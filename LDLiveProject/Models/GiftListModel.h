//
//  GiftListModel.h
//  LDLiveProject
//
//  Created by MAC on 16/6/24.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BaseModel.h"

@interface GiftListModel : BaseModel

@property (nonatomic,strong)NSArray *list;
@property (nonatomic,strong)NSArray *types;
@property (nonatomic,strong)NSString *path;
@property (nonatomic,strong)NSString *swf;

@end
