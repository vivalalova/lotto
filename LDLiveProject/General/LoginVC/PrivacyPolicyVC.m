//
//  PrivacyPolicyVC.m
//  LDLiveProject
//
//  Created by MAC on 16/7/16.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "PrivacyPolicyVC.h"

@interface PrivacyPolicyVC ()<UIWebViewDelegate,UIAlertViewDelegate>

{
    NSURLRequest *request;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation PrivacyPolicyVC

- (void)actionClickNavigationBarLeftButton
{
    if (_policyType == kLoginPolicyType) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self dismissAsPushAndPopAnimation:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _webView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64);
    if (_policyType == kAnchorPolicyType) {
        [self setUsualNavigationBarWithBackAndTitleWithString:@"主播协议"];
    }else{
        [self setUsualNavigationBarWithBackAndTitleWithString:@"用户协议"];
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"0x4a5054"];
    _webView.delegate = self;
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    if (_policyType == kAnchorPolicyType) {
        NSString *urlStr = [NSString stringWithFormat:@"%@static/anchor.html",URI_BASE_SERVER];
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    }else{
        NSString *urlStr = [NSString stringWithFormat:@"%@static/agreement.html",URI_BASE_SERVER];
        request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    }
    [_webView loadRequest:request];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showKVNProgress];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideKVNProgress];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideKVNProgress];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"加载页面失败" message:@"点击取消返回登录页面\n点击继续重新进行请求" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
    [alert show];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==1) {
        [_webView reload];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    }
}

- (void)dealloc
{
    NSLog( @"===deallco");
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
