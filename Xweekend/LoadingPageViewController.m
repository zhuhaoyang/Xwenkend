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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (1) {
        startLoge = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"startLog.jpg"]];
        startLoge.frame = self.view.bounds;
        
        [self.view addSubview:startLoge];
        
        timer = [NSTimer scheduledTimerWithTimeInterval: 3.0
                                                 target: self
                                               selector: @selector(fadeScreen)
                                               userInfo: nil repeats: NO];
    }else {
        [self showMain];
    }
    
    
}


- (void) fadeScreen
{
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration: 0.5f];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector: @selector(finishedFading)];
	self.view.alpha = 0.0;
	[UIView commitAnimations];
}

- (void) finishedFading
{
	[UIView beginAnimations: nil context: nil];
	[UIView setAnimationDuration: 0.5f];
	self.view.alpha = 1.0;
	[UIView commitAnimations];
	[startLoge removeFromSuperview];
    
    [self showMain];
}




- (void)showMain
{
    self.view.frame = CGRectMake(0, 0, 768, 1024);
    viewController = [[ViewController alloc]initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
    nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"banner"] forBarMetrics:UIBarMetricsDefault];
//    NSLog(@"%@",self.view);
    [self.view addSubview:nav.view];
    NSLog(@"%@ %@",self.view,nav.view);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
