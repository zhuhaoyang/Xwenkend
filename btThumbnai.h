//
//  btThumbnai.h
//  Xweekend
//
//  Created by Myth on 13-3-7.
//  Copyright (c) 2013年 Myth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface btThumbnai : UIButton
{
    NSMutableDictionary *dicUserInfo;
}

@property(nonatomic,retain) NSMutableDictionary *dicUserInfo;

- (void)setObject:(id)obj forKey:(NSString *)key;

@end
