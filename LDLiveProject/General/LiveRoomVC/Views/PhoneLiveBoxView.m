//
//  PhoneLiveBoxView.m
//
//  Created by coolyouimac01 on 16/1/4.
//  Copyright © 2016年 coolyouimac01. All rights reserved.
//

#import "PhoneLiveBoxView.h"
#import <QuartzCore/QuartzCore.h>
const CGFloat kArrowWidth = 16.0f;
const CGFloat kArrowHeight = 8.0f;
@implementation PhoneLiveBoxView {
    CGFloat                     _arrowPosition;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor clearColor];
        self.opaque = YES;
        [self createContentView];
    }
    return self;
}

-(void)setBgColor:(UIColor *)bgColor{
    _bgColor=bgColor;
    _contentView.backgroundColor=_bgColor;
}
- (void)createContentView{
    if (_contentView==nil) {
        _contentView=[[UIView alloc]initWithFrame:CGRectMake(kArrowHeight, kArrowHeight, self.frame.size.width-kArrowHeight*2, self.frame.size.height-kArrowHeight*2)];
        _contentView.layer.masksToBounds=YES;
        _contentView.layer.cornerRadius=5;
        if (_bgColor) {
            _contentView.backgroundColor=_bgColor;
        }else{
            _contentView.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
        }
        [self addSubview:_contentView];
    }else{
        [_contentView setFrame:CGRectMake(kArrowHeight, kArrowHeight, self.frame.size.width-kArrowHeight*2, self.frame.size.height-kArrowHeight*2)];
    }
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath* bezierPathTop = UIBezierPath.bezierPath;
    if (_arrowX==2){
        [bezierPathTop moveToPoint: CGPointMake(rect.size.width*0.75-kArrowWidth/2, kArrowHeight)];
        [bezierPathTop addLineToPoint: CGPointMake(rect.size.width*0.75, 0)];
        [bezierPathTop addLineToPoint: CGPointMake(rect.size.width*0.75+kArrowWidth/2, kArrowHeight)];
    }else if (_arrowX==1) {
        // liveroomvc sharebutton 箭头在右 
        [bezierPathTop moveToPoint: CGPointMake(rect.size.width-kArrowWidth/2, rect.size.height/2-kArrowHeight)];
        [bezierPathTop addLineToPoint: CGPointMake(rect.size.width-kArrowWidth/2, rect.size.height/2+kArrowHeight)];
        [bezierPathTop addLineToPoint: CGPointMake(rect.size.width, rect.size.height/2)];
    }else{
        // 其他默认情况 例如phoneliveroom 箭头在下
        [bezierPathTop moveToPoint: CGPointMake(rect.size.width*_arrowSite-kArrowWidth/2, rect.size.height-kArrowHeight)];
        [bezierPathTop addLineToPoint: CGPointMake(rect.size.width*_arrowSite+kArrowWidth/2, rect.size.height-kArrowHeight)];
        [bezierPathTop addLineToPoint: CGPointMake(rect.size.width*_arrowSite, rect.size.height)];
    }

    if (_bgColor) {
         [_bgColor setFill];
    }else{
        [[UIColor colorWithWhite:0 alpha:0.5]setFill];
    }
    [bezierPathTop fill];
}
@end
