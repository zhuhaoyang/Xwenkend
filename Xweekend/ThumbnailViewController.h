//
//  ThumbnailViewController.h
//  Xweekend
//
//  Created by Myth on 13-3-6.
//  Copyright (c) 2013年 Myth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btThumbnai.h"
#import "Publisher.h"

@interface ThumbnailViewController : UIViewController
<UIScrollViewDelegate>{
    UIScrollView *m_ScrollView;
    NSArray *arrThumbnailInfo;
    NSInteger max;
    NSMutableArray *arrTag;
    NSInteger numOfIssue;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil numOfIssue:(NSInteger)num;
@end
