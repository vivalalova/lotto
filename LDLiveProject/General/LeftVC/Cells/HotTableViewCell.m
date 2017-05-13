//
//  HotTableViewell.m
//  LDLiveProject
//
//  Created by MAC on 16/6/18.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "HotTableViewCell.h"

@implementation HotTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _headerBGView.backgroundColor = [UIColor colorWithHexString:@"0xb27fb5"];
    _headerBGView.layer.cornerRadius = _headerBGView.height/2;
    _headerBGView.layer.masksToBounds = YES;//设为NO去试试

    _groundView.backgroundColor = [UIColor colorWithHexString:SystemGroundColor];
    
    _headerImageView.layer.cornerRadius = _headerImageView.height/2;
    _headerImageView.layer.masksToBounds = YES;//设为NO去试试
    
    _nameLabel.font = [UIFont systemFontOfSize:CustomFont(15)];
    _addressLabel.font = [UIFont systemFontOfSize:CustomFont(14)];
    _zaikanLabel.font = [UIFont systemFontOfSize:CustomFont(12)];
    _viewerNumLabel.font = [UIFont systemFontOfSize:CustomFont(21)];
    
}

- (void)setUIWithHostInfoModel:(HostDetailInfoModel*)hostInfoModel
{
    _nameLabel.text = hostInfoModel.nick;
    _addressLabel.text = hostInfoModel.location;
    _viewerNumLabel.text = hostInfoModel.online_users;
    [_headerImageView setImageWithUrlString:hostInfoModel.headportrait placeholderImage:[UIImage imageByApplyingAlpha:1 color:[UIColor lightGrayColor]]];
    [_groundImageView setImageWithUrlString:hostInfoModel.portrait placeholderImage:[UIImage imageByApplyingAlpha:1 color:[UIColor lightGrayColor]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
