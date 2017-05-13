//
//  EditGenderVC.m
//  LDLiveProject
//
//  Created by MAC on 16/6/22.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "EditGenderVC.h"
#import "UserModel.h"
@interface EditGenderVC ()
{
    UserModel *_userModel;
}
@property (weak, nonatomic) IBOutlet UIImageView *manImageV;
@property (weak, nonatomic) IBOutlet UIImageView *womanImageV;

@end

@implementation EditGenderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUsualNavigationBarWithBackAndTitleWithString:@"性别"];
    _userModel = [AccountHelper userInfo];
    if (_userModel.gender.intValue) {
        _manImageV.image = [UIImage imageNamed:@"man_select"];
    }else{
        _womanImageV.image = [UIImage imageNamed:@"woman_select"];
    }
    
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)manButtonClick:(id)sender {
    [self sendEditGenderRequestwithManBool:YES];
}
- (IBAction)womanButtonClick:(id)sender {
    [self sendEditGenderRequestwithManBool:NO];
}

- (void)sendEditGenderRequestwithManBool:(BOOL)manBool
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [params setObject:manBool?@"1":@"0" forKey:@"sex"];
    [AFRequestManager SafeGET:URI_UserGender parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            if (manBool) {
                _manImageV.image = [UIImage imageNamed:@"man_select"];
                _womanImageV.image = [UIImage imageNamed:@"woman_unselect"];
            }else{
                _manImageV.image = [UIImage imageNamed:@"man_unselect"];
                _womanImageV.image = [UIImage imageNamed:@"woman_select"];
            }
            
            _userModel.gender = manBool?@"1":@"0";
            [AccountHelper saveUserInfo:_userModel];
            [super actionClickNavigationBarLeftButton];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];

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
