//
//  LiveRecordVC.m
//  LDLiveProject
//
//  Created by MAC on 16/9/13.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "LiveRecordVC.h"
#import "PlayerView.h"
#import <MediaPlayer/MediaPlayer.h>
#import <QuartzCore/QuartzCore.h>
#import "PhoneLiveShareView.h"

#define DEFINITIONVIEW_WIDTH     85
#define DEFINITIONVIEW_HEIGHT    35*2
/////////////////////////////////////////////

#define LOCAL_MIN_BUFFERED_DURATION   0.2
#define LOCAL_MAX_BUFFERED_DURATION   0.4
#define NETWORK_MIN_BUFFERED_DURATION 2.0
#define NETWORK_MAX_BUFFERED_DURATION 4.0
@interface LiveRecordVC ()<PhoneLiveShareDelegate>
{
    
    UIActivityIndicatorView *_activityIndicatorView;
    
    UITapGestureRecognizer *_tapGestureRecognizer;
    
    BOOL _isMediaSliderBeingDragged;
    
    BOOL                _hiddenHUD;
    
    NSString *_path;
    CGFloat moviePosition;
}
////ui
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *headerActionView;
@property (weak, nonatomic) IBOutlet UIView *footActionView;
@property (weak, nonatomic) IBOutlet UIButton *ESCButton;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UISlider *progressSlider;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIView *titleBgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *headBgView;
@property (weak, nonatomic) IBOutlet WebImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;
@property (strong,nonatomic)NSString *progressTime;
@property (strong,nonatomic)NSString *leftTime;
@property (weak, nonatomic) PhoneLiveShareView *liveShareView;

@end

@implementation LiveRecordVC




- (void) dealloc
{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self installMovieNotificationObservers];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    [self showHUD: NO];
    
    [_activityIndicatorView startAnimating];
}
- (void)viewDidLoad
{
    [self setUIFrameAndAction];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    _path = self.liveVideoModel.videoUrl;
    [self openUrl:_path useVTB:YES];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.liveVideoModel.v_id forKey:@"vid"];
    [AFRequestManager SafeGET:URI_VisitVedio parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = responseObject;
        NSLog(@"%@",result);
        if ([result[@"status"] intValue] == 200) {
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}
-(BOOL) openUrl:(NSString*)URL useVTB:(int)useVTB
{
    if (self.player) {
        [self closeUrl];
    }
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:NO];
    [IJKFFMoviePlayerController checkIfPlayerVersionMatch:NO major:1 minor:0 micro:0];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    //    [options setFormatOptionValue:@"ijktcphook" forKey:@"http-tcp-hook"];
    //    [options setPlayerOptionIntValue:YES    forKey:@"videotoolbox"];
    
    NSURL* url = [NSURL URLWithString:URL];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.contentView.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFill;
    self.player.shouldAutoplay = YES;
    
    IJKFFMoviePlayerController *ffp = self.player;
    ffp.httpOpenDelegate = self;
    ffp.tcpOpenDelegate = self;
    
    self.contentView.autoresizesSubviews = YES;
    [self.contentView addSubview:self.player.view];
    
    _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    _tapGestureRecognizer.numberOfTapsRequired = 1;
    [self.player.view addGestureRecognizer:_tapGestureRecognizer];
    
    [self.contentView sendSubviewToBack:self.player.view];
    
    [self installMovieNotificationObservers];
    
    [self.player prepareToPlay];
    
    [self.player play];
    
    [self addLog:[NSString stringWithFormat:@"Open URL : %@", _path]];
    
    return YES;
}


-(void)setUIFrameAndAction
{
    _titleBgView.layer.cornerRadius=_titleBgView.height/2;
    _titleBgView.layer.masksToBounds=YES;
    [_titleBgView setTop:-_titleBgView.height/2];
    [_titleBgView setLeft:-_titleBgView.height/2];
    [_titleLbl setLeft:_titleBgView.height/2];
    [_titleLbl setTop:_titleBgView.height/2];
    [_titleLbl setWidth:_titleBgView.width-_titleBgView.height/2];
    _headBgView.layer.cornerRadius=_headBgView.height/2;
    _headBgView.layer.masksToBounds=YES;
    _headBgView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.6];
    _headIV.layer.cornerRadius=_headIV.height/2;
    _headIV.layer.masksToBounds=YES;
    [_progressSlider setThumbImage:[UIImage imageNamed:@"playback_botton"]forState:UIControlStateNormal];
    _progressSlider.tintColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
    if (![NSString isBlankString:self.liveVideoModel.title]) {
        _titleLbl.text = self.liveVideoModel.title;
    }else{
        _titleLbl.text = @"当前视频没有标题哦!";
    }
    _numLbl.text=self.liveVideoModel.viewTimes;
    [_headIV setImageWithUrlString:self.liveVideoModel.imgUrl placeholderImage:[UIImage imageByApplyingAlpha:1 color:[UIColor darkGrayColor]]];
    
    _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.center = self.contentView.center;
    _activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.contentView addSubview:_activityIndicatorView];
    
    [_ESCButton addTarget:self action:@selector(doneDidTouch:) forControlEvents:UIControlEventTouchUpInside];
    [_playButton addTarget:self action:@selector(playDidTouch:) forControlEvents:UIControlEventTouchUpInside];
}
#pragma mark ---- 显示隐藏信息
- (void) showHUD: (BOOL) show
{
    _hiddenHUD = !show;
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:_hiddenHUD];
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionNone
                     animations:^{
                         
                         if (_hiddenHUD) {
                             [self refreshMediaControl];
                             _headerActionView.hidden = NO;
                             _footActionView.hidden = NO;
                         }else{
                             _headerActionView.hidden = YES;
                             _footActionView.hidden = YES;
                         }
                     }
                     completion:nil];
    
}
#pragma mark - gesture recognizer

- (void) handleTap: (UITapGestureRecognizer *) sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        if (sender == _tapGestureRecognizer ) {
            
            [self showHUD: _hiddenHUD];
            
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
#pragma mark PhoneLiveShareDelegate
//getliveshareviewdelegate
-(void)selectButtonWithTag:(NSInteger)tag type:(int)type{
    NSDictionary *dic;
//    =@{@"room_url":self.hostDetailInfoModel.share_addr,@"user_img":self.hostDetailInfoModel.headportrait,@"uname":self.hostDetailInfoModel.nick};
    
    if (tag==0) {
        //微博
        if ([WeiboSDK isWeiboAppInstalled]) {
            [[WeiboSDKManager sharedInstance]WeiboShareWithContent:@"" info:dic successCompletion:^(BOOL success) {
                [self.liveShareView hideFromView];
            } failureCompletion:^(BOOL failer) {
                [self.liveShareView hideFromView];
            }];
        }
    }else if(tag==1||tag==2){
        WXApiType wxApiType;
        if (tag==1) {
            //朋友圈
            wxApiType=WXApiTypeSceneTimeline;
        }else{
            //微信
            wxApiType=WXApiTypeWXSceneSession;
        }
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            [[WXApiManager shareManager]wxShareForMessage:wxApiType content:@"" info:dic successCompletion:^(BOOL success) {
                [self.liveShareView hideFromView];
            } failureCompletion:^(BOOL failer) {
                [self.liveShareView hideFromView];
            }];
        }
    }else if(tag==3||tag==4){
        NSInteger shareType;
        if (tag==3) {
            shareType=0;//qq好友
        }else{
            shareType=1;//qq空间
        }
        if ([QQApiInterface isQQInstalled]) {
            [[TencentOpenApiManager shareManager]qqShareWithType:shareType content:@"" info:dic successCompletion:^(BOOL success) {
                [self.liveShareView hideFromView];
                
            } failureCompletion:^(BOOL failer) {
                [self.liveShareView hideFromView];
            }];
        }
    }
}

#pragma mark - actions
- (IBAction)shareBtnClick:(UIButton *)sender {
    CGRect rect=CGRectMake(sender.frame.origin.x-20,_footActionView.top+sender.frame.origin.y, sender.width, sender.height);
    _liveShareView=[PhoneLiveShareView viewFromXIB];
    _liveShareView.delegate=self;
    _liveShareView.arrowtype=ArrowToBottom;
    _liveShareView.isSelfVideo=NO;
    [_liveShareView showInView:KAPP_WINDOW withRect:rect arrow:0.7];
}

- (void) playDidTouch: (id) sender
{
    if ([self.player isPlaying]){
        [self.player pause];
    }else{
        if ([self.progressTime isEqualToString:self.leftTime]) {
            [self onReplay];
        }else{
            [self.player play];
        }
    }
    [self updatePlayButton];
}
//重播
- (void) onReplay
{
    if (self.player) {
        [self closeUrl];
        [self openUrl:_path useVTB:YES];
    }
}
- (void) updatePlayButton
{
    if ([self.player isPlaying]) {
        [_playButton setImage:[UIImage imageNamed:@"playback_up.png"] forState:UIControlStateNormal];
    }else{
        [_playButton setImage:[UIImage imageNamed:@"playback_down.png"] forState:UIControlStateNormal];
    }
}
//退出
- (void) doneDidTouch: (id) sender
{
    [self closeUrl];
    if (self.presentingViewController || !self.navigationController)
        [self dismissViewControllerAnimated:YES completion:nil];
    else
        [self.navigationController popViewControllerAnimated:YES];
}
- (NSString *)onHttpOpen:(int)streamIndex url:(NSString *)url
{
    return url;
}

- (NSString *)onTcpOpen:(int)streamIndex url:(NSString *)url
{
    return url;
}

#pragma mark 进度条事件

- (IBAction)didSliderTouchUpInside:(id)sender {
    self.player.currentPlaybackTime = self.progressSlider.value;
    _isMediaSliderBeingDragged = NO;
}

#pragma mark 刷新播放相关信息

- (void)refreshMediaControl
{
    // duration
    NSTimeInterval duration = self.player.duration;
    NSInteger intDuration = duration + 0.5;
    if (intDuration > 0) {
        self.progressSlider.maximumValue = duration;
        self.leftTime = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
    } else {
        self.leftTime = @"--:--";
        self.progressSlider.maximumValue = 1.0f;
    }
    
    
    // position
    NSTimeInterval position;
    if (_isMediaSliderBeingDragged) {
        position = self.progressSlider.value;
    } else {
        position = self.player.currentPlaybackTime;
    }
    NSInteger intPosition = position + 0.5;
    if (intDuration > 0) {
        self.progressSlider.value = position;
    } else {
        self.progressSlider.value = 0.0f;
    }
    self.progressTime = [NSString stringWithFormat:@"%02d:%02d", (int)(intPosition / 60), (int)(intPosition % 60)];
    self.progressLabel.text=[NSString stringWithFormat:@"%@/%@",self.progressTime,self.leftTime];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    if (_hiddenHUD) {
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
    }
}


- (void)loadStateDidChange:(NSNotification*)notification
{
    
    MPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & MPMovieLoadStatePlaythroughOK) != 0) {
        [self addLog:[NSString stringWithFormat:@"Play State : Playback will be automatically started in this state when shouldAutoplay is YES"]];
        [_activityIndicatorView stopAnimating];
        [_playButton setImage:[UIImage imageNamed:@"playback_down.png"] forState:UIControlStateNormal];
        //开始、
    } else if ((loadState & MPMovieLoadStateStalled) != 0) {
        [self addLog:[NSString stringWithFormat:@"Play State : Playback will be automatically paused in this state, if started"]];
        [_activityIndicatorView startAnimating];
        [_playButton setImage:[UIImage imageNamed:@"playback_up.png"] forState:UIControlStateNormal];
        //网络卡 暂停
    } else {
        [self addLog:[NSString stringWithFormat:@"Play State :  loadStateDidChange : %d", (int)loadState]];
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    int reason = [[[notification userInfo] valueForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case MPMovieFinishReasonPlaybackEnded:
            [self addLog:@"Play Finish : Playback Ended"];
            [_activityIndicatorView stopAnimating];
            [_playButton setImage:[UIImage imageNamed:@"playback_up.png"] forState:UIControlStateNormal];
            break;
            
        case MPMovieFinishReasonUserExited:
            [self addLog:@"Play Finish : User Exited"];
            break;
            
        case MPMovieFinishReasonPlaybackError:
            [self addLog: [NSString stringWithFormat:@"Play Finish : Playback Error : %d", reason]];
            break;
            
        default:
            [self addLog: [NSString stringWithFormat:@"Play Finish : Unkonow Error : %d", reason]];
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
    [self refreshMediaControl];
    [self addLog:@"Player mediaIsPreparedToPlayDidChange\n"];
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    switch (_player.playbackState)
    {
        case MPMoviePlaybackStateStopped: {
            [self addLog:@"Player Stopped\n"];
            break;
        }
        case MPMoviePlaybackStatePlaying: {
            [self addLog:[NSString stringWithFormat:@"Player : Is Playing : %d, Bytes Transferred : %d",
                          (int)[self.player isPlaying], (int)self.player.numberOfBytesTransferred]];
            break;
        }
        case MPMoviePlaybackStatePaused: {
            [self addLog:@"Player : Paused"];
            break;
        }
        case MPMoviePlaybackStateInterrupted: {
            [self addLog:@"Player : Interrupted"];
            break;
        }
        case MPMoviePlaybackStateSeekingForward:
        case MPMoviePlaybackStateSeekingBackward: {
            [self addLog:@"Player moviePlayBackStateDidChange Seek\n"];
            break;
        }
        default: {
            [self addLog:@"Player moviePlayBackStateDidChange unKnow\n"];
            break;
        }
    }
}
#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}
-(void) closeUrl
{
    if (self.player) {
        
        [self.player.view removeFromSuperview];
        [self.player shutdown];
        [self removeMovieNotificationObservers ];
        self.player = nil;
    }
}

-(void) addLog:(NSString*) text
{
    
    NSString *strText = [NSString stringWithFormat:@"%@\n",text];
    NSLog(@"====%@",strText);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (void) viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
      [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    [super viewWillDisappear:animated];
    
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
