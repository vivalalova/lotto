//
//  AppDelegate.m
//  LDLiveProject
//
//  Created by MAC on 16/5/30.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "AppDelegate.h"
#import "LLTabBar.h"
#import "LLTabBarItem.h"
#import "UMMobClick/MobClick.h"
#import "Reachability.h"

#import "LeftVC.h"
#import "RightVC.h"
#import "LiveVC.h"
#import "LoginVC.h"
#import "AnchorProVC.h"
#import "UserTVInfoModel.h"

@interface AppDelegate ()<LLTabBarDelegate,AnchorProVCDelegate>
//网络状态改变
@property (nonatomic, strong) Reachability *routerReachability;
@end

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabbar;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self setJPUSHServiceWithOptions:launchOptions];
#pragma mark  设置statusbar背景色透明
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    if (![AccountHelper isLogin]) {
        [self showLoginViewController];
    }else{
        [self initRootViewControllers];
    }
    [self.window makeKeyAndVisible];
    /////
    [WXApi registerApp:WXAppId];
    [TencentOpenApiManager registerApp:QQAppKey];
    [WeiboSDK registerApp:SinaAppKey];
    /////
    [self getIndexTextRequest];
    //获取未读消息数
    [[MessageHelper shareInstance]getTotalNotReadRequest];
    UMConfigInstance.appKey = UMENG_APPKEY;
    [MobClick startWithConfigure:UMConfigInstance];
    
    [self appleReachabilityTest];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [application setApplicationIconBadgeNumber:0];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark 推送
- (void)setJPUSHServiceWithOptions:(NSDictionary *)launchOptions
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_APPKEY channel:JPUSH_CHANNEL_ID apsForProduction:YES];
}

//消息推送
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    [JPUSHService registerDeviceToken:deviceToken];
    if ([AccountHelper isLogin]) {
        NSLog(@"---_%@",User_Id);
        [JPUSHService setAlias:User_Id callbackSelector:nil object:self];
    }else{
        [JPUSHService setAlias:@"zhibotv" callbackSelector:nil object:self];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark  第三方登录分享
- (BOOL)application:(UIApplication *)application handleOpenURL:(nonnull NSURL *)url
{
    if ([[WXApiManager shareManager] handleOpenURL:url]) {
        return YES;
    }
    if ([[TencentOpenApiManager shareManager] handleOpenURL:url]) {
        return YES;
    }
    if ([[WeiboSDKManager sharedInstance] handleOpenURLSina:url]) {
        return YES;
    }
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    if ([[WXApiManager shareManager] handleOpenURL:url]) {
        return YES;
    }
    if ([[TencentOpenApiManager shareManager] handleOpenURL:url]) {
        return YES;
    }
    if ([[WeiboSDKManager sharedInstance] handleOpenURLSina:url]) {
        return YES;
    }
    return YES;
}
#pragma mark 全局控制禁止转屏
- (NSUInteger)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma customActions
- (void)initRootViewControllers
{
    self.tabbar = [[UITabBarController alloc] init];
    self.window.rootViewController = self.tabbar;
    
    LeftVC *leftVC = [[LeftVC alloc] init];
    UINavigationController      *leftNav = [[UINavigationController alloc] initWithRootViewController:leftVC];
    RightVC *rightVC = [[RightVC alloc] init];
    UINavigationController      *rightNav = [[UINavigationController alloc]initWithRootViewController:rightVC];
    [self.tabbar setViewControllers:[NSArray arrayWithObjects:leftNav,rightNav, nil]];
    self.tabbar.tabBar.backgroundColor = [UIColor blueColor];
    
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    LLTabBar *tabBar = [[LLTabBar alloc] initWithFrame:self.tabbar.tabBar.bounds];
    
    CGFloat normalButtonWidth = (SCREEN_WIDTH -100) / 2;
    CGFloat tabBarHeight = CGRectGetHeight(tabBar.frame);
    CGFloat publishItemWidth = 100;
    
    LLTabBarItem *homeItem = [self tabBarItemWithFrame:CGRectMake(0, 0, normalButtonWidth, tabBarHeight)
                                                 title:nil
                                       normalImageName:@"tab_live_p"
                                     selectedImageName:@"tab_live" tabBarItemType:LLTabBarItemNormal];
    LLTabBarItem *publishItem = [self tabBarItemWithFrame:CGRectMake(normalButtonWidth, 0, publishItemWidth, tabBarHeight)
                                                    title:nil
                                          normalImageName:@"tab_room_p"
                                        selectedImageName:@"tab_room" tabBarItemType:LLTabBarItemRise];
    LLTabBarItem *mineItem = [self tabBarItemWithFrame:CGRectMake(normalButtonWidth + publishItemWidth, 0, normalButtonWidth, tabBarHeight)
                                                 title:nil
                                       normalImageName:@"tab_me_p"
                                     selectedImageName:@"tab_me" tabBarItemType:LLTabBarItemNormal];
    
    tabBar.tabBarItems = @[homeItem, publishItem, mineItem];
    tabBar.delegate = self;

    [self.tabbar.tabBar addSubview:tabBar];
    
}
- (LLTabBarItem *)tabBarItemWithFrame:(CGRect)frame title:(NSString *)title normalImageName:(NSString *)normalImageName selectedImageName:(NSString *)selectedImageName tabBarItemType:(LLTabBarItemType)tabBarItemType {
    LLTabBarItem *item = [[LLTabBarItem alloc] initWithFrame:frame withTabBarItem:tabBarItemType];
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    [item setImage:normalImage forState:UIControlStateNormal];
    [item setImage:selectedImage forState:UIControlStateSelected];
    [item setImage:selectedImage forState:UIControlStateHighlighted];
    item.tabBarItemType = tabBarItemType;
    
    return item;
}
#pragma mark - LLTabBarDelegate

- (void)tabBarDidSelectedRiseButton {
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.window.rootViewController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    NSString *tokenStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"anchorProtocol"];
    if (![User_Id isEqualToString:tokenStr]) {
        AnchorProVC *anchorProVC = [[AnchorProVC alloc]init];
        anchorProVC.delegate = self;
        [self.window.rootViewController presentViewController:anchorProVC animated:YES completion:^{}];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [AFRequestManager SafeGET:URI_UserOwnTv parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            UserTVInfoModel *userTVInfoModel = [[UserTVInfoModel alloc]initWithDictionary:result[@"data"] error:nil];
            LiveVC *lrvc = [[LiveVC alloc]init];
            lrvc.userTVInfoModel = userTVInfoModel;
            [self.window.rootViewController presentViewController:lrvc animated:YES completion:^{}];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
#pragma mark AnchorProVCDelegate
- (void)didClickAgreeButtonAction
{
    [self tabBarDidSelectedRiseButton];
}

- (void)showLoginViewController
{
    LoginVC  *lvc = [[LoginVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:lvc];
    self.window.rootViewController = nav;
}
#pragma mark request
- (void)getIndexTextRequest
{
    [AFRequestManager SafeGET:URI_IndexText parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            NSDictionary *dict = [result objectForKey:@"data"];
            self.roomWarningString = [dict objectForKey:@"roomWarning"];
            self.crash = [dict objectForKey:@"crash"];
            self.ver_test = [dict objectForKey:@"ver_test"];
            [[VersionServiceManager sharedInstance] isHasNewVersionWithDict:result];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


#pragma mark - 苹果提供的方法
/// 当检测到网络断开时会间隔15s再次检测，如果还是断开则弹窗提醒，防止过于频繁操作
- (void)appleReachabilityTest {
    /// Reachability使用了通知，当网络状态发生变化时发送通知kReachabilityChangedNotification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appReachabilityChanged:)
                                                 name:kReachabilityChangedNotification
                                               object:nil];
    
    // 被通知函数运行的线程应该由startNotifier函数执行的线程决定
    typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        weakSelf.routerReachability = [Reachability reachabilityForInternetConnection];
        [weakSelf.routerReachability startNotifier];
        // 开启当前线程消息循环
        [[NSRunLoop currentRunLoop] run];
    });
}

/// 当网络状态发生变化时调用
- (void)appReachabilityChanged:(NSNotification *)notification{
    Reachability *reach = [notification object];
    if([reach isKindOfClass:[Reachability class]]){
        NetworkStatus status = [reach currentReachabilityStatus];
        // 两种检测:路由与服务器是否可达  三种状态:手机流量联网、WiFi联网、没有联网
        if (reach == self.routerReachability) {
            if (status == NotReachable) {
                
            } else if (status == ReachableViaWiFi) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkStatusChangedNotification object:nil];
                NSLog(@"routerReachability ReachableViaWiFi");
            } else if (status == ReachableViaWWAN) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kNetworkStatusChangedNotification object:nil];
                NSLog(@"routerReachability ReachableViaWWAN");
            }
        }
    }
}

@end
