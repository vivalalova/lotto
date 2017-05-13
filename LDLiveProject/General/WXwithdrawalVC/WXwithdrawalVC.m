//
//  WXwithdrawalVC.m
//  LDLiveProject
//
//  Created by MAC on 16/9/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "WXwithdrawalVC.h"
#import "PhoneNumLoginVC.h"
#import "WXAdvanceRecord.h"

@interface WXwithdrawalVC ()<PhoneNumLoginVCDelegate>
{
    __weak IBOutlet UILabel *ticketsNumLabel;
    __weak IBOutlet UILabel *redNumYLabel;
    __weak IBOutlet UIButton *bindingButton;
    __weak IBOutlet UILabel *tishiLabel;
    __weak IBOutlet UIView *contentView;
    
    UserModel *_userModel;
}

@end

@implementation WXwithdrawalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _userModel = [AccountHelper userInfo];
    [self setUsualNavigationBarWithBackAndTitleWithString:@"我的收益" RightBarString:@"提现记录"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0x2f3639"];
    contentView.backgroundColor = [UIColor colorWithHexString:@"0x2f3639"];
    [self buildUI];
    // Do any additional setup after loading the view from its nib.
}
- (void)buildUI
{
    bindingButton.layer.cornerRadius = bindingButton.height/2;
    bindingButton.layer.masksToBounds = YES;
    ticketsNumLabel.text = _userModel.points;
    redNumYLabel.text = _userModel.redgift;
    tishiLabel.hidden = YES;
    tishiLabel.textColor = [UIColor colorWithHexString:GiftUsualColor];
    if ([NSString isBlankString:_userModel.wx_openid]) {
        [bindingButton setTitle:@"绑定微信" forState:UIControlStateNormal];
        return;
    }
    if ([NSString isBlankString:_userModel.user_mobile]) {
        [bindingButton setTitle:@"绑定手机" forState:UIControlStateNormal];
        return;
    }
    if (![NSString isBlankString:_userModel.user_mobile]&&![NSString isBlankString:_userModel.wx_openid]) {
        tishiLabel.hidden = NO;
//        [bindingButton setTitle:@"领劳务费" forState:UIControlStateNormal];
        bindingButton.hidden = YES;
    }
}


- (void)actionClickNavigationBarRightButton
{
    WXAdvanceRecord *wx = [[WXAdvanceRecord alloc]init];
    [self.navigationController pushViewController:wx animated:YES];
}
- (IBAction)bindingButtonClick:(id)sender {
    if ([NSString isBlankString:_userModel.wx_openid]) {
        [self bindingWXOpenid];
        return;
    }
    if ([NSString isBlankString:_userModel.user_mobile]) {
        PhoneNumLoginVC *pnlVC = [[PhoneNumLoginVC alloc]init];
        pnlVC.delegate = self;
        pnlVC.LoginVCBool = NO;
        [self.navigationController pushViewController:pnlVC animated:YES];
        return;
    }
    if (![NSString isBlankString:_userModel.user_mobile]&&![NSString isBlankString:_userModel.wx_openid]) {
        [self sendWXwithdrawalRequest];
    }
}
- (void)bindingWXOpenid
{
    if([WXApi isWXAppInstalled]){
        [self showKVNProgress];
        __weak typeof(self) weakSelf=self;
        [[WXApiManager shareManager]wxBindSuccessCompletion:^(BOOL success) {
            [weakSelf hideKVNProgress];
            [self showPromptViewWithText:@"绑定微信成功"];
        } failureCompletion:^(BOOL failer) {
//            if (failer) {
            [self showPromptViewWithText:@"绑定微信失败"];
                [weakSelf hideKVNProgress];
//            }
        } accessToken:^(NSString * accessToken) {
            [weakSelf hideKVNProgress];
            if(![NSString isBlankString:accessToken]){
                [weakSelf sendBindWeiXinRequest:accessToken];
            }else{
                [self showPromptViewWithText:@"获取信息失败"];
            }
        }];
    }else{
        [self showPromptViewWithText:@"微信未安装,请安装后重试"];
    }
}

- (void)sendBindWeiXinRequest:(NSString *)accessToken
{
    [self showKVNProgress];
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:User_Token forKey:@"token"];
    [paramToken setObject:accessToken forKey:@"unionid"];
    [AFRequestManager SafePOST:URI_BindWeiXin parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideKVNProgress];
        if ([((NSDictionary*)responseObject)[@"ret"] intValue] == 1007 || [((NSDictionary*)responseObject)[@"ret"] intValue] == 1009) {
            NSString *descStr = [((NSDictionary*)responseObject)[@"desc"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:descStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertV show];
            
        }else if ([((NSDictionary*)responseObject)[@"ret"] intValue] == 0){
            [bindingButton setTitle:@"绑定手机" forState:UIControlStateNormal];
            _userModel.wx_openid = accessToken;
            [AccountHelper saveUserInfo:_userModel];
            [self buildUI];
            [self showPromptViewWithText:@"绑定微信成功"];
        }else{
            [self showPromptViewWithText:@"其他错误"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showPromptViewWithText:@"网路错误"];
        [self hideKVNProgress];
    }];
}
- (void)BingPhoneNumSuccessDelegate
{
    _userModel = [AccountHelper userInfo];
    tishiLabel.hidden = NO;
    [self buildUI];
}

- (void)sendWXwithdrawalRequest
{
//    if (drawalTextField.text.intValue<0) {
//        [self showPromptViewWithText:@"请输入要领取的金额"];
//        return;
//    }
//    [self showKVNProgress];
//    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
//    [paramToken setObject:User_Token forKey:@"token"];
//    [paramToken setObject:drawalTextField.text forKey:@"m"];
//    [AFRequestManager SafePOST:URI_WXWithdrawals parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
//        [self hideKVNProgress];
//        if ([((NSDictionary*)responseObject)[@"ret"] intValue] == 0){
//            NSString *descStr = [((NSDictionary*)responseObject)[@"desc"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [self showPromptViewWithText:descStr];
//        }else{
//            NSString *descStr = [((NSDictionary*)responseObject)[@"desc"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            [self showPromptViewWithText:descStr];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        [self showPromptViewWithText:@"网路错误"];
//        [self hideKVNProgress];
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  keyboardNSNotification---------------------------------------
//键盘弹起通知
//- (void)keyboardWillShow:(NSNotification *)notification
//{
//    /*
//     获取通知携带的信息
//     */
//    NSDictionary *userInfo = [notification userInfo];
//    
//    if (userInfo)
//    {
//        [[DataCacheManager sharedManager] addObject:userInfo forKey:UIKeyboardFrameEndUserInfoKey];
//    }
//    
//    if (!drawalTextField)
//    {
//        return;
//    }
//    
//    // Get the origin of the keyboard when it's displayed.
//    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
//    CGRect keyboardRect = [aValue CGRectValue];
//    if (CGRectEqualToRect(keyboardRect, CGRectZero))
//    {
//        NSDictionary *userInfo = (NSDictionary *)[[DataCacheManager sharedManager] getCachedObjectByKey:UIKeyboardFrameEndUserInfoKey];
//        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
//        keyboardRect = [aValue CGRectValue];
//    }
//    
//    keyboardRect = [self.view convertRect:keyboardRect toView:self.view];
//    
//    //获取键盘的动画执行时长
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    
//    contentView.top -= keyboardRect.size.height;
//    
//    [UIView commitAnimations];
//    
//}
////键盘退出通知
//- (void)keyboardWillHide:(NSNotification *)notification
//{
//    NSDictionary* userInfo = [notification userInfo];
//    
//    /*
//     Restore the size of the text view (fill self's view).
//     Animate the resize so that it's in sync with the disappearance of the keyboard.
//     */
//    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
//    NSTimeInterval animationDuration;
//    [animationDurationValue getValue:&animationDuration];
//    
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.3];
//    
//    contentView.top =  64;
//    
//    [UIView commitAnimations];
//}
//
//- (BOOL)isEnableKeyboardManger
//{
//    return YES;
//}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [drawalTextField resignFirstResponder];
}

/*
#pragma mark - Navigation
o_CHSw912CHdSEx7M19DXbOILk18
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
