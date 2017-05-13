//
//  MyFriendListVC.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/5/16.
//  Copyright © 2016年 Mac. All rights reserved.
//

#define kNavBarTitleLabelFont [UIFont boldSystemFontOfSize:19.0f]
#define PageNum  @"20"

#import "MyFriendListVC.h"
#import "MyFirendCell.h"
#import "ChatPrivateVC.h"
#import "MessListModel.h"
@interface MyFriendListVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSTimer *timer;
    SRRefreshView   *_slimeView;
    //页数标记
    NSInteger currentPage;
    NSInteger totalPage;

}
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong)UIButton *firendBtn;//好友
@property(nonatomic,strong)UIView *redPoint2;
@property(nonatomic,strong)UIButton *unAttentionBtn;//未关注
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIButton *selectBtn;//当前选中的按钮
@end

@implementation MyFriendListVC

- (UITableView*)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
         _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}


- (UIView *)redPoint2{
    if (_redPoint2==nil) {
        _redPoint2=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 8)];
        _redPoint2.backgroundColor=[UIColor redColor];
        _redPoint2.layer.cornerRadius=_redPoint2.width/2;
        _redPoint2.layer.masksToBounds=YES;
        [_redPoint2 setRight:_unAttentionBtn.width];
        [_unAttentionBtn addSubview:_redPoint2];
        _redPoint2.hidden=YES;
    }
    return _redPoint2;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.dataArray removeAllObjects];
    [self sendRequestOfGetChatListRequestWithPageNumber:1 withType:2];
    [self sendRequestOfGetChatListRequestWithPageNumber:1 indicatorViewBool:YES];
    if (timer==nil) {
        timer =[NSTimer scheduledTimerWithTimeInterval:kListRefreshTime target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
    }
}
- (void)timerClick{
    [self sendRequestOfGetChatListRequestWithPageNumber:1 indicatorViewBool:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [timer invalidate];
    timer=nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    
    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor blackColor];
    _slimeView.slime.skinColor = [UIColor whiteColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor blackColor];
    
    UIView *mheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SELFVIEW_WIDTH, 0)];
    self.tableView.tableHeaderView = mheaderView;
    [self.tableView addSubview:_slimeView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [_slimeView update:0];
    
    [self setUsualNavigationBarWithBackAndTitleWithString:@""];
    [self.view addSubview:self.tableView];
    [self createSegmentView];
    self.tableView.backgroundColor=[UIColor clearColor];
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
    [self sendRequestOfGetChatListRequestWithPageNumber:1 indicatorViewBool:YES];
}


-(void)createSegmentView{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 185, 64-[[UIApplication sharedApplication]statusBarFrame].size.height)];
    view.backgroundColor=[UIColor clearColor];
    [view setCenterX:SCREEN_WIDTH/2];
    [view setTop:[[UIApplication sharedApplication]statusBarFrame].size.height];
    [self.view addSubview:view];
    _firendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _firendBtn.frame=CGRectMake(10, 10, 60, view.height-20);
    _firendBtn.titleLabel.font=kNavBarTitleLabelFont;
    _firendBtn.titleLabel.textColor=[UIColor whiteColor];
    _firendBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [_firendBtn setTitle:@"好友" forState:UIControlStateNormal];
    _firendBtn.tag=100+1;
    [_firendBtn addTarget:self action:@selector(chooseListBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_firendBtn];
    _unAttentionBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _unAttentionBtn.frame=CGRectMake(0, _firendBtn.top, _firendBtn.width, _firendBtn.height);
    _unAttentionBtn.titleLabel.font=kNavBarTitleLabelFont;
    _unAttentionBtn.titleLabel.textColor=[UIColor whiteColor];
    _unAttentionBtn.titleLabel.textAlignment=NSTextAlignmentCenter;
    [_unAttentionBtn setTitle:@"未关注" forState:UIControlStateNormal];
    [_unAttentionBtn setRight:view.width-10];
    _unAttentionBtn.tag=100+2;
    [_unAttentionBtn addTarget:self action:@selector(chooseListBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:_unAttentionBtn];
    _lineView=[[UIView alloc]initWithFrame:CGRectMake(0, _firendBtn.bottom, _unAttentionBtn.width/3*2, 2)];
    _lineView.backgroundColor=[UIColor whiteColor];
    [view addSubview:_lineView];
    [_lineView setCenterX:_firendBtn.centerX];
    _selectBtn=_firendBtn;
    
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    saveButton.frame = CGRectMake(SCREEN_WIDTH-70-5, 20, 70, NAV_BAR_HEIGHT);
    saveButton.titleLabel.font = [UIFont systemFontOfSize:CustomFont(15)];
    [saveButton setTitle:@"忽略全部" forState:UIControlStateNormal];
    [saveButton addTarget: self action:@selector(IgnoreAllButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveButton];
    
}
- (void)IgnoreAllButtonClick:(UIButton*)button
{
    NSDictionary *params=@{@"token":User_Token};
    
    [AFRequestManager SafePOST:URI_readAllMsg parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
        [_slimeView endRefresh];
        if ([result[@"status"] intValue] == 200) {
            [self sendRequestOfGetChatListRequestWithPageNumber:1 withType:1];
            [self sendRequestOfGetChatListRequestWithPageNumber:1 withType:2];
            [self sendRequestOfGetChatListRequestWithPageNumber:1 indicatorViewBool:YES];
            [self showMPNotificationViewWithErrorMessage:@"已全部标记为已读"];
        }else{
            [self showMPNotificationViewWithErrorMessage:[NSString stringWithFormat:@"%@",result[@"data"]]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showMPNotificationViewWithErrorMessage:@"网络请求失败"];
    }];
}
- (void)chooseListBtnClick:(UIButton *)button{
    if (_selectBtn!=button) {
        _selectBtn=button;
        if (button.tag==100+1) {//好友
            [_lineView setWidth:button.width/3*2];
        }
        if (button.tag==100+2) {//未关注
            [_lineView setWidth:button.width];
        }
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        [_lineView setCenterX:button.centerX];
        [self sendRequestOfGetChatListRequestWithPageNumber:1 indicatorViewBool:YES];
    }
}


-(NSString *)defaultNoDataPromptText{
    return @"抱歉！当前无聊天记录";
}
#pragma mark 网络请求
//获取是否有未读消息
- (void)sendRequestOfGetChatListRequestWithPageNumber:(int)pageNum withType:(int)type{
    NSDictionary *params=@{@"token":User_Token,@"size":PageNum,@"page":[NSString stringWithFormat:@"%d",pageNum],@"type":[NSString stringWithFormat:@"%d",type]};
    [AFRequestManager SafePOST:URI_MessageList parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([result[@"status"] intValue] == 200) {
            NSMutableArray *array = [NSMutableArray array];
            NSArray *list = [[result objectForKey:@"data"] objectForKey:@"user_list"];
            if ([list isKindOfClass:[NSArray class]]) {
                array = [NSMutableArray arrayWithCapacity:list.count];
                for (NSDictionary *dic in list) {
                    [array addObject:[[MessListModel alloc] initWithDictionary:dic error:nil]];
                }
            }
                        int a=0;
                        for (MessListModel *model in array) {
                            if ([model.num intValue]>0) {
                                if (type==1) {
                                    //self.redPoint1.hidden=NO;
                                }else{
                                    self.redPoint2.hidden=NO;
                                }
                                break;
                            }
                            a++;
                        }
                        if (a==array.count) {
                            if (type==1) {
                                //self.redPoint1.hidden=YES;
                            }else{
                                self.redPoint2.hidden=YES;
                            }
                        }
        }else{
            [self showMPNotificationViewWithErrorMessage:[NSString stringWithFormat:@"%@",result[@"data"]]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showMPNotificationViewWithErrorMessage:@"网络请求失败"];
    }];
}
//获取好友列表
- (void)sendRequestOfGetChatListRequestWithPageNumber:(int)pageNum indicatorViewBool:(BOOL)boolView{
    [self showActivityIndicatorView];
    NSString *type=@"1";
    if (_selectBtn.tag==100+1) {
        type=@"1";
    }
    if (_selectBtn.tag==100+2) {
        type=@"2";
    }
    NSDictionary *params=@{@"token":User_Token,@"size":PageNum,@"page":[NSString stringWithFormat:@"%d",pageNum],@"type":type};
    
    [AFRequestManager SafePOST:URI_MessageList parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
        [self hideActivityIndicatorView];
        [_slimeView endRefresh];
        if ([result[@"status"] intValue] == 200) {
            [self hidePromptView];
            currentPage = [result[@"data"][@"curr_page"] integerValue];
            totalPage = [result[@"data"][@"max_page"] integerValue];
            if ([result objectForKey:@"data"]) {
                NSMutableArray *array = [NSMutableArray array];
                NSArray *list = [[result objectForKey:@"data"] objectForKey:@"user_list"];
                if ([list isKindOfClass:[NSArray class]]) {
                    array = [NSMutableArray arrayWithCapacity:list.count];
                    for (NSDictionary *dic in list) {
                        [array addObject:[[MessListModel alloc] initWithDictionary:dic error:nil]];
                    }
                }
                if (currentPage == 1) {
                    self.dataArray = array;
                }else{
                    [self.dataArray addObjectsFromArray:array];
                }
                
                int a=0;
                for (MessListModel *model in self.dataArray) {
                                if ([model.num intValue]>0) {
                                    if ([type intValue]==1) {
                                        //self.redPoint1.hidden=NO;
                                    }else{
                                        self.redPoint2.hidden=NO;
                                    }
                                    break;
                                }
                                a++;
                            }
                            if (a==self.dataArray.count) {
                                if ([type intValue]==1) {
                                    //self.redPoint1.hidden=YES;
                                }else{
                                    self.redPoint2.hidden=YES;
                                }
                            }
            }
            [self.tableView reloadData];
            if (self.dataArray.count<1) {
                [self showNoDataPromptView];
            }
        }else{
            [self showNoDataPromptView];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_slimeView endRefresh];
        [self hideActivityIndicatorView];
        [self showMPNotificationViewWithErrorMessage:@"网络请求失败"];
    }];
}
//删除和某个用户的所有消息
-(void)sendRequestOfDelUserAllWithIndexPath:(NSIndexPath *)indexPath{
    MessListModel *model=self.dataArray[indexPath.row];
    NSDictionary *params=@{@"token":User_Token,@"uid":model.uid};
    
    [AFRequestManager SafePOST:URI_DelUserAll parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([result[@"status"] intValue] == 200) {
            [_slimeView endRefresh];
            [self hidePromptView];
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];
        }else{
            [self showMPNotificationViewWithErrorMessage:[NSString stringWithFormat:@"%@",result[@"data"]]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showMPNotificationViewWithErrorMessage:@"网络请求失败"];
    }];
}
#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"MyFirendCell";
    MyFirendCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MyFirendCell" owner:nil options:nil]lastObject];
    }
    if (indexPath.row == [PageNum intValue] *currentPage) {
        [self sendRequestOfGetChatListRequestWithPageNumber:currentPage+1 indicatorViewBool:YES];
    }
    cell.chatListModel=self.dataArray[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatPrivateVC *chatVC=[[ChatPrivateVC alloc]init];
    if (self.dataArray.count>indexPath.row) {
        chatVC.chatListModel=self.dataArray[indexPath.row];   
    }else{
        return;
    }
    [self.navigationController pushViewController:chatVC animated:YES];
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
        [self sendRequestOfDelUserAllWithIndexPath:indexPath];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
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
