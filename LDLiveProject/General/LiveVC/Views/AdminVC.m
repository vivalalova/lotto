//
//  AdminVC.m
//  LDLiveProject
//
//  Created by MAC on 16/7/23.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "AdminVC.h"
#import "UserModel.h"
#import "AdminModel.h"
#import "AdminCell.h"
@interface AdminVC ()<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate>
{
    NSMutableArray *dataArray;
    SRRefreshView   *_slimeView;
    
}
@property (nonatomic,strong)UITableView*tableview;

@end

@implementation AdminVC

- (void)actionClickNavigationBarLeftButton
{
    self.view.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUsualNavigationBarWithBackAndTitleWithString:@"管理员列表"];
    dataArray = [[NSMutableArray alloc]init];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    UILabel *label = [[UILabel alloc]init];
    label.width = SCREEN_WIDTH;
    label.height = 30;
    label.center = self.view.center;
    label.backgroundColor = [UIColor clearColor];
    label.text = @"您还没有管理员哦，快去设置你的粉丝为管理吧!";
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
    
    UIView *mheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    _tableview.tableHeaderView = mheaderView;
    [_tableview addSubview:_slimeView];
    _tableview.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [_slimeView update:0];
    
    [self sendURI_FansRequest];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self sendURI_FansRequest];
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
    static NSString *ident = @"AdminCell";
    AdminCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:ident owner:self options:nil];
        cell = (AdminCell*)objects[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
    
    [cell setUIwithAdminModel:[dataArray objectAtIndex:indexPath.row]];
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCellEditingStyle result = UITableViewCellEditingStyleNone;//默认没有编辑风格
    if ([tableView isEqual:_tableview]) {
        result = UITableViewCellEditingStyleDelete;//设置编辑风格为删除风格
    }
    return result;
}

-(void)setEditing:(BOOL)editing animated:(BOOL)animated{//设置是否显示一个可编辑视图的视图控制器。
    [super setEditing:editing animated:animated];
    [self.tableview setEditing:editing animated:animated];//切换接收者的进入和退出编辑模式。
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{//请求数据源提交的插入或删除指定行接收者。
    if (editingStyle ==UITableViewCellEditingStyleDelete) {//如果编辑样式为删除样式
        AdminModel *adminModel = [dataArray objectAtIndex:indexPath.row];
        if ([_delegate respondsToSelector:@selector(didClickDeleteAdminWithAdminModel:)]) {
            [_delegate didClickDeleteAdminWithAdminModel:adminModel];
        }
    }
}

#pragma mark  requests
- (void)sendURI_FansRequest
{
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:User_Token forKey:@"token"];
    [AFRequestManager SafeGET:URI_GetManagerList parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            NSArray *list = [result objectForKey:@"data"];
            _tableview.hidden = NO;
            if ([list isKindOfClass:[NSArray class]]) {
                dataArray = [NSMutableArray arrayWithCapacity:list.count];
                for (NSDictionary *dic in list) {
                    AdminModel *adminModel = [[AdminModel alloc] initWithDictionary:dic error:nil];
                    [dataArray addObject:adminModel];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableview reloadData];
                [_slimeView endRefresh];
            });
        }else{
            [_slimeView endRefresh];
            _tableview.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_slimeView endRefresh];
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
    [self sendURI_FansRequest];
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
