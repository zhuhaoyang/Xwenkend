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
@interface ViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate>{
    UITableView *m_tableView;
    UIButton *btRead;
    ReadViewController *m_ReadViewController;
    NSArray *arrIssuesPlist;
    NSUInteger numOfRows;
    MBProgressHUD *m_hud;
}

@end
