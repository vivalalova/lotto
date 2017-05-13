//
//  VIPComeInAnimation.m
//  LDLiveProject
//
//  Created by MAC on 16/9/26.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "VIPComeInAnimation.h"

#define kCoinCountKey   10     //每次动画显示图片总数

@implementation VIPComeInAnimation

-(instancetype)init{
    self=[super init];
    if (self) {
        self.animationBool=NO;
        self.dataArray = [NSMutableArray array];
    }
    return self;
}

- (CKShimmerLabel *)shimmerLabel
{
    if (!_shimmerLabel) {
        _shimmerLabel = [[CKShimmerLabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/5*3, 30)];
        _shimmerLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        _shimmerLabel.layer.cornerRadius = 5;
        _shimmerLabel.layer.masksToBounds = YES;
        _shimmerLabel.textColor = [UIColor yellowColor];
        _shimmerLabel.shimmerType = ST_AutoReverse;
        _shimmerLabel.durationTime = 0.5;
        _shimmerLabel.shimmerColor = [UIColor redColor];
    }
    return _shimmerLabel;
}

- (void)startVipComeInAnimation{
    if (!self.animationBool) {
        
    if (_dataArray.count>0) {
        UserWelcomeModel *model=nil;
        model=[_dataArray firstObject];
        [self showInView:_superView position:CGPointMake(_position.x, _position.y) duration:4 delay:0 userWelcomeModel:[_dataArray firstObject]];
        self.animationBool = YES;
    }
        
    }
}
- (void)showInView:(UIView *)view position:(CGPoint)point duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay userWelcomeModel:(UserWelcomeModel *)model
{
    
    NSString *words = @"    欢迎";
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:words attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]}];
    
    NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attatch.bounds = CGRectMake(3, -1, 30, 15);
    attatch.image = [UIImage imageNamed:[NSString stringWithFormat:@"level_%@",model.richlevel]];
    NSTextAttachment *attatch1 = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attatch1.bounds = CGRectMake(3, -1, 15, 15);
    attatch1.image = [UIImage imageNamed:@"vip_icon"];
    NSAttributedString *string8 = [NSAttributedString attributedStringWithAttachment:attatch];
    NSAttributedString *string9 = [NSAttributedString attributedStringWithAttachment:attatch1];
    NSAttributedString *str999 = [[NSAttributedString alloc]initWithString:@" "];
    [strAtt appendAttributedString:string8];
    [strAtt appendAttributedString:str999];
    [strAtt appendAttributedString:string9];
    [strAtt appendAttributedString:str999];
    NSString *userName = [model.username stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *userNameStr=[NSString stringWithFormat:@"%@进入频道",userName];
    NSAttributedString *str10 = [[NSAttributedString alloc]initWithString:userNameStr];
    [strAtt appendAttributedString:str10];
    self.shimmerLabel.attributedText = strAtt;
    [self.shimmerLabel startShimmer];
    [view addSubview:self.shimmerLabel];
    [self.shimmerLabel setTop:point.y];
    [self.shimmerLabel setLeft:point.x];
    
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        self.shimmerLabel.left = 0;
    } completion:^(BOOL finished) {
        if (_dataArray.count>0) {
            [self performSelector:@selector(hideFromView) withObject:self.shimmerLabel afterDelay:1];
        }else{
            self.animationBool = NO;
        }
    }];
}


- (void)hideFromView
{
    [self.shimmerLabel stopShimmer];
    [self.shimmerLabel removeFromSuperview];
    self.shimmerLabel = nil;
    if (_dataArray.count>0) {
        [self startVipComeInAnimation];
    }
}



@end
