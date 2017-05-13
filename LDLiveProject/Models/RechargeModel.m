//
//  RechargeModel.m
//  LDLiveProject
//
//  Created by MAC on 16/7/7.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "RechargeModel.h"

@implementation RechargeModel
//匹配model与json不一致的字段
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"g_id",
                                                       }];
}
@end
