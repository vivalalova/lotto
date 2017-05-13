//
//  LiveVideoModel.h
//  LDLiveProject
//
//  Created by MAC on 16/9/13.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BaseModel.h"

@interface LiveVideoModel : BaseModel

@property(nonatomic,strong)NSString *filePath;
@property(nonatomic,strong)NSString *v_id;
@property(nonatomic,strong)NSString *imgUrl;
@property(nonatomic,strong)NSString *size;
@property(nonatomic,strong)NSString *time;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *tlen;
@property(nonatomic,strong)NSString *videoUrl;
@property(nonatomic,strong)NSString *viewTimes;

@end
