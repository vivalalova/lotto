//
//  PersonInfoModel.m
//  LDLiveProject
//
//  Created by MAC on 16/7/4.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "PersonInfoModel.h"

@implementation PersonInfoModel
//匹配model与json不一致的字段
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"u_id",
                                                       @"description": @"u_description"
                                                       }];
}
@end
