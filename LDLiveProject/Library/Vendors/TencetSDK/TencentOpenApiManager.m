//
//  TencentOpenApiManager.m
//  HDHLProject
//
//  Created by Mac on 15/7/2.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "TencentOpenApiManager.h"

#define QQRelease(X) if (X != nil) {X = nil;}

@interface TencentOpenApiManager () <TencentApiInterfaceDelegate, TencentSessionDelegate,QQApiInterfaceDelegate> {

}
@end

@implementation TencentOpenApiManager

static id instance;
+ (id)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:nil] init];
    });
    return instance;
}
-(id)init
{
     _oauth =  [[TencentOAuth alloc] initWithAppId:QQAppKey
                                               andDelegate:self];
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self shareManager];
}

- (BOOL)handleOpenURL:(NSURL *)url {
    if ([TencentOAuth HandleOpenURL:url]) {
        return YES;
    } else if ([url.absoluteString hasPrefix:@"tencent"]) {
        [QQApiInterface handleOpenURL:url delegate:self];
        return YES;
    } else {
        return NO;
    }
    return YES;
}

+ (id)registerApp:(NSString *)appId {
    return [[TencentOAuth alloc] init];
}
//登陆
-(void)qqLoginWithSuccessCompletion:(TencentQQSuccessBlock) sucBlock failureCompletion:(TencentQQFailureBlock)faiBlock
{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            nil];
    [self.oauth authorize:permissions];
    WXRelease(_successBlock);
    WXRelease(_failureBlock);
    
    if (sucBlock) {
        _successBlock  = [sucBlock copy];
    }
    if (faiBlock) {
        _failureBlock  = [faiBlock copy];
    }

}
//分享
-(void)qqShareWithType:(NSInteger)shareType content:(NSString *)content info:(NSDictionary *)dic   successCompletion:(TencentQQSuccessBlock) sucBlock failureCompletion:(TencentQQFailureBlock)faiBlock{
    WXRelease(_successBlock);
    WXRelease(_failureBlock);
    
    if (sucBlock) {
        _successBlock  = [sucBlock copy];
    }
    if (faiBlock) {
        _failureBlock  = [faiBlock copy];
    }
    NSURL *url;
    if (![NSString isBlankString:[dic objectForKey:@"room_url"]]) {
        url = [NSURL URLWithString:[dic objectForKey:@"room_url"]];
    }else{
        url = [NSURL URLWithString:URI_BASE_SERVER];
    }
    
    QQApiURLObject *urlObject=[QQApiURLObject objectWithURL:url title:[NSString stringWithFormat:@"触手可及，完美挥杆，快来【%@】的直播间围观吧！/来自 秀播高尔夫-随时随地，享受高尔夫！",dic[@"uname"]] description:@"" previewImageData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"user_img"]]] targetContentType:(QQApiURLTargetTypeNews)];
    SendMessageToQQReq *req=[SendMessageToQQReq reqWithContent:urlObject];
    if(shareType==0){
        QQApiSendResultCode send=[QQApiInterface sendReq:req];
    }else{
        QQApiSendResultCode send=[QQApiInterface SendReqToQZone:req];
    }
}
/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp{
    if ([resp isKindOfClass:[SendMessageToQQResp class]]) {
        if ([resp.result isEqualToString:@"0"]) {
            _successBlock(YES);
        }else{
            _failureBlock(YES);
        }
    }
}
- (void)handleQQSendResult:(QQApiSendResultCode)sendResult {
    switch (sendResult) {
        case EQQAPIQQNOTINSTALLED: {
            [MPNotificationView notifyWithText:@""
                                        detail:@"尚未安装手机QQ客户端."
                                 andTouchBlock:^(MPNotificationView *notificationView) {
                                     NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                                 }];
            break;
        } default: {
            [MPNotificationView notifyWithText:@""
                                        detail:@"发送失败."
                                 andTouchBlock:^(MPNotificationView *notificationView) {
                                     NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                                 }];
            break;
        }
    }
}

- (void)tencentDidLogin {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:_oauth.accessToken forKey:@"access_token"];
    [params setObject:_oauth.openId forKey:@"open_id"];
    [params setObject:@"4" forKey:@"login_type"];
    _successBlock(YES);
    
    [AFRequestManager SafePOST:URI_ThirdLogin parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *responseDict = (NSDictionary*)responseObject;
        if ([responseDict[@"status"] intValue] == 200) {
            NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
            NSString *tokenStr = responseDict[@"data"][@"token"];
            [paramToken setObject:tokenStr forKey:@"token"];
            [AFRequestManager SafeGET:URI_GetInfo parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([((NSDictionary*)responseObject)[@"status"] intValue] == 200) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:((NSDictionary*)responseObject)[@"data"]];
                    [dict setObject:tokenStr forKey:@"token"];
                    [dict setObject:tokenStr forKey:@"currentToken"];
                    UserModel *userModel = [[UserModel alloc]initWithDictionary:dict error:nil];
                    [AccountHelper saveUserInfo:userModel];
                    [JPUSHService setAlias:User_Id callbackSelector:nil object:self];
                    NSDictionary *loginDict = [NSDictionary dictionaryWithObject:@"1" forKey:@"LoginSuccess"];
                    [[NSNotificationCenter defaultCenter]postNotificationName:kLoginOnceMoreNotification object:loginDict];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSDictionary *loginDict = [NSDictionary dictionaryWithObject:@"0" forKey:@"LoginSuccess"];
                [[NSNotificationCenter defaultCenter]postNotificationName:kLoginOnceMoreNotification object:loginDict];
                [MPNotificationView notifyWithText:@""
                                            detail:@"登录失败,请重新尝试."
                                     andTouchBlock:^(MPNotificationView *notificationView) {
                                         NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                                     }];
            }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MPNotificationView notifyWithText:@""
                                    detail:@"登录失败,请重新尝试."
                             andTouchBlock:^(MPNotificationView *notificationView) {
                                 NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                             }];
        NSDictionary *loginDict = [NSDictionary dictionaryWithObject:@"0" forKey:@"LoginSuccess"];
        [[NSNotificationCenter defaultCenter]postNotificationName:kLoginOnceMoreNotification object:loginDict];
    }];
    
}

#pragma mark -
#pragma mark - TencentSessionDelegate

- (void)tencentDidLogout {

}

#pragma mark -
#pragma mark - TencentLoginDelegate

/**
 * 登录失败后的回调
 * param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled {
    _failureBlock(YES);
    if (cancelled){
        [MPNotificationView notifyWithText:@""
                                    detail:@"您取消了QQ登录!"
                                andTouchBlock:^(MPNotificationView *notificationView) {
                                    NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                                }];
    }else{
        [MPNotificationView notifyWithText:@""
                                    detail:@"登录失败"
                                andTouchBlock:^(MPNotificationView *notificationView) {
                                    NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                                }];
    }
}

- (void)tencentDidNotNetWork {
    [MPNotificationView notifyWithText:@""
                                detail:@"无网络连接,请检查网络."
                         andTouchBlock:^(MPNotificationView *notificationView) {
                             NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                         }];
}

@end
