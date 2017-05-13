//
//  AccountSecurityVC.m
//  LDLiveProject
//
//  Created by MAC on 16/9/13.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "AccountSecurityVC.h"
#import "PhoneNumLoginVC.h"

@interface AccountSecurityVC ()<UITableViewDelegate,UITableViewDataSource,PhoneNumLoginVCDelegate>
{
    UserModel *_userModel;
}
@property (nonatomic,strong)UITableView *mTableView;

@end

@implementation AccountSecurityVC


- (void)viewDidLoad {
    [super viewDidLoad];
    _userModel = [AccountHelper userInfo];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf0eff5"];
    [self setUsualNavigationBarWithBackAndTitleWithString:@"账户安全"];
    _mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _mTableView.dataSource = self;
    _mTableView.delegate = self;
    [_mTableView setSeparatorColor:[UIColor colorWithHexString:@"0xdadada"]];
    _mTableView.backgroundColor = [UIColor clearColor];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.mTableView];
    [self.mTableView reloadData];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }else{
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor colorWithHexString:@"0xf0eff5"];
    return view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if ([NSString isBlankString:_userModel.wx_openid]) {
            UITableViewCell *cell = [self SetupUsualTableViewCellWithString:@"绑定微信"];
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 43.5, SCREEN_WIDTH-20, 0.5)];
            lineLabel.backgroundColor = UIColorFromRGB(230, 230, 230);
            [cell addSubview:lineLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            UITableViewCell *cell = [self SetupUsualMoreTableViewCellWithString:@"绑定微信" modelStr:@"已绑定"];
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 43.5, SCREEN_WIDTH-20, 0.5)];
            lineLabel.backgroundColor = UIColorFromRGB(230, 230, 230);
            [cell addSubview:lineLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        
    }else if (indexPath.row == 1) {
        if ([NSString isBlankString:_userModel.user_mobile]) {
            UITableViewCell *cell = [self SetupUsualTableViewCellWithString:@"绑定手机"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            NSMutableString *mobileStr = [NSMutableString stringWithFormat:@"%@",_userModel.user_mobile];
            [mobileStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];   //从第3个字符串处替换掉后4个字符串
            UITableViewCell *cell = [self SetupUsualMoreTableViewCellWithString:@"绑定手机" modelStr:mobileStr];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

-(UITableViewCell*)SetupUsualTableViewCellWithString:(NSString*)str
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = str;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-32+10, 15, 8, 14)];
    imageV.image = [UIImage imageNamed:@"returndown.png"];
    [cell addSubview:imageV];
    return cell;
}

-(UITableViewCell*)SetupUsualMoreTableViewCellWithString:(NSString*)str modelStr:(NSString*)modelStr
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = str;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-160-10, 0, 160, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentRight;
    label.text = modelStr;
    [cell addSubview:label];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && [NSString isBlankString:_userModel.wx_openid]) {
        [self bindingWXOpenid];
    }
    if (indexPath.row == 1 && [NSString isBlankString:_userModel.user_mobile]) {
        PhoneNumLoginVC *pnlVC = [[PhoneNumLoginVC alloc]init];
        pnlVC.delegate = self;
        pnlVC.LoginVCBool = NO;
        [self.navigationController pushViewController:pnlVC animated:YES];
    }
}
- (void)bindingWXOpenid
{
    if([WXApi isWXAppInstalled]){
        [self showKVNProgress];
        __weak typeof(self) weakSelf=self;
        [[WXApiManager shareManager]wxBindSuccessCompletion:^(BOOL success) {
            [weakSelf hideKVNProgress];
        } failureCompletion:^(BOOL failer) {
            //            if (failer) {
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
        if ([((NSDictionary*)responseObject)[@"ret"] intValue] == 1007) {
            NSString *descStr = [((NSDictionary*)responseObject)[@"desc"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:descStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alertV show];
            
        }else if ([((NSDictionary*)responseObject)[@"ret"] intValue] == 0){
            _userModel.wx_openid = accessToken;
            [AccountHelper saveUserInfo:_userModel];
            [self showPromptViewWithText:@"绑定微信成功"];
            [_mTableView reloadData];
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
    [_mTableView reloadData];
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
