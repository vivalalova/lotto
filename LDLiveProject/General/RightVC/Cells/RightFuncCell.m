//
//  RightFuncCell.m
//  LDLiveProject
//
//  Created by MAC on 16/6/20.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "RightFuncCell.h"
#import "UserModel.h"

@implementation RightFuncCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"0xf4f4f4"];
    _incomeTitleLabel.font = [UIFont systemFontOfSize:CustomFont(14)];
    _incomeNumLabel.font = [UIFont systemFontOfSize:CustomFont(14)];
    _accountTitleLabel.font = [UIFont systemFontOfSize:CustomFont(14)];
    _accountNumLabel.font = [UIFont systemFontOfSize:CustomFont(14)];
    
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([appVersion isEqualToString:[KAPP_DELEGATE ver_test]]) {
        _incomeTitleLabel.text = @"球票";
        _leftImageView.image = [UIImage imageNamed:@"me_golf"];
    }else{
        _incomeTitleLabel.text = @"收益";
        _leftImageView.image = [UIImage imageNamed:@"me_money"];
    }
    
    _accountNumLabel.textAlignment = NSTextAlignmentCenter;
    [_accountNumLabel appendText:@"0"];
    [_accountNumLabel appendImage:[UIImage imageNamed:@"diam"]];
    // Initialization code
}

- (void)setDataWithUserModel:(UserModel*)userModel
{
    _incomeNumLabel.text = [NSString stringWithFormat:@"%@球票",userModel.points];
    _accountNumLabel.attributedText = nil;
    [_accountNumLabel appendText:userModel.gold];
    [_accountNumLabel appendImage:[UIImage imageNamed:@"diam"]];
}

- (IBAction)leftButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickLeftIncomButtonClick)]) {
        [_delegate didClickLeftIncomButtonClick];
    }
}

- (IBAction)rightButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickRightAccountButtonClick)]) {
        [_delegate didClickRightAccountButtonClick];
    }
}

@end
