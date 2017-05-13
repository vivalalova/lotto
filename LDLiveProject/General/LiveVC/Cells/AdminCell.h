//
//  AttentionCell.h
//  LDLiveProject
//
//  Created by MAC on 16/7/5.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdminModel.h"


@interface AdminCell : UITableViewCell


@property (weak, nonatomic) IBOutlet WebImageView *headImageView;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *nameLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *signatureLabel;
@property (weak, nonatomic) IBOutlet UIButton *attButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel1;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel2;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel3;
@property (strong,nonatomic)AdminModel *adminModel;
@property (strong,nonatomic)NSIndexPath *indexPath;

- (void)setUIwithAdminModel:(AdminModel*)adminModel;

@end
