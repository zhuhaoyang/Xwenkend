//
//  LoadingPageViewController.m
//  Xweekend
//
//  Created by Myth on 13-3-27.
//  Copyright (c) 2013年 Myth. All rights reserved.
//

#import "LoadingPageViewController.h"

@interface LoadingPageViewController ()

@end

@implementation LoadingPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"12312313%@",self.view);
        self.view.autoresizingMask = UIViewAutoresizingNone;
        self.view.autoresizesSubviews = NO;
//                NSLog(@"superView = %@",self.view.superview);
        self.view.frame = CGRectMake(0, 0, 768, 1024);

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.autoresizingMask = UIViewAutoresizingNone;
    self.view.autoresizesSubviews = NO;
    self.view.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view from its nib.
    if (1) {
        startLoge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"startLog.jpg"]];
        startLoge.frame = CGRectMake(0, 0, 768, 1024);
        startLoge.alpha = 0;
        [self.view addSubview:startLoge];
//        NSLog(@"superView = %@",self.view.superview);
        [UIView beginAnimations: nil context: nil];
        [UIView setAnimationDuration: 0.5f];
        [UIView setAnimationDelegate: self];
        startLoge.alpha = 1.0;
        [UIView commitAnimations];

        timer = [NSTimer scheduledTimerWithTimeInterval: 3.0
                                                 target: self
                                               selector: @selector(fadeScreen)
                                               userInfo: nil repeats: NO];
        self.view.frame = CGRectMake(0, 0, 768, 1024);

    }else {
        self.view.frame = CGRectMake(0, 0, 768, 1024);
        viewController = [[ViewController alloc]initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
        nav = [[UINavigationController alloc]initWithRootViewController:viewController];
        [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"banner"] forBarMetrics:UIBarMetricsDefault];
        //    NSLog(@"%@",self.view);
        [self.view addSubview:nav.view];

//        [self showMain];
    }
    
    
}


- (void)fadeScreen
{
//            NSLog(@"superView = %@",self.view.superview);
    self.view.frame = CGRectMake(0, 0, 768, 1024);
    viewController = [[ViewController alloc]initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
//    viewController.view.frame = CGRectMake(0, -20, 768, 1024);
    nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"banner"] forBarMetrics:UIBarMetricsDefault];
    //    NSLog(@"%@",self.view);
    [self.view addSubview:nav.view];
    [self.view bringSubviewToFront:startLoge];
//	[UIView beginAnimations: nil context: nil];
//	[UIView setAnimationDuration: 0.3f];
//	[UIView setAnimationDelegate: self];
//	[UIView setAnimationDidStopSelector: @selector(finishedFading)];
//	startLoge.alpha = 1.0;
//	[UIView commitAnimations];
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 0.5f];
    [UIView setAnimationDelegate: self];
    startLoge.alpha = 0.0;
    [UIView setAnimationDidStopSelector:@selector(finishedFading)];
    [UIView commitAnimations];
    
//    [UIView beginAnimations: nil context: nil];
//	[UIView setAnimationDuration: 0.5f];
//	startLoge.alpha = 0.0;
//	[UIView commitAnimations];
	   
//    [self showMain];
}

- (void)finishedFading
{
//    [startLoge removeFromSuperview];

//	[UIView beginAnimations: nil context: nil];
//	[UIView setAnimationDuration: 3.0f];
//	startLoge.alpha = 0.0;
    
//    self.view.frame = CGRectMake(0, 0, 768, 1024);
//    viewController.view.frame = self.view.frame;
    [startLoge removeFromSuperview];
//	[UIView commitAnimations];
    
//    [self showMain];
}




- (void)showMain
{
//    [startLoge removeFromSuperview];
    self.view.frame = CGRectMake(0, 0, 768, 1024);
    viewController = [[ViewController alloc]initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
    nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"banner"] forBarMetrics:UIBarMetricsDefault];
//    NSLog(@"%@",self.view);
    [self.view addSubview:nav.view];
//    NSLog(@"%@ %@",self.view,nav.view);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
