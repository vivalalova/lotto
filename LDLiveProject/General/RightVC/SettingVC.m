//
//  SettingVC.m
//  LDLiveProject
//
//  Created by MAC on 16/6/22.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "SettingVC.h"
#import "SDImageCache.h"
#import "AboutUsVC.h"
#import "BlackListVC.h"
#import "AccountSecurityVC.h"


@interface SettingVC ()<UIAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>
{
    UITableView *mTableView;
    NSString *cacheDataSizeStr;
}
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    cacheDataSizeStr = @"0.00M";
    [self setUsualNavigationBarWithBackAndTitleWithString:@"设置"];
    
    mTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    mTableView.dataSource = self;
    mTableView.delegate = self;
    [mTableView setSeparatorColor:[UIColor colorWithHexString:@"0xdadada"]];
    mTableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:mTableView];
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf0eff5"];
    mTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self countCacheDataSize];
    // Do any additional setup after loading the view from its nib.
}

- (void)actionClickNavigationBarLeftButton
{
    [super actionClickNavigationBarLeftButton];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)countCacheDataSize
{
    int cacheSize = [[SDImageCache sharedImageCache]getDiskSize];
    float cacheSizeF = cacheSize;
    float cacheSizeM = cacheSizeF/1024/1024;
    cacheDataSizeStr = [NSString stringWithFormat:@"%.2fM",cacheSizeM];
    [mTableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }else if (section == 1){
        return 2;
    }else if (section == 2){
        return 1;
    }else{
        return 0;
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 44;
    }else{
        return 44;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    view.backgroundColor = [UIColor colorWithHexString:@"0xf0eff5"];
    return view;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [self SetupUsualTableViewCellWithString:@"账户安全"];
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 43.5, SCREEN_WIDTH-20, 0.5)];
            lineLabel.backgroundColor = UIColorFromRGB(230, 230, 230);
            [cell addSubview:lineLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1) {
            UITableViewCell *cell = [self SetupUsualTableViewCellWithString:@"黑名单"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UITableViewCell *cell = [self SetupUsualMoreTableViewCellWithString:@"清理缓存" modelStr:cacheDataSizeStr];
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 43.5, SCREEN_WIDTH-20, 0.5)];
            lineLabel.backgroundColor = UIColorFromRGB(230, 230, 230);
            [cell addSubview:lineLabel];
            return cell;
        }else if (indexPath.row == 1){
            UITableViewCell *cell = [self SetupUsualMoreTableViewCellWithString:@"关于我们" modelStr:@""];
            return cell;
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
            label.font = [UIFont systemFontOfSize:16];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"退出登录";
            [cell addSubview:label];
            return cell;
        }
    }
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

-(UITableViewCell*)SetupUsualTableViewCellWithString:(NSString*)str
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = str;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-32+10, 15, 8, 14)];
    imageV.image = [UIImage imageNamed:@"returndown.png"];
    [cell addSubview:imageV];
    return cell;
}

-(UITableViewCell*)SetupUsualMoreTableViewCellWithString:(NSString*)str modelStr:(NSString*)modelStr
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text = str;
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-160-10, 0, 160, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentRight;
    label.text = modelStr;
    [cell addSubview:label];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            AccountSecurityVC *asVC = [[AccountSecurityVC alloc]init];
            [self.navigationController pushViewController:asVC animated:YES];
        }else if (indexPath.row == 1) {
            //黑名单
            BlackListVC *blackVC = [[BlackListVC alloc]init];
            [self.navigationController pushViewController:blackVC animated:YES];
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            //清理缓存
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"您确定要清除缓存吗?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.delegate = self;
            [alertView show];
        }else if (indexPath.row == 1){
            //关于我们
            AboutUsVC *avc = [[AboutUsVC alloc]init];
            [self.navigationController pushViewController:avc animated:YES];
        }
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            //退出登录
            [AccountHelper logout];
            AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
            [appdelegate showLoginViewController];
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[SDImageCache sharedImageCache] clearDisk];
        int cacheSize = [[SDImageCache sharedImageCache]getDiskSize];
        float cacheSizeF = cacheSize;
        float cacheSizeM = cacheSizeF/1024/1024;
        _cacheLabel.text = [NSString stringWithFormat:@"%.2fM",cacheSizeM];
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
