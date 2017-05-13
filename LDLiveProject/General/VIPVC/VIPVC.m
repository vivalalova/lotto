//
//  VIPVC.m
//  LDLiveProject
//
//  Created by MAC on 16/9/24.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "VIPVC.h"
#import "VIPSelectView.h"
#import "VIPModel.h"

@interface VIPVC ()<VIPSelectViewDelegate,UIAlertViewDelegate>
{
    UserModel *_userModel;
    VIPSelectView *vipSelectView;
}
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *openVIPButton;
@property (strong,nonatomic) NSMutableArray *dataArray;
@end

@implementation VIPVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _userModel = [AccountHelper userInfo];
    [self setUsualNavigationBarWithBackAndTitleWithString:@"我的特权"];
    _timeLabel.textColor = [UIColor colorWithHexString:@"0xe73962"];
    [_openVIPButton setBackgroundColor:[UIColor colorWithHexString:@"0x00a2e6"]];
    if (!_userModel.super_vip.intValue) {
        _timeLabel.text = @"未开通";
    }else
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *date = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(_userModel.vip_expire.intValue)]];
        _timeLabel.text = [NSString stringWithFormat:@"%@到期",date];
    }
    [self sendVIPListRequest];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)openVIPButtonClick:(id)sender {
    if (self.dataArray.count<1) {
        [self showMPNotificationViewWithErrorMessage:@"网络请求失败，无法获得数据，请重新进入尝试!"];
        return;
    }
    vipSelectView = [VIPSelectView viewFromXIB];
    vipSelectView.frame = self.view.frame;
    vipSelectView.delegate = self;
    [vipSelectView setUIWithDataArray:self.dataArray];
    [self.view addSubview:vipSelectView];
    [vipSelectView showInSupeView];
}

- (void)sendVIPListRequest
{
    [self showActivityIndicatorView];
    [AFRequestManager SafeGET:URI_GetVIPList parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
        [self hideActivityIndicatorView];
        if ([result[@"status"] intValue] == 200) {
            NSArray *list = [result objectForKey:@"data"];
            if ([list isKindOfClass:[NSArray class]]) {
                self.dataArray = [NSMutableArray arrayWithCapacity:list.count];
                for (NSDictionary *dic in list) {
                    [self.dataArray addObject:[[VIPModel alloc] initWithDictionary:dic error:nil]];
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideActivityIndicatorView];
    }];
}

- (void)didSelectOpenVIPButtonWithDateStr:(NSString *)dateStr
{
    VIPModel *model = [self.dataArray objectAtIndex:dateStr.intValue];
    NSString *message = [NSString stringWithFormat:@"您确定要以%@钻石的价格购买%@个月的会员吗？",model.price,model.desc];
    UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertV.tag = dateStr.intValue;
    [alertV show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        VIPModel *model = [self.dataArray objectAtIndex:alertView.tag];
        [self sendOpenVipWithVipCode:model.giftid];
    }    
}
- (void)sendOpenVipWithVipCode:(NSString *)vipCode
{
    [self showKVNProgress];
    NSDictionary *params=@{@"token":User_Token,@"giftid":vipCode};
    
    [AFRequestManager SafePOST:URI_BuyVIP parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [self hideKVNProgress];
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([result[@"status"] intValue] == 200) {
            [vipSelectView hideFromSuperView];
            _userModel.points = result[@"data"][@"points"];
            _userModel.vip_expire = result[@"data"][@"vip_expire"];
            _userModel.super_vip = @"1";
            [AccountHelper saveUserInfo:_userModel];
            [self showMPNotificationViewWithErrorMessage:@"购买成功"];
            
            NSString *dateStr = [NSString stringWithFormat:@"%@",result[@"data"][@"vip_expire"]];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *date = [dateFormatter stringFromDate:[NSDate dateWithTimeIntervalSince1970:(dateStr.intValue)]];
            _timeLabel.text = [NSString stringWithFormat:@"%@到期",date];
        }else{
            [self showMPNotificationViewWithErrorMessage:result[@"status_msg"]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideKVNProgress];
        [self showMPNotificationViewWithErrorMessage:@"网络请求失败"];
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
