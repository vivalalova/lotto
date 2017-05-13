//
//  PhoneLiveCell.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/4/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PhoneLiveCell.h"
#import "M80AttributedLabel.h"
#import "SocketMessageModel.h"
#import "GiftOneModel.h"
#import "UserWelcomeModel.h"
#import "UserSendGiftModel.h"
#define kNameColor [UIColor colorWithHexString:@"0xf9d28c"]
@interface PhoneLiveCell ()
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end
@implementation PhoneLiveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bgView.backgroundColor=[UIColor clearColor];
    _contentLbl.textColor=[UIColor whiteColor];
    _contentLbl.shadowColor=[UIColor blackColor];
    _contentLbl.shadowBlur=2.0f;
    _contentLbl.shadowOffset=CGSizeMake(0, 1);
    self.backgroundColor = [UIColor clearColor];
}
- (IBAction)selectbuttonclick:(id)sender {
    if (![NSString isBlankString:_uid]) {
        if (self.delegate&&[self.delegate respondsToSelector:@selector(showVisitorInfoOfChatUsualCell:)]) {
            [self.delegate showVisitorInfoOfChatUsualCell:_uid];
        }
    }
}
-(void)setMsgStr:(NSString *)msgStr{
    _msgStr=msgStr;
    _contentLbl.attributedText=nil;
    if (_font>0) {
        _contentLbl.font=[UIFont systemFontOfSize:_font];
    }
    if (_msgColor) {
        [_contentLbl setTextColor:_msgColor];
    }
    [_contentLbl appendText:msgStr];
}
-(void)setUserWelcomeModel:(UserWelcomeModel *)userWelcomeModel{
    _userWelcomeModel=userWelcomeModel;
    _contentLbl.attributedText=nil;
    if (_font>0) {
        _contentLbl.font=[UIFont systemFontOfSize:_font];
    }
    [_contentLbl setTextColor:kNameColor];
    if (![NSString isBlankString:userWelcomeModel.username]&&![NSString isBlankString:userWelcomeModel.richlevel]) {
        [_contentLbl appendText:@"欢迎"];
        UIView *levelView = [self getUserLevelViewWithLevelString:userWelcomeModel.richlevel];
        [_contentLbl appendView:levelView];
        [_contentLbl appendText:@" "];
        //VIP
        if([userWelcomeModel.super_vip intValue]!=0){
            [_contentLbl appendView:[self getUserVIPView]];
            [_contentLbl appendText:@" "];
        }
        NSString *userName = [userWelcomeModel.username stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *userNameStr=[NSString stringWithFormat:@"%@进入频道",[NSString isBlankString:userName]?@"游客":userName];
        [_contentLbl appendText:userNameStr];
    }else{
        [_contentLbl appendText:@"欢迎游客进入频道"];
    }
}
-(void)setDataWithUserSendGiftModel:(UserSendGiftModel*)userSendGiftModel withGiftOneModel:(GiftOneModel*)giftOneModel
{
//送礼物信息
    _userSendGiftModel=userSendGiftModel;
    _giftOneModel = giftOneModel;
    _contentLbl.attributedText=nil;
    if (_font>0) {
        _contentLbl.font=[UIFont systemFontOfSize:_font];
    }
    [_contentLbl setTextColor:[UIColor whiteColor]];
    if ([userSendGiftModel.richlevel intValue]>0){
        UIView *levelView = [self getUserLevelViewWithLevelString:userSendGiftModel.richlevel];
        [_contentLbl appendView:levelView];
        [_contentLbl appendText:@" "];
    }
    //VIP
    if([userSendGiftModel.super_vip intValue]!=0){
        [_contentLbl appendView:[self getUserVIPView]];
        [_contentLbl appendText:@" "];
    }
    NSString *nameStr = [userSendGiftModel.fromUser stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *giftNumString;
    if (!_isAnchorBool) {
        giftNumString = [NSString stringWithFormat:@"%@送给主播%@个%@",nameStr,userSendGiftModel.giftcount,giftOneModel.gname];
    }else{
        giftNumString = [NSString stringWithFormat:@"%@送给您%@个%@",nameStr,userSendGiftModel.giftcount,giftOneModel.gname];
    }
    if (![NSString isBlankString:userSendGiftModel.roomid]) {
        giftNumString = [NSString stringWithFormat:@"%@在[%@]直播间送出了%@个%@",nameStr,userSendGiftModel.roomid,userSendGiftModel.giftcount,giftOneModel.gname];
    }
    [_contentLbl appendText:giftNumString];
    WebImageView *imageView = [[WebImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    [imageView setImageWithUrlString:[NSString stringWithFormat:@"%@%@.png",self.giftPicBaseUrlStr,giftOneModel.gpic]];
    [_contentLbl appendView:imageView];
    [_contentLbl appendText:[NSString stringWithFormat:@"x%@",userSendGiftModel.giftcount]];
}
-(void)setMessageDict:(NSDictionary *)messageDict{
    _messageDict=messageDict;
    _contentLbl.attributedText=nil;
    if (_font>0) {
        _contentLbl.font=[UIFont systemFontOfSize:_font];
    }
    [_contentLbl setTextColor:[UIColor orangeColor]];
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
        [_contentLbl appendText:chatText];
    }
    if ([[messageDict objectForKey:@"messageType"]isEqualToString:@"set manager level success"]) {
        NSString *chatText=@"";
        if ([messageDict[@"level"]intValue]==3) {
            chatText=[NSString stringWithFormat:@"你已将%@任命为超管成功",[messageDict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
        }
        if ([messageDict[@"level"]intValue]==2) {
            chatText=[NSString stringWithFormat:@"你已将%@任命为管理员成功",[messageDict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
        }
         [_contentLbl appendText:chatText];
    }
    if ([[messageDict objectForKey:@"messageType"]isEqualToString:@"set normal level"]) {
        NSString *chatText=@"";
        if ([messageDict[@"manager_level"]intValue]==4) {
            chatText=[NSString stringWithFormat:@"主播:%@将%@贬为普通用户",[messageDict[@"manager"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ,[messageDict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
        }
        if ([messageDict[@"manager_level"]intValue]==3) {
            chatText=[NSString stringWithFormat:@"超管:%@将%@贬为普通用户",[messageDict[@"manager"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ,[messageDict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];        }
         [_contentLbl appendText:chatText];
    }
    if ([[messageDict objectForKey:@"messageType"]isEqualToString:@"set normal level success"]) {
        NSString * chatText=[NSString stringWithFormat:@"你已将%@贬为普通用户成功",[messageDict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
         [_contentLbl appendText:chatText];
    }
}
-(void)setUpdateDict:(NSDictionary *)updateDict{
    _updateDict=updateDict;
    _contentLbl.attributedText=nil;
    if (_font>0) {
        _contentLbl.font=[UIFont systemFontOfSize:_font];
    }
    [_contentLbl setTextColor:[UIColor orangeColor]];
    NSString *message=[updateDict objectForKey:@"userUpdateMessage"];
    NSString *messageStr = [message stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [_contentLbl appendText:messageStr];
    if (![NSString isBlankString:updateDict[@"richlevel"]]) {
        [_contentLbl appendImage:[UIImage imageNamed:[NSString stringWithFormat:@"Wealth level_%@",[updateDict objectForKey:@"level"]]]];
    }else{
        if ([[updateDict objectForKey:@"level"]intValue] <= 10) {
            [_contentLbl appendImage:[UIImage imageNamed:[NSString stringWithFormat:@"Anchor class_%@",[updateDict objectForKey:@"level"]]]];
        }else {
            [_contentLbl appendImage:[UIImage imageNamed:[NSString stringWithFormat:@"主播等级2_%d",([[updateDict objectForKey:@"level"]intValue]-10 )]]];
        }
    }
}
-(void)setBubbleDict:(NSDictionary *)bubbleDict{
    _bubbleDict=bubbleDict;
    _contentLbl.attributedText=nil;
    if (_font>0) {
        _contentLbl.font=[UIFont systemFontOfSize:_font];
    }
    [_contentLbl setTextColor:[UIColor whiteColor]];
    NSString *name=[[bubbleDict objectForKey:@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *str=[NSString stringWithFormat:@"%@ 我点亮了",name];
    [_contentLbl appendText:str];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"heart-%d",[[bubbleDict objectForKey:@"color"]intValue]]]];
    [_contentLbl appendView:imageView];
}
-(void)setSocketMessageModel:(SocketMessageModel *)socketMessageModel{
    _socketMessageModel = socketMessageModel;
    _contentLbl.attributedText=nil;
    if (_font>0) {
        _contentLbl.font=[UIFont systemFontOfSize:_font];
    }
    [_contentLbl setTextColor:[UIColor whiteColor]];
    //级别
    if([socketMessageModel.richlevel intValue]!=0){
        UIView *levelView = [self getUserLevelViewWithLevelString:socketMessageModel.richlevel];
        [_contentLbl appendView:levelView];
        [_contentLbl appendText:@" "];
    }
    //VIP
    if([socketMessageModel.super_vip intValue]!=0){
        [_contentLbl appendView:[self getUserVIPView]];
        [_contentLbl appendText:@" "];
    }
    
    //手机图标
    if ([socketMessageModel.clienttype isEqualToString:@"2"]) {
        // iPhone手机用户
        [_contentLbl appendImage:[UIImage imageNamed:@"UserPhoneType_iPhone"]];
        [_contentLbl appendText:@" "];
    } else if ([socketMessageModel.clienttype isEqualToString:@"1"] ) {
        // Android手机用户
        [_contentLbl appendImage:[UIImage imageNamed:@"UserPhoneType_Android"]];
        [_contentLbl appendText:@" "];
    }
    //管理级别
    if ([socketMessageModel.manager_level isEqualToString:@"2"]) {
        // 普通管理员
        [_contentLbl appendImage:[UIImage imageNamed:@"ManagerLevel_guan"]];
        [_contentLbl appendText:@" "];
    } else if ([socketMessageModel.manager_level isEqualToString:@"3"]) {
        // 超级管理员
        [_contentLbl appendImage:[UIImage imageNamed:@"ManagerLevel_chao"]];
        [_contentLbl appendText:@" "];
    }
    //周星
    for (int i=0; i<socketMessageModel.regal.count; i++) {
        WebImageView *imageView = [[WebImageView alloc]initWithFrame:CGRectMake(i*20, 0, 20, 20)];
        [imageView setImageWithURL:[NSURL URLWithString:[socketMessageModel.regal objectAtIndex:i]]];
        UIImage *image=[self imageCompressForSize:imageView.image targetSize:CGSizeMake(21, 21)];
        [_contentLbl appendImage:image];
        [_contentLbl appendText:@" "];
    }
    //名字
    NSString *nameStr = [socketMessageModel.fromUser stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *nameString = [NSString stringWithFormat:@"%@:",nameStr];
    NSMutableAttributedString *name=[[NSMutableAttributedString alloc]initWithString:nameString];
    [name addAttribute:NSForegroundColorAttributeName value:kNameColor range:NSMakeRange(0, name.length)];
    if(_font>0){
     [name addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:_font] range:NSMakeRange(0, name.length)];
    }
    [_contentLbl appendAttributedText:name];
    //聊天内容
    NSString *chatString = [socketMessageModel.msg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _contentLbl=[self emotionStrWithString:chatString plistName:@"emoticons.plist" label:_contentLbl];
    _contentLbl.lineSpacing=0.0;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    [_contentLbl setTop:0];
    CGSize size= [_contentLbl sizeThatFits:CGSizeMake(self.width-20, 100)];
    [_bgView setSize:CGSizeMake(size.width, size.height)];
    [_selectBtn setSize:_bgView.size];
    [_contentLbl setSize:size];
    [_contentLbl setLeft:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
-(UIImage *) imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
            
        }
        else{
            
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}
- (M80AttributedLabel *)emotionStrWithString:(NSString *)text plistName:(NSString *)plistName label:(M80AttributedLabel *)label{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:plistName ofType:nil];
    NSArray  *face = [NSArray arrayWithContentsOfFile:filePath];
    //1、创建一个可变的属性字符串00
    //2、通过正则表达式来匹配字符串
    //    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]"; //匹配表情
    NSString *regex_emoji = @"/[a-zA-Z]?[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]?[a-zA-Z0-9\u4e00-\u9fa5]?[a-zA-Z0-9\u4e00-\u9fa5]?[a-zA-Z0-9\u4e00-\u9fa5]?";
    
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        [label appendText:text];
        return label;
    }
    
    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    //3、获取所有的表情以及位置
    //用来存放字典，字典中存储的是图片和图片对应的位置
    NSMutableArray *imageArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    //根据匹配范围来用图片进行相应的替换
    for(NSTextCheckingResult *match in resultArray) {
        //获取数组元素中得到range
        NSRange range = [match range];
        //获取原字符串中对应的值
        NSString *subStr = [text substringWithRange:range];
        for (int i = 0; i < face.count; i ++) {
            if ([face[i][@"cht"] isEqualToString:subStr]) {
                //face[i][@"png"]就是我们要加载的图片
                UIImage* image = [UIImage imageNamed:face[i][@"png"]];
                //把图片和图片对应的位置存入字典中
                NSMutableDictionary *imageDic = [NSMutableDictionary dictionaryWithCapacity:2];
                [imageDic setObject:image forKey:@"image"];
                [imageDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                [imageDic setObject:subStr forKey:@"imageStr"];
                //把字典存入数组中
                [imageArray addObject:imageDic];
            }
        }
    }
    NSString *str2=text;
    for (NSDictionary *dict in imageArray) {
        NSString *str=[dict objectForKey:@"imageStr"];
        NSArray *array=[str2 componentsSeparatedByString:str];
        NSMutableString *str1=[[NSMutableString alloc]initWithString:@""];
        if ([[array firstObject]isEqualToString:str]) {
            UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
            imageview.image=[dict objectForKey:@"image"];
            imageview.backgroundColor=[UIColor clearColor];
            [label appendView:imageview];
            [str1 appendString:str];
        }else{
            [label appendText:[array firstObject]];
            UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
            imageview.image=[dict objectForKey:@"image"];
            imageview.backgroundColor=[UIColor clearColor];
            [label appendView:imageview];
            [str1 appendString:[array firstObject]];
            [str1 appendString:str];
        }
        str2=[str2 substringFromIndex:str1.length];
    }
    if (imageArray.count>0&&![NSString isBlankString:str2]) {
        [label appendText:str2];
    }
    if (imageArray.count==0) {
        [label appendText:text];
    }
    return label;
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
#pragma mark 获取VIP
- (UIView *)getUserVIPView
{
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 15, 15)];
    view.image = [UIImage imageNamed:@"vip_icon"];
    return view;
}

@end
