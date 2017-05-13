//
//  UserSendGiftModel.h
//  LiveProject
//
//  Created by coolyouimac01 on 15/10/23.
//  Copyright © 2015年 Mac. All rights reserved.
//

#import "BaseModel.h"

@interface UserSendGiftModel : BaseModel
@property (strong,nonatomic) NSString *giftName;
@property (strong,nonatomic) UIImage *giftImage;
@property (strong,nonatomic) NSString *date;
@property (strong,nonatomic) NSString *fromUser;
@property (strong,nonatomic) NSString *giftcount;
@property (strong,nonatomic) NSString *giftid;
@property (strong,nonatomic) NSString *manager_level;
@property (strong,nonatomic) NSString *richlevel;
@property (strong,nonatomic) NSString *vip_type;
@property (strong,nonatomic) NSString *uid;
@property (strong,nonatomic) NSString *user_head_img;
@property (strong,nonatomic) NSString *serial_count;
@property (strong,nonatomic) NSString *roomid;
@property (strong,nonatomic) NSString *super_vip;
@end
