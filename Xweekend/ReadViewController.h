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

@interface ReadViewController : UIViewController
<ColumnsDelegate,UITextViewDelegate,
SinaWeiboDelegate,SinaWeiboRequestDelegate,
UITableViewDataSource,UITableViewDelegate>{
    BOOL isflage;
    ColumnsView *m_ColumnsView;
    NSArray *arrIssuesPlist;
    ThumbnailViewController *thumbnailView;
    BOOL isShow;
    MBProgressHUD *m_hud;
    UITableView *m_tableView;
    UIView *backGround;
    UITextView *textView;
}

@end
