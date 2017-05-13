//
//  RechargeVC.m
//  LDLiveProject
//
//  Created by MAC on 16/7/7.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "RechargeVC.h"
#import "RechargeCell.h"
#import "RechargeModel.h"
#import "UserModel.h"
#import "IAPHelper.h"
#import "IAPHelperManager.h"

@interface RechargeVC ()<UITableViewDelegate,UITableViewDataSource,RechargeCellDelegate>
{
    NSMutableArray *dataArray;
    UserModel *_userModel;
    UIWebView *phoneCallWebView;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *titleLabelView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSArray *products;//存储商品列表

@end

@implementation RechargeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _userModel = [AccountHelper userInfo];
    [self setUsualNavigationBarWithBackAndTitleWithString:@"我的钻石"];
    [self UIInit];
    [self sendURI_IosProduceList];
    // Do any additional setup after loading the view from its nib.
}
- (void)UIInit
{
    _contentView.backgroundColor = [UIColor colorWithHexString:@"0xefeff5"];
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [_tableView setSeparatorColor:[UIColor colorWithHexString:@"0xdadada"]];
    _tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _titleLabelView.font = [UIFont systemFontOfSize:16];
    _titleLabelView.textColor = [UIColor colorWithHexString:@"0xec6d69"];
    _titleLabelView.attributedText = nil;
    [_titleLabelView appendText:@" "];
    [_titleLabelView appendImage:[UIImage imageNamed:@"diam"]];
    [_titleLabelView appendText:@" "];
    [_titleLabelView appendText:_userModel.gold];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshTableViewData:) name:kProductsLoadedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paymentFinished:) name:kProductPurchasedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paymentFailed:) name:kProductPurchaseFailedNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(verifyFinished:) name:kProductVerifyNodtification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(verifyFailed:) name:kProductVerifyFailedNodtification object:nil];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super viewWillDisappear:animated];
}


#pragma mark tableviewDelegate
//header
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
    label.backgroundColor = [UIColor colorWithHexString:@"f7f1f1"];
    label.text = @"     充值:";
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor darkGrayColor];
    return label;
}

//footer
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 80;
}
- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, SCREEN_WIDTH, 80);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setTitleColor:[UIColor colorWithHexString:@"0xec6d69"] forState:UIControlStateNormal];
    [button setTitle:@"充值问题，点此联系客服" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(connectServerPerson:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}
- (void)connectServerPerson:(UIButton *)button
{
    NSString *phoneNum = @"010-57206105";// 电话号码
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",phoneNum]];
    if ( !phoneCallWebView ) {
        phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
    }
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
}
//////
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ident = @"RechargeCell";
    RechargeCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:ident owner:self options:nil];
        cell = (RechargeCell*)objects[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    cell.product = [self.products objectAtIndex:indexPath.row];
    cell.rechargeModel = [dataArray objectAtIndex:indexPath.row];
    [cell setRechargeCellUIwithRechargeModel:[dataArray objectAtIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark RechargeCellDelegate
-(void)inPurchaseWith:(SKProduct *)product
{
    [self showKVNProgress];
    IAPHelperManager *helper=[IAPHelperManager sharedHelper];
    [helper paymentWithProduct:product];
}


#pragma mark  requests
- (void)sendURI_IosProduceList
{
    [self showActivityIndicatorView];
    [AFRequestManager SafeGET:URI_IosProduceList parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            NSArray *list = [[result objectForKey:@"data"] objectForKey:@"list"];
            _tableView.hidden = NO;
            [dataArray removeAllObjects];
            NSMutableSet *productSet=[NSMutableSet set];

            if ([list isKindOfClass:[NSArray class]]) {
                dataArray = [NSMutableArray arrayWithCapacity:list.count];
                for (NSDictionary *dic in list) {
                    RechargeModel *rechargeModel = [[RechargeModel alloc] initWithDictionary:dic error:nil];
                    [dataArray addObject:rechargeModel];
                    [productSet addObject:rechargeModel.g_id];
                }
                IAPHelperManager *helper=[IAPHelperManager sharedHelper];
                [helper requestProducts:productSet];
            }
//            dispatch_async(dispatch_get_main_queue(), ^{
//                if (dataArray.count>0) {
//                    [_tableView reloadData];
//                }else{
//                    _tableView.hidden = YES;
//                }
//            });
        }else{
            _tableView.hidden = YES;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark  NSNotification
-(void)refreshTableViewData:(NSNotification *)notification{
    self.products=[self sortedArrayDesceding:(NSArray *)notification.object];
    if (dataArray.count!=self.products.count) {
        NSMutableArray *array=[NSMutableArray array];
        for (SKProduct *procudt in self.products) {
            for (RechargeModel *model  in dataArray) {
                if ([procudt.productIdentifier isEqualToString:model.g_id]) {
                    [array addObject:model];
                }
            }
        }
        [dataArray removeAllObjects];
        dataArray=array;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        if (dataArray.count>0) {
            [_tableView reloadData];
        }else{
            _tableView.hidden = YES;
        }
    });
    [self hideActivityIndicatorView];
}
-(NSArray *)sortedArrayDesceding:(NSArray *)array{
    NSComparator cmptr = ^(SKProduct *obj1, SKProduct *obj2){
        if ([obj1.price integerValue] > [obj2.price integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        if ([obj1.price integerValue] < [obj2.price integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    return [array sortedArrayUsingComparator:cmptr];
}

-(void)paymentFinished:(NSNotification *)notification{
    [self showKVNProgress];
    [MPNotificationView notifyWithText:@""
                                detail:@"正在验证,请暂不要执行其他操作，稍等片刻…"
                         andTouchBlock:^(MPNotificationView *notificationView) {
                             NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                         }];
}
-(void)verifyFinished:(NSNotification *)notification{
    [self hideKVNProgress];
    [MPNotificationView notifyWithText:@""
                                detail:@"恭喜您，充值成功"
                         andTouchBlock:^(MPNotificationView *notificationView) {
                             NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                         }];
    _titleLabelView.attributedText = nil;
    [_titleLabelView appendText:@" "];
    [_titleLabelView appendImage:[UIImage imageNamed:@"diam"]];
    [_titleLabelView appendText:@" "];
    [_titleLabelView appendText:_userModel.gold];
}
-(void)verifyFailed:(NSNotification *)notification{
    [self hideKVNProgress];
    if (notification.object) {
        [MPNotificationView notifyWithText:@""
                                    detail:[NSString stringWithFormat:@"%@",notification.object]
                             andTouchBlock:^(MPNotificationView *notificationView) {
                                 NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                             }];
    }else{
        [MPNotificationView notifyWithText:@""
                                    detail:@"验证失败,如有疑问请联系客服"
                             andTouchBlock:^(MPNotificationView *notificationView) {
                                 NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                             }];
    }
}
-(void)paymentFailed:(NSNotification *)notification{
    [self hideKVNProgress];
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
