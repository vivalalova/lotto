//
//  IWBadgeButton.h
//  ItcastWeibo
//
//  Created by apple on 14-5-5.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BadgeButton : UIButton
@property (nonatomic,strong)UIImageView *imageV;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic, copy) NSString *badgeValue;

@end
