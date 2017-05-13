//
//  SocketMessageModel.h
//  LDLiveProject
//
//  Created by MAC on 16/6/24.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BaseModel.h"

@interface SocketMessageModel : BaseModel
@property (nonatomic,strong)NSString *clienttype;
@property (nonatomic,strong)NSString *date;
@property (nonatomic,strong)NSString *fromUser;
@property (nonatomic,strong)NSString *manager_level;
@property (nonatomic,strong)NSString *msg;
@property (nonatomic,strong)NSArray *regal;
@property (nonatomic,strong)NSString *richlevel;
@property (nonatomic,strong)NSString *room_num;
@property (nonatomic,strong)NSString *uid;
@property (nonatomic,strong)NSString<Optional> *vip_head_img;
@property (nonatomic,strong)NSString *vip_type;
@property (nonatomic,strong)NSString *super_vip;

@end
