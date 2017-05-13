//
//  BasisVC.h
//  LDLiveProject
//
//  Created by MAC on 16/5/30.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPNotificationView.h"
#import "PromptView.h"

@interface BasisVC : UIViewController<MPNotificationViewDelegate>

@property (nonatomic,strong)UIActivityIndicatorView *activityIndicatorView;

#pragma mark  MPNotificationViewActionBasic
-(void)showMPNotificationViewWithErrorMessage:(NSString *)errorMessage;
#pragma mark navigationController
- (void)setUsualNavigationBarWithBackAndTitleWithString:(NSString *)titleString;
- (void)setUsualNavigationBarWithBackAndTitleWithString:(NSString *)titleString RightBarString:(NSString *)rightStr;
- (void)actionClickNavigationBarLeftButton;

- (void)setUsualNavigationBarWithCancelSaveAndTitleWithString:(NSString *)titleString;
- (void)actionClickNavigationBarRightButton;


#pragma mark  键盘事件
///////////////////////////////////////////////////////////////////////////////
- (BOOL)isEnableKeyboardManger;
//如果开启此功能 则VieController 会自动监听键盘弹起事件 自动将编辑中的view拖动到可见区域

//结束编辑退出软键盘
- (void)endEditing;
//键盘弹起通知
- (void)keyboardWillShow:(NSNotification *)notification;
//键盘退出通知
- (void)keyboardWillHide:(NSNotification *)notification;
//提示框 显示隐藏
//显示 提示框
- (void)showKVNProgress;
//隐藏提示框
- (void)hideKVNProgress;
#pragma mark UIActivityIndicatorView
- (void)showActivityIndicatorView;
- (void)hideActivityIndicatorView;
//无数据提示
- (NSString *)defaultNoDataPromptText;
- (PromptView *)promptView;
- (void)showPromptViewWithText:(NSString *)text;
- (void)showNoDataPromptView;
- (void)showNetErrorPromptView;
- (void)showServerErrorPromptView;
- (void)hidePromptView;
- (void)tapPromptViewAction;
@end
