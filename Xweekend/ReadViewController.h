//
//  ReadViewController.h
//  Xweekend
//
//  Created by Myth on 13-2-28.
//  Copyright (c) 2013年 Myth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColumnsView.h"
#import "ThumbnailViewController.h"
#import "MBProgressHUD.h"
#import "TSPopoverController.h"
#import "TSActionSheet.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "AppDelegate.h"
#import <NewsstandKit/NewsstandKit.h>

@interface ReadViewController : UIViewController
<ColumnsDelegate,UITextViewDelegate,
SinaWeiboDelegate,SinaWeiboRequestDelegate,
UITableViewDataSource,UITableViewDelegate>{
    BOOL isflage;
    ColumnsView *m_ColumnsView;
    NSArray *arrIssuesPlist;
    NSDictionary *dicIssueInfo;
    ThumbnailViewController *thumbnailView;
    BOOL isShow;
    MBProgressHUD *m_hud;
//    UITableView *m_tableView;
    UIView *backGround;
    UIView *shareView;
    UITextView *textView;
    NSInteger m_Column;
    NSInteger m_NumOfIssue;
//    NSInteger fun;
}
//@property (nonatomic,assign) NSInteger 
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil dic:(NSDictionary *)dic numOfIssues:(NSString *)numOfIssues;
@end
