//
//  LiveChooseVC.m
//  LiveProject
//
//  Created by MAC on 16/3/31.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "LiveChooseVC.h"

@interface LiveChooseVC ()<UITextViewDelegate>
{
    UIImageView *boxImageView;
    //话题array
    NSArray  *topicArray;
}


@property (weak, nonatomic) IBOutlet UITextView *liveTitleTV;
@property (weak, nonatomic) IBOutlet UIButton *qzoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *qqBtn;
@property (weak, nonatomic) IBOutlet UIButton *sinaBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UIButton *circleFriendsBtn;

@property (weak, nonatomic) IBOutlet UIButton *startLiveBtn;
@property (weak, nonatomic) IBOutlet UIView *shareBgView;

@property (weak, nonatomic) IBOutlet UIView *nameBgView;
@property (weak, nonatomic) IBOutlet UIImageView *preview;
@property (weak, nonatomic) IBOutlet UIView *backBGView;
@property (weak, nonatomic) IBOutlet UIButton *addTopicButton;

@property (weak, nonatomic) UIButton *directionBtn;//方向
@property (weak, nonatomic) UIButton *definitionBtn;//清晰度
@property (weak, nonatomic) UIButton *shareBtn;//分享

@end

@implementation LiveChooseVC

- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification object:nil]; //监听是否重新进入程序程序.
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_liveTitleTV resignFirstResponder];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [super viewDidDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self showTextHint:[NSString stringWithFormat:@"开始直播分享到%@朋友圈",@"\n"] button:_circleFriendsBtn];
}
- (void)applicationDidBecomeActive:(NSNotification *)notification
{
    [self showLiveVC];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _liveTitleTV.text = @"给直播写个标题吧";
    _liveTitleTV.textColor = [UIColor darkGrayColor];
    _liveTitleTV.selectedRange=NSMakeRange(0,0) ;   //起始位置
    [_liveTitleTV becomeFirstResponder];

    UITapGestureRecognizer* myTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self.view addGestureRecognizer:myTap];
    myTap.cancelsTouchesInView = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:_liveTitleTV];
    
    [self rebuildUI];
}



-(void)rebuildUI
{
    _startLiveBtn.layer.cornerRadius=_startLiveBtn.height/2;
    _startLiveBtn.layer.masksToBounds=YES;
    _startLiveBtn.layer.borderWidth=1;
    _startLiveBtn.layer.borderColor=[UIColor colorWithHexString:GiftUsualColor].CGColor;
    [_startLiveBtn setTitleColor:[UIColor colorWithHexString:GiftUsualColor] forState:UIControlStateNormal];
    [_startLiveBtn setTitleColor:[UIColor colorWithHexString:GiftUsualColor] forState:UIControlStateHighlighted];
    [_startLiveBtn setTitleColor:[UIColor colorWithHexString:GiftUsualColor] forState:UIControlStateSelected];
    
    _liveTitleTV.delegate=self;
    _liveTitleTV.textColor = [UIColor whiteColor];
    
    _circleFriendsBtn.tag=200;
    [_circleFriendsBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _weixinBtn.tag=200+1;
    [_weixinBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _sinaBtn.tag=200+2;
    [_sinaBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _qqBtn.tag=200+3;
    [_qqBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    _qzoneBtn.tag=200+4;
    [_qzoneBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    
    //默认分享朋友圈
    _circleFriendsBtn.selected=YES;
    _shareBtn=_circleFriendsBtn;
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    return YES;
}

- (void)handleSingleTap:(UITapGestureRecognizer*)tap
{
    [_liveTitleTV resignFirstResponder];
    if ([_liveTitleTV.text isEqualToString:@""]) {
        
    }
}




#pragma mark 按钮触发事件


- (IBAction)closeClick:(UIButton *)sender {
    [_liveTitleTV resignFirstResponder];
    if ([_delegate respondsToSelector:@selector(LiveChooseVCDelegateCloseButtonClick)]) {
        [_delegate LiveChooseVCDelegateCloseButtonClick];
    }
}

- (IBAction)startLiveBtnClick:(UIButton *)sender {
    [_liveTitleTV resignFirstResponder];
    [self gotoShare];
}

-(void)gotoShare
{
    NSString *titleStr=nil;
    if ([_liveTitleTV.text isEqualToString:@"给直播写个标题吧!"]) {
        titleStr=@"";
    }else{
        titleStr=_liveTitleTV.text;
    }
    [self startLiveInformLiveFirstVC];
}

#pragma mark PrepareLiveViewDelegate
- (void)startLiveInformLiveFirstVC{
    UserModel *userModel = [AccountHelper userInfo];
    NSDictionary *dic=@{@"room_url":self.userTVInfoModel.share_addr,@"user_img":userModel.headportrait,@"uname":userModel.nick};
    
    if (_shareBtn.tag-200 == 0 || _shareBtn.tag-200 == 1) {//0 朋友圈 1 微信
        WXApiType wxApiType;
        if (_shareBtn.tag-200 == 0) {
            wxApiType=WXApiTypeSceneTimeline;//朋友圈
        }else{
            wxApiType=WXApiTypeWXSceneSession;//好友
        }
        if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
            [[WXApiManager shareManager]wxShareForMessage:wxApiType content:[NSString stringWithFormat:@"%@我正在直播TV[直播],速来围观.",[_liveTitleTV.text isEqualToString:@"给直播写个标题吧"]?@"":[NSString stringWithFormat:@"\"%@\"",_liveTitleTV.text]] info:dic successCompletion:^(BOOL success) {

            } failureCompletion:^(BOOL failer) {


            }];
        }else{
            [self showLiveVC];
        }
    }
    else if (_shareBtn.tag-200 == 2){
        if ([WeiboSDK isWeiboAppInstalled]) {
            [[WeiboSDKManager sharedInstance]WeiboShareWithContent:[NSString stringWithFormat:@"%@我正在直播TV[直播],速来围观.点击进入",[_liveTitleTV.text isEqualToString:@"给直播写个标题吧"]?@"":[NSString stringWithFormat:@"\"%@\"",_liveTitleTV.text]] info:dic successCompletion:^(BOOL success) {

            } failureCompletion:^(BOOL failer) {

            }];
        }else{
            [self showLiveVC];
        }
    }
    else if (_shareBtn.tag-200 == 3 || _shareBtn.tag-200 == 4){//QQ
        NSInteger shareType;
        if (_shareBtn.tag-200 == 3) {
            shareType=0;//qq好友
        }else{
            shareType=1;//qq空间
        }
        if ([QQApiInterface isQQInstalled]) {
            [[TencentOpenApiManager shareManager]qqShareWithType:shareType content:[NSString stringWithFormat:@"%@我正在直播TV[直播],速来围观.",[_liveTitleTV.text isEqualToString:@"给直播写个标题吧"]?@"":[NSString stringWithFormat:@"\"%@\"",_liveTitleTV.text]] info:dic successCompletion:^(BOOL success) {

            } failureCompletion:^(BOOL failer) {

            }];
        }else{
            [self showLiveVC];
        }
    }
}

- (void)showLiveVC
{
    if ([_delegate respondsToSelector:@selector(LiveChooseVCDelegateStartButtonClick)]) {
        if ([_liveTitleTV.text isEqualToString:@"给直播写个标题吧!"]) {
            self.titleString=@"";
        }else{
            self.titleString=_liveTitleTV.text;
        }
        [_delegate LiveChooseVCDelegateStartButtonClick];
    }
}


- (void)shareBtnClick:(UIButton *)sender{
    _shareBtn.selected=NO;
    sender.selected=YES;
    _shareBtn=sender;
    switch (sender.tag-200) {
        case 0:
            [self showTextHint:[NSString stringWithFormat:@"开始直播分享到%@朋友圈",@"\n"] button:sender];
            break;
        case 1:
            [self showTextHint:[NSString stringWithFormat:@"开始直播分享到%@微信",@"\n"] button:sender];
            break;
        case 2:
            [self showTextHint:[NSString stringWithFormat:@"开始直播分享到%@微博",@"\n"] button:sender];
            break;
        case 3:
            [self showTextHint:[NSString stringWithFormat:@"开始直播分享到%@QQ好友",@"\n"] button:sender];
            break;
        case 4:
            [self showTextHint:[NSString stringWithFormat:@"开始直播分享到%@QQ空间",@"\n"] button:sender];
            break;
        default:
            break;
    }
}
- (void)showTextHint:(NSString *)text button:(UIButton *)button{
    
    if (boxImageView) {
        [boxImageView removeFromSuperview];
        boxImageView=nil;
    }
    CGFloat boxIvWidth=85;
    CGFloat boxIvHeight=35;
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(3, 3, boxIvWidth-3*2, boxIvHeight-5-3*2)];
    label.text=text;
    label.numberOfLines=2;
    label.font=[UIFont systemFontOfSize:10];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    
    boxImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, _shareBgView.top-boxIvHeight, boxIvWidth, boxIvHeight)];
    boxImageView.image=[UIImage imageNamed:@"share_hint"];
    [boxImageView setCenterX:_shareBgView.left+button.centerX];
    [boxImageView addSubview:label];
    [self.view addSubview:boxImageView];
    
    [self performSelector:@selector(removeBoxViewFromSuperView:) withObject:boxImageView afterDelay:2.0];
}
-(void)removeBoxViewFromSuperView:(UIImageView *)boxView1{
    if (boxView1) {
        [boxView1 removeFromSuperview];
    }
}
- (void)chooseDefinitionClick:(UIButton *)sender {
    _definitionBtn.selected=NO;
    sender.selected=YES;
    _definitionBtn=sender;
}
#pragma mark UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    return YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]) {
        textView.text=@"给直播写个标题吧!";
    }
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

//Fetching UITextField object from notification.
- (void)textViewTextDidChangeNotification:(NSNotification *) notification
{
    _liveTitleTV = notification.object;
    
    NSString *toBeString = _liveTitleTV.text;
    
    NSString *lang = [(UITextInputMode*)[[UITextInputMode activeInputModes] firstObject] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [_liveTitleTV markedTextRange];
        //获取高亮部分
        UITextPosition *position = [_liveTitleTV positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if ([_liveTitleTV.text rangeOfString:@"给直播写个标题吧"].location != NSNotFound) {
                NSString *textStr = [_liveTitleTV.text stringByReplacingOccurrencesOfString:@"给直播写个标题吧" withString:@""];
                if (textStr.length>0) {
                    _liveTitleTV.text = textStr;
                }
            }
            
        } // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if ([_liveTitleTV.text rangeOfString:@"给直播写个标题吧"].location != NSNotFound) {
            NSString *textStr = [_liveTitleTV.text stringByReplacingOccurrencesOfString:@"给直播写个标题吧" withString:@""];
            if (textStr.length>0) {
            }
        }
    }
    if (_liveTitleTV.text.length == 0) {
        _liveTitleTV.text = @"给直播写个标题吧";
        _liveTitleTV.selectedRange=NSMakeRange(0,0) ;   //起始位置
    }
}

-(void)dealloc{
    NSLog(@"LiveChooseVC=====dealloc");
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
