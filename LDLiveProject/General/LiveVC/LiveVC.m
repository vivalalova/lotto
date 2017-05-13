//
//  LiveVC.m
//  LDLiveProject
//
//  Created by MAC on 16/6/21.
//  Copyright © 2016年 MAC. All rights reserved.
//
#define cellFont  16
#import "ChatPrivateVC.h"
#import "MessListModel.h"
#import "CreditListVC.h"
#import "SDImageCache.h"

#import "LiveVC.h"
#import "UserModel.h"
#import "PhoneLiveCell.h"
#import "SocketMessageModel.h"
#import "PhoneLiveCellTool.h"

#import "DMHeartFlyView.h"
#import "DansView.h"

#import "LiveChooseVC.h"
#import "ChatListModel.h"

#import "LiveCountDownView.h"

#import "AdminVC.h"
#import "AdminModel.h"

#import "GiftListModel.h"
#import "GiftOneModel.h"
#import "UserSendGiftModel.h"
#import "GiveGiftAnimation.h"
#import "PhoneReceiveGiftManager.h"
#import "UserWelcomeModel.h"

#import "PersonInfoModel.h"
#import "PersonInfoView.h"
#import "WeskitInfoView.h"
#import "LiveFinishView.h"
#import "MBAnimationView.h"
#import "VIPComeInAnimation.h"
/*------------*/
//#import "UIControl+YYAdd.h"
//#import "UIView+YYAdd.h"
/*------------*/
#import "LFLiveSession.h"

static BOOL LoginSuccessBool = YES;

@interface LiveVC ()<LFLiveSessionDelegate,UIActionSheetDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,PhoneLiveCellDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,LiveChooseVCDelegate,UITextFieldDelegate,PersonInfoViewDelegate,WeskitInfoViewDelegate,LiveFinishViewDelegate,AdminVCDelegate,MBAnimationViewDelegate,CreditListVCDelegate>
{
    UserModel *_userModel;
#pragma mark 礼物相关
    GiftListModel *_giftListModel;
#pragma mark 聊天滚动timer
    NSTimer *chatTimer;
//    NSTimer *chatScrollTimer;
#pragma mark 在线观众
    NSTimer  *refreshTimer;
    NSString *startNum;
    NSString *stopNum;
#pragma mark 用户的当前权限socket获取相关
    NSInteger manager_level;
    NSString *userUid;
    NSString *manUserUid;
    NSString *manUserNick;
    BOOL DanmuMessageBOOL;//是不是弹幕发送
    //私信
    ChatPrivateVC *chatVC;
    //排行榜
    CreditListVC *creditVC;
#pragma mark 第一次进入直播倒计时
    BOOL CountdownBOOL;
}
@property (nonatomic,strong) NSMutableArray *socketAddrArray;
#pragma mark 推流
@property (nonatomic, strong) LFLiveDebug *debugInfo;
@property (nonatomic, strong) LFLiveSession *session;

@property (strong, nonatomic) LiveChooseVC *liveChooseVC;
@property (weak, nonatomic) IBOutlet UIView *liveView;
//背景视图
@property (weak, nonatomic) IBOutlet UIView *contentView;
#pragma mark 输入框
@property (weak, nonatomic) IBOutlet UIView *chatTextFiledBar;
@property (weak, nonatomic) IBOutlet UIView *danmuBGView;
@property (weak, nonatomic) IBOutlet UILabel *danmuLabel;
@property (weak, nonatomic) IBOutlet UITextField *chatTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
//左上角头像
@property (weak, nonatomic) IBOutlet UIView *headerBGView;
@property (weak, nonatomic) IBOutlet WebImageView *headerImageV;
@property (weak, nonatomic) IBOutlet UILabel *onlineUserNumLabel;
//底部toolbar
@property (weak, nonatomic) IBOutlet UIView *bottomToolBar;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIButton *flashButton;
@property (weak, nonatomic) IBOutlet UIButton *camerButton;
@property (weak, nonatomic) IBOutlet UIButton *beautyButton;
//贡献榜
@property (weak, nonatomic) IBOutlet UIButton *creditsButton;

//chat tableview
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
//礼物相关
@property (strong, nonatomic) GiftOneModel *currentSendGift;//当前要送的礼物连击
@property (strong, nonatomic) PhoneReceiveGiftManager *reveiveGiftManager;
//VIP进入动画
@property (strong, nonatomic) VIPComeInAnimation *vipComeInAnimation;
//高级礼物
@property (strong, nonatomic) MBAnimationView *animationView;
@property (strong, nonatomic) NSMutableArray *higherAnimationArray;//存储高级动画
//个人信息页
@property (strong, nonatomic) PersonInfoView *personInfoView;
@property (strong, nonatomic) WeskitInfoView *weskitInfoView;
//管理员列表
@property (strong, nonatomic)AdminVC *adminVC;

@end

#define StopLiveAlertTag   1000
#define ShutupAlertTag     2000
#define ReportAlertTag     3000
#define MJShutupAlertTag   4000
@implementation LiveVC


- (NSMutableArray *)higherAnimationArray
{
    if (!_higherAnimationArray) {
        _higherAnimationArray=[NSMutableArray array];
    }
    return _higherAnimationArray;
}

- (MBAnimationView *)animationView{
    if (_animationView==nil) {
        _animationView = [[MBAnimationView alloc] initWithFrame:CGRectMake(0, 120, SCREEN_WIDTH, (1013*SCREEN_WIDTH)/1242)];
        _animationView.delegate=self;
        [self.view addSubview:_animationView];
    }
    return _animationView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.userDataArray = [NSMutableArray array];
    _liveChooseVC = [[LiveChooseVC alloc]init];
    _liveChooseVC.userTVInfoModel = self.userTVInfoModel;
    _liveChooseVC.delegate = self;
    [self.view addSubview:_liveChooseVC.view];
    
    [self initSubViewsStyle];
    [self setSubViewsData];
    [self sendSocketListRequest];
    [self sendGiftListRequest];
    [self sendUserFianceRequest];
}

- (void)kNetworkStatusChangedAction
{
    [self.socketPrivate connect];
}
#pragma mark 定制xibView
- (void)initSubViewsStyle
{
    //管理员列表
    _adminVC = [[AdminVC alloc]init];
    _adminVC.delegate = self;
    [self addChildViewController:_adminVC];
    [self.view addSubview:_adminVC.view];
    _adminVC.view.hidden = YES;
    //聊天输入框
    _danmuBGView.backgroundColor = [UIColor lightGrayColor];
    _danmuLabel.textColor = [UIColor lightGrayColor];
    _danmuBGView.layer.cornerRadius = 3;
    _danmuBGView.layer.masksToBounds = YES;
    _danmuLabel.layer.cornerRadius = 3;
    _danmuLabel.layer.masksToBounds = YES;
    _chatTextField.layer.cornerRadius = 3;
    _chatTextField.layer.masksToBounds = YES;
    _chatTextField.delegate = self;
    _sendMessageButton.layer.cornerRadius = 3;
    _sendMessageButton.layer.masksToBounds = YES;
    [_sendMessageButton setBackgroundImage:[UIImage imageByApplyingAlpha:1 color:[UIColor colorWithHexString:GiftUsualColor]] forState:UIControlStateNormal];
    
    //左上角个人信息
    _headerImageV.layer.cornerRadius=_headerImageV.height/2;
    _headerImageV.layer.masksToBounds=YES;
    _headerBGView.layer.cornerRadius=_headerBGView.height/2;
    _headerBGView.layer.masksToBounds=YES;
    _headerBGView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.4];
    //聊天tableview
    [_tableView setBottom:_bottomToolBar.top];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    
    //contentview添加手势
    UITapGestureRecognizer* myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.contentView addGestureRecognizer:myTap];
    myTap.delegate = self;
    myTap.cancelsTouchesInView = NO;
    //当前观众
    if(_horizontalView==nil){
        self.horizontalView	= [[EasyTableView alloc] initWithFrame:CGRectMake(_headerBGView.right+5, _headerBGView.top, SCREEN_WIDTH - _headerBGView.right-5, 34) ofWidth:36];
        self.horizontalView.delegate					= self;
        self.horizontalView.tableView.backgroundColor	= [UIColor clearColor];
        self.horizontalView.tableView.allowsSelection	= YES;
        self.horizontalView.tableView.separatorColor	= [UIColor clearColor];
        self.horizontalView.autoresizingMask			= UIViewAutoresizingFlexibleWidth;
        self.horizontalView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.horizontalView];
    }
    //贡献榜按钮
    _creditsButton.backgroundColor = [[UIColor colorWithHexString:GiftUsualColor]colorWithAlphaComponent:0.5];
    _creditsButton.layer.cornerRadius = _creditsButton.height/2;
    _creditsButton.clipsToBounds = YES;
    _creditsButton.hidden = YES;
}
- (void)setSubViewsData
{
    LoginSuccessBool = YES;
    CountdownBOOL = YES;
    _userModel = [AccountHelper userInfo];
    [_headerImageV setImageWithUrlString:_userModel.headportrait placeholderImage:[UIImage imageByApplyingAlpha:1 color:[UIColor darkGrayColor]]];
    
    [NSThread detachNewThreadSelector:@selector(startRefreshTimer) toTarget:self withObject:nil];
    [NSThread detachNewThreadSelector:@selector(startChatTimer) toTarget:self withObject:nil];
}

- (void)startRefreshTimer
{
    startNum = @"0";
    stopNum = @"49";
    @autoreleasepool {
        refreshTimer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(refreshOnlineUsers) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    }
}
- (void)startChatTimer
{
    @autoreleasepool {
        chatTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(chatTableViewReloadData) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    }
}

#pragma mark view  apper  disapper------------------------------

- (void)viewWillAppear:(BOOL)animated
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification object:nil]; //监听是否触发home键挂起程序.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kNetworkStatusChangedAction) name:kNetworkStatusChangedNotification object:nil];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    self.personInfoView;
    self.weskitInfoView;
    [self requestAccessForVideo];
    [self requestAccessForAudio];
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNetworkStatusChangedNotification object:nil];
    [super viewDidDisappear:animated];
}

- (void)applicationWillResignActive:(NSNotification *)notification
{
    [self.socketPrivate sendEvent:@"play task" data:@{}];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification
{

}
#pragma mark ------------------------推流start--------------------------------------
#pragma mark  获取相机和麦克风权限
-(BOOL)getAVCaptureDevicePermissions
{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        //无权限
        NSString *tips = [NSString stringWithFormat:@"请在iPhone的”设置-隐私-相机“选项中，允许\"秀播高尔夫\"访问你的手机相机"];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:tips delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        return NO;
    }
    return YES;
}
-(BOOL)getAVAudioSessionPermissions
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (!granted) {
                    bCanRecord = NO;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:[NSString stringWithFormat:@"请在iPhone的”设置-隐私-麦克风“选项中，允许\"秀播高尔夫\"访问你的手机麦克风"]
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil] show];
                    });
                }else{
                    bCanRecord = YES;
                }
            }];
        }
    }
    return bCanRecord;
}

- (void)requestAccessForVideo{
    __weak typeof(self) _self = self;
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_self.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            [_self.session setRunning:YES];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
}

- (void)requestAccessForAudio{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}
#pragma mark -- LFStreamingSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    if (state == LFLiveError) {
//        [self.session stopLive];
//        LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
//        stream.url = self.userTVInfoModel.publish_addr;
//        [self.session startLive:stream];
    }

}

/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo{
    
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode{
    NSString *str =[NSString stringWithFormat:@"当前网络状态不佳\n请您检查您的网络情况后,尝试重新开播."];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"直播错误" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
    [self didClickLiveFinishViewCloseButton];
}

#pragma mark -- Getter Setter
- (LFLiveSession*)session{
    if(!_session){
        /***   默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏 ***/
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:[LFLiveAudioConfiguration defaultConfiguration] videoConfiguration:[LFLiveVideoConfiguration defaultConfigurationForQuality:LFLiveVideoQuality_Medium2 landscape:NO]];
        _session.delegate = self;
        _session.running = YES;
        _session.preView = _liveView;
    }
    return _session;
}
#pragma mark 开播停播
- (void)sendRoomStartRequest
{
    @WeakObj(self);
    LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
    @WeakObj(stream);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [params setObject:self.titleStr forKey:@"urtitle"];
    [params setObject:@"1" forKey:@"orientation"];
    [AFRequestManager SafeGET:URI_RoomStart parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            streamWeak.url = selfWeak.userTVInfoModel.publish_addr;
//            streamWeak.url = @"rtmp://pull.myxstar.cn/golf/12345";
//            streamWeak.url = @"rtmp://stream3.zhibo.tv/8live/12345";
//            streamWeak.url = @"rtmp://stream.bo8.tv/8live_m/s_8194";
            [self.session startLive:stream];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)sendRoomStopRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [AFRequestManager SafeGET:URI_RoomStop parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
        [self.session setRunning:NO];
        if ([result[@"status"] intValue] == 200) {
            [self showLiveFinishViewWithData:result[@"data"]];
        }else if ([result[@"status"] intValue] == 208) {
            [self showLiveFinishViewWithData:result[@"data"]];
        }else{
            [self showLiveFinishViewWithData:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.session setRunning:NO];
        [self showLiveFinishViewWithData:nil];
    }];
}
- (void)showLiveFinishViewWithData:(NSDictionary*)dict
{
    [self endEditing];
    LiveFinishView *liveFinishView = [LiveFinishView viewFromXIB];
    liveFinishView.width = SCREEN_WIDTH;
    liveFinishView.height = SCREEN_HEIGHT;
    liveFinishView.delegate = self;
    [liveFinishView setDataWithStopDict:dict];
    [self.view addSubview:liveFinishView];
}

//LiveFinishView 代理
- (void)didClickLiveFinishViewCloseButton
{
    [self.session setRunning:NO];
    [self.session stopLive];
    [chatTimer setFireDate:[NSDate distantFuture]];
    [chatTimer invalidate];
    chatTimer = nil;
    [refreshTimer setFireDate:[NSDate distantFuture]];
    [refreshTimer invalidate];
    refreshTimer = nil;
//    [chatScrollTimer invalidate];
//    chatScrollTimer = nil;
    [self.socketPrivate disconnect];
    self.socketPrivate = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ------------------------推流end--------------------------------------
#pragma mark ---------------------socketStart-------------------------------------
- (void)sendSocketListRequest
{
    @WeakObj(self);
    [AFRequestManager SafeGET:URI_ChatList parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            NSArray *list = [result objectForKey:@"data"];
            if ([list isKindOfClass:[NSArray class]]) {
                self.socketAddrArray = [NSMutableArray arrayWithCapacity:list.count];
                for (NSDictionary *dic in list) {
                    [self.socketAddrArray addObject:[[ChatListModel alloc] initWithDictionary:dic error:nil]];
                }
            }
            [selfWeak sendRequestOfSocketWithChatListModel:[self.socketAddrArray firstObject]];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
-(void)sendRequestOfSocketWithChatListModel:(ChatListModel*)clModel
{
    NSArray *array = [clModel.addr componentsSeparatedByString:@":"];
    if (array.count!=2) {
        return;
    }
    if ([self.socketPrivate isConnecting] || [self.socketPrivate isConnected]) {
        return;
    }
    self.socketPrivate = [[SocketIO alloc] initWithDelegate:self host:[array objectAtIndex:0] port:[[array objectAtIndex:1] integerValue] namespace:nil timeout:1000 secured:NO];
    [_socketPrivate connect];
}

- (void) socketIODidDisconnect:(SocketIO *)socket
{
    [socket connect];
    NSLog(@"Disconnect");
}
- (void) socketIO:(SocketIO *)socket didReceiveMessage:(id)data ack:(SocketIOCallback)function
{
}

- (void) socketIO:(SocketIO *)socket didReceiveEvent:(NSString *) eventName data:(id)data extradata:(id)extradata ack:(SocketIOCallback) function
{
    if ([eventName isEqualToString:@"login success"]) {
        //登录成功
        if (![NSString isBlankString:[KAPP_DELEGATE roomWarningString]] && LoginSuccessBool) {
            NSDictionary *newDict = [NSDictionary dictionaryWithObject:[KAPP_DELEGATE roomWarningString] forKey:@"login success"];
            [self newMessageDataChanged:newDict];
            LoginSuccessBool = NO;
        }
        //用户在当前房间的管理等级
        manager_level = [NSString stringWithFormat:@"%@",[data objectForKey:@"manager_level"]].integerValue;
        //主播球票数
        NSString *str = [data objectForKey:@"room_credit"];
        [self setCreditButtonWithNumString:str];
        //在线观众
        NSDictionary *getUserDict = [[NSDictionary alloc]initWithObjectsAndKeys:@"0",@"start",@"49",@"stop", nil];
        [self.socketPrivate sendEvent:@"get online users" data:getUserDict];
    }else if ([eventName isEqualToString:@"new message"]){
        //聊天
        NSDictionary *newDict = [NSDictionary dictionaryWithObject:data forKey:@"new message"];
        [self newMessageDataChanged:newDict];
    }else if ([eventName isEqualToString:@"login failed"]){
        //登录失败
        
    }else if ([eventName isEqualToString:@"enter chat"]){
        //用户进入房间
        NSDictionary *newDict = [NSDictionary dictionaryWithObject:data forKey:@"enter chat"];
        [self newMessageDataChanged:newDict];
        [self showVIPComeInAnimation:data];
    }else if ([eventName isEqualToString:@"send gift"]){
        //送礼物
        [self showGiftAnimation:data];
        [self receiveGiftWithDataArray:data];
        NSDictionary *newDict = [NSDictionary dictionaryWithObject:data forKey:@"send gift"];
        [self showHigherGiftAnimation:data];
        [self newMessageDataChanged:newDict];
    }else if ([eventName isEqualToString:@"send gift big"]){
        //送礼物
        [self showGiftAnimation:data];
        [self receiveGiftWithDataArray:data];
        NSDictionary *newDict = [NSDictionary dictionaryWithObject:data forKey:@"send gift"];
        UserSendGiftModel *userSendGiftModel = [[UserSendGiftModel alloc]initWithDictionary:[newDict objectForKey:@"send gift"] error:nil];
        if ([userSendGiftModel.roomid isEqualToString:_userTVInfoModel.room_id]) {
            [self showHigherGiftAnimation:data];
        }
        [self newMessageDataChanged:newDict];
    }else if ([eventName isEqualToString:@"send gift error"]){
        //送礼物出错 钱不够
        
    }else if ([eventName isEqualToString:@"onlinecount update"]){
        //更新在线用户
        _onlineUserNumLabel.text = [NSString stringWithFormat:@"%@",data[@"count"]];
    }else if ([eventName isEqualToString:@"user rich exp update"]){
        //更新用户财富
        NSString *userpoints = [NSString stringWithFormat:@"%@",[data objectForKey:@"userpoints"]];
        [[NSUserDefaults standardUserDefaults]setObject:userpoints forKey:@"gold"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    }else if ([eventName isEqualToString:@"online users"]){
        //在线观众
        NSDictionary *dict = data;
        NSArray *dataArray = [dict objectForKey:@"users"];
        NSString *startN = [NSString stringWithFormat:@"%@",[dict objectForKey:@"start"]];
        NSString *stopN = [NSString stringWithFormat:@"%@",[dict objectForKey:@"stop"]];
        if (dataArray.count<=0) {
            return;
        }
        if (startN.intValue == 0) {
            [self.userDataArray removeAllObjects];
            [self.userDataArray addObjectsFromArray:dataArray];
            [self refreshUserTableView];
        }else if (startN.intValue>0 && stopN.intValue>=self.userDataArray.count-1){
            if (startN.intValue > self.userDataArray.count-1) {
                [self.userDataArray addObjectsFromArray:dataArray];
            }else{
                for (int i=startN.intValue;i < self.userDataArray.count-1; i++) {
                    [self.userDataArray removeObjectAtIndex:i];
                }
                [self.userDataArray addObjectsFromArray:dataArray];
            }
        }else if (startN.intValue >0 && stopN.intValue<self.userDataArray.count-1){
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            for (int i=startN.intValue;i < stopN.intValue-1; i++) {
                if (self.userDataArray.count < i) {
                    [self.userDataArray removeObjectAtIndex:i];
                }
                if (i-startN.intValue<dataArray.count) {
                    [self.userDataArray insertObject:[dataArray objectAtIndex:(i-startN.intValue)] atIndex:i];
                    NSUInteger section = 0;
                    NSUInteger row = i;
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
                    [indexPaths addObject:indexPath];
                }
            }
            if (self.userDataArray.count>10) {
                [refreshTimer invalidate];
                refreshTimer = nil;
                refreshTimer = [NSTimer timerWithTimeInterval:15 target:self selector:@selector(refreshOnlineUsers) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:refreshTimer forMode:NSRunLoopCommonModes];
            }
            [self actionReloadEasyTableViewRowsAtIndexPaths:indexPaths];
        }
    }else if ([eventName isEqualToString:@"error message"]){
        // 错误信息提示
        NSDictionary *dict = data;
        NSString *errormsg=[[dict objectForKey:@"msg"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (![NSString isBlankString:errormsg]) {
            NSMutableDictionary *dict1=[NSMutableDictionary dictionary];
            [dict1 setObject:errormsg forKey:@"error message"];
            [self newMessageDataChanged:dict1];
        }
    }else if ([eventName isEqualToString:@"ban message failed"]){
        // 禁言失败
        [MPNotificationView notifyWithText:@""
                                    detail:@"禁言失败"
                             andTouchBlock:^(MPNotificationView *notificationView) {
                                 NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                             }];
    }else if ([eventName isEqualToString:@"ban message success"]){
        //禁言成功
        [MPNotificationView notifyWithText:@""
                                    detail:@"禁言成功"
                             andTouchBlock:^(MPNotificationView *notificationView) {
                                 NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                             }];
    }else if ([eventName isEqualToString:@"ban message"]){
        //禁言广播消息
        NSDictionary *dict = data;
        NSString *user_name=[[dict objectForKey:@"user_name"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *manager=[[dict objectForKey:@"manager"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *msg = [NSString stringWithFormat:@"%@ 被管理员：%@禁言",user_name,manager];
        if (![NSString isBlankString:msg]) {
            NSMutableDictionary *dict1=[NSMutableDictionary dictionary];
            [dict1 setObject:msg forKey:@"error message"];
            [self newMessageDataChanged:dict1];
        }
    }else if ([eventName isEqualToString:@"set manager level failed"]){
        [MPNotificationView notifyWithText:@""
                                    detail:@"设置管理失败"
                             andTouchBlock:^(MPNotificationView *notificationView) {
                                 NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                             }];
    }else if ([eventName isEqualToString:@"set manager level success"]){
        [MPNotificationView notifyWithText:@""
                                    detail:@"设为管理成功"
                             andTouchBlock:^(MPNotificationView *notificationView) {
                                 NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                             }];
    }else if ([eventName isEqualToString:@"set normal level failed"]){
        [MPNotificationView notifyWithText:@""
                                    detail:@"取消管理失败"
                             andTouchBlock:^(MPNotificationView *notificationView) {
                                 NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                             }];
    }else if ([eventName isEqualToString:@"set normal level success"]){
        [MPNotificationView notifyWithText:@""
                                    detail:@"取消管理成功"
                             andTouchBlock:^(MPNotificationView *notificationView) {
                                 NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                             }];
    }else if ([eventName isEqualToString:@"set manager level"]){
        //设置管理广播消息
        NSDictionary *dict = data;
        NSString *user_name=[[dict objectForKey:@"user_name"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *manager=[[dict objectForKey:@"manager"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *msg = [NSString stringWithFormat:@"%@ 被：%@设为管理员身份",user_name,manager];
        if (![NSString isBlankString:msg]) {
            NSMutableDictionary *dict1=[NSMutableDictionary dictionary];
            [dict1 setObject:msg forKey:@"error message"];
            [self newMessageDataChanged:dict1];
        }
    }else if ([eventName isEqualToString:@"set normal level"]){
        //取消管理广播消息
        NSDictionary *dict = data;
        NSString *user_name=[[dict objectForKey:@"user_name"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *manager=[[dict objectForKey:@"manager"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *msg = [NSString stringWithFormat:@"%@ 被：%@取消管理员身份",user_name,manager];
        if (![NSString isBlankString:msg]) {
            NSMutableDictionary *dict1=[NSMutableDictionary dictionary];
            [dict1 setObject:msg forKey:@"error message"];
            [self newMessageDataChanged:dict1];
        }
    }else if ([eventName isEqualToString:@"bubble"]){
        //点亮心
        NSString *imageId = [NSString stringWithFormat:@"%@",[data objectForKey:@"color"]];
        [self showTheLoveWithImageId:imageId];
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setObject:data forKey:@"bubble"];
        [self newMessageDataChanged:dict];
    }else if ([eventName isEqualToString:@"bobi message"]){
        //弹幕
        NSDictionary *newDict = [NSDictionary dictionaryWithObject:data forKey:@"new message"];
        [self newMessageDataChanged:newDict];
        [self manualSendBarrageWithArray:data];
    }else if ([eventName isEqualToString:@"user credit update"]){
        //刷新主播球票
        NSString *str = [data objectForKey:@"credit"];
        [self setCreditButtonWithNumString:str];
    }

}

- (void) socketIO:(SocketIO *)socket didReceiveStream:(SocketIOInputStream *)stream
{
}

- (void) stream:(SocketIOInputStream*)stream didReceiveData:(NSData*)data
{
}

- (void) streamDidFinish:(SocketIOInputStream*)stream
{
}

- (void) stream:(SocketIOOutputStream*)stream askData:(NSUInteger)length
{
}

- (void) socketIODidConnect:(SocketIO *)socket
{
    if(![socket nsp])
    {
        NSLog(@"CONNECTED ON ROOT NSP");
    }
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:User_Token,@"username",_userModel.room_id,@"roomid",@"0",@"clienttype",@"1",@"isroomer", nil];
    [socket sendEvent:@"login" data:dict];
}

- (void) socketIO:(SocketIO *)socket didReceiveError:(NSString *)error
{
    NSAssert([error isEqualToString:@"unauthorized"], @"Auth");
    [socket connect];
}


#pragma mark --------------------- socketEnd-------------------------------------
#pragma mark 用户财务信息请求
//用户财务信息请求
- (void)sendUserFianceRequest
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [AFRequestManager SafeGET:URI_UserFinance parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        NSLog(@"%@",result);
        if ([result[@"status"] intValue] == 200) {
            [[NSUserDefaults standardUserDefaults]setObject:result[@"data"][@"gold"] forKey:@"gold"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

#pragma mark Delegates==================================================
#pragma mark LiveChooseVCDelegate

- (void)LiveChooseVCDelegateCloseButtonClick
{
    self.liveView.backgroundColor = [UIColor whiteColor];
    [self.session setRunning:NO];
    [self.session stopLive];
    [chatTimer setFireDate:[NSDate distantFuture]];
    [chatTimer invalidate];
    chatTimer = nil;
    [refreshTimer setFireDate:[NSDate distantFuture]];
    [refreshTimer invalidate];
    refreshTimer = nil;
//    [chatScrollTimer invalidate];
//    chatScrollTimer = nil;
    [self.socketPrivate disconnect];
    self.socketPrivate = nil;
    [_liveChooseVC.view removeFromSuperview];
    _liveChooseVC = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)LiveChooseVCDelegateStartButtonClick
{
    if (![self getAVAudioSessionPermissions]) {
        return;
    };
    if (![self getAVCaptureDevicePermissions]) {
        return;
    }
    if (CountdownBOOL) {
        LiveCountDownView *liveCountDownView=[LiveCountDownView viewFromXIB];
        [liveCountDownView showInSuperView:self.view];
        self.titleStr = _liveChooseVC.titleString;
        _liveChooseVC.view.hidden = YES;
        CountdownBOOL = NO;
        [self sendRoomStartRequest];
    }
}



#pragma mark buttonactions==================================================
//弹幕按钮事件
- (IBAction)barrageButtonClick:(id)sender {
    if (!DanmuMessageBOOL) {
        _danmuLabel.textColor = [UIColor colorWithHexString:GiftUsualColor];
        _danmuBGView.backgroundColor = [UIColor colorWithHexString:GiftUsualColor];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        _danmuLabel.left = _danmuBGView.width-1-_danmuLabel.width;
        [UIView commitAnimations];
        DanmuMessageBOOL = !DanmuMessageBOOL;
        _chatTextField.placeholder = @"开启大喇叭,10钻石/条";
    }else{
        _danmuLabel.textColor = [UIColor lightGrayColor];
        _danmuBGView.backgroundColor = [UIColor lightGrayColor];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.2];
        _danmuLabel.left = 1;
        [UIView commitAnimations];
        DanmuMessageBOOL = !DanmuMessageBOOL;
        _chatTextField.placeholder = @"和大家说点什么";
    }
}
//弹幕播放
- (void)manualSendBarrageWithArray:(NSDictionary*)dataArray
{
    @autoreleasepool {
        NSDictionary *dict = dataArray;
        NSString *chatStr = [[dict objectForKey:@"msg"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *nameStr = [[dict objectForKey:@"fromUser"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        DansView *view = [DansView viewFromXIB];
        view.title = chatStr;
        view.name = nameStr;
        // 服务器暂时未定义
        view.url = [dict objectForKey:@"user_head_img"];
        //[self.view addSubview:view];
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        CGFloat yy = appDelegate.window.frame.size.height/2;
        CGFloat height = [self getRandomNumber:50 to:yy+80];
        view.origin = CGPointMake(self.view.width, height);
        // 服务器暂时未定义
        [self.view addSubview:view];
        [UIView animateWithDuration:5 animations:^{
            view.origin = CGPointMake(-view.width, height);
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
        }];
        //[view star];
    }
}
// 随机纵坐标
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}
//发送消息按钮
- (IBAction)sendMessageButtonClick:(id)sender {
    NSString *chatStr = [NSString stringWithFormat:@"%@",_chatTextField.text];
    
    if (![NSString isBlankString:chatStr]) {
        if ([NSString isBlankString:chatStr]) {
            return;
        }
        NSString *filename = [[NSBundle mainBundle]pathForResource:@"dirtywords" ofType:@"plist"];
        NSArray *dirtywordsArray = [[NSArray alloc]initWithContentsOfFile:filename];
        for (int i=0; i<dirtywordsArray.count; i++) {
            NSString *dirtywordStr = [dirtywordsArray objectAtIndex:i];
            if ([chatStr rangeOfString:dirtywordStr].location !=NSNotFound) {
                NSInteger length = [[dirtywordsArray objectAtIndex:i] length];
                NSString *lengthStr = @"";
                for (int j=0; j<length; j++) {
                    lengthStr = [NSString stringWithFormat:@"%@*",lengthStr];
                }
                chatStr = [chatStr stringByReplacingOccurrencesOfString:[dirtywordsArray objectAtIndex:i] withString:lengthStr];
            }
        }
        
        if (!DanmuMessageBOOL) {
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:chatStr,@"msg", nil];
            [self.socketPrivate sendEvent:@"new message" data:dict];
        } else {
            NSString *goldStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"gold"];
            if (goldStr.intValue < 10) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"余额不足" message:@"当前余额不足，请充值后发送大喇叭消息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                return;
            }else{
                NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:chatStr,@"msg", nil];
                [self.socketPrivate sendEvent:@"bobi message" data:dict];
            }
        }
    }
    _chatTextField.text = @"";
//    [self endEditing];
}
//textfiledDelegate 发送消息
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *chatStr = [NSString stringWithFormat:@"%@",_chatTextField.text];
    
    if (![NSString isBlankString:chatStr]) {
        if ([NSString isBlankString:chatStr]) {
            return YES;
        }
        NSString *filename = [[NSBundle mainBundle]pathForResource:@"dirtywords" ofType:@"plist"];
        NSArray *dirtywordsArray = [[NSArray alloc]initWithContentsOfFile:filename];
        for (int i=0; i<dirtywordsArray.count; i++) {
            NSString *dirtywordStr = [dirtywordsArray objectAtIndex:i];
            if ([chatStr rangeOfString:dirtywordStr].location !=NSNotFound) {
                NSInteger length = [[dirtywordsArray objectAtIndex:i] length];
                NSString *lengthStr = @"";
                for (int j=0; j<length; j++) {
                    lengthStr = [NSString stringWithFormat:@"%@*",lengthStr];
                }
                chatStr = [chatStr stringByReplacingOccurrencesOfString:[dirtywordsArray objectAtIndex:i] withString:lengthStr];
            }
        }
        
        if (!DanmuMessageBOOL) {
            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:chatStr,@"msg", nil];
            [self.socketPrivate sendEvent:@"new message" data:dict];
        } else {
            NSString *goldStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"gold"];
            if (goldStr.intValue < 10) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"余额不足" message:@"当前余额不足，请充值后发送大喇叭消息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alertView show];
                return YES;
            }else{
                NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:chatStr,@"msg", nil];
                [self.socketPrivate sendEvent:@"bobi message" data:dict];
            }
        }
    }
    _chatTextField.text = @"";
    //    [self endEditing];
    return YES;
}
//左上角个人信息按钮点击
- (IBAction)hostInfoButtonClick:(id)sender {
    [self sendRequestOfGetInfoByAesId:_userModel.pid];
}
//贡献榜点击
- (IBAction)creditsButtonClickAction:(id)sender {
    creditVC = [[CreditListVC alloc]init];
    creditVC.CreditListVCDelegateResponseBool = YES;
    creditVC.aesIdStr = _userModel.pid;
    creditVC.view.frame = CGRectMake(SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    creditVC.delegate = self;
    [self addChildViewController:creditVC];
    [self.view addSubview:creditVC.view];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    creditVC.view.left = 0;
    [UIView commitAnimations];
}
- (void)didClickHiddenCreditListVCAction
{
    [UIView animateWithDuration:0.5 animations:^{
        creditVC.view.left = SCREEN_WIDTH;
    } completion:^(BOOL finished) {
        [creditVC.view removeFromSuperview];
        [creditVC removeFromParentViewController];
    }];
}
#pragma mark bottomtoolBarAction
//bottomtoolBaraction
- (IBAction)chatButtonClick:(id)sender {
    [_chatTextField becomeFirstResponder];
    _bottomToolBar.hidden = YES;
}
- (IBAction)closeButtonClick:(id)sender {
    UIAlertView *alv=[[UIAlertView alloc]initWithTitle:nil message:@"你确定要退出直播吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alv.tag = StopLiveAlertTag;
    [alv show];
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == StopLiveAlertTag) {
        if (buttonIndex==1) {
            [self sendRoomStopRequest];
        }
    }else if (alertView.tag == ReportAlertTag){
        if (buttonIndex == 1) {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setObject:User_Token forKey:@"token"];
            [params setObject:manUserUid forKey:@"pid"];
            [params setObject:manUserNick forKey:@"nick"];
            [AFRequestManager SafeGET:URI_IssueReport parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                NSDictionary *result = responseObject;
                NSLog(@"%@",result);
                if ([result[@"status"] intValue] == 200) {
                    [MPNotificationView notifyWithText:@""
                                                detail:@"举报成功"
                                         andTouchBlock:^(MPNotificationView *notificationView) {
                                             NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                                         }];
                    [self closePersonInfoViewButtonAction];
                }else{
                    [MPNotificationView notifyWithText:@""
                                                detail:@"举报失败"
                                         andTouchBlock:^(MPNotificationView *notificationView) {
                                             NSLog( @"Received touch for notification with text: %@", notificationView.textLabel.text );
                                         }];
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
    }else if (alertView.tag == ShutupAlertTag){
        //禁言
        if (buttonIndex == 1) {
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:manUserNick,@"user_name",manUserUid,@"uid", nil];
            [self.socketPrivate sendEvent:@"ban message" data:dict];
            [self closePersonInfoViewButtonAction];
        }
    }
    
}
- (IBAction)flashButtonClick:(id)sender {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    _flashButton.selected = NO;
    if (captureDeviceClass != nil) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDevicePosition devicePositon = self.session.captureDevicePosition;
        if ([device hasTorch] && [device hasFlash]){
            [device lockForConfiguration:nil];
            if (devicePositon == AVCaptureDevicePositionBack) {
                if (device.flashMode == AVCaptureFlashModeOn) {
                    [device setTorchMode:AVCaptureTorchModeOff];
                    [device setFlashMode:AVCaptureFlashModeOff];
                }else{
                    [device setTorchMode:AVCaptureTorchModeOn];
                    [device setFlashMode:AVCaptureFlashModeOn];
                    _flashButton.selected = YES;
                }
            }
            [device unlockForConfiguration];
        }
    }

}
- (IBAction)camerButtonClick:(id)sender {
    AVCaptureDevicePosition devicePositon = self.session.captureDevicePosition;
    self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
}
- (IBAction)beautyButtonClick:(id)sender {
    _beautyButton.selected = !_beautyButton.selected;
    self.session.beautyFace = !self.session.beautyFace;
}

#pragma mark  tableView===scrollviewdelegate---------------------------------------
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tableView && self.dataArray.count>5) {
        if (fabs(scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y) > 20.f){
            //            滑到底部加载更多
//            if ([[chatTimer fireDate] earlierDate:[NSDate date]]) {
//                [chatTimer setFireDate:[NSDate distantFuture]];
//            }
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView == _tableView && self.dataArray.count>5) {
//        if (fabs(scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y) > 20.f){
            //滑到底部加载更多
//            [chatScrollTimer invalidate];
//            chatScrollTimer = nil;
//            chatScrollTimer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(chatTableViewScrollToPositionBottom) userInfo:nil repeats:NO];
//            [[NSRunLoop currentRunLoop] addTimer:chatScrollTimer forMode:NSRunLoopCommonModes];
//        }
    }
}

//- (void)chatTableViewScrollToPositionBottom
//{
//    if(self.dataArray.count>4){
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
//        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
//    }
////    [chatScrollTimer invalidate];
////    chatScrollTimer = nil;
////    if ([[chatTimer fireDate] laterDate:[NSDate date]]) {
////        [chatTimer setFireDate:[NSDate distantPast]];
////    }
//}

-(void)scrollViewDidEndDragging:(UIScrollView*)scrollView willDecelerate:(BOOL)decelerate
{
    stopTimer = 5;
}


#pragma mark  tableView代理方法---------------------------------------
#pragma mark tableView代理方法
-(void)newMessageDataChanged:(NSDictionary*)dict{
    if (self.dataArray.count>100) {
        [self.dataArray removeObjectAtIndex:0];
        [self.dataArray addObject:dict];
    }else{
        [self.dataArray addObject:dict];
    }
    [_tableView reloadData];
}

static int stopTimer = 0;

- (void)chatTableViewReloadData
{
    NSLog(@"============================================");
    if (stopTimer != 0) {
        stopTimer --;
        return;
    }
    dispatch_sync(dispatch_get_main_queue(), ^{
        if(self.dataArray.count>4){
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0];
            [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
    if ([dict objectForKey:@"new message"]) {
        SocketMessageModel *smModel = [[SocketMessageModel alloc]initWithDictionary:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"new message"] error:nil];
        PhoneLiveCellTool *phoneTool=[[PhoneLiveCellTool alloc]init];
        CGFloat cellHeight=[phoneTool cellSizeWithModel:smModel maxWidth:_tableView.width-20 minHeight:100 font:cellFont].height;
        phoneTool=nil;
        return cellHeight;
    }
    if([dict objectForKey:@"send gift"]){
        UserSendGiftModel *userSendGiftModel = [[UserSendGiftModel alloc]initWithDictionary:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"send gift"] error:nil];
        GiftOneModel *giftOneModel = [self setUserSendGiftModelGiftNameAndGiftPicWith:userSendGiftModel];
        PhoneLiveCellTool *phoneTool=[[PhoneLiveCellTool alloc]init];
        phoneTool.giftPicBaseUrlStr = _giftListModel.path;
        CGFloat cellHeight = [phoneTool cellSizeWithGiftModel:userSendGiftModel giftOneModel:giftOneModel maxWidth:tableView.width-20 minHeight:100 font:cellFont isAnchorBool:NO].height;
        phoneTool=nil;
        return cellHeight;
    }
    if([dict objectForKey:@"enter chat"]){
        UserWelcomeModel *model=[[UserWelcomeModel alloc]initWithDictionary:[[self.dataArray objectAtIndex:indexPath.row] objectForKey:@"enter chat"] error:nil];
        PhoneLiveCellTool *phoneTool=[[PhoneLiveCellTool alloc]init];
        CGFloat cellHeight=[phoneTool cellSizeWithWelcomeModel:model maxWidth:tableView.width-20 minHeight:100 font:cellFont].height;
        phoneTool=nil;
        return cellHeight;
    }
    if([dict objectForKey:@"login success"]){
        PhoneLiveCellTool *phoneTool=[[PhoneLiveCellTool alloc]init];
        CGFloat cellHeight=[phoneTool cellSizeWithMsg:[KAPP_DELEGATE roomWarningString] maxWidth:tableView.width-20 minHeight:100 font:cellFont].height;
        phoneTool=nil;
        return cellHeight;
    }
    if([dict objectForKey:@"error message"]){
        PhoneLiveCellTool *phoneTool=[[PhoneLiveCellTool alloc]init];
        CGFloat cellHeight=[phoneTool cellSizeWithMsg:[dict objectForKey:@"error message"] maxWidth:tableView.width-20 minHeight:100 font:cellFont].height;
        phoneTool=nil;
        return cellHeight;
    }
    if([dict objectForKey:@"bubble"]){
        PhoneLiveCellTool *phoneTool=[[PhoneLiveCellTool alloc]init];
        CGFloat cellHeight=[phoneTool cellSizeWithBubbleDict:[dict objectForKey:@"bubble"] maxWidth:tableView.width-20 minHeight:100 font:cellFont].height;
        phoneTool=nil;
        return cellHeight;
    }
    return 30;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataArray.count;
}
- (PhoneLiveCell *)loadPhoneLiveCellWithTableView:(UITableView *)tableView{
    static NSString *ident = @"PhoneLiveCell";
    PhoneLiveCell *cell=[tableView dequeueReusableCellWithIdentifier:ident];
    if (!cell) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:ident owner:self options:nil];
        cell = (PhoneLiveCell*)objects[0];
    }
    cell.delegate=self;
    cell.font=cellFont;
    cell.width = tableView.width;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @autoreleasepool {
        NSDictionary *dict = (NSDictionary*)[self.dataArray objectAtIndex:indexPath.row];
        if ([dict objectForKey:@"new message"]) {
            SocketMessageModel *smModel = [[SocketMessageModel alloc]initWithDictionary:[dict objectForKey:@"new message"] error:nil];
            PhoneLiveCell *cell=[self loadPhoneLiveCellWithTableView:tableView];
            cell.socketMessageModel=smModel;
            cell.uid=smModel.uid;
            return cell;
        }
        if ([dict objectForKey:@"send gift"]) {
            PhoneLiveCell *cell=[self loadPhoneLiveCellWithTableView:tableView];
            cell.isAnchorBool = NO;
            UserSendGiftModel *userSendGiftModel = [[UserSendGiftModel alloc]initWithDictionary:[dict objectForKey:@"send gift"] error:nil];
            
            GiftOneModel *giftOneModel = [self setUserSendGiftModelGiftNameAndGiftPicWith:userSendGiftModel];
            cell.uid=userSendGiftModel.uid;
            cell.giftPicBaseUrlStr = _giftListModel.path;
            [cell setDataWithUserSendGiftModel:userSendGiftModel withGiftOneModel:giftOneModel];
            return cell;
        }
        if ([dict objectForKey:@"enter chat"]) {
            PhoneLiveCell *cell=[self loadPhoneLiveCellWithTableView:tableView];
            UserWelcomeModel *model=[[UserWelcomeModel alloc]initWithDictionary:[dict objectForKey:@"enter chat"] error:nil];
            cell.userWelcomeModel=model;
            cell.uid=model.uid;
            return cell;
        }
        
        if ([dict objectForKey:@"login success"]) {
            PhoneLiveCell *cell=[self loadPhoneLiveCellWithTableView:tableView];
            cell.msgColor=[UIColor orangeColor];
            cell.msgStr=[KAPP_DELEGATE roomWarningString];
            cell.uid=@"";
            return cell;
        }
        
        if ([dict objectForKey:@"error message"]) {
            PhoneLiveCell *cell=[self loadPhoneLiveCellWithTableView:tableView];
            cell.msgColor=[UIColor orangeColor];
            cell.uid=@"";
            cell.msgStr=[dict objectForKey:@"error message"];
            return cell;
        }
        
        if ([dict objectForKey:@"bubble"]) {
            PhoneLiveCell *cell=[self loadPhoneLiveCellWithTableView:tableView];
            cell.uid=@"";
            [cell setBubbleDict:[dict objectForKey:@"bubble"]];
            return cell;
        }
        
        return [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
}
#pragma mark cellDelegate
- (void)showVisitorInfoOfChatUsualCell:(NSString *)uid
{
    [self endEditing];
    [self sendRequestOfGetInfoByAesId:uid];
}

#pragma mark requests---------------------------------------

- (void)sendGiftListRequest
{
    @WeakObj(self);
    [AFRequestManager SafeGET:URI_GiftList parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            _giftListModel = [[GiftListModel alloc]initWithDictionary:result[@"data"] error:nil];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark vip

- (void)showVIPComeInAnimation:(NSDictionary*)data
{
    UserWelcomeModel *welcomeModel = [[UserWelcomeModel alloc]initWithDictionary:data error:nil];
    if (![NSString isBlankString:welcomeModel.super_vip]){
        if (welcomeModel.super_vip.intValue <1) {
            return;
        }
    }else{
        return;
    }
    if (!_vipComeInAnimation) {
        _vipComeInAnimation = [[VIPComeInAnimation alloc]init];
        _vipComeInAnimation.superView=self.contentView;
        _vipComeInAnimation.position=CGPointMake(_tableView.left,  _tableView.top-30);
    }
    [_vipComeInAnimation.dataArray addObject:welcomeModel];
    [_vipComeInAnimation startVipComeInAnimation];
}
#pragma mark 收到礼物开启动画---------------------------------------
-(void)receiveGiftWithDataArray:(NSDictionary *)data{
    UserSendGiftModel *userSendGiftModel = [[UserSendGiftModel alloc]initWithDictionary:data error:nil];
    if (![userSendGiftModel.giftid isEqualToString:@"0"]) {
        GiftOneModel *giftOneModel = [self setUserSendGiftModelGiftNameAndGiftPicWith:userSendGiftModel];
        UIImage *image = [self getGiftUIImageWithGiftUrl:[NSString stringWithFormat:@"%@%@",_giftListModel.path,giftOneModel.gpic]];
        [self startAnimationWithImage:image giftcount:[userSendGiftModel.giftcount intValue]];
    }
}
-(void)startAnimationWithImage:(UIImage *)image giftcount:(int)giftcount{
    GiveGiftAnimation *animation=[GiveGiftAnimation shareAnimation];
    animation.view=self.view;
    animation.image=image;
    animation.number=giftcount;
    [animation start];
}
-(void)showGiftAnimation:(NSDictionary *)data{
    if (data) {
        UserSendGiftModel *userSendGiftModel=[[UserSendGiftModel alloc]initWithDictionary:data error:nil];
        if (![userSendGiftModel.giftid isEqualToString:@"0"]&&![NSString isBlankString:userSendGiftModel.fromUser]) {
            GiftOneModel *giftOneModel = [self setUserSendGiftModelGiftNameAndGiftPicWith:userSendGiftModel];
            UIImage *image = [self getGiftUIImageWithGiftUrl:[NSString stringWithFormat:@"%@%@",_giftListModel.path,giftOneModel.gpic]];
            userSendGiftModel.giftImage=image;
            userSendGiftModel.giftName=giftOneModel.gname;
            if (_reveiveGiftManager==nil) {
                _reveiveGiftManager=[[PhoneReceiveGiftManager alloc]init];
                _reveiveGiftManager.superView=self.contentView;
                _reveiveGiftManager.position=CGPointMake(_tableView.left,  _tableView.top-90);
            }
            [_reveiveGiftManager.dataArray addObject:userSendGiftModel];
            [_reveiveGiftManager startSendGiftAnimation];
        }
    }
}
///////////////////////////////////
-(GiftOneModel*)setUserSendGiftModelGiftNameAndGiftPicWith:(UserSendGiftModel*)userSendGiftModel
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@"" forKey:@"giftName"];
    [dict setObject:@"" forKey:@"giftPic"];
    for (int i=0; i<_giftListModel.list.count; i++) {
        NSDictionary *dict = [_giftListModel.list objectAtIndex:i];
        GiftOneModel *giftOneModel = [[GiftOneModel alloc]initWithDictionary:dict error:nil];
        if ([giftOneModel.gid isEqualToString:userSendGiftModel.giftid]) {
            return giftOneModel;
        }
    }
    return nil;
}

#pragma mark big礼物动画------------------------------------------------------
- (void)showHigherGiftAnimation:(NSDictionary *)dict{
    //五星一号木：giftid = 207; 顶级五星套杆giftid = 208;三星五号木：giftid = 214;四星三号木：giftid = 215;
    //纯金推杆：giftid = 216;S杆：giftid = 218;七号铁杆：giftid = 219;
    NSString *giftId = [dict objectForKey:@"giftid"];
    if ([giftId isEqualToString:@"207"] || [giftId isEqualToString:@"208"] || [giftId isEqualToString:@"214"] || [giftId isEqualToString:@"215"] || [giftId isEqualToString:@"216"] || [giftId isEqualToString:@"218"] || [giftId isEqualToString:@"219"] || [giftId isEqualToString:@"1006"] || [giftId isEqualToString:@"1007"] || [giftId isEqualToString:@"1008"] ) {
        if ([self.animationView isAnimating]) {
            [self.higherAnimationArray addObject:dict];
        }else{
            [self startHigherAnimation:dict];
        }
    }else{
        return;
    }
}
- (void)startHigherAnimation:(NSDictionary *)dict{
    //五星一号木：giftid = 207
    if ([[dict objectForKey:@"giftid"]isEqualToString:@"207"]) {
        [self.animationView playAnimation: @"wx1hm"
                               withRange : NSMakeRange(0, 29)
                          numberPadding  : 3
                                  ofType : @"png"
                                     fps : 15
                                  repeat : NO
                              completion : ^{
                              }];
        [self.animationView startAnimating];
    }
    //顶级五星套杆giftid = 208
    if ([[dict objectForKey:@"giftid"]isEqualToString:@"208"]) {
        [self.animationView playAnimation: @"wxtg_"
                               withRange : NSMakeRange(0, 51)
                          numberPadding  : 3
                                  ofType : @"png"
                                     fps : 15
                                  repeat : NO
                              completion : ^{
                              }];
        [self.animationView startAnimating];
    }
    //三星五号木：giftid = 214
    if ([[dict objectForKey:@"giftid"]isEqualToString:@"214"]) {
        [self.animationView playAnimation: @"wxtg"
                               withRange : NSMakeRange(0, 56)
                          numberPadding  : 3
                                  ofType : @"png"
                                     fps : 15
                                  repeat : NO
                              completion : ^{
                              }];
        [self.animationView startAnimating];
    }
    //四星三号木：giftid = 215;
    if ([[dict objectForKey:@"giftid"]isEqualToString:@"215"]) {
        [self.animationView playAnimation: @"sx3hm"
                               withRange : NSMakeRange(0, 50)
                          numberPadding  : 3
                                  ofType : @"png"
                                     fps : 15
                                  repeat : NO
                              completion : ^{
                              }];
        [self.animationView startAnimating];
    }
    //纯金推杆：giftid = 216
    if ([[dict objectForKey:@"giftid"]isEqualToString:@"216"]) {
        [self.animationView playAnimation: @"hjtg"
                               withRange : NSMakeRange(0, 44)
                          numberPadding  : 3
                                  ofType : @"png"
                                     fps : 15
                                  repeat : NO
                              completion : ^{
                              }];
        [self.animationView startAnimating];
    }
    //S杆：giftid = 218;
    if ([[dict objectForKey:@"giftid"]isEqualToString:@"218"]) {
        [self.animationView playAnimation: @"sjqg"
                               withRange : NSMakeRange(0, 49)
                          numberPadding  : 3
                                  ofType : @"png"
                                     fps : 15
                                  repeat : NO
                              completion : ^{
                              }];
        [self.animationView startAnimating];
    }
    //七号铁杆：giftid = 219;
    if ([[dict objectForKey:@"giftid"]isEqualToString:@"219"]) {
        [self.animationView playAnimation: @"qxtg"
                               withRange : NSMakeRange(0, 34)
                          numberPadding  : 3
                                  ofType : @"png"
                                     fps : 15
                                  repeat : NO
                              completion : ^{
                              }];
        [self.animationView startAnimating];
    }
    //玫瑰99
    if ([[dict objectForKey:@"giftid"]isEqualToString:@"1006"]) {
        [self.animationView playAnimation: @"mgjiujiu"
                               withRange : NSMakeRange(0, 19)
                          numberPadding  : 3
                                  ofType : @"png"
                                     fps : 10
                                  repeat : NO
                              completion : ^{
                              }];
        [self.animationView startAnimating];
    }
    //玫瑰999
    if ([[dict objectForKey:@"giftid"]isEqualToString:@"1007"]) {
        [self.animationView playAnimation: @"mgjiujiujiu"
                               withRange : NSMakeRange(0, 13)
                          numberPadding  : 3
                                  ofType : @"png"
                                     fps : 4
                                  repeat : NO
                              completion : ^{
                              }];
        [self.animationView startAnimating];
    }
    //炸弹
    if ([[dict objectForKey:@"giftid"]isEqualToString:@"1008"]) {
        [self.animationView playAnimation: @"boom"
                               withRange : NSMakeRange(0, 8)
                          numberPadding  : 3
                                  ofType : @"png"
                                     fps : 18
                                  repeat : NO
                              completion : ^{
                              }];
        [self.animationView startAnimating];
    }
}
#pragma mark MBAnimationViewDelegate
-(void)animationViewIsFinished{
    if (self.higherAnimationArray.count>0) {
        [self startHigherAnimation:[self.higherAnimationArray firstObject]];
        [self.higherAnimationArray removeObjectAtIndex:0];
    }else{
        [_animationView removeFromSuperview];
        _animationView=nil;
    }
}


#pragma mark 点亮心动画------------------------------------------------------
-(void)showTheLoveWithImageId:(NSString*)imageId{
    float heartSize = 30;
    DMHeartFlyView* heart = [[DMHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, heartSize, heartSize) imageID:imageId];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(self.view.frame.size.width - heartSize/2.0 - 20, self.view.bounds.size.height - heartSize/2.0 - 10);
    heart.center = fountainSource;
    [heart animateInView:self.view];
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
        if ([result[@"status"] intValue] == 200) {
            
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
        if ([result[@"status"] intValue] == 200) {
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

//查询关注状态
- (void)sendAttentionStatusRequestWithRoomUid:(NSString *)room_uid hostBool:(BOOL)hostBool
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [params setObject:room_uid forKey:@"room_uid"];
    [AFRequestManager SafeGET:URI_IsAttention parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            NSString *isAttention = result[@"data"][@"isAttention"];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}

#pragma mark  获取个人信息与其相关--------------------------------------------
- (PersonInfoView *)personInfoView
{
    if (!_personInfoView) {
        _personInfoView = [PersonInfoView viewFromXIB];
        _personInfoView.width = self.view.width;
        _personInfoView.height = self.view.height;
        _personInfoView.delegate = self;
        _personInfoView.origin = CGPointMake(0, SCREEN_HEIGHT);
        [self.view addSubview:_personInfoView];
    }
    return _personInfoView;
}
- (WeskitInfoView *)weskitInfoView
{
    if (!_weskitInfoView) {
        _weskitInfoView = [WeskitInfoView viewFromXIB];
        _weskitInfoView.width = self.view.width;
        _weskitInfoView.height = self.view.height;
        _weskitInfoView.delegate = self;
        _weskitInfoView.origin = CGPointMake(0, SCREEN_HEIGHT);
        [self.view addSubview:_weskitInfoView];
    }
    return _weskitInfoView;
}

- (void)sendRequestOfGetInfoByAesId:(NSString*)aesId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:aesId forKey:@"aesId"];
    [params setObject:User_Token forKey:@"token"];
    [params setObject:self.userTVInfoModel.room_id forKey:@"roomid"];
    [AFRequestManager SafeGET:URI_GetInfoByAesId parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            PersonInfoModel *personInfoModel = [[PersonInfoModel alloc]initWithDictionary:result[@"data"] error:nil];
            if (personInfoModel.isVest.intValue==0 || [personInfoModel.pid isEqualToString:_userModel.pid]) {
                if (manager_level>personInfoModel.manageLv.integerValue) {
                    [self.personInfoView.leftTopButton setTitle:@"管理" forState:UIControlStateNormal];
                }else{
                    [self.personInfoView.leftTopButton setTitle:@"举报" forState:UIControlStateNormal];
                }
                [self.personInfoView setPersonInfoViewUIwithPersonInfoModel:personInfoModel];
                [self showPerInfoViewAnimations];
            }else{
                if (manager_level>personInfoModel.manageLv.integerValue) {
                    [self.weskitInfoView.manButton setTitle:@"管理" forState:UIControlStateNormal];
                }else{
                    [self.weskitInfoView.manButton setTitle:@"举报" forState:UIControlStateNormal];
                }
                [self.weskitInfoView setWeskitInfoViewWithModel:personInfoModel];
                [self showWeskitInfoViewAnimations];
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}

- (void)showPerInfoViewAnimations
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.personInfoView.origin = CGPointMake(0, 0);
    [UIView commitAnimations];
}
- (void)showWeskitInfoViewAnimations
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.weskitInfoView.origin = CGPointMake(0, 0);
    [UIView commitAnimations];
}
//马甲信息代理
- (void)closeWeskitInfoViewButtonAction
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.weskitInfoView.origin = CGPointMake(0, SCREEN_HEIGHT);
    [UIView commitAnimations];
}
- (void)WeskitInfoViewManButtonAction:(PersonInfoModel *)personInfoModel
{
    manUserUid = personInfoModel.pid;
    manUserNick = personInfoModel.nick;
    UIActionSheet *sheet=nil;
    if (manager_level > personInfoModel.manageLv.integerValue) {
        sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"举报",@"禁言", nil];
        sheet.tag=MJShutupAlertTag;
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定举报" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = ReportAlertTag;
        [alertView show];
    }
    [sheet showInView:self.view];
}
#pragma mark  代理
- (void)closePersonInfoViewButtonAction
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    self.personInfoView.origin = CGPointMake(0, SCREEN_HEIGHT);
    [UIView commitAnimations];
}
- (void)personInfoViewAttButtonAction:(PersonInfoModel*)personInfoModel
{
    //添加关注
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [params setObject:personInfoModel.u_id forKey:@"room_uid"];
    [AFRequestManager SafeGET:URI_AddAttention parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        if ([result[@"status"] intValue] == 200) {
            [self.personInfoView.attButton setTitle:@"已关注" forState:UIControlStateNormal];
            [self.personInfoView.attButton setEnabled:NO];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
}
- (void)personInfoViewLeftTopButtonManageAction:(PersonInfoModel *)personInfoModel
{
    manUserUid = personInfoModel.pid;
    manUserNick = personInfoModel.nick;
    UIActionSheet *sheet=nil;
    if (manager_level == 4) {
        if (personInfoModel.manageLv.intValue>0 &&personInfoModel.manageLv.intValue<4) {
            sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"取消管理",@"管理员列表",@"禁言", nil];
            sheet.tag = personInfoModel.manageLv.intValue;
        }else{
            sheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"设为管理",@"管理员列表",@"禁言", nil];
        }
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定举报" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = ReportAlertTag;
        [alertView show];
    }
    [sheet showInView:self.view];
}
- (void)personInfoViewInboxButtonAction:(PersonInfoModel *)personInfoModel
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.personInfoView.origin = CGPointMake(0, SCREEN_HEIGHT);
    [UIView commitAnimations];
    
    chatVC=[[ChatPrivateVC alloc]init];
    chatVC.SmallTypeBool = YES;
    NSMutableDictionary *dict=[NSMutableDictionary dictionary];
    [dict setObject:personInfoModel.u_id forKey:@"uid"];
    [dict setObject:personInfoModel.headportrait forKey:@"user_head_img"];
    [dict setObject:personInfoModel.nick forKey:@"user_name"];
    [dict setObject:personInfoModel.level forKey:@"user_rich_level"];
    [dict setObject:personInfoModel.gender forKey:@"user_sex"];
    MessListModel *model=[[MessListModel alloc]initWithDictionary:dict error:nil];
    chatVC.chatListModel=model;
    chatVC.view.frame = CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, SCREEN_HEIGHT/2);
    [self addChildViewController:chatVC];
    [self.contentView addSubview:chatVC.view];
}
- (void)personInfoViewSelfButtonAction:(PersonInfoModel *)personInfoModel
{
    NSLog(@"您的资料卡");
}


#pragma mark UIActionSheetDelegate
- (void)willPresentActionSheet:(UIActionSheet *)actionSheet {
    for (UIView *subViwe in actionSheet.subviews) {
        if ([subViwe isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subViwe;
            if ([button.titleLabel.text isEqualToString:@"禁言"]) {
                [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        if (actionSheet.tag>0 &&actionSheet.tag<4) {
            //取消管理
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:manUserNick,@"user_name",manUserUid,@"uid", nil];
            [self.socketPrivate sendEvent:@"set normal level" data:dict];
            [self closePersonInfoViewButtonAction];
        }else{
            //设置管理
            NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:manUserNick,@"user_name",manUserUid,@"uid",@"1",@"level", nil];
            [self.socketPrivate sendEvent:@"set manager level" data:dict];
            [self closePersonInfoViewButtonAction];
        }
    }else if (buttonIndex == 1){
        if (actionSheet.tag != MJShutupAlertTag) {
            //管理员列表
            [self.view bringSubviewToFront:_adminVC.view];
            _adminVC.view.hidden = NO;
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要将此人禁言？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = ShutupAlertTag;
            [alertView show];
        }
    }else if (buttonIndex == 2){
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"确定要将此人禁言？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.tag = ShutupAlertTag;
        [alertView show];
    }
}
#pragma mark AdminVCDelegate
- (void)didClickDeleteAdminWithAdminModel:(AdminModel *)adminModel
{
    //取消管理
    NSDictionary *dict=[NSDictionary dictionaryWithObjectsAndKeys:adminModel.nick,@"user_name",adminModel.pid,@"uid", nil];
    [self.socketPrivate sendEvent:@"set normal level" data:dict];
    [_adminVC sendURI_FansRequest];
}
#pragma mark 在线观众-------------------------------------------------------
- (void)setCreditButtonWithNumString:(NSString *)numStr
{
    NSString *string = [NSString stringWithFormat:@"%@",numStr];
    if (string.intValue>0 && ![NSString isBlankString:string]) {
        _creditsButton.hidden = NO;
    }else{
        _creditsButton.hidden = YES;
    }
    NSString *str = [NSString stringWithFormat:@"球票:%@ >",string];
    [_creditsButton setTitle:str forState:UIControlStateNormal];
    CGSize size = [str sizeWithFont:[UIFont systemFontOfSize:12] constrainedToSize:CGSizeMake(MAXFLOAT, 20) lineBreakMode:NSLineBreakByWordWrapping];
    _creditsButton.left = 10;
    _creditsButton.width = size.width+8;
}
#pragma mark  在线观众
#pragma mark  horizontalTableViewViewDelegate
// These delegate methods support both example views - first delegate method creates the necessary views
- (UITableViewCell *)easyTableView:(EasyTableView *)easyTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"EasyTableViewCell";
    
    UITableViewCell *cell = [easyTableView.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        // Create a new table view cell
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    [cell.contentView removeAllSubviews];
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(2, 1, 32, 32)];
    bgView.backgroundColor = [UIColor darkGrayColor];
    bgView.layer.cornerRadius = 32/2;
    bgView.layer.masksToBounds = YES;
    [cell.contentView addSubview:bgView];

    WebImageView *imageV= [[WebImageView alloc]initWithFrame:CGRectMake(1, 1, 30, 30)];
    imageV.layer.cornerRadius = 30/2;
    imageV.layer.masksToBounds = YES;//设为NO去试试
    [bgView addSubview:imageV];
    
    NSString *strUrl = [[self.userDataArray objectAtIndex:indexPath.row]objectForKey:@"user_head_img"];
    if (![NSString isBlankString:strUrl]) {
        strUrl = [NSString stringWithFormat:@"%@%@",URI_BASE_SERVER,strUrl];
        [imageV setImageWithURL:[NSURL URLWithString:strUrl] placeholderImage:[UIImage imageNamed:@"userHead.png"]];
    }else{
        [imageV setImage:[UIImage imageNamed:@"userHead.png"]];
    }
    NSString *vip_icon = [NSString stringWithFormat:@"%@",[[self.userDataArray objectAtIndex:indexPath.row]objectForKey:@"super_vip"]];
    if (vip_icon.intValue) {
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(32-10, 32-10, 10, 10)];
        imageV.image = [UIImage imageNamed:@"vip_icon"];
        [bgView addSubview:imageV];
    }
    
    return cell;
}

- (void)easyTableView:(EasyTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [UIView beginAnimations:nil context:NULL];
//    [UIView setAnimationDuration:0.5];
//    self.personInfoView.origin = CGPointMake(0, 0);
//    [UIView commitAnimations];
    NSString *uid = [[self.userDataArray objectAtIndex:indexPath.row]objectForKey:@"uid"];
    [self sendRequestOfGetInfoByAesId:uid];
}

- (NSInteger)easyTableView:(EasyTableView *)easyTableView numberOfRowsInSection:(NSInteger)section {
    return self.userDataArray.count;
}


#pragma mark scrollviewdelegate
- (void)easyTableViewScrollViewDidEndDecelerating:(UITableView*)tableView
{
    [refreshTimer setFireDate:[NSDate distantPast]];
    NSArray *arr = [tableView indexPathsForVisibleRows];
    if (arr.count<=0) {
        return;
    }
    NSIndexPath *indexPath1 = [arr firstObject];
    NSIndexPath *indexPath2;
    if (arr.count>0) {
        indexPath2 = [arr objectAtIndex:arr.count-1];
    }
    if (indexPath2.row<50) {
        startNum = @"0";
        stopNum = @"49";
        [self addNewDataArrayWithStartNum:startNum stopNum:stopNum];
    }else{
        startNum = [NSString stringWithFormat:@"%ld",(long)indexPath1.row];
        stopNum = [NSString stringWithFormat:@"%ld",(long)indexPath2.row];
        [self addNewDataArrayWithStartNum:startNum stopNum:stopNum];
    }
}
- (void)easyTableViewScrollViewDidScroll:(UITableView*)tableview
{
    [refreshTimer setFireDate:[NSDate distantFuture]];
    /*
    NSArray *arr = [tableview indexPathsForVisibleRows];
    if (arr.count<=0) {
        return;
    }
    NSIndexPath *indexPath = [arr objectAtIndex:arr.count-1];
    if (indexPath.row>=self.userDataArray.count-arr.count) {
        startNum = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
        stopNum = [NSString stringWithFormat:@"%ld",(long)(indexPath.row+50)];
    }
    [self addNewDataArrayWithStartNum:startNum stopNum:stopNum];
    */
}

#pragma mark usertableview action

- (void)actionReloadEasyTableViewRowsAtIndexPaths:(NSArray *)indexPaths
{
    [self.horizontalView reloadEasyTableViewRowsAtIndexPaths:indexPaths];
}


- (void)refreshUserTableView
{
    [self.horizontalView reload];
}

- (void)refreshOnlineUsers
{
    
    [self addNewDataArrayWithStartNum:startNum stopNum:stopNum];
}
- (void)addNewDataArrayWithStartNum:(NSString*)startN stopNum:(NSString*)stopN
{
    NSDictionary *getUserDict = [[NSDictionary alloc]initWithObjectsAndKeys:startN,@"start",stopN,@"stop", nil];
    [self.socketPrivate sendEvent:@"get online users" data:getUserDict];
}


#pragma mark  keyboardNSNotification---------------------------------------
//键盘弹起通知
- (void)keyboardWillShow:(NSNotification *)notification
{
    /*
     获取通知携带的信息
     */
    NSDictionary *userInfo = [notification userInfo];
    
    if (userInfo)
    {
        [[DataCacheManager sharedManager] addObject:userInfo forKey:UIKeyboardFrameEndUserInfoKey];
    }
    
    if (!_chatTextField)
    {
        return;
    }
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    if (CGRectEqualToRect(keyboardRect, CGRectZero))
    {
        NSDictionary *userInfo = (NSDictionary *)[[DataCacheManager sharedManager] getCachedObjectByKey:UIKeyboardFrameEndUserInfoKey];
        NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
        keyboardRect = [aValue CGRectValue];
    }
    
    keyboardRect = [self.view convertRect:keyboardRect toView:self.view];
    
    CGRect textViewRect =  [_chatTextField.superview convertRect:_chatTextField.frame toView:self.view];
    
    
    float offsetY  = (textViewRect.origin.y + textViewRect.size.height) - keyboardRect.origin.y;
    
    //输入框未被键盘遮挡 无需调整
    if (offsetY <=0)
    {
        return;
    }
    
    //  offsetY += IOS_VERSION_CODE < IOS_SDK_7 ? 44 :0;
    
    //获取键盘的动画执行时长
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    _chatTextFiledBar.top -= 45;
    [_tableView setBottom:_chatTextFiledBar.top];
    self.contentView.top -= (offsetY + 5 -40);
    
    [UIView commitAnimations];

}
//键盘退出通知
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    self.contentView.top =  0;
    _chatTextFiledBar.top = SCREEN_HEIGHT;
    [_tableView setBottom:_bottomToolBar.top];
    
    [UIView commitAnimations];
    _bottomToolBar.hidden = NO;
}

- (BOOL)isEnableKeyboardManger
{
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([event touchesForView:self.contentView] || [event touchesForView:self.tableView]) {
        [self endEditing];
        [chatVC.view removeFromSuperview];
        [chatVC removeFromParentViewController];
        chatVC = nil;
    }
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}
- (void)handleSingleTap:(UITapGestureRecognizer*)tap
{
    [self endEditing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"===========livevc===dealloc");
    [chatTimer invalidate];
    chatTimer = nil;
    [self.dataArray removeAllObjects];
    self.dataArray = nil;
    [self.userDataArray removeAllObjects];
    self.userDataArray = nil;
}
- (UIImage *)getGiftUIImageWithGiftUrl:(NSString *)giftUrl
{
    UIImage *image = [[SDImageCache sharedImageCache] imageFromKey:giftUrl];
    if (image) {
        return image;
    }else{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@.png",giftUrl]];
        image = [UIImage imageWithData: [NSData dataWithContentsOfURL:url]];
        [[SDImageCache sharedImageCache] storeImage:image forKey:giftUrl toDisk:NO];
        return image;
    }
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
