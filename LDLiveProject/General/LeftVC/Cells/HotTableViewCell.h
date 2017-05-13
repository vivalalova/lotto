//
//  HotTableViewell.h
//  LDLiveProject
//
//  Created by MAC on 16/6/18.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HostDetailInfoModel.h"

@interface HotTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *titleBGView;
@property (weak, nonatomic) IBOutlet UIView *headerBGView;
@property (weak, nonatomic) IBOutlet WebImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *zaikanLabel;
@property (weak, nonatomic) IBOutlet UILabel *viewerNumLabel;
@property (weak, nonatomic) IBOutlet WebImageView *groundImageView;
@property (weak, nonatomic) IBOutlet UIView *groundView;

- (void)setUIWithHostInfoModel:(HostDetailInfoModel*)hostInfoModel;

@end
