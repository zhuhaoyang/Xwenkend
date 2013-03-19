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

- (void)loadImage:(NSDictionary *)dic
{
//    dicData = [[NSDictionary alloc]initWithDictionary:dic];
//    
//    // Initialization UIScrollView
//    
//       
//    for (int i = 1; i <= kNumberOfPages; i++) {
//        
//        
//        
//        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            dispatch_async(dispatch_get_main_queue(), ^{
//                NSString *str = [NSString stringWithFormat:@"%@%iS",[dicData objectForKey:@"title"],i];
//                NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"jpg"];
//                UIImage *image1 = [UIImage imageWithContentsOfFile:path];
//                UIImageView *image = [[UIImageView alloc]initWithImage:image1];
//                CGRect frame = m_scrollView.frame;
//                frame.origin.x = 0;
//                frame.origin.y = frame.size.height * (i-1);
//                image.frame = frame;
//                [m_scrollView addSubview:image];
//                [image release];
//            });
//        });
//        
//        
//        //            NSString *str = [NSString stringWithFormat:@"%@%iS",[dicData objectForKey:@"title"],i];
//        //            NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"jpg"];
//        //            UIImage *image1 = [UIImage imageWithContentsOfFile:path];
//        //            UIImageView *image = [[UIImageView alloc]initWithImage:image1];
//        //            CGRect frame = m_scrollView.frame;
//        //            frame.origin.x = 0;
//        //            frame.origin.y = frame.size.height * (i-1);
//        //            image.frame = frame;
//        //            [m_scrollView addSubview:image];
//        //            [image release];
//    }
//    
//    
//    //		[self loadScrollViewWithPage:1];
//    NSString *str = [NSString stringWithFormat:@"%@1",[dicData objectForKey:@"title"]];
//    //    UIImage *image = [UIImage imageNamed:str];
//    
//    //    UIImage *image = [[UIImage alloc]initWithContentsOfFile:path];
//    //    UIImageView *bigImage = [[UIImageView alloc]initWithImage:image];
//    //        bigImage = [[UIImageView alloc]init];
//    NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"jpg"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
//    
//    UIImageView *bigImage = [[UIImageView alloc]initWithImage:image];
//    //        NSLog(@"%i",bigImage.retainCount);
//    
//    //    [image release];
//    image = nil;
//    CGRect frame = m_scrollView.frame;
//    frame.origin.x = 0;
//    frame.origin.y = 0;
//    bigImage.frame = frame;
//    bigImage.tag = 1;
//    [m_scrollView addSubview:bigImage];
//    //        NSLog(@"%i",bigImage.retainCount);
//    
//    //    [image release];
//    //        bigImage.image = nil;
//    [bigImage release];
//    //        NSLog(@"%i",bigImage.retainCount);
//    
//    //    bigImage = nil;
//    
//    
//    
//    
//    //        MCImageViewWithPreview * imageView = [[MCImageViewWithPreview alloc] initWithFrame:m_scrollView.frame];
//    //        imageView.previewImageName = [NSString stringWithFormat:@"%@1S.jpg",[dicData objectForKey:@"title"]];
//    //        imageView.imageName = [NSString stringWithFormat:@"%@1.jpg",[dicData objectForKey:@"title"]];
//    //        imageView.tag = 1;
//    //        [m_scrollView addSubview:imageView];
//    //        [imageView release];
//
//
}

- (id)initWithFrame:(CGRect)frame withDic:(NSDictionary *)dic
{
    if ((self = [super initWithFrame:frame])) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(move:) name:@"move" object:nil];
        page = 1;
        dicData = [[NSDictionary alloc]initWithDictionary:dic];

		m_scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        
		[self addSubview:m_scrollView];
		
        kNumberOfPages = [[dic objectForKey:@"numOfPaages"] intValue];
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

		for (int i = 1; i <= kNumberOfPages; i++) {
            
            
            
           
                dispatch_async(dispatch_get_global_queue(0, 0), ^{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSString *str = [NSString stringWithFormat:@"%@%iS",[dicData objectForKey:@"title"],i];
                            NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"jpg"];
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
        
        
        NSString *str = [NSString stringWithFormat:@"%@1",[dicData objectForKey:@"title"]];
        NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        
       UIImageView *bigImage = [[UIImageView alloc]initWithImage:image];

        image = nil;
        CGRect frame = m_scrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        bigImage.frame = frame;
        bigImage.tag = 1;
        [m_scrollView addSubview:bigImage];
        [bigImage release];
    }
    return self;

}

- (void)move:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    NSInteger m_tag = [[dic objectForKey:@"tag"] integerValue];
    if (self.tag == m_tag) {
        NSInteger m_page = [[dic objectForKey:@"page"] integerValue];
        UIImageView *view =(UIImageView*)[m_scrollView viewWithTag:page];
        [view removeFromSuperview];
        CGFloat pageHeight = m_scrollView.frame.size.height;
        
        [m_scrollView setContentOffset:CGPointMake(0, m_scrollView.frame.size.height*(m_page - 1)) animated:NO];
        
        
        page = floor((m_scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 2;
        
        NSString *str = [NSString stringWithFormat:@"%@%i",[dicData objectForKey:@"title"],page];
        //    UIImage *image = [UIImage imageNamed:str];
        
        //    UIImage *image = [[UIImage alloc]initWithContentsOfFile:path];
        //    UIImageView *bigImage = [[UIImageView alloc]initWithImage:image];
        //    bigImage = [[UIImageView alloc]init];
        NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        UIImageView *bigImage = [[UIImageView alloc]initWithImage:image];
        //    [image release];
        image = nil;
        CGRect frame = m_scrollView.frame;
        frame.origin.x = 0;
        frame.origin.y = frame.size.height * (page-1);
        bigImage.frame = frame;
        bigImage.tag = page;
        [m_scrollView addSubview:bigImage];
        //    [image release];
        //    bigImage.image = nil;
        [bigImage release];

    }
    

    
    

}


//- (void)loadScrollViewWithPage:(int)m_page {
//
//    NSString *str = [NSString stringWithFormat:@"%@%i",[dicData objectForKey:@"title"],m_page];
////    UIImage *image = [UIImage imageNamed:str];
//    
//    //    UIImage *image = [[UIImage alloc]initWithContentsOfFile:path];
////    UIImageView *bigImage = [[UIImageView alloc]initWithImage:image];
////    bigImage = [[UIImageView alloc]init];
//    NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"jpg"];
//    UIImage *image = [UIImage imageWithContentsOfFile:path];
//    bigImage = [[[UIImageView alloc]initWithImage:image] retain];
////    bigImage.image = image;
////    [image release];
////    image = nil;
//    CGRect frame = m_scrollView.frame;
//    frame.origin.x = 0;
//    frame.origin.y = frame.size.height * (m_page-1);
//    bigImage.frame = frame;
//    bigImage.tag = m_page;
//    [m_scrollView addSubview:bigImage];
////    [image release];
//    [bigImage release];
////    bigImage = nil;
//
//}
//
- (void)scrollViewDidScroll:(UIScrollView *)sender {
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}



// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    UIImageView *view =(UIImageView*)[scrollView viewWithTag:page];
//    NSLog(@"%i",view.retainCount);
    [view removeFromSuperview];
//        NSLog(@"%i",view.retainCount);
//    [view release];
//    NSLog(@"%i",view.retainCount);

//    view.image = nil;

//    if (bigImage) {
////        bigImage.image = nil;
//        [bigImage removeFromSuperview];
////        [bigImage release];
////        bigImage = nil;
//    }
//    [view release];

    

//    CGRect frame = m_scrollView.frame;
//    frame.origin.x = 0;
//    frame.origin.y = frame.size.height * (page-1);
//
//    MCImageViewWithPreview * imageView = [[MCImageViewWithPreview alloc] initWithFrame:frame];
//    imageView.previewImageName = [NSString stringWithFormat:@"%@%iS.jpg",[dicData objectForKey:@"title"],page];
//    imageView.imageName = [NSString stringWithFormat:@"%@%i.jpg",[dicData objectForKey:@"title"],page];
//    imageView.tag = page;
//    [m_scrollView addSubview:imageView];
//    [imageView release];
    CGFloat pageHeight = scrollView.frame.size.height;
    page = floor((scrollView.contentOffset.y - pageHeight / 2) / pageHeight) + 2;
    NSString *str = [NSString stringWithFormat:@"%@%i",[dicData objectForKey:@"title"],page];
    NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"jpg"];
    UIImage *image = [UIImage imageWithContentsOfFile:path];
   UIImageView *bigImage = [[UIImageView alloc]initWithImage:image];
    //    [image release];
    image = nil;
    CGRect frame = m_scrollView.frame;
    frame.origin.x = 0;
    frame.origin.y = frame.size.height * (page-1);
    bigImage.frame = frame;
    bigImage.tag = page;
    [m_scrollView addSubview:bigImage];
    //    [image release];
//    bigImage.image = nil;
    [bigImage release];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hidden" object:nil];
//    [self loadScrollViewWithPage:page];
    
}


- (void)dealloc
{
   
//    NSArray *arr = [m_scrollView subviews];
//    for (id obj in arr) {
//        [obj removeFromSuperview];
//    }
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"move" object:nil];
    [m_scrollView release];
    m_scrollView = nil;
    [dicData release];
    dicData = nil;
    [arrData release];
    arrData = nil;
//    [bigImage release];
//    bigImage = nil;
    [super dealloc];


}

@end
