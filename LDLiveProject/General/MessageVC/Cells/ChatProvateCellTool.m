//
//  ChatProvateCellTool.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/5/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ChatProvateCellTool.h"
#import "M80AttributedLabel.h"
@implementation ChatProvateCellTool
-(CGFloat)cellHeightWithMsg:(NSString *)msgStr maxWidth:(CGFloat)width{
     M80AttributedLabel *contentLbl=[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    contentLbl.font=[UIFont systemFontOfSize:12];
    NSString *chatString = [msgStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    contentLbl=[self emotionStrWithString:chatString plistName:@"emoticons.plist" label:contentLbl];
    CGSize size= [contentLbl sizeThatFits:CGSizeMake(width*0.8-10-45-20, 100)];
    CGRect rect;
    if (size.height<25) {
        rect=CGRectMake(0, 0, size.width+10, 25+10);
    }else{
        rect=CGRectMake(0, 0, size.width+10, size.height+10);
    }
    return rect.size.height+20;
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
