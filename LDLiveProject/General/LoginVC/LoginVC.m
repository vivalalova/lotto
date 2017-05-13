//
//  LoginVC.m
//  LDLiveProject
//
//  Created by MAC on 16/6/14.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "LoginVC.h"
#import "PhoneNumLoginVC.h"
#import "PrivacyPolicyVC.h"

@interface LoginVC ()<M80AttributedLabelDelegate>

@end


static LoginVC *_currentLoadingVC = nil;

@implementation LoginVC



- (void)viewDidLoad {
    [super viewDidLoad];
    [self UIInit];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessAction:) name:kLoginOnceMoreNotification object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginOnceMoreNotification object:nil];
}



- (void)UIInit
{
    self.view.userInteractionEnabled = YES;
    UIImageView *groundImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    groundImageView.image = [UIImage imageNamed:@"login_ground"];
    groundImageView.userInteractionEnabled = YES;
    [self.view addSubview:groundImageView];
    
    UILabel *hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/4*3-5, SCREEN_WIDTH, 24)];
    hintLabel.backgroundColor = [UIColor clearColor];
    hintLabel.text = @"选择登录方式";
    hintLabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    hintLabel.textColor = [UIColor whiteColor];
    hintLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:hintLabel];
    
    NSInteger loginCount = 0;
    NSInteger loginNum = 0;
    if ([WXApi isWXAppInstalled]) {
        loginCount = 5;
        UIButton *wxButton = [UIButton buttonWithType:UIButtonTypeCustom];
        wxButton.frame = CGRectMake((SCREEN_WIDTH + 44)/loginCount - 44, SCREEN_HEIGHT/16*13, 44, 44);
        [wxButton setImage:[UIImage imageNamed:@"wx_login"] forState:UIControlStateNormal];
        [wxButton setImage:[UIImage imageNamed:@"wx_login"] forState:UIControlStateHighlighted];
        [wxButton addTarget:self action:@selector(wxButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:wxButton];
    }else{
        loginCount = 4;
        loginNum ++;
    }
    
    
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qqButton.frame = CGRectMake((SCREEN_WIDTH + 44)/loginCount*(2-loginNum) - 44, SCREEN_HEIGHT/16*13, 44, 44);
    [qqButton setImage:[UIImage imageNamed:@"qq_login"] forState:UIControlStateNormal];
    [qqButton setImage:[UIImage imageNamed:@"qq_login"] forState:UIControlStateHighlighted];
    [qqButton addTarget:self action:@selector(qqButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:qqButton];
    
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake((SCREEN_WIDTH + 44)/loginCount*(3-loginNum) - 44, SCREEN_HEIGHT/16*13, 44, 44);
    [phoneButton setImage:[UIImage imageNamed:@"phone_login"] forState:UIControlStateNormal];
    [phoneButton setImage:[UIImage imageNamed:@"phone_login"] forState:UIControlStateHighlighted];
    [phoneButton addTarget:self action:@selector(phoneButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:phoneButton];
    
    UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaButton.frame = CGRectMake((SCREEN_WIDTH + 44)/loginCount*(4-loginNum) - 44, SCREEN_HEIGHT/16*13, 44, 44);
    [sinaButton setImage:[UIImage imageNamed:@"sina_login"] forState:UIControlStateNormal];
    [sinaButton setImage:[UIImage imageNamed:@"sina_login"] forState:UIControlStateHighlighted];
    [sinaButton addTarget:self action:@selector(sinaButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sinaButton];
    
    
    
    
    M80AttributedLabel *linkLabel = [[M80AttributedLabel alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT/12*11, SCREEN_WIDTH, 20)];
    linkLabel.textColor = [UIColor whiteColor];
    linkLabel.backgroundColor = [UIColor clearColor];
    linkLabel.highlightColor = [UIColor colorWithHexString:@"0x8ee2d3"];
    linkLabel.textAlignment = kCTTextAlignmentCenter;
    NSString *text  = @"登录即代表您同意 信天翁服务和隐私条款";
    NSRange range   = [text rangeOfString:@"信天翁服务和隐私条款"];
    linkLabel.text      = text;
    [linkLabel addCustomLink:[NSValue valueWithRange:range]
                    forRange:range linkColor:[UIColor colorWithHexString:@"0x8ee2d3"]];
    linkLabel.delegate = self;
    [self.view addSubview:linkLabel];
    
}

#pragma mark buttonActions
- (void)wxButtonClick:(UIButton *)button
{
    if([WXApi isWXAppInstalled]){
        [[WXApiManager shareManager]wxLoginSuccessCompletion:^(BOOL success) {
            [self showKVNProgress];
        } failureCompletion:^(BOOL failer) {
            [self hideKVNProgress];
            if (failer) {
                
            }
        }];
    }
}

- (void)qqButtonClick:(UIButton *)button
{
    [[TencentOpenApiManager shareManager]qqLoginWithSuccessCompletion:^(BOOL success) {
        [self showKVNProgress];
    } failureCompletion:^(BOOL failure) {
        [self hideKVNProgress];
        if (failure) {
           
        }
    }];
}

- (void)sinaButtonClick:(UIButton *)button
{
    [[WeiboSDKManager sharedInstance]WeiboLoginSuccessCompletion:^(BOOL success) {
        [self showKVNProgress];
    } failureCompletion:^(BOOL failure) {
        [self hideKVNProgress];
        if (failure) {
            
        }
    }];
}




- (void)loginSuccessAction:(NSNotification *)dict
{
    [self hideKVNProgress];
    if (![[dict.object objectForKey:@"LoginSuccess"] intValue]) {
        return;
    }
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    [appdelegate initRootViewControllers];
}

- (void)phoneButtonClick:(UIButton *)button
{
    PhoneNumLoginVC *pnlVC = [[PhoneNumLoginVC alloc]init];
    pnlVC.LoginVCBool = YES;
    [self.navigationController pushViewController:pnlVC animated:YES];
}

#pragma mark M80AttributedLabelDelegate
- (void)m80AttributedLabel:(M80AttributedLabel *)label
             clickedOnLink:(id)linkData
{
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    PrivacyPolicyVC *ppVC = [[PrivacyPolicyVC alloc]init];
    ppVC.policyType = kLoginPolicyType;
    [self presentViewController:ppVC animated:YES completion:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
