//
//  ChatPrivateVC.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/5/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ChatPrivateVC.h"
#import "ChatPrivateCell.h"
#import "MessListModel.h"
#import "ChatPrivateModel.h"
#import "ChatProvateCellTool.h"
@interface ChatPrivateVC ()<UITableViewDelegate,UITableViewDataSource,ChatPrivateCellDelegate,UITextFieldDelegate>
{
    NSTimer *timer;
    SRRefreshView   *_slimeView;
    //页数标记
    NSInteger currentPage;
    NSInteger totalPage;
}
@property (weak, nonatomic) IBOutlet UITextField *chatTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendMessageButton;
@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)BOOL isMoreMessage;//有无更多历史消息
@property (nonatomic,strong)UIButton *delBtn;
@property (nonatomic,strong)NSString *delMsgId;//要删除的消息
@end

@implementation ChatPrivateVC
-(UIButton *)delBtn{
    if (_delBtn==nil) {
        _delBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_delBtn setFrame:CGRectMake(0, 0, 50, 24)];
        [_delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [_delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_delBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [KAPP_WINDOW addSubview:_delBtn];
        [_delBtn addTarget:self action:@selector(delBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _delBtn;
}
- (NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView*)tableView
{
    if (!_tableView) {
        if (!_SmallTypeBool) {
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64-40) style:UITableViewStylePlain];
        }else{
            _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT/2-40-40) style:UITableViewStylePlain];
        }
        
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-40);
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _slimeView = [[SRRefreshView alloc] init];
    _slimeView.delegate = self;
    _slimeView.slimeMissWhenGoingBack = YES;
    _slimeView.slime.bodyColor = [UIColor blackColor];
    _slimeView.slime.skinColor = [UIColor whiteColor];
    _slimeView.slime.lineWith = 1;
    _slimeView.slime.shadowBlur = 4;
    _slimeView.slime.shadowColor = [UIColor blackColor];
    
    UIView *mheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SELFVIEW_WIDTH, 0)];
    self.tableView.tableHeaderView = mheaderView;
    [self.tableView addSubview:_slimeView];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [_slimeView update:0];
    
    [self.view addSubview:self.tableView];
    if (!_SmallTypeBool) {
        [self setUsualNavigationBarWithBackAndTitleWithString:_chatListModel.user_name];
    }else{
        [self addtitleView];
    }
    
    if (self.dataArray.count>0) {
        ChatPrivateModel *model=[self.dataArray firstObject];
        if (model) {
            [self getHistoryMsgid:model.msgid];
        }
    }else{
        [self getLastMsgId:@"0"];
    }
    
    
    _bottomView.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    _chatTextField.delegate = self;
    [_sendMessageButton setBackgroundColor:[UIColor colorWithHexString:GiftUsualColor]];
    [_sendMessageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_sendMessageButton addTarget:self action:@selector(sendMessageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    _sendMessageButton.layer.cornerRadius = 3;
    _sendMessageButton.layer.masksToBounds = YES;
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideDelBtn:)];
    [self.view addGestureRecognizer:tap];
}
- (void)addtitleView
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    label.backgroundColor = [UIColor colorWithHexString:GiftUsualColor];
    label.textColor = [UIColor whiteColor];
    label.font = [UIFont systemFontOfSize:16];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _chatListModel.user_name;
    [self.view addSubview:label];
}

-(void)hideDelBtn:(UIGestureRecognizer *)tap{
    [self endEditing];
    if (self.delBtn.hidden==NO) {
        self.delBtn.hidden=YES;
    }
}
-(void)actionClickNavigationBarLeftButton
{
    [[MessageHelper shareInstance] getTotalNotReadRequest];
    [super actionClickNavigationBarLeftButton];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (timer==nil) {
        timer =[NSTimer scheduledTimerWithTimeInterval:kChatRefreshTime target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
    }
}
- (void)timerClick{
    NSString *msgid=@"0";
    if (self.dataArray.count>0) {
        ChatPrivateModel *model=[self.dataArray lastObject];
        msgid=model.msgid;
    }
    [self getLastMsgId:msgid];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [timer invalidate];
    timer=nil;
}
- (void)delBtnClick{
    _delBtn.hidden=YES;
    [self delSingleMsgWithMsgID:_delMsgId];
}
#pragma mark 删除单个消息
- (void)delSingleMsgWithMsgID:(NSString *)msgid{
    NSDictionary *params=@{@"token":User_Token,@"msgid":msgid};
    
    [AFRequestManager SafePOST:URI_MsglogDel parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([result[@"status"] intValue] == 200) {
            if ([result objectForKey:@"data"]) {
                for (ChatPrivateModel *model in _dataArray) {
                    if ([model.msgid isEqualToString:msgid]) {
                        [_dataArray removeObject:model];
                        [_tableView reloadData];
                        return ;
                    }
                }
            }
        }else{
            [self showMPNotificationViewWithErrorMessage:[NSString stringWithFormat:@"%@",result[@"data"]]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showMPNotificationViewWithErrorMessage:@"网络请求失败"];
    }];
}
#pragma mark 获取最新聊天消息
- (void)getLastMsgId:(NSString *)msgid{
    NSDictionary *params=@{@"token":User_Token,@"uid":_chatListModel.uid,@"msgid":msgid};
    
    [AFRequestManager SafePOST:URI_GetLastMsg parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [_slimeView endRefresh];
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([result[@"status"] intValue] == 200) {
            NSMutableArray *array = [NSMutableArray array];
            NSArray *list = [[result objectForKey:@"data"] objectForKey:@"hisMsg"];
            if ([list isKindOfClass:[NSArray class]]) {
                array = [NSMutableArray arrayWithCapacity:list.count];
                for (NSDictionary *dic in list) {
                    [array addObject:[[ChatPrivateModel alloc] initWithDictionary:dic error:nil]];
                }
            }
            ChatPrivateModel *model=[array firstObject];
            ChatPrivateModel *model1=[self.dataArray lastObject];
            if (self.dataArray>0) {
                if ([model.msgid intValue]<=[model1.msgid intValue]) {
                    return ;
                }
            }
            [self.dataArray addObjectsFromArray:array];
            [_tableView reloadData];
            [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
        }else{
//            [self showMPNotificationViewWithErrorMessage:[NSString stringWithFormat:@"%@",result[@"data"]]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_slimeView endRefresh];
        [self showMPNotificationViewWithErrorMessage:@"网络请求失败"];
    }];
}
#pragma mark 获取历史聊天消息
- (void)getHistoryMsgid:(NSString *)msgid{
    NSDictionary *params=@{@"token":User_Token,@"uid":_chatListModel.uid,@"msgid":msgid,@"size":@"20"};
    
    [AFRequestManager SafePOST:URI_GetHistoryMsg parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        [_slimeView endRefresh];
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([result[@"status"] intValue] == 200) {
            NSMutableArray *array = [NSMutableArray array];
            NSArray *list = [[result objectForKey:@"data"] objectForKey:@"hisMsg"];
            if ([list isKindOfClass:[NSArray class]]) {
                array = [NSMutableArray arrayWithCapacity:list.count];
                for (NSDictionary *dic in list) {
                    [array addObject:[[MessListModel alloc] initWithDictionary:dic error:nil]];
                }
            }
            ChatPrivateModel *model=[array firstObject];
            ChatPrivateModel *model1=[self.dataArray lastObject];
            if (self.dataArray>0) {
                if ([model.msgid intValue]<=[model1.msgid intValue]) {
                    return ;
                }
            }
            [array addObjectsFromArray:self.dataArray];
            [self.dataArray removeAllObjects];
            [self.dataArray addObjectsFromArray:array];
            array = nil;
            [_tableView reloadData];
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [_slimeView endRefresh];
        [self showMPNotificationViewWithErrorMessage:@"网络请求失败"];
    }];
}
#pragma mark 发送消息
- (void)sendMsg:(NSString *)msg{
    NSDictionary *params=@{@"token":User_Token,@"send_uid":_chatListModel.uid,@"send_msg":msg};
    __weak typeof(self)weakSelf=self;
    
    [AFRequestManager SafePOST:URI_SendMsg parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
        NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
        if ([result[@"status"] intValue] == 200) {
            NSString *msgid=[NSString stringWithFormat:@"%d",[result[@"data"] intValue]-1];
            ChatPrivateModel *model=[weakSelf.dataArray lastObject];
            if (model){
                msgid=model.msgid;
            }
            [weakSelf getLastMsgId:msgid];
        }else{
//            [self showMPNotificationViewWithErrorMessage:[NSString stringWithFormat:@"%@",result[@"data"]]];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self showMPNotificationViewWithErrorMessage:@"网络请求失败"];
    }];
}
#pragma mark tableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID=@"ChatPrivateCell";
    ChatPrivateCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell=[[ChatPrivateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.delegate=self;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    [cell setChatPrivateModel:self.dataArray[indexPath.row] chatListModel:_chatListModel];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChatProvateCellTool *tool=[[ChatProvateCellTool alloc]init];
    ChatPrivateModel *model=self.dataArray[indexPath.row];
    return [tool cellHeightWithMsg:model.msg maxWidth:tableView.width];
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (self.delBtn.hidden==NO) {
        self.delBtn.hidden=YES;
    }
}
#pragma mark ChatPrivateCellDelegate
-(void)delSingleMsgWithMsgID:(NSString *)msgid rect:(CGRect)frame{
    _delMsgId=nil;
    _delMsgId=msgid;
    self.delBtn.hidden=NO;
    [self.delBtn setCenterX:frame.origin.x+frame.size.width/2];
    if (frame.origin.y<64+_delBtn.height) {
        [self.delBtn setTop:frame.origin.y+frame.size.height];
        [_delBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 0, 0, 0)];
         [_delBtn setBackgroundImage:[UIImage imageNamed:@"personvc_arrowbg_up"] forState:UIControlStateNormal];
    }else{
        [self.delBtn setBottom:frame.origin.y];
        [_delBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
         [_delBtn setBackgroundImage:[UIImage imageNamed:@"personvc_arrowbg_down"] forState:UIControlStateNormal];
    }
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
    if (!_SmallTypeBool) {
        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64 -(offsetY + 5)-40);
        _bottomView.top -= (offsetY + 5 );
    }else{
        
    }
    
    
    [UIView commitAnimations];
    if (self.dataArray.count>0) {
        [_tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionBottom];
    }
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
    if (!_SmallTypeBool) {
        _bottomView.top = SCREEN_HEIGHT-40;
        self.tableView.frame = CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64 -40);
    }else{
        _bottomView.top = SCREEN_HEIGHT/2-40;
        self.tableView.frame = CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT/2-40 -40);
    }
    [UIView commitAnimations];
}

- (BOOL)isEnableKeyboardManger
{
    return YES;
}


//textfiledDelegate 发送消息
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *chatStr = [NSString stringWithFormat:@"%@",_chatTextField.text];
    if (![NSString isBlankString:chatStr]) {
        if ([NSString isBlankString:chatStr]) {
            return YES;
        }
        [self sendMsg:_chatTextField.text];
    }
    _chatTextField.text = @"";
    return YES;
}

- (void)sendMessageButtonClick:(UIButton*)button
{
//    NSString *chatStr = [NSString stringWithFormat:@"%@",notif.object];
//    chatStr = [chatStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *chatStr = [NSString stringWithFormat:@"%@",_chatTextField.text];
    if (![NSString isBlankString:chatStr]) {
        if ([NSString isBlankString:chatStr]) {
            return;
        }
        [self sendMsg:_chatTextField.text];
    }
    _chatTextField.text = @"";
}


#pragma mark - slimeRefresh delegate
#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    if (self.dataArray.count>0) {
        ChatPrivateModel *model=[self.dataArray firstObject];
        [self getHistoryMsgid:model.msgid];
    }else{
        [self getHistoryMsgid:@"0"];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc{
    
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
