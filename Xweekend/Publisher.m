//
//  Publisher.m
//  Newsstand
//
//  Created by Carlo Vigiani on 18/Oct/11.
//  Copyright (c) 2011 viggiosoft. All rights reserved.
//

#import "Publisher.h"
#import <NewsstandKit/NewsstandKit.h>
static Publisher *instance = nil;

NSString *PublisherDidUpdateNotification = @"PublisherDidUpdate";
NSString *PublisherFailedUpdateNotification = @"PublisherFailedUpdate";

@interface Publisher ()



@end

@implementation Publisher
@synthesize m_products = _m_products;
@synthesize m_purchasedProducts = _m_purchasedProducts;
@synthesize ready;
+ (Publisher *) sharedPublisher
{
	if (nil == instance)
	{
		instance = [[self alloc] init];
	}
	return instance;
}

-(id)init {
    self = [super init];
    if(self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        ready = NO;
        issues = nil;
//        isSubscription = NO;
        
    }
    return self;
}

-(void)dealloc {
    [issues release];
    [m_productIdentifiers release];
//    [_m_products release];
    [_m_purchasedProducts release];
//    [m_request release];
        [m_productIdentifiers release];
    [super dealloc];
}

- (BOOL)isSubscription
{
    BOOL isSubscription = [[NSUserDefaults standardUserDefaults] boolForKey:kProductIdentifier1Year];
//    NSLog(@"isSubscription = %i",isSubscription);
    return isSubscription;
//    return isSubscription;
}

-(void)getIssuesList {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                   ^{
                       NSArray *tmpIssues = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:@"http://xweekend.b0.upaiyun.com/test.plist"]];
//                       NSArray *tmpIssues = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:@"http://xweekend.b0.upaiyun.com/issue.plist"]];
//                       NSDictionary *dicPlist = [NSDictionary dictionaryWithContentsOfURL:[NSURL URLWithString:@"http://xweekend.b0.upaiyun.com/issue.plist"]];
                       if(!tmpIssues) {
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [[NSNotificationCenter defaultCenter] postNotificationName:PublisherFailedUpdateNotification object:self];
                           });
                          
                       } else {
                           if(issues) {
                               [issues release];
                           }
                           
                           
//                           NSString *path = [[NSBundle mainBundle] pathForResource:@"issues" ofType:@"plist"];
//                           issues = [[NSArray alloc]initWithContentsOfFile:path];

                           
                           issues = [[NSArray alloc] initWithArray:tmpIssues];
                           ready = YES;
                           [self addIssuesInNewsstand];
                           //    NSLog(@"%@",issues);
                           
                           // Store product identifiers
                           if (m_productIdentifiers) {
                               [m_productIdentifiers release];
                           }
                           m_productIdentifiers = [[NSMutableSet alloc]init];
                           for (NSDictionary *dic in issues) {
                               [m_productIdentifiers addObject:[dic objectForKey:@"productIdentifier"]];
                           }
                           // Check for previously purchased products
                           NSMutableSet * purchasedProducts = [NSMutableSet set];
                           for (NSString * productIdentifier in m_productIdentifiers) {
                               BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
                               if (productPurchased) {
                                   [purchasedProducts addObject:productIdentifier];
                                   //    NSLog(@"Previously purchased: %@", productIdentifier);
                               }
                               //    NSLog(@"Not purchased: %@", productIdentifier);
                           }
                           self.m_purchasedProducts = purchasedProducts;

                           [self requestProducts];
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               [[NSNotificationCenter defaultCenter] postNotificationName:PublisherDidUpdateNotification object:self];
                           });
                       }
                   });
}

-(void)addIssuesInNewsstand {
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
    [issues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *name = [(NSDictionary *)obj objectForKey:@"name"];
        NKIssue *nkIssue = [nkLib issueWithName:name];
        if(!nkIssue) {
            nkIssue = [nkLib addIssueWithName:name date:[(NSDictionary *)obj objectForKey:@"date"]];
            
        }
        //    NSLog(@"nkIssue = %@",nkIssue);
        //    NSLog(@"status = %i",nkIssue.status);
    }];
}

-(NSInteger)numberOfIssues {
    if([self isReady] && issues) {
        return [issues count];
    } else {
        return 0;
    }
}

-(NSDictionary *)issueAtIndex:(NSInteger)index {
//    NSLog(@"index = %d  dic = %@",index,[issues objectAtIndex:index]);
    return [issues objectAtIndex:index];
}

//-(NSString *)titleOfIssueAtIndex:(NSInteger)index {
//    return [[self issueAtIndex:index] objectForKey:@"title"];
//}

-(NSString *)nameOfIssueAtIndex:(NSInteger)index {
   return [[self issueAtIndex:index] objectForKey:@"name"];    
}

- (BOOL)isRetina
{
    // 需要#import "sys/utsname.h"
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];

    if ([deviceString isEqualToString:@"iPad3,1"])      return YES;
    if ([deviceString isEqualToString:@"iPad3,2"])      return YES;
    if ([deviceString isEqualToString:@"iPad3,3"])      return YES;
    if ([deviceString isEqualToString:@"iPad3,4"])      return YES;
    if ([deviceString isEqualToString:@"iPad3,5"])      return YES;
    if ([deviceString isEqualToString:@"iPad3,6"])      return YES;
//    NSLog(@"NOTE: Unknown device type: %@", deviceString);
    return NO;
}

-(void)setCoverOfIssueAtIndex:(NSInteger)index  completionBlock:(void(^)(NSString *fileName))block {
    
//    NKIssue *nkIssue = [[NKLibrary sharedLibrary] issueWithName:[self nameOfIssueAtIndex:index]];
    NSURL *coverURL;
    NSString *coverFileName;
    NSString *coverFilePath;
    NSMutableString *returnPath;
//    NSLog(@"%d",[self isRetina]);
    if ([self isRetina]) {
//    if (1) {
        isRetina = YES;
        coverURL = [NSURL URLWithString:[[self issueAtIndex:index] objectForKey:@"cover@2x"]];
        coverFileName = [coverURL lastPathComponent];
        coverFilePath = [CacheDirectory stringByAppendingPathComponent:coverFileName];
        NSUInteger length = [coverFilePath length];
        returnPath = [NSMutableString stringWithString:coverFilePath];
        [returnPath deleteCharactersInRange:NSMakeRange(length - 7, 3)];
    }else{
        isRetina = NO;
        coverURL = [NSURL URLWithString:[[self issueAtIndex:index] objectForKey:@"cover"]];
        coverFileName = [coverURL lastPathComponent];
        coverFilePath = [CacheDirectory stringByAppendingPathComponent:coverFileName];
        returnPath = [NSMutableString stringWithString:coverFilePath];
    }

//    NSString *coverFilePath = [[self downloadPathForIssue:nkIssue] stringByAppendingPathComponent:coverFileName];

    UIImage *image = [UIImage imageWithContentsOfFile:coverFilePath];
//    NSLog(@"%@",coverFilePath);
    if(image) {
        block(returnPath);
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
                       ^{
                           NSData *imageData = [NSData dataWithContentsOfURL:coverURL];
                           UIImage *image = [UIImage imageWithData:imageData];
                           if(image) {
                               [imageData writeToFile:coverFilePath atomically:YES];
                               block(returnPath);
                           }
                       });
    }
}

-(UIImage *)coverImageForIssue:(NKIssue *)nkIssue {
    NSString *name = nkIssue.name;
    for(NSDictionary *issueInfo in issues) {
        if([name isEqualToString:[issueInfo objectForKey:@"name"]]) {
            NSString *coverPath = [issueInfo objectForKey:@"cover"];
            NSString *coverName = [coverPath lastPathComponent];
//            NSString *coverFilePath = [[self downloadPathForIssue:nkIssue] stringByAppendingPathComponent:coverName];
            NSString *coverFilePath = [CacheDirectory stringByAppendingPathComponent:coverName];
            UIImage *image = [UIImage imageWithContentsOfFile:coverFilePath];
            return image;
        }
    }
    return nil;
}

-(NSURL *)contentURLForIssueWithName:(NSString *)name {
    __block NSURL *contentURL=nil;
    [issues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *aName = [(NSDictionary *)obj objectForKey:@"name"];
        if([aName isEqualToString:name]) {
            contentURL = [[NSURL URLWithString:[(NSDictionary *)obj objectForKey:@"contentUrl"]] retain];
            *stop=YES;
        }
    }];
    //    NSLog(@"Content URL for issue with name %@ is %@",name,contentURL);
    return [contentURL autorelease];
}

-(NSString *)downloadPathForIssue:(NKIssue *)nkIssue {
    return [nkIssue.contentURL path];
}

#pragma mark - IAP


- (void)requestProducts {
    if (m_request) {
        [m_request release];
    }
    m_request = [[SKProductsRequest alloc] initWithProductIdentifiers:m_productIdentifiers];
    m_request.delegate = self;
    [m_request start];
//    [self performSelector:@selector(timeout) withObject:nil afterDelay:3.0];
//    timer = [NSTimer scheduledTimerWithTimeInterval: 10.0
//                                     target: self
//                                   selector: @selector(timeout)
//                                   userInfo: nil repeats: NO];

    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSelector:@selector(timeout) withObject:nil afterDelay:15.0];
    });
    
}

- (void)timeout
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timeout" object:self];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
    });

//    [timer invalidate];
//    //    NSLog(@"Received products results...");
//    //    NSLog(@"%@",response.products);
    if (_m_products) {
        [_m_products release];
    }
    _m_products = [[NSArray alloc ]initWithArray:response.products];
//    [m_request release];
    for (SKProduct * obj in _m_products) {
        for(NSMutableDictionary *issueInfo in issues) {
            if([obj.productIdentifier isEqualToString:[issueInfo objectForKey:@"productIdentifier"]]) {
//                float price = ;
                [issueInfo setObject:[NSString stringWithFormat:@"%.2f￥",[obj.price floatValue]]forKey:@"price"];
            }
        }

//        //    NSLog(@"productIdentifier = %@",obj.productIdentifier);
//        //    NSLog(@"localizedDescription = %@",obj.localizedDescription);
//        //    NSLog(@"downloadable = %i",obj.downloadable);
//        //    NSLog(@"downloadContentVersion = %@",obj.downloadContentVersion);
//        //    NSLog(@"localizedTitle = %@",obj.localizedTitle);
//        //    NSLog(@"price = %@",obj.price);
//        //    NSLog(@"priceLocale = %@",obj.priceLocale);
//        //    NSLog(@"localizedTitle = %@",obj.localizedTitle);
    }
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_m_products];
}

//- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers {
//- (id)init{
//    if ((self = [super init])) {
//        
//        
//        // Store product identifiers
//        m_productIdentifiers = [[NSSet alloc]init];
//        
//        // Check for previously purchased products
//        NSMutableSet * purchasedProducts = [NSMutableSet set];
//        for (NSString * productIdentifier in m_productIdentifiers) {
//            BOOL productPurchased = [[NSUserDefaults standardUserDefaults] boolForKey:productIdentifier];
//            if (productPurchased) {
//                [purchasedProducts addObject:productIdentifier];
//                //    NSLog(@"Previously purchased: %@", productIdentifier);
//            }
//            //    NSLog(@"Not purchased: %@", productIdentifier);
//        }
//        self.m_purchasedProducts = purchasedProducts;
//        
//    }
//    return self;
//}

- (void)recordTransaction:(SKPaymentTransaction *)transaction {
//    if ([transaction.payment.productIdentifier isEqualToString:kProductIdentifier1Year]) {
//        isSubscription = YES;
//        NSLog(@"isSubscription = %i",isSubscription);
//    }
//    NSLog(@"isSubscription = %i",isSubscription);
    // Optional: Record the transaction on the server side...
    if (transaction.transactionState == SKPaymentTransactionStatePurchased) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:transaction.transactionIdentifier];
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"订阅成功"
//                                                       message:nil
//                                                      delegate:nil
//                                             cancelButtonTitle:@"确认"
//                                             otherButtonTitles: nil];
//        [alert show];
    }else if(transaction.transactionState == SKPaymentTransactionStateRestored){
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:transaction.originalTransaction.payment.productIdentifier];

    }
}

- (void)provideContent:(NSString *)productIdentifier {
//    NSLog(@"%@",productIdentifier);
    //    NSLog(@"Toggling flag for: %@", productIdentifier);
    if (productIdentifier) {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:productIdentifier];
        [self.m_purchasedProducts addObject:productIdentifier];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
}

- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    
    //    NSLog(@"completeTransaction...");
    
    [self recordTransaction: transaction];
    [self provideContent: transaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    
    //    NSLog(@"restoreTransaction...");

    [self recordTransaction: transaction];
    [self provideContent: transaction.originalTransaction.payment.productIdentifier];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
//    NSLog(@"error = %i",transaction.error.code);
//    NSLog(@"state = %i",transaction.transactionState);
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        //    NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
//        NSLog(@"transactionState = %i",transaction.transactionState);
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
                [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void)buyProductIdentifier:(NSString *)productIdentifier {
    
    //    NSLog(@"Buying %@...", productIdentifier);
    
    //    SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
    //    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    SKMutablePayment *payment = [[SKMutablePayment alloc] init];
    payment.productIdentifier = productIdentifier;
    payment.quantity = 1;
    [[SKPaymentQueue defaultQueue] addPayment:payment];
    [payment release];
}


@end
