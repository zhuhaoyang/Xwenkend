//
//  AppDelegate.h
//  Xweekend
//
//  Created by Myth on 13-2-28.
//  Copyright (c) 2013年 Myth. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MobClick.h"
#import "serviceNewDevice.h"
#define kAppKey             @"3123568899"
#define kAppSecret          @"f36aa095949a6fd54451ede65cd2e884"
#define kAppRedirectURI     @"http://www.tingso.com/"

#ifndef kAppKey
#error
#endif

#ifndef kAppSecret
#error
#endif

#ifndef kAppRedirectURI
#error
#endif

//@class ViewController;
@class LoadingPageViewController;
@class SinaWeibo;

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
//    UINavigationController *nav;
//    ViewController *viewController;
//    LoadingPageViewController *loadingPageViewController;
//    NSTimer *timer;
//    UIImageView *startLoge;

    serviceNewDevice *m_serviceNewDevice;

}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SinaWeibo *sinaweibo;
@property (strong, nonatomic) LoadingPageViewController *loadingPageViewController;
//@property (strong, nonatomic) ViewController *viewController;


@end
