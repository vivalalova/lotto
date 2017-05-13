//
//  AnchorProVC.m
//  LDLiveProject
//
//  Created by MAC on 16/8/6.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "AnchorProVC.h"

@interface AnchorProVC ()<UIWebViewDelegate,UIAlertViewDelegate>

{
    NSURLRequest *request;
}
@property (weak, nonatomic) IBOutlet UIButton *agreeButton;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AnchorProVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0x4a5054"];
    _webView.delegate = self;
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@static/anchor.html",URI_BASE_SERVER]]];
    [_webView loadRequest:request];
    
    [_agreeButton setTitleColor:[UIColor colorWithHexString:GiftUsualColor] forState:UIControlStateNormal];
    _agreeButton.layer.cornerRadius = _agreeButton.height/2;
    _agreeButton.layer.borderColor = [UIColor colorWithHexString:GiftUsualColor].CGColor;
    _agreeButton.layer.borderWidth = 1.0f;
    _agreeButton.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)closetButtonClick:(id)sender {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)agreeButtonClick:(id)sender {
    [[NSUserDefaults standardUserDefaults]setObject:User_Id forKey:@"anchorProtocol"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [self dismissViewControllerAnimated:YES completion:nil];
    if ([_delegate respondsToSelector:@selector(didClickAgreeButtonAction)]) {
        [_delegate didClickAgreeButtonAction];
    }
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
