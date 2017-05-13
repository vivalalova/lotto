//
//  MyFirendCell.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/5/16.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "MyFirendCell.h"
#import "MessListModel.h"
@interface MyFirendCell ()
@property (weak, nonatomic) IBOutlet WebImageView *headIV;
@property (weak, nonatomic) IBOutlet UILabel *lastMsgLbl;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *namLabel;

@end
@implementation MyFirendCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _headIV.layer.cornerRadius=_headIV.height/2;
    _headIV.layer.masksToBounds=YES;
    _timeLbl.textColor=[UIColor colorWithHexString:@"0xa3a3a3"];
    _lastMsgLbl.textColor=[UIColor colorWithHexString:@"0xa3a3a3"];
    _namLabel.layer.cornerRadius = 8;
    _namLabel.layer.masksToBounds = YES;
}
- (void)setChatListModel:(MessListModel *)chatListModel{
    _chatListModel=chatListModel;
    [_headIV setImageWithUrlString:[NSString stringWithFormat:@"%@%@",URI_BASE_SERVER,_chatListModel.user_head_img] placeholderImage:[UIImage imageNamed:@"150a.png"]];
    _nameLbl.text=_chatListModel.user_name;
    _lastMsgLbl.text=_chatListModel.last_msg;
    _timeLbl.text=[NSDate stringOfDefaultFormatWithInterval:[_chatListModel.time doubleValue]];
    //赋值后再调位置
    if (_chatListModel.num.intValue == 0) {
        _namLabel.hidden = YES;
    }else{
        _namLabel.hidden = NO;
        if (_chatListModel.num.intValue>99) {
            _namLabel.text = @"99+";
        }else{
            _namLabel.text = _chatListModel.num;
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
