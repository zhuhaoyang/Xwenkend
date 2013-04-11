//
//  Publisher.h
//  Newsstand
//
//  Created by Carlo Vigiani on 18/Oct/11.
//  Copyright (c) 2011 viggiosoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NewsstandKit/NewsstandKit.h>
#import "StoreKit/StoreKit.h"

#define kProductsLoadedNotification         @"ProductsLoaded"
#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"

extern  NSString *PublisherDidUpdateNotification;
extern  NSString *PublisherFailedUpdateNotification;

@interface Publisher : NSObject<SKProductsRequestDelegate, SKPaymentTransactionObserver> {
    NSArray *issues;
    
    NSMutableSet * m_productIdentifiers;
    NSArray * m_products;
    NSMutableSet * m_purchasedProducts;
    SKProductsRequest * m_request;

}

@property (nonatomic,readonly,getter = isReady) BOOL ready;
@property (nonatomic,retain) NSArray * m_products;
@property (nonatomic,retain) NSMutableSet *m_purchasedProducts;
@property (nonatomic,assign) NSInteger numOfPage;
+ (Publisher *) sharedPublisher;

-(void)addIssuesInNewsstand;
-(void)getIssuesList;
-(NSInteger)numberOfIssues;
-(NSString *)titleOfIssueAtIndex:(NSInteger)index;
-(NSString *)nameOfIssueAtIndex:(NSInteger)index;
-(void)setCoverOfIssueAtIndex:(NSInteger)index completionBlock:(void(^)(UIImage *img))block;
-(NSURL *)contentURLForIssueWithName:(NSString *)name;
-(NSString *)downloadPathForIssue:(NKIssue *)nkIssue;
-(UIImage *)coverImageForIssue:(NKIssue *)nkIssue;
-(NSDictionary *)issueAtIndex:(NSInteger)index;


- (void)requestProducts;
//- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)buyProductIdentifier:(NSString *)productIdentifier;

@end
