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
//        //    NSLog(@"12312313%@",self.view);
        self.view.autoresizingMask = UIViewAutoresizingNone;
        self.view.autoresizesSubviews = NO;
//                //    NSLog(@"superView = %@",self.view.superview);
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
//        //    NSLog(@"superView = %@",self.view.superview);
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
        //    //    NSLog(@"%@",self.view);
        [self.view addSubview:nav.view];
        [viewController release];
//        [self showMain];
    }
    
    
}


- (void)fadeScreen
{
//            //    NSLog(@"superView = %@",self.view.superview);
    self.view.frame = CGRectMake(0, 0, 768, 1024);

    NSArray *arrImage = [[NSArray alloc]initWithObjects:@"guide1",@"guide2",@"guide3",@"guide4",@"guide5", nil];
    if (guideView) {
//        [guideView release];
    }
    guideView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
    guideView.pagingEnabled = YES;
    guideView.contentSize = CGSizeMake(self.view.frame.size.width*5, 1024);
    guideView.showsHorizontalScrollIndicator = NO;
    guideView.showsVerticalScrollIndicator = NO;
//    guideView.scrollsToTop = NO;
    guideView.delegate = self;
//    guideView.minimumZoomScale = .25;
//    guideView.maximumZoomScale = 20;
//    guideView.canCancelContentTouches = YES;
//    guideView.userInteractionEnabled = YES;
//    guideView.alwaysBounceVertical = YES;
    
    pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 1024-36, 768, 36)];
    pageControl.numberOfPages=[arrImage count];
//    [pageControl setCurrentPageIndicatorTintColor:[UIColor yellowColor]];
    
    for ( int i = 0; i<[arrImage count]; i++) {
//        NSString *url=[arr objectAtIndex:i];
//        UIButton *img=[[UIButton alloc]initWithFrame:CGRectMake(320*i, 0, 320, 189)];
        NSString *path = [[NSBundle mainBundle] pathForResource:[arrImage objectAtIndex:i] ofType:@"jpg"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
//        NSLog(@"%f",image.size.width);
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = CGRectMake(768*i, 0, 768, 1024);
        [guideView addSubview:imageView];
        [imageView release];
    }
    [arrImage release];
    [self.view addSubview:guideView];
    [self.view addSubview:pageControl];
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
    [self.view bringSubviewToFront:startLoge];
    [startLoge removeFromSuperview];
    [startLoge release];
}




- (void)showMain
{
//    [startLoge removeFromSuperview];
    self.view.frame = CGRectMake(0, 0, 768, 1024);
    viewController = [[ViewController alloc]initWithNibName:@"ViewController" bundle:[NSBundle mainBundle]];
    nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"banner"] forBarMetrics:UIBarMetricsDefault];
    [viewController release];

//    //    NSLog(@"%@",self.view);
    [self.view addSubview:nav.view];
    [self.view bringSubviewToFront:guideView];
    [self.view bringSubviewToFront:pageControl];
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 0.3f];
    [UIView setAnimationDelegate: self];
    guideView.alpha = 0.0;
    pageControl.alpha = 0.0;
    [UIView setAnimationDidStopSelector:@selector(loadMainView)];
    [UIView commitAnimations];

//    //    NSLog(@"%@ %@",self.view,nav.view);
}

- (void)loadMainView
{
    [guideView removeFromSuperview];
    [guideView release];
    [pageControl removeFromSuperview];
    [pageControl release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x >= 3200) {
        [self showMain];
    }
    pageControl.currentPage=scrollView.contentOffset.x/768;
//    [self setCurrentPage:pageControl.currentPage];
//    NSLog(@"%f",scrollView.contentOffset.x);
    
}

- (void)dealloc
{
    [nav release];
    [super dealloc];
}
@end
