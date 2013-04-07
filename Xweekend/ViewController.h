//
//  ViewController.h
//  Xweekend
//
//  Created by Myth on 13-2-28.
//  Copyright (c) 2013年 Myth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadViewController.h"
#import "MBProgressHUD.h"
#import "Publisher.h"
#import <NewsstandKit/NewsstandKit.h>
//#import "ZipArchive.h"
@interface ViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,NSURLConnectionDownloadDelegate,
SKRequestDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver,NSURLConnectionDelegate>{
    UITableView *m_tableView;
    UIButton *btRead;
    ReadViewController *m_ReadViewController;
//    NSArray *arrIssuesPlist;
    NSUInteger numOfRows;
    MBProgressHUD *m_hud;
    UIImageView *testImageView;
    Publisher *publisher;
    UIBarButtonItem *editButton;
    UIBarButtonItem *waitButton;
    UIBarButtonItem *refreshButton;
    UIView *backView;
    BOOL isEdit;
}
@property(nonatomic,retain)UIImageView *testImageView;

@end
