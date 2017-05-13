//
//  LiveVC.h
//  LDLiveProject
//
//  Created by MAC on 16/6/21.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BasisVC.h"
#import "UserTVInfoModel.h"
#import "SocketIO.h"
#import "SocketIOInputStream.h"
#import "SocketIOOutputStream.h"
#import "EasyTableView.h"

@interface LiveVC : BasisVC<SocketIODelegate, SocketIOInputStreamDelegate, SocketIOOutputStreamDelegate,EasyTableViewDelegate>
#pragma mark 在线观众
@property (strong, nonatomic) EasyTableView *horizontalView;
@property (atomic, strong) NSMutableArray *userDataArray;

@property (strong, nonatomic) UserTVInfoModel *userTVInfoModel;
@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) SocketIO * socketPrivate;

@end
