//
//  LevelVC.m
//  LDLiveProject
//
//  Created by MAC on 16/9/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "LevelVC.h"
#import "ExpInfoModel.h"

@interface LevelVC ()
{
    UserModel *_userModel;
}
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageBGView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nowValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *endValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *betweenValueLabel;

@end

@implementation LevelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _userModel = [AccountHelper userInfo];
    [self setUsualNavigationBarWithBackAndTitleWithString:@"我的等级"];
    [self sendRequestOfUserLevel];
    
    _nowValueLabel.textColor = [UIColor colorWithHexString:@"0x626d71"];
    _endValueLabel.textColor = [UIColor colorWithHexString:@"0x626d71"];
    _betweenValueLabel.textColor = [UIColor colorWithHexString:@"0xf0bb11"];
    _imageView.layer.cornerRadius = _imageView.height/2;
    // Do any additional setup after loading the view from its nib.
}

- (void)sendRequestOfUserLevel
{
    [self showKVNProgress];
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:_userModel.pid forKey:@"aesId"];
    [AFRequestManager SafePOST:URI_GetExpInfo parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideKVNProgress];
        if ([((NSDictionary*)responseObject)[@"status"] intValue] == 200) {
            ExpInfoModel *expInfoModel = [[ExpInfoModel alloc]initWithDictionary:responseObject[@"data"] error:nil];
            [self refreshUIwithExpInfoModel:expInfoModel];
        }else{
            [self showPromptViewWithText:@"出现错误，请重新进入尝试"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showPromptViewWithText:@"网络连接失败"];
        [self hideKVNProgress];
    }];
}
- (void)refreshUIwithExpInfoModel:(ExpInfoModel*)model
{
    _nowValueLabel.text = model.cexp;
    _endValueLabel.text = model.mexp;
    int betweenValue = model.mexp.intValue - model.cexp.intValue;
    _betweenValueLabel.text = [NSString stringWithFormat:@"还差 %d",betweenValue];
    _imageView.width = model.cexp.intValue/model.mexp.intValue*(_imageBGView.width-8);
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
