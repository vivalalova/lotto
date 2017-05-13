//
//  UserTVInfoModel.m
//  LDLiveProject
//
//  Created by MAC on 16/6/22.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "UserTVInfoModel.h"

@implementation UserTVInfoModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"sid"
                                                       // 这里就采用了KVC的方式来取值，它赋给price属性
                                                       }];
}
@end
