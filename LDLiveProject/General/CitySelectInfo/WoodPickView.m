//
//  WoodPickView.m
//  LDLiveProject
//
//  Created by MAC on 16/9/3.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "WoodPickView.h"

@implementation WoodPickView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _bgView.backgroundColor = [UIColor blackColor];
    _bgView.alpha = 0;
    
    _pickView.backgroundColor = [UIColor whiteColor];
    _pickView.top = self.bottom;
    
    _baomiButton.layer.cornerRadius = 2;
    _baomiButton.layer.masksToBounds = YES;
    [_baomiButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_baomiButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_baomiButton setBackgroundImage:[UIImage imageByApplyingAlpha:1 color:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [_baomiButton setBackgroundImage:[UIImage imageByApplyingAlpha:1 color:[UIColor colorWithHexString:GiftUsualColor]] forState:UIControlStateSelected];
    
    _danshenButton.layer.cornerRadius = 2;
    _danshenButton.layer.masksToBounds = YES;
    [_danshenButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_danshenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_danshenButton setBackgroundImage:[UIImage imageByApplyingAlpha:1 color:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [_danshenButton setBackgroundImage:[UIImage imageByApplyingAlpha:1 color:[UIColor colorWithHexString:GiftUsualColor]] forState:UIControlStateSelected];
    
    _lianaizhongButton.layer.cornerRadius = 2;
    _lianaizhongButton.layer.masksToBounds = YES;
    [_lianaizhongButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_lianaizhongButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_lianaizhongButton setBackgroundImage:[UIImage imageByApplyingAlpha:1 color:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [_lianaizhongButton setBackgroundImage:[UIImage imageByApplyingAlpha:1 color:[UIColor colorWithHexString:GiftUsualColor]] forState:UIControlStateSelected];
    
    _yihunButton.layer.cornerRadius = 2;
    _yihunButton.layer.masksToBounds = YES;
    [_yihunButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_yihunButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_yihunButton setBackgroundImage:[UIImage imageByApplyingAlpha:1 color:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [_yihunButton setBackgroundImage:[UIImage imageByApplyingAlpha:1 color:[UIColor colorWithHexString:GiftUsualColor]] forState:UIControlStateSelected];
    
    _tongxingButton.layer.cornerRadius = 2;
    _tongxingButton.layer.masksToBounds = YES;
    [_tongxingButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_tongxingButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [_tongxingButton setBackgroundImage:[UIImage imageByApplyingAlpha:1 color:[UIColor lightGrayColor]] forState:UIControlStateNormal];
    [_tongxingButton setBackgroundImage:[UIImage imageByApplyingAlpha:1 color:[UIColor colorWithHexString:GiftUsualColor]] forState:UIControlStateSelected];
    
    [_baomiButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_danshenButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_lianaizhongButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_yihunButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [_tongxingButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenSelf)];
    [_bgView addGestureRecognizer:tap];
}

- (void)showInView:(UIView *)view withSelectStr:(NSString*)selectStr
{
    _selectStr = selectStr;
    if ([selectStr isEqualToString:@"保密"]) {
        _baomiButton.selected = YES;
    }
    if ([selectStr isEqualToString:@"单身"]) {
        _danshenButton.selected = YES;
    }
    if ([selectStr isEqualToString:@"恋爱中"]) {
        _lianaizhongButton.selected = YES;
    }
    if ([selectStr isEqualToString:@"已婚"]) {
        _yihunButton.selected = YES;
    }
    if ([selectStr isEqualToString:@"同性"]) {
        _tongxingButton.selected = YES;
    }
    [view addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
        _bgView.alpha = 0.5;
        _pickView.bottom = self.bottom;
    }];
}
- (void)hiddenSelf
{
    [UIView animateWithDuration:0.5 animations:^{
        _bgView.alpha = 0;
        _pickView.top = self.bottom;
    }];
    if ([_delegate respondsToSelector:@selector(woodPickViewDidSelectWithStr:)]) {
        [_delegate woodPickViewDidSelectWithStr:_selectStr];
    }
    [self removeFromSuperview];
}


- (void)buttonClickAction:(UIButton*)button
{
    if (button == _baomiButton) {
        _baomiButton.selected = YES;
        _danshenButton.selected = NO;
        _lianaizhongButton.selected = NO;
        _yihunButton.selected = NO;
        _tongxingButton.selected = NO;
        _selectStr = @"保密";
    }
    if (button == _danshenButton) {
        _baomiButton.selected = NO;
        _danshenButton.selected = YES;
        _lianaizhongButton.selected = NO;
        _yihunButton.selected = NO;
        _tongxingButton.selected = NO;
        _selectStr = @"单身";
    }
    if (button == _lianaizhongButton) {
        _baomiButton.selected = NO;
        _danshenButton.selected = NO;
        _lianaizhongButton.selected = YES;
        _yihunButton.selected = NO;
        _tongxingButton.selected = NO;
        _selectStr = @"恋爱中";
    }
    if (button == _yihunButton) {
        _baomiButton.selected = NO;
        _danshenButton.selected = NO;
        _lianaizhongButton.selected = NO;
        _yihunButton.selected = YES;
        _tongxingButton.selected = NO;
        _selectStr = @"已婚";
    }
    if (button == _tongxingButton) {
        _baomiButton.selected = NO;
        _danshenButton.selected = NO;
        _lianaizhongButton.selected = NO;
        _yihunButton.selected = NO;
        _tongxingButton.selected = YES;
        _selectStr = @"同性";
    }

}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
