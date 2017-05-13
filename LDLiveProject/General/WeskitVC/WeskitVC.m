//
//  WeskitVC.m
//  LDLiveProject
//
//  Created by MAC on 16/8/12.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "WeskitVC.h"
#import "VestModel.h"
#import "WeskitCell.h"
#import "RechargeVC.h"

@interface WeskitVC ()<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate,WeskitCellDelegate,UIAlertViewDelegate>
{
    NSMutableArray *dataArray;
    SRRefreshView   *_slimeView;
    //确定开通的马甲id
    NSString *maJiaId;
}
@property (nonatomic,strong)UITableView*tableview;
@property (nonatomic,strong)UITextView *bottomView;
@end

@implementation WeskitVC

- (UITextView*)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UITextView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-80, SCREEN_WIDTH, 80)];
        _bottomView.textAlignment = NSTextAlignmentCenter;
        _bottomView.backgroundColor = [UIColor clearColor];
        _bottomView.textColor = [UIColor lightGrayColor];
        _bottomView.text = @"身份新体验\n变身马甲，想怎么变，就怎么变";
        _bottomView.font = [UIFont systemFontOfSize:CustomFont(16)];
    }
    return _bottomView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUsualNavigationBarWithBackAndTitleWithString:@"我的马甲"];
    dataArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    UILabel *label = [[UILabel alloc]init];
    label.width = SCREEN_WIDTH;
    label.height = 30;
    label.center = self.view.center;
    label.backgroundColor = [UIColor clearColor];
    label.text = @"网络请求失败";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-80)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    [_tableview setSeparatorColor:[UIColor colorWithHexString:@"0xdadada"]];
    _tableview.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    [self.view addSubview:_tableview];
    self.view.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.bottomView];
    
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor blackColor];
    _slimeView.slime.skinColor = [UIColor whiteColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor blackColor];
    
    UIView *mheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SELFVIEW_WIDTH, 0)];
    _tableview.tableHeaderView = mheaderView;
    _tableview.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [_tableview addSubview:_slimeView];
    _tableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [_slimeView update:0];
    
    [self sendURI_VestList];
    // Do any additional setup after loading the view.
}


#pragma mark tableviewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"WeskitCell";
    WeskitCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:ident owner:self options:nil];
        cell = (WeskitCell*)objects[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    cell.indexPath = indexPath;
    if (dataArray.count>1) {
        if (indexPath.row == 0) {
            cell.lineLabel1.hidden = NO;
            cell.lineLabel2.hidden = NO;
            cell.lineLabel3.hidden = YES;
        }else if (indexPath.row == dataArray.count-1){
            cell.lineLabel1.hidden = YES;
            cell.lineLabel2.hidden = YES;
            cell.lineLabel3.hidden = NO;
        }else{
            cell.lineLabel1.hidden = YES;
            cell.lineLabel2.hidden = NO;
            cell.lineLabel3.hidden = YES;
        }
    }else{
        cell.lineLabel1.hidden = NO;
        cell.lineLabel2.hidden = YES;
        cell.lineLabel3.hidden = NO;
    }
    
    [cell setWeskitCellWithModel:[dataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    HostDetailInfoModel *hostDetailInfoModel = [dataArray objectAtIndex:indexPath.row];
    //    if (hostDetailInfoModel.status.intValue) {
    //        LiveRoomVC *plvc = [[LiveRoomVC alloc]init];
    //        plvc.hostDetailInfoModel = hostDetailInfoModel;
    //        [self.navigationController pushViewController:plvc animated:YES];
    //    }
}
#pragma celldelegate
- (void)didClickFuncButtonWithVestModel:(VestModel *)vestModel withIndexPath:(NSIndexPath *)indexPath
{
    if (!vestModel.is_open.intValue) {
        if (indexPath.row>1) {
            VestModel *vestmodel = [dataArray objectAtIndex:indexPath.row-1];
            if (vestmodel.is_open.intValue) {
                //出提示框 确定购买
                maJiaId = vestModel.sx_id;
                NSString *message = [NSString stringWithFormat:@"开通马甲将消耗%@钻石",vestModel.price];
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                alertV.tag = 999;
                [alertV show];
            }else{
                //提示开通上级马甲
                UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您必须开通上一级马甲" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertV show];
            }
        }else{
            //出提示框 确定购买
            maJiaId = vestModel.sx_id;
            NSString *message = [NSString stringWithFormat:@"开通马甲将消耗%@钻石",vestModel.price];
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertV.tag = 999;
            [alertV show];
        }
    }else{
        if (!vestModel.is_use.intValue) {
            //确定使用
            [self sendURI_UseVestRequestWithUserId:vestModel.user_id];
        }else{
            //确定取消
            UserModel *userModel = [AccountHelper userInfo];
            [self sendURI_UseVestRequestWithUserId:@"0"];
        }
    }

}
#pragma mark uialertviewdelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 999 &&buttonIndex == 1) {
        [self sendURI_OpenVestRequestWithVestId:maJiaId];
    }
    if (alertView.tag == 9999 &&buttonIndex == 1) {
        RechargeVC *revc = [[RechargeVC alloc]init];
        [self.navigationController pushViewController:revc animated:YES];
    }
}
#pragma mark  requests
//使用
- (void)sendURI_UseVestRequestWithUserId:(NSString *)userId
{
    [self showKVNProgress];
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:CurrentUserToken forKey:@"token"];
    [paramToken setObject:userId forKey:@"uid"];
    [AFRequestManager SafeGET:URI_UseVest parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        NSLog(@"%@",result);
        if ([result[@"status"] intValue] == 200) {
            UserModel *userModel = [AccountHelper userInfo];
            userModel.currentToken = result[@"data"][@"token"];
            [AccountHelper saveUserInfo:userModel];
            [self sendURI_VestList];
        }else{
            [self hideKVNProgress];
            [MPNotificationView notifyWithText:@""
                                        detail:result[@"status_msg"]
                                 andTouchBlock:^(MPNotificationView *notificationView) {
                                     NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                                 }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideKVNProgress];
        [MPNotificationView notifyWithText:@""
                                    detail:@"网络请求失败，请检查您的网络！"
                             andTouchBlock:^(MPNotificationView *notificationView) {
                                 NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                             }];
    }];
}
//开通
- (void)sendURI_OpenVestRequestWithVestId:(NSString *)vestId
{
    [self showKVNProgress];
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:CurrentUserToken forKey:@"token"];
    [paramToken setObject:vestId forKey:@"sid"];
    [AFRequestManager SafeGET:URI_OpenVest parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        NSLog(@"%@",result);
        if ([result[@"status"] intValue] == 200) {
            [self sendURI_VestList];
        }else if([result[@"status"] intValue] == 223){
            [self hideKVNProgress];
            UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"余额不足，是否前去充值？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertV.tag = 9999;
            [alertV show];
        }else{
            [self hideKVNProgress];
            [MPNotificationView notifyWithText:@""
                                        detail:result[@"status_msg"]
                                 andTouchBlock:^(MPNotificationView *notificationView) {
                                     NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                                 }];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideKVNProgress];
        [MPNotificationView notifyWithText:@""
                                    detail:@"网络请求失败，请检查您的网络！"
                             andTouchBlock:^(MPNotificationView *notificationView) {
                                 NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                             }];
    }];
}


- (void)sendURI_VestList
{
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:CurrentUserToken forKey:@"token"];
    [AFRequestManager SafeGET:URI_VestList parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        NSLog(@"%@",result);
        if ([result[@"status"] intValue] == 200) {
            NSArray *list = [result objectForKey:@"data"];
            _tableview.hidden = NO;
            if ([list isKindOfClass:[NSArray class]]) {
                dataArray = [NSMutableArray arrayWithCapacity:list.count];
                for (NSDictionary *dic in list) {
                    VestModel *vestModel = [[VestModel alloc] initWithDictionary:dic error:nil];
                    [dataArray addObject:vestModel];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableview reloadData];
                [_slimeView endRefresh];
            });
        }else{
            _tableview.hidden = YES;
        }
        [self hideKVNProgress];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideKVNProgress];
        [MPNotificationView notifyWithText:@""
                                    detail:@"网络请求失败，请检查您的网络！"
                             andTouchBlock:^(MPNotificationView *notificationView) {
                                 NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                             }];
    }];
}


#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}
- (void)slimeRefreshStartRefresh:(SRRefreshView*)refreshView
{
    [self sendURI_VestList];
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
