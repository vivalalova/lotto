//
//  VideoView.m
//  EasyPlayer
//
//  Created by 霍红雷 on 16/2/24.
//  Copyright © 2016年 霍红雷. All rights reserved.
//



#import "PlayerView.h"


@interface PlayerView()
{
    UIVisualEffectView *effectview;
}
@property(nonatomic, strong)NSString* playURL;
@property(nonatomic) int bVTB;
@property(nonatomic, strong)UIImageView *bgImageView;
@property(nonatomic, strong)WebImageView *gaussImageView;
@property(nonatomic, strong)UIActivityIndicatorView *activityIndicatorView;
@end

@implementation PlayerView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        return self;
    }
    
    return nil;
}

-(void)dealloc
{
    if (self.player) {
        [self.player shutdown];
        self.player = nil;
    }
}

-(BOOL) openUrl:(NSString*)URL useVTB:(int)useVTB
{
    if (self.player) {
        [self closeUrl];
    }
    //添加语音界面的背景图片
//    if ([URL rangeOfString:INDEX_ONLY_AUDIO].location != NSNotFound) {
//        if (self.bgImageView) {
//            [self addSubview:self.bgImageView];
//        }
//    }else{
        if (self.bgImageView) {
            [self.bgImageView removeFromSuperview];
        }
//    }
    
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setPlayerOptionIntValue:1      forKey:@"video-pictq-size"];

    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:URL] withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFill;
    self.player.shouldAutoplay = YES;
    self.playURL = URL;
    self.bVTB = useVTB;
    
    self.autoresizesSubviews = YES;
    [self addSubview:self.player.view];
    
    [self sendSubviewToBack:self.player.view];
    
    [self installMovieNotificationObservers];
    
    [self.player prepareToPlay];
    
    [self addLog:[NSString stringWithFormat:@"Open URL : %@", URL]];
    //添加高斯效果图
    if (![NSString isBlankString:self.imageUrl]) {
        NSURL *url = [NSURL URLWithString:self.imageUrl];
        [self.gaussImageView setImageWithURL:url];
    }
    //加载圆圈转动
    [self.activityIndicatorView startAnimating];
    return YES;
}

-(void) closeUrl
{
    if (self.player) {
        self.activityIndicatorView = nil;
        [self.player.view removeFromSuperview];
        [self.player shutdown];
        [self removeMovieNotificationObservers ];
        self.player = nil;
    }
}
-(void) playerPause
{
    [self.player pause];
}

-(void) playerPlay
{
    [self.player play];
}

-(void) playerShutdown
{
    [self.player shutdown];
}

- (void)loadStateDidChange:(NSNotification*)notification
{
    
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & MPMovieLoadStatePlaythroughOK) != 0) {
        [self addLog:[NSString stringWithFormat:@"Play State : Playback will be automatically started in this state when shouldAutoplay is YES"]];
        [self.activityIndicatorView stopAnimating];
        [self hiddenGassImageView];
        //开始、
    } else if ((loadState & MPMovieLoadStateStalled) != 0) {
        [self addLog:[NSString stringWithFormat:@"Play State : Playback will be automatically paused in this state, if started"]];
        [self.activityIndicatorView startAnimating];
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
            [self.activityIndicatorView stopAnimating];
            [self showGassImageView];
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

//重播
- (void) onReplay
{
    if (self.player) {
        [self closeUrl];
        [self openUrl:self.playURL useVTB:self.bVTB];
    }
}

-(void) addLog:(NSString*) text
{
    
    NSString *strText = [NSString stringWithFormat:@"%@\n",text];
    NSLog(@"====%@",strText);
}

-(UIImageView*)bgImageView
{
    if (_bgImageView == nil) {
        _bgImageView = [[UIImageView alloc]initWithFrame:self.bounds];
        _bgImageView.image = [UIImage imageNamed:@"voice.jpg"];
    }
    return _bgImageView;
}
-(UIImageView*)gaussImageView
{
    if (!_gaussImageView) {
        _gaussImageView = [[WebImageView alloc]initWithFrame:self.bounds];
        [_gaussImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:self.gaussImageView];
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        effectview = [[UIVisualEffectView alloc] initWithEffect:blur];
        effectview.frame =self.bounds;
        [_gaussImageView addSubview:effectview];
    }
    return _gaussImageView;
}
-(void)hiddenGassImageView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8];
    self.gaussImageView.alpha = 0;
    [UIView commitAnimations];
}

-(void)showGassImageView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    self.gaussImageView.alpha = 1;
    [UIView commitAnimations];
}

-(UIActivityIndicatorView*)activityIndicatorView
{
    if (!_activityIndicatorView) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
        _activityIndicatorView.center = self.superview.center;
        _activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_activityIndicatorView];
    }
    return _activityIndicatorView;
}

-(void)setNeedsLayout
{
    self.gaussImageView.frame = self.bounds;
    effectview.frame = self.bounds;
}
@end
