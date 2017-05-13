//
//  HostDetailInfoModel.m
//  LDLiveProject
//
//  Created by MAC on 16/6/22.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "HostDetailInfoModel.h"

@implementation HostDetailInfoModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"sid",
                                                       
                                                       @"creator.birth": @"birth",
                                                       @"creator.description": @"u_description",
                                                       @"creator.emotion": @"emotion",
                                                       @"creator.gender": @"gender",
                                                       @"creator.gmutex": @"gmutex",
                                                       @"creator.golf_verify": @"golf_verify",
                                                       @"creator.headportrait": @"headportrait",
                                                       @"creator.hometown": @"hometown",
                                                       @"creator.id": @"u_id",
                                                       @"creator.level": @"level",
                                                       @"creator.location": @"location",
                                                       @"creator.nick": @"nick",
                                                       @"creator.pid": @"pid",
                                                       @"creator.portrait": @"portrait",
                                                       @"creator.profession": @"profession",
                                                       @"creator.rank_veri": @"rank_veri",
                                                       @"creator.room_id": @"room_id",
                                                       @"creator.third_platform": @"third_platform",
                                                       @"creator.veri_info": @"veri_info",
                                                       @"creator.verified": @"verified",
                                                       @"creator.verified_reason": @"verified_reason"
                                                       // 这里就采用了KVC的方式来取值，它赋给price属性
                                                       }];
}
@end
