//
//  RightVC.m
//  LDLiveProject
//
//  Created by MAC on 16/6/6.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "RightVC.h"
#import "RightFuncCell.h"
#import "UserModel.h"
#import "EditInfoVC.h"
#import "SettingVC.h"
#import "HeaderImageEditVC.h"
#import "AttentionVC.h"
#import "FansVC.h"
#import "RechargeVC.h"
#import "CommonUtils.h"
#import "SearchVC.h"
#import "WeskitVC.h"
#import "BadgeButton.h"
#import "MyFriendListVC.h"
#import "CreditListVC.h"
#import "RightFuncMoreCell.h"
#import "LevelVC.h"
#import "WXwithdrawalVC.h"
#import "LiveVideoVC.h"
#import "VIPVC.h"

@interface RightVC ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,RightFuncCellDelegate,RightFuncMoreCellDelegate>
{
    UIImageView *headerGroundImageView;
    M80AttributedLabel *consLabel;
    WebImageView *headerImageView;
    UIImageView *vip_icon;
    M80AttributedLabel *roomNumLabel;
    M80AttributedLabel *nickNameLabel;
    UIButton *focusButton;
    UIButton *fansButton;
    UserModel *_userModel;
    //马甲视图
    M80AttributedLabel *weskitLabel;
#pragma mark 消息按钮
    BadgeButton *messageButton;
#pragma mark testVersion
    BOOL testVersionBool;
}
@property (nonatomic, strong)UITableView *tableView;

@end

@implementation RightVC

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([appVersion isEqualToString:[KAPP_DELEGATE ver_test]]) {
        testVersionBool = YES;
    }else{
        testVersionBool = NO;
    }
    
    _userModel = [AccountHelper userInfo];
    self.navigationController.navigationBar.hidden = YES;
    [self UIInit];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden=NO;
    [self refeshUI];
    [self sendUserInfoRequest];
    [self sendVestLvRequest];
    [self sendLiveVideoRequest];
}

-(void)UIInit
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf4f4f4"];
    
    headerGroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_WIDTH*2/3+40)];
    headerGroundImageView.image = [UIImage imageNamed:@"me_ground"];
    [self.view addSubview:headerGroundImageView];

    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SELFVIEW_WIDTH, SELFVIEW_HEIGHT-TAB_BAR_HEIGHT) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [self getTableViewHeaderView];
}

-(void)refeshUI
{
    _userModel = [AccountHelper userInfo];
    [headerImageView setImageWithUrlString:_userModel.portrait placeholderImage:[UIImage imageByApplyingAlpha:1 color:[UIColor lightGrayColor]]];
    if (_userModel.super_vip.intValue) {
        vip_icon.hidden = NO;
    }else{
        vip_icon.hidden = YES;
    }
    
    nickNameLabel.attributedText = nil;
    [nickNameLabel appendText:[NSString stringWithFormat:@"%@ ",_userModel.nick]];
    if (_userModel.gender.intValue) {
        [nickNameLabel appendView:[self getUserSexViewWithString:@"1"]];
    }else{
        [nickNameLabel appendView:[self getUserSexViewWithString:@"0"]];
    }
    [nickNameLabel appendText:@" "];
    [nickNameLabel appendView:[self getUserLevelViewWithLevelString:_userModel.level]];
    [nickNameLabel appendText:@" "];
    [nickNameLabel appendImage:[UIImage imageNamed:@"me_edit"]];
    
    [self setConsLabelwithNumStr:_userModel.send_gold];
    [[NSUserDefaults standardUserDefaults]setObject:_userModel.gold forKey:@"gold"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    RightFuncCell *cell = (RightFuncCell*)[_tableView cellForRowAtIndexPath:indexPath];
    [cell setDataWithUserModel:_userModel];
    NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
    RightFuncMoreCell *cell1 = (RightFuncMoreCell*)[_tableView cellForRowAtIndexPath:indexPath1];
    [cell1 setFuncMoreDataWithUserModel:_userModel];
    
    [focusButton setTitle:[NSString stringWithFormat:@"关注 %@",_userModel.attention] forState:UIControlStateNormal];
    [fansButton setTitle:[NSString stringWithFormat:@"粉丝 %@",_userModel.fans] forState:UIControlStateNormal];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

#pragma mark tableviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (testVersionBool) {
        return 5;
    }
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0){
        return SCREEN_WIDTH/3+6;
    }else if (indexPath.row == 1){
        return SCREEN_WIDTH/3+6;
    }else if (indexPath.row == 2){
        return TAB_BAR_HEIGHT+5;
    }else if (indexPath.row == 3){
        return TAB_BAR_HEIGHT;
    }else if (indexPath.row == 4){
        return TAB_BAR_HEIGHT;
    }else if (indexPath.row == 5){
        return TAB_BAR_HEIGHT;
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RightFuncMoreCell" owner:self options:nil];
        RightFuncMoreCell *cell = (RightFuncMoreCell*)objects[0];
        cell.width = SCREEN_WIDTH;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 1) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"RightFuncCell" owner:self options:nil];
        RightFuncCell *cell = (RightFuncCell*)objects[0];
        cell.width = SCREEN_WIDTH;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TAB_BAR_HEIGHT)];
        view.backgroundColor = [UIColor whiteColor];
        [cell addSubview:view];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
        label.text = @"球票贡献榜";
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentLeft;
        [view addSubview:label];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-12, (TAB_BAR_HEIGHT-9)/2, 5, 9)];
        imageView.image = [UIImage imageNamed:@"me_goahead"];
        [view addSubview:imageView];
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, TAB_BAR_HEIGHT-0.8, SCREEN_WIDTH, 0.8)];
        lineLabel.backgroundColor = [UIColor colorWithHexString:@"0xf4f4f4"];
        [view addSubview:lineLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (indexPath.row == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
        label.text = @"我的马甲";
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:15];
        [cell addSubview:label];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-12, (TAB_BAR_HEIGHT-9)/2, 5, 9)];
        imageView.image = [UIImage imageNamed:@"me_goahead"];
        [cell addSubview:imageView];
        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, TAB_BAR_HEIGHT-0.8, SCREEN_WIDTH, 0.8)];
        lineLabel.backgroundColor = [UIColor colorWithHexString:@"0xf4f4f4"];
        [cell addSubview:lineLabel];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    if (testVersionBool) {
        if (indexPath.row == 4) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
            label.text = @"设置";
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:label];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-12, (TAB_BAR_HEIGHT-9)/2, 5, 9)];
            imageView.image = [UIImage imageNamed:@"me_goahead"];
            [cell addSubview:imageView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        if (indexPath.row == 4) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
            label.text = @"我的特权";
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentLeft;
            [cell addSubview:label];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-12, (TAB_BAR_HEIGHT-9)/2, 5, 9)];
            imageView.image = [UIImage imageNamed:@"me_goahead"];
            [cell addSubview:imageView];
            UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, TAB_BAR_HEIGHT-0.8, SCREEN_WIDTH, 0.8)];
            lineLabel.backgroundColor = [UIColor colorWithHexString:@"0xf4f4f4"];
            [cell addSubview:lineLabel];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
    }
    }
    if (indexPath.row == 5) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 300, 44)];
        label.text = @"设置";
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentLeft;
        [cell addSubview:label];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-12, (TAB_BAR_HEIGHT-9)/2, 5, 9)];
        imageView.image = [UIImage imageNamed:@"me_goahead"];
        [cell addSubview:imageView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 2) {
        self.tabBarController.tabBar.hidden=YES;
        CreditListVC *cvc = [[CreditListVC alloc]init];
        cvc.CreditListVCDelegateResponseBool = NO;
        cvc.aesIdStr = _userModel.pid;
        cvc.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [self.navigationController pushViewController:cvc animated:YES];
    }
    if (indexPath.row == 3) {
        self.tabBarController.tabBar.hidden=YES;
        WeskitVC *wvc = [[WeskitVC alloc]init];
        [self.navigationController pushViewController:wvc animated:YES];
    }
    if (testVersionBool) {
        if (indexPath.row == 4) {
            self.tabBarController.tabBar.hidden=YES;
            SettingVC *svc = [[SettingVC alloc]init];
            [self.navigationController pushViewController:svc animated:YES];
        }
    }else{
        if (indexPath.row == 4) {
            self.tabBarController.tabBar.hidden=YES;
            VIPVC *vipvc = [[VIPVC alloc]init];
            [self.navigationController pushViewController:vipvc animated:YES];
        }
    }
    if (indexPath.row == 5) {
        self.tabBarController.tabBar.hidden=YES;
        SettingVC *svc = [[SettingVC alloc]init];
        [self.navigationController pushViewController:svc animated:YES];
    }
}

#pragma custom cell
- (UIView *)getTableViewHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*2/3)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 20, NAV_BAR_HEIGHT, NAV_BAR_HEIGHT);
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchButton addTarget: self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:searchButton];
    
    messageButton = [[BadgeButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - NAV_BAR_HEIGHT, 20, NAV_BAR_HEIGHT, NAV_BAR_HEIGHT)];
    messageButton.userInteractionEnabled = YES;
    [messageButton addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:messageButton];

    
    consLabel = [[M80AttributedLabel alloc]initWithFrame:CGRectMake(NAV_BAR_HEIGHT, 35, SCREEN_WIDTH-NAV_BAR_HEIGHT*2, 32)];
    consLabel.backgroundColor = [UIColor clearColor];
    consLabel.textColor = [UIColor whiteColor];
    consLabel.font = [UIFont systemFontOfSize:CustomFont(14)];
    consLabel.textAlignment = NSTextAlignmentRight;
    [consLabel appendImage:[UIImage imageNamed:@"diam"]];
    [consLabel appendText:@" 送出 0"];
    [headerView addSubview:consLabel];
    
    UIView *imageBGview = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH/5)/2, 64, SCREEN_WIDTH/5, SCREEN_WIDTH/5)];
    imageBGview.backgroundColor = [UIColor clearColor];
    [headerView addSubview:imageBGview];
    
    headerImageView = [[WebImageView alloc]initWithFrame:CGRectMake(2, 2, imageBGview.width-4, imageBGview.width-4)];
    [headerImageView setImageWithURL:nil placeholderImage:[UIImage imageByApplyingAlpha:1 color:[UIColor colorWithHexString:@"0xa4acaf"]]];
    headerImageView.layer.cornerRadius = headerImageView.width/2;
    headerImageView.layer.masksToBounds = YES;
    headerImageView.userInteractionEnabled = YES;
    [headerImageView setImageWithUrlString:_userModel.portrait placeholderImage:[UIImage imageByApplyingAlpha:1 color:[UIColor lightGrayColor]]];
    [imageBGview addSubview:headerImageView];
    
    vip_icon = [UIImageView new];
    vip_icon.size = CGSizeMake(15, 15);
    vip_icon.origin = CGPointMake(headerImageView.origin.x +headerImageView.width-18, headerImageView.origin.y +headerImageView.height-18);
    vip_icon.image = [UIImage imageNamed:@"vip_icon"];
    vip_icon.hidden = YES;
    [imageBGview addSubview:vip_icon];
    
    UITapGestureRecognizer *tapGeR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(headerImageViewTapGeRAction:)];
    [headerImageView addGestureRecognizer:tapGeR];
    
    roomNumLabel = [[M80AttributedLabel alloc]initWithFrame:CGRectMake(0, imageBGview.bottom+10, SCREEN_WIDTH, 20)];
    roomNumLabel.backgroundColor = [UIColor clearColor];
    roomNumLabel.textColor = [UIColor whiteColor];
    roomNumLabel.font = [UIFont systemFontOfSize:CustomFont(14)];
    roomNumLabel.textAlignment = NSTextAlignmentRight;
    roomNumLabel.text = [NSString stringWithFormat:@"房间号:%@",_userModel.room_id];
    [headerView addSubview:roomNumLabel];
    
    CGFloat hightSpace;
    if (iPhone6p) {
        hightSpace = 10;
    }else if (iPhone6){
        hightSpace = 7;
    }else{
        hightSpace = -2;
    }
    
    nickNameLabel = [[M80AttributedLabel alloc]initWithFrame:CGRectMake(0, roomNumLabel.bottom +hightSpace, SCREEN_WIDTH, 22)];
    nickNameLabel.backgroundColor = [UIColor clearColor];
    nickNameLabel.textColor = [UIColor whiteColor];
    nickNameLabel.font = [UIFont systemFontOfSize:CustomFont(15)];
    nickNameLabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:nickNameLabel];
    [nickNameLabel appendText:[NSString stringWithFormat:@"%@ ",_userModel.nick]];
    if (_userModel.gender.intValue) {
        [nickNameLabel appendView:[self getUserSexViewWithString:@"1"]];
    }else{
        [nickNameLabel appendView:[self getUserSexViewWithString:@"0"]];
    }
    [nickNameLabel appendText:@" "];
    [nickNameLabel appendView:[self getUserLevelViewWithLevelString:_userModel.level]];
    [nickNameLabel appendText:@" "];
    [nickNameLabel appendImage:[UIImage imageNamed:@"me_edit"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(nickNameLabel.left, nickNameLabel.top-5, nickNameLabel.width, nickNameLabel.height+6);
    [button addTarget:self action:@selector(editInfoButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:button];
    
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, nickNameLabel.bottom +hightSpace, 0.5, 22)];
    lineLabel.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:lineLabel];
    
    focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    focusButton.frame = CGRectMake(0, nickNameLabel.bottom +hightSpace, SCREEN_WIDTH/2-10, 22);
    focusButton.titleLabel.textColor = [UIColor whiteColor];
    focusButton.titleLabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    focusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [focusButton setTitle:@"关注 0" forState:UIControlStateNormal];
    [focusButton addTarget:self action:@selector(focusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:focusButton];
    
    fansButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fansButton.frame = CGRectMake(SCREEN_WIDTH/2+10, nickNameLabel.bottom +hightSpace, SCREEN_WIDTH/2-10, 22);
    fansButton.titleLabel.textColor = [UIColor whiteColor];
    fansButton.titleLabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    fansButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [fansButton setTitle:@"粉丝 0" forState:UIControlStateNormal];
    [fansButton addTarget:self action:@selector(fansButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:fansButton];
    
    weskitLabel = [M80AttributedLabel new];
    weskitLabel.frame = CGRectMake(0, fansButton.bottom+5, SCREEN_WIDTH, 25);
    weskitLabel.backgroundColor = [UIColor clearColor];
    weskitLabel.font = [UIFont systemFontOfSize:CustomFont(14)];
    weskitLabel.textColor = [UIColor whiteColor];
    weskitLabel.textAlignment = NSTextAlignmentRight;
    [weskitLabel appendImage:[UIImage imageNamed:@"weskit"]];
    [weskitLabel appendText:@"  "];
    weskitLabel.hidden = YES;
    [headerView addSubview:weskitLabel];
    
    CGFloat hightS;
    if (iPhone6p) {
        hightS = 0;
    }else if (iPhone6){
        hightS = 10;
    }else{
        hightS = 20;
    }
    if (_userModel.isVest.intValue) {
        weskitLabel.hidden = NO;
        if (_userModel.isVest.intValue == 1) {
            [weskitLabel appendText:@"初级球员"];
        }
        else if (_userModel.isVest.intValue == 2){
            [weskitLabel appendText:@"中级球员"];
        }
        else if (_userModel.isVest.intValue == 3){
            [weskitLabel appendText:@"高级球员"];
        }
        else if (_userModel.isVest.intValue == 4){
            [weskitLabel appendText:@"职业球员"];
        }
        else if (_userModel.isVest.intValue == 5){
            [weskitLabel appendText:@"高球大师"];
        }
        headerView.height = SCREEN_WIDTH*2/3 +hightS;
    }else{
        weskitLabel.hidden = YES;
    }
    
    return headerView;
}


#pragma mark  uiscrollviewdelegate
//滚动tableview 完毕之后
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //图片高度
    CGFloat imageHeight = SCREEN_WIDTH*2/3+20;
    //图片上下偏移量
    CGFloat imageOffsetY = scrollView.contentOffset.y;
    
//    NSLog(@"图片上下偏移量 imageOffsetY:%f ->",imageOffsetY);
    //上移
    if (imageOffsetY < 0) {
        CGFloat totalOffset = imageHeight + ABS(imageOffsetY);
        headerGroundImageView.frame = CGRectMake(0 , -0, SCREEN_WIDTH, totalOffset);
    }
    //下移
    if (imageOffsetY > 0) {
        CGFloat totalOffset = imageHeight - ABS(imageOffsetY);
        [headerGroundImageView setFrame:CGRectMake(0 , -0, SCREEN_WIDTH, totalOffset)];
    }
}


#pragma mark  buttonClick
- (void)searchButtonClick:(UIButton *)button
{
    SearchVC *searchVC = [[SearchVC alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (void)messageButtonClick
{
    MyFriendListVC *vc=[[MyFriendListVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)messageChange:(NSNotification *)notification{
     messageButton.badgeValue=(NSString *)notification.object;
}

- (void)focusButtonClick:(UIButton *)button
{
    self.tabBarController.tabBar.hidden=YES;
    AttentionVC *attentionVC = [[AttentionVC alloc]init];
    [self.navigationController pushViewController:attentionVC animated:YES];
}

- (void)fansButtonClick:(UIButton *)button
{
    self.tabBarController.tabBar.hidden=YES;
    FansVC *fansVC = [[FansVC alloc]init];
    [self.navigationController pushViewController:fansVC animated:YES];
}
- (void) editInfoButtonClick: (UIButton *) sender
{
    self.tabBarController.tabBar.hidden=YES;
    EditInfoVC *eivc = [[EditInfoVC alloc]init];
    [self.navigationController pushViewController:eivc animated:YES];
}

- (void)headerImageViewTapGeRAction:(UITapGestureRecognizer *)tapGeR
{
    HeaderImageEditVC *hieVC = [[HeaderImageEditVC alloc]init];
    [self presentViewController:hieVC animated:YES completion:nil];
}

#pragma mark RightFuncCellDelegate
- (void)didClickLeftIncomButtonClick
{
    if (![[KAPP_DELEGATE crash] intValue]) {
        return;
    }
    if (testVersionBool) {
        return;
    }
    self.tabBarController.tabBar.hidden=YES;
    WXwithdrawalVC *wxVC = [[WXwithdrawalVC alloc]init];
    [self.navigationController pushViewController:wxVC animated:YES];
}

- (void)didClickRightAccountButtonClick
{
    if (![CommonUtils isJailBreak]) {
        self.tabBarController.tabBar.hidden=YES;
        RechargeVC *rechargeVC = [[RechargeVC alloc]init];
        [self.navigationController pushViewController:rechargeVC animated:YES];
    }
}

- (void)didClickRightFuncMoreCellLeftLiveButtonClick
{
    self.tabBarController.tabBar.hidden=YES;
    LiveVideoVC *lvvc = [[LiveVideoVC alloc]init];
    [self.navigationController pushViewController:lvvc animated:YES];
}
- (void)didClickRightFuncMoreCellRightLevelButtonClick
{
    self.tabBarController.tabBar.hidden=YES;
    LevelVC *levelVC = [[LevelVC alloc]init];
    [self.navigationController pushViewController:levelVC animated:YES];
}
#pragma mark 获取用男女视图
- (UIView *)getUserSexViewWithString:(NSString *)sex
{
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 14, 14)];
    if (sex.intValue) {
        view.image = [UIImage imageNamed:@"me_sex1"];
    }else{
        view.image = [UIImage imageNamed:@"me_sex2"];
    }
    view.clipsToBounds = YES;
    view.contentMode = UIViewContentModeScaleAspectFill;
    return view;
}
#pragma mark 获取用等级视图
- (UIView *)getUserLevelViewWithLevelString:(NSString *)level
{
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 30, 14)];
    if (level.intValue == 0) {
        return nil;
    }
    view.image = [UIImage imageNamed:[NSString stringWithFormat:@"level_%@",level]];
    return view;
}
//刷新马甲等级视图
- (void)refreshVestViewWithvestLv:(NSString *)vestLv
{
    //马甲
    CGFloat hightS;
    if (iPhone6p) {
        hightS = 0;
    }else if (iPhone6){
        hightS = 10;
    }else{
        hightS = 20;
    }
    if (vestLv.intValue) {
        weskitLabel.hidden = NO;
        UIView *headerView = self.tableView.tableHeaderView;
        headerView.height = SCREEN_WIDTH*2/3 +hightS;
        [_tableView beginUpdates];
        [_tableView setTableHeaderView:headerView];// 关键是这句话
        [_tableView endUpdates];
        weskitLabel.attributedText = nil;
        [weskitLabel appendImage:[UIImage imageNamed:@"weskit"]];
        [weskitLabel appendText:@"  "];
        if (vestLv.intValue == 1) {
            [weskitLabel appendText:@"初级球员"];
        }
        else if (vestLv.intValue == 2){
            [weskitLabel appendText:@"中级球员"];
        }
        else if (vestLv.intValue == 3){
            [weskitLabel appendText:@"高级球员"];
        }
        else if (vestLv.intValue == 4){
            [weskitLabel appendText:@"职业球员"];
        }
        else if (vestLv.intValue == 5){
            [weskitLabel appendText:@"高球大师"];
        }
        
    }else{
        weskitLabel.hidden = YES;
        UIView *headerView = self.tableView.tableHeaderView;
        headerView.height = SCREEN_WIDTH*2/3;
        [_tableView beginUpdates];
        [_tableView setTableHeaderView:headerView];// 关键是这句话
        [_tableView endUpdates];
    }
}

#pragma mark requests
- (void)sendVestLvRequest
{
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:CurrentUserToken forKey:@"token"];
    [AFRequestManager SafeGET:URI_VestLv parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([((NSDictionary*)responseObject)[@"status"] intValue] == 200) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:((NSDictionary*)responseObject)[@"data"]];
            [self refreshVestViewWithvestLv:[dict objectForKey:@"isVest"]];
            _userModel.isVest = [dict objectForKey:@"isVest"];
            [AccountHelper saveUserInfo:_userModel];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


- (void)sendUserInfoRequest
{
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:User_Token forKey:@"token"];
    [AFRequestManager SafeGET:URI_GetInfo parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([((NSDictionary*)responseObject)[@"status"] intValue] == 200) {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:((NSDictionary*)responseObject)[@"data"]];
            [dict setObject:User_Token forKey:@"token"];
            [dict setObject:CurrentUserToken forKey:@"currentToken"];
            _userModel = [[UserModel alloc]initWithDictionary:dict error:nil];
            [AccountHelper saveUserInfo:_userModel];
            [self refeshUI];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (void)setConsLabelwithNumStr:(NSString*)numStr
{
    consLabel.attributedText = nil;
    [consLabel appendImage:[UIImage imageNamed:@"diam"]];
    [consLabel appendText:[NSString stringWithFormat:@" 送出 %@",numStr]];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}

//录像个数
- (void)sendLiveVideoRequest
{
    UserModel *userModel = [AccountHelper userInfo];
    NSDictionary *params=@{@"aesId":userModel.pid,@"size":@"10000",@"page":@"1"};
    
    [AFRequestManager SafePOST:URI_GetVideo parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
        [self hideActivityIndicatorView];
        if ([result[@"status"] intValue] == 200) {
            NSArray *list = [result objectForKey:@"data"][@"list"];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            RightFuncMoreCell *cell = (RightFuncMoreCell*)[_tableView cellForRowAtIndexPath:indexPath];
            [cell setLiveVideoNumWithNumStr:[NSString stringWithFormat:@"%lu",list.count]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
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
