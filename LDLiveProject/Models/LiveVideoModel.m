//
//  LiveVideoModel.m
//  LDLiveProject
//
//  Created by MAC on 16/9/13.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "LiveVideoModel.h"

@implementation LiveVideoModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"v_id",
                                                       // 这里就采用了KVC的方式来取值，它赋给price属性
                                                       }];
}
@end
