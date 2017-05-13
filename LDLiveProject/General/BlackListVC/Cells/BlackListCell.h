//
//  AttentionCell.h
//  LDLiveProject
//
//  Created by MAC on 16/7/5.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlackListModel.h"

@protocol BlackListCellDelegate <NSObject>

- (void)didClickBlackListCellWithBlackListModel:(BlackListModel*)blackListModel withIndexPath:(NSIndexPath*)indexPath;

@end

@interface BlackListCell : UITableViewCell

@property (assign,nonatomic) id <BlackListCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet WebImageView *headImageView;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *nameLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UIButton *attButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel1;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel2;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel3;
@property (strong,nonatomic)BlackListModel *blackListModel;
@property (strong,nonatomic)NSIndexPath *indexPath;

- (void)setUIwithBlackListModel:(BlackListModel*)blackListModel withBaseUrl:(NSString *)baseUrl;

@end
