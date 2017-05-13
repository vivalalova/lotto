//
//  WeskitCell.m
//  LDLiveProject
//
//  Created by MAC on 16/8/12.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "WeskitCell.h"
#import "VestModel.h"

@implementation WeskitCell

- (void)awakeFromNib {
    
    _headerImageView.layer.cornerRadius = _headerImageView.width/2;
    _headerImageView.clipsToBounds = YES;
    
    _lineLabel1.height = 0.25;
    _lineLabel1.backgroundColor = [UIColor colorWithHexString:@"0xebebeb"];
    _lineLabel2.height = 0.25;
    _lineLabel2.backgroundColor = [UIColor colorWithHexString:@"0xebebeb"];
    _lineLabel3.height = 0.25;
    _lineLabel3.backgroundColor = [UIColor colorWithHexString:@"0xebebeb"];
    
    _titleViewLabel.font = [UIFont systemFontOfSize:16];
    _detailViewLabel.font = [UIFont systemFontOfSize:13];
    
    [super awakeFromNib];
    // Initialization code
}
- (void)setWeskitCellWithModel:(VestModel*)vestModel
{
    _vestModel = vestModel;
    
    [_headerImageView setImageWithUrlString:[NSString stringWithFormat:@"%@%@",URI_BASE_SERVER,vestModel.img] placeholderImage:[UIImage imageByApplyingAlpha:1 color:[UIColor lightGrayColor]]];
    
    _titleViewLabel.attributedText = nil;
    [_titleViewLabel appendText:vestModel.name];
    
    
    if (vestModel.is_open.intValue) {
        [_funcButton setImage:[UIImage imageNamed:@"vest_unlock"] forState:UIControlStateNormal];
        _detailViewLabel.attributedText = nil;
        [_detailViewLabel appendView:[self getUserLevelViewWithLevelString:vestModel.lv]];
    }else{
        [_funcButton setImage:[UIImage imageNamed:@"vest_lock"] forState:UIControlStateNormal];
        _detailViewLabel.attributedText = nil;
        [_detailViewLabel appendText:vestModel.price];
        [_detailViewLabel appendText:@" "];
        [_detailViewLabel appendImage:[UIImage imageNamed:@"diam"]];
    }
    if (vestModel.is_use.intValue) {
        [_funcButton setImage:[UIImage imageNamed:@"vest_select"] forState:UIControlStateNormal];
    }
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)funcButtonAction:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClickFuncButtonWithVestModel:withIndexPath:)]) {
        [_delegate didClickFuncButtonWithVestModel:_vestModel withIndexPath:_indexPath];
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
@end
