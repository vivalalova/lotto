//
//  WeiboSDKManager.h
//  LDLiveProject
//
//  Created by MAC on 16/8/19.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>


//处理结果
typedef void(^WeiboApiManagerSuccessBlock)(BOOL);
typedef void(^WeiboApiManagerFailureBlock)(BOOL);

@interface WeiboSDKManager : NSObject

@property (copy,nonatomic) WeiboApiManagerSuccessBlock successBlock;
@property (copy,nonatomic) WeiboApiManagerFailureBlock failureBlock;
+ (WeiboSDKManager *)sharedInstance;

//新浪微博
+ (BOOL)registerSinaApp;                //注册sinaweibo
- (BOOL)handleOpenURLSina:(NSURL *)url; //处理新浪微博回调

//微博登陆
- (void)WeiboLoginSuccessCompletion:(WeiboApiManagerSuccessBlock)sucBlock failureCompletion:(WeiboApiManagerFailureBlock)faiBlock;
//微博分享
- (void)WeiboShareWithContent:(NSString *)content info:(NSDictionary *)dic successCompletion:(WeiboApiManagerSuccessBlock)sucBlock failureCompletion:(WeiboApiManagerFailureBlock)faiBlock;
- (void)WeiboShareWithContent:(NSString *)content image:(UIImage *)image successCompletion:(WeiboApiManagerSuccessBlock)sucBlock failureCompletion:(WeiboApiManagerFailureBlock)faiBlock;

@end
