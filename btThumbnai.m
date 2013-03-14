//
//  btThumbnai.m
//  Xweekend
//
//  Created by Myth on 13-3-7.
//  Copyright (c) 2013年 Myth. All rights reserved.
//

#import "btThumbnai.h"

@implementation btThumbnai
@synthesize dicUserInfo = _dicUserInfo;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _dicUserInfo = [[NSMutableDictionary alloc]initWithCapacity:0];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)setObject:(id)obj forKey:(NSString *)key
{
    [_dicUserInfo setObject:obj forKey:key];
}

- (void)dealloc
{
    [_dicUserInfo release];
    [super dealloc];
}

@end
