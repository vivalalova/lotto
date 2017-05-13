//
//  LiveRoomVC.h
//  LDLiveProject
//
//  Created by MAC on 16/6/23.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BasisVC.h"
#import "PlayerView.h"
#import "HostDetailInfoModel.h"
#import "SocketIO.h"
#import "SocketIOInputStream.h"
#import "SocketIOOutputStream.h"
#import "EasyTableView.h"
#import "UIScrollView+Responder.h"

@interface LiveRoomVC : BasisVC<SocketIODelegate, SocketIOInputStreamDelegate, SocketIOOutputStreamDelegate,EasyTableViewDelegate>
#pragma mark 在线观众
@property (strong, nonatomic) EasyTableView *horizontalView;
@property (atomic, strong) NSMutableArray *userDataArray;

@property (nonatomic, strong) HostDetailInfoModel *hostDetailInfoModel;
@property (strong, nonatomic) SocketIO * socketPrivate;

- (void)liveRoomVCClosePlayerUrl;

@end
