//
//  TencentOpenApiManager.h
//  HDHLProject
//
//  Created by Mac on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#define WXRelease(X) if (X != nil) {X = nil;}

//处理结果
typedef void(^TencentQQSuccessBlock)(BOOL);
typedef void(^TencentQQFailureBlock)(BOOL);

@interface TencentOpenApiManager : NSObject
@property (copy,nonatomic) TencentQQSuccessBlock successBlock;
@property (copy,nonatomic) TencentQQFailureBlock failureBlock;
@property (nonatomic, retain)TencentOAuth *oauth;

+ (id)shareManager;

//注册QQ
+ (id)registerApp:(NSString *)appId;

//处理腾讯QQ回调
- (BOOL)handleOpenURL:(NSURL *)url;
//登陆
-(void)qqLoginWithSuccessCompletion:(TencentQQSuccessBlock) sucBlock failureCompletion:(TencentQQFailureBlock)faiBlock;
//分享
-(void)qqShareWithType:(NSInteger)shareType content:(NSString *)content info:(NSDictionary *)dic   successCompletion:(TencentQQSuccessBlock) sucBlock failureCompletion:(TencentQQFailureBlock)faiBlock;
@end
