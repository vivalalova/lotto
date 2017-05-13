//
//  HostDetailInfoModel.h
//  LDLiveProject
//
//  Created by MAC on 16/6/22.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BaseModel.h"

@interface HostDetailInfoModel : BaseModel
@property (strong,nonatomic) NSString<Optional> *birth;
@property (strong,nonatomic) NSString<Optional> *u_description;
@property (strong,nonatomic) NSString<Optional> *emotion;
@property (strong,nonatomic) NSString<Optional> *gender;
@property (strong,nonatomic) NSString<Optional> *gmutex;
@property (strong,nonatomic) NSString<Optional> *golf_verify;
@property (strong,nonatomic) NSString *headportrait;
@property (strong,nonatomic) NSString<Optional> *hometown;
@property (strong,nonatomic) NSString *u_id;
@property (strong,nonatomic) NSString *level;
@property (strong,nonatomic) NSString<Optional> *location;
@property (strong,nonatomic) NSString *nick;
@property (strong,nonatomic) NSString *pid;
@property (strong,nonatomic) NSString *portrait;
@property (strong,nonatomic) NSString<Optional> *profession;
@property (strong,nonatomic) NSString<Optional> *rank_veri;
@property (strong,nonatomic) NSString *room_id;
@property (strong,nonatomic) NSString<Optional> *third_platform;
@property (strong,nonatomic) NSString<Optional> *veri_info;
@property (strong,nonatomic) NSString<Optional> *verified;
@property (strong,nonatomic) NSString<Optional> *verified_reason;

@property (strong,nonatomic) NSString *city;
@property (strong,nonatomic) NSString *group;
@property (strong,nonatomic) NSString *sid;
@property (strong,nonatomic) NSString<Optional> *imgage;
@property (strong,nonatomic) NSString *link;
@property (strong,nonatomic) NSString<Optional> *multi;
@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *online_users;
@property (strong,nonatomic) NSString<Optional> *pub_stat;
@property (strong,nonatomic) NSString *share_addr;
@property (strong,nonatomic) NSString *slot;
@property (strong,nonatomic) NSString<Optional> *status;
@property (strong,nonatomic) NSString *stream_addr;
@property (strong,nonatomic) NSString *version;

#pragma mark 关注使用相关

@property (strong,nonatomic) NSString<Optional> *isAttention;

@end
