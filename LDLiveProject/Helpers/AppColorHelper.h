//
//  AppColorHelper.h
//  Carte
//
//  Created by ligh on 14-7-15.
//
//

#import <Foundation/Foundation.h>


//创建颜色
#define UIColorFromRGBA(r,g,b,a)    [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b)       UIColorFromRGBA(r,g,b,1)
//程序背景色默认
#define UIColorFromRGB_BGColor UIColorFromRGB(245,245,245)


/*
 *首页颜色keys----------------------------------------------------
 */

#define AppColor_Home_Basic_Blue         @"home_basic_blue"
#define AppColor_Home_StatusBarStyle     @"StatusBarStyle"
#define AppColor_Home_NavigationBarTitle @"navigation_bar_title"
#define AppColor_Home_TabBatItemNormal   @"home_tabbarNormal"
#define AppColor_Home_TabBatItemSelect   @"home_tabbarSelect"
//


#define AppColor_Home_NavBg1 @"home_navigation_bar_bg1" //粉红
#define AppColor_Home_NavBg2 @"home_navigation_bar_bg2" //白色

/*
 *内页颜色keys----------------------------------------------------
 */
// 竞猜
#define AppColor_Guess_OneBack @"guess_one_back"
#define AppColor_Guess_TwoBack @"guess_two_back"
#define AppColor_Sendgift_AnthorName @"sendgift_anthorname"

//2.1.2  导航栏中跳转功能
#define AppColor_Navigation_Bar_Function  @"navigation_bar_function"


//15.3.31   转字符串格式
#define StringFormat(a) [NSString stringWithFormat:@"%@",(a)]



//15.4.21  增加tabbar颜色
#define AppColor_tabbar_unselect @"tabbar_unselect"
#define AppColor_tabbar_select @"tabbar_select"



/**
 *  应用程序颜色值
 */

//十六进制颜色值表示
#define ColorForHexKey(key)     [AppColorHelper colorWithHexForKey:key]
#define HomeColorForHexKey(key) [AppColorHelper homeColorWithHexForKey:key]
//状态栏颜色设定
#define kApp_StatusBarStyle [AppColorHelper preferredStatusBarStyle]

@interface AppColorHelper : NSObject

+ (id)shareInstance;

//IOS中十六进制的颜色转换为UIColor
+ (UIColor *)colorWithHexForKey:(NSString *)key;
- (UIColor *)colorWithHexForKey:(NSString *)key;

+ (UIColor *)homeColorWithHexForKey:(NSString *)key;
- (UIColor *)homeColorWithHexForKey:(NSString *)key;

+ (UIStatusBarStyle)preferredStatusBarStyle;

@end
