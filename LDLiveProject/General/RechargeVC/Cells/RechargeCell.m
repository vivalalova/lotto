//
//  RechargeCell.m
//  LDLiveProject
//
//  Created by MAC on 16/7/7.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "RechargeCell.h"

@implementation RechargeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lineLabel.backgroundColor = UIColorFromRGB(245, 245, 245);
    _lineLabel.height = 0.5;
    _lineLabel.bottom = self.bottom;
    
    [_moneyButton setTitleColor:[UIColor colorWithHexString:@"0xec6d69"] forState:UIControlStateNormal];
    _moneyButton.layer.cornerRadius = 3;
    _moneyButton.layer.masksToBounds = YES;
    _moneyButton.layer.borderColor = [UIColor colorWithHexString:@"0xec6d69"].CGColor;
    _moneyButton.layer.borderWidth = 1;
    
    _titleViewLabel.font = [UIFont systemFontOfSize:15];
    
    // Initialization code
}
- (void)setRechargeCellUIwithRechargeModel:(RechargeModel *)rechargeModel
{
    if (rechargeModel.add_points.intValue) {
        _moreDesLabel.hidden = NO;
        _moreDesLabel.text = [NSString stringWithFormat:@"赠送%@钻石",rechargeModel.add_points];
    }else{
        _moreDesLabel.hidden = YES;
    }
    
    _titleViewLabel.attributedText = nil;
    [_titleViewLabel appendImage:[UIImage imageNamed:@"diam"]];
    [_titleViewLabel appendText:@"  "];
    [_titleViewLabel appendText:rechargeModel.bo8_points];
    
    [_moneyButton setTitle:[NSString stringWithFormat:@"￥ %@",rechargeModel.money] forState:UIControlStateNormal];
}



- (IBAction)rechargeButtonClick:(id)sender {
    if (self.delegate&&[self.delegate respondsToSelector:@selector(inPurchaseWith:)]) {
        [self.delegate inPurchaseWith:self.product];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
