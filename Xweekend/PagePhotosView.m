//
//  PagePhotosView.m
//  PagePhotosDemo
//
//  Created by junmin liu on 10-8-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import "PagePhotosView.h"
//#import "HomeViewController.h"
#import "ViewController.h"

@interface PagePhotosView (PrivateMethods)

- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end

@implementation PagePhotosView
- (void)removeImage:(NSInteger)m_page
{
    if (m_page < 1 || m_page > kNumberOfPages || m_page == page || m_page == (page+1) || m_page == (page-1) ) {
        return;
    }
    UIImageView *imageView = (UIImageView *)[m_scrollView viewWithTag:m_page];
    [imageView removeFromSuperview];
    [arrTag replaceObjectAtIndex:(m_page-1) withObject:[NSNumber numberWithBool:NO]];
}
- (void)loadImage:(NSInteger)m_page
{
    if (m_page < 1 || m_page > kNumberOfPages) {
        return;
    }
    if ([[arrTag objectAtIndex:(m_page - 1)] boolValue]) {
        return;
    }
//    NSString *str = @"999";
    
    Publisher *publisher = [Publisher sharedPublisher];
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
    NKIssue *nkIssue = [nkLib issueWithName:[publisher nameOfIssueAtIndex:numOfIssue]];

    NSString *str = [NSString stringWithFormat:@"%@%i.jpg",[dicData objectForKey:@"title"],m_page];
    NSString *strTag = [NSString stringWithFormat:@"%@%i",[dicData objectForKey:@"title"],m_page];
//    NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"jpg"];
    NSString *path = [[nkIssue.contentURL path] stringByAppendingPathComponent:str];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
//    [image drawInRect:m_scrollView.frame];
    UIImageView *bigImage = [[UIImageView alloc]initWithImage:image];
    bigImage.opaque = YES;
//    NSLog(@"%@",bigImage);
    CGRect frame = m_scrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = frame.size.height * (m_page-1);
    bigImage.frame = frame;
    bigImage.tag = m_page;
    [m_scrollView addSubview:bigImage];
    [bigImage release];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidden" object:nil];
    [arrTag replaceObjectAtIndex:(m_page - 1) withObject:[NSNumber numberWithBool:YES]];
    if ([dicCopyrightPage objectForKey:strTag] != nil) {
        btVisitWeibo *m_btVisitWeibo = [btVisitWeibo buttonWithType:UIButtonTypeCustom];
        m_btVisitWeibo.frame = CGRectMake(160, frame.size.height * (m_page-1)+797, 92, 36);
        [m_btVisitWeibo addTarget:self action:@selector(visitWeibo:) forControlEvents:UIControlEventTouchUpInside];
//        m_btVisitWeibo.backgroundColor = [UIColor blackColor];
        m_btVisitWeibo.url = [dicCopyrightPage objectForKey:strTag];
        [m_scrollView addSubview:m_btVisitWeibo];
    }
    if ([dicWeiboURL objectForKey:strTag] != nil) {
        btVisitWeibo *m_btVisitWeibo = [btVisitWeibo buttonWithType:UIButtonTypeCustom];
        m_btVisitWeibo.frame = CGRectMake(20, frame.size.height * (m_page-1)+281, 144, 44);
        [m_btVisitWeibo addTarget:self action:@selector(visitWeibo:) forControlEvents:UIControlEventTouchUpInside];
        m_btVisitWeibo.url = [dicWeiboURL objectForKey:strTag];
//        //    NSLog(@"%@",m_btVisitWeibo.url);
        [m_scrollView addSubview:m_btVisitWeibo];
    }
}

- (void)visitWeibo:(id)sender
{

    btVisitWeibo *bt = sender;
    [MobClick event:@"visitWeibo" label:[NSString stringWithFormat:@"%@",bt.url]];
//    //    NSLog(@"%@",bt.url);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:bt.url]];
}

- (id)initWithFrame:(CGRect)frame withDic:(NSDictionary *)dic numOfIssue:(NSInteger)num
{
    if ((self = [super initWithFrame:frame])) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(move:) name:@"move" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(remove:) name:@"removePage" object:nil];
        self.opaque = YES;
        numOfIssue = num;
        page = 1;
        dicData = [[NSDictionary alloc]initWithDictionary:dic];

		m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
		[self addSubview:m_scrollView];
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"issues" ofType:@"plist"];
//        NSArray *arr = [[NSArray alloc]initWithContentsOfFile:path];
//        NSDictionary *dicIssueInfo = [arr objectAtIndex:numOfIssue];
//        //    NSLog(@"%@",dicIssueInfo);
//        //    NSLog(@"%@",[dicIssueInfo objectForKey:@"weiboURL"]);
        NSDictionary *dicIssueInfo = [[NSDictionary alloc]initWithDictionary:[[Publisher sharedPublisher] issueAtIndex:numOfIssue]];
		dicWeiboURL = [[NSDictionary alloc]initWithDictionary:[dicIssueInfo objectForKey:@"weiboURL"]];
        dicCopyrightPage = [[NSDictionary alloc]initWithDictionary:[dicIssueInfo objectForKey:@"copyrightPageURL"]];
        [dicIssueInfo release];
        kNumberOfPages = [[dic objectForKey:@"numOfPaages"] integerValue];
        arrTag = [[NSMutableArray alloc]initWithCapacity:0];
        for (NSInteger x = 0; x < kNumberOfPages; x++) {
            [arrTag addObject:[NSNumber numberWithBool:NO]];
        }
//        self.imageViews = [[NSMutableArray alloc]initWithCapacity:0];
        
		// in the meantime, load the array with placeholders which will be replaced on demand
        //
		// a page is the width of the scroll view
		m_scrollView.pagingEnabled = YES;
		m_scrollView.contentSize = CGSizeMake(m_scrollView.frame.size.width, m_scrollView.frame.size.height * kNumberOfPages);
		m_scrollView.showsHorizontalScrollIndicator = NO;
		m_scrollView.showsVerticalScrollIndicator = NO;
		m_scrollView.scrollsToTop = NO;
		m_scrollView.delegate = self;
		m_scrollView.minimumZoomScale = .25;
        m_scrollView.maximumZoomScale = 20;
        m_scrollView.canCancelContentTouches = YES;
        m_scrollView.userInteractionEnabled = YES;
        m_scrollView.alwaysBounceVertical = YES;

		for (NSInteger i = 1; i <= kNumberOfPages; i++) {
            
            
            
           
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            Publisher *publisher = [Publisher sharedPublisher];
                            NKLibrary *nkLib = [NKLibrary sharedLibrary];
                            NKIssue *nkIssue = [nkLib issueWithName:[publisher nameOfIssueAtIndex:numOfIssue]];
                            
                            NSString *str = [NSString stringWithFormat:@"%@%iS.jpg",[dicData objectForKey:@"title"],i];
                            //    NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"jpg"];
                            NSString *path = [[nkIssue.contentURL path] stringByAppendingPathComponent:str];
                            UIImage *image1 = [UIImage imageWithContentsOfFile:path];

                            
                            UIImageView *image = [[UIImageView alloc]initWithImage:image1];
                            CGRect frame = m_scrollView.frame;
                            frame.origin.x = 0;
                            frame.origin.y = frame.size.height * (i-1);
                            image.frame = frame;
                            [m_scrollView addSubview:image];
                            [m_scrollView sendSubviewToBack:image];
                            [image release];
                    });
                });
		}
        
        
//        NSString *str = [NSString stringWithFormat:@"%@1",[dicData objectForKey:@"title"]];
//        NSString *str = @"C5";
//        NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"jpg"];
//        UIImage *image = [UIImage imageWithContentsOfFile:path];
//        
//       UIImageView *bigImage = [[UIImageView alloc]initWithImage:image];
//
//        image = nil;
//        CGRect frame = m_scrollView.frame;
//        frame.origin.x = 0;
//        frame.origin.y = 0;
//        bigImage.frame = frame;
//        bigImage.tag = 1;
//        [m_scrollView addSubview:bigImage];
//        [bigImage release];

//        [self loadImage:1];
//        [self loadImage:2];
    }
    return self;

}
- (void)remove:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    NSInteger m_tag = [[dic objectForKey:@"column"] integerValue];
    if (self.tag == m_tag) {
//        //    NSLog(@"remove column %i",self.tag);
        for (NSInteger i = 0; i < kNumberOfPages; i++) {
            if ([[arrTag objectAtIndex:i] boolValue]) {
                UIImageView *imageView = (UIImageView *)[m_scrollView viewWithTag:(i+1)];
                [imageView removeFromSuperview];
                [arrTag replaceObjectAtIndex:i withObject:[NSNumber numberWithBool:NO]];
            }
        }
    }
}
- (void)move:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    NSInteger m_tag = [[dic objectForKey:@"column"] integerValue];
//     && [[dic objectForKey:@"page"] integerValue] != 100
    if ((self.tag == (m_tag-1) || self.tag == (m_tag+1))) {
//        [self loadImage:page-1];
        [self loadImage:page];
//        [Publisher sharedPublisher].numOfPage = page;
    //    NSLog(@"PAGE = %i",page);
//        [self loadImage:page+1];
        //    NSLog(@"column = %i ,page = %@",self.tag,arrTag);
    }
    if (self.tag == m_tag) {
        nowPage = page;
//        [m_scrollView setContentOffset:CGPointMake(0, m_scrollView.frame.size.height*(page - 1)) animated:YES];

        if ([[dic objectForKey:@"page"] integerValue] != 100) {
            page = [[dic objectForKey:@"page"] integerValue];

            [self removeImage:nowPage-1];
            [self removeImage:nowPage];
            [self removeImage:nowPage+1];
            
            [self loadImage:page-1];
            [self loadImage:page];
            [self loadImage:page+1];
            [Publisher sharedPublisher].numOfPage = page;
    //    NSLog(@"PAGE = %i",page);
//            //    NSLog(@"column = %i ,page = %@",self.tag,arrTag);

        }else{
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self removeImage:nowPage-1];
                    [self removeImage:nowPage];
                    [self removeImage:nowPage+1];
                    
                    [self loadImage:page-1];
                    [self loadImage:page];
                    [self loadImage:page+1];
                    [Publisher sharedPublisher].numOfPage = page;
    //    NSLog(@"PAGE = %i",page);
//                    //    NSLog(@"column = %i ,page = %@",self.tag,arrTag);

                });
            });


        }
        [m_scrollView setContentOffset:CGPointMake(0, m_scrollView.frame.size.height*(page - 1)) animated:YES];


//        nowPage = page;
//        if ([[dic objectForKey:@"page"] integerValue] == 100) {
//            [m_scrollView setContentOffset:CGPointMake(0, m_scrollView.frame.size.height*(page - 1)) animated:YES];
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [self loadImage:page-1];
//                    [self loadImage:page];
//                    [self loadImage:page+1];
//                });
//            });
//        }else{
//            page = [[dic objectForKey:@"page"] integerValue];
//            [self removeImage:nowPage-1];
//            [self removeImage:nowPage];
//            [self removeImage:nowPage+1];
//            
//            [self loadImage:page-1];
//            [self loadImage:page];
//            [self loadImage:page+1];
//            [m_scrollView setContentOffset:CGPointMake(0, m_scrollView.frame.size.height*(page - 1)) animated:YES];
//        }

        
//        CGFloat pageHeight = m_scrollView.frame.size.height;
//        page = floor((m_scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 2;
        
       
    }
    

    
    

}


- (void)scrollViewDidScroll:(UIScrollView *)sender {
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}



// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{

    nowPage = page;
    CGFloat pageHeight = scrollView.frame.size.height;
    page = floor((scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 2;

    [self removeImage:nowPage-1];
    [self removeImage:nowPage];
    [self removeImage:nowPage+1];
        
    [self loadImage:page-1];
    [self loadImage:page];
    [self loadImage:page+1];
    [Publisher sharedPublisher].numOfPage = page;
    //    NSLog(@"PAGE = %i",page);
//    //    NSLog(@"arrTag = %@",arrTag);
    
}


- (void)dealloc
{
   
//    NSArray *arr = [m_scrollView subviews];
//    for (id obj in arr) {
//        [obj removeFromSuperview];
//    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"move" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"removePage" object:nil];

    [m_scrollView release];
    m_scrollView = nil;
    [dicData release];
    dicData = nil;
//    [arrData release];
//    arrData = nil;
    [arrTag release];
    arrTag = nil;
    [dicCopyrightPage release];
    dicCopyrightPage = nil;
    [dicWeiboURL release];
    dicWeiboURL = nil;
    [super dealloc];


}

@end
