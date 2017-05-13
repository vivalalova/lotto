//
//  timer.m
//  circleDemo
//
//  Created by coolyouimac01 on 16/4/1.
//  Copyright © 2016年 coolyouimac01. All rights reserved.
//

#import "SendGiftButton.h"

@interface SendGiftButton ()

@end
@implementation SendGiftButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor=[UIColor clearColor];
        self.layer.masksToBounds=YES;
        self.layer.cornerRadius=self.frame.size.width/2;
    }
    return self;
}
-(void)setTextBgColor:(UIColor *)textBgColor{
    _textBgColor=textBgColor;
    [self createTextLbl];
}
-(void)createTextLbl{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width*0.85, self.frame.size.width*0.85)];
    if (_text) {
       label.text=_text;
    }
    label.font=[UIFont systemFontOfSize:15];
    label.textColor=[UIColor whiteColor];
    label.backgroundColor=_textBgColor;
    label.layer.masksToBounds=YES;
    label.layer.cornerRadius=label.frame.size.width/2;
    label.textAlignment=NSTextAlignmentCenter;
    [label setCenter:CGPointMake(self.frame.size.width/2, self.frame.size.width/2)];
    [self addSubview:label];
}

- (void)refreshUI:(float )a{
    _currentProgress=a;
    [self setNeedsDisplay];
}
- (void)drawRect:(CGRect)rect {
    CGFloat lineWidth = 1.f;
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = lineWidth;
    processBackgroundPath.lineCapStyle = kCGLineCapRound;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - lineWidth)/2;
    CGFloat startAngle = - ((float)M_PI / 2);
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [self.tintBgColor set];
    [processBackgroundPath stroke];
    
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    processPath.lineCapStyle = kCGLineCapRound;
    processPath.lineWidth = lineWidth;
    endAngle = ( _currentProgress/_progress* 2 * (float)M_PI) + startAngle;
    [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    [self.tintColor set];
    [processPath stroke];
}
-(void)dealloc{
   
}
@end
