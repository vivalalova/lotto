//
//  AFRequestManager.h
//  LDLiveProject
//
//  Created by MAC on 16/5/30.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface AFRequestManager : AFHTTPSessionManager
+ (instancetype)sharedManager;

+ (NSURLSessionDataTask *)SafePOST:(NSString *)URLString
                        parameters:(id)parameters
                           success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
                           failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

+ (NSURLSessionDataTask *)SafeGET:(NSString *)URLString
                       parameters:(id)parameters
                          success:(void (^)(NSURLSessionDataTask * task, id responseObject))success
                          failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

+ (void)reset;
@end
