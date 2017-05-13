//
//  WXAdvanceRecord.m
//  LDLiveProject
//
//  Created by MAC on 2016/11/28.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "WXAdvanceRecord.h"
#import "WXRecordModel.h"
#import "WXRecordCell.h"

@interface WXAdvanceRecord ()<UITableViewDelegate,UITableViewDataSource,SRRefreshDelegate>
{
    NSMutableArray *dataArray;
    SRRefreshView   *_slimeView;
    //页数标记
    NSInteger currentPage;
    NSInteger totalPage;
    UILabel *label;
}
@property (nonatomic,strong)UITableView*tableview;
@end

@implementation WXAdvanceRecord

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUsualNavigationBarWithBackAndTitleWithString:@"提现记录"];
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
    
    _tableview = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.width, SCREEN_HEIGHT-64)];
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
    [self sendURI_wxcashRequestOFPageNum:@"1"];
    
    
    // Do any additional setup after loading the view from its nib.
}
- (void)viewWillAppear:(BOOL)animated
{
    [self sendURI_wxcashRequestOFPageNum:@"1"];
    
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
    static NSString *ident = @"WXRecordCell";
    WXRecordCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:ident owner:self options:nil];
        cell = (WXRecordCell*)objects[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.width = SCREEN_WIDTH;
    }
    if (indexPath.row == currentPage*20 -1 && currentPage<=totalPage) {
        NSString *pageNum = [NSString stringWithFormat:@"%ld",currentPage+1];
        [self sendURI_wxcashRequestOFPageNum:pageNum];
    }
    [cell setWxRecordModel:[dataArray objectAtIndex:indexPath.row]];
    return cell;
    return nil;
}


- (void)sendURI_wxcashRequestOFPageNum:(NSString *)pageNum
{
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:User_Token forKey:@"token"];
    [paramToken setObject:pageNum forKey:@"page"];
    [paramToken setObject:@"20" forKey:@"size"];
    [AFRequestManager SafeGET:URI_PayWXCash parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
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
                        WXRecordModel *lvModel = [[WXRecordModel alloc] initWithDictionary:dic error:nil];
                        [dataArray addObject:lvModel];
                    }
                }
            }else{
                NSArray *list = [result objectForKey:@"data"][@"list"];
                if ([list isKindOfClass:[NSArray class]]) {
                    for (NSDictionary *dic in list) {
                        WXRecordModel *lvModel = [[WXRecordModel alloc] initWithDictionary:dic error:nil];
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
    [self sendURI_wxcashRequestOFPageNum:@"1"];
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
