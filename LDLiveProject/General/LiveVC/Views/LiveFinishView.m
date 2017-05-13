//
//  LiveFinishView.m
//  LDLiveProject
//
//  Created by MAC on 16/7/16.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "LiveFinishView.h"

@implementation LiveFinishView

- (void)awakeFromNib
{
    [super awakeFromNib];
    _titleLabel.textColor = [UIColor colorWithHexString:@"0xeb6d69"];
    _personViewLabel.backgroundColor = [UIColor clearColor];
    _ticketViewLabel.backgroundColor = [UIColor clearColor];
    _personViewLabel.font = [UIFont systemFontOfSize:CustomFont(18)];
    _ticketViewLabel.font = [UIFont systemFontOfSize:CustomFont(18)];
    _personViewLabel.textAlignment = NSTextAlignmentRight;
    _ticketViewLabel.textAlignment = NSTextAlignmentRight;
    [_closeButton setTitle:@"返回首页" forState:UIControlStateNormal];
    [_closeButton setTitleColor:[UIColor colorWithHexString:@"0xeb6d69"] forState:UIControlStateNormal];
    _closeButton.layer.cornerRadius = _closeButton.height/2;
    _closeButton.clipsToBounds = YES;
    _closeButton.layer.borderColor = [UIColor colorWithHexString:@"0xeb6d69"].CGColor;
    _closeButton.layer.borderWidth = 1.0f;
    
}
- (void)setDataWithStopDict:(NSDictionary*)dict
{
    if (!dict) {
        return;
    }
    NSString *personString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"online_users"]];
    if (![NSString isBlankString:personString]) {
        _personViewLabel.hidden = NO;
        _personViewLabel.attributedText = nil;
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
            [_personViewLabel appendAttributedText:attributedText];
            [_personViewLabel appendText:@" "];
        }

    }else{
        _personViewLabel.hidden = YES;
    }
    NSString *pointsString = [NSString stringWithFormat:@"%@",[dict objectForKey:@"points"]];
    if (![NSString isBlankString:pointsString]) {
        _ticketViewLabel.hidden = NO;
        _ticketViewLabel.attributedText = nil;
        NSString *perStr = [NSString stringWithFormat:@"收获 %@ 球票",pointsString];
        NSArray *components = [perStr componentsSeparatedByString:@" "];
        
        for (int i=0; i<components.count; i++) {
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc]initWithString:components[i]];
            if (i == 1) {
                [attributedText m80_setTextColor:[UIColor colorWithHexString:@"0xeb6d69"]];
            }else{
                [attributedText m80_setTextColor:[UIColor whiteColor]];
            }
            [attributedText m80_setFont:[UIFont systemFontOfSize:CustomFont(18)]];
            [_ticketViewLabel appendAttributedText:attributedText];
            [_ticketViewLabel appendText:@" "];
        }
        
    }else{
        _ticketViewLabel.hidden = YES;
    }
}


#pragma mark buttonActions
- (IBAction)closeButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickLiveFinishViewCloseButton)]) {
        [_delegate didClickLiveFinishViewCloseButton];
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
