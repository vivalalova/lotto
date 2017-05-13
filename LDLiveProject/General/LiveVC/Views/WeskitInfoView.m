//
//  WeskitInfoView.m
//  LDLiveProject
//
//  Created by MAC on 16/8/13.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "WeskitInfoView.h"
#import "PersonInfoModel.h"

@implementation WeskitInfoView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _infoViewLabel.backgroundColor = [UIColor clearColor];
    _infoViewLabel.font = [UIFont systemFontOfSize:CustomFont(16)];
    _infoViewLabel.textAlignment = NSTextAlignmentRight;
    _infoViewLabel.textColor = [UIColor whiteColor];
    
    
    _manButton.layer.cornerRadius = 3;
    _manButton.layer.masksToBounds = YES;
    [_manButton setBackgroundColor:[UIColor redColor]];
    
    UITapGestureRecognizer *tapGeR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapPersonInfoView:)];
    tapGeR.delegate = self;
    [self addGestureRecognizer:tapGeR];
    
}

- (void)setWeskitInfoViewWithModel:(PersonInfoModel*)personInfoModel
{
    _perInfoModel = personInfoModel;
    _infoViewLabel.attributedText = nil;
    if (personInfoModel.isVest.intValue == 1) {
        _bgImageView.image = [UIImage imageNamed:@"chujiqiuyuan"];
        [_infoViewLabel appendText:@"初级球员"];
    }else if (personInfoModel.isVest.intValue == 2){
        _bgImageView.image = [UIImage imageNamed:@"zhongjiqiuyuan"];
        [_infoViewLabel appendText:@"中级球员"];
    }else if (personInfoModel.isVest.intValue == 3){
        _bgImageView.image = [UIImage imageNamed:@"gaojiqiuyuan"];
        [_infoViewLabel appendText:@"高级球员"];
    }else if (personInfoModel.isVest.intValue == 4){
        _bgImageView.image = [UIImage imageNamed:@"zhiyeqiuyuan"];
        [_infoViewLabel appendText:@"职业球员"];
    }else if (personInfoModel.isVest.intValue == 5){
        _bgImageView.image = [UIImage imageNamed:@"gaojiqiuyuan"];
        [_infoViewLabel appendText:@"高球大师"];
    }
    [_infoViewLabel appendText:@"   "];
    [_infoViewLabel appendView:[self getUserLevelViewWithLevelString:personInfoModel.level]];
}
#pragma mark 获取用等级视图
- (UIView *)getUserLevelViewWithLevelString:(NSString *)level
{
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 30, 14)];
    if (level.intValue == 0) {
        return nil;
    }
    view.image = [UIImage imageNamed:[NSString stringWithFormat:@"level_%@",level]];
    return view;
}

- (IBAction)closeButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(closeWeskitInfoViewButtonAction)]) {
        [_delegate closeWeskitInfoViewButtonAction];
    }
}
- (IBAction)manButtonClickAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(WeskitInfoViewManButtonAction:)]) {
        [_delegate WeskitInfoViewManButtonAction:_perInfoModel];
    }
}


- (void)tapPersonInfoView:(UITapGestureRecognizer *)tapGeR
{
    if (tapGeR.view == self) {
        if ([_delegate respondsToSelector:@selector(closeWeskitInfoViewButtonAction)]) {
            [_delegate closeWeskitInfoViewButtonAction];
        }
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isDescendantOfView:_contentView]) {
        return NO;
    }
    return YES;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
