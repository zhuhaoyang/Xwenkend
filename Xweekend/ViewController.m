//
//  ViewController.m
//  Xweekend
//
//  Created by Myth on 13-2-28.
//  Copyright (c) 2013年 Myth. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"行周末";
//    [self.view setBackgroundColor:[UIColor blackColor]];

//    [self.view addSubview:backGroundView];
    m_tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
//    [m_tableView setBackgroundColor:[UIColor grayColor]];
    UIImageView *backGroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"960768.png"]];
    backGroundView.frame = CGRectMake(0, 0, 768, 960);
    [m_tableView setBackgroundView:backGroundView];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [backGroundView release];
    [self.view addSubview:m_tableView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"issues" ofType:@"plist"];
    arrIssuesPlist = [[NSArray alloc]initWithContentsOfFile:path];

    
//    btRead = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btRead.frame = CGRectMake(100, 100, 100, 50);
//    [btRead setTitle:@"阅读" forState:UIControlStateNormal];
//    [btRead addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btRead];
}

//- (void)test
//{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/u/1760807974"]];
//}


- (void)dealloc
{
    [m_tableView release];
    m_tableView = nil;
    [btRead release];
    btRead = nil;
    [m_ReadViewController release];
    m_ReadViewController = nil;
    [arrIssuesPlist release];
    arrIssuesPlist = nil;
    [super dealloc];

}

- (void)loadOrRead:(id)sender
{
//    if (m_ReadViewController) {
//        [m_ReadViewController release];
//        m_ReadViewController = nil;
//    }
    UIButton *bt = (UIButton *)sender;
    NSMutableString *str = [NSMutableString stringWithFormat:@"%i",bt.tag];
    [str deleteCharactersInRange:NSMakeRange(0, 1)];
    m_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    m_hud.labelText = @"加载中...";
    m_ReadViewController = [[ReadViewController alloc]initWithNibName:@"ReadViewController" bundle:[NSBundle mainBundle] numOfIssues:str];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:YES animated:FALSE];
//    [self setWantsFullScreenLayout:YES];
    
    [self.navigationController pushViewController:m_ReadViewController animated:YES];
    [m_ReadViewController release];

    [MBProgressHUD hideHUDForView:self.view animated:YES];
    m_hud = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark -
#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height;
    if ([indexPath row] != 0) {
        height = 399;
    }else{
        height = 116;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIImageView *headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"title.png"]];
//    headerView.frame = CGRectMake(0, 0, 768, 150);
//    return headerView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 150;
//}

#pragma mark -
#pragma mark table view datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
    NSUInteger row = [indexPath row];
    UIImageView *cellBackgroundView;
    if (row != 0) {
        cellBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"shelf"]];
        cellBackgroundView.frame = CGRectMake(0, 0, 768, 399);
        if (row == numOfRows) {
            cellBackgroundView.layer.shadowColor = [UIColor grayColor].CGColor;
            cellBackgroundView.layer.shadowOffset = CGSizeMake(0, 4);
            cellBackgroundView.layer.shadowOpacity = 0.5;
            cellBackgroundView.layer.shadowRadius = 4.0;

            }
        for (NSUInteger column = 1; column <= 3; column++) {
            NSUInteger num = (row - 1)*3+column;
            if (num > [arrIssuesPlist count]) {
                break;
            }
            UIButton * bt = [UIButton buttonWithType:UIButtonTypeCustom];
            bt.frame = CGRectMake((column - 1)*256 + 15.5, 30, 225, 300);
            
            NSString *str = [[arrIssuesPlist objectAtIndex:(num - 1)] objectForKey:@"cover"];
            UIImage *image = [UIImage imageNamed:str];
            [bt setBackgroundImage:image forState:UIControlStateNormal];
            bt.tag = [[NSString stringWithFormat:@"1%i",num] integerValue];
            [bt addTarget:self action:@selector(loadOrRead:) forControlEvents:UIControlEventTouchUpInside];
            
            UIProgressView *progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
            progressView.frame = CGRectMake((column - 1)*256 + 20, 300, 216, 9);
            progressView.tag = [[NSString stringWithFormat:@"2%i",num] integerValue];
            progressView.alpha = 1;
            progressView.progress = 0.5;
            
            UIButton *btLoadOrRead = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btLoadOrRead.frame = CGRectMake((column - 1)*256 + 88, 350, 80, 30);
            [btLoadOrRead addTarget:self action:@selector(loadOrRead:) forControlEvents:UIControlEventTouchUpInside];
            btLoadOrRead.tag = [[NSString stringWithFormat:@"3%i",num] integerValue];
            
//            bt.layer.shadowColor = [UIColor blackColor].CGColor;
//            bt.layer.shadowOffset = CGSizeMake(0, 4);
//            bt.layer.shadowOpacity = 0.5;
//            bt.layer.shadowRadius = 4.0;

            [cell addSubview:bt];
            [cell addSubview:progressView];
            [cell addSubview:btLoadOrRead];
            [progressView release];
            }
    }else{
        
        cellBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"title"]];
        cellBackgroundView.frame = CGRectMake(0, 0, 768, 116);
        cellBackgroundView.layer.shadowColor = [UIColor grayColor].CGColor;
        cellBackgroundView.layer.shadowOffset = CGSizeMake(0, -4);
        cellBackgroundView.layer.shadowOpacity = 0.5;
        cellBackgroundView.layer.shadowRadius = 4.0;
        cell.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    }
    [cell setBackgroundView:cellBackgroundView];
    [cellBackgroundView release];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    numOfRows = [arrIssuesPlist count]/3;
    if ([arrIssuesPlist count]%3 >0) {
        numOfRows = numOfRows+1;
    }
    if (numOfRows == 2) {
        numOfRows = numOfRows + 1;
    }else if(numOfRows == 1){
        numOfRows = numOfRows + 2;
    }
    return numOfRows+1;
}

@end
