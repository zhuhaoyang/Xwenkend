//
//  ColumnsView.m
//  PDFtest
//
//  Created by Myth on 13-2-4.
//  Copyright (c) 2013年 Myth. All rights reserved.
//

#import "ColumnsView.h"


@interface ColumnsView (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation ColumnsView
@synthesize m_delegate = _m_delegate;

- (id)initWithFrame:(CGRect)frame withDic:(NSDictionary *)dicData delegate:(id)delegate numOfIssue:(NSInteger)numOfIssue
{
    if ((self = [super initWithFrame:frame])) {
        
        
        
        
        self.m_delegate = delegate;
        // Initialization UIScrollView
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(move:) name:@"moveTo" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidden:) name:@"hidden" object:nil];
        page = 1;
		m_ScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:m_ScrollView];
        
		arrData = [[NSArray alloc]initWithArray:[dicData objectForKey:@"contentInfo"]];
        kNumberOfColumns = [arrData count];
        arrTag = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSInteger x = 0; x<kNumberOfColumns; x++) {
            [arrTag addObject:[NSNumber numberWithBool:NO]];
        }
//        self.imageViews = [[NSMutableArray alloc]initWithCapacity:0];
        
		// in the meantime, load the array with placeholders which will be replaced on demand
        //
		// a page is the width of the scroll view
		m_ScrollView.pagingEnabled = YES;
		m_ScrollView.contentSize = CGSizeMake(m_ScrollView.frame.size.width * kNumberOfColumns, m_ScrollView.frame.size.height);
		m_ScrollView.showsHorizontalScrollIndicator = NO;
		m_ScrollView.showsVerticalScrollIndicator = NO;
		m_ScrollView.scrollsToTop = NO;
		m_ScrollView.delegate = self;
		m_ScrollView.minimumZoomScale = .25;
        m_ScrollView.maximumZoomScale = 20;
        m_ScrollView.userInteractionEnabled = YES;
        m_ScrollView.canCancelContentTouches = YES;

        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        [singleTap setNumberOfTapsRequired:1];
        [m_ScrollView addGestureRecognizer:singleTap];
        singleTap.cancelsTouchesInView = NO;
        singleTap.delegate = self;

        [singleTap release];
		// pages are created on demand
		// load the visible page
		// load the page on either side to avoid flashes when the user starts scrolling
        thumbnailScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 1024, 768, 256)];
		thumbnailScrollView.contentSize = CGSizeMake(192 * kNumberOfColumns, thumbnailScrollView.frame.size.height);
        thumbnailScrollView.showsHorizontalScrollIndicator = NO;
        thumbnailScrollView.showsVerticalScrollIndicator = NO;
        thumbnailScrollView.scrollsToTop = NO;
        thumbnailScrollView.delegate = self;
        thumbnailScrollView.minimumZoomScale = .25;
        thumbnailScrollView.maximumZoomScale = 20;
        thumbnailScrollView.backgroundColor = [UIColor blackColor];
        [self addSubview:thumbnailScrollView];
        isThumbnailShow = NO;
        
        
		for (NSInteger i = 0; i < kNumberOfColumns; i++) {
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[arrData objectAtIndex:i]];
            pagePhotosView = nil;
            pagePhotosView = [[PagePhotosView alloc]initWithFrame:self.bounds withDic:dic numOfIssue:numOfIssue];
            [dic release];
            CGRect frame = m_ScrollView.frame;
            frame.origin.x = frame.size.width * i;
            frame.origin.y = 0;
            pagePhotosView.frame = frame;
            pagePhotosView.tag = i+1;
            [m_ScrollView addSubview:pagePhotosView];
            
//            [pagePhotosView loadImage:[arrData objectAtIndex:i]];
            [pagePhotosView release];
            
            UIButton *bt = [UIButton buttonWithType:UIButtonTypeCustom];
//            [bt setBackgroundImage:[UIImage imageNamed:[[arrData objectAtIndex:i] objectAtIndex:0]] forState:UIControlStateNormal];
            bt.frame = CGRectMake(i*192, 0, 192, 256);
            [bt addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
            
//                NSString *str = [NSString stringWithFormat:@"COVER%@",[[arrData objectAtIndex:i] objectForKey:@"title"]];
            //    UIImage *image = [UIImage imageNamed:str];
            
//                NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"jpg"];
//                UIImage *image = [UIImage imageWithContentsOfFile:path];

        
            Publisher *publisher = [Publisher sharedPublisher];
            NKLibrary *nkLib = [NKLibrary sharedLibrary];
            NKIssue *nkIssue = [nkLib issueWithName:[publisher nameOfIssueAtIndex:numOfIssue]];
            
            NSString *str = [NSString stringWithFormat:@"COVER%@.jpg",[[arrData objectAtIndex:i] objectForKey:@"title"]];
            //    NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"jpg"];
            NSString *path = [[nkIssue.contentURL path] stringByAppendingPathComponent:str];
            UIImage *image = [UIImage imageWithContentsOfFile:path];

        
        
            [bt setBackgroundImage:image forState:UIControlStateNormal];
            [thumbnailScrollView addSubview:bt];

		}
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:1],@"column", [NSNumber numberWithInteger:1],@"page",nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"move" object:nil userInfo:dic];
        [dic release];
        
        
		
    }
    return self;

}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 过滤掉UIButton，也可以是其他类型
    if ( [touch.view isKindOfClass:[UIButton class]])
    {
        return NO;
    }
    
    return YES;
}

- (void)hidden:(NSNotification *)notification
{
    if (isThumbnailShow) {
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        [UIView beginAnimations:nil context:context];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        
        thumbnailScrollView.frame = CGRectMake(0, 1024, 768, 256);
        isThumbnailShow = NO;
        
        [UIView setAnimationDelegate:self];
        [UIView commitAnimations];
        
        
        [self.m_delegate Hidden:YES];
    }

}

- (void)move:(NSNotification *)notification
{
    nowColumn = page;
    NSDictionary *dic = notification.userInfo;
//    NSLog(@"%@",dic);
    NSInteger column = [[dic objectForKey:@"column"] integerValue];
    NSInteger m_page = [[dic objectForKey:@"page"] integerValue];
    [self removeColums:[NSNumber numberWithInteger:column]];
    [self.m_delegate turnToPage:column];
    CGPoint point = CGPointMake(192*(column-1), 0);
    if (point.x >= (thumbnailScrollView.contentSize.width - 192*4)) {
        point = CGPointMake(thumbnailScrollView.contentSize.width - 192*4, 0);
    }
    //        klp.alpha = 0;
    //        klp.frame = CGRectMake(192*(page + 1), 0, 192, 256);
    //        [UIView animateWithDuration:0.2 animations:^(void){
    //            klp.alpha = 0.85;
    //        }];
    //        [thumbnailScrollView setContentOffset:CGPointMake(192*page, 0) animated:YES];
    [thumbnailScrollView setContentOffset:point animated:NO];
    

    
    
    [m_ScrollView setContentOffset:CGPointMake(768*(column- 1), 0) animated:NO];
    
    NSDictionary *dicUserInfo = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:m_page],@"page",[NSNumber numberWithInteger:column],@"column", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"move" object:nil userInfo:dicUserInfo];
    [dicUserInfo release];
//    PagePhotosView *view = (PagePhotosView *)[m_ScrollView viewWithTag:column];
//    [view move:m_page];
//    [self.m_delegate Hidden];
    thumbnailScrollView.frame = CGRectMake(0, 1024, 768, 256);
    isThumbnailShow = NO;
    page = column;
}

- (void)click:(id)sender
{
    nowColumn = page;
    UIButton *bt = sender;
    [m_ScrollView setContentOffset:CGPointMake(bt.frame.origin.x*4, 0) animated:YES];
    CGPoint point = CGPointMake(bt.frame.origin.x, 0);
    page = point.x/192 + 1;
    [self.m_delegate turnToPage:page];
    if (point.x >= (thumbnailScrollView.contentSize.width - 192*4)) {
        point = CGPointMake(thumbnailScrollView.contentSize.width - 192*4, 0);
    }
//    klp.alpha = 0;
//    klp.frame = CGRectMake(bt.frame.origin.x-3, 0, 192, 256);
//    [UIView animateWithDuration:0.2 animations:^(void){
//        klp.alpha = 0.85;
//    }];
    [thumbnailScrollView setContentOffset:point animated:YES];
    NSDictionary *dicUserInfo = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:100],@"page",[NSNumber numberWithInteger:page],@"column", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"move" object:nil userInfo:dicUserInfo];
    [dicUserInfo release];
    [self performSelector:@selector(removeColums:) withObject:[NSNumber numberWithInteger:page] afterDelay:0.1f];
//    [self removeColums:page];


}





- (void)loadColumn:(NSInteger)m_column
{

}

- (void)removeColums:(NSNumber *)column
{
    NSInteger m_column= [column integerValue];
    if (nowColumn != m_column && nowColumn != (m_column-1) && nowColumn != (m_column+1)) {
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:nowColumn], @"column", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"removePage" object:nil userInfo:dic];
        [dic release];
    }
    if ((nowColumn-1) != m_column && (nowColumn-1) != (m_column-1) && (nowColumn-1) != (m_column+1)) {
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:nowColumn-1], @"column", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"removePage" object:nil userInfo:dic];
        [dic release];
    }
    if ((nowColumn+1) != m_column && (nowColumn+1) != (m_column-1) && (nowColumn+1) != (m_column+1)) {
        NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:nowColumn+1], @"column", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"removePage" object:nil userInfo:dic];
        [dic release];
    }

}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (scrollView == m_ScrollView) {
//        CGFloat pageWidth = scrollView.frame.size.width;
//		int index = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth);
//		page = index;
//        NSLog(@"%i",page);
//    }
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
  
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    

    if (scrollView == m_ScrollView) {
        nowColumn = page;
                CGFloat pageWidth = scrollView.frame.size.width;
        NSInteger index = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth);
        page = index + 2;
//        NSLog(@"%i",page);
        [self removeColums:[NSNumber numberWithInteger:page]];
        [self.m_delegate turnToPage:page];
        
        CGPoint point = CGPointMake(192*(page-1), 0);
        if (point.x >= (thumbnailScrollView.contentSize.width - 192*4)) {
            point = CGPointMake(thumbnailScrollView.contentSize.width - 192*4, 0);
        }
//        klp.alpha = 0;
//        klp.frame = CGRectMake(192*(page + 1), 0, 192, 256);
//        [UIView animateWithDuration:0.2 animations:^(void){
//            klp.alpha = 0.85;
//        }];
//        [thumbnailScrollView setContentOffset:CGPointMake(192*page, 0) animated:YES];
        if (isThumbnailShow) {
            
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIView beginAnimations:nil context:context];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationDuration:0.3];
            
            thumbnailScrollView.frame = CGRectMake(0, 1024, 768, 256);
            isThumbnailShow = NO;
            
            [UIView setAnimationDelegate:self];
            [UIView commitAnimations];

            
            [self.m_delegate Hidden:YES];
        }
        [thumbnailScrollView setContentOffset:point animated:NO];
        NSDictionary *dicUserInfo = [[NSDictionary alloc]initWithObjectsAndKeys:[NSNumber numberWithInteger:100],@"page",[NSNumber numberWithInteger:page],@"column", nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"move" object:nil userInfo:dicUserInfo];
        [dicUserInfo release];


    }
}


- (void) handleSingleTap:(UITapGestureRecognizer *) gestureRecognizer
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [self.m_delegate Hidden:isThumbnailShow];

    if (isThumbnailShow) {
        thumbnailScrollView.frame = CGRectMake(0, 1024, 768, 256);
        isThumbnailShow = NO;
    }else{
        thumbnailScrollView.frame = CGRectMake(0, 1024-256, 768, 256);
        isThumbnailShow = YES;
    }
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];

        
}


- (void)dealloc
{
//    NSArray *arr = [m_ScrollView subviews];
//    for (id obj in arr) {
//        [obj removeFromSuperview];
//    }
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"moveTo" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hidden" object:nil];
    [m_ScrollView release];
    m_ScrollView = nil;
    [thumbnailScrollView release];
    thumbnailScrollView = nil;
    [arrData release];
	arrData = nil;
    [super dealloc];

}

@end
