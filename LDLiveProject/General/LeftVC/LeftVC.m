//
//  LeftVC.m
//  LDLiveProject
//
//  Created by MAC on 16/5/30.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "LeftVC.h"
#import "LiveRoomVC.h"
#import "SearchVC.h"
#import "BadgeButton.h"
#import "MyFriendListVC.h"

#import "HotTableViewCell.h"
#import "MoreTableViewCell.h"

#import "UserModel.h"
#import "ScrollViewModel.h"
#import "HostDetailInfoModel.h"

#import "UITabBarController+hidable.h"
#import "RNFullScreenScroll.h"
#import "ScrollAndPageView.h"
#import "HeaderScrollImageView.h"


@interface LeftVC ()<ScrollViewViewDelegate,MoreTableViewCellDelegate>
{
#pragma mark navigatiombarview
    UIImageView *_focusImageView;
    UIImageView *_hotImageView;
    UIImageView *_moreImageView;
    UIButton *_focusButton;
    UIButton *_hotButton;
    UIButton *_moreButton;
#pragma mark header刷新
    SRRefreshView   *_hotSlimeView;
    SRRefreshView   *_focusSlimeView;
    SRRefreshView   *_moreSlimeView;
#pragma mark data数据
    NSMutableArray  *_hotDataArray;
    NSMutableArray  *_focusDataArray;
    NSMutableArray  *_moreDataArray;
#pragma mark timercount
    NSInteger refreshTimerCount;
#pragma mark 记录当前的cell的indexpath。row
    NSInteger currentIndexPathRow;
#pragma mark 滚动图
    NSMutableArray  *_scrollDataArray;
    UIImageView     *_scrollbgImageView;
#pragma mark 消息按钮
    BadgeButton *messageButton;
}
@property (nonatomic, strong) UIScrollView *groundScrollView;
@property (nonatomic, strong) RNFullScreenScroll *rnfullScreenScroll;
@property (nonatomic, strong) ScrollAndPageView *whView;
#pragma mark timer
@property (nonatomic,retain) NSTimer * countDomnTimer;
@end

@implementation LeftVC


- (void)viewDidLoad {
    [super viewDidLoad];
    [self DataInit];
    [self UIInit];
    
    [self sendURI_IndexShowHotRequest];
    [self sendURI_HomeScrollRequest];
    [self showActivityIndicatorView];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(messageChange:) name:kGetTotalNotReadNumNotificaiton object:nil];
    // Do any additional setup after loading the view.
}

- (void)DataInit
{
    currentIndexPathRow = 0;
    refreshTimerCount = 30;
    refreshTimerCount = 0;
    _hotDataArray = [[NSMutableArray alloc]init];
    _focusDataArray = [[NSMutableArray alloc]init];
    _moreDataArray = [[NSMutableArray alloc]init];
    _scrollDataArray = [[NSMutableArray alloc]init];
}
- (void)UIInit
{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
    [self.navigationController.navigationBar addSubview:[self getNavgationBarView]];
    
    _groundScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SELFVIEW_WIDTH, SELFVIEW_HEIGHT)];
    _groundScrollView.delegate = self;
    _groundScrollView.showsHorizontalScrollIndicator = NO;
    _groundScrollView.showsVerticalScrollIndicator = NO;
    _groundScrollView.pagingEnabled = YES;
    _groundScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*3, 0);
    [self.view addSubview:_groundScrollView];
    _groundScrollView.directionalLockEnabled=YES;//定向锁定

#pragma mark 热门
    _hotTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _hotTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _hotTableView.delegate = self;
    _hotTableView.dataSource = self;
    [_groundScrollView addSubview:_hotTableView];
    [_groundScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0)];
    
    _hotSlimeView = [[SRRefreshView alloc] init];
    _hotSlimeView.delegate = self;
    _hotSlimeView.slimeMissWhenGoingBack = YES;
    _hotSlimeView.slime.bodyColor = [UIColor blackColor];
    _hotSlimeView.slime.skinColor = [UIColor whiteColor];
    _hotSlimeView.slime.lineWith = 1;
    _hotSlimeView.slime.shadowBlur = 4;
    _hotSlimeView.slime.shadowColor = [UIColor blackColor];
    
    UIView *sheaderView = [self getTableViewHeaderViewWithTableView:_hotTableView];
    
    _hotTableView.tableHeaderView = sheaderView;
    _hotTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [_hotTableView addSubview:_hotSlimeView];
    _hotTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [_hotSlimeView update:0];
    
#pragma mark 关注
    _focusTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _focusTableView.delegate = self;
    _focusTableView.dataSource = self;
    _focusTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_groundScrollView addSubview:_focusTableView];
    
    _focusSlimeView = [[SRRefreshView alloc] init];
    _focusSlimeView.delegate = self;
    _focusSlimeView.slimeMissWhenGoingBack = YES;
    _focusSlimeView.slime.bodyColor = [UIColor blackColor];
    _focusSlimeView.slime.skinColor = [UIColor whiteColor];
    _focusSlimeView.slime.lineWith = 1;
    _focusSlimeView.slime.shadowBlur = 4;
    _focusSlimeView.slime.shadowColor = [UIColor blackColor];
    
    UIView *fheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SELFVIEW_WIDTH, 31)];
    fheaderView.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    UIImageView *fImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 5, 5, 31-10)];
    fImageView.backgroundColor = [UIColor colorWithHexString:@"0xea6e69"];
    [fheaderView addSubview:fImageView];
    UILabel *flabel = [[UILabel alloc]initWithFrame:CGRectMake(fImageView.right+5, 0, 260, 31)];
    flabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    flabel.backgroundColor = [UIColor clearColor];
    flabel.textColor = [UIColor blackColor];
    flabel.text = @"关注好友的直播";
    [fheaderView addSubview:flabel];
    
    _focusTableView.tableHeaderView = fheaderView;
    _focusTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [_focusTableView addSubview:_focusSlimeView];
    _focusTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [_focusSlimeView update:0];
    
    
#pragma mark 更多
    _moreTableView = [[UITableView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*2, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    _moreTableView.delegate = self;
    _moreTableView.dataSource = self;
    _moreTableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [_groundScrollView addSubview:_moreTableView];
    
    _moreSlimeView = [[SRRefreshView alloc] init];
    _moreSlimeView.delegate = self;
    _moreSlimeView.slimeMissWhenGoingBack = YES;
    _moreSlimeView.slime.bodyColor = [UIColor blackColor];
    _moreSlimeView.slime.skinColor = [UIColor whiteColor];
    _moreSlimeView.slime.lineWith = 1;
    _moreSlimeView.slime.shadowBlur = 4;
    _moreSlimeView.slime.shadowColor = [UIColor blackColor];
    
    UIView *mheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SELFVIEW_WIDTH, 0)];
    _moreTableView.tableHeaderView = mheaderView;
    _moreTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth| UIViewAutoresizingFlexibleHeight;
    [_moreTableView addSubview:_moreSlimeView];
    _moreTableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [_moreSlimeView update:0];
    
    self.rnfullScreenScroll = [[RNFullScreenScroll alloc] initWithViewController:self scrollView:self.hotTableView];
    
// resume bars when back to forground from other apps

}
- (UIView *)getNavgationBarView
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, NAV_BAR_HEIGHT+STATUS_BAR_HEIGHT)];
    UIImageView *navImageView = [[UIImageView alloc]initWithFrame:navView.bounds];
    navImageView.image = [UIImage imageNamed:@"navImage"];
    [navView addSubview:navImageView];
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    searchButton.frame = CGRectMake(0, 20, NAV_BAR_HEIGHT, NAV_BAR_HEIGHT);
    [searchButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [searchButton addTarget: self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:searchButton];
    
    messageButton = [[BadgeButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - NAV_BAR_HEIGHT, 20, NAV_BAR_HEIGHT, NAV_BAR_HEIGHT)];
    messageButton.userInteractionEnabled = YES;
    [messageButton addTarget:self action:@selector(messageButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:messageButton];
    
    _focusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _focusButton.frame = CGRectMake((SCREEN_WIDTH - 60*3)/2, 20, 60, NAV_BAR_HEIGHT);
    [_focusButton setTitle:@"关注" forState:UIControlStateNormal];
    [_focusButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _focusButton.titleLabel.font = [UIFont systemFontOfSize:CustomFont(18)];
    [_focusButton addTarget: self action:@selector(focusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:_focusButton];
    _focusImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_focusButton.left + (60-32)/2, 64-10, 32, 2)];
    _focusImageView.image = [UIImage imageNamed:@"normal_select"];
    [navView addSubview:_focusImageView];
    _focusImageView.hidden = YES;
    
    _hotButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _hotButton.frame = CGRectMake((SCREEN_WIDTH - 60*3)/2+60, 20, 60, NAV_BAR_HEIGHT);
    [_hotButton setTitle:@"热门" forState:UIControlStateNormal];
    [_hotButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _hotButton.titleLabel.font = [UIFont systemFontOfSize:CustomFont(18)];
    [_hotButton addTarget: self action:@selector(hotButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:_hotButton];
    _hotImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_hotButton.left + (60-15)/2, 64-10, 15, 5)];
    _hotImageView.image = [UIImage imageNamed:@"hot_select"];
    [navView addSubview:_hotImageView];
    _hotImageView.hidden = NO;
    
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _moreButton.frame = CGRectMake((SCREEN_WIDTH - 60*3)/2+120, 20, 60, NAV_BAR_HEIGHT);
    [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _moreButton.titleLabel.font = [UIFont systemFontOfSize:CustomFont(18)];
    [_moreButton addTarget: self action:@selector(moreButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:_moreButton];
    _moreImageView = [[UIImageView alloc]initWithFrame:CGRectMake(_moreButton.left + (60-32)/2, 64-10, 32, 2)];
    _moreImageView.image = [UIImage imageNamed:@"normal_select"];
    [navView addSubview:_moreImageView];
    _moreImageView.hidden = YES;
    
    return navView;
}

#pragma mark buttonActions
- (void)searchButtonClick:(UIButton *)button
{
    SearchVC *searchVC = [[SearchVC alloc]init];
    [self.rnfullScreenScroll contractWhatEverNoAnimation];
    [self.navigationController pushViewController:searchVC animated:YES];
}
- (void)messageButtonClick
{
    MyFriendListVC *vc=[[MyFriendListVC alloc]init];
    [self.rnfullScreenScroll contractWhatEverNoAnimation];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)messageChange:(NSNotification *)notification{
    messageButton.badgeValue=(NSString *)notification.object;
}

- (void)focusButtonClick:(UIButton *)button
{
    _focusImageView.hidden = NO;
    _hotImageView.hidden = YES;
    _moreImageView.hidden = YES;
    [_groundScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    [_hotSlimeView endRefresh];
    [_moreSlimeView endRefresh];
    [self.rnfullScreenScroll contractWhatEver];
    self.rnfullScreenScroll = nil;
    self.rnfullScreenScroll = [[RNFullScreenScroll alloc] initWithViewController:self scrollView:self.focusTableView];
    if (_focusDataArray.count<1) {
        [self sendURI_FocusRequest];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_focusTableView reloadData];
        });
    }
}

- (void)hotButtonClick:(UIButton *)button
{
    _focusImageView.hidden = YES;
    _hotImageView.hidden = NO;
    _moreImageView.hidden = YES;
    [_groundScrollView setContentOffset:CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    [_focusSlimeView endRefresh];
    [_moreSlimeView endRefresh];
    [self.rnfullScreenScroll contractWhatEver];
    self.rnfullScreenScroll = nil;
    self.rnfullScreenScroll = [[RNFullScreenScroll alloc] initWithViewController:self scrollView:self.hotTableView];
    if (_hotDataArray.count<1) {
        [self sendURI_IndexShowHotRequest];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_hotTableView reloadData];
        });
    }
}

- (void)moreButtonClick:(UIButton *)button
{
    _focusImageView.hidden = YES;
    _hotImageView.hidden = YES;
    _moreImageView.hidden = NO;
    [_groundScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*2, 0) animated:YES];
    [_hotSlimeView endRefresh];
    [_focusSlimeView endRefresh];
    [self.rnfullScreenScroll contractWhatEver];
    self.rnfullScreenScroll = nil;
    self.rnfullScreenScroll = [[RNFullScreenScroll alloc] initWithViewController:self scrollView:self.moreTableView];
    if (_moreDataArray.count<1) {
        [self sendURI_MoreRequest];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [_moreTableView reloadData];
        });
    }
}

- (void)noFocusButtonClick:(UIButton *)button
{
    [self hotButtonClick:nil];
}
#pragma mark view出现消失
- (void)viewWillAppear:(BOOL)animated
{
    [self.rnfullScreenScroll viewWillAppear:animated];
    [self sendURI_IndexShowHotRequest];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden=NO;
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.rnfullScreenScroll viewDidAppear:animated];
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.rnfullScreenScroll viewWillDisappear:animated];
    [_countDomnTimer setFireDate:[NSDate distantFuture]];
    [_countDomnTimer invalidate];
    _countDomnTimer = nil;
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self.rnfullScreenScroll viewDidDisappear:animated];
    [super viewDidDisappear:animated];
}

#pragma mark getTableViewHeaderViewWithTableView
- (UIView *)getTableViewHeaderViewWithTableView:(UITableView*)tableView
{
    if (tableView == _hotTableView) {
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/3)];
        headerView.backgroundColor = [UIColor whiteColor];
        _scrollbgImageView = [[UIImageView alloc]initWithFrame:headerView.bounds];
        _scrollbgImageView.image = [UIImage imageNamed:@"广告图"];
        [headerView addSubview:_scrollbgImageView];
        if (_whView==nil) {
            _whView=[[ScrollAndPageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH/3)];
            _whView.scrollView.backgroundColor = [UIColor clearColor];
        }
        //把N张图片放到imageview上
        NSMutableArray *tempAry = [NSMutableArray array];
        for (int i=0; i<_scrollDataArray.count; i++) {
            ScrollViewModel *scrollModel = (ScrollViewModel*)[_scrollDataArray objectAtIndex:i];
            HeaderScrollImageView *headScorllImageView = [[HeaderScrollImageView alloc]initWithFrame:CGRectMake(0, 0, _whView.width, _whView.height)];
            [headScorllImageView.bgImageView setImageWithUrlString:scrollModel.img_url];
//            headScorllImageView.titlelabel.text = homeScrollModel.roomTitle;
            [tempAry addObject:headScorllImageView];
        }
        //把imageView数组存到whView里
        [_whView setImageViewAry:tempAry];
        //开启自动翻页
        [_whView shouldAutoShow:YES];
        
        //遵守协议
        _whView.delegate = self;
        [headerView addSubview:_whView];
        return headerView;
    }
    return [[UIView alloc]init];
}

#pragma mark 协议里面方法，点击某一页
-(void)didClickPage:(ScrollAndPageView *)view atIndex:(NSInteger)index
{
//    HomeScrollModel *homeScrollModel = (HomeScrollModel*)[homeCategoryModel.scroll objectAtIndex:(index-1)];
//    //弹出下一个界面
//    if (LiveEquipmentBool == YES&&cellRepeatClickCount==0) {
//        cellRepeatClickCount++;
//        [self sendGetLiveEquipmentRequestWithRoomId:homeScrollModel.roomId];
//    }
}

#pragma mark - Table view data source
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _moreTableView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 35)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(11, 0, SCREEN_WIDTH-20, 35)];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor darkGrayColor];
        label.font = [UIFont systemFontOfSize:CustomFont(15)];
        label.text = @"最新直播";
        [view addSubview:label];
        return view;
    }else{
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _moreTableView) {
        return 35;
    }else{
        return 0;
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == _hotTableView) {
            return _hotDataArray.count;
    }
    if (tableView == _focusTableView) {
        if (_focusDataArray.count>0) {
            return _focusDataArray.count;
        }
        return 1;
    }
    if (tableView == _moreTableView) {
        if (_moreDataArray.count%3==0) {
            return _moreDataArray.count/3;
        }else{
            return _moreDataArray.count/3+1;
        }
    }
    return 200;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _hotTableView) {
        return SCREEN_WIDTH + 48;
    }
    if (tableView == _focusTableView) {
        if (_focusDataArray.count>0) {
            return SCREEN_WIDTH + 48;
        }else{
            return SCREEN_WIDTH*5/13;
        }
    }
    if (tableView == _moreTableView) {
        return (SCREEN_WIDTH-20)/3-1+30;
    }
    return SCREEN_WIDTH;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == _hotTableView) {
        HotTableViewCell *cell=[self loadPhoneLiveCellWithTableView:tableView];
        [cell setUIWithHostInfoModel:[_hotDataArray objectAtIndex:indexPath.row]];
        currentIndexPathRow = indexPath.row;
        return cell;
    }
    
    if (tableView == _focusTableView) {
        if (_focusDataArray.count>0) {
            HotTableViewCell *cell=[self loadPhoneLiveCellWithTableView:tableView];
            [cell setUIWithHostInfoModel:[_focusDataArray objectAtIndex:indexPath.row]];
            return cell;
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
            UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*5/13)];
            imageV.image = [UIImage imageNamed:@"hot_focus"];
            [cell addSubview:imageV];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake((SCREEN_WIDTH-180)/2, (SCREEN_WIDTH*5/13- 30)/2, 180, 30);
            [button setTitle:@"去看看最新精彩直播" forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:CustomFont(14)];
            button.layer.cornerRadius = 30/2;
            button.layer.borderColor = [UIColor whiteColor].CGColor;
            button.layer.borderWidth = 1.0f;
            button.layer.masksToBounds = YES;
            [cell addSubview:button];
            [button addTarget:self action:@selector(noFocusButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
    }
    
    if (tableView == _moreTableView) {
        static NSString *ident = @"MoreTableViewCell";
        MoreTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
        if (!cell) {
            NSArray *objects = [[NSBundle mainBundle] loadNibNamed:ident owner:self options:nil];
            cell = (MoreTableViewCell*)objects[0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        NSInteger sectionCount = _moreDataArray.count/3;
        if (_moreDataArray.count%3==0) {
            cell.hostInfoModel1 = [_moreDataArray objectAtIndex:indexPath.row*3];
            cell.hostInfoModel2 = [_moreDataArray objectAtIndex:indexPath.row*3+1];
            cell.hostInfoModel3 = [_moreDataArray objectAtIndex:indexPath.row*3+2];
            cell.bgView1.hidden = NO;
            cell.bgView2.hidden = NO;
            cell.bgView3.hidden = NO;
        }else if (_moreDataArray.count%3==1){
            if (indexPath.row == sectionCount) {
                cell.hostInfoModel1 = [_moreDataArray objectAtIndex:indexPath.row*3];
                cell.bgView1.hidden = NO;
                cell.bgView2.hidden = YES;
                cell.bgView3.hidden = YES;
            }else{
                cell.hostInfoModel1 = [_moreDataArray objectAtIndex:indexPath.row*3];
                cell.hostInfoModel2 = [_moreDataArray objectAtIndex:indexPath.row*3+1];
                cell.hostInfoModel3 = [_moreDataArray objectAtIndex:indexPath.row*3+2];
                cell.bgView1.hidden = NO;
                cell.bgView2.hidden = NO;
                cell.bgView3.hidden = NO;
            }
        }else if (_moreDataArray.count%3==2){
            if (indexPath.row == sectionCount) {
                cell.hostInfoModel1 = [_moreDataArray objectAtIndex:indexPath.row*3];
                cell.hostInfoModel2 = [_moreDataArray objectAtIndex:indexPath.row*3+1];
                cell.bgView1.hidden = NO;
                cell.bgView2.hidden = NO;
                cell.bgView3.hidden = YES;
            }else{
                cell.hostInfoModel1 = [_moreDataArray objectAtIndex:indexPath.row*3];
                cell.hostInfoModel2 = [_moreDataArray objectAtIndex:indexPath.row*3+1];
                cell.hostInfoModel3 = [_moreDataArray objectAtIndex:indexPath.row*3+2];
                cell.bgView1.hidden = NO;
                cell.bgView2.hidden = NO;
                cell.bgView3.hidden = NO;
            }
        }

        [cell setUIwithModel];
        return cell;
    }
    
    return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
}

- (HotTableViewCell *)loadPhoneLiveCellWithTableView:(UITableView *)tableView{
    static NSString *ident = @"HotTableViewCell";
    HotTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:ident owner:self options:nil];
        cell = (HotTableViewCell*)objects[0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _hotTableView) {
        HostDetailInfoModel *hostInfoModel = [_hotDataArray objectAtIndex:indexPath.row];
        LiveRoomVC *plvc = [[LiveRoomVC alloc]init];
        plvc.hostDetailInfoModel = hostInfoModel;
        [self.rnfullScreenScroll contractWhatEverNoAnimation];
        [self.navigationController pushViewController:plvc animated:YES];
    }
    if (tableView == _focusTableView) {
        HostDetailInfoModel *hostInfoModel = [_focusDataArray objectAtIndex:indexPath.row];
        LiveRoomVC *plvc = [[LiveRoomVC alloc]init];
        plvc.hostDetailInfoModel = hostInfoModel;
        [self.rnfullScreenScroll contractWhatEverNoAnimation];
        [self.navigationController pushViewController:plvc animated:YES];
    }
}



#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _moreTableView) {
        CGFloat sectionHeaderHeight = 35;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    [_hotSlimeView scrollViewDidScroll];
    [_focusSlimeView scrollViewDidScroll];
    [_moreSlimeView scrollViewDidScroll];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _groundScrollView.scrollEnabled = YES;
    if (scrollView == _hotTableView) {
        [self sendURI_IndexInfosRequest];
    }
    
    if (scrollView == _groundScrollView) {
        [_hotSlimeView endRefresh];
        [_focusSlimeView endRefresh];
        [_moreSlimeView endRefresh];
        int pageIndex = _groundScrollView.contentOffset.x/SCREEN_WIDTH;
        
        if (pageIndex == 0) {
            [self.rnfullScreenScroll contractWhatEver];
            self.rnfullScreenScroll = nil;
            self.rnfullScreenScroll = [[RNFullScreenScroll alloc] initWithViewController:self scrollView:self.focusTableView];
            _focusImageView.hidden = NO;
            _hotImageView.hidden = YES;
            _moreImageView.hidden = YES;
            if (_focusDataArray.count<1) {
                [self sendURI_FocusRequest];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_focusTableView reloadData];
                });
            }
        }
        if (pageIndex == 1) {
            [self.rnfullScreenScroll contractWhatEver];
            self.rnfullScreenScroll = nil;
            self.rnfullScreenScroll = [[RNFullScreenScroll alloc] initWithViewController:self scrollView:self.hotTableView];
                _focusImageView.hidden = YES;
            _hotImageView.hidden = NO;
            _moreImageView.hidden = YES;
            if (_hotDataArray.count<1) {
                [self sendURI_IndexShowHotRequest];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_hotTableView reloadData];
                });
            }
        }
        if (pageIndex == 2) {
            [self.rnfullScreenScroll contractWhatEver];
            self.rnfullScreenScroll = nil;
            self.rnfullScreenScroll = [[RNFullScreenScroll alloc] initWithViewController:self scrollView:self.moreTableView];
            _focusImageView.hidden = YES;
            _hotImageView.hidden = YES;
            _moreImageView.hidden = NO;
            if (_moreDataArray.count<1) {
                [self sendURI_MoreRequest];
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_moreTableView reloadData];
                });
            }
        }
    }
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_hotSlimeView scrollViewDidEndDraging];
    [_focusSlimeView scrollViewDidEndDraging];
    [_moreSlimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate

- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    if (refreshView == _hotSlimeView) {
        [self sendURI_IndexShowHotRequest];
        [self sendURI_HomeScrollRequest];
    }
    if (refreshView == _focusSlimeView) {
        [self sendURI_FocusRequest];
    }
    if (refreshView == _moreSlimeView) {
        [self sendURI_MoreRequest];
    }
}



#pragma mark  requests
- (void)sendURI_IndexShowHotRequest
{
    [AFRequestManager SafeGET:URI_IndexShow parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            NSArray *list = [result objectForKey:@"data"];
            if ([list isKindOfClass:[NSArray class]]) {
                _hotDataArray = [NSMutableArray arrayWithCapacity:list.count];
                for (NSDictionary *dic in list) {
                    [_hotDataArray addObject:[[HostDetailInfoModel alloc] initWithDictionary:dic error:nil]];
                }
            }
            [_countDomnTimer setFireDate:[NSDate distantFuture]];
            [_countDomnTimer invalidate];
            _countDomnTimer = nil;
            
            refreshTimerCount = [[result objectForKey:@"expire_time"] integerValue];
            _countDomnTimer = [NSTimer scheduledTimerWithTimeInterval:refreshTimerCount target:self selector:@selector(refreshALLdataSource) userInfo:nil repeats:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_hotTableView reloadData];
            });
        }
        [_hotSlimeView endRefresh];
        [self hideActivityIndicatorView];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_hotSlimeView endRefresh];
        [self hideActivityIndicatorView];
    }];
}

- (void)sendURI_FocusRequest
{
    NSMutableDictionary *paramToken = [NSMutableDictionary dictionary];
    [paramToken setObject:User_Token forKey:@"token"];
    [AFRequestManager SafeGET:URI_AttentionList parameters:paramToken success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            NSArray *list = [result objectForKey:@"data"];
            if ([list isKindOfClass:[NSArray class]]) {
                _focusDataArray = [NSMutableArray arrayWithCapacity:list.count];
                for (NSDictionary *dic in list) {
                    HostDetailInfoModel *hostDetailInfoModel = [[HostDetailInfoModel alloc] initWithDictionary:dic error:nil];
                    if (hostDetailInfoModel.status.intValue) {
                        [_focusDataArray addObject:hostDetailInfoModel];
                    }
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_focusTableView reloadData];
            });
        }
        [_focusSlimeView endRefresh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_focusSlimeView endRefresh];
    }];
}

- (void)sendURI_MoreRequest
{
    [AFRequestManager SafeGET:URI_LastAnchor parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            NSArray *list = [result objectForKey:@"data"];
            if ([list isKindOfClass:[NSArray class]]) {
                _moreDataArray = [NSMutableArray arrayWithCapacity:list.count];
                for (NSDictionary *dic in list) {
                    [_moreDataArray addObject:[[HostDetailInfoModel alloc] initWithDictionary:dic error:nil]];
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [_moreTableView reloadData];
            });
        }
        [_moreSlimeView endRefresh];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_moreSlimeView endRefresh];
    }];
}
//详细信息
- (void)sendURI_IndexInfosRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_hotDataArray.count<7) {
        return;
    }
    if (currentIndexPathRow== 0) {
        NSString *id1 = [[_hotDataArray objectAtIndex:currentIndexPathRow] sid];
        NSString *id2 = [[_hotDataArray objectAtIndex:currentIndexPathRow+1] sid];
        NSString *id3 = [[_hotDataArray objectAtIndex:currentIndexPathRow+2] sid];
        NSString *id4 = [[_hotDataArray objectAtIndex:currentIndexPathRow+3] sid];
        NSString *id5 = [[_hotDataArray objectAtIndex:currentIndexPathRow+4] sid];
        [params setObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@",id1,id2,id3,id4,id5] forKey:@"ids"];
    }else if (currentIndexPathRow == 1){
        NSString *id1 = [[_hotDataArray objectAtIndex:currentIndexPathRow-1] sid];
        NSString *id2 = [[_hotDataArray objectAtIndex:currentIndexPathRow] sid];
        NSString *id3 = [[_hotDataArray objectAtIndex:currentIndexPathRow+1] sid];
        NSString *id4 = [[_hotDataArray objectAtIndex:currentIndexPathRow+2] sid];
        NSString *id5 = [[_hotDataArray objectAtIndex:currentIndexPathRow+3] sid];
        [params setObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@",id1,id2,id3,id4,id5] forKey:@"ids"];
    }else if (currentIndexPathRow == _hotDataArray.count-1){
        NSString *id1 = [[_hotDataArray objectAtIndex:currentIndexPathRow-4] sid];
        NSString *id2 = [[_hotDataArray objectAtIndex:currentIndexPathRow-3] sid];
        NSString *id3 = [[_hotDataArray objectAtIndex:currentIndexPathRow-2] sid];
        NSString *id4 = [[_hotDataArray objectAtIndex:currentIndexPathRow-1] sid];
        NSString *id5 = [[_hotDataArray objectAtIndex:currentIndexPathRow] sid];
        [params setObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@",id1,id2,id3,id4,id5] forKey:@"ids"];
    }else if (currentIndexPathRow == _hotDataArray.count-2){
        NSString *id1 = [[_hotDataArray objectAtIndex:currentIndexPathRow-3] sid];
        NSString *id2 = [[_hotDataArray objectAtIndex:currentIndexPathRow-2] sid];
        NSString *id3 = [[_hotDataArray objectAtIndex:currentIndexPathRow-1] sid];
        NSString *id4 = [[_hotDataArray objectAtIndex:currentIndexPathRow] sid];
        NSString *id5 = [[_hotDataArray objectAtIndex:currentIndexPathRow+1] sid];
        [params setObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@",id1,id2,id3,id4,id5] forKey:@"ids"];
    }else{
        NSString *id1 = [[_hotDataArray objectAtIndex:currentIndexPathRow-2] sid];
        NSString *id2 = [[_hotDataArray objectAtIndex:currentIndexPathRow-1] sid];
        NSString *id3 = [[_hotDataArray objectAtIndex:currentIndexPathRow] sid];
        NSString *id4 = [[_hotDataArray objectAtIndex:currentIndexPathRow+1] sid];
        NSString *id5 = [[_hotDataArray objectAtIndex:currentIndexPathRow+2] sid];
        [params setObject:[NSString stringWithFormat:@"%@,%@,%@,%@,%@",id1,id2,id3,id4,id5] forKey:@"ids"];
    }

    [AFRequestManager SafeGET:URI_IndexInfos parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            NSArray *list = [result objectForKey:@"data"];
            if ([list isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dic in list) {
                    HostDetailInfoModel *hostDetailInfoModel= [[HostDetailInfoModel alloc] initWithDictionary:dic error:nil];
                    for (int i=0; i<_hotDataArray.count-1; i++) {
                        HostDetailInfoModel *hostDetailInfoModel1 = [_hotDataArray objectAtIndex:i];
                        if ([hostDetailInfoModel1.sid isEqualToString:hostDetailInfoModel.sid]) {
                            [_hotDataArray replaceObjectAtIndex:i withObject:hostDetailInfoModel];
                            [_hotTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:i inSection:0],nil] withRowAnimation:UITableViewRowAnimationNone];
                        }
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}


//滚动图
#pragma mark  requests
- (void)sendURI_HomeScrollRequest
{
    [AFRequestManager SafeGET:URI_HomeScroll parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            NSArray *list = [result objectForKey:@"data"];
            if ([list isKindOfClass:[NSArray class]]) {
                _scrollDataArray = [NSMutableArray arrayWithCapacity:list.count];
                for (NSDictionary *dic in list) {
                    [_scrollDataArray addObject:[[ScrollViewModel alloc] initWithDictionary:dic error:nil]];
                }
            }
            [self refreshScrollViewUI];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)refreshScrollViewUI
{    
    for (UIImageView *imageView in _hotTableView.tableHeaderView.subviews) {
        if (imageView == _scrollbgImageView) {
            [imageView removeFromSuperview];
        }
    }
    //把N张图片放到imageview上
    NSMutableArray *tempAry = [NSMutableArray array];
    for (int i=0; i<_scrollDataArray.count; i++) {
        ScrollViewModel *scrollModel = (ScrollViewModel*)[_scrollDataArray objectAtIndex:i];
        HeaderScrollImageView *headScorllImageView = [[HeaderScrollImageView alloc]initWithFrame:CGRectMake(0, 0, _whView.width, _whView.height)];
        [headScorllImageView.bgImageView setImageWithUrlString:scrollModel.img_url];\
        //            headScorllImageView.titlelabel.text = homeScrollModel.roomTitle;
        [tempAry addObject:headScorllImageView];
    }
    //把imageView数组存到whView里
    [_whView setImageViewAry:tempAry];
    //开启自动翻页
    [_whView shouldAutoShow:YES];
}

#pragma makr refreshALLdataSource
- (void)refreshALLdataSource
{
    [self sendURI_IndexShowHotRequest];
    [self sendURI_FocusRequest];
    [self sendURI_MoreRequest];
}


#pragma mark tMoreTableviewCellDelegate
- (void)didSelectMoreTableviewWithHostInfoModel:(HostDetailInfoModel *)hostInfoModel
{
    LiveRoomVC *plvc = [[LiveRoomVC alloc]init];
    plvc.hostDetailInfoModel = hostInfoModel;
    [self.rnfullScreenScroll contractWhatEverNoAnimation];
    [self.navigationController pushViewController:plvc animated:YES];
}

- (void)dealloc
{
    [_hotSlimeView removeFromSuperview];
    [_focusSlimeView removeFromSuperview];
    [_moreSlimeView removeFromSuperview];
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
