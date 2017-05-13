//
//  LiveRecordVC.h
//  LDLiveProject
//
//  Created by MAC on 16/9/13.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BasisVC.h"
#import "LiveVideoModel.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface LiveRecordVC : BasisVC<IJKMediaUrlOpenDelegate>

@property(atomic, retain) id<IJKMediaPlayback> player;
@property(nonatomic, strong) LiveVideoModel *liveVideoModel;

@end
