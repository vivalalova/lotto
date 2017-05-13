//
//  DansView.m
//  DansDemo
//
//  Created by coolyouimac02 on 16/6/20.
//  Copyright © 2016年 coolyouimac02. All rights reserved.
//

#import "DansView.h"

CGFloat const padding = 0.25;

@interface DansView ()
{
    __weak IBOutlet WebImageView *headImGView;

    __weak IBOutlet UILabel *nameLabel;
    
    __weak IBOutlet UILabel *titleLabel;
    
    __weak IBOutlet UIView *titleBGView;
    
    NSTimer *_mytimer;
    
    int count;
}

@end

@implementation DansView

- (void)awakeFromNib
{
    headImGView.layer.cornerRadius = headImGView.frame.size.height/2;
    headImGView.layer.masksToBounds = YES;
    
    nameLabel.textColor = [UIColor colorWithHexString:GiftUsualColor];
    
    titleBGView.layer.cornerRadius = 10;
    titleBGView.layer.borderColor = [UIColor whiteColor].CGColor;
    titleBGView.layer.borderWidth = 1.0f;
    
    UIColor *color = [UIColor blackColor];
    titleBGView.backgroundColor = [color colorWithAlphaComponent:0.6];
   
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    CGFloat y;
    // 竖屏
    CGFloat yy = appDelegate.window.frame.size.height/2;
    y = [self getRandomNumber:50 to:yy+80];

    CGRect tmp = self.frame;
    CGFloat x = SCREEN_WIDTH + 20;
    tmp = CGRectMake(x, y, 163, 46);
    self.frame = tmp;

}
// 随机纵坐标
-(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

- (void)addTimer
{
    _mytimer = [NSTimer scheduledTimerWithTimeInterval:0.0025 target:self selector:@selector(runTimer) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_mytimer forMode:NSRunLoopCommonModes];
}

- (void)removeTimer
{
    [_mytimer invalidate];
    _mytimer = nil;
    [self removeAllSubviews];
    [self removeFromSuperview];
}

- (void)runTimer
{
    CGFloat x = self.frame.origin.x;
    
    x -= padding;
    
    CGRect tmp = self.frame;
    tmp.origin.x = x;
    self.frame = tmp;
    
    CGRect newRect = [titleLabel convertRect:titleLabel.bounds toView:[UIApplication sharedApplication].keyWindow];
    if (CGRectGetMaxX(self.frame) < 0 && CGRectGetMaxX(newRect) < 0) {
        [self removeTimer];
    }
}

- (void)star
{
    [self addTimer];
}

#pragma mark - GetterAndSetter
- (void)setTitle:(NSString *)title
{
    _title = title;
    titleLabel.text = title;
    
    CGFloat width = [titleLabel.text widthWithFont:[UIFont boldSystemFontOfSize:14] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20)]+40;
    titleBGView.width = width;
    
}

- (void)setName:(NSString *)name
{
    _name = name;
    nameLabel.text = name;
    
    CGFloat width = [nameLabel.text widthWithFont:[UIFont boldSystemFontOfSize:14] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20)]+40;
    nameLabel.width = width;
}

- (void)setUrl:(NSString *)url
{
    _url = [NSString stringWithFormat:@"%@%@",URI_BASE_SERVER,url];
    [headImGView setImageWithUrlString:_url placeholderImage:[UIImage imageNamed:@"150a.png"]];
}
- (void)dealloc
{

}
@end
