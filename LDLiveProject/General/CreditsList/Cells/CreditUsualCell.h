//
//  CreditUsualCell.h
//  LDLiveProject
//
//  Created by MAC on 16/9/2.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CreditModel;

@interface CreditUsualCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet WebImageView *headerImageView;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *nameViewLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *creditNumViewLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;

- (void)setUsualCellUIWithImageHost:(NSString*)imageHost CreditModel:(CreditModel*)model;

@end
