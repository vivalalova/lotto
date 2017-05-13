//
//  PhoneLiveShareView.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/1/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PhoneLiveShareView.h"
#import "PhoneLiveBoxView.h"
#import "PhoneLiveShareButton.h"
@implementation PhoneLiveShareView{
    PhoneLiveBoxView * _boxView;
    NSArray *_titleArray;
    NSArray *_imageArray;
    NSArray *_highlightImageArray;
    CGRect frame;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor=[UIColor clearColor];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideView:)];
    [self addGestureRecognizer:tap];
}
-(void)hideView:(UITapGestureRecognizer *)tap{
    [self hideFromView];
}
-(void)showInView:(UIView *)view withRect:(CGRect)rect arrow:(CGFloat)position{
    frame=rect;
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    CGFloat width=110;
    CGFloat height=200;
    CGFloat x=frame.origin.x+frame.size.width/2-width/2;
    CGFloat y=frame.origin.y-height;
    _boxView=[[PhoneLiveBoxView alloc]initWithFrame:CGRectMake( x, y, width, height)];
    _boxView.arrowX = _arrowtype;
    _boxView.arrowSite=position;
    [self createShareButton];
    [self addSubview:_boxView];
    [self showInView:view];
}
-(void)showInView:(UIView *)view withRect:(CGRect)rect{
    [self showInView:view withRect:rect arrow:0.5];
}
-(void)createShareButton{
    _titleArray=@[@"微博",@"朋友圈",@"微信",@"QQ",@"QQ空间"];
    _imageArray=@[@"UMS_sina_off",@"UMS_wechat_timeline_off",@"UMS_wechat_off",@"UMS_qq_off",@"UMS_qzone_off"];
 _highlightImageArray=@[@"UMS_sina_icon",@"UMS_wechat_timeline_icon",@"UMS_wechat_icon",@"UMS_qq_icon",@"UMS_qzone_icon"];
    for(int i=0;i<_titleArray.count;i++){
        PhoneLiveShareButton *button=[PhoneLiveShareButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, _boxView.contentView.height/_titleArray.count*i, _boxView.contentView.width, _boxView.contentView.height/_titleArray.count)];
        [button setTitle:_titleArray[i] forState:UIControlStateNormal];
        [button setTitle:_titleArray[i] forState:UIControlStateHighlighted];
        [button setImage:[UIImage imageNamed:_imageArray[i]] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:_highlightImageArray[i]] forState:UIControlStateHighlighted];
        button.tag=i+100;
        [button.imageView setContentMode:UIViewContentModeCenter];
        [button.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [button addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_boxView.contentView addSubview:button];
    }
}
-(void)showInView:(UIView *)view {
    [view addSubview:self];
    [view bringSubviewToFront:self];
}
-(void)hideFromView{
    [self removeFromSuperview];
}
-(void)shareButtonClick:(UIButton *)button{
    if(_isSelfVideo){
        if (self.delegate&&[self.delegate respondsToSelector:@selector(selectButtonWithTag:type:)]) {
            [self.delegate selectButtonWithTag:button.tag-100 type:1];
        }
    }else{
        if (self.delegate&&[self.delegate respondsToSelector:@selector(selectButtonWithTag: type:)]) {
            [self.delegate selectButtonWithTag:button.tag-100 type:0];
        }
    }
}
@end
