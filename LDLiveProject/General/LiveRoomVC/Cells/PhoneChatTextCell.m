//
//  PhoneChatTextCell.m
//  LiveProject
//
//  Created by coolyouimac01 on 15/12/28.
//  Copyright © 2015年 Mac. All rights reserved.
//

#import "PhoneChatTextCell.h"
@interface PhoneChatTextCell ()

@end
@implementation PhoneChatTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    _chatText.textColor = [UIColor orangeColor];
    _chatText.backgroundColor = [UIColor clearColor];
    _chatText.font=[UIFont systemFontOfSize:_textFont>0?_textFont:13];
    _chatText.adjustsFontSizeToFitWidth=YES;
    _bgView.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    _bgView.tag = 19;
}
-(void)setChatTextStr:(NSString *)chatTextStr{
    CGFloat welcomeLabelWidth = [chatTextStr widthWithFont:[UIFont systemFontOfSize:_textFont>0?_textFont:13] boundingRectWithSize:CGSizeMake(self.width-40, 20)]+2;
    [_bgView setLeft:10];
    [_bgView setWidth:welcomeLabelWidth+20];
    _chatText.text=chatTextStr;
    
    [_chatText setLeft:10];
    [_chatText setWidth:welcomeLabelWidth];
    _bgView.layer.cornerRadius = _bgView.height/2;
    _bgView.layer.masksToBounds = YES;
    _chatText.font=[UIFont systemFontOfSize:_textFont>0?_textFont:13];
}
-(void)setMessageDict:(NSDictionary *)messageDict{
    _messageDict=messageDict;
    if ([[messageDict objectForKey:@"messageType"]isEqualToString:@"set manager level"]) {
        NSString *chatText=@"";
        if ([messageDict[@"manager_level"]intValue]==4) {
            if ([messageDict[@"level"]intValue]==3) {
                chatText=[NSString stringWithFormat:@"主播:%@任命%@为超管成功",[messageDict[@"manager"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ,[messageDict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
            }
            if ([messageDict[@"level"]intValue]==2) {
                chatText=[NSString stringWithFormat:@"主播:%@任命%@为管理员成功",[messageDict[@"manager"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[messageDict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
            }
        }
        if ([messageDict[@"manager_level"]intValue]==3) {
            if ([messageDict[@"level"]intValue]==2) {
                chatText=[NSString stringWithFormat:@"超管:%@任命%@为管理员成功",[messageDict[@"manager"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[messageDict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
            }
        }
        [self showChatText:chatText];
    }
    if ([[messageDict objectForKey:@"messageType"]isEqualToString:@"set manager level success"]) {
        NSString *chatText=@"";
        if ([messageDict[@"level"]intValue]==3) {
            chatText=[NSString stringWithFormat:@"你已将%@任命为超管成功",[messageDict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
        }
        if ([messageDict[@"level"]intValue]==2) {
            chatText=[NSString stringWithFormat:@"你已将%@任命为管理员成功",[messageDict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
        }
        [self showChatText:chatText];
    }
    if ([[messageDict objectForKey:@"messageType"]isEqualToString:@"set normal level"]) {
        NSString *chatText=@"";
        if ([messageDict[@"manager_level"]intValue]==4) {
                chatText=[NSString stringWithFormat:@"主播:%@将%@贬为普通用户",[messageDict[@"manager"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ,[messageDict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
        }
        if ([messageDict[@"manager_level"]intValue]==3) {
            chatText=[NSString stringWithFormat:@"超管:%@将%@贬为普通用户",[messageDict[@"manager"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ,[messageDict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];        }
        [self showChatText:chatText];
    }
    if ([[messageDict objectForKey:@"messageType"]isEqualToString:@"set normal level success"]) {
        NSString * chatText=[NSString stringWithFormat:@"你已将%@贬为普通用户成功",[messageDict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
        [self showChatText:chatText];
    }
}
- (void)showChatText:(NSString *)chatText{
    CGFloat welcomeLabelWidth = [chatText widthWithFont:[UIFont systemFontOfSize:_textFont>0?_textFont:13] boundingRectWithSize:CGSizeMake(self.width-40, 20)]+2;
    [_bgView setLeft:10];
    [_bgView setWidth:welcomeLabelWidth+20];
    _chatText.text=chatText;
    [_chatText setLeft:10];
    [_chatText setWidth:welcomeLabelWidth];
    _bgView.layer.cornerRadius = _bgView.height/2;
    _bgView.layer.masksToBounds = YES;
    _chatText.font=[UIFont systemFontOfSize:_textFont>0?_textFont:13];
}
-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}



//-(void)setDataWithUserSendGiftModel:(UserWelcomeModel*)userWelcomeModel{
//    if (![NSString isBlankString:userWelcomeModel.username]&&![NSString isBlankString:userWelcomeModel.richlevel]) {
//        _welcomeLbl.hidden=NO;
//        _levelImageView.hidden=NO;
//        CGFloat welcomeLabelWidth = [@"欢迎-" widthWithFont:[UIFont systemFontOfSize:11] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20)]+2;
//        _welcomeLbl.text=@"欢迎-";
//        [_welcomeLbl setLeft:10];
//        [_welcomeLbl setWidth:welcomeLabelWidth];
//        _levelImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"Wealth level_%@",userWelcomeModel.richlevel]];
//        NSString *userName = [userWelcomeModel.username stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//        NSString *userNameStr=[NSString stringWithFormat:@"%@-进入频道",[NSString isBlankString:userName]?@"游客":userName];
//        CGFloat nameLabelWidth = [userNameStr widthWithFont:[UIFont systemFontOfSize:11] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20)]+10;
//        _messageLbl.text=userNameStr;
//        [_levelImageView setLeft:_welcomeLbl.right];
//        [_messageLbl setLeft:(_levelImageView.right+2)];
//        [_messageLbl setWidth:nameLabelWidth];
//        [_welcomeBgView setWidth:(nameLabelWidth+_levelImageView.right+2)];
//    }else{
//        _welcomeLbl.hidden=YES;
//        _levelImageView.hidden=YES;
//        NSString *userNameStr=@"欢迎-游客-进入频道";
//        CGFloat nameLabelWidth = [userNameStr widthWithFont:[UIFont systemFontOfSize:11] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20)]+10;
//        _messageLbl.text=userNameStr;
//        [_messageLbl setLeft:10];
//        [_messageLbl setWidth:nameLabelWidth];
//        [_welcomeBgView setWidth:(nameLabelWidth+10)];
//    }
//    _welcomeBgView.layer.cornerRadius = _welcomeBgView.height/2;
//    _welcomeBgView.layer.masksToBounds = YES;
//}

@end
