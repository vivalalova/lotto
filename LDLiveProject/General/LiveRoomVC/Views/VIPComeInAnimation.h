//
//  VIPComeInAnimation.h
//  LDLiveProject
//
//  Created by MAC on 16/9/26.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CKShimmerLabel.h"
#import "UserWelcomeModel.h"

@interface VIPComeInAnimation : NSObject

@property (nonatomic,assign)BOOL animationBool;
@property (nonatomic,strong) CKShimmerLabel *shimmerLabel;
@property (strong,atomic)NSMutableArray *dataArray;//存储将要展示的动画信息
@property (nonatomic,assign)CGPoint position;
@property (nonatomic,strong)UIView *superView;
- (void)startVipComeInAnimation;
@end
