//
//  VendorMacro.h
//  MinFramework
//  第三方常量
//  Created by ligh on 14-3-10.
//
//

#ifndef MinFramework_VendorMacro_h
#define MinFramework_VendorMacro_h

//极光推送
#import "JPUSHService.h"
#define JPUSH_APPKEY     @"34c4375e8b9e86cc010526d5"
#define JPUSH_CHANNEL_ID @"Publish channel" //默认渠道
#define JPUSH_IsProduction TURE

//友盟
#define UMENG_APPKEY @"577f5d8ee0f55a8f950011f0"

//旧微信
//#define WXAppId         @"wx6f7fb4c6205d71c1"
//#define WXAppSecret     @"b2d61cbcee78040a73d9ef63e6a6e91e"
//新微信
#define WXAppId         @"wx1bd130adcbd0dc7f"
#define WXAppSecret     @"426883298c2402746ca88f3323b9f842"
//更新微信
//#define WXAppId         @"wx502190394e3f01f0"
//#define WXAppSecret     @"bd508ff0becbbc31fde3c26d71bb075a"

#define WXPartnerID     @"1282559201" /** 商家向财付通申请的商家id */
#define WXPackage       @"Sign=WXPay"   /** 商家根据财付通文档填写的数据和签名 */
#define WXPartnerSecret @"Wxerfg12321OILKHksdf987VBFXC3291" //商户API密钥
#import "WXApi.h"
#import "WXApiObject.h"
#import "WXApiManager.h"

//新浪微博相关
#define SinaAppKey        @"3437716477"
#define SinaRedirectURI   @"http://www.golf8.tv/app/user/loginByWeibo"
#import "WeiboSDK.h"
#import "WeiboSDKManager.h"

#define QQAppKey      @"1105539739"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import "TencentOpenApiManager.h"

//提示
#import "MPNotificationView.h"
#endif
