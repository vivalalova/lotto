//
//  UserModel.h
//  PMS
//
//  Created by ligh on 14/10/22.
//
//

#import "BaseModel.h"

//用户信息
@interface UserModel : BaseModel<NSCoding>

@property (strong,nonatomic) NSString *u_id;
@property (strong,nonatomic) NSString *currentToken;
@property (strong,nonatomic) NSString *token;
@property (strong,nonatomic) NSString *level;
@property (strong,nonatomic) NSString *nick;
@property (strong,nonatomic) NSString *pid;
@property (strong,nonatomic) NSString *portrait;
@property (strong,nonatomic) NSString *headportrait;
@property (strong,nonatomic) NSString *emotion;
@property (strong,nonatomic) NSString *golf_verify;
@property (strong,nonatomic) NSString *verified;
@property (strong,nonatomic) NSString *u_description;
@property (strong,nonatomic) NSString *gender;
@property (strong,nonatomic) NSString *profession;
@property (strong,nonatomic) NSString *verified_reason;
@property (strong,nonatomic) NSString *location;
@property (strong,nonatomic) NSString *birth;
@property (strong,nonatomic) NSString *hometown;
@property (strong,nonatomic) NSString *gmutex;
@property (strong,nonatomic) NSString *third_platform;
@property (strong,nonatomic) NSString *veri_info;
@property (strong,nonatomic) NSString *rank_veri;
@property (strong,nonatomic) NSString *room_id;
@property (strong,nonatomic) NSString *gold;
@property (strong,nonatomic) NSString *points;
@property (strong,nonatomic) NSString *send_gold;
@property (strong,nonatomic) NSString *attention;
@property (strong,nonatomic) NSString *fans;
@property (strong,nonatomic) NSString *isVest;
@property (strong,nonatomic) NSString *mood;
@property (strong,nonatomic) NSString *wx_openid;
@property (strong,nonatomic) NSString *user_mobile;
@property (strong,nonatomic) NSString *super_vip;
@property (strong,nonatomic) NSString *vip_expire;
@property (strong,nonatomic) NSString *redgift;
@property (strong,nonatomic) NSString *vedio_num;
@end
