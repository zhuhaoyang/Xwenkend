//
//  ColumnsView.h
//  PDFtest
//
//  Created by Myth on 13-2-4.
//  Copyright (c) 2013年 Myth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PagePhotosView.h"
@protocol ColumnsDelegate;

@interface ColumnsView : UIView
<UIScrollViewDelegate> {
	UIScrollView *m_ScrollView;
    UIScrollView *thumbnailScrollView;
	PagePhotosView *pagePhotosView;
	NSArray *arrData;
    int page;
	BOOL isThumbnailShow;
    
}

//@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic ,assign) id m_delegate;
- (id)initWithFrame:(CGRect)frame withDic:(NSDictionary *)dicData delegate:(id)delegate;
- (void)loadBigImage:(int)page;
@end
@protocol ColumnsDelegate<NSObject>
-(void)Hidden;
@end
