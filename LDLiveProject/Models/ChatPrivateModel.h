//
//  ChatPrivateModel.h
//  LiveProject
//
//  Created by coolyouimac01 on 16/5/26.
//  Copyright © 2016年 Mac. All rights reserved.
//  私聊

#import "BaseModel.h"

@interface ChatPrivateModel : BaseModel
@property (nonatomic,retain)NSString *msgid;
@property (nonatomic,retain)NSString *from_uid;
@property (nonatomic,retain)NSString *to_uid;
@property (nonatomic,retain)NSString *time;
@property (nonatomic,retain)NSString *msg;
@end
