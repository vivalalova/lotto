//
//  BasisVC.m
//  LDLiveProject
//
//  Created by MAC on 16/5/30.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BasisVC.h"
#import "KVNProgress.h"

@interface BasisVC ()
{
    PromptView              *_promptView;
}

@end

@implementation BasisVC

- (UIActivityIndicatorView*)activityIndicatorView
{
    if (!_activityIndicatorView) {
        AppDelegate * app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activityIndicatorView.center = app.window.center;
        _activityIndicatorView.hidden = YES;
        [app.window addSubview:_activityIndicatorView];
    }
    
    return _activityIndicatorView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //键盘
    [self enableKeyboardManger];
    //提示框
    [self setupBaseKVNProgressUI];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self endEditing];
    [self disableKeyboardManager];
}

- (void)endEditing
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark  MPNotificationViewActionBasic
- (void)showMPNotificationViewWithErrorMessage:(NSString *)errorMessage
{
    [MPNotificationView notifyWithText:@""
                            detail:errorMessage
                     andTouchBlock:^(MPNotificationView *notificationView) {
                         NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                     }];
}

#pragma mark navigationController
/*================================================================================================*/
- (void)setUsualNavigationBarWithBackAndTitleWithString:(NSString *)titleString
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:[self getNavgationBarViewWithTitleString:titleString]];
}
- (UIView *)getNavgationBarViewWithTitleString:(NSString *)titleString
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_BAR_HEIGHT+STATUS_BAR_HEIGHT)];
    UIImageView *navImageView = [[UIImageView alloc]initWithFrame:navView.bounds];
    navImageView.image = [UIImage imageNamed:@"navImage"];
    [navView addSubview:navImageView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 60, NAV_BAR_HEIGHT);
    [backButton setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    [backButton addTarget: self action:@selector(actionClickNavigationBarLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(backButton.width + 25, 20, SCREEN_WIDTH - (backButton.width + 25)*2, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:CustomFont(18)];
    titleLabel.text = titleString;
    [navView addSubview:titleLabel];
    
    return navView;
}
/*--------------------------*/
- (void)setUsualNavigationBarWithBackAndTitleWithString:(NSString *)titleString RightBarString:(NSString *)rightStr
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:[self getNavgationBarViewWithTitleString:titleString withRightStr:rightStr]];
}
- (UIView *)getNavgationBarViewWithTitleString:(NSString *)titleString withRightStr:(NSString *)rightStr
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_BAR_HEIGHT+STATUS_BAR_HEIGHT)];
    UIImageView *navImageView = [[UIImageView alloc]initWithFrame:navView.bounds];
    navImageView.image = [UIImage imageNamed:@"navImage"];
    [navView addSubview:navImageView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 60, NAV_BAR_HEIGHT);
    [backButton setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    [backButton addTarget: self action:@selector(actionClickNavigationBarLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(backButton.width + 25, 20, SCREEN_WIDTH - (backButton.width + 25)*2, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:CustomFont(18)];
    titleLabel.text = titleString;
    [navView addSubview:titleLabel];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(SCREEN_WIDTH-80, 20, 80, NAV_BAR_HEIGHT);
    rightButton.titleLabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    [rightButton setTitle:rightStr forState:UIControlStateNormal];
    [rightButton addTarget: self action:@selector(actionClickNavigationBarRightButton) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:rightButton];
    
    return navView;
}
/*================================================================================================*/

- (void)setUsualNavigationBarWithCancelSaveAndTitleWithString:(NSString *)titleString
{
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:[self getNavgationBarViewCancelSaveWithTitleString:titleString]];
}
- (UIView *)getNavgationBarViewCancelSaveWithTitleString:(NSString *)titleString
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, NAV_BAR_HEIGHT+STATUS_BAR_HEIGHT)];
    UIImageView *navImageView = [[UIImageView alloc]initWithFrame:navView.bounds];
    navImageView.image = [UIImage imageNamed:@"navImage"];
    [navView addSubview:navImageView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(0, 20, 60, NAV_BAR_HEIGHT);
    backButton.titleLabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    [backButton setTitle:@"取消" forState:UIControlStateNormal];
    [backButton addTarget: self action:@selector(actionClickNavigationBarLeftButton) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backButton];

    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(SCREEN_WIDTH-60, 20, 60, NAV_BAR_HEIGHT);
    saveButton.titleLabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [saveButton addTarget: self action:@selector(actionClickNavigationBarRightButton) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:saveButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(backButton.width + 25, 20, SCREEN_WIDTH - (backButton.width + 25)*2, 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:CustomFont(18)];
    titleLabel.text = titleString;
    [navView addSubview:titleLabel];
    
    return navView;
}






/*================================================================================================*/
- (void)actionClickNavigationBarLeftButton
{
    [self hideActivityIndicatorView];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionClickNavigationBarRightButton
{

    
}

///////////////////////////////////////////////////////////////////////////////
#pragma mark  键盘事件
///////////////////////////////////////////////////////////////////////////////
- (BOOL)isEnableKeyboardManger
{
    return NO;
}
- (void)enableKeyboardManger
{
    if (![self isEnableKeyboardManger]) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
//    /*Registering for textField notification*/
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditingNotification:) name:UITextFieldTextDidBeginEditingNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditingNotification:) name:UITextFieldTextDidEndEditingNotification object:nil];
//    
//    /*Registering for textView notification*/
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidBeginEditingNotification:) name:UITextViewTextDidBeginEditingNotification object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidEndEditingNotification:) name:UITextViewTextDidEndEditingNotification object:nil];
}

- (void)disableKeyboardManager
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidBeginEditingNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidEndEditingNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidBeginEditingNotification object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidEndEditingNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)notification
{

}


- (void)keyboardWillHide:(NSNotification *)notification
{
    
}

#pragma mark -  提示框

- (void)setupBaseKVNProgressUI
{
    // See the documentation of all appearance propoerties
    [KVNProgress appearance].statusColor = [UIColor whiteColor];
    [KVNProgress appearance].statusFont = [UIFont systemFontOfSize:17.0f];
    [KVNProgress appearance].circleStrokeForegroundColor = [UIColor whiteColor];
    [KVNProgress appearance].circleStrokeBackgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.1f];
    [KVNProgress appearance].circleFillBackgroundColor = [UIColor clearColor];
    [KVNProgress appearance].backgroundFillColor = [UIColor colorWithWhite:0.9f alpha:0.1f];
    [KVNProgress appearance].backgroundTintColor = [UIColor clearColor];
    [KVNProgress appearance].successColor = [UIColor whiteColor];
    [KVNProgress appearance].errorColor = [UIColor whiteColor];
    [KVNProgress appearance].circleSize = 35.0f;
    [KVNProgress appearance].lineWidth = 2.0f;
}

//显示 提示框
- (void)showKVNProgress
{
    [KVNProgress showWithParameters:@{KVNProgressViewParameterFullScreen: @(YES)}];
}


//隐藏提示框
- (void)hideKVNProgress
{
    [KVNProgress dismiss];
}


#pragma mark UIActivityIndicatorView

- (void)showActivityIndicatorView
{
    [self.view bringSubviewToFront:self.activityIndicatorView];
    self.activityIndicatorView.hidden = NO;
    [self.activityIndicatorView startAnimating];
}

- (void)hideActivityIndicatorView
{
    self.activityIndicatorView.hidden = YES;
    [self.activityIndicatorView stopAnimating];
}

#pragma mark  PromptView


- (PromptView *)promptView
{
    if (!_promptView) {
        _promptView = [PromptView viewFromXIB];
        _promptView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
        [_promptView.actionButton addTarget:self action:@selector(tapPromptViewAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _promptView;
}

- (void)showPromptViewWithText:(NSString *)text
{
    [self.view addSubview:[self promptView]];
    [self.view sendSubviewToBack:_promptView];
    [_promptView setPromptText:text];
}

- (void)showNoDataPromptView
{
    [self showPromptViewWithText:[self defaultNoDataPromptText]];
}

- (void)showNetErrorPromptView
{
    [self showPromptViewWithText:@"网络连接错误，请重新载入"];
}

- (void)showServerErrorPromptView
{
    [self showPromptViewWithText:@"加载失败，请重新载入"];
}

- (void)hidePromptView
{
    [_promptView removeFromSuperview];
}

- (void)tapPromptViewAction
{
    
}

- (NSString *)defaultNoDataPromptText
{
    return @"暂无数据";
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
