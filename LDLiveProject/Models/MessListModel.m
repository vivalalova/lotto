//
//  ChatListModel.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/5/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "MessListModel.h"

@implementation MessListModel
//匹配model与json不一致的字段
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"Id",
                                                       }];
}
@end
