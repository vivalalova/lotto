//
//  UserModel.m
//  PMS
//
//  Created by ligh on 14/10/22.
//
//

#import "UserModel.h"

@implementation UserModel

//匹配model与json不一致的字段
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"u_id",
                                                       @"description": @"u_description"
                                                       }];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.u_id = [aDecoder decodeObjectForKey:@"id"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.currentToken = [aDecoder decodeObjectForKey:@"currentToken"];
        self.level = [aDecoder decodeObjectForKey:@"level"];
        self.nick = [aDecoder decodeObjectForKey:@"nick"];
        self.pid = [aDecoder decodeObjectForKey:@"pid"];
        self.portrait = [aDecoder decodeObjectForKey:@"portrait"];
        self.headportrait = [aDecoder decodeObjectForKey:@"headportrait"];
        self.emotion = [aDecoder decodeObjectForKey:@"emotion"];
        self.golf_verify = [aDecoder decodeObjectForKey:@"golf_verify"];
        self.verified = [aDecoder decodeObjectForKey:@"verified"];
        self.u_description = [aDecoder decodeObjectForKey:@"description"];
        self.gender = [aDecoder decodeObjectForKey:@"gender"];
        self.profession = [aDecoder decodeObjectForKey:@"profession"];
        self.verified_reason = [aDecoder decodeObjectForKey:@"verified_reason"];
        self.location = [aDecoder decodeObjectForKey:@"location"];
        self.birth = [aDecoder decodeObjectForKey:@"birth"];
        self.hometown = [aDecoder decodeObjectForKey:@"hometown"];
        self.gmutex = [aDecoder decodeObjectForKey:@"gmutex"];
        self.third_platform = [aDecoder decodeObjectForKey:@"third_platform"];
        self.veri_info = [aDecoder decodeObjectForKey:@"veri_info"];
        self.rank_veri = [aDecoder decodeObjectForKey:@"rank_veri"];
        self.room_id = [aDecoder decodeObjectForKey:@"room_id"];
        self.gold = [aDecoder decodeObjectForKey:@"gold"];
        self.points = [aDecoder decodeObjectForKey:@"points"];
        self.send_gold = [aDecoder decodeObjectForKey:@"send_gold"];
        self.attention = [aDecoder decodeObjectForKey:@"attention"];
        self.fans = [aDecoder decodeObjectForKey:@"fans"];
        self.isVest = [aDecoder decodeObjectForKey:@"isVest"];
        self.mood = [aDecoder decodeObjectForKey:@"mood"];
        self.user_mobile = [aDecoder decodeObjectForKey:@"user_mobile"];
        self.wx_openid = [aDecoder decodeObjectForKey:@"wx_openid"];
        self.super_vip = [aDecoder decodeObjectForKey:@"super_vip"];
        self.vip_expire = [aDecoder decodeObjectForKey:@"vip_expire"];
        self.redgift = [aDecoder decodeObjectForKey:@"redgift"];
        self.vedio_num = [aDecoder decodeObjectForKey:@"vedio_num"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.u_id forKey:@"id"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.currentToken forKey:@"currentToken"];
    [aCoder encodeObject:self.level forKey:@"level"];
    [aCoder encodeObject:self.nick forKey:@"nick"];
    [aCoder encodeObject:self.pid forKey:@"pid"];
    [aCoder encodeObject:self.portrait forKey:@"portrait"];
    [aCoder encodeObject:self.headportrait forKey:@"headportrait"];
    [aCoder encodeObject:self.emotion forKey:@"emotion"];
    [aCoder encodeObject:self.golf_verify forKey:@"golf_verify"];
    [aCoder encodeObject:self.verified forKey:@"verified"];
    [aCoder encodeObject:self.u_description forKey:@"description"];
    [aCoder encodeObject:self.gender forKey:@"gender"];
    [aCoder encodeObject:self.profession forKey:@"profession"];
    [aCoder encodeObject:self.verified_reason forKey:@"verified_reason"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.birth forKey:@"birth"];
    [aCoder encodeObject:self.hometown forKey:@"hometown"];
    [aCoder encodeObject:self.gmutex forKey:@"gmutex"];
    [aCoder encodeObject:self.third_platform forKey:@"third_platform"];
    [aCoder encodeObject:self.veri_info forKey:@"veri_info"];
    [aCoder encodeObject:self.rank_veri forKey:@"rank_veri"];
    [aCoder encodeObject:self.room_id forKey:@"room_id"];
    [aCoder encodeObject:self.gold forKey:@"gold"];
    [aCoder encodeObject:self.points forKey:@"points"];
    [aCoder encodeObject:self.send_gold forKey:@"send_gold"];
    [aCoder encodeObject:self.attention forKey:@"attention"];
    [aCoder encodeObject:self.fans forKey:@"fans"];
    [aCoder encodeObject:self.isVest forKey:@"isVest"];
    [aCoder encodeObject:self.mood forKey:@"mood"];
    [aCoder encodeObject:self.user_mobile forKey:@"user_mobile"];
    [aCoder encodeObject:self.wx_openid forKey:@"wx_openid"];
    [aCoder encodeObject:self.super_vip forKey:@"super_vip"];
    [aCoder encodeObject:self.vip_expire forKey:@"vip_expire"];
    [aCoder encodeObject:self.redgift forKey:@"redgift"];
    [aCoder encodeObject:self.vedio_num forKey:@"vedio_num"];
}



@end
