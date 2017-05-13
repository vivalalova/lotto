//
//  LiveVideoCell.m
//  LDLiveProject
//
//  Created by MAC on 16/9/13.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "LiveVideoCell.h"
#import "LiveVideoModel.h"

@implementation LiveVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _numLabel.textColor = [UIColor colorWithHexString:GiftUsualColor];
    _lineLabel1.backgroundColor = UIColorFromRGB(240, 240, 240);
    _lineLabel2.backgroundColor = UIColorFromRGB(240, 240, 240);
    _lineLabel1.height = 0.5;
    _lineLabel2.height = 0.5;
    // Initialization code
}

- (void)setUIwithLiveVideoModel:(LiveVideoModel *)liveVideoModel
{
    _titleLabel.text = liveVideoModel.title;
    _timeLabel.text = [NSDate timeStringWithInterval:[liveVideoModel.time doubleValue]];
    _numLabel.text = liveVideoModel.viewTimes;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
