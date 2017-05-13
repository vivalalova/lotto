//
//  RightFuncCell.h
//  LDLiveProject
//
//  Created by MAC on 16/6/20.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;

@protocol RightFuncCellDelegate <NSObject>

- (void)didClickLeftIncomButtonClick;
- (void)didClickRightAccountButtonClick;

@end

@interface RightFuncCell : UITableViewCell
@property (assign,nonatomic) id<RightFuncCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *incomeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *incomeNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *accountTitleLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *accountNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

- (void)setDataWithUserModel:(UserModel*)userModel;

@end
