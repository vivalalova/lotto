//
//  EditYourProfileVC.m
//  LiveProject
//
//  Created by coolyouimac02 on 15/10/30.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "EditYourProfileVC.h"
#import "UserModel.h"

@interface EditYourProfileVC ()<UITextFieldDelegate>
{
    __weak IBOutlet UITextField *nickNameTextFiled;
    __weak IBOutlet UIView *bgView;
    __weak IBOutlet UILabel *topLine;
    __weak IBOutlet UILabel *bottomLine;
    
    UserModel *_userModel;
    NSUInteger _subLen;
}
@end

@implementation EditYourProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUsualNavigationBarWithCancelSaveAndTitleWithString:@"昵称"];

    bgView.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    topLine.height = 0.5;
    bottomLine.height = 0.5;
    bottomLine.top += 0.5;
    nickNameTextFiled.delegate = self;
    _userModel = [AccountHelper userInfo];                                                      
    nickNameTextFiled.text = _userModel.nick;
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [nickNameTextFiled becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fieldTextChanged:) name:UITextFieldTextDidChangeNotification object:nickNameTextFiled];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)actionClickNavigationBarRightButton
{
    if (nickNameTextFiled.text.length<1) {
//        [BDKNotifyHUD showPortraitModeHUDWithText:@"您输入您的昵称"];
        return;
    }
    if ([nickNameTextFiled.text isEqualToString:_userModel.nick]) {
//        [BDKNotifyHUD showPortraitModeHUDWithText:@"您的昵称并没有改变"];
        return;
    }
    [nickNameTextFiled resignFirstResponder];
    [self sendChangeNickNameRequest];
}

-(void)sendChangeNickNameRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [params setObject:nickNameTextFiled.text forKey:@"nick"];
    [AFRequestManager SafeGET:URI_UserNick parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            _userModel.nick = nickNameTextFiled.text;
            [AccountHelper saveUserInfo:_userModel];
            [super actionClickNavigationBarLeftButton];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


#pragma mark UITextFieldDelegate nickname
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0)
    {
//        [BDKNotifyHUD showPortraitModeHUDWithText:@"亲昵称不能为空哦"];
//        return NO;
    }
    
    textField.tag = 1;
    [textField resignFirstResponder];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@" "]) {
        return NO;
    }else{
        return YES;
    }
}

#pragma mark - NSNotification

- (void)fieldTextChanged:(NSNotification *)notification
{
    @try{
        
        UITextField *textField = (UITextField *)notification.object;
        NSString *str = [[textField text] stringByReplacingOccurrencesOfString:@"?" withString:@""];//输入的字符，包括键盘上高亮的未转成中文的拼音
        NSLog(@"str--%@",str);
        UITextRange *selectedRange = [textField markedTextRange];
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];//高亮
        
        if (!position) {//没高亮的文字
            CGFloat ascLen=[self countW:str];//没高亮，获取长度
            NSLog(@"ascLen------------------%f",ascLen);
            if (ascLen > 5) {
                NSString *strNew = [NSString stringWithString:str];
                NSLog(@"strNew--%@",strNew);
                NSLog(@"_subLen%f",_subLen);
                if (_subLen==0) {
                    _subLen=strNew.length;
                }
                [textField setText:[strNew substringToIndex:_subLen]];
            }
        }
        else{
            //            NSLog(@"输入的英文还没转化为汉字");//只是高亮，不应该算长度
        }
        
        
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
}
- (CGFloat)countW:(NSString *)s
{
    int i;CGFloat n=[s length],l=0,a=0,b=0;
    CGFloat wLen=0;
    unichar c;
    for(i=0;i<n;i++){
        c=[s characterAtIndex:i];//按顺序取出单个字符
        if(isblank(c)){//判断字符串为空或为空格
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
        wLen=l+(CGFloat)((CGFloat)(a+b)/2.0);
        NSLog(@"wLen--%f",wLen);
        if (wLen>=6.5&&wLen<7.5) {//设定这个范围是因为，当输入了当输入9英文，即4.5，后面还能输1字母，但不能输1中文
            _subLen=l+a+b;//_subLen是要截取字符串的位置
        }
        
    }
    if(a==0 && l==0)
    {
        _subLen=0;
        return 0;//只有isblank
    }
    else{
        
        return wLen;//长度，中文占1，英文等能转ascii的占0.5
    }
}

- (IBAction)closeButtonClick:(id)sender {
    nickNameTextFiled.text = @"";
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
