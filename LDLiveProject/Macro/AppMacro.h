//
//  AppMacro.h
//  MinFramework
//  app相关的宏定义
//
//  Created by ligh on 14-3-10.
//
//

#ifndef MinFramework_AppMacro_h
#define MinFramework_AppMacro_h

#import "AppDelegate.h"

//获取系统当前版本号
#define kSystemVersion [[UIDevice currentDevice].systemVersion doubleValue]

#define  CLIENT_TYPE_IOS    @"2"
//NSUserDefaults
#define KUserDefaults [NSUserDefaults standardUserDefaults]

//app本地版本
#define Bundle_App_Version      [NSString stringWithFormat:@"%@",[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"]]

//判断设备是否是iphone5
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6p ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
//AppDelegate
#define KAPP_DELEGATE (AppDelegate *)[UIApplication sharedApplication].delegate
#define KAPP_WINDOW   (UIWindow *)[KAPP_DELEGATE window]
//block弱引用
//#define WeakObj(o) __weak typeof(o) weakSelf=self
#define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
#endif
