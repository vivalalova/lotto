//
//  WXApiManager.h
//  Carte
//
//  Created by ligh on 15-4-27.
//
//

#import <Foundation/Foundation.h>
#import "WXApi.h"
#import "WXApiObject.h"

typedef NS_ENUM(NSInteger, WXApiType)
{
    WXApiTypeSceneTimeline  = 1,//微信朋友圈
    WXApiTypeWXSceneSession = 2,//微信好友
};

//处理结果
typedef void(^WXApiManagerSuccessBlock)(BOOL);
typedef void(^WXApiManagerFailureBlock)(BOOL);
typedef void(^WXAccessToken)(NSString *);
@interface WXApiManager : NSObject

@property (copy,nonatomic) WXApiManagerSuccessBlock successBlock;
@property (copy,nonatomic) WXApiManagerFailureBlock failureBlock;
@property (copy,nonatomic) WXAccessToken accessTokenBlock;
+ (id)shareManager;

//微信支付
- (void)wxPayForProduct:(NSDictionary *)product successCompletion:(WXApiManagerSuccessBlock) sucBlock failureCompletion:(WXApiManagerFailureBlock)faiBlock;

//微信分享
- (void)wxShareForMessage:(WXApiType)wxApiType content:(NSString *)content info:(NSDictionary *)dic successCompletion:(WXApiManagerSuccessBlock) sucBlock failureCompletion:(WXApiManagerFailureBlock)faiBlock;
- (void)wxShareForMessage:(WXApiType)wxApiType content:(NSString *)content image:(UIImage *)image successCompletion:(WXApiManagerSuccessBlock) sucBlock failureCompletion:(WXApiManagerFailureBlock)faiBlock;

//处理微信回调
- (BOOL)handleOpenURL:(NSURL *)url;
//微信登陆
- (void)wxLoginSuccessCompletion:(WXApiManagerSuccessBlock)sucBlock failureCompletion:(WXApiManagerFailureBlock)faiBlock;
//微信绑定
- (void)wxBindSuccessCompletion:(WXApiManagerSuccessBlock)sucBlock failureCompletion:(WXApiManagerFailureBlock)faiBlock accessToken:(WXAccessToken)accessTokenBlock;
@end
