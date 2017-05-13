//
//  ChatPrivateCell.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/5/26.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ChatPrivateCell.h"
#import "ChatPrivateModel.h"
#import "MessListModel.h"
#import "M80AttributedLabel.h"
@interface ChatPrivateCell ()
{
    BOOL isSender;
}
@property (nonatomic, strong) WebImageView *headImageView;       //头像
@property (nonatomic, strong) UIView *bubbleView;   //内容区域
@property (strong, nonatomic) UIImageView *bubbleBgView;
@property (strong, nonatomic) M80AttributedLabel *contentLbl;
@property (strong, nonatomic) MessListModel *chatListModel;
@property (strong, nonatomic) ChatPrivateModel *chatPrivateModel;
@end
@implementation ChatPrivateCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configUI];
    }
    return self;
}
- (void)configUI{
    _headImageView=[[WebImageView alloc]initWithFrame:CGRectMake(0, 5, 45, 45)];
    _headImageView.layer.cornerRadius=_headImageView.height/2;
    _headImageView.layer.masksToBounds=YES;
    _bubbleView=[[UIView alloc]initWithFrame:CGRectZero];
    _bubbleView.backgroundColor=[UIColor clearColor];
    _bubbleBgView=[[UIImageView alloc]initWithFrame:CGRectZero];
    _bubbleBgView.userInteractionEnabled=YES;
    _contentLbl=[[M80AttributedLabel alloc]initWithFrame:CGRectZero];
    _contentLbl.font=[UIFont systemFontOfSize:12];
    _contentLbl.backgroundColor=[UIColor clearColor];
    [self.contentView addSubview:_headImageView];
    [self.contentView addSubview:_bubbleView];
    [_bubbleView addSubview:_bubbleBgView];
    [_bubbleBgView addSubview:_contentLbl];
    UILongPressGestureRecognizer *longPGR=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longClick:)];
    [_bubbleBgView addGestureRecognizer:longPGR];
}
-(void)longClick:(UILongPressGestureRecognizer *)gesture{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(delSingleMsgWithMsgID:rect:)]) {
        CGRect rect= [_bubbleBgView convertRect:_bubbleBgView.bounds toView:KAPP_WINDOW];
        [self.delegate delSingleMsgWithMsgID:_chatPrivateModel.msgid rect:rect];
    }
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _contentLbl.attributedText=nil;
    [_headImageView setTop:5];
    if ([_chatPrivateModel.from_uid isEqualToString:[AccountHelper uid]]) {
        isSender=YES;
        _contentLbl.textColor=[UIColor whiteColor];
    }else{
        isSender=NO;
        _contentLbl.textColor=[UIColor blackColor];
    }
    if (isSender==NO) {
        [_headImageView setLeft:10];
        if ([_chatListModel.user_head_img rangeOfString:URI_BASE_SERVER].location == NSNotFound) {
            [_headImageView setImageWithUrlString:[NSString stringWithFormat:@"%@%@",URI_BASE_SERVER,_chatListModel.user_head_img] placeholderImage:[UIImage imageNamed:@"150a.png"]];
        }else{
            [_headImageView setImageWithUrlString:[NSString stringWithFormat:@"%@",_chatListModel.user_head_img] placeholderImage:[UIImage imageNamed:@"150a.png"]];
        }
    }else{
        [_headImageView setRight:self.width-10];
        [_headImageView setImageWithUrlString:[AccountHelper userInfo].headportrait placeholderImage:[UIImage imageNamed:@"150a.png"]];
    }
    NSString *chatString = [_chatPrivateModel.msg stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    _contentLbl=[self emotionStrWithString:chatString plistName:@"emoticons.plist" label:_contentLbl];
    CGSize size= [_contentLbl sizeThatFits:CGSizeMake(self.width*0.8-10-_headImageView.height-20, 100)];
    if (size.height<25) {
        _bubbleView.frame=CGRectMake(0, 0, size.width+15, 25+10);
    }else{
        _bubbleView.frame=CGRectMake(0, 0, size.width+15, size.height+10);
    }
    [_bubbleView setTop:_headImageView.top+5];
    [_bubbleBgView setFrame:_bubbleView.bounds];
    [_contentLbl setFrame:CGRectMake(0, 0, size.width, size.height)];
    [_contentLbl setCenterY:_bubbleView.height/2];
    if (isSender==NO) {
        [_contentLbl setLeft:10];
        [_bubbleView setLeft:_headImageView.right+5];
         _bubbleBgView.image=[[UIImage imageNamed:@"Speech-Bubble.png"]stretchableImageWithLeftCapWidth:31 topCapHeight:31];
    }else{
        [_contentLbl setRight:_bubbleView.width-10];
        [_bubbleView setRight:_headImageView.left-5];
         _bubbleBgView.image=[[UIImage imageNamed:@"Bubbles.png"]stretchableImageWithLeftCapWidth:5 topCapHeight:31];
    }
}
- (void)setChatPrivateModel:(ChatPrivateModel *)chatPrivateModel chatListModel:(MessListModel *)chatListModel{
    _chatPrivateModel=chatPrivateModel;
    _chatListModel=chatListModel;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
