//
//  AttentionCell.m
//  LDLiveProject
//
//  Created by MAC on 16/7/5.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "AttentionCell.h"

@implementation AttentionCell

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


- (void)setUIwithHostDetailInfoModel:(HostDetailInfoModel*)hostDetailInfoModel
{
    _hostDetailInfoModel = hostDetailInfoModel;
    [_headImageView setImageWithUrlString:hostDetailInfoModel.headportrait placeholderImage:[UIImage imageByApplyingAlpha:1 color:[UIColor lightGrayColor]]];
    _nameLabel.attributedText = nil;
    [_nameLabel appendText:hostDetailInfoModel.nick];
    [_nameLabel appendText:@" "];
    if (!hostDetailInfoModel.gender.intValue) {
        [_nameLabel appendImage:[UIImage imageNamed:@"me_sex2"]];
    }else{
        [_nameLabel appendImage:[UIImage imageNamed:@"me_sex1"]];
    }
    [_nameLabel appendText:@" "];
    [_nameLabel appendView:[self getUserLevelViewWithLevelString:hostDetailInfoModel.level]];
//    if (hostDetailInfoModel.status.intValue) {
//        [_nameLabel appendText:@"  "];
//        UILabel *label =[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 42, 18)];
//        label.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.7];
//        label.textColor = [UIColor whiteColor];
//        label.font = [UIFont systemFontOfSize:10];
//        label.text = @"直播ing";
//        label.textAlignment = NSTextAlignmentCenter;
//        label.layer.cornerRadius = 8;
//        label.layer.masksToBounds = YES;
//        label.layer.borderColor = [UIColor blackColor].CGColor;
//        label.layer.borderWidth = 0.5;
//        [_nameLabel appendView:label];
//    }
    
    _signatureLabel.text = hostDetailInfoModel.emotion;
    
    if (hostDetailInfoModel.isAttention.intValue) {
        [_attButton setImage:[UIImage imageNamed:@"me_following"] forState:UIControlStateNormal];
    }else{
        [_attButton setImage:[UIImage imageNamed:@"me_follow"] forState:UIControlStateNormal];
    }
}


- (IBAction)attButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickAttentionAttButtonWithHostDetailInfoModel:withIndexPath:)]) {
        [_delegate didClickAttentionAttButtonWithHostDetailInfoModel:_hostDetailInfoModel withIndexPath:_indexPath];
    }
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
