//
//  LoadingPageViewController.h
//  Xweekend
//
//  Created by Myth on 13-3-27.
//  Copyright (c) 2013年 Myth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface LoadingPageViewController : UIViewController{
    ViewController *viewController;
    UINavigationController *nav;
    NSTimer *timer;
    UIImageView *startLoge;
}

- (void)fadeScreen;
- (void)finishedFading;
- (void)showMain;
@end
