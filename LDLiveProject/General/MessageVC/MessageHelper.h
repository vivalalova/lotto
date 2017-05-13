//
//  MessageHelper.h
//  LiveProject
//
//  Created by coolyouimac01 on 16/5/19.
//  Copyright © 2016年 Mac. All rights reserved.
//  聊天消息

#import <Foundation/Foundation.h>

@interface MessageHelper : NSObject
+ (id)shareInstance;
- (NSString *)totalMessageNum;
- (void)getTotalNotReadRequest;
@end
