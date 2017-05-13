//
//  ChatListModel.h
//  LiveProject
//
//  Created by coolyouimac01 on 16/5/19.
//  Copyright © 2016年 Mac. All rights reserved.
//  好友列表

#import "BaseModel.h"

@interface MessListModel : BaseModel
@property (nonatomic,retain)NSString *Id;
@property (nonatomic,retain)NSString *num;
@property (nonatomic,retain)NSString *uid;
@property (nonatomic,retain)NSString *receive_uid;
@property (nonatomic,retain)NSString *last_msg;
@property (nonatomic,retain)NSString *time;
@property (nonatomic,retain)NSString *user_name;
@property (nonatomic,retain)NSString *user_head_img;
@property (nonatomic,retain)NSString *user_rich_level;
@property (nonatomic,retain)NSString *user_sex;
@end
