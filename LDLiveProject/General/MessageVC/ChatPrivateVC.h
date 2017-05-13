//
//  ChatPrivateVC.h
//  LiveProject
//
//  Created by coolyouimac01 on 16/5/26.
//  Copyright © 2016年 Mac. All rights reserved.
//  私聊

#import "BasisVC.h"
@class MessListModel;
@interface ChatPrivateVC : BasisVC<SRRefreshDelegate>
@property (nonatomic,strong)MessListModel *chatListModel;
@property (nonatomic,assign)BOOL SmallTypeBool;
@end
