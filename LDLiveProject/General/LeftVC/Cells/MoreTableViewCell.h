//
//  MoreTableViewCell.h
//  LDLiveProject
//
//  Created by MAC on 16/6/21.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HostDetailInfoModel.h"

@protocol MoreTableViewCellDelegate <NSObject>

-(void)didSelectMoreTableviewWithHostInfoModel:(HostDetailInfoModel *)hostInfoModel;

@end

@interface MoreTableViewCell : UITableViewCell
@property (assign, nonatomic) id<MoreTableViewCellDelegate>delegate;
@property (strong, nonatomic)  UIView *bgView1;
@property (strong, nonatomic)  UIView *bgView2;
@property (strong, nonatomic)  UIView *bgView3;
@property (strong, nonatomic)  WebImageView *headerImageV1;
@property (strong, nonatomic)  WebImageView *headerImageV2;
@property (strong, nonatomic)  WebImageView *headerImageV3;
@property (strong, nonatomic)  M80AttributedLabel *titleLabel1;
@property (strong, nonatomic)  M80AttributedLabel *titleLabel2;
@property (strong, nonatomic)  M80AttributedLabel *titleLabel3;

@property (strong, nonatomic) HostDetailInfoModel *hostInfoModel1;
@property (strong, nonatomic) HostDetailInfoModel *hostInfoModel2;
@property (strong, nonatomic) HostDetailInfoModel *hostInfoModel3;
- (void)setUIwithModel;
@end
