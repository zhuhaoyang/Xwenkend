//
//  PagePhotosView.h
//  PagePhotosDemo
//
//  Created by junmin liu on 10-8-23.
//  Copyright 2010 Openlab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "btVisitWeibo.h"
#import "Publisher.h"

//#import "MCImageViewWithPreview.h"



@interface PagePhotosView : UIView
<UIScrollViewDelegate,UIGestureRecognizerDelegate> {
	UIScrollView *m_scrollView;
//	NSMutableArray *imageViews;
    NSDictionary *dicData;
    NSArray *arrData;
//    UIImageView *bigImage;
    NSInteger kNumberOfPages;
    NSInteger page;
    NSInteger nowPage;
    NSMutableArray *arrTag;
    NSDictionary *dicWeiboURL;
    NSDictionary *dicCopyrightPage;
    NSInteger numOfIssue;
}

//@property (nonatomic, strong) NSMutableArray *imageViews;
- (id)initWithFrame:(CGRect)frame withDic:(NSDictionary *)dic numOfIssue:(NSInteger)num;
- (void)loadImage:(NSInteger)m_page;
- (void)removeImage:(NSInteger)m_page;
//- (void)move:(NSInteger)m_page;
//- (void)loadBigImage:(int)page;
@end

