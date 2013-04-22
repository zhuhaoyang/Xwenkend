//
//  ViewController.m
//  Xweekend
//
//  Created by Myth on 13-2-28.
//  Copyright (c) 2013年 Myth. All rights reserved.
//

#import "ViewController.h"
#import "zlib.h"
#import "ZipArchive.h"
@interface ViewController ()

@end

@implementation ViewController
@synthesize testImageView = _testImageView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.opaque = YES;
    publisher = [Publisher sharedPublisher];
    isEdit = NO;
//    self.title = @"行周末";
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    title.text = @"行周末";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = [UIColor blackColor];
    title.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    title.font = [UIFont boldSystemFontOfSize:23];
    self.navigationItem.titleView = title;
    [title release];
    
    UIView *liftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 30)];
//    editButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(edit)];
    editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    editButton.frame = CGRectMake(0, 0, 55, 30);
    [editButton addTarget:self action:@selector(edit) forControlEvents:UIControlEventTouchUpInside];
//    [editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [editButton setBackgroundImage:[UIImage imageNamed:@"BUTTON5"] forState:UIControlStateNormal];
    [liftView addSubview:editButton];
    UIButton *btRestore = [UIButton buttonWithType:UIButtonTypeCustom];
    btRestore.frame = CGRectMake(60, 0, 55, 30);
    [btRestore addTarget:self action:@selector(restore) forControlEvents:UIControlEventTouchUpInside];
//    [btRestore setTitle:@"恢复" forState:UIControlStateNormal];
    [btRestore setBackgroundImage:[UIImage imageNamed:@"BUTTON6"] forState:UIControlStateNormal];
    [liftView addSubview:btRestore];
    
    UIBarButtonItem *liftButton = [[UIBarButtonItem alloc]initWithCustomView:liftView];
    [self.navigationItem setLeftBarButtonItem:liftButton];
    [liftView release];
    [liftButton release];
//    self.navigationItem.leftBarButtonItem = editButton;
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
    m_hud = [MBProgressHUD showHUDAddedTo:backView animated:YES];
    m_hud.labelText = @"加载中...";
//    [self.view setBackgroundColor:[UIColor blackColor]];
//    refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [refreshButton setBackgroundImage:[UIImage imageNamed:@"BUTTON9"] forState:UIControlStateNormal];
//    [refreshButton addTarget:self action:@selector(loadIssues) forControlEvents:UIControlEventTouchUpInside];
//    refreshButton.frame = CGRectMake(0, 0, 55, 30);
    
//    refreshButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonItemStylePlain target:self action:@selector(loadIssues)];
//    refreshButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"BUTTON9"] style:UIBarButtonItemStylePlain target:self action:@selector(loadIssues)];
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 42, 30)];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"BUTTON9"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(loadIssues) forControlEvents:UIControlEventTouchUpInside];
    rightButton.frame = CGRectMake(0, 0, 42, 30);
    [rightView addSubview:rightButton];
    refreshButton = [[UIBarButtonItem alloc]initWithCustomView:rightView];
    [rightView release];
//    [refreshButton setBackButtonBackgroundImage:[UIImage imageNamed:@"BUTTON9"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [refreshButton setAction:@selector(loadIssues)];
//    [refreshButton setTarget:self];
    
//    UIBarButtonItem *rightView = [[UIBarButtonItem alloc]initWithCustomView:refreshButton];
//    refreshButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"BUTTON9"] style:UIBarButtonItemStyleBordered target:self action:@selector(loadIssues)];
    UIActivityIndicatorView *loadingActivity = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge] autorelease];
    loadingActivity.frame = CGRectMake(0, 0, 42, 30);
    [loadingActivity startAnimating];
    waitButton = [[UIBarButtonItem alloc] initWithCustomView:loadingActivity];
    [waitButton setBackButtonBackgroundImage:[UIImage imageNamed:@"BUTTON9"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [waitButton setTarget:nil];
    [waitButton setAction:nil];
    
    // left bar button item
    
    
    if([publisher isReady]) {
        [self showIssues];
    } else {
        [self loadIssues];
    }
//    [self.view addSubview:backGroundView];
    m_tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    m_tableView.delegate = self;
    m_tableView.dataSource = self;
//    m_tableView.alpha = 0;
//    [m_tableView setBackgroundColor:[UIColor grayColor]];
    UIImageView *backGroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"960768.png"]];
    backGroundView.frame = CGRectMake(0, 0, 768, 960);
    [m_tableView setBackgroundView:backGroundView];
    m_tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [backGroundView release];
    [self.view addSubview:m_tableView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(timeout) name:@"timeout" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productsLoaded:) name:kProductsLoadedNotification object:nil];
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        //    NSLog(@"No internet connection!");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法连接到互联网"
                                                       message:nil
                                                      delegate:nil
                                             cancelButtonTitle:@"确认"
                                             otherButtonTitles: nil];
        [alert show];
    } else {
        if (publisher.m_products != nil) {
            
//            [[Publisher sharedPublisher] requestProducts];
//            m_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            m_hud.labelText = @"Loading comics...";
//            [self performSelector:@selector(timeout:) withObject:nil afterDelay:30.0];
            
        }
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(productPurchased:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector: @selector(productPurchaseFailed:) name:kProductPurchaseFailedNotification object: nil];
    

    
    
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"issues" ofType:@"plist"];
//    arrIssuesPlist = [[NSArray alloc]initWithContentsOfFile:path];

    
//    btRead = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btRead.frame = CGRectMake(0, 0, 100, 50);
//    [btRead setTitle:@"阅读" forState:UIControlStateNormal];
//    [btRead addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btRead];
    
//    self.testImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"P1S.jpg"]];
//    self.testImageView.frame = CGRectMake(100, 100, 320, 480);
//    [self.view addSubview:self.testImageView];
}

//- (void)test
//{
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://weibo.com/u/1760807974"]];
//    self.testImageView.frame = CGRectMake(100, 100, 1280, 1024);
//}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kProductPurchaseFailedNotification object:nil];
    [m_tableView release];
    m_tableView = nil;
    [btRead release];
    btRead = nil;
    [m_ReadViewController release];
    m_ReadViewController = nil;
//    [arrIssuesPlist release];
//    arrIssuesPlist = nil;
    [waitButton release];
    waitButton = nil;
    [refreshButton release];
    refreshButton = nil;
    [editButton release];
    editButton = nil;
    [super dealloc];

}

- (void)loadOrReadOrBuy:(id)sender
{

    if (!isEdit) {
        UIButton *bt = (UIButton *)sender;
        NSMutableString *str = [NSMutableString stringWithFormat:@"%i",bt.tag];
        [str deleteCharactersInRange:NSMakeRange(0, 1)];
        NSInteger num = [str integerValue] - 1;
        NKLibrary *nkLib = [NKLibrary sharedLibrary];
        NKIssue *nkIssue = [nkLib issueWithName:[publisher nameOfIssueAtIndex:num]];
        // NSURL *downloadURL = [nkIssue contentURL];
        if ([publisher.m_purchasedProducts containsObject:[[publisher issueAtIndex:(num)] objectForKey:@"productIdentifier"]]) {
            if (nkIssue.status != NKIssueContentStatusDownloading) {
                if(nkIssue.status==NKIssueContentStatusAvailable) {
                    [self readIssue:str];
                } else if(nkIssue.status==NKIssueContentStatusNone) {
                    [self downloadIssueAtIndex:num];
                }
            }
        }else{
            [publisher buyProductIdentifier:[[publisher issueAtIndex:num] objectForKey:@"productIdentifier"]];
        }
    }


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Issue actions

-(void)readIssue:(NSString *)str {
//    [[NKLibrary sharedLibrary] setCurrentlyReadingIssue:nkIssue];
    NSDictionary *dic = [[NSDictionary alloc]initWithDictionary:[publisher issueAtIndex:([str integerValue]-1)]];
    m_ReadViewController = [[ReadViewController alloc]initWithNibName:@"ReadViewController" bundle:[NSBundle mainBundle] dic:dic numOfIssues:str];
    [dic release];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    [self.navigationController setNavigationBarHidden:YES animated:FALSE];
    //    [self setWantsFullScreenLayout:YES];
    
    [self.navigationController pushViewController:m_ReadViewController animated:YES];
    [m_ReadViewController release];

//    QLPreviewController *previewController = [[[QLPreviewController alloc] init] autorelease];
//    previewController.delegate=self;
//    previewController.dataSource=self;
//    [self presentModalViewController:previewController animated:YES];
}

-(void)downloadIssueAtIndex:(NSInteger)index {
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [reach currentReachabilityStatus];
    if (netStatus == NotReachable) {
        //    NSLog(@"No internet connection!");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"无法连接到互联网"
                                                       message:nil
                                                      delegate:nil cancelButtonTitle:@"确认"
                                             otherButtonTitles: nil];
        [alert show];
        return;
    }
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
    NKIssue *nkIssue = [nkLib issueWithName:[publisher nameOfIssueAtIndex:index]];
    NSURL *downloadURL = [publisher contentURLForIssueWithName:nkIssue.name];
    if(!downloadURL) return;
    NSURLRequest *req = [NSURLRequest requestWithURL:downloadURL];
    NKAssetDownload *assetDownload = [nkIssue addAssetWithRequest:req];
    [assetDownload downloadWithDelegate:self];
    [assetDownload setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                [NSNumber numberWithInt:(index+1)],@"num",
                                nil]];
    
}
#pragma mark - Trash content
// remove one downloaded magazines
- (void)deleteIssue:(id)sender
{
    UIButton *bt = (UIButton *)sender;
    NSMutableString *str = [NSMutableString stringWithFormat:@"%i",bt.tag];
    [str deleteCharactersInRange:NSMakeRange(0, 1)];
    NSInteger num = [str integerValue] - 1;
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"是否删除杂志:%@",[publisher nameOfIssueAtIndex:num]]
                                                   message:nil
                                                  delegate:self
                                         cancelButtonTitle:nil
                                         otherButtonTitles:@"确认",@"取消", nil];
    alert.tag = num;
    [alert show];
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NKLibrary *nkLib = [NKLibrary sharedLibrary];
        NKIssue *nkIssue = [nkLib issueWithName:[publisher nameOfIssueAtIndex:alertView.tag]];
        [nkLib removeIssue:nkIssue];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publisherReady:) name:PublisherDidUpdateNotification object:publisher];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publisherFailed:) name:PublisherFailedUpdateNotification object:publisher];
        [publisher getIssuesList];
//        [publisher requestProducts];
        [m_tableView reloadData];
    }
}

// remove all downloaded magazines
- (void)edit {
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
//    Publisher *publisher = [Publisher sharedPublisher];
    NSInteger num = [publisher numberOfIssues];
    if (isEdit) {
//        [editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [editButton setBackgroundImage:[UIImage imageNamed:@"BUTTON5"] forState:UIControlStateNormal];
        for (NSInteger i = 1; i <= num; i++) {
            NSInteger tag = [[NSString stringWithFormat:@"4%i",i] integerValue];
            UIButton *btDel = (UIButton *)[m_tableView viewWithTag:tag];
            btDel.enabled = NO;
            btDel.alpha = 0.0;
        }
        [refreshButton setEnabled:YES];
    }else{
//        [editButton setTitle:@"完成" forState:UIControlStateNormal];
        [editButton setBackgroundImage:[UIImage imageNamed:@"BUTTON7"] forState:UIControlStateNormal];
        for (NSInteger i = 1; i <= num; i++) {
            NKIssue *nkIssue = [nkLib issueWithName:[publisher nameOfIssueAtIndex:(i-1)]];
            if (nkIssue.status == NKIssueContentStatusAvailable) {
                NSInteger tag = [[NSString stringWithFormat:@"4%i",i] integerValue];
                UIButton *btDel = (UIButton *)[m_tableView viewWithTag:tag];
                btDel.enabled = YES;
                btDel.alpha = 1.0;
            }
        }
        [refreshButton setEnabled:NO];
    }
    
//    [m_tableView reloadData];
    isEdit = !isEdit;

//    NKLibrary *nkLib = [NKLibrary sharedLibrary];
//    //    NSLog(@"%@",nkLib.issues);
//    [nkLib.issues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
//        [nkLib removeIssue:(NKIssue *)obj];
//    }];
////    [publisher ]
//    [publisher getIssuesList];
//    [m_tableView reloadData];
}


#pragma mark - NSURLConnectionDownloadDelegate

-(void)updateProgressOfConnection:(NSURLConnection *)connection withTotalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes {
    // get asset
    NKAssetDownload *dnl = connection.newsstandAssetDownload;
//    UITableViewCell *cell = [table_ cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[[dnl.userInfo objectForKey:@"num"] intValue] inSection:0]];
    NSInteger num = [[dnl.userInfo objectForKey:@"num"] integerValue];
    
    NSInteger tag =  [[NSString stringWithFormat:@"2%i", num] integerValue];
    UIProgressView *progressView = (UIProgressView *)[m_tableView viewWithTag:tag];
    progressView.alpha=1.0;
    progressView.progress=1.f*totalBytesWritten/expectedTotalBytes;

//    tag =  [[NSString stringWithFormat:@"1%i", num] integerValue];
//    UIButton *bt = (UIButton *)[m_tableView viewWithTag:tag];
//    bt.enabled = NO;

//    tag =  [[NSString stringWithFormat:@"3%i", num] integerValue];
//    UIButton *btLoadOrRead = (UIButton *)[m_tableView viewWithTag:tag];
//    btLoadOrRead.enabled = NO;

//    [[cell viewWithTag:103] setAlpha:0.0];
}

-(void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes {
    [self updateProgressOfConnection:connection withTotalBytesWritten:totalBytesWritten expectedTotalBytes:expectedTotalBytes];
}

-(void)connectionDidResumeDownloading:(NSURLConnection *)connection totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes {
    //    NSLog(@"Resume downloading %f",1.f*totalBytesWritten/expectedTotalBytes);
    [self updateProgressOfConnection:connection withTotalBytesWritten:totalBytesWritten expectedTotalBytes:expectedTotalBytes];
}

-(void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL {
    // copy file to destination URL
    NKAssetDownload *dnl = connection.newsstandAssetDownload;
    NKIssue *nkIssue = dnl.issue;
    NSString *contentPath = [publisher downloadPathForIssue:nkIssue];
//    NSError *moveError=nil;
//    //    NSLog(@"File is being copied to %@",contentPath);
    
//    if([[NSFileManager defaultManager] moveItemAtPath:[destinationURL path] toPath:contentPath error:&moveError]==NO) {
//        //    NSLog(@"Error copying file from %@ to %@",destinationURL,contentPath);
//    }
//    //    NSLog(@"Error copying file from %@ to %@",destinationURL,contentPath);
//    NSString *strDestinationURL = [NSString stringWithContentsOfURL:destinationURL encoding:NSUTF8StringEncoding error:&moveError];
//    NSString *strDestinationURL = [NSString stringWithFormat:@"%@",destinationURL];
//    NSString *nameOfZip = [strDestinationURL lastPathComponent];
    NSString *filePath =  [destinationURL path];
//    NSString *strContentPath = [NSString stringWithFormat:@"%@",contentPath];
    
    //    NSLog( @"download to %@",filePath);
    ZipArchive* za = [[ZipArchive alloc] init];
	if( [za UnzipOpenFile:filePath] )
	{
		BOOL ret = [za UnzipFileTo:contentPath overWrite:YES];
		if( NO==ret )
		{
            //    NSLog(@"Error unzip!");
		}
		[za UnzipCloseFile];
	}
    
	[za release];
    NSFileManager* fileManager=[NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
//    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"pin.png"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!blHave) {
        //    NSLog(@"no  have");
        return ;
    }else {
        //    NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:filePath error:nil];
        if (blDele) {
            //    NSLog(@"dele success");
        }else {
            //    NSLog(@"dele fail");
        }
        
    }
    // update the Newsstand icon
    UIImage *img = [publisher coverImageForIssue:nkIssue];
    if(img) {
        [[UIApplication sharedApplication] setNewsstandIconImage:img];
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    }
//    NSInteger num = [[dnl.userInfo objectForKey:@"num"] integerValue];
    
//    NSInteger tag =  [[NSString stringWithFormat:@"2%i", num] integerValue];
//    UIProgressView *progressView = (UIProgressView *)[m_tableView viewWithTag:tag];
//    progressView.alpha=1.0;
//    progressView.progress=1.f*totalBytesWritten/expectedTotalBytes;
    
//    NSInteger tag =  [[NSString stringWithFormat:@"1%i", num] integerValue];
//    UIButton *bt = (UIButton *)[m_tableView viewWithTag:tag];
//    bt.enabled = YES;
    
//    tag =  [[NSString stringWithFormat:@"3%i", num] integerValue];
//    UIButton *btLoadOrRead = (UIButton *)[m_tableView viewWithTag:tag];
//    btLoadOrRead.enabled = YES;

    
    [m_tableView reloadData];
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
    
//    UIProgressView *progressView = (UIProgressView*)[m_tableView viewWithTag:21];
//    progressView.progress = 0.1;
//    progressView.alpha = 1;
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
//            cellBackgroundView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:cellBackgroundView.bounds] CGPath];
            }
        for (NSUInteger column = 1; column <= 3; column++) {
            NSUInteger num = (row - 1)*3+column;
            if (num > [publisher numberOfIssues]) {
                break;
            }
           
            UIButton * bt = [UIButton buttonWithType:UIButtonTypeCustom];
            bt.tag = [[NSString stringWithFormat:@"1%i",num] integerValue];
            //            bt.adjustsImageWhenHighlighted = NO;
            [bt addTarget:self action:@selector(loadOrReadOrBuy:) forControlEvents:UIControlEventTouchUpInside];
            bt.showsTouchWhenHighlighted = YES;
            
            UIButton *btDel = [UIButton buttonWithType:UIButtonTypeCustom];
            [btDel setBackgroundImage:[UIImage imageNamed:@"delete"] forState:UIControlStateNormal];
            //            btDel.backgroundColor = [UIColor blackColor];
            [btDel addTarget:self action:@selector(deleteIssue:) forControlEvents:UIControlEventTouchUpInside];
            btDel.tag = [[NSString stringWithFormat:@"4%i",num] integerValue];
            NKLibrary *nkLib = [NKLibrary sharedLibrary];
            NKIssue *nkIssue = [nkLib issueWithName:[publisher nameOfIssueAtIndex:(num-1)]];
            if ((nkIssue.status == NKIssueContentStatusAvailable) &&isEdit) {
                //                NSInteger tag = [[NSString stringWithFormat:@"4%i",num] integerValue];
                //                UIButton *btDel = (UIButton *)[m_tableView viewWithTag:tag];
                btDel.enabled = YES;
                btDel.alpha = 1.0;
            }else{
                btDel.alpha = 0.0;
                btDel.enabled = NO;
            }
//            NSLog(@"111111111");
            [publisher setCoverOfIssueAtIndex:(num - 1) completionBlock:^(NSString *filePath) {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    UITableViewCell *cell = [table_ cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
//                    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
//                    NSMutableString * str = [NSMutableString stringWithString:fileName];
//                    NSLog(@"%@",str);
//                    NSUInteger length =  [str length];
//                                        NSLog(@"%d",length);
//                    [str deleteCharactersInRange:NSMakeRange(length - 7, 3)];
//                                        NSLog(@"%@",str);
                    UIImage *image = [UIImage imageWithContentsOfFile:filePath];
//                                        NSLog(@"%@",image);
                    bt.frame = CGRectMake( (column - 1)*256 + 18+5 + (220-image.size.width)/2, 20+(286-image.size.height),image.size.width-10, image.size.height-10);
                    [bt setBackgroundImage:image forState:UIControlStateNormal];
//                    bt.frame.size = image.size
                    btDel.frame = CGRectMake(bt.frame.size.width - 20, -10, 30, 30);

                    [bt addSubview:btDel];

                });
            }];
//            [bt setBackgroundImage:image forState:UIControlStateNormal];
            
            
            UIProgressView *progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
            progressView.frame = CGRectMake((column - 1)*256 + 20, 300, 216, 9);
            progressView.tag = [[NSString stringWithFormat:@"2%i",num] integerValue];
            progressView.alpha = 1;
//            progressView.progress = 0.5;
            
            UIButton *btLoadOrReadOrBuy = [UIButton buttonWithType:UIButtonTypeCustom];
            btLoadOrReadOrBuy.frame = CGRectMake((column - 1)*256 + 74.5, 330, 107, 39);
            [btLoadOrReadOrBuy addTarget:self action:@selector(loadOrReadOrBuy:) forControlEvents:UIControlEventTouchUpInside];
            btLoadOrReadOrBuy.tag = [[NSString stringWithFormat:@"3%i",num] integerValue];
//            btLoadOrReadOrBuy.adjustsImageWhenHighlighted = NO;

//            NSLog(@"bt = %@ btDel = %@",bt.frame,btDel.frame);
            if ([publisher.m_purchasedProducts containsObject:[[publisher issueAtIndex:(num-1)] objectForKey:@"productIdentifier"]]) {
                if(nkIssue.status==NKIssueContentStatusAvailable) {
                    [btLoadOrReadOrBuy setBackgroundImage:[UIImage imageNamed:@"ICON1"] forState:UIControlStateNormal];
                    //                tapLabel.text=@"TAP TO READ";
                    //                tapLabel.alpha=1.0;
                    btLoadOrReadOrBuy.alpha=1.0;
                    progressView.alpha=0.0;
                } else {
                    if(nkIssue.status==NKIssueContentStatusDownloading) {
                        progressView.alpha=1.0;
                        btLoadOrReadOrBuy.alpha=1.0;
                        //                    tapLabel.alpha=0.0;
                        [btLoadOrReadOrBuy setBackgroundImage:[UIImage imageNamed:@"ICON3"] forState:UIControlStateNormal];
                    } else {
                        btLoadOrReadOrBuy.alpha=1.0;
                        progressView.alpha=0.0;
                        [btLoadOrReadOrBuy setBackgroundImage:[UIImage imageNamed:@"ICON3"] forState:UIControlStateNormal];
                        
                        //                    tapLabel.alpha=1.0;
                        //                    tapLabel.text=@"TAP TO DOWNLOAD";
                    }
                    
                }
            }else{
                NSString *price = [[publisher issueAtIndex:(num-1)] objectForKey:@"price"];
                [btLoadOrReadOrBuy setBackgroundImage:[UIImage imageNamed:@"ICON4"] forState:UIControlStateNormal];
                [btLoadOrReadOrBuy setTitle:price forState:UIControlStateNormal];
                btLoadOrReadOrBuy.alpha=1.0;
                progressView.alpha=0.0;
            }

            
//            bt.layer.shadowColor = [UIColor blackColor].CGColor;
//            bt.layer.shadowOffset = CGSizeMake(0, 4);
//            bt.layer.shadowOpacity = 0.5;
//            bt.layer.shadowRadius = 4.0;

            [cell addSubview:bt];
            [cell addSubview:progressView];
            [cell addSubview:btLoadOrReadOrBuy];
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
//        cellBackgroundView.layer.shadowPath = [[UIBezierPath bezierPathWithRect:cellBackgroundView.bounds] CGPath];

    }
    cellBackgroundView.opaque = YES;
    [cell setBackgroundView:cellBackgroundView];
    [cellBackgroundView release];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.opaque = YES;
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    numOfRows = [publisher numberOfIssues]/3;
    if ([publisher numberOfIssues]%3 >0) {
        numOfRows = numOfRows+1;
    }
    if (numOfRows == 2) {
        numOfRows = numOfRows + 1;
    }else if(numOfRows == 1){
        numOfRows = numOfRows + 2;
    }
    return numOfRows+1;
}
#pragma mark - Publisher interaction

-(void)loadIssues {
//    table_.alpha=0.0;
    [self.view addSubview:backView];

    [self.navigationItem setRightBarButtonItem:waitButton];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publisherReady:) name:PublisherDidUpdateNotification object:publisher];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publisherFailed:) name:PublisherFailedUpdateNotification object:publisher];
    [publisher getIssuesList];
//    [publisher requestProducts];
}

-(void)publisherReady:(NSNotification *)not {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PublisherDidUpdateNotification object:publisher];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PublisherFailedUpdateNotification object:publisher];
    [self showIssues];
}

-(void)showIssues {
//    [m_tableView reloadData];
}

-(void)publisherFailed:(NSNotification *)not {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PublisherDidUpdateNotification object:publisher];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PublisherFailedUpdateNotification object:publisher];
    //    NSLog(@"%@",not);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"无法从服务器获取杂志列表"
                                                    message:nil
                                                   delegate:nil
                                          cancelButtonTitle:@"确认"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    [MBProgressHUD hideHUDForView:backView animated:YES];
    [backView removeFromSuperview];
    [self.navigationItem setRightBarButtonItem:refreshButton];
}


#pragma mark - IAP
- (void)restore
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];    
}


- (void)productsLoaded:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    [self.navigationItem setRightBarButtonItem:refreshButton];
    [MBProgressHUD hideHUDForView:backView animated:YES];
    [backView removeFromSuperview];

//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    m_tableView.hidden = FALSE;
    
    [m_tableView reloadData];
    
}

- (void)productPurchased:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
//    NSString *productIdentifier = (NSString *) notification.object;
    //    NSLog(@"Purchased: %@", productIdentifier);
    
    [m_tableView reloadData];
    
}

- (void)productPurchaseFailed:(NSNotification *)notification {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
//    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    SKPaymentTransaction * transaction = (SKPaymentTransaction *) notification.object;
    if (transaction.error.code != SKErrorPaymentCancelled) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                                        message:transaction.error.localizedDescription
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        
        [alert show];
    }
    
}

- (void)timeout {
    
    UIAlertView *aler = [[UIAlertView alloc]initWithTitle:@"网络连接失败"
                                                  message:@"请检查网络后再尝试"
                                                 delegate:nil
                                        cancelButtonTitle:@"确定"
                                        otherButtonTitles: nil];
    [aler show];
    [self.navigationItem setRightBarButtonItem:refreshButton];
    [m_tableView reloadData];

//    m_hud.labelText = @"Timeout!";
//    m_hud.detailsLabelText = @"Please try again later.";
//    m_hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.jpg"]];
//    m_hud.mode = MBProgressHUDModeCustomView;
//    [self performSelector:@selector(dismissHUD:) withObject:nil afterDelay:3.0];
    
}
@end
