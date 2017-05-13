//
//  FansVC.m
//  LDLiveProject
//
//  Created by MAC on 16/7/5.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "FansVC.h"
#import "UserModel.h"
#import "HostDetailInfoModel.h"
#import "AttentionCell.h"
#import "LiveRoomVC.h"
#import "UserDetailVCViewController.h"
#import "PersonInfoModel.h"

@interface FansVC ()<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate,AttentionCellDelegate>
{
    NSMutableArray *dataArray;
    SRRefreshView   *_slimeView;
    //页数标记
    NSInteger currentPage;
    NSInteger totalPage;
    //自己还是别人
    BOOL IsOwnBool;
    UILabel *label;
}
@property (nonatomic,strong)UITableView*tableview;

@end

@implementation FansVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![NSString isBlankString:self.titleStr]) {
        [self setUsualNavigationBarWithBackAndTitleWithString:@"粉丝"];
        IsOwnBool = NO;
    }else{
        [self setUsualNavigationBarWithBackAndTitleWithString:@"粉丝"];
        IsOwnBool = YES;
    }
    dataArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    label = [[UILabel alloc]init];
    label.width = SCREEN_WIDTH;
    label.height = 30;
    label.center = self.view.center;
    label.backgroundColor = [UIColor clearColor];
    label.text = @"您还没有粉丝哦，快去直播让别人关注你吧";
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _tableview.dataSource = self;
    _tableview.delegate = self;
    [_tableview setSeparatorColor:[UIColor colorWithHexString:@"0xdadada"]];
    _tableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableview];
    self.view.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
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
    if (IsOwnBool) {
        [self sendURI_FansRequestOFPageNum:@"1"];
    }else{
        [self sendOtherURI_FansRequestOFPageNum:@"1"];
    }
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    if (IsOwnBool) {
        [self sendURI_FansRequestOFPageNum:@"1"];
    }else{
        [self sendOtherURI_FansRequestOFPageNum:@"1"];
    }
    
    [super viewWillAppear:animated];
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
    static NSString *ident = @"AttentionCell";
    AttentionCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:ident owner:self options:nil];
        cell = (AttentionCell*)objects[0];
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
    if (indexPath.row == currentPage*20 -1 && currentPage<=totalPage) {
        NSString *pageNum = [NSString stringWithFormat:@"%ld",currentPage+1];
        if (IsOwnBool) {
            [self sendURI_FansRequestOFPageNum:pageNum];
        }else{
            [self sendOtherURI_FansRequestOFPageNum:pageNum];
        }
    }
    [cell setUIwithHostDetailInfoModel:[dataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    HostDetailInfoModel *hostDetailInfoModel = [dataArray objectAtIndex:indexPath.row];
    [self sendRequestOfGetInfoByAesId:hostDetailInfoModel.pid roomid:hostDetailInfoModel.room_id];
}
- (void)sendRequestOfGetInfoByAesId:(NSString*)aesId roomid:(NSString *)roomid
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:aesId forKey:@"aesId"];
    [params setObject:User_Token forKey:@"token"];
    [params setObject:roomid forKey:@"roomid"];
    [AFRequestManager SafeGET:URI_GetInfoByAesId parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        NSLog(@"%@",result);
        if ([result[@"status"] intValue] == 200) {
            PersonInfoModel *personInfoModel = [[PersonInfoModel alloc]initWithDictionary:result[@"data"] error:nil];
            UserDetailVCViewController *userdvc = [[UserDetailVCViewController alloc]init];
            userdvc.personInfoModel = personInfoModel;
            userdvc.screenWidth = self.view.width;
            userdvc.screenHeight = self.view.height;
            [self.navigationController pushViewController:userdvc animated:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}
#pragma celldelegate
- (void)didClickAttentionAttButtonWithHostDetailInfoModel:(HostDetailInfoModel *)hostDetailInfoModel withIndexPath:(NSIndexPath *)indexPath
{
    if (hostDetailInfoModel.isAttention.intValue) {
        [self sendCancelAttentionRequestWithRoomUid:hostDetailInfoModel.u_id withIndexPath:indexPath];
    }else{
        [self sendAddAttentionRequestWithRoomUid:hostDetailInfoModel.u_id withIndexPath:indexPath];
    }
}


#pragma mark  requests
- (void)sendURI_FansRequestOFPageNum:(NSString *)pageNum
{
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:User_Token forKey:@"token"];
    [paramToken setObject:pageNum forKey:@"page"];
    [paramToken setObject:@"20" forKey:@"size"];
    [AFRequestManager SafeGET:URI_FansList parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            _tableview.hidden = NO;
            currentPage = [result[@"data"][@"page"] integerValue];
            totalPage = [result[@"data"][@"total"] integerValue];
            if (pageNum.intValue == 1) {
                [dataArray removeAllObjects];
                NSArray *list = [result objectForKey:@"data"][@"list"];
                if ([list isKindOfClass:[NSArray class]]) {
                    dataArray = [NSMutableArray arrayWithCapacity:list.count];
                    for (NSDictionary *dic in list) {
                        HostDetailInfoModel *lvModel = [[HostDetailInfoModel alloc] initWithDictionary:dic error:nil];
                        [dataArray addObject:lvModel];
                    }
                }
                if (dataArray.count>0) {
                    label.hidden = YES;
                }else{
                    label.hidden = NO;
                }
            }else{
                NSArray *list = [result objectForKey:@"data"][@"list"];
                if ([list isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in list) {
                        HostDetailInfoModel *lvModel = [[HostDetailInfoModel alloc] initWithDictionary:dic error:nil];
                        [dataArray addObject:lvModel];
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableview reloadData];
                [_slimeView endRefresh];
            });
        }else{
            _tableview.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (void)sendOtherURI_FansRequestOFPageNum:(NSString *)pageNum
{
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:User_Token forKey:@"token"];
    [paramToken setObject:pageNum forKey:@"page"];
    [paramToken setObject:@"20" forKey:@"size"];
    [paramToken setObject:self.aesId forKey:@"aesId"];
    [AFRequestManager SafeGET:URI_fansaesid parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            _tableview.hidden = NO;
            currentPage = [result[@"data"][@"page"] integerValue];
            totalPage = [result[@"data"][@"total"] integerValue];
            if (pageNum.intValue == 1) {
                [dataArray removeAllObjects];
                NSArray *list = [result objectForKey:@"data"][@"list"];
                if ([list isKindOfClass:[NSArray class]]) {
                    dataArray = [NSMutableArray arrayWithCapacity:list.count];
                    for (NSDictionary *dic in list) {
                        HostDetailInfoModel *lvModel = [[HostDetailInfoModel alloc] initWithDictionary:dic error:nil];
                        [dataArray addObject:lvModel];
                    }
                }
                if (dataArray.count>0) {
                    label.hidden = YES;
                }else{
                    label.hidden = NO;
                    label.text = @"ta还没有粉丝哦,关注成为ta的粉丝吧";
                }
            }else{
                NSArray *list = [result objectForKey:@"data"][@"list"];
                if ([list isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in list) {
                        HostDetailInfoModel *lvModel = [[HostDetailInfoModel alloc] initWithDictionary:dic error:nil];
                        [dataArray addObject:lvModel];
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableview reloadData];
                [_slimeView endRefresh];
            });
        }else{
            _tableview.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

#pragma mark  添加关注取消关注 关注相关----------------------------------------
//添加关注
- (void)sendAddAttentionRequestWithRoomUid:(NSString *)room_uid withIndexPath:(NSIndexPath*)indexPath
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [params setObject:room_uid forKey:@"room_uid"];
    [AFRequestManager SafeGET:URI_AddAttention parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            HostDetailInfoModel *hostDetailInfoModel =  [dataArray objectAtIndex:indexPath.row];
            hostDetailInfoModel.isAttention = @"1";
            [dataArray replaceObjectAtIndex:indexPath.row withObject:hostDetailInfoModel];
            [_tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

//取消关注
- (void)sendCancelAttentionRequestWithRoomUid:(NSString *)room_uid withIndexPath:(NSIndexPath*)indexPath
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [params setObject:room_uid forKey:@"room_uid"];
    [AFRequestManager SafeGET:URI_CancelAttention parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            HostDetailInfoModel *hostDetailInfoModel =  [dataArray objectAtIndex:indexPath.row];
            hostDetailInfoModel.isAttention = @"0";
            [dataArray replaceObjectAtIndex:indexPath.row withObject:hostDetailInfoModel];
            [_tableview reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
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
    if (IsOwnBool) {
        [self sendURI_FansRequestOFPageNum:@"1"];
    }else{
        [self sendOtherURI_FansRequestOFPageNum:@"1"];
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
