//
//  RightFuncMoreCell.m
//  LDLiveProject
//
//  Created by MAC on 16/9/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "RightFuncMoreCell.h"

@implementation RightFuncMoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithHexString:@"0xf4f4f4"];
    _liveTitleLabel.font = [UIFont systemFontOfSize:CustomFont(14)];
    _liveNumLabel.font = [UIFont systemFontOfSize:CustomFont(14)];
    _levelTitleLabel.font = [UIFont systemFontOfSize:CustomFont(14)];
    _levelNumLabel.font = [UIFont systemFontOfSize:CustomFont(14)];
    
    _levelNumLabel.textAlignment = NSTextAlignmentCenter;
    [_levelNumLabel appendText:@"0 级"];
    // Initialization code
    _liveNumLabel.text = [NSString stringWithFormat:@"0 个"];
}

- (void)setLiveVideoNumWithNumStr:(NSString *)numStr
{
    _liveNumLabel.text = [NSString stringWithFormat:@"%@ 个",numStr];
}

- (void)setFuncMoreDataWithUserModel:(UserModel*)userModel
{
    _levelNumLabel.attributedText = nil;
    [_levelNumLabel appendText:[NSString stringWithFormat:@"%@ 级",userModel.level]];
}

- (IBAction)leftButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickRightFuncMoreCellLeftLiveButtonClick)]) {
        [_delegate didClickRightFuncMoreCellLeftLiveButtonClick];
    }
}

- (IBAction)rightButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickRightFuncMoreCellRightLevelButtonClick)]) {
        [_delegate didClickRightFuncMoreCellRightLevelButtonClick];
    }
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
