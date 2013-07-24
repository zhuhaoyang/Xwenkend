//
//  PublicDefine.h
//  excel
//
//  Created by zhuhaoyang on 11-11-8.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

// Log Print  on->1  off->0
#define LOG_STATE 1

#if LOG_STATE
#define LOGS(msg1, ...) NSLog(msg1, ##__VA_ARGS__)
#else
#define LOGS(msg1, ...)
#endif

// Safe Release
#define SAFE_RELEASE(object)\
{\
if (nil != object)\
{\
[object release];\
object = nil;\
}\
}


// Time out setting for Http engine
#define kTimeOutDuration 20


