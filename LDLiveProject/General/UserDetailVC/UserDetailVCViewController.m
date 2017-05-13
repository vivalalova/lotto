//
//  UserDetailVCViewController.m
//  LDLiveProject
//
//  Created by MAC on 16/9/5.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "UserDetailVCViewController.h"
#import "LiveRoomVC.h"
#import "ChatPrivateVC.h"
#import "MessListModel.h"
#import "LiveVideoModel.h"
#import "LiveVideoCell.h"
#import "LiveRecordVC.h"
#import "LiveRoomVC.h"
#import "AttentionVC.h"
#import "FansVC.h"
#import "CreditModel.h"
#import "CreditListVC.h"

@interface UserDetailVCViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,UIAlertViewDelegate>
{
    UIImageView *headerGroundImageView;
    M80AttributedLabel *consLabel;
    WebImageView *headerImageView;
    UIImageView *vip_icon;
    M80AttributedLabel *nickNameLabel;
    UIButton *focusButton;
    UIButton *fansButton;
    //认证信息
    M80AttributedLabel *certificateLabel;
#pragma mark 是否在直播
    UIButton *isLiveButton;
    //正在直播是否重复点击
    NSInteger isLiveInteger;
    //头像图片根地址
    NSString *imageRootUrlStr;
    UIButton *rightButton;
    UIButton *leftButton;
    UIButton *newButton;
    UIButton *hotButton;
    //type
    NSString *typeStr;
}
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *leftDataArray;
@property (nonatomic, strong)NSMutableArray *rightDataArray;
@property (nonatomic, strong)NSMutableArray *threeArray;
//主页label
@property (nonatomic, strong)UILabel *leftLabel;
//直播label
@property (nonatomic, strong)UILabel *rightLabel;
@property (nonatomic, assign)BOOL TypeBOOL;
@end

#define LaHeiAlertTag 9999
#define LHHouSiXin    8888


@implementation UserDetailVCViewController

- (NSMutableArray *)leftDataArray
{
    if (!_leftDataArray) {
        _leftDataArray = [NSMutableArray array];
        if (![NSString isBlankString:_personInfoModel.birth]) {
            [_leftDataArray addObject:_personInfoModel.birth];
        }else{
            [_leftDataArray addObject:@"保密"];
        }
        if (![NSString isBlankString:_personInfoModel.mood]) {
            [_leftDataArray addObject:_personInfoModel.mood];
        }else{
            [_leftDataArray addObject:@"保密"];
        }
        if (![NSString isBlankString:_personInfoModel.hometown]) {
            [_leftDataArray addObject:_personInfoModel.hometown];
        }else{
            [_leftDataArray addObject:@"火星"];
        }
        if (![NSString isBlankString:_personInfoModel.profession]) {
            [_leftDataArray addObject:_personInfoModel.profession];
        }else{
            [_leftDataArray addObject:@"主播"];
        }
        if (![NSString isBlankString:_personInfoModel.room_id]) {
            [_leftDataArray addObject:_personInfoModel.room_id];
        }
        if (![NSString isBlankString:_personInfoModel.emotion]) {
            [_leftDataArray addObject:_personInfoModel.emotion];
        }
        
    }
    return _leftDataArray;
}

- (NSMutableArray *)rightDataArray
{
    if (!_rightDataArray) {
        _rightDataArray = [NSMutableArray array];
    }
    return _rightDataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    isLiveInteger = 0;
    self.TypeBOOL = YES;
    [self UIInit];
    typeStr = @"1";
    [self initBottomView];
    [self sendLiveVideoRequest];
    [self sendCreditListOfthree];
    // Do any additional setup after loading the view from its nib.
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(void)UIInit
{
    self.view.backgroundColor = [UIColor colorWithHexString:@"0xf4f4f4"];
    
    headerGroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -20, _screenWidth, _screenWidth*2/3+40)];
    headerGroundImageView.image = [UIImage imageNamed:@"me_ground"];
    [self.view addSubview:headerGroundImageView];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, _screenWidth, _screenHeight-45) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [self getTableViewHeaderView];
}

- (void)initBottomView
{
    _b_lineView1.height = 0.5;
    _b_lineView2.width = 0.5;
    _b_lineView3.width = 0.5;
    
    _attViewLabel.font = [UIFont systemFontOfSize:15];
    _attViewLabel.textAlignment = NSTextAlignmentRight;
    _attViewLabel.textColor = [UIColor darkGrayColor];
    _attViewLabel.attributedText = nil;
    if (_personInfoModel.isAttention.intValue == 1) {
        [_attViewLabel appendImage:[UIImage imageNamed:@"att"]];
        [_attViewLabel appendText:@" 已关注"];
    }else{
        [_attViewLabel appendImage:[UIImage imageNamed:@"unAtt"]];
        [_attViewLabel appendText:@" 关注"];
    }
    
    _inboxViewLabel.font = [UIFont systemFontOfSize:15];
    _inboxViewLabel.textAlignment = NSTextAlignmentRight;
    _inboxViewLabel.textColor = [UIColor darkGrayColor];
    _inboxViewLabel.attributedText = nil;
    [_inboxViewLabel appendImage:[UIImage imageNamed:@"Inbox"]];
    [_inboxViewLabel appendText:@" 私信"];
    
    _blackViewLabel.font = [UIFont systemFontOfSize:15];
    _blackViewLabel.textAlignment = NSTextAlignmentRight;
    _blackViewLabel.textColor = [UIColor darkGrayColor];
    _blackViewLabel.attributedText = nil;
    if (_personInfoModel.isAttention.intValue == 2) {
        [_blackViewLabel appendImage:[UIImage imageNamed:@"setUnBlack"]];
        [_blackViewLabel appendText:@" 解除拉黑"];
    }else{
        [_blackViewLabel appendImage:[UIImage imageNamed:@"setblack"]];
        [_blackViewLabel appendText:@" 拉黑"];
    }
    
}


#pragma custom cell
- (UIView *)getTableViewHeaderView
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*2/3-20 + 51)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UIButton *gobackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    gobackButton.frame = CGRectMake(0, 20, NAV_BAR_HEIGHT, NAV_BAR_HEIGHT);
    [gobackButton setImage:[UIImage imageNamed:@"goback"] forState:UIControlStateNormal];
    [gobackButton addTarget: self action:@selector(gobackButtonButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:gobackButton];
    
    isLiveButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - NAV_BAR_HEIGHT-30, 20, NAV_BAR_HEIGHT+25, NAV_BAR_HEIGHT)];
    isLiveButton.userInteractionEnabled = YES;
    isLiveButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [isLiveButton setTitle:@"正在直播" forState:UIControlStateNormal];
    [isLiveButton addTarget:self action:@selector(isLiveButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:isLiveButton];
    if (_personInfoModel.status.intValue) {
        isLiveButton.hidden = NO;
    }else{
        isLiveButton.hidden = YES;
    }
    
    consLabel = [[M80AttributedLabel alloc]initWithFrame:CGRectMake(NAV_BAR_HEIGHT, 35, SCREEN_WIDTH-NAV_BAR_HEIGHT*2, 32)];
    consLabel.backgroundColor = [UIColor clearColor];
    consLabel.textColor = [UIColor whiteColor];
    consLabel.font = [UIFont systemFontOfSize:CustomFont(14)];
    consLabel.textAlignment = NSTextAlignmentRight;
    [consLabel appendImage:[UIImage imageNamed:@"diam"]];
    [consLabel appendText:[NSString stringWithFormat:@" 送出 %@",_personInfoModel.send_gold]];
    [headerView addSubview:consLabel];
    
    UIView *imageBGview = [[UIView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH - SCREEN_WIDTH/5)/2, 64, SCREEN_WIDTH/5, SCREEN_WIDTH/5)];
    imageBGview.backgroundColor = [UIColor clearColor];
    [headerView addSubview:imageBGview];
    
    headerImageView = [[WebImageView alloc]initWithFrame:CGRectMake(2, 2, imageBGview.width-4, imageBGview.width-4)];
    headerImageView.layer.cornerRadius = headerImageView.width/2;
    headerImageView.layer.masksToBounds = YES;
    headerImageView.userInteractionEnabled = YES;
    [headerImageView setImageWithUrlString:_personInfoModel.portrait placeholderImage:[UIImage imageByApplyingAlpha:1 color:[UIColor lightGrayColor]]];
    [imageBGview addSubview:headerImageView];
    
    if (self.personInfoModel.super_vip.intValue) {
        vip_icon = [UIImageView new];
        vip_icon.size = CGSizeMake(15, 15);
        vip_icon.origin = CGPointMake(headerImageView.origin.x +headerImageView.width-15, headerImageView.origin.y +headerImageView.height-15);
        vip_icon.image = [UIImage imageNamed:@"vip_icon"];
        vip_icon.hidden = YES;
        [imageBGview addSubview:vip_icon];
    }
    
    CGFloat hightSpace;
    if (iPhone6p) {
        hightSpace = 10;
    }else if (iPhone6){
        hightSpace = 7;
    }else{
        hightSpace = -2;
    }
    
    nickNameLabel = [[M80AttributedLabel alloc]initWithFrame:CGRectMake(0, imageBGview.bottom +hightSpace, SCREEN_WIDTH, 22)];
    nickNameLabel.backgroundColor = [UIColor clearColor];
    nickNameLabel.textColor = [UIColor whiteColor];
    nickNameLabel.font = [UIFont systemFontOfSize:CustomFont(15)];
    nickNameLabel.textAlignment = NSTextAlignmentRight;
    [headerView addSubview:nickNameLabel];
    [nickNameLabel appendText:[NSString stringWithFormat:@"%@ ",_personInfoModel.nick]];
    if (_personInfoModel.gender.intValue) {
        [nickNameLabel appendView:[self getUserSexViewWithString:@"1"]];
    }else{
        [nickNameLabel appendView:[self getUserSexViewWithString:@"0"]];
    }
    [nickNameLabel appendText:@" "];
    [nickNameLabel appendView:[self getUserLevelViewWithLevelString:_personInfoModel.level]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(nickNameLabel.left, nickNameLabel.top-5, nickNameLabel.width, nickNameLabel.height+6);
    [headerView addSubview:button];
    
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, nickNameLabel.bottom +hightSpace, 0.5, 22)];
    lineLabel.backgroundColor = [UIColor whiteColor];
    [headerView addSubview:lineLabel];
    
    focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    focusButton.frame = CGRectMake(0, nickNameLabel.bottom +hightSpace, SCREEN_WIDTH/2-10, 22);
    focusButton.titleLabel.textColor = [UIColor whiteColor];
    focusButton.titleLabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    focusButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [focusButton setTitle:[NSString stringWithFormat:@"关注 %@",_personInfoModel.attention] forState:UIControlStateNormal];
    [focusButton addTarget:self action:@selector(focusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:focusButton];
    
    fansButton = [UIButton buttonWithType:UIButtonTypeCustom];
    fansButton.frame = CGRectMake(SCREEN_WIDTH/2+10, nickNameLabel.bottom +hightSpace, SCREEN_WIDTH/2-10, 22);
    fansButton.titleLabel.textColor = [UIColor whiteColor];
    fansButton.titleLabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    fansButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [fansButton setTitle:[NSString stringWithFormat:@"粉丝 %@",_personInfoModel.fans] forState:UIControlStateNormal];

    [fansButton addTarget:self action:@selector(fansButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:fansButton];
    
    certificateLabel = [M80AttributedLabel new];
    certificateLabel.frame = CGRectMake(0, fansButton.bottom+5, SCREEN_WIDTH, 25);
    certificateLabel.backgroundColor = [UIColor clearColor];
    certificateLabel.font = [UIFont systemFontOfSize:CustomFont(14)];
    certificateLabel.textColor = [UIColor whiteColor];
    certificateLabel.textAlignment = NSTextAlignmentRight;
    [certificateLabel appendImage:[UIImage imageNamed:@"weskit"]];
    [certificateLabel appendText:@"  "];
    certificateLabel.hidden = YES;
    [headerView addSubview:certificateLabel];
    
    CGFloat hightS;
    if (iPhone6p) {
        hightS = 0;
    }else if (iPhone6){
        hightS = 10;
    }else{
        hightS = 20;
    }
    //如果已经认证高度增加
    //设置certificateLabel
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, headerView.height-51, SCREEN_WIDTH, 51)];
    view.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    _leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2-1.5, 48)];
    _leftLabel.backgroundColor = [UIColor clearColor];
    _leftLabel.font = [UIFont systemFontOfSize:18];
    _leftLabel.textAlignment = NSTextAlignmentCenter;
    _leftLabel.textColor = [UIColor colorWithHexString:GiftUsualColor];
    _leftLabel.text = @"主页";
    [view addSubview:_leftLabel];
    
    _rightLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2+1.5, 0, SCREEN_WIDTH/2-1.5, 48)];
    _rightLabel.backgroundColor = [UIColor clearColor];
    _rightLabel.font = [UIFont systemFontOfSize:18];
    _rightLabel.textAlignment = NSTextAlignmentCenter;
    _rightLabel.textColor = [UIColor darkGrayColor];
    _rightLabel.text = @"直播";
    [view addSubview:_rightLabel];
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 0, 3, 48)];
    label2.backgroundColor = UIColorFromRGB(240, 240, 240);
    [view addSubview:label2];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, 3)];
    label1.backgroundColor = UIColorFromRGB(240, 240, 240);
    [view addSubview:label1];
    
    leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, SCREEN_WIDTH/2, 48);
    [leftButton addTarget:self action:@selector(leftButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:leftButton];
    
    rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(SCREEN_WIDTH/2, 0, SCREEN_WIDTH/2, 48);
    [rightButton addTarget:self action:@selector(rightButtonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:rightButton];
    if (self.TypeBOOL) {
        _leftLabel.textColor = [UIColor colorWithHexString:GiftUsualColor];
        _rightLabel.textColor = [UIColor darkGrayColor];
    }else{
        _leftLabel.textColor = [UIColor darkGrayColor];
        _rightLabel.textColor = [UIColor colorWithHexString:GiftUsualColor];
    }
    [headerView addSubview:view];
    
    return headerView;
}

- (void)focusButtonClick:(UIButton *)button
{
    AttentionVC *attentionVC = [[AttentionVC alloc]init];
    attentionVC.titleStr = self.personInfoModel.nick;
    attentionVC.aesId = self.personInfoModel.pid;
    [self.navigationController pushViewController:attentionVC animated:YES];
}

- (void)fansButtonClick:(UIButton *)button
{
    FansVC *fansVC = [[FansVC alloc]init];
    fansVC.titleStr = self.personInfoModel.nick;
    fansVC.aesId = self.personInfoModel.pid;
    [self.navigationController pushViewController:fansVC animated:YES];
}


- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.TypeBOOL) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 51)];
        view.backgroundColor = [UIColor whiteColor];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 48, SCREEN_WIDTH, 3)];
        lineV.backgroundColor = UIColorFromRGB(240, 240, 240);
        [view addSubview:lineV];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, (SCREEN_WIDTH-20)/2, 48)];
        label.textColor = [UIColor darkGrayColor];
        label.text = @"球票贡献榜";
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        if (self.threeArray.count>0) {
            for (int i=0; i<self.threeArray.count; i++) {
                CreditModel *model = [self.threeArray objectAtIndex:i];
                WebImageView *webv = [WebImageView new];
                webv.size = CGSizeMake(36, 36);
                webv.left = SCREEN_WIDTH-20 -(3-i)*36;
                webv.top = 6;
                webv.layer.cornerRadius = 18;
                webv.layer.masksToBounds = YES;
                [webv setImageWithUrlString:[NSString stringWithFormat:@"%@%@",imageRootUrlStr,model.img]];
                [view addSubview:webv];
            }
            UIButton *button = [UIButton new];
            button.frame = view.frame;
            [button setBackgroundColor:[UIColor clearColor]];
            [button addTarget:self action:@selector(creditsListButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:button];
        }
        return view;
    }else{
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 43)];
        view.backgroundColor = [UIColor whiteColor];
        UIView *lineV = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, 3)];
        lineV.backgroundColor = UIColorFromRGB(240, 240, 240);
        [view addSubview:lineV];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, (SCREEN_WIDTH-20)/2, 40)];
        label.textColor = [UIColor darkGrayColor];
        label.text = @"精彩视频回放";
        label.font = [UIFont systemFontOfSize:15];
        [view addSubview:label];
        
        newButton = [UIButton buttonWithType:UIButtonTypeCustom];
        newButton.frame = CGRectMake(SCREEN_WIDTH-110, 0, 40, 40);
        [newButton setTitle:@"最新" forState:UIControlStateNormal];
        newButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [newButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [newButton setTitleColor:[UIColor colorWithHexString:GiftUsualColor] forState:UIControlStateSelected];
        [newButton addTarget:self action:@selector(newbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        newButton.selected = YES;
        [view addSubview:newButton];
        
        hotButton = [UIButton buttonWithType:UIButtonTypeCustom];
        hotButton.frame = CGRectMake(SCREEN_WIDTH-50, 0, 40, 40);
        [hotButton setTitle:@"最热" forState:UIControlStateNormal];
        hotButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [hotButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [hotButton setTitleColor:[UIColor colorWithHexString:GiftUsualColor] forState:UIControlStateSelected];
        [hotButton addTarget:self action:@selector(hotbuttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:hotButton];
        
        return view;
    }
}

- (void)creditsListButtonClick:(UIButton *)button
{
    CreditListVC *cvc = [[CreditListVC alloc]init];
    cvc.CreditListVCDelegateResponseBool = NO;
    cvc.aesIdStr = self.personInfoModel.pid;
    cvc.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.navigationController pushViewController:cvc animated:YES];
}

- (void)newbuttonClick:(UIButton *)button
{
    typeStr = @"1";
    newButton.selected = YES;
    hotButton.selected = NO;
    [self sendLiveVideoRequest];

}
- (void)hotbuttonClick:(UIButton *)button
{
    typeStr = @"2";
    newButton.selected = NO;
    hotButton.selected = YES;
    [self sendLiveVideoRequest];
}

- (void)leftButtonClickAction:(UIButton *)button
{
    self.TypeBOOL = YES;
    if (self.TypeBOOL) {
        _leftLabel.textColor = [UIColor colorWithHexString:GiftUsualColor];
        _rightLabel.textColor = [UIColor darkGrayColor];
    }else{
        _leftLabel.textColor = [UIColor darkGrayColor];
        _rightLabel.textColor = [UIColor colorWithHexString:GiftUsualColor];
    }
    [self.tableView reloadData];
}

- (void)rightButtonClickAction:(UIButton *)button
{
    self.TypeBOOL = NO;
    if (self.TypeBOOL) {
        _leftLabel.textColor = [UIColor colorWithHexString:GiftUsualColor];
        _rightLabel.textColor = [UIColor darkGrayColor];
    }else{
        _leftLabel.textColor = [UIColor darkGrayColor];
        _rightLabel.textColor = [UIColor colorWithHexString:GiftUsualColor];
    }
    [self.tableView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (self.TypeBOOL) {
        return 51;
    }else{
        return 43;
    }
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
    if (self.TypeBOOL) {
        return self.leftDataArray.count;
    }else{
        return self.rightDataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.TypeBOOL) {
        return 40;
    }else{
        return 60;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.TypeBOOL) {
        
    if (indexPath.row == 0) {
       UITableViewCell *cell = [self SetupUsualMoreTableViewCellWithString:@"生日" modelStr:[self.leftDataArray objectAtIndex:indexPath.row]];
        return cell;
    }
    if (indexPath.row == 1) {
        UITableViewCell *cell = [self SetupUsualMoreTableViewCellWithString:@"情感状态" modelStr:[self.leftDataArray objectAtIndex:indexPath.row]];
        return cell;
    }
    if (indexPath.row == 2) {
        UITableViewCell *cell = [self SetupUsualMoreTableViewCellWithString:@"家乡" modelStr:[self.leftDataArray objectAtIndex:indexPath.row]];
        return cell;
    }
    if (indexPath.row == 3) {
        UITableViewCell *cell = [self SetupUsualMoreTableViewCellWithString:@"职业" modelStr:[self.leftDataArray objectAtIndex:indexPath.row]];
        return cell;
    }
    if (indexPath.row == 4) {
        UITableViewCell *cell = [self SetupUsualMoreTableViewCellWithString:@"房间号" modelStr:[self.leftDataArray objectAtIndex:indexPath.row]];
        return cell;
    }
    if (indexPath.row == 5) {
        UITableViewCell *cell = [self SetupUsualMoreTableViewCellWithString:@"个性签名" modelStr:[self.leftDataArray objectAtIndex:indexPath.row]];
        return cell;
    }
        
    }else{
        static NSString *ident = @"LiveVideoCell";
        LiveVideoCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
        if (!cell) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:ident owner:self options:nil];
            cell = (LiveVideoCell*)objects[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.lineLabel2.hidden = YES;
        if (indexPath.row == 0) {
            cell.lineLabel1.hidden = YES;
        }else{
            cell.lineLabel1.hidden = NO;
        }
        [cell setUIwithLiveVideoModel:[self.rightDataArray objectAtIndex:indexPath.row]];
        return cell;
    }
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
}

-(UITableViewCell*)SetupUsualMoreTableViewCellWithString:(NSString*)str modelStr:(NSString*)modelStr
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = str;
    cell.textLabel.textColor = [UIColor lightGrayColor];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(110, 0, SELFVIEW_WIDTH-120, 40)];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:14];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor darkGrayColor];
    label.text = modelStr;
    [cell addSubview:label];
    
    return cell;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.TypeBOOL) {
        LiveVideoModel *lvModel = [self.rightDataArray objectAtIndex:indexPath.row];
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
}



- (void)isLiveButtonClick
{
    if (isLiveInteger == 0 ) {
        [self sendURI_IndexInfosRequestWithSid:_personInfoModel.u_id];
        isLiveInteger++;
    }
}
- (void)sendURI_IndexInfosRequestWithSid:(NSString *)sid
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:sid forKey:@"ids"];
    [AFRequestManager SafeGET:URI_IndexInfos parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        isLiveInteger = 0;
        if ([result[@"status"] intValue] == 200) {
            NSArray *list = [result objectForKey:@"data"];
            HostDetailInfoModel *hostDetailInfoModel= [[HostDetailInfoModel alloc] initWithDictionary:list.firstObject error:nil];
            LiveRoomVC *lrVC = [[LiveRoomVC alloc]init];
            lrVC.hostDetailInfoModel = hostDetailInfoModel;
            if (!lrVC.hostDetailInfoModel.stream_addr) {
                return;
            }else{
                NSMutableArray *array = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
                for (UIViewController *vc in array) {
                    if ([vc isKindOfClass:[LiveRoomVC class]]) {
                        [(LiveRoomVC*)vc liveRoomVCClosePlayerUrl];
                        [array removeObject:vc];
                        break;
                    }
                }
                self.navigationController.viewControllers = array;
            }
            [self.navigationController pushViewController:lrVC animated:YES];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        isLiveInteger = 0;
    }];
}

- (void)sendCreditListOfthree
{
    NSDictionary *params=@{@"aesId":self.personInfoModel.pid,@"size":@"3",@"page":@"1"};
    [AFRequestManager SafePOST:URI_AnchorContribution parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
        [self hideActivityIndicatorView];
        if ([result[@"status"] intValue] == 200) {
                imageRootUrlStr = result[@"data"][@"url"];
                NSArray *list = [result objectForKey:@"data"][@"list"];
                if ([list isKindOfClass:[NSArray class]]) {
                    self.threeArray = [NSMutableArray arrayWithCapacity:list.count];
                    for (NSDictionary *dic in list) {
                        CreditModel *creditModel = [[CreditModel alloc] initWithDictionary:dic error:nil];
                        [self.threeArray addObject:creditModel];
                    }
                }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
            [self showMPNotificationViewWithErrorMessage:@"请求贡献榜数据失败"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

- (void)gobackButtonButtonClick:(UIButton*)button
{
    [super actionClickNavigationBarLeftButton];
}

#pragma mark bottonViewActions
//关注
- (IBAction)attButtonClickAction:(id)sender {
    if (_personInfoModel.isAttention.intValue == 1) {
        //解除关注
        [self sendCancelAttentionRequestWithRoomUid:_personInfoModel.u_id];
    }else{
        //添加关注
        [self sendAddAttentionRequestWithRoomUid:_personInfoModel.u_id];
    }
}
//私信
- (IBAction)inboxButtonClickAction:(id)sender {
    if (_personInfoModel.isAttention.intValue == 2) {
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发送私信,将自动解除拉黑" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"发送", nil];
        alertV.tag = LHHouSiXin;
        [alertV show];
    }else{
        ChatPrivateVC *cvc = [[ChatPrivateVC alloc]init];
        cvc.SmallTypeBool = NO;
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        [dict setObject:_personInfoModel.u_id forKey:@"uid"];
        [dict setObject:_personInfoModel.nick forKey:@"user_name"];
        [dict setObject:_personInfoModel.headportrait forKey:@"user_head_img"];
        MessListModel *model = [[MessListModel alloc]initWithDictionary:dict error:nil];
        cvc.chatListModel = model;
        [self.navigationController pushViewController:cvc animated:YES];
    }
}
//黑名单
- (IBAction)blackButtonClickAction:(id)sender {
    if (_personInfoModel.isAttention.intValue == 2) {
        //解除拉黑
        [self sendURI_AttDelBlackRequestWithRoomUid:_personInfoModel.u_id showChatPrivateVCBool:NO];
    }else{
        //添加拉黑 拉黑后改变关注状态为未关注
        UIAlertView *alertV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"拉黑后你们将解除关注关系,ta不能再关注你或私信你" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拉黑", nil];
        alertV.tag = LaHeiAlertTag;
        [alertV show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == LaHeiAlertTag) {
        if (buttonIndex == 1) {
            [self sendURI_AttAddBlackRequestWithSid:_personInfoModel.u_id];
        }
    }else if (alertView.tag == LHHouSiXin){
        [self sendURI_AttDelBlackRequestWithRoomUid:_personInfoModel.u_id showChatPrivateVCBool:YES];
    }
}

#pragma mark  添加关注取消关注 关注相关----------------------------------------
//添加关注
- (void)sendAddAttentionRequestWithRoomUid:(NSString *)room_uid
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [params setObject:room_uid forKey:@"room_uid"];
    [AFRequestManager SafeGET:URI_AddAttention parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        NSLog(@"%@",result);
        _personInfoModel.isAttention = @"1";
        _attViewLabel.attributedText = nil;
        if (_personInfoModel.isAttention.intValue == 1) {
            [_attViewLabel appendImage:[UIImage imageNamed:@"att"]];
            [_attViewLabel appendText:@" 已关注"];
        }else{
            [_attViewLabel appendImage:[UIImage imageNamed:@"unAtt"]];
            [_attViewLabel appendText:@" 关注"];
        }
        _blackViewLabel.attributedText = nil;
        if (_personInfoModel.isAttention.intValue == 2) {
            [_blackViewLabel appendImage:[UIImage imageNamed:@"setUnBlack"]];
            [_blackViewLabel appendText:@" 解除拉黑"];
        }else{
            [_blackViewLabel appendImage:[UIImage imageNamed:@"setblack"]];
            [_blackViewLabel appendText:@" 拉黑"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

//取消关注
- (void)sendCancelAttentionRequestWithRoomUid:(NSString *)room_uid
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [params setObject:room_uid forKey:@"room_uid"];
    [AFRequestManager SafeGET:URI_CancelAttention parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        NSLog(@"%@",result);
        if ([result[@"status"] intValue] == 200) {
            _personInfoModel.isAttention = @"0";
            _attViewLabel.attributedText = nil;
            if (_personInfoModel.isAttention.intValue == 0) {
                [_attViewLabel appendImage:[UIImage imageNamed:@"unAtt"]];
                [_attViewLabel appendText:@" 关注"];
            }else{
                [_attViewLabel appendImage:[UIImage imageNamed:@"att"]];
                [_attViewLabel appendText:@" 已关注"];
            }
            _blackViewLabel.attributedText = nil;
            if (_personInfoModel.isAttention.intValue == 2) {
                [_blackViewLabel appendImage:[UIImage imageNamed:@"setUnBlack"]];
                [_blackViewLabel appendText:@" 解除拉黑"];
            }else{
                [_blackViewLabel appendImage:[UIImage imageNamed:@"setblack"]];
                [_blackViewLabel appendText:@" 拉黑"];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
#pragma mark   拉黑相关----------------------------------------
//添加拉黑
- (void)sendURI_AttAddBlackRequestWithSid:(NSString *)sid
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [params setObject:sid forKey:@"block"];
    [AFRequestManager SafeGET:URI_AttAddBlack parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        NSLog(@"%@",result);
        _personInfoModel.isAttention = @"2";
        _attViewLabel.attributedText = nil;
        if (_personInfoModel.isAttention.intValue == 1) {
            [_attViewLabel appendImage:[UIImage imageNamed:@"att"]];
            [_attViewLabel appendText:@" 已关注"];
        }else{
            [_attViewLabel appendImage:[UIImage imageNamed:@"unAtt"]];
            [_attViewLabel appendText:@" 关注"];
        }
        _blackViewLabel.attributedText = nil;
        if (_personInfoModel.isAttention.intValue == 2) {
            [_blackViewLabel appendImage:[UIImage imageNamed:@"setUnBlack"]];
            [_blackViewLabel appendText:@" 解除拉黑"];
        }else{
            [_blackViewLabel appendImage:[UIImage imageNamed:@"setblack"]];
            [_blackViewLabel appendText:@" 拉黑"];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

//取消拉黑
- (void)sendURI_AttDelBlackRequestWithRoomUid:(NSString *)sid showChatPrivateVCBool:(BOOL)showChatPrivateVCBool
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [params setObject:sid forKey:@"block"];
    [AFRequestManager SafeGET:URI_AttDelBlack parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        NSLog(@"%@",result);
        if ([result[@"status"] intValue] == 200) {
            _personInfoModel.isAttention = @"0";
            _attViewLabel.attributedText = nil;
            if (_personInfoModel.isAttention.intValue == 0) {
                [_attViewLabel appendImage:[UIImage imageNamed:@"unAtt"]];
                [_attViewLabel appendText:@" 关注"];
            }
            _blackViewLabel.attributedText = nil;
            if (_personInfoModel.isAttention.intValue == 2) {
                [_blackViewLabel appendImage:[UIImage imageNamed:@"setUnBlack"]];
                [_blackViewLabel appendText:@" 解除拉黑"];
            }else{
                [_blackViewLabel appendImage:[UIImage imageNamed:@"setblack"]];
                [_blackViewLabel appendText:@" 拉黑"];
            }
            if (showChatPrivateVCBool) {
                ChatPrivateVC *cvc = [[ChatPrivateVC alloc]init];
                cvc.SmallTypeBool = NO;
                NSMutableDictionary *dict = [NSMutableDictionary dictionary];
                [dict setObject:_personInfoModel.u_id forKey:@"uid"];
                [dict setObject:_personInfoModel.nick forKey:@"user_name"];
                [dict setObject:_personInfoModel.headportrait forKey:@"user_head_img"];
                MessListModel *model = [[MessListModel alloc]initWithDictionary:dict error:nil];
                cvc.chatListModel = model;
                [self.navigationController pushViewController:cvc animated:YES];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
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


- (void)sendLiveVideoRequest
{
    [self showActivityIndicatorView];
    NSDictionary *params=@{@"aesId":self.personInfoModel.pid,@"size":@"20",@"page":[NSString stringWithFormat:@"%d",1],@"order":typeStr};
    
    [AFRequestManager SafePOST:URI_GetVideo parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
        [self hideActivityIndicatorView];
        if ([result[@"status"] intValue] == 200) {
            self.tableView.hidden = NO;
            [self.rightDataArray removeAllObjects];
            NSArray *list = [result objectForKey:@"data"][@"list"];
            if ([list isKindOfClass:[NSArray class]]) {
                self.rightDataArray = [NSMutableArray arrayWithCapacity:list.count];
                for (NSDictionary *dic in list) {
                    LiveVideoModel *lvModel = [[LiveVideoModel alloc] initWithDictionary:dic error:nil];
                    [self.rightDataArray addObject:lvModel];
                }
            }
        }else{
            [self showMPNotificationViewWithErrorMessage:@"请求数据失败"];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self hideActivityIndicatorView];
        [self showMPNotificationViewWithErrorMessage:@"网络请求失败"];
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
