//
//  SocketIOManager.m
//  LiveProject
//
//  Created by MAC on 16/7/11.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "SocketIOManager.h"

@implementation SocketIOManager

static id instance;
+ (id)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)connetWithHost:(NSString *)host port:(NSInteger)port roomid:(NSString *)roomid timeout:(NSTimeInterval)timeout
{
    self.roomid = roomid;
    if ([host isEqualToString:self.hostStr]) {
        [self.socketPrivate connect];
    }else{
        self.hostStr = host;
        self.socketPrivate = [[SocketIO alloc] initWithDelegate:self host:host port:8082 namespace:nil timeout:1000 secured:NO];
        [self.socketPrivate connect];
    }
}

- (void)closeSocket
{
    [self.socketPrivate disconnect];
}

- (void)socketIOsendEvent:(NSString *)eventName data:(NSDictionary *)dict
{
    if (![NSString isBlankString:eventName]) {
        [self.socketPrivate sendEvent:eventName data:dict];
    }
}


- (void) socketIODidDisconnect:(SocketIO *)socket
{
    NSLog(@"Disconnect");
}
- (void) socketIO:(SocketIO *)socket didReceiveMessage:(id)data ack:(SocketIOCallback)function
{
    
}


- (void) socketIO:(SocketIO *)socket didReceiveEvent:(NSString *) eventName data:(id)data extradata:(id)extradata ack:(SocketIOCallback) function
{
    //	NSLog(@"didReceiveEvent");
    if ([_delegate respondsToSelector:@selector(SocketIOManagerDidreceiveEvent:data:)]) {
        [_delegate SocketIOManagerDidreceiveEvent:eventName data:data];
    }
//    if ([eventName isEqualToString:@"login success"]) {
//        NSLog(@"=========data=======%@",data);
//    }
}

- (void) socketIO:(SocketIO *)socket didReceiveStream:(SocketIOInputStream *)stream
{
}

- (void) stream:(SocketIOInputStream*)stream didReceiveData:(NSData*)data
{
}

- (void) streamDidFinish:(SocketIOInputStream*)stream
{
}

- (void) stream:(SocketIOOutputStream*)stream askData:(NSUInteger)length
{
    
}

- (void) socketIODidConnect:(SocketIO *)socket
{
    if(![socket nsp])
    {
        NSLog(@"CONNECTED ON ROOT NSP");
    }
    NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:User_Token,@"username",self.roomid,@"roomid",CLIENT_TYPE_IOS,@"clienttype", nil];
    [socket sendEvent:@"login" data:dict];
}

- (void) socketIO:(SocketIO *)socket didReceiveError:(NSString *)error
{
    if ([_delegate respondsToSelector:@selector(SocketIOManagerDidReceiveError:)]) {
        [_delegate SocketIOManagerDidReceiveError:error];
    }

    
}























@end
