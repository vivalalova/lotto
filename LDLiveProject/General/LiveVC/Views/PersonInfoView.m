//
//  PersonInfoView.m
//  LDLiveProject
//
//  Created by MAC on 16/7/4.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "PersonInfoView.h"
#import "UserModel.h"
@interface PersonInfoView ()
{
    UserModel *_userModel;
    UIImageView *vip_icon;
}
@property (nonatomic,strong)PersonInfoModel*perInfoModel;
@end

@implementation PersonInfoView



- (void)awakeFromNib
{
    [super awakeFromNib];
    _userModel = [AccountHelper userInfo];
    
    self.backgroundColor = [UIColor clearColor];
    [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"0xf9f3f3"]];
    self.contentView.layer.cornerRadius = 5;
    self.contentView.clipsToBounds = YES;
    _headerBGView.backgroundColor = [UIColor whiteColor];
    _headerBGView.layer.cornerRadius = _headerBGView.height/2;
    _headerBGView.clipsToBounds = YES;
    _headerImageView.layer.cornerRadius = _headerImageView.height/2;
    _headerImageView.clipsToBounds = YES;
    
    _nameLabel.backgroundColor =[UIColor clearColor];
    _roomIdLabel.backgroundColor =[UIColor clearColor];
    _signatureLabel.backgroundColor =[UIColor clearColor];
    _nameLabel.textColor = [UIColor blackColor];
    _roomIdLabel.textColor = [UIColor darkGrayColor];
    _signatureLabel.textColor = [UIColor lightGrayColor];
    
    _nameLabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    _roomIdLabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    _signatureLabel.font = [UIFont systemFontOfSize:CustomFont(14)];
    
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _roomIdLabel.textAlignment = NSTextAlignmentRight;
    _signatureLabel.textAlignment = NSTextAlignmentRight;
    
    _linLabel1.width = 0.5;
    _linLabel2.width = 0.5;
    _linLabel3.height = 0.25;
    _linLabel4.width = 0.5;
    
    _linLabel1.backgroundColor = [UIColor colorWithHexString:@"0xd7d9d8"];
    _linLabel2.backgroundColor = [UIColor colorWithHexString:@"0xd7d9d8"];
    _linLabel3.backgroundColor = [UIColor colorWithHexString:@"0xd7d9d8"];
    _linLabel4.backgroundColor = [UIColor colorWithHexString:@"0xd7d9d8"];
    
    _attLabel.backgroundColor = [UIColor clearColor];
    _fansLabel.backgroundColor = [UIColor clearColor];
    _sendMoneyLabel.backgroundColor = [UIColor clearColor];
    _ticketLabel.backgroundColor = [UIColor clearColor];
    
    _attLabel.textColor = [UIColor darkGrayColor];
    _fansLabel.textColor = [UIColor darkGrayColor];
    _sendMoneyLabel.textColor = [UIColor colorWithHexString:GiftUsualColor];
    _ticketLabel.textColor = [UIColor colorWithHexString:GiftUsualColor];
    
    _attLabel.textAlignment = NSTextAlignmentRight;
    _fansLabel.textAlignment = NSTextAlignmentRight;
    _sendMoneyLabel.textAlignment = NSTextAlignmentRight;
    _ticketLabel.textAlignment = NSTextAlignmentRight;
    
    _attLabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    _fansLabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    _sendMoneyLabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    _ticketLabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    
    [_attButton setTitleColor:[UIColor colorWithHexString:GiftUsualColor] forState:UIControlStateNormal];
    [_inboxButton setTitleColor:[UIColor colorWithHexString:GiftUsualColor] forState:UIControlStateNormal];
    [_selfButton setTitleColor:[UIColor colorWithHexString:GiftUsualColor] forState:UIControlStateNormal];
    [_selfButton setBackgroundColor:[UIColor colorWithHexString:@"0xf9f3f3"]];
    
    [_leftTopButton setTitleColor:[UIColor colorWithHexString:GiftUsualColor] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tapGeR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPersonInfoView:)];
    tapGeR.delegate = self;
    [self addGestureRecognizer:tapGeR];
    
    vip_icon = [UIImageView new];
    vip_icon.size = CGSizeMake(18, 18);
    vip_icon.origin = CGPointMake(_headerBGView.origin.x+_headerBGView.width-18, _headerBGView.origin.y+_headerBGView.height-18);
    vip_icon.image = [UIImage imageNamed:@"vip_icon"];
    vip_icon.hidden = YES;
    [self.topView addSubview:vip_icon];
    
}





- (void)setPersonInfoViewUIwithPersonInfoModel:(PersonInfoModel*)personInfoModel
{
    _headerBGView.layer.cornerRadius = _headerBGView.height/2;
    _headerBGView.clipsToBounds = YES;
    _headerImageView.layer.cornerRadius = _headerImageView.height/2;
    _headerImageView.clipsToBounds = YES;
    _linLabel3.top = 0;
    _linLabel3.height = 0.25;
    
    _perInfoModel = personInfoModel;
    [_headerImageView setImageWithUrlString:personInfoModel.headportrait placeholderImage:[UIImage imageByApplyingAlpha:1 color:[UIColor darkGrayColor]]];
    
    if (personInfoModel.super_vip.intValue) {
        vip_icon.origin = CGPointMake(_headerBGView.right-21, _headerBGView.bottom-21);
        vip_icon.hidden = NO;
    }else{
        vip_icon.hidden = YES;
    }
    
    _nameLabel.attributedText = nil;
    [_nameLabel appendText:personInfoModel.nick];
    [_nameLabel appendText:@" "];
    if (personInfoModel.gender.intValue) {
        [_nameLabel appendImage:[UIImage imageNamed:@"me_sex1"]];
    }else{
        [_nameLabel appendImage:[UIImage imageNamed:@"me_sex2"]];
    }
    [_nameLabel appendText:@" "];
    [_nameLabel appendView:[self getUserLevelViewWithLevelString:personInfoModel.level]];
    
    _roomIdLabel.attributedText = nil;
    _roomIdLabel.text = [NSString stringWithFormat:@"房间号: %@",personInfoModel.room_id];
    
    _signatureLabel.attributedText = nil;
    _signatureLabel.text = personInfoModel.emotion;
    
    _attLabel.attributedText = nil;
    CGFloat attNum = personInfoModel.attention.floatValue;
    if (attNum >10000) {
        attNum = attNum/10000.00;
        _attLabel.text = [NSString stringWithFormat:@"关注: %.2f万",attNum];
    }else{
        _attLabel.text = [NSString stringWithFormat:@"关注: %@",personInfoModel.attention];
    }
    
    
    _fansLabel.attributedText = nil;
    CGFloat fansNum = personInfoModel.fans.floatValue;
    if (fansNum >10000) {
        fansNum = fansNum/10000.00;
        _fansLabel.text = [NSString stringWithFormat:@"粉丝: %.2f万",fansNum];
    }else{
        _fansLabel.text = [NSString stringWithFormat:@"粉丝: %@",personInfoModel.fans];
    }
    
    _sendMoneyLabel.attributedText = nil;
    CGFloat sendNum = personInfoModel.send_gold.floatValue;
    if (sendNum>100000000){
        sendNum = sendNum/100000000.00;
        [_sendMoneyLabel appendText:[NSString stringWithFormat:@"送出: %.2f亿",sendNum]];
        [_sendMoneyLabel appendImage:[UIImage imageNamed:@"room_money"]];
    }else if (sendNum>10000){
        sendNum = sendNum/10000.00;
        [_sendMoneyLabel appendText:[NSString stringWithFormat:@"送出: %.2f万",sendNum]];
        [_sendMoneyLabel appendImage:[UIImage imageNamed:@"room_money"]];
    }else{
        [_sendMoneyLabel appendText:[NSString stringWithFormat:@"送出: %@",personInfoModel.send_gold]];
        [_sendMoneyLabel appendImage:[UIImage imageNamed:@"room_money"]];
    }
    
    _ticketLabel.attributedText = nil;
    CGFloat pointsNum = personInfoModel.points.floatValue;
    
    if (pointsNum>100000000){
        pointsNum = pointsNum/100000000.00;
        [_ticketLabel appendText:[NSString stringWithFormat:@"球票: %.2f亿",pointsNum]];
    }else if (pointsNum>10000){
        pointsNum = pointsNum/10000.00;
        [_ticketLabel appendText:[NSString stringWithFormat:@"球票: %.2f万",pointsNum]];
    }else{
        [_ticketLabel appendText:[NSString stringWithFormat:@"球票: %@",personInfoModel.points]];
    }
    
    if ([personInfoModel.pid isEqualToString:_userModel.pid]) {
        _selfButton.hidden = NO;
        _leftTopButton.hidden = YES;
    }else{
        _selfButton.hidden = YES;
        _leftTopButton.hidden = NO;
        if (personInfoModel.isAttention.intValue == 1) {
            [_attButton setTitle:@"已关注" forState:UIControlStateNormal];
            _attButton.enabled = NO;
        }else{
            [_attButton setTitle:@"关注" forState:UIControlStateNormal];
            _attButton.enabled = YES;
        }
    }
}

- (IBAction)closeButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(closePersonInfoViewButtonAction)]) {
        [_delegate closePersonInfoViewButtonAction];
    }
}
- (IBAction)leftTopButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(personInfoViewLeftTopButtonManageAction:)]) {
        [_delegate personInfoViewLeftTopButtonManageAction:_perInfoModel];
    }
}



- (IBAction)attButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(personInfoViewAttButtonAction:)]) {
        [_delegate personInfoViewAttButtonAction:_perInfoModel];
    }
}
- (IBAction)inboxButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(personInfoViewInboxButtonAction:)]) {
        [_delegate personInfoViewInboxButtonAction:_perInfoModel];
    }
}

- (IBAction)selfButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(personInfoViewSelfButtonAction:)]) {
        [_delegate personInfoViewSelfButtonAction:_perInfoModel];
    }
}
- (IBAction)headerImageButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(personInfoViewHeaderImageButtonClickAction:)]) {
        [_delegate personInfoViewHeaderImageButtonClickAction:_perInfoModel];
    }
}




- (void)tapPersonInfoView:(UITapGestureRecognizer *)tapGeR
{
    if (tapGeR.view == self) {
        if ([_delegate respondsToSelector:@selector(closePersonInfoViewButtonAction)]) {
            [_delegate closePersonInfoViewButtonAction];
        }
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_contentView]) {
        return NO;
    }
    return YES;
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
