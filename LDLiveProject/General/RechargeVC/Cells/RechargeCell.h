//
//  RechargeCell.h
//  LDLiveProject
//
//  Created by MAC on 16/7/7.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RechargeModel.h"
#import "StoreKit/StoreKit.h"

@protocol RechargeCellDelegate <NSObject>

-(void)inPurchaseWith:(SKProduct *)product;

@end

@interface RechargeCell : UITableViewCell

@property (assign, nonatomic) id<RechargeCellDelegate>delegate;
@property (strong, nonatomic) RechargeModel *rechargeModel;

- (void)setRechargeCellUIwithRechargeModel:(RechargeModel *)rechargeModel;

@property(nonatomic,strong) SKProduct *product;

@property (weak, nonatomic) IBOutlet M80AttributedLabel *titleViewLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreDesLabel;
@property (weak, nonatomic) IBOutlet UIButton *moneyButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@end
