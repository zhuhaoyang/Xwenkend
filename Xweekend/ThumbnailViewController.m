//
//  ThumbnailViewController.m
//  Xweekend
//
//  Created by Myth on 13-3-6.
//  Copyright (c) 2013年 Myth. All rights reserved.
//

#import "ThumbnailViewController.h"


@interface ThumbnailViewController ()

@end

@implementation ThumbnailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil numOfIssue:(NSInteger)num
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        numOfIssue = num;
    }
    return self;
}

- (void)move:(id)sender
{
    btThumbnai *bt = sender;
    [Publisher sharedPublisher].numOfPage = [[bt.dicUserInfo objectForKey:@"page"] integerValue];
//    //    NSLog(@"%@",bt.dicUserInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"moveTo" object:nil userInfo:bt.dicUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remove" object:nil];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIImageView *backgroundImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"background.png"]];
    [self.view addSubview:backgroundImage];
    [backgroundImage release];
    Publisher *publisher = [Publisher sharedPublisher];
//    [[publisher issueAtIndex:numOfIssue] objectForKey:@"contentInfo"];
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"issues" ofType:@"plist"];
//    NSArray *arrIssuesPlist = [[NSArray alloc]initWithContentsOfFile:path];
//    NSDictionary *dicIssueInfo = [arrIssuesPlist objectAtIndex:0];
    arrThumbnailInfo = [[NSArray alloc]initWithArray:[[publisher issueAtIndex:numOfIssue] objectForKey:@"contentInfo"]];
//    [arrIssuesPlist release];
    arrTag = [[NSMutableArray alloc]initWithCapacity:[arrThumbnailInfo count]];
    m_ScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
//    m_ScrollView.pagingEnabled = YES;
//    [m_ScrollView setBackgroundColor:[UIColor grayColor]];
    [m_ScrollView setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0]];
    m_ScrollView.contentSize = CGSizeMake(199 * [arrThumbnailInfo count] - 26, m_ScrollView.frame.size.height);
//        m_ScrollView.contentSize = CGSizeMake(199 * 5 - 26, m_ScrollView.frame.size.height);
    m_ScrollView.showsHorizontalScrollIndicator = NO;
    m_ScrollView.showsVerticalScrollIndicator = NO;
    m_ScrollView.scrollsToTop = NO;
    m_ScrollView.delegate = self;
    m_ScrollView.minimumZoomScale = .25;
    m_ScrollView.maximumZoomScale = 20;
    m_ScrollView.userInteractionEnabled = YES;
    m_ScrollView.canCancelContentTouches = YES;
    [self.view addSubview:m_ScrollView];
    for (NSInteger i = 0; i < [arrThumbnailInfo count]; i++) {
        [arrTag addObject:[NSNumber numberWithBool:NO]];
    }
    if ([arrThumbnailInfo count] < 4) {
        max = [arrThumbnailInfo count];
    }else{
        max = 4;
    }
    for (NSInteger column = 0; column < max; column++) {
//    for (NSInteger column = 0; column < [arrThumbnailInfo count]; column++) {
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSDictionary *dic = [arrThumbnailInfo objectAtIndex:column];
        NSInteger numOfPaages = [[dic objectForKey:@"numOfPaages"] integerValue];
        UIScrollView *pageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(200 * column, 0, 172, 960)];
        pageScrollView.contentSize = CGSizeMake(pageScrollView.frame.size.width, 240 * numOfPaages);
		pageScrollView.showsHorizontalScrollIndicator = NO;
		pageScrollView.showsVerticalScrollIndicator = NO;
		pageScrollView.scrollsToTop = NO;
		pageScrollView.delegate = self;
		pageScrollView.minimumZoomScale = .25;
        pageScrollView.maximumZoomScale = 20;
        pageScrollView.canCancelContentTouches = YES;
        pageScrollView.userInteractionEnabled = YES;
        pageScrollView.alwaysBounceVertical = YES;
        pageScrollView.tag = column + 1;
		for (NSInteger page = 1; page <= numOfPaages; page++) {



            
            
            Publisher *publisher = [Publisher sharedPublisher];
            NKLibrary *nkLib = [NKLibrary sharedLibrary];
            NKIssue *nkIssue = [nkLib issueWithName:[publisher nameOfIssueAtIndex:numOfIssue]];
            
            NSString *str = [NSString stringWithFormat:@"%@%iS.jpg",[dic objectForKey:@"title"],page];
            //    NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"jpg"];
            NSString *path = [[nkIssue.contentURL path] stringByAppendingPathComponent:str];
            UIImage *image1 = [UIImage imageWithContentsOfFile:path];
            

            
            btThumbnai *image = [btThumbnai buttonWithType:UIButtonTypeCustom];
            [image setObject:[NSNumber numberWithInteger:column+1] forKey:@"column"];
            [image setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
            CGRect frame = CGRectMake(0, 240*(page -1)+5, 172, 225);
            image.frame = frame;
            [image setBackgroundImage:image1 forState:UIControlStateNormal];
            [image addTarget:self action:@selector(move:) forControlEvents:UIControlEventTouchUpInside];
            [pageScrollView addSubview:image];

		}
        [m_ScrollView addSubview:pageScrollView];
        [pageScrollView release];
        
//            });
        [arrTag replaceObjectAtIndex:column withObject:[NSNumber numberWithBool:YES]];

    }
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    //    NSLog(@"%f",scrollView.contentOffset.x);
    NSInteger offSet = scrollView.contentOffset.x/200+4;
//    //    NSLog(@"%ld",(long)offSet);

    if ([arrThumbnailInfo count] <= 4 ||offSet >([arrThumbnailInfo count] - 1)) {
        return;
    }
    if ([[arrTag objectAtIndex:offSet] boolValue]) {
        return;
    }
    [arrTag replaceObjectAtIndex:offSet withObject:[NSNumber numberWithBool:YES]];


        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            
            
                dispatch_async(dispatch_get_main_queue(), ^{

                

        
        
        
        NSInteger offSet = scrollView.contentOffset.x/200+4;
//        //    NSLog(@"%ld",(long)offSet);
        if (offSet < [arrThumbnailInfo count]) {
            NSDictionary *dic = [arrThumbnailInfo objectAtIndex:offSet];
            NSInteger numOfPaages = [[dic objectForKey:@"numOfPaages"] integerValue];
            UIScrollView *pageScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(200 * offSet, 0, 172, 960)];
            pageScrollView.contentSize = CGSizeMake(pageScrollView.frame.size.width, 240 * numOfPaages);
            pageScrollView.showsHorizontalScrollIndicator = NO;
            pageScrollView.showsVerticalScrollIndicator = NO;
            pageScrollView.scrollsToTop = NO;
            pageScrollView.delegate = self;
            pageScrollView.minimumZoomScale = .25;
            pageScrollView.maximumZoomScale = 20;
            pageScrollView.canCancelContentTouches = YES;
            pageScrollView.userInteractionEnabled = YES;
            pageScrollView.alwaysBounceVertical = YES;
            pageScrollView.tag = offSet + 1;
            for (NSInteger page = 1; page <= numOfPaages; page++) {
                
                
                Publisher *publisher = [Publisher sharedPublisher];
                NKLibrary *nkLib = [NKLibrary sharedLibrary];
                NKIssue *nkIssue = [nkLib issueWithName:[publisher nameOfIssueAtIndex:numOfIssue]];
                
                NSString *str = [NSString stringWithFormat:@"%@%iS.jpg",[dic objectForKey:@"title"],page];
                //    NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"jpg"];
                NSString *path = [[nkIssue.contentURL path] stringByAppendingPathComponent:str];
                UIImage *image1 = [UIImage imageWithContentsOfFile:path];

                
                
//                NSString *str = [NSString stringWithFormat:@"%@%iS",[dic objectForKey:@"title"],page];
//                NSString *path = [[NSBundle mainBundle] pathForResource:str ofType:@"jpg"];
//                UIImage *image1 = [UIImage imageWithContentsOfFile:path];
                btThumbnai *image = [btThumbnai buttonWithType:UIButtonTypeCustom];
                [image setObject:[NSNumber numberWithInteger:offSet+1] forKey:@"column"];
                [image setObject:[NSNumber numberWithInteger:page] forKey:@"page"];
                CGRect frame = CGRectMake(0, 240*(page -1)+5, 172, 225);
                image.frame = frame;
                [image setBackgroundImage:image1 forState:UIControlStateNormal];
                [image addTarget:self action:@selector(move:) forControlEvents:UIControlEventTouchUpInside];
                [pageScrollView addSubview:image];
                
            }
            [m_ScrollView addSubview:pageScrollView];
            [pageScrollView release];


        }

                });
  
    });

    
}

- (void)viewDidAppear:(BOOL)animated
{

}

- (void)dealloc
{
    [m_ScrollView release];
    m_ScrollView = nil;
    [arrThumbnailInfo release];
    arrThumbnailInfo = nil;
    [arrTag release];
    arrTag = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
