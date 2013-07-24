//
//  AppDelegate.m
//  Xweekend
//
//  Created by Myth on 13-2-28.
//  Copyright (c) 2013年 Myth. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "LoadingPageViewController.h"
#import "SinaWeibo.h"
#import "Publisher.h"


@implementation AppDelegate
//@synthesize sinaweibo = _sinaweibo;
//@synthesize viewController = _viewController;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor blackColor];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.loadingPageViewController = [[LoadingPageViewController alloc] initWithNibName:@"LoadingPageViewController" bundle:nil];
    
//    //    NSLog(@"232323232%@",self.loadingPageViewController.view);
//    nav = [[UINavigationController alloc]initWithRootViewController:viewController];
//    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"banner"] forBarMetrics:UIBarMetricsDefault];
    self.window.rootViewController = self.loadingPageViewController;

    [self.window makeKeyAndVisible];
    [[UIApplication sharedApplication]setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];

    self.sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey appSecret:kAppSecret appRedirectURI:kAppRedirectURI andDelegate:self.loadingPageViewController];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
    if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] && [sinaweiboInfo objectForKey:@"ExpirationDateKey"] && [sinaweiboInfo objectForKey:@"UserIDKey"])
    {
        self.sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
        self.sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
        self.sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
    }

//    [[SKPaymentQueue defaultQueue] addTransactionObserver:[Publisher sharedPublisher]];
    
    
    //umeng
    [MobClick startWithAppkey:@"5164c6a156240bfe620231e3"];
    
    //ANP
    [[UIApplication sharedApplication]
     registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                         UIRemoteNotificationTypeSound |
                                         UIRemoteNotificationTypeAlert |
                                         UIRemoteNotificationTypeNewsstandContentAvailability)];
    
    return YES;
}

//- (void)dealloc
//{
//    [nav release];
//    [_sinaweibo release];
//    [_viewController release];
//    [_window release];
//    [super dealloc];
//}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [self.sinaweibo handleOpenURL:url];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    
    return [self.sinaweibo handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [self.sinaweibo applicationDidBecomeActive];

}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark APNS

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"devToken=%@",deviceToken);
    //    strDeviceToken = [[NSString alloc]initWithData:deviceToken encoding:NSUTF8StringEncoding];
    
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@",deviceToken];
    //    NSRange range = NSMakeRange(9, 1);
    for (NSUInteger i=0; i<9 ; i++) {
        [str deleteCharactersInRange:NSMakeRange(72-i*9, 1)];
    }
   NSString *strDeviceToken = [NSString stringWithString:str];
    //    strDeviceToken = @"aec3eeb78d094d8bdc16b595dd3d74791cd7c1ab98796e867c1e74ec8c3";
    NSLog(@"%@ length = %d", strDeviceToken,[strDeviceToken length]);
    m_serviceNewDevice = [[serviceNewDevice alloc]initWithDelegate:self requestMode:TRequestMode_Asynchronous];
    [m_serviceNewDevice sendRequestWithData:[NSString stringWithFormat:@"deviceToken=%@",strDeviceToken] addr:@"index.php?"];

}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSLog(@"Error in registration. Error: %@", error);
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    /*
     
     收到消息自定义事件
     
     */
    
    if ([[userInfo objectForKey:@"aps"] objectForKey:@"alert"] != nil) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"通知"
                                                        message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
//        [alert release];
    }
}

- (void)serviceNewDeviceCallBack:(NSDictionary *)dicCallBack withErrorMessage:(Error *)error;
{
    //    UIAlertView *alert;
    UIAlertView *alert;
    if ([dicCallBack objectForKey:@"state"] != nil) {
        if ([dicCallBack objectForKey:@"state"] == [NSNumber numberWithInt:1]) {
            alert = [[UIAlertView alloc]initWithTitle:[[dicCallBack objectForKey:@"error"] objectAtIndex:0]
                                              message:nil
                                             delegate:self
                                    cancelButtonTitle:@"确认"
                                    otherButtonTitles:nil];
            [alert show];
        }else if([dicCallBack objectForKey:@"state"] == [NSNumber numberWithInt:0]){
            LOGS(@"Add devicecode succeed");
        }
    }else{
        LOGS(@"失败");
    }
}


@end
