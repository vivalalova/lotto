//
//  MessageHelper.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/5/19.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "MessageHelper.h"

@interface MessageHelper ()
{
    NSString *totalMessageNum;
    NSTimer *timer;
}
@end
@implementation MessageHelper
- (id)init
{
    if (self = [super init]) {
        [self loadConfig];
    }
    return self;
}

static id instance;
+ (id)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}
- (void)loadConfig{
    totalMessageNum=@"0";
    if (timer==nil) {
        timer =[NSTimer scheduledTimerWithTimeInterval:kNotiRefreshTime target:self selector:@selector(timerClick) userInfo:nil repeats:YES];
    }
}
- (void)timerClick{
    [self getTotalNotReadRequest];
}
- (NSString *)totalMessageNum{
    if ([AccountHelper isLogin]) {
        return totalMessageNum;
    }else{
        return @"0";
    }
}
-(void)getTotalNotReadRequest{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([AccountHelper isLogin]) {
        [params setObject:User_Token forKey:@"token"];
    }
        [AFRequestManager SafePOST:URI_GetTotalNotRead parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            NSDictionary *result = [NSDictionary dictionaryWithDictionary:responseObject];
            if ([result[@"status"] intValue] == 200) {
                if ([result objectForKey:@"data"]) {
                    NSDictionary *dict=[result objectForKey:@"data"];
                    totalMessageNum=[dict objectForKey:@"total"];
                }
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:kGetTotalNotReadNumNotificaiton object:totalMessageNum];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kGetTotalNotReadNumNotificaiton object:totalMessageNum];
        }];
}
@end
