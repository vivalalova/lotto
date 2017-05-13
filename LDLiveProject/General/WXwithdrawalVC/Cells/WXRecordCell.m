//
//  WXRecordCell.m
//  LDLiveProject
//
//  Created by MAC on 2016/11/28.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "WXRecordCell.h"
#import "WXRecordModel.h"

@interface WXRecordCell ()

@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UILabel *paytimeLbl;
@property (weak, nonatomic) IBOutlet UILabel *statusDescLbl;

@end

@implementation WXRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setWxRecordModel:(WXRecordModel *)wxRecordModel
{
    _wxRecordModel = wxRecordModel;
    
    _priceLbl.text=[NSString stringWithFormat:@"%@元",wxRecordModel.cash];
    _paytimeLbl.text=wxRecordModel.time;
    _statusDescLbl.text=wxRecordModel.state_des;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
