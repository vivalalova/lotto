//
//  BlackListVC.m
//  LDLiveProject
//
//  Created by MAC on 16/9/6.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BlackListVC.h"
#import "UserModel.h"
#import "BlackListCell.h"
#import "LiveRoomVC.h"
#import "UserDetailVCViewController.h"
#import "PersonInfoModel.h"
#import "BlackListModel.h"

@interface BlackListVC ()<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate>
{
    NSMutableArray *dataArray;
    SRRefreshView   *_slimeView;
    NSString *BaseUrl;
}
@property (nonatomic,strong)UITableView*tableview;


@end

@implementation BlackListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUsualNavigationBarWithBackAndTitleWithString:@"粉丝"];
    dataArray = [[NSMutableArray alloc]init];
    
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
    
    [self sendURI_BlackListRequestOfPage:1];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
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
    static NSString *ident = @"BlackListCell";
    BlackListCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:ident owner:self options:nil];
        cell = (BlackListCell*)objects[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.attButton.userInteractionEnabled = NO;
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
    
    [cell setUIwithBlackListModel:[dataArray objectAtIndex:indexPath.row] withBaseUrl:BaseUrl];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BlackListModel *hostDetailInfoModel = [dataArray objectAtIndex:indexPath.row];
    [self sendRequestOfGetInfoByAesId:hostDetailInfoModel.pid];
}
- (void)sendRequestOfGetInfoByAesId:(NSString*)aesId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:aesId forKey:@"aesId"];
    [params setObject:User_Token forKey:@"token"];
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
- (void)sendURI_AttDelBlackRequestWithRoomUid:(NSString *)sid withIndexPath:(NSIndexPath*)indexPath
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [params setObject:sid forKey:@"block"];
    [AFRequestManager SafeGET:URI_AttDelBlack parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        NSLog(@"%@",result);
        if ([result[@"status"] intValue] == 200) {
            [dataArray removeObjectAtIndex:indexPath.row];
            [self.tableview reloadData];
            if (dataArray.count<1) {
                [self showNoDataPromptView];
            }else{
                [self hidePromptView];
            }
        }else{
            [self showPromptViewWithText:@"移出黑名单失败，请重新尝试"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showPromptViewWithText:@"网路请求失败"];
    }];
}

#pragma mark  requests
- (void)sendURI_BlackListRequestOfPage:(int)page
{
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:User_Token forKey:@"token"];
    [paramToken setObject:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [paramToken setObject:@"20" forKey:@"size"];
    [AFRequestManager SafePOST:URI_AttBlacklist parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            [self hidePromptView];
            NSArray *list = [result objectForKey:@"data"][@"list"];
            _tableview.hidden = NO;
            BaseUrl = result[@"data"][@"url"];
            if ([list isKindOfClass:[NSArray class]]) {
                dataArray = [NSMutableArray arrayWithCapacity:list.count];
                for (NSDictionary *dic in list) {
                    BlackListModel *blackListModel = [[BlackListModel alloc] initWithDictionary:dic error:nil];
                    [dataArray addObject:blackListModel];
                }
                if (dataArray.count<1) {
                    _tableview.hidden = YES;
                    [self showNoDataPromptView];
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



- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BlackListModel *hostDetailInfoModel = [dataArray objectAtIndex:indexPath.row];
        [self sendURI_AttDelBlackRequestWithRoomUid:hostDetailInfoModel.u_id withIndexPath:indexPath];
    }
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
    [self sendURI_BlackListRequestOfPage:1];
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
