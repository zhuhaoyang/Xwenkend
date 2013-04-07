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
        publisher = [Publisher sharedPublisher];
        isEdit = NO;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.title = @"行周末";
    editButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleBordered target:self action:@selector(edit)];
    self.navigationItem.leftBarButtonItem = editButton;
    
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
    m_hud = [MBProgressHUD showHUDAddedTo:backView animated:YES];
    m_hud.labelText = @"Loading comics...";
//    [self.view setBackgroundColor:[UIColor blackColor]];
    refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadIssues)];
    UIActivityIndicatorView *loadingActivity = [[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite] autorelease];
    [loadingActivity startAnimating];
    waitButton = [[UIBarButtonItem alloc] initWithCustomView:loadingActivity];
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

- (void)loadOrRead:(id)sender
{
//    if (m_ReadViewController) {
//        [m_ReadViewController release];
//        m_ReadViewController = nil;
//    }
    UIButton *bt = (UIButton *)sender;
    NSMutableString *str = [NSMutableString stringWithFormat:@"%i",bt.tag];
    [str deleteCharactersInRange:NSMakeRange(0, 1)];
    NSInteger num = [str integerValue] - 1;
    
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
    NKIssue *nkIssue = [nkLib issueWithName:[publisher nameOfIssueAtIndex:num]];
    // NSURL *downloadURL = [nkIssue contentURL];
    if(nkIssue.status==NKIssueContentStatusAvailable) {
        [self readIssue:str];
    } else if(nkIssue.status==NKIssueContentStatusNone) {
        [self downloadIssueAtIndex:num];
    }

    
    
    
    
//    m_hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//    m_hud.labelText = @"加载中...";
//    m_ReadViewController = [[ReadViewController alloc]initWithNibName:@"ReadViewController" bundle:[NSBundle mainBundle] numOfIssues:str];
//    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
//    [self.navigationController setNavigationBarHidden:YES animated:FALSE];
////    [self setWantsFullScreenLayout:YES];
//    
//    [self.navigationController pushViewController:m_ReadViewController animated:YES];
//    [m_ReadViewController release];

//    [MBProgressHUD hideHUDForView:self.view animated:YES];
//    m_hud = nil;
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
        //    [publisher getIssuesList];
        [m_tableView reloadData];
    }
}

// remove all downloaded magazines
- (void)edit {
    if (isEdit) {
        [editButton setTitle:@"编辑"];
    }else{
        [editButton setTitle:@"完成"];
    }
    
    [m_tableView reloadData];
    isEdit = !isEdit;

//    NKLibrary *nkLib = [NKLibrary sharedLibrary];
//    NSLog(@"%@",nkLib.issues);
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

    tag =  [[NSString stringWithFormat:@"1%i", num] integerValue];
    UIButton *bt = (UIButton *)[m_tableView viewWithTag:tag];
    bt.enabled = NO;

    tag =  [[NSString stringWithFormat:@"3%i", num] integerValue];
    UIButton *btLoadOrRead = (UIButton *)[m_tableView viewWithTag:tag];
    btLoadOrRead.enabled = NO;

//    [[cell viewWithTag:103] setAlpha:0.0];
}

-(void)connection:(NSURLConnection *)connection didWriteData:(long long)bytesWritten totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes {
    [self updateProgressOfConnection:connection withTotalBytesWritten:totalBytesWritten expectedTotalBytes:expectedTotalBytes];
}

-(void)connectionDidResumeDownloading:(NSURLConnection *)connection totalBytesWritten:(long long)totalBytesWritten expectedTotalBytes:(long long)expectedTotalBytes {
    NSLog(@"Resume downloading %f",1.f*totalBytesWritten/expectedTotalBytes);
    [self updateProgressOfConnection:connection withTotalBytesWritten:totalBytesWritten expectedTotalBytes:expectedTotalBytes];
}

-(void)connectionDidFinishDownloading:(NSURLConnection *)connection destinationURL:(NSURL *)destinationURL {
    // copy file to destination URL
    NKAssetDownload *dnl = connection.newsstandAssetDownload;
    NKIssue *nkIssue = dnl.issue;
    NSString *contentPath = [publisher downloadPathForIssue:nkIssue];
//    NSError *moveError=nil;
//    NSLog(@"File is being copied to %@",contentPath);
    
//    if([[NSFileManager defaultManager] moveItemAtPath:[destinationURL path] toPath:contentPath error:&moveError]==NO) {
//        NSLog(@"Error copying file from %@ to %@",destinationURL,contentPath);
//    }
//    NSLog(@"Error copying file from %@ to %@",destinationURL,contentPath);
//    NSString *strDestinationURL = [NSString stringWithContentsOfURL:destinationURL encoding:NSUTF8StringEncoding error:&moveError];
//    NSString *strDestinationURL = [NSString stringWithFormat:@"%@",destinationURL];
//    NSString *nameOfZip = [strDestinationURL lastPathComponent];
    NSString *filePath =  [destinationURL path];
//    NSString *strContentPath = [NSString stringWithFormat:@"%@",contentPath];
    
    NSLog( @"download to %@",filePath);
    ZipArchive* za = [[ZipArchive alloc] init];
	if( [za UnzipOpenFile:filePath] )
	{
		BOOL ret = [za UnzipFileTo:contentPath overWrite:YES];
		if( NO==ret )
		{
            NSLog(@"Error unzip!");
		}
		[za UnzipCloseFile];
	}
    
	[za release];
    NSFileManager* fileManager=[NSFileManager defaultManager];
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
//    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"pin.png"];
    BOOL blHave=[[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!blHave) {
        NSLog(@"no  have");
        return ;
    }else {
        NSLog(@" have");
        BOOL blDele= [fileManager removeItemAtPath:filePath error:nil];
        if (blDele) {
            NSLog(@"dele success");
        }else {
            NSLog(@"dele fail");
        }
        
    }
    // update the Newsstand icon
    UIImage *img = [publisher coverImageForIssue:nkIssue];
    if(img) {
        [[UIApplication sharedApplication] setNewsstandIconImage:img];
//        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
    }
    NSInteger num = [[dnl.userInfo objectForKey:@"num"] integerValue];
    
//    NSInteger tag =  [[NSString stringWithFormat:@"2%i", num] integerValue];
//    UIProgressView *progressView = (UIProgressView *)[m_tableView viewWithTag:tag];
//    progressView.alpha=1.0;
//    progressView.progress=1.f*totalBytesWritten/expectedTotalBytes;
    
    NSInteger tag =  [[NSString stringWithFormat:@"1%i", num] integerValue];
    UIButton *bt = (UIButton *)[m_tableView viewWithTag:tag];
    bt.enabled = YES;
    
    tag =  [[NSString stringWithFormat:@"3%i", num] integerValue];
    UIButton *btLoadOrRead = (UIButton *)[m_tableView viewWithTag:tag];
    btLoadOrRead.enabled = YES;

    
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

            }
        for (NSUInteger column = 1; column <= 3; column++) {
            NSUInteger num = (row - 1)*3+column;
            if (num > [publisher numberOfIssues]) {
                break;
            }
            UIButton * bt = [UIButton buttonWithType:UIButtonTypeCustom];
            bt.frame = CGRectMake((column - 1)*256 + 18, 10, 220, 286);
            
//            NSString *str = [[arrIssuesPlist objectAtIndex:(num - 1)] objectForKey:@"cover"];
//            UIImage *image = [UIImage imageNamed:str];
            [publisher setCoverOfIssueAtIndex:(num - 1) completionBlock:^(UIImage *image) {
                dispatch_async(dispatch_get_main_queue(), ^{
//                    UITableViewCell *cell = [table_ cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
//                    UIImageView *imageView = (UIImageView *)[cell viewWithTag:100];
                    [bt setBackgroundImage:image forState:UIControlStateNormal];
                });
            }];
//            [bt setBackgroundImage:image forState:UIControlStateNormal];
            bt.tag = [[NSString stringWithFormat:@"1%i",num] integerValue];
            [bt addTarget:self action:@selector(loadOrRead:) forControlEvents:UIControlEventTouchUpInside];
            
            UIProgressView *progressView = [[UIProgressView alloc]initWithProgressViewStyle:UIProgressViewStyleDefault];
            progressView.frame = CGRectMake((column - 1)*256 + 20, 300, 216, 9);
            progressView.tag = [[NSString stringWithFormat:@"2%i",num] integerValue];
            progressView.alpha = 1;
            progressView.progress = 0.5;
            
            UIButton *btLoadOrRead = [UIButton buttonWithType:UIButtonTypeCustom];
            btLoadOrRead.frame = CGRectMake((column - 1)*256 + 74.5, 330, 107, 39);
            [btLoadOrRead addTarget:self action:@selector(loadOrRead:) forControlEvents:UIControlEventTouchUpInside];
            btLoadOrRead.tag = [[NSString stringWithFormat:@"3%i",num] integerValue];
            
            UIButton *btDel = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btDel.frame = CGRectMake(210, -10, 20, 20);
//            btDel.backgroundColor = [UIColor blackColor];
            [btDel addTarget:self action:@selector(deleteIssue:) forControlEvents:UIControlEventTouchUpInside];
            btDel.tag = [[NSString stringWithFormat:@"4%i",num] integerValue];
            if (isEdit) {
                btDel.alpha = 1.0;
                btDel.enabled = YES;
            }else{
                btDel.alpha = 0.0;
                btDel.enabled = NO;
            }
            [bt addSubview:btDel];
            NKLibrary *nkLib = [NKLibrary sharedLibrary];
            NKIssue *nkIssue = [nkLib issueWithName:[publisher nameOfIssueAtIndex:(num-1)]];

            if(nkIssue.status==NKIssueContentStatusAvailable) {
                [btLoadOrRead setBackgroundImage:[UIImage imageNamed:@"ICON1"] forState:UIControlStateNormal];
//                tapLabel.text=@"TAP TO READ";
//                tapLabel.alpha=1.0;
                btLoadOrRead.alpha=1.0;
                progressView.alpha=0.0;
            } else {
                if(nkIssue.status==NKIssueContentStatusDownloading) {
                    progressView.alpha=1.0;
                    btLoadOrRead.alpha=0.0;
//                    tapLabel.alpha=0.0;
                } else {
                    btLoadOrRead.alpha=1.0;
                    progressView.alpha=0.0;
                    [btLoadOrRead setBackgroundImage:[UIImage imageNamed:@"ICON3"] forState:UIControlStateNormal];

//                    tapLabel.alpha=1.0;
//                    tapLabel.text=@"TAP TO DOWNLOAD";
                }
                
            }

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
}

-(void)publisherReady:(NSNotification *)not {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PublisherDidUpdateNotification object:publisher];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PublisherFailedUpdateNotification object:publisher];
    [self showIssues];
}

-(void)showIssues {
    [self.navigationItem setRightBarButtonItem:refreshButton];
    [MBProgressHUD hideHUDForView:backView animated:YES];
    [backView removeFromSuperview];
    [m_tableView reloadData];
}

-(void)publisherFailed:(NSNotification *)not {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PublisherDidUpdateNotification object:publisher];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PublisherFailedUpdateNotification object:publisher];
    NSLog(@"%@",not);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:@"Cannot get issues from publisher server."
                                                   delegate:nil
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    [MBProgressHUD hideHUDForView:backView animated:YES];
    [backView removeFromSuperview];
    [self.navigationItem setRightBarButtonItem:refreshButton];
}

@end
