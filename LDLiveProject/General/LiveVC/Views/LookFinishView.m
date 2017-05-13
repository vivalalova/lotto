//
//  LookFinishView.m
//  LDLiveProject
//
//  Created by MAC on 16/7/23.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "LookFinishView.h"

@implementation LookFinishView
- (void)awakeFromNib
{
    [super awakeFromNib];
    _tltleLabel.textColor = [UIColor colorWithHexString:@"0xeb6d69"];
    _lookPersonLabel.backgroundColor = [UIColor clearColor];
    _lookPersonLabel.backgroundColor = [UIColor clearColor];
    _lookPersonLabel.font = [UIFont systemFontOfSize:CustomFont(18)];
    _lookPersonLabel.font = [UIFont systemFontOfSize:CustomFont(18)];
    _lookPersonLabel.textAlignment = NSTextAlignmentRight;
    _lookPersonLabel.textAlignment = NSTextAlignmentRight;
    [_backButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [_backButton setTitleColor:[UIColor colorWithHexString:@"0xeb6d69"] forState:UIControlStateNormal];
    _backButton.layer.cornerRadius = _backButton.height/2;
    _backButton.clipsToBounds = YES;
    _backButton.layer.borderColor = [UIColor colorWithHexString:@"0xeb6d69"].CGColor;
    _backButton.layer.borderWidth = 1.0f;
    
    [_attButton setTitle:@"关注主播" forState:UIControlStateNormal];
    [_attButton setTitleColor:[UIColor colorWithHexString:@"0xeb6d69"] forState:UIControlStateNormal];
    _attButton.layer.cornerRadius = _attButton.height/2;
    _attButton.clipsToBounds = YES;
    _attButton.layer.borderColor = [UIColor colorWithHexString:@"0xeb6d69"].CGColor;
    _attButton.layer.borderWidth = 1.0f;
    
}
- (void)setDataWithStopDict:(NSDictionary*)dict
{
    NSString *personString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"allusers"]];
    if (![NSString isBlankString:personString]) {
        _lookPersonLabel.hidden = NO;
        _lookPersonLabel.attributedText = nil;
        NSString *perStr = [NSString stringWithFormat:@"%@ 人看过",personString];
        NSArray *components = [perStr componentsSeparatedByString:@" "];
        
        for (int i=0; i<components.count; i++) {
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:components[i]];
            if (i == 0) {
                [attributedText m80_setTextColor:[UIColor colorWithHexString:@"0xeb6d69"]];
            }else{
                [attributedText m80_setTextColor:[UIColor whiteColor]];
            }
            [attributedText m80_setFont:[UIFont systemFontOfSize:CustomFont(18)]];
            [_lookPersonLabel appendAttributedText:attributedText];
            [_lookPersonLabel appendText:@" "];
        }
        
    }else{
        _lookPersonLabel.hidden = YES;
    }
    if (_IsAttHostBool) {
        [_attButton setTitle:@"已关注" forState:UIControlStateNormal];
    }else{
        [_attButton setTitle:@"关注主播" forState:UIControlStateNormal];
    }
}


- (IBAction)attButtonClickAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(lookFinishViewAttButtonClick)]) {
        [_delegate lookFinishViewAttButtonClick];
    }
}
- (IBAction)closeButtonClickAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(lookFinishViewCloseButtonClick)]) {
        [_delegate lookFinishViewCloseButtonClick];
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
