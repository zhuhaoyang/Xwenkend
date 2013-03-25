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
<UIScrollViewDelegate,UIGestureRecognizerDelegate> {
	UIScrollView *m_ScrollView;
    UIScrollView *thumbnailScrollView;
	PagePhotosView *pagePhotosView;
	NSArray *arrData;
    NSInteger page;
	BOOL isThumbnailShow;
    NSInteger nowColumn;
    NSInteger kNumberOfColumns;
    NSMutableArray *arrTag;
}

//@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic ,assign) id m_delegate;
- (id)initWithFrame:(CGRect)frame withDic:(NSDictionary *)dicData delegate:(id)delegate numOfIssue:(NSInteger)numOfIssue;
- (void)loadColumn:(NSInteger)m_column;
- (void)removeColums:(NSNumber *)column;
@end
@protocol ColumnsDelegate<NSObject>
- (void)Hidden;
- (void)turnToPage:(NSInteger)column;
@end
