//
//  AppDelegate.h
//  LDLiveProject
//
//  Created by MAC on 16/5/30.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VersionServiceManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UITabBarController    *tabbar;

@property (strong, nonatomic) NSString *roomWarningString;
@property (strong, nonatomic) NSString *crash;
@property (strong, nonatomic) NSString *ver_test;

- (void)initRootViewControllers;
- (void)showLoginViewController;
@end

