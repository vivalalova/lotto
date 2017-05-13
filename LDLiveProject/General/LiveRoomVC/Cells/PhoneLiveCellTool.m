//
//  PhoneLiveCellTool.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/4/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PhoneLiveCellTool.h"
#import "GiftOneModel.h"
#import "SocketMessageModel.h"
#import "UserSendGiftModel.h"
#import "UserWelcomeModel.h"
#import "M80AttributedLabel.h"
@implementation PhoneLiveCellTool

-(CGSize)cellSizeWithMsg:(NSString *)msgStr maxWidth:(CGFloat)maxWidth minHeight:(CGFloat)minHeight font:(CGFloat)font{
    M80AttributedLabel *contentLbl=[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    if (font>0) {
        contentLbl.font=[UIFont systemFontOfSize:font];
    }
    contentLbl.attributedText=nil;
    [contentLbl appendText:msgStr];
    contentLbl.lineSpacing=0.0;
    return [contentLbl sizeThatFits:CGSizeMake(maxWidth, minHeight)];
}
-(CGSize)cellSizeWithWelcomeModel:(UserWelcomeModel *)model maxWidth:(CGFloat)maxWidth minHeight:(CGFloat)minHeight font:(CGFloat) font{
    M80AttributedLabel *contentLbl=[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    contentLbl.attributedText=nil;
    contentLbl.lineSpacing=0.0;
    if (font>0) {
        contentLbl.font=[UIFont systemFontOfSize:font];
    }
    if (![NSString isBlankString:model.username]&&![NSString isBlankString:model.richlevel]) {
        [contentLbl appendText:@"欢迎"];
        if ([model.richlevel intValue]>0) {
            UIView *levelView = [self getUserLevelViewWithLevelString:model.richlevel];
            [contentLbl appendView:levelView];
            [contentLbl appendText:@" "];
        }
        //VIP
        if([model.super_vip intValue]!=0){
            [contentLbl appendView:[self getUserVIPView]];
            [contentLbl appendText:@" "];
        }
        NSString *userName = [model.username stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *userNameStr=[NSString stringWithFormat:@"%@进入频道",[NSString isBlankString:userName]?@"游客":userName];
        [contentLbl appendText:userNameStr];
    }else{
        [contentLbl appendText:@"欢迎游客进入频道"];
    }
    return [contentLbl sizeThatFits:CGSizeMake(maxWidth, minHeight)];
}

-(CGSize)cellSizeWithGiftModel:(UserSendGiftModel *)model giftOneModel:(GiftOneModel *)giftOneModel maxWidth:(CGFloat)maxWidth minHeight:(CGFloat)minHeight font:(CGFloat) font isAnchorBool:(BOOL)isAnchorBool
{
     M80AttributedLabel *contentLbl=[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    contentLbl.attributedText=nil;
    contentLbl.lineSpacing=0.0;
    if (font>0) {
        contentLbl.font=[UIFont systemFontOfSize:font];
    }
    [contentLbl setTextColor:[UIColor whiteColor]];
    if ([model.richlevel intValue]!=0){
        UIView *levelView = [self getUserLevelViewWithLevelString:model.richlevel];
        [contentLbl appendView:levelView];
        [contentLbl appendText:@" "];
    }
    //VIP
    if([model.super_vip intValue]!=0){
        [contentLbl appendView:[self getUserVIPView]];
        [contentLbl appendText:@" "];
    }
    NSString *nameStr = [model.fromUser stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *giftNumString;
    if (!isAnchorBool) {
        giftNumString = [NSString stringWithFormat:@"%@送给主播%@个%@",nameStr,model.giftcount,giftOneModel.gname];
    }else{
        giftNumString = [NSString stringWithFormat:@"%@送给您%@个%@",nameStr,model.giftcount,giftOneModel.gname];
    }
    if (![NSString isBlankString:model.roomid]) {
        giftNumString = [NSString stringWithFormat:@"%@在[%@]直播间送出了%@个%@",nameStr,model.roomid,model.giftcount,giftOneModel.gname];
    }
    [contentLbl appendText:giftNumString];
    WebImageView *imageView = [[WebImageView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
    [imageView setImageWithUrlString:[NSString stringWithFormat:@"%@%@.png",self.giftPicBaseUrlStr,giftOneModel.gpic]];
    [contentLbl appendView:imageView];
    [contentLbl appendText:[NSString stringWithFormat:@"x%@",model.giftcount]];
    return [contentLbl sizeThatFits:CGSizeMake(maxWidth, minHeight)];
}
-(CGSize)cellSizeWithMsgDict:(NSDictionary *)dict maxWidth:(CGFloat)maxWidth minHeight:(CGFloat)minHeight font:(CGFloat) font{
    M80AttributedLabel *contentLbl=[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    if (font>0) {
        contentLbl.font=[UIFont systemFontOfSize:font];
    }
    contentLbl.attributedText=nil;
    contentLbl.lineSpacing=0.0;
    if ([[dict objectForKey:@"messageType"]isEqualToString:@"set manager level"]) {
        NSString *chatText=@"";
        if ([dict[@"manager_level"]intValue]==4) {
            if ([dict[@"level"]intValue]==3) {
                chatText=[NSString stringWithFormat:@"主播:%@任命%@为超管成功",[dict[@"manager"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ,[dict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
            }
            if ([dict[@"level"]intValue]==2) {
                chatText=[NSString stringWithFormat:@"主播:%@任命%@为管理员成功",[dict[@"manager"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[dict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
            }
        }
        if ([dict[@"manager_level"]intValue]==3) {
            if ([dict[@"level"]intValue]==2) {
                chatText=[NSString stringWithFormat:@"超管:%@任命%@为管理员成功",[dict[@"manager"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[dict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
            }
        }
        [contentLbl appendText:chatText];
    }
    if ([[dict objectForKey:@"messageType"]isEqualToString:@"set manager level success"]) {
        NSString *chatText=@"";
        if ([dict[@"level"]intValue]==3) {
            chatText=[NSString stringWithFormat:@"你已将%@任命为超管成功",[dict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
        }
        if ([dict[@"level"]intValue]==2) {
            chatText=[NSString stringWithFormat:@"你已将%@任命为管理员成功",[dict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
        }
        [contentLbl appendText:chatText];
    }
    if ([[dict objectForKey:@"messageType"]isEqualToString:@"set normal level"]) {
        NSString *chatText=@"";
        if ([dict[@"manager_level"]intValue]==4) {
            chatText=[NSString stringWithFormat:@"主播:%@将%@贬为普通用户",[dict[@"manager"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ,[dict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
        }
        if ([dict[@"manager_level"]intValue]==3) {
            chatText=[NSString stringWithFormat:@"超管:%@将%@贬为普通用户",[dict[@"manager"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ,[dict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];        }
        [contentLbl appendText:chatText];
    }
    if ([[dict objectForKey:@"messageType"]isEqualToString:@"set normal level success"]) {
        NSString * chatText=[NSString stringWithFormat:@"你已将%@贬为普通用户成功",[dict[@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
        [contentLbl appendText:chatText];
    }
    return [contentLbl sizeThatFits:CGSizeMake(maxWidth, minHeight)];
}
-(CGSize)cellSizeWithUpdateDict:(NSDictionary *)dict maxWidth:(CGFloat)maxWidth minHeight:(CGFloat)minHeight font:(CGFloat) font{
    M80AttributedLabel *contentLbl=[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    if (font>0) {
        contentLbl.font=[UIFont systemFontOfSize:font];
    }
    contentLbl.attributedText=nil;
    contentLbl.lineSpacing=0.0;
    NSString *message=[dict objectForKey:@"userUpdateMessage"];
    NSString *messageStr = [message stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [contentLbl appendText:messageStr];
    if (![NSString isBlankString:dict[@"richlevel"]]) {
//        [contentLbl appendImage:[UIImage imageNamed:[NSString stringWithFormat:@"Wealth level_%@",[dict objectForKey:@"level"]]]];
    }else{
        if ([[dict objectForKey:@"level"]intValue] <= 10) {
            [contentLbl appendImage:[UIImage imageNamed:[NSString stringWithFormat:@"Anchor class_%@",[dict objectForKey:@"level"]]]];
        }else {
            [contentLbl appendImage:[UIImage imageNamed:[NSString stringWithFormat:@"主播等级2_%d",([[dict objectForKey:@"level"]intValue]-10 )]]];
        }
    }
    return [contentLbl sizeThatFits:CGSizeMake(maxWidth, minHeight)];
}
-(CGSize)cellSizeWithBubbleDict:(NSDictionary *)dict maxWidth:(CGFloat)maxWidth minHeight:(CGFloat)minHeight font:(CGFloat) font{
    M80AttributedLabel *contentLbl=[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    if (font>0) {
        contentLbl.font=[UIFont systemFontOfSize:font];
    }
    contentLbl.attributedText=nil;
    contentLbl.lineSpacing=0.0;
    NSString *name=[[dict objectForKey:@"user_name"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *str=[NSString stringWithFormat:@"%@ 我点亮了",name];
    [contentLbl appendText:str];
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    [imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"zhibotv_%d",[[dict objectForKey:@"color"]intValue]]]];
    [contentLbl appendView:imageView];
    return [contentLbl sizeThatFits:CGSizeMake(maxWidth, minHeight)];
}
-(CGSize)cellSizeWithModel:(SocketMessageModel *)sMessageModel maxWidth:(CGFloat)maxWidth minHeight:(CGFloat)minHeight font:(CGFloat)font{
    M80AttributedLabel *contentLbl=[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    if (font>0) {
        contentLbl.font=[UIFont systemFontOfSize:font];
    }
    contentLbl.attributedText=nil;
    //级别
    if([sMessageModel.richlevel intValue]!=0){
        UIView *levelView = [self getUserLevelViewWithLevelString:sMessageModel.richlevel];
        [contentLbl appendView:levelView];
        [contentLbl appendText:@" "];
    }
    if([sMessageModel.super_vip intValue]!=0){
        [contentLbl appendView:[self getUserVIPView]];
        [contentLbl appendText:@" "];
    }
    //手机图标
    if ([sMessageModel.clienttype isEqualToString:@"2"]) {
        // iPhone手机用户
        [contentLbl appendImage:[UIImage imageNamed:@"UserPhoneType_iPhone"]];
        [contentLbl appendText:@" "];
    } else if ([sMessageModel.clienttype isEqualToString:@"1"] ) {
        // Android手机用户
        [contentLbl appendImage:[UIImage imageNamed:@"UserPhoneType_Android"]];
        [contentLbl appendText:@" "];
    }
    //管理级别
    if ([sMessageModel.manager_level isEqualToString:@"2"]) {
        // 普通管理员
        [contentLbl appendImage:[UIImage imageNamed:@"ManagerLevel_guan"]];
        [contentLbl appendText:@" "];
    } else if ([sMessageModel.manager_level isEqualToString:@"3"]) {
        // 超级管理员
        [contentLbl appendImage:[UIImage imageNamed:@"ManagerLevel_chao"]];
        [contentLbl appendText:@" "];
    }
    //周星
    for (int i=0; i<sMessageModel.regal.count; i++) {
        WebImageView *imageView = [[WebImageView alloc]initWithFrame:CGRectMake(i*20, 0, 20, 20)];
        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/images/gift/%@.png",URI_BASE_SERVER,[sMessageModel.regal objectAtIndex:i]]]];
        UIImage *image=[self imageCompressForSize:imageView.image targetSize:CGSizeMake(21, 21)];
        [contentLbl appendImage:image];
        [contentLbl appendText:@" "];
    }
    //名字
    NSString *nameStr = [sMessageModel.fromUser stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *nameString = [NSString stringWithFormat:@"%@:",nameStr];
    NSMutableAttributedString *name=[[NSMutableAttributedString alloc]initWithString:nameString];
    [name addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"0xe5dfa7"] range:NSMakeRange(0, name.length)];
    if(font>0){
        [name addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:font] range:NSMakeRange(0, name.length)];
    }
    [contentLbl appendAttributedText:name];
    //聊天内容
    NSString *chatString = [sMessageModel.msg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    contentLbl=[self emotionStrWithString:chatString plistName:@"emoticons.plist" label:contentLbl];
    contentLbl.lineSpacing=0.0;
    return [contentLbl sizeThatFits:CGSizeMake(maxWidth, minHeight)];
}
- (M80AttributedLabel *)emotionStrWithString:(NSString *)text plistName:(NSString *)plistName label:(M80AttributedLabel *)label{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:plistName ofType:nil];
    NSArray  *face = [NSArray arrayWithContentsOfFile:filePath];
    //1、通过正则表达式来匹配字符串
    //    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]"; //匹配表情
    NSString *regex_emoji = @"/[a-zA-Z]?[a-zA-Z\u4e00-\u9fa5][a-zA-Z0-9\u4e00-\u9fa5]?[a-zA-Z0-9\u4e00-\u9fa5]?[a-zA-Z0-9\u4e00-\u9fa5]?[a-zA-Z0-9\u4e00-\u9fa5]?";
    
    NSError *error = nil;
    NSRegularExpression *re = [NSRegularExpression regularExpressionWithPattern:regex_emoji options:NSRegularExpressionCaseInsensitive error:&error];
    if (!re) {
        NSLog(@"%@", [error localizedDescription]);
        [label appendText:text];
        return label;
    }
    
    NSArray *resultArray = [re matchesInString:text options:0 range:NSMakeRange(0, text.length)];
    //2、获取所有的表情以及位置
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
//重画image
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
