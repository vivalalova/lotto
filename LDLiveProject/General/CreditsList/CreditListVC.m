//
//  CreditListVC.m
//  LDLiveProject
//
//  Created by MAC on 16/9/2.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "CreditListVC.h"
#import "CreditModel.h"
#import "CreditFirstCell.h"
#import "CreditTwoCell.h"
#import "CreditThreeCell.h"
#import "CreditUsualCell.h"
#import "PersonInfoModel.h"
#import "UserDetailVCViewController.h"

@interface CreditListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    SRRefreshView   *_slimeView;
//页数标记
    NSInteger currentPage;
    NSInteger totalPage;
    //头像图片根地址
    NSString *imageRootUrlStr;
}
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UILabel *tableViewHeaderView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation CreditListVC

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}
- (NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

- (UILabel *)tableViewHeaderView
{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 55)];
        _tableViewHeaderView.backgroundColor = [UIColor clearColor];
        _tableViewHeaderView.textAlignment = NSTextAlignmentCenter;
        _tableViewHeaderView.textColor = [UIColor darkGrayColor];
        _tableViewHeaderView.font = [UIFont systemFontOfSize:15];
    }
    return _tableViewHeaderView;
}


- (void)actionClickNavigationBarLeftButton
{
    if (_CreditListVCDelegateResponseBool && [_delegate respondsToSelector:@selector(didClickHiddenCreditListVCAction)]) {
        [_delegate didClickHiddenCreditListVCAction];
    }else{
        [super actionClickNavigationBarLeftButton];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    [self setUsualNavigationBarWithBackAndTitleWithString:@"球票贡献榜"];
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor blackColor];
    _slimeView.slime.skinColor = [UIColor whiteColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor blackColor];
    
    self.tableView.tableHeaderView = self.tableViewHeaderView;
    [self.tableView addSubview:_slimeView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [_slimeView update:0];
    
    [self.view addSubview:self.tableView];
    
    
    [self sendRequestOfPageNum:1];
    
    
    // Do any additional setup after loading the view.
}


- (void)sendRequestOfPageNum:(int)num
{
    if ([NSString isBlankString:self.aesIdStr]) {
        [self showMPNotificationViewWithErrorMessage:@"请求失败"];
        return;
    }
    [self showActivityIndicatorView];
    NSDictionary *params=@{@"aesId":self.aesIdStr,@"size":@"20",@"page":[NSString stringWithFormat:@"%d",num]};
    
    [AFRequestManager SafePOST:URI_AnchorContribution parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
        [_slimeView endRefresh];
        [self hideActivityIndicatorView];
        if ([result[@"status"] intValue] == 200) {
            [self hidePromptView];
            self.tableView.hidden = NO;
            imageRootUrlStr = result[@"data"][@"url"];
            currentPage = [result[@"data"][@"page"] integerValue];
            totalPage = [result[@"data"][@"total"] integerValue];
            
            self.tableViewHeaderView.text = [NSString stringWithFormat:@"%@ 球票",result[@"data"][@"tickets"]];
            
            if (num == 1) {
                [self.dataArray removeAllObjects];
                NSArray *list = [result objectForKey:@"data"][@"list"];
                if ([list isKindOfClass:[NSArray class]]) {
                    self.dataArray = [NSMutableArray arrayWithCapacity:list.count];
                    for (NSDictionary *dic in list) {
                        CreditModel *creditModel = [[CreditModel alloc] initWithDictionary:dic error:nil];
                        [self.dataArray addObject:creditModel];
                    }
                }
            }else{
                NSArray *list = [result objectForKey:@"data"][@"list"];
                if ([list isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in list) {
                        CreditModel *creditModel = [[CreditModel alloc] initWithDictionary:dic error:nil];
                        [self.dataArray addObject:creditModel];
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            if (self.dataArray.count<1) {
                self.tableView.hidden = YES;
                [self showPromptViewWithText:@"你还没有收到球票，赶紧开播召唤好友给你送礼吧"];
            }
        }else{
            [self showMPNotificationViewWithErrorMessage:@"请求数据失败"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_slimeView endRefresh];
        [self hideActivityIndicatorView];
        [self showMPNotificationViewWithErrorMessage:@"网络请求失败"];
    }];

}



#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        static NSString *ident = @"CreditFirstCell";
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:ident owner:self options:nil];
            CreditFirstCell * cell = (CreditFirstCell*)objects[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setFirstCellUIWithImageHost:imageRootUrlStr CreditModel:[self.dataArray objectAtIndex:indexPath.row]];
        return cell;
    }
    if (indexPath.row == 1) {
        static NSString *ident = @"CreditTwoCell";
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:ident owner:self options:nil];
           CreditTwoCell * cell = (CreditTwoCell*)objects[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setTwoCellUIWithImageHost:imageRootUrlStr CreditModel:[self.dataArray objectAtIndex:indexPath.row]];
        return cell;
    }
    if (indexPath.row == 2) {
        static NSString *ident = @"CreditThreeCell";
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:ident owner:self options:nil];
            CreditThreeCell * cell = (CreditThreeCell*)objects[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setThreeCellUIWithImageHost:imageRootUrlStr CreditModel:[self.dataArray objectAtIndex:indexPath.row]];
        return cell;
    }
    
    static NSString *ident = @"CreditUsualCell";
    CreditUsualCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:ident owner:self options:nil];
        cell = (CreditUsualCell*)objects[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [cell setUsualCellUIWithImageHost:imageRootUrlStr CreditModel:[self.dataArray objectAtIndex:indexPath.row]];
    if (indexPath.row == currentPage*20 -1 && currentPage<=totalPage) {
        [self sendRequestOfPageNum:currentPage+1];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 151;
    }else if (indexPath.row == 1){
        return 139;
    }else if (indexPath.row == 2){
        return 126;
    }else{
        return 71;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CreditModel *creditModel = [self.dataArray objectAtIndex:indexPath.row];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:creditModel.pid forKey:@"aesId"];
        [params setObject:User_Token forKey:@"token"];
        [AFRequestManager SafeGET:URI_GetInfoByAesId parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *result = responseObject;
            NSLog(@"%@",result);
            if ([result[@"status"] intValue] == 200) {
                PersonInfoModel *personInfoModel = [[PersonInfoModel alloc]initWithDictionary:result[@"data"] error:nil];
                if (personInfoModel.isVest.intValue) {
                    [self showMPNotificationViewWithErrorMessage:@"马甲用户无法查看个人信息"];
                }else{
                    UserDetailVCViewController *userdVC = [[UserDetailVCViewController alloc]init];
                    userdVC.personInfoModel = personInfoModel;
                    userdVC.screenWidth = self.view.width;
                    userdVC.screenHeight = self.view.height;
                    [self.navigationController pushViewController:userdVC animated:YES];
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
        }];
}


#pragma mark - slimeRefresh delegate
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self sendRequestOfPageNum:1];
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
