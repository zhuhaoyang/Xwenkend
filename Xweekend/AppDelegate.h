//
//  AppDelegate.h
//  Xweekend
//
//  Created by Myth on 13-2-28.
//  Copyright (c) 2013年 Myth. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kAppKey             @"3448415748"
#define kAppSecret          @"03aa2cb686379d48f3ea0117607590e3"
#define kAppRedirectURI     @"http://www.sina.com"

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


}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SinaWeibo *sinaweibo;
@property (strong, nonatomic) LoadingPageViewController *loadingPageViewController;
//@property (strong, nonatomic) ViewController *viewController;


@end
