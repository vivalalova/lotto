//
//  PhoneLiveVipCell.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/5/11.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PhoneLiveVipCell.h"
#import "M80AttributedLabel.h"
//#import "UserChatModel.h"
@interface PhoneLiveVipCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet WebImageView *headImageView;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *contentLbl;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@end
@implementation PhoneLiveVipCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImageView.layer.cornerRadius = _headImageView.width/2;
    _headImageView.layer.masksToBounds = YES;
    _bgView.backgroundColor = [UIColor clearColor];
    _contentLbl.textColor=[UIColor whiteColor];
    self.backgroundColor = [UIColor clearColor];
}
- (IBAction)selectbuttonclick:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(showVisitorInformationOfChatCell:)]) {
        [self.delegate showVisitorInformationOfChatCell:_userChatModel];
    }
}
-(void)setUserChatModel:(UserChatModel *)userChatModel{
//    _userChatModel=userChatModel;
//    _contentLbl.attributedText=nil;
//    if (_font>0) {
//        _contentLbl.font=[UIFont systemFontOfSize:_font];
//    }
//    [_headImageView setImageWithUrlString:[userChatModel.vip_head_img PicUrlStringWithHostUrl] placeholderImage:[UIImage imageNamed:@"150a.png"]];
//    //级别
//    if([userChatModel.richlevel intValue]!=0){
//        [_contentLbl appendImage:[UIImage imageNamed:[NSString stringWithFormat:@"Wealth level_%@",userChatModel.richlevel]]];
//        [_contentLbl appendText:@" "];
//    }
//    //手机图标
//    if ([userChatModel.clienttype isEqualToString:@"2"]) {
//        // iPhone手机用户
//        [_contentLbl appendImage:[UIImage imageNamed:@"UserPhoneType_iPhone"]];
//        [_contentLbl appendText:@" "];
//    } else if ([userChatModel.clienttype isEqualToString:@"1"] ) {
//        // Android手机用户
//        [_contentLbl appendImage:[UIImage imageNamed:@"UserPhoneType_Android"]];
//        [_contentLbl appendText:@" "];
//    }
//    //管理级别
//    if ([userChatModel.manager_level isEqualToString:@"2"]) {
//        // 普通管理员
//        [_contentLbl appendImage:[UIImage imageNamed:@"ManagerLevel_guan"]];
//        [_contentLbl appendText:@" "];
//    } else if ([userChatModel.manager_level isEqualToString:@"3"]) {
//        // 超级管理员
//        [_contentLbl appendImage:[UIImage imageNamed:@"ManagerLevel_chao"]];
//        [_contentLbl appendText:@" "];
//    }
//    //周星
//    for (int i=0; i<userChatModel.regal.count; i++) {
//        WebImageView *imageView = [[WebImageView alloc]initWithFrame:CGRectMake(i*20, 0, 20, 20)];
//        [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/images/gift/%@.png",Host_Url,[userChatModel.regal objectAtIndex:i]]]];
//        UIImage *image=[self imageCompressForSize:imageView.image targetSize:CGSizeMake(21, 21)];
//        [_contentLbl appendImage:image];
//        [_contentLbl appendText:@" "];
//    }
//    //名字
//    NSString *nameStr = [userChatModel.fromUser stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *nameString = [NSString stringWithFormat:@"%@:",nameStr];
//    [_contentLbl appendText:nameString];
//    //聊天内容
//    NSString *chatString = [userChatModel.msg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    _contentLbl=[self emotionStrWithString:chatString plistName:@"emoticons.plist" label:_contentLbl];
}
-(void)layoutSubviews{
    [super layoutSubviews];
    _contentLbl.lineSpacing=0.0;
    CGSize size= [_contentLbl sizeThatFits:CGSizeMake(self.width-_headImageView.right-_headImageView.width-5, 40)];
    [_bgView setSize:CGSizeMake(size.width+_headImageView.right+10, 40)];
    [_selectBtn setSize:_bgView.size];
    [_contentLbl setSize:size];
    [_contentLbl setLeft:_headImageView.right+5];
    [_contentLbl setCenterY:_bgView.height/2];
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
@end
