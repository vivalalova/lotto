//
//  VersionServiceManager.h
//  ZWProject
//
//  Created by hdcai on 15/6/11.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

//单例定义
#define AS_SINGLETON( __class ) \
+ (__class *)sharedInstance;

#import <Foundation/Foundation.h>

@interface VersionServiceManager : NSObject

typedef void (^VersionCheckSuccessCallback)(BOOL ishasNew,NSDictionary *dict);
typedef void (^VersionCheckFaildCallback)(NSString *reason);

AS_SINGLETON (VersionServiceManager)

//检测是否有新版本
- (void)isHasNewVersionWithDict:(NSDictionary*)dict;

@end
