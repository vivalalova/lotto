//
//  WeskitCell.h
//  LDLiveProject
//
//  Created by MAC on 16/8/12.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VestModel;

@protocol WeskitCellDelegate <NSObject>

- (void)didClickFuncButtonWithVestModel:(VestModel*)vestModel withIndexPath:(NSIndexPath*)indexPath;

@end

@interface WeskitCell : UITableViewCell
@property (assign,nonatomic) id<WeskitCellDelegate>delegate;
@property (weak, nonatomic) IBOutlet WebImageView *headerImageView;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *titleViewLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *detailViewLabel;
@property (weak, nonatomic) IBOutlet UIButton *funcButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel1;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel2;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel3;

@property (strong,nonatomic) VestModel *vestModel;
@property (strong,nonatomic)NSIndexPath *indexPath;
- (void)setWeskitCellWithModel:(VestModel*)vestModel;

@end
