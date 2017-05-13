//
//  PhoneFansListView.h
//  LiveProject
//
//  Created by coolyouimac01 on 16/5/24.
//  Copyright © 2016年 Mac. All rights reserved.
//  粉丝榜

#import "XibView.h"

@interface PhoneFansListView : XibView
@property(nonatomic,strong)NSArray *totalArray;//总榜
@property(nonatomic,strong)NSArray *weekArray;//本周
@property(nonatomic,strong)NSArray *currentArray;//本场
- (void)showInView:(UIView *)view;
@end
