//
//  RightFuncMoreCell.h
//  LDLiveProject
//
//  Created by MAC on 16/9/10.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;

@protocol RightFuncMoreCellDelegate <NSObject>

- (void)didClickRightFuncMoreCellLeftLiveButtonClick;
- (void)didClickRightFuncMoreCellRightLevelButtonClick;

@end

@interface RightFuncMoreCell : UITableViewCell

@property (assign,nonatomic) id<RightFuncMoreCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UILabel *liveTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *liveNumLabel;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *levelTitleLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *levelNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

- (void)setFuncMoreDataWithUserModel:(UserModel*)userModel;
- (void)setLiveVideoNumWithNumStr:(NSString *)numStr;

@end
