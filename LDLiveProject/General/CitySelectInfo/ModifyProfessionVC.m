//
//  ModifyProfessionVC.m
//  LDLiveProject
//
//  Created by MAC on 16/9/3.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "ModifyProfessionVC.h"

@interface ModifyProfessionVC ()
{
    UITextView *mTextView;
    UserModel   *_userModel;
}
@end

@implementation ModifyProfessionVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fieldTextChanged:) name:UITextViewTextDidChangeNotification object:mTextView];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUsualNavigationBarWithCancelSaveAndTitleWithString:@"编辑职业"];
    self.view.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    mTextView = [[UITextView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, 120)];
    mTextView.font = [UIFont boldSystemFontOfSize:16];
    [self.view addSubview:mTextView];
    
    _userModel = [AccountHelper userInfo];
    if ([NSString isBlankString:_userModel.profession]) {
        mTextView.text = @"主播";
    }else{
        mTextView.text = _userModel.profession;
    }
    // Do any additional setup after loading the view.
}


-(void)actionClickNavigationBarRightButton
{
    NSString *filename = [[NSBundle mainBundle]pathForResource:@"dirtywords" ofType:@"plist"];
    NSArray *dirtywordsArray = [[NSArray alloc]initWithContentsOfFile:filename];
    for (int i=0; i<dirtywordsArray.count; i++) {
        NSString *dirtywordStr = [dirtywordsArray objectAtIndex:i];
        if ([mTextView.text rangeOfString:dirtywordStr].location !=NSNotFound) {
            NSInteger length = [[dirtywordsArray objectAtIndex:i] length];
            NSString *lengthStr = @"";
            for (int j=0; j<length; j++) {
                lengthStr = [NSString stringWithFormat:@"%@*",lengthStr];
            }
            mTextView.text = [mTextView.text stringByReplacingOccurrencesOfString:[dirtywordsArray objectAtIndex:i] withString:lengthStr];
            //            [BDKNotifyHUD showPortraitModeHUDWithText:@"您的输入包含违禁词汇,请修改后重新提交!"];
            return;
        }
    }
    
    [self sendRequestOfModifyBulletin];
}


-(void)sendRequestOfModifyBulletin
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [params setObject:mTextView.text forKey:@"info"];
    [AFRequestManager SafeGET:URI_UserProfession parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        NSLog(@"%@",result);
        if ([result[@"status"] intValue] == 200) {
            _userModel.profession = mTextView.text;
            [AccountHelper saveUserInfo:_userModel];
            if ([_delegate respondsToSelector:@selector(ModifyProfessionDidChanged)]) {
                [_delegate ModifyProfessionDidChanged];
            }
            [super actionClickNavigationBarLeftButton];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


#pragma mark - NSNotification

- (void)fieldTextChanged:(NSNotification *)notification
{
    mTextView = (UITextView *)notification.object;
    
    NSString *toBeString = mTextView.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [mTextView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [mTextView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length >= 20) {
                mTextView.text = [toBeString  substringWithRange:NSMakeRange(0,20)];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length >= 20) {
            mTextView.text = [toBeString  substringWithRange:NSMakeRange(0,20)];
        }
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
