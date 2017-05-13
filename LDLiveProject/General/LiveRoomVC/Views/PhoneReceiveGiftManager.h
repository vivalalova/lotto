//
//  PhoneReceiveGiftManager.h
//  LiveProject
//
//  Created by coolyouimac01 on 16/4/6.
//  Copyright © 2016年 Mac. All rights reserved.
//  送礼物动画管理类

#import <Foundation/Foundation.h>
@class PhoneReceiveGiftView;
@interface PhoneReceiveGiftManager : NSObject
@property (strong,nonatomic)NSMutableArray *dataArray;//存储将要展示的动画信息
@property (nonatomic,weak)UIView *superView;
@property (nonatomic,assign)CGPoint position;
- (void)startSendGiftAnimation;
@end
