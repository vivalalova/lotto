//
//  LiveVideoVC.m
//  LDLiveProject
//
//  Created by MAC on 16/9/12.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "LiveVideoVC.h"
#import "LiveVideoModel.h"
#import "LiveVideoCell.h"
#import "VideoHeaderView.h"
#import "LiveRecordVC.h"
#import "LiveRoomVC.h"

@interface LiveVideoVC ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,VideoHeaderViewDelegate>
{
    SRRefreshView   *_slimeView;
    //页数标记
    NSInteger currentPage;
    NSInteger totalPage;
    //头像图片根地址
    NSString *imageRootUrlStr;
    NSIndexPath *delIndexPath;
    //type
    NSString *typeStr;
}
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic,strong)VideoHeaderView *tableViewHeaderView;
@property (nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation LiveVideoVC

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

- (VideoHeaderView *)tableViewHeaderView
{
    if (!_tableViewHeaderView) {
        _tableViewHeaderView = [VideoHeaderView viewFromXIB];
        _tableViewHeaderView.width = SCREEN_WIDTH;
        _tableViewHeaderView.height = 50;
        _tableViewHeaderView.delegate = self;
    }
    return _tableViewHeaderView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    typeStr = @"1";
    [self setUsualNavigationBarWithBackAndTitleWithString:@"直播录像"];
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

#pragma mark VideoHeaderViewDelegate
- (void)didClidkVideoHeaderViewwithNewButton
{
    typeStr = @"1";
    [self sendRequestOfPageNum:1];
}
- (void)didClidkVideoHeaderViewwithHotButton
{
    typeStr = @"2";
    [self sendRequestOfPageNum:1];
}


- (void)sendRequestOfPageNum:(int)num
{
    [self showActivityIndicatorView];
    UserModel *userModel = [AccountHelper userInfo];
    NSDictionary *params=@{@"aesId":userModel.pid,@"size":@"20",@"page":[NSString stringWithFormat:@"%d",num],@"order":typeStr};
    
    [AFRequestManager SafePOST:URI_GetVideo parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
        [_slimeView endRefresh];
        [self hideActivityIndicatorView];
        if ([result[@"status"] intValue] == 200) {
            [self hidePromptView];
            self.tableView.hidden = NO;
            imageRootUrlStr = result[@"data"][@"url"];
            currentPage = [result[@"data"][@"page"] integerValue];
            totalPage = [result[@"data"][@"total"] integerValue];
            NSArray *list = [result objectForKey:@"data"][@"list"];
            self.tableViewHeaderView.titleLabel.text = [NSString stringWithFormat:@"%lu个精彩回放",list.count];
            if (num == 1) {
                [self.dataArray removeAllObjects];
                NSArray *list = [result objectForKey:@"data"][@"list"];
                if ([list isKindOfClass:[NSArray class]]) {
                    self.dataArray = [NSMutableArray arrayWithCapacity:list.count];
                    for (NSDictionary *dic in list) {
                        LiveVideoModel *lvModel = [[LiveVideoModel alloc] initWithDictionary:dic error:nil];
                        [self.dataArray addObject:lvModel];
                    }
                }
            }else{
                NSArray *list = [result objectForKey:@"data"][@"list"];
                if ([list isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in list) {
                        LiveVideoModel *lvModel = [[LiveVideoModel alloc] initWithDictionary:dic error:nil];
                        [self.dataArray addObject:lvModel];
                    }
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
            if (self.dataArray.count<1) {
                self.tableView.hidden = YES;
                [self showPromptViewWithText:@"你还没有直播录像，赶紧开播记录一下吧"];
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
    static NSString *ident = @"LiveVideoCell";
    LiveVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:ident owner:self options:nil];
        cell = (LiveVideoCell*)objects[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row == 0) {
        cell.lineLabel1.hidden = NO;
    }else{
        cell.lineLabel1.hidden = YES;
    }
    [cell setUIwithLiveVideoModel:[self.dataArray objectAtIndex:indexPath.row]];
    if (indexPath.row == currentPage*20 -1 && currentPage<=totalPage) {
        [self sendRequestOfPageNum:currentPage+1];
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveVideoModel *lvModel = [self.dataArray objectAtIndex:indexPath.row];
    LiveRecordVC *lrVC = [[LiveRecordVC alloc]init];
    lrVC.liveVideoModel = lvModel;
    NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    for (UIViewController *vc in array) {
        if ([vc isKindOfClass:[LiveRoomVC class]]) {
            [(LiveRoomVC*)vc liveRoomVCClosePlayerUrl];
            [array removeObject:vc];
            break;
        }
    }
    self.navigationController.viewControllers = array;
    [self.navigationController pushViewController:lrVC animated:YES];
}


-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return   UITableViewCellEditingStyleDelete;
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle ==UITableViewCellEditingStyleDelete)
    {
        delIndexPath = indexPath;
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"删除视频后将不能恢复，确定删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertV show];
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        LiveVideoModel *lvModel = [self.dataArray objectAtIndex:delIndexPath.row];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:lvModel.v_id forKey:@"vid"];
        [params setObject:User_Token forKey:@"token"];
        [AFRequestManager SafeGET:URI_DelVedio parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *result = responseObject;
            NSLog(@"%@",result);
            if ([result[@"status"] intValue] == 200) {
                [self.dataArray removeObjectAtIndex:[delIndexPath row]];  //删除数组里的数据
                [self.tableView reloadData];
                if (self.dataArray>0) {
                    self.tableViewHeaderView.titleLabel.text = [NSString stringWithFormat:@"%lu个精彩回放",self.dataArray.count];
                }else{
                    self.tableView.hidden = YES;
                    [self showPromptViewWithText:@"你还没有直播录像，赶紧开播记录一下吧"];
                }
            }else{
                [self showMPNotificationViewWithErrorMessage:@"删除失败，请重新尝试。"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [self showMPNotificationViewWithErrorMessage:@"网络请求失败，请检查您的网络。"];
        }];
    }
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
