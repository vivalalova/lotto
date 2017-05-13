//
//  SocketIOManager.h
//  LiveProject
//
//  Created by MAC on 16/7/11.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"
#import "SocketIOInputStream.h"
#import "SocketIOOutputStream.h"

@protocol SocketIOManagerDelegate <NSObject>

- (void)SocketIOManagerDidreceiveEvent:(NSString *)eventName data:(id)data;
- (void)SocketIOManagerDidReceiveError:(NSString *)error;

@end

@interface SocketIOManager : NSObject<SocketIODelegate, SocketIOInputStreamDelegate, SocketIOOutputStreamDelegate>

@property (nonatomic,assign) id<SocketIOManagerDelegate>delegate;
@property (nonatomic, strong) SocketIO * socketPrivate;
@property (nonatomic, strong) NSString * roomid;
@property (nonatomic, strong) NSString * hostStr;
+ (id)shareManager;
- (void)socketIOsendEvent:(NSString *)eventName data:(NSDictionary *)dict;
- (void)connetWithHost:(NSString *)host port:(NSInteger)port roomid:(NSString *)roomid timeout:(NSTimeInterval)timeout;
- (void)closeSocket;

@end
