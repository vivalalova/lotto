//
//  AttentionCell.m
//  LDLiveProject
//
//  Created by MAC on 16/7/5.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "AdminCell.h"

@implementation AdminCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headImageView.layer.cornerRadius = _headImageView.width/2;
    _headImageView.clipsToBounds = YES;
    
    _lineLabel1.height = 0.25;
    _lineLabel1.backgroundColor = [UIColor colorWithHexString:@"0xebebeb"];
    _lineLabel2.height = 0.25;
    _lineLabel2.backgroundColor = [UIColor colorWithHexString:@"0xebebeb"];
    _lineLabel3.height = 0.25;
    _lineLabel3.backgroundColor = [UIColor colorWithHexString:@"0xebebeb"];
    
    // Initialization code
}


- (void)setUIwithAdminModel:(AdminModel*)adminModel
{
    _adminModel = adminModel;
    [_headImageView setImageWithUrlString:adminModel.headportrait placeholderImage:[UIImage imageByApplyingAlpha:1 color:[UIColor lightGrayColor]]];
    _nameLabel.attributedText = nil;
    [_nameLabel appendText:adminModel.nick];
    [_nameLabel appendText:@" "];
    if (!adminModel.gender.intValue) {
        [_nameLabel appendImage:[UIImage imageNamed:@"me_sex2"]];
    }else{
        [_nameLabel appendImage:[UIImage imageNamed:@"me_sex1"]];
    }
    [_nameLabel appendText:@" "];
    [_nameLabel appendView:[self getUserLevelViewWithLevelString:adminModel.level]];
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
