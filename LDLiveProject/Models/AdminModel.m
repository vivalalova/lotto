//
//  AdminModel.m
//  LDLiveProject
//
//  Created by MAC on 16/7/23.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "AdminModel.h"

@implementation AdminModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"u_id",
                                                       // 这里就采用了KVC的方式来取值，它赋给price属性
                                                       }];
}
@end
