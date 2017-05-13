//
//  CreditModel.m
//  LDLiveProject
//
//  Created by MAC on 16/9/2.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "CreditModel.h"

@implementation CreditModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"Id",
                                                       // 这里就采用了KVC的方式来取值，它赋给price属性
                                                       }];
}
@end
