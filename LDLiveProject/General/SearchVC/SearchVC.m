//
//  SearchVC.m
//  LDLiveProject
//
//  Created by MAC on 16/7/4.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "SearchVC.h"
#import "HostDetailInfoModel.h"
#import "AttentionCell.h"
#import "PersonInfoModel.h"
#import "UserDetailVCViewController.h"

@interface SearchVC ()<UITableViewDelegate,UITableViewDataSource,AttentionCellDelegate,UITextFieldDelegate>
{
    NSMutableArray *dataArray;
}
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *navBarView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextFiled;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UILabel *searchLabel;

@property (weak, nonatomic) IBOutlet UIView *searchBGView;
@property (weak, nonatomic) IBOutlet UILabel *promptLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation SearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self UIInit];
    // Do any additional setup after loading the view from its nib.
}

- (void)UIInit
{
    _navBarView.backgroundColor = [UIColor colorWithHexString:@"0x2f3639"];
    _searchLabel.layer.cornerRadius = _searchLabel.height/2;
    _searchLabel.layer.masksToBounds = YES;
    
    _tableview.dataSource = self;
    _tableview.delegate = self;
    [_tableview setSeparatorColor:[UIColor colorWithHexString:@"0xdadada"]];
    _tableview.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    _tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [[UITextField appearance] setTintColor:[UIColor colorWithHexString:@"0x2f3639"]];
    _searchTextFiled.delegate = self;
    [_searchTextFiled setReturnKeyType:UIReturnKeySearch];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fieldTextChanged:) name:UITextFieldTextDidChangeNotification object:_searchTextFiled];
    [_searchTextFiled becomeFirstResponder];
    [super viewWillAppear:animated];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super viewWillDisappear:animated];
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
- (void)sendURI_SearchRequest
{
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:User_Token forKey:@"token"];
    [paramToken setObject:_searchTextFiled.text forKey:@"keyword"];
    [AFRequestManager SafeGET:URI_IndexSearch parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            NSArray *list = [result objectForKey:@"data"];
            _tableview.hidden = NO;
            [dataArray removeAllObjects];
            if ([list isKindOfClass:[NSArray class]]) {
                dataArray = [NSMutableArray arrayWithCapacity:list.count];
                for (NSDictionary *dic in list) {
                    HostDetailInfoModel *hostDetailInfoModel = [[HostDetailInfoModel alloc] initWithDictionary:dic error:nil];
                    [dataArray addObject:hostDetailInfoModel];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (dataArray.count>0) {
                    [_tableview reloadData];
                    [_searchTextFiled resignFirstResponder];
                }else{
                    _tableview.hidden = YES;
                }
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
#pragma mark texfiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendURI_SearchRequest];
    return YES;
}

#pragma mark - NSNotification

- (void)fieldTextChanged:(NSNotification *)notification
{
    @try{
        UITextField *textField = (UITextField *)notification.object;
        if (textField.text.length>0) {
            _searchLabel.text = @"";
        }else{
            _searchLabel.text = @"  输入您想要的用户";
        }
    }
    @catch(NSException *exception) {
        NSLog(@"exception:%@", exception);
    }
    @finally {
        
    }
}

#pragma mark  buttonClickAction

- (IBAction)cancelButtonClick:(id)sender {
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
