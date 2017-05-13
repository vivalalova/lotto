//
//  WeiboSDKManager.m
//  LDLiveProject
//
//  Created by MAC on 16/8/19.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "WeiboSDKManager.h"
#import "WeiboUser.h"

@interface WeiboSDKManager ()<WeiboSDKDelegate>

@property(nonatomic,assign)BOOL isWeiBoShare;

@end

@implementation WeiboSDKManager
DEF_SINGLETON (WeiboSDKManager)

//注册新浪微博
+ (BOOL)registerSinaApp {
    [WeiboSDK enableDebugMode:YES];
    return [WeiboSDK registerApp:SinaAppKey];
}

#pragma mark -
#pragma mark - HandleOpenURL

//新浪微博
- (BOOL)handleOpenURLSina:(NSURL *)url {
    return [WeiboSDK handleOpenURL:url delegate:self];
}


#pragma mark 微博登陆
- (void)WeiboLoginSuccessCompletion:(WeiboApiManagerSuccessBlock)sucBlock failureCompletion:(WeiboApiManagerFailureBlock)faiBlock{
    _isWeiBoShare=NO;
    WXRelease(_successBlock);
    WXRelease(_failureBlock);
    if (sucBlock) {
        _successBlock  = [sucBlock copy];
    }
    if (faiBlock) {
        _failureBlock  = [faiBlock copy];
    }
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = SinaRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"LoginVC",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         };
    [WeiboSDK sendRequest:request];
}
//微博分享
- (void)WeiboShareWithContent:(NSString *)content info:(NSDictionary *)dic successCompletion:(WeiboApiManagerSuccessBlock)sucBlock failureCompletion:(WeiboApiManagerFailureBlock)faiBlock{
    _isWeiBoShare=YES;
    WXRelease(_successBlock);
    WXRelease(_failureBlock);
    if (sucBlock) {
        _successBlock  = [sucBlock copy];
    }
    if (faiBlock) {
        _failureBlock  = [faiBlock copy];
    }
    WBImageObject *imageObj=[WBImageObject object];
    imageObj.imageData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"user_img"]]];
    WBMessageObject *messageObj=[WBMessageObject message];

    messageObj.text=[NSString stringWithFormat:@"%@>>%@[分享自@高尔夫直播]",[NSString stringWithFormat:@"触手可及，完美挥杆，快来【%@】的直播间围观吧！",dic[@"uname"]],[NSURL URLWithString:[dic objectForKey:@"room_url"]?[dic objectForKey:@"room_url"]:URI_BASE_SERVER]];
    messageObj.imageObject=imageObj;
    WBSendMessageToWeiboRequest *request=[WBSendMessageToWeiboRequest requestWithMessage:messageObj];
    request.userInfo = @{@"SSO_From": @"LoginVC",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         };
    [WeiboSDK sendRequest:request];
}

- (void)WeiboShareWithContent:(NSString *)content image:(UIImage *)image successCompletion:(WeiboApiManagerSuccessBlock)sucBlock failureCompletion:(WeiboApiManagerFailureBlock)faiBlock
{
    _isWeiBoShare=YES;
    WXRelease(_successBlock);
    WXRelease(_failureBlock);
    if (sucBlock) {
        _successBlock  = [sucBlock copy];
    }
    if (faiBlock) {
        _failureBlock  = [faiBlock copy];
    }
    WBImageObject *imageObj=[WBImageObject object];
    if (UIImagePNGRepresentation(image) == nil) {
        imageObj.imageData = UIImageJPEGRepresentation(image, 1);
    } else {
        imageObj.imageData = UIImagePNGRepresentation(image);
    }
    WBMessageObject *messageObj=[WBMessageObject message];
    messageObj.imageObject=imageObj;
    WBSendMessageToWeiboRequest *request=[WBSendMessageToWeiboRequest requestWithMessage:messageObj];
    request.userInfo = @{@"SSO_From": @"LoginVC",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         };
    [WeiboSDK sendRequest:request];
    
}


//#pragma mark -
//#pragma mark - WeiboSDKDelegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request {
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response {
    if (!_isWeiBoShare) {
        if ([response isKindOfClass:WBAuthorizeResponse.class] && response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            _successBlock(YES);
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:[(WBAuthorizeResponse *)response accessToken] forKey:@"access_token"];
            [params setObject:[(WBAuthorizeResponse *)response userID] forKey:@"open_id"];
            [params setObject:@"5" forKey:@"login_type"];
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
        }else{
            _failureBlock(YES);
        }
    }
    if (_isWeiBoShare) {
        //微博分享
        if ([response isKindOfClass:WBSendMessageToWeiboResponse.class]&&response.statusCode == WeiboSDKResponseStatusCodeSuccess) {
            _successBlock(YES);
        }else{
            _failureBlock(YES);
        }
    }
}


@end
