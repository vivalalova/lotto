//
//  PhoneNumLoginVC.m
//  LDLiveProject
//
//  Created by MAC on 16/6/15.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "PhoneNumLoginVC.h"

@interface PhoneNumLoginVC ()<UITextFieldDelegate>
{
    UITextField *phoneNumTextField;
    UITextField *verifyNumTextField;
    UIButton *verifyButton;
    UIButton *loginButton;
    UILabel *noticeLabel;
    NSTimer * countDomnTimer;
    NSInteger countDownNum;
}
@end

@implementation PhoneNumLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_LoginVCBool) {
        [self setUsualNavigationBarWithBackAndTitleWithString:@"手机号登录"];
    }else{
        [self setUsualNavigationBarWithBackAndTitleWithString:@"绑定手机"];
    }
    
    self.view.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    [self UIInit];
    
    [self registerForKeyboardNotifications];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [phoneNumTextField becomeFirstResponder];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneNumTextChanged:) name:UITextFieldTextDidChangeNotification object:phoneNumTextField];
    [super viewDidAppear:animated];
}

- (void)UIInit
{
    verifyButton = [UIButton new];
    [verifyButton setTitle:@"获取短信验证码" forState:UIControlStateNormal];
    [verifyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [verifyButton setTitleColor:[UIColor colorWithHexString:@"0xc8c7cd"] forState:UIControlStateSelected];
    verifyButton.titleLabel.font = [UIFont systemFontOfSize:CustomFont(15)];
    [verifyButton setBackgroundImage:[UIImage imageByApplyingAlpha:1 color:[UIColor colorWithHexString:@"0xea6c68"]] forState:UIControlStateNormal];
    verifyButton.layer.cornerRadius = 3;
    verifyButton.layer.masksToBounds = YES;//设为NO去试试
    verifyButton.userInteractionEnabled = NO;
    [self.view addSubview:verifyButton];
    [verifyButton addTarget:self action:@selector(verifyButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [verifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(110,27));
        make.top.equalTo(self.view).with.offset(45+64);
        make.right.equalTo(self.view).with.offset(-18);
    }];
    
    phoneNumTextField = [UITextField new];
    phoneNumTextField.delegate = self;
    phoneNumTextField.font = [UIFont systemFontOfSize:CustomFont(15)];
    phoneNumTextField.placeholder = @"请输入手机号码";
    phoneNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:phoneNumTextField];
    [phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(verifyButton.mas_centerY);
        make.left.equalTo(self.view).with.offset(27);
        make.right.equalTo(verifyButton.mas_left).with.offset(-15);
        make.height.mas_equalTo(verifyButton.mas_height);
    }];
    
    UILabel *linelabel1 = [UILabel new];
    linelabel1.backgroundColor = [UIColor colorWithHexString:@"0xea6c68"];
    [self.view addSubview:linelabel1];
    [linelabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumTextField.mas_bottom).with.offset(3);
        make.right.equalTo(self.view).with.offset(-15);
        make.left.equalTo(self.view).with.offset(15);
        make.height.mas_equalTo(1);
    }];
    
    verifyNumTextField = [UITextField new];
    verifyNumTextField.delegate = self;
    verifyNumTextField.font = [UIFont systemFontOfSize:CustomFont(15)];
    verifyNumTextField.placeholder = @"请输入验证码";
    verifyNumTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:verifyNumTextField];
    [verifyNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(phoneNumTextField.mas_bottom).with.offset(20);
        make.left.equalTo(self.view).with.offset(30);
        make.right.equalTo(self.view).with.offset(-30);
        make.height.mas_equalTo(phoneNumTextField.mas_height);
    }];
    
    UILabel *linelabel2 = [UILabel new];
    linelabel2.backgroundColor = [UIColor colorWithHexString:@"0xea6c68"];
    [self.view addSubview:linelabel2];
    [linelabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verifyNumTextField.mas_bottom).with.offset(3);
        make.right.equalTo(self.view).with.offset(-15);
        make.left.equalTo(self.view).with.offset(15);
        make.height.mas_equalTo(1);
    }];
    
    noticeLabel = [UILabel new];
    noticeLabel.text = @"运营商将会给您发送短信验证码，请注意查收";
    noticeLabel.font = [UIFont systemFontOfSize:CustomFont(13)];
    noticeLabel.backgroundColor = [UIColor clearColor];
    noticeLabel.textColor = [UIColor blackColor];
    noticeLabel.numberOfLines = 2;
    noticeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:noticeLabel];
    [noticeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(verifyNumTextField.mas_bottom).with.offset(20);
        make.left.equalTo(self.view).with.offset(80);
        make.right.equalTo(self.view).with.offset(-80);
        make.height.mas_equalTo(CGSizeMake(100, 40));
    }];
    noticeLabel.hidden = YES;
    
    loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    loginButton.frame = CGRectMake(50, SCREEN_HEIGHT - 226 - 15 - 40, SCREEN_WIDTH - 100, 40);
    if (_LoginVCBool) {
        [loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    }else{
        [loginButton setTitle:@"绑 定" forState:UIControlStateNormal];
    }
    loginButton.titleLabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    [loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginButton setBackgroundImage:[UIImage imageByApplyingAlpha:1 color:[UIColor colorWithHexString:@"0xea6c68"]] forState:UIControlStateNormal];
    loginButton.layer.cornerRadius = 20;
    loginButton.layer.masksToBounds = YES;//设为NO去试试
    [self.view addSubview:loginButton];
    [loginButton addTarget:self action:@selector(loginButtonClick:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark  buttonAction
- (void)verifyButtonClick:(UIButton *)button
{
    if (phoneNumTextField.text.length>=11) {
        
        NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
        [paramToken setObject:phoneNumTextField.text forKey:@"phone"];
        [AFRequestManager SafeGET:URI_PCodeByPhone parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *result = responseObject;
            if ([result[@"status"] intValue] == 200) {
                [MPNotificationView notifyWithText:@""
                                            detail:@"手机验证码下发成功，请注意查收"
                                     andTouchBlock:^(MPNotificationView *notificationView) {
                                         NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                                     }];
                [self startTimer];
            }else{
                [MPNotificationView notifyWithText:@""
                                            detail:result[@"status_msg"]
                                     andTouchBlock:^(MPNotificationView *notificationView) {
                                         NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                                     }];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [MPNotificationView notifyWithText:@""
                                        detail:@"网络请求失败，请检查您的网络"
                                 andTouchBlock:^(MPNotificationView *notificationView) {
                                     NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                                 }];
        }];
    }
}
-(void)startTimer
{
    countDownNum = 60;
    countDomnTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDownAction:) userInfo:nil repeats:YES];
    verifyButton.layer.borderColor =   [UIColor colorWithHexString:@"0xc8c7cd"].CGColor;
    verifyButton.layer.borderWidth = 0.5;
    verifyButton.selected = YES;
    verifyButton.userInteractionEnabled = NO;
    noticeLabel.hidden = NO;
}
//获取验证码倒计时
-(void)countDownAction:(NSTimer *)timer
{
    countDownNum--;
    [verifyButton setTitle:[NSString stringWithFormat:@"%ld秒后重新获取",(long)countDownNum] forState:UIControlStateSelected];
    if (countDownNum == 0)
    {
        [self stopTimer];
    }
}
-(void) stopTimer
{
    [countDomnTimer invalidate];
    countDomnTimer = nil;
    countDownNum = 60;
    verifyButton.selected = NO;
    verifyButton.userInteractionEnabled = YES;
    verifyButton.layer.borderColor =   [UIColor colorWithHexString:@"0xea6c68"].CGColor;
    verifyButton.layer.borderWidth = 0.5;
    [verifyButton setTitle:@"获取短信验证码" forState:UIControlStateNormal];
}

- (void)loginButtonClick:(UIButton*)button
{
    if (_LoginVCBool) {
        [self gotoLogin];
    }else{
        [self bindingPhone];
    }
}

- (void)gotoLogin
{
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:phoneNumTextField.text forKey:@"phone"];
    [paramToken setObject:verifyNumTextField.text forKey:@"code"];
    [AFRequestManager SafeGET:URI_LoginByCode parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        NSLog(@"%@",result);
        if ([result[@"status"] intValue] == 200) {
            [self showKVNProgress];
            
            NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
            NSString *tokenStr = result[@"data"][@"token"];
            [paramToken setObject:tokenStr forKey:@"token"];
            [AFRequestManager SafeGET:URI_GetInfo parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([((NSDictionary*)responseObject)[@"status"] intValue] == 200) {
                    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:((NSDictionary*)responseObject)[@"data"]];
                    [dict setObject:tokenStr forKey:@"token"];
                    [dict setObject:tokenStr forKey:@"currentToken"];
                    UserModel *userModel = [[UserModel alloc]initWithDictionary:dict error:nil];
                    [AccountHelper saveUserInfo:userModel];
                    [JPUSHService setAlias:User_Id callbackSelector:nil object:self];
                    [self hideKVNProgress];
                }else{
                    [self hideKVNProgress];
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [MPNotificationView notifyWithText:@""
                                            detail:@"登录失败,请重新尝试."
                                     andTouchBlock:^(MPNotificationView *notificationView) {
                                         NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                                     }];
                [self hideKVNProgress];
            }];
            AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
            [appdelegate initRootViewControllers];
        }else{
            [MPNotificationView notifyWithText:@""
                                        detail:result[@"status_msg"]
                                 andTouchBlock:^(MPNotificationView *notificationView) {
                                     NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                                 }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MPNotificationView notifyWithText:@""
                                    detail:@"网络请求失败，请检查您的网络"
                             andTouchBlock:^(MPNotificationView *notificationView) {
                                 NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                             }];
    }];
}

- (void)bindingPhone
{
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:phoneNumTextField.text forKey:@"phone_num"];
    [paramToken setObject:verifyNumTextField.text forKey:@"code"];
    [paramToken setObject:User_Token forKey:@"token"];
    [AFRequestManager SafePOST:URI_SetPhone parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        NSLog(@"%@",result);
        if ([result[@"status"] intValue] == 200) {
            UserModel *userModel = [AccountHelper userInfo];
            userModel.user_mobile = phoneNumTextField.text;
            [AccountHelper saveUserInfo:userModel];
            if ([_delegate respondsToSelector:@selector(BingPhoneNumSuccessDelegate)]) {
                [_delegate BingPhoneNumSuccessDelegate];
                [super actionClickNavigationBarLeftButton];
            }
        }else{
            [MPNotificationView notifyWithText:@""
                                        detail:result[@"status_msg"]
                                 andTouchBlock:^(MPNotificationView *notificationView) {
                                     NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                                 }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [MPNotificationView notifyWithText:@""
                                    detail:@"网络请求失败，请检查您的网络"
                             andTouchBlock:^(MPNotificationView *notificationView) {
                                 NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                             }];
    }];
}

#pragma mark  KeyboardNotifications
- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}

- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    loginButton.top = SCREEN_HEIGHT - keyboardSize.height - 15 - 44;
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    ///keyboardWasShown = YES;
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    
}


#pragma mark textfiledDelegate

- (void)phoneNumTextChanged:(NSNotification *)notification
{
    UITextField *textField = (UITextField *)notification.object;
    if (textField.text.length>=11) {
        verifyButton.userInteractionEnabled = YES;
        verifyButton.selected = NO;
    }
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
