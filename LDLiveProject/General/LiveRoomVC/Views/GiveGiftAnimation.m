//
//  GiveGiftAnimation.m
//  气泡Demo
//
//  Created by coolyouimac01 on 15/12/17.
//  Copyright © 2015年 coolyouimac01. All rights reserved.
//

#import "GiveGiftAnimation.h"
#define kCoinCountKey   10     //每次动画显示图片总数
@interface GiveGiftAnimation()
{
    NSTimer *timer;
    BOOL isStop;
}
@property(nonatomic,strong)NSMutableArray *giftImageArray;//存放生成的所有imageView对应的tag值
@property(nonatomic,strong)NSMutableArray *giftArray;//存放所有image
@end
static int i=0;//记录点击的次数
static int sum=0;//记录当前创建的第几个imageView
@implementation GiveGiftAnimation
static id instance;
+(instancetype)shareAnimation{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}
-(instancetype)init{
    self=[super init];
    if (self) {
        isStop=YES;
    }
    return self;
}
-(void)start{
    if (isStop) {
        isStop=NO;
        i++;
        timer=[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
    }else{
        i++;
        if (![timer isValid]&&i==1) {
            timer=[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
        }
    }
}
-(void)setImage:(UIImage *)image{
    if (image!=nil) {
        [self.giftArray addObject:image];   
    }
}
-(NSMutableArray *)giftImageArray{
    if (_giftImageArray==nil) {
        _giftImageArray=[NSMutableArray array];
    }
    return _giftImageArray;
}
-(NSMutableArray *)giftArray{
    if (_giftArray==nil) {
        _giftArray=[NSMutableArray array];
    }
    return _giftArray;
}
-(void)timerClick{
    if (sum<(kCoinCountKey>_number?_number:kCoinCountKey)&&i>0) {
        [self initCoinViewWithInt:sum];
        sum++;
    }else{
        sum=0;
        if (i>0) {
            i--;
            if (self.giftArray.count>0) {
                [self.giftArray removeObjectAtIndex:0];
            }
        }else{
            [timer invalidate];
        }
    }
}
-(void)initCoinViewWithInt:(int)a{
    UIImageView *coin = [[UIImageView alloc] initWithImage:[self.giftArray firstObject]];
    if (CGRectGetMaxX(self.view.frame)>CGRectGetMaxY(self.view.frame)) {
        coin.center=CGPointMake(CGRectGetMaxX(self.view.frame)/5*4, CGRectGetMaxY(self.view.frame));
    }else{
        coin.center=CGPointMake(CGRectGetMaxX(self.view.frame)/5*4, CGRectGetMaxY(self.view.frame)-60);
    }
    coin.tag = a+1;
    [self.giftImageArray addObject:[NSNumber numberWithInt:(int)coin.tag]];
    [self.view addSubview:coin];
    [self setAnimationWithLayer:coin];
}
- (void)setAnimationWithLayer:(UIView *)coin
{
    CGFloat duration = 1.0f;
    CGFloat positionX;
    if (CGRectGetMaxX(self.view.frame)>CGRectGetMaxY(self.view.frame)) {
        positionX   = CGRectGetMaxX(self.view.frame)-arc4random()%(int)(CGRectGetMaxX(self.view.frame)/6)-70;
    }else{
        positionX   = CGRectGetMaxX(self.view.frame)-arc4random()%(int)(CGRectGetMaxX(self.view.frame)/5)-10;
    }
    CGFloat positionY;
    if (CGRectGetMaxX(self.view.frame)>CGRectGetMaxY(self.view.frame)) {
        positionY   = CGRectGetMaxY(self.view.frame)-CGRectGetMaxY(self.view.frame)/3*2;
    }else{
        positionY   = CGRectGetMaxY(self.view.frame)-CGRectGetMaxY(self.view.frame)/3;
    }
    CGMutablePathRef path = CGPathCreateMutable();
    int fromX       = (int)coin.layer.position.x;
    int height      = (int)coin.layer.position.y;
    CGFloat cpx = positionX + (fromX - positionX)/2;
    CGFloat cpy=0;
    if (CGRectGetMaxX(self.view.frame)>CGRectGetMaxY(self.view.frame)) {
        cpy = CGRectGetMaxY(self.view.frame);
    }else{
        cpy = CGRectGetMaxX(self.view.frame)+100;
    }
    //动画的起始位置
    CGPathMoveToPoint(path, NULL, fromX, height);
    CGPathAddQuadCurveToPoint(path, NULL, cpx, cpy, positionX, positionY);
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setPath:path];
    CFRelease(path);
    path = nil;
    
    //透明度变化
    CABasicAnimation *animation1=[CABasicAnimation animationWithKeyPath:@"opacity"];
    animation1.fromValue=[NSNumber numberWithFloat:1];
    animation1.toValue=[NSNumber numberWithFloat:0];
    animation.removedOnCompletion=NO;
    //图像由大到小的变化动画
    CGFloat to3DScale = 0.8+ arc4random() % 10 *0.005 ;
    CGFloat from3DScale  = to3DScale * 0.2;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(from3DScale, from3DScale, from3DScale)], [NSValue valueWithCATransform3D:CATransform3DMakeScale(to3DScale, to3DScale, to3DScale)]];
    scaleAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut], [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
    //动画组合
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = duration;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    group.animations = @[scaleAnimation, animation,animation1];
    [coin.layer addAnimation:group forKey:@"position and transform"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        //动画完成后把金币和数组对应位置上的tag移除
        UIView *coinView = (UIView *)[self.view viewWithTag:[[self.giftImageArray firstObject] intValue]];
        if(coinView){
            [coinView removeFromSuperview];
        }
        [self.giftImageArray removeObjectAtIndex:0];
        if (self.giftImageArray.count==0) {
            isStop=YES;
        }
    }
}
@end
