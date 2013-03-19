//
//  PagePhotosView.h
//  PagePhotosDemo
//
//  Created by junmin liu on 10-8-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
//#import "MCImageViewWithPreview.h"



@interface PagePhotosView : UIView
<UIScrollViewDelegate> {
	UIScrollView *m_scrollView;
//	NSMutableArray *imageViews;
    NSDictionary *dicData;
    NSArray *arrData;
//    UIImageView *bigImage;
    int kNumberOfPages;
    int page;
}

//@property (nonatomic, strong) NSMutableArray *imageViews;
- (id)initWithFrame:(CGRect)frame withDic:(NSDictionary *)dic;
- (void)loadImage:(NSDictionary *)dic;
//- (void)move:(NSInteger)m_page;
//- (void)loadBigImage:(int)page;
@end

