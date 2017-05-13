//
//  LiveCountDownView.m
//  LiveProject
//
//  Created by coolyouimac01 on 15/12/10.
//  Copyright © 2015年 Mac. All rights reserved.
//

#import "LiveCountDownView.h"
static int a=3;
@interface LiveCountDownView()
{
    NSTimer *timer;
}
@end
@implementation LiveCountDownView
-(void)awakeFromNib{
    [super awakeFromNib];
    //self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.5];
}
-(void)showInSuperView:(UIView *)view{
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.countNum setCenter:CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)];
    [self.countText setTop:self.countNum.bottom];
    [self showInView:view];
}
-(void)showInView:(UIView *)view {
    [view addSubview:self];
    [view bringSubviewToFront:self];
    [self startTimer];
}
-(void)hideFromView{
    [self removeFromSuperview];
    if ([_delegate respondsToSelector:@selector(didHideFromSuperView)]) {
        [_delegate didHideFromSuperView];
    }
}
-(void)startTimer{
    timer=[NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(countDownClick) userInfo:nil repeats:YES];
}
-(void)countDownClick{
    self.countNum.text=[NSString stringWithFormat:@"%d",a];
    a--;
    if (a<0) {
        a=3;
        [timer invalidate];
        [self hideFromView];
    }
}
-(void)dealloc{
    [timer invalidate];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
