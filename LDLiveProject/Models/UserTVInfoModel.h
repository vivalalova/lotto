//
//  UserTVInfoModel.h
//  LDLiveProject
//
//  Created by MAC on 16/6/22.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BaseModel.h"

@interface UserTVInfoModel : BaseModel
@property (strong,nonatomic) NSString *u_id;
@property (strong,nonatomic) NSString *link;
@property (strong,nonatomic) NSString *publish_addr;
@property (strong,nonatomic) NSString *room_id;
@property (strong,nonatomic) NSString *share_addr;
@property (strong,nonatomic) NSString *slot;
@property (strong,nonatomic) NSString *stream_addr;
@end
