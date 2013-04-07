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
        ready = NO;
        issues = nil;
    }
    return self;
}

-(void)dealloc {
    [issues release];
    [super dealloc];
}

-(void)getIssuesList {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
                   ^{
                       NSArray *tmpIssues = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:@"http://xweekend.b0.upaiyun.com/issues.plist"]];
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
                           NSLog(@"%@",issues);
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
        NSLog(@"nkIssue = %@",nkIssue);
        NSLog(@"status = %i",nkIssue.status);
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
    return [issues objectAtIndex:index];
}

-(NSString *)titleOfIssueAtIndex:(NSInteger)index {
    return [[self issueAtIndex:index] objectForKey:@"title"];
}

-(NSString *)nameOfIssueAtIndex:(NSInteger)index {
   return [[self issueAtIndex:index] objectForKey:@"name"];    
}

-(void)setCoverOfIssueAtIndex:(NSInteger)index  completionBlock:(void(^)(UIImage *img))block {
    
//    NKIssue *nkIssue = [[NKLibrary sharedLibrary] issueWithName:[self nameOfIssueAtIndex:index]];
    
    NSURL *coverURL = [NSURL URLWithString:[[self issueAtIndex:index] objectForKey:@"cover"]];
    NSString *coverFileName = [coverURL lastPathComponent];
//    NSString *coverFilePath = [[self downloadPathForIssue:nkIssue] stringByAppendingPathComponent:coverFileName];

    NSString *coverFilePath = [CacheDirectory stringByAppendingPathComponent:coverFileName];
    UIImage *image = [UIImage imageWithContentsOfFile:coverFilePath];
    if(image) {
        block(image);
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
                       ^{
                           NSData *imageData = [NSData dataWithContentsOfURL:coverURL];
                           UIImage *image = [UIImage imageWithData:imageData];
                           if(image) {
                               [imageData writeToFile:coverFilePath atomically:YES];
                               block(image);
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
    NSLog(@"Content URL for issue with name %@ is %@",name,contentURL);
    return [contentURL autorelease];
}

-(NSString *)downloadPathForIssue:(NKIssue *)nkIssue {
    return [nkIssue.contentURL path];
}

@end
