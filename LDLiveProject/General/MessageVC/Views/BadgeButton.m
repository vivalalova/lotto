//
//  IWBadgeButton.m
//  ItcastWeibo
//
//  Created by apple on 14-5-5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "BadgeButton.h"

@implementation BadgeButton
- (UIImage *)resizedImageWithName:(NSString *)name
{
    return [self resizedImageWithName:name left:0.5 top:0.5];
}

- (UIImage *)resizedImageWithName:(NSString *)name left:(CGFloat)left top:(CGFloat)top
{
    UIImage *image = [UIImage imageNamed:name];
    return [image stretchableImageWithLeftCapWidth:image.size.width * left topCapHeight:image.size.height * top];
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addSubview:self.imageV];
        [self addSubview:self.label];
        self.label.hidden = YES;
    }
    return self;
}
- (UIImageView*)imageV
{
    if (!_imageV) {
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 12, 18, 18)];
        _imageV.image = [UIImage imageNamed:@"message"];
    }
    return _imageV;
}
- (UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc]initWithFrame:CGRectMake(22, 5, 15, 10)];
        _label.textColor = [UIColor redColor];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:7];
        _label.backgroundColor = [UIColor clearColor];
        _label.layer.cornerRadius = 5;
        _label.layer.borderColor = [UIColor redColor].CGColor;
        _label.layer.borderWidth = 1;
        _label.layer.masksToBounds = YES;
    }
    return _label;
}


- (void)setBadgeValue:(NSString *)badgeValue
{
    if (badgeValue.intValue == 0) {
        self.label.hidden = YES;
        return;
    }else{
        self.label.hidden = NO;
    }
    _badgeValue = [badgeValue copy];
    // 设置文字
    if ([badgeValue intValue]>=100) {
        self.label.text = @"99+";
    }else{
        self.label.text = badgeValue;
    }
    if (badgeValue.intValue<10) {
        self.label.width = 10;
    }
    if (badgeValue.intValue>9) {
        self.label.width = 15;
    }
}

@end
