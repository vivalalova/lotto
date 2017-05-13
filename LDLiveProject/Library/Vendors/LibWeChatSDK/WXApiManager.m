//
//  WXApiManager.m
//  Carte
//
//  Created by ligh on 15-4-27.
//
//
#import <UIKit/UIKit.h>
#import "WXApiManager.h"

//#import "ThirdPartyLoginRequest.h"
//#import "UserInfoRequest.h"
//#import "IAPHelper.h"

#define WXRelease(X) if (X != nil) {X = nil;}

@interface WXApiManager () <WXApiDelegate>
{

}
@property(nonatomic,assign)BOOL isBindWX;//判断是绑定微信还是登陆
@end

@implementation WXApiManager

static id instance;
+ (id)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

//微信支付
- (void)wxPayForProduct:(NSDictionary *)product successCompletion:(WXApiManagerSuccessBlock) sucBlock failureCompletion:(WXApiManagerFailureBlock)faiBlock
{
    WXRelease(_successBlock);
    WXRelease(_failureBlock);
    
    if (sucBlock) {
        _successBlock  = [sucBlock copy];
    }
    if (faiBlock) {
        _failureBlock  = [faiBlock copy];
    }

    
    PayReq* req             = [[PayReq alloc] init];
    req.partnerId           = WXPartnerID;
    req.prepayId            = [product objectForKey:@"prepay_id"];
    req.nonceStr            = [self genNonceStr];
    req.timeStamp           = [[self genTimeStamp] intValue];
    req.package             = WXPackage;
    
    // 获取订单返回的sign不能直接使用，需用客户端进行二次签名
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject: WXAppId  forKey:@"appid"];
    [signParams setObject: WXPartnerID  forKey:@"partnerid"];
    [signParams setObject: req.nonceStr    forKey:@"noncestr"];
    [signParams setObject: WXPackage      forKey:@"package"];
    [signParams setObject: [NSString stringWithFormat:@"%u", (unsigned int)req.timeStamp] forKey:@"timestamp"];
    [signParams setObject: req.prepayId      forKey:@"prepayid"];
    
    //生成签名
    NSString *sign  = [self createMd5Sign:signParams];
    
    req.sign                = sign;
    
    [WXApi sendReq:req];
}

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", WXPartnerSecret];
    //得到MD5 sign签名
    NSString *md5Sign =[self md5:contentString];
    
    return md5Sign;
}

#pragma mark - 生成各种参数
// 获取时间戳
- (NSString *)genTimeStamp
{
    return [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
}

/**
 *  获取32位内的随机串, 防重发
 *
 *  注意：商户系统内部的订单号,32个字符内、可包含字母,确保在商户系统唯一
 */
- (NSString *)genNonceStr
{
    return [self md5:[NSString stringWithFormat:@"%d", arc4random() % 10000]];
}

- (NSString *)md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

- (NSString *)stringForValue:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return ((NSString *)value).nonemptyString;
    } else if ([value respondsToSelector:@selector(stringValue)]) {
        return [value stringValue].nonemptyString;
    } else {
        return [value description].nonemptyString;
    }
}

//微信分享
- (void)wxShareForMessage:(WXApiType)wxApiType content:(NSString *)content info:(NSDictionary *)dic successCompletion:(WXApiManagerSuccessBlock) sucBlock failureCompletion:(WXApiManagerFailureBlock)faiBlock {
    WXRelease(_successBlock);
    WXRelease(_failureBlock);
    
    if (sucBlock) {
        _successBlock  = [sucBlock copy];
    }
    if (faiBlock) {
        _failureBlock  = [faiBlock copy];
    }
    //创建分享内容对象
    WXMediaMessage *message=[WXMediaMessage message];
    message.title = [NSString stringWithFormat:@"触手可及，完美挥杆，快来【%@】的直播间围观吧！/来自 秀播高尔夫-随时随地，享受高尔夫！",dic[@"uname"]];
    UIImage *image1=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[dic objectForKey:@"user_img"]]]];
    UIImage *image=[self imageWithImage:image1 scaledToSize:CGSizeMake(50, 50)];
    message.thumbData=UIImageJPEGRepresentation(image, 0.5);
    //创建对媒体对象
    WXWebpageObject *webObj=[WXWebpageObject object];
    webObj.webpageUrl=[dic objectForKey:@"room_url"]?[dic objectForKey:@"room_url"]:URI_BASE_SERVER;
    message.mediaObject=webObj;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.message=message;
    if (wxApiType == WXApiTypeSceneTimeline) {
        req.scene = WXSceneTimeline;
    } else if (wxApiType == WXApiTypeWXSceneSession) {
        req.scene = WXSceneSession;
    }
    [WXApi sendReq:req];
}
//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    CGSize size=CGSizeMake(newSize.width*2, newSize.height*2);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)wxShareForMessage:(WXApiType)wxApiType content:(NSString *)content image:(UIImage *)image successCompletion:(WXApiManagerSuccessBlock) sucBlock failureCompletion:(WXApiManagerFailureBlock)faiBlock
{
    WXRelease(_successBlock);
    WXRelease(_failureBlock);
    
    if (sucBlock) {
        _successBlock  = [sucBlock copy];
    }
    if (faiBlock) {
        _failureBlock  = [faiBlock copy];
    }
    //创建分享内容对象
    WXMediaMessage *message=[WXMediaMessage message];

    //创建对媒体对象
    WXImageObject *imgObj=[WXImageObject object];
    if (UIImagePNGRepresentation(image) == nil) {
        imgObj.imageData = UIImageJPEGRepresentation(image, 1);
    } else {
        imgObj.imageData = UIImagePNGRepresentation(image);
    }
    message.mediaObject=imgObj;
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.message=message;
    //    req.openID = WXAppId;
    req.scene = WXSceneTimeline;

    [WXApi sendReq:req];
}


//微信登陆
- (void)wxLoginSuccessCompletion:(WXApiManagerSuccessBlock)sucBlock failureCompletion:(WXApiManagerFailureBlock)faiBlock{
    _isBindWX=NO;
    WXRelease(_successBlock);
    WXRelease(_failureBlock);
    if (sucBlock) {
        _successBlock  = [sucBlock copy];
    }
    if (faiBlock) {
        _failureBlock  = [faiBlock copy];
    }
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ]init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"wechat_sdk_demo_test" ;
//    req.openID = WXAppId;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}
//微信绑定
- (void)wxBindSuccessCompletion:(WXApiManagerSuccessBlock)sucBlock failureCompletion:(WXApiManagerFailureBlock)faiBlock accessToken:(WXAccessToken)tokenBlock{
    _isBindWX=YES;
    WXRelease(_successBlock);
    WXRelease(_failureBlock);
    WXRelease(_accessTokenBlock);
    if (sucBlock) {
        _successBlock  = [sucBlock copy];
    }
    if (faiBlock) {
        _failureBlock  = [faiBlock copy];
    }
    if (tokenBlock) {
        _accessTokenBlock=[tokenBlock copy];
    }
    //构造SendAuthReq结构体
    SendAuthReq* req =[[SendAuthReq alloc ]init];
    req.scope = @"snsapi_userinfo" ;
    req.state = @"wechat_sdk_demo_test" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}
#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp*)resp
{
    if (resp.type==0&&resp.errCode==0) {
        _successBlock(YES);
        // 支付成功
//        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:nil];
    }
    if (resp.type==0&&resp.errCode!=0) {
        _failureBlock(YES);
        // 支付失败
//        [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:nil];
    }
    if ([resp isKindOfClass:[SendAuthResp class]]) {
        [self getAccess_tokenWithCode:[(SendAuthResp *)resp code]];
    }
}

-(void)getAccess_tokenWithCode:(NSString *)code  {
    //https://api.weixin.qq.com/sns/oauth2/access_token?appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code
    
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAppId,WXAppSecret,code];
    
    @try {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSURL *zoneUrl = [NSURL URLWithString:url];
            NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
            NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (data) {
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                    NSLog(@"dic:%@",dic);
                    if (!_isBindWX) {
                        [self sendRequestWithAccessToken:[dic objectForKey:@"access_token"] withOpenid:[dic objectForKey:@"openid"]];
                    }else{
                        _isBindWX=NO;
                        _accessTokenBlock([dic objectForKey:@"unionid"]);
                    }
                }
            });
        });
    } @catch (NSException *exception) {
        
    } @finally {
        
    }
}
-(void)sendRequestWithAccessToken:(NSString*)accessToken withOpenid:(NSString*)openId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([NSString isBlankString:accessToken] || [NSString isBlankString:openId]) {
        [MPNotificationView notifyWithText:@""
                                    detail:@"您取消了微信登录!"
                             andTouchBlock:^(MPNotificationView *notificationView) {
                                 NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                             }];
        return;
    }
    
    [params setObject:accessToken forKey:@"access_token"];
    [params setObject:openId forKey:@"open_id"];
    [params setObject:@"3" forKey:@"login_type"];
    
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

- (void)onReq:(BaseReq *)req
{
    
}

#pragma mark - 微信回调

//处理微信回调
- (BOOL)handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

@end
