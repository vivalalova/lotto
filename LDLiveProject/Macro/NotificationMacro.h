//
//  NotificationMacro.h
//  MinFramework
//
//   里放的是通知相关的宏定义
//
//  Created by ligh on 14-3-10.
//
//

#ifndef MinFramework_NotificationMacro_h
#define MinFramework_NotificationMacro_h

#define kNotiRefreshTime  60.f
#define kListRefreshTime  30.f
#define kChatRefreshTime  10.f//消息定时器时间
//获取未读消息总数
#define kGetTotalNotReadNumNotificaiton @"kGetTotalNotReadNumNotificaiton"
//订单状态改变通知
#define KOrderListRefreshNotification @"RefreshOrderListNotificaiton"
//充值回调的通知
#define kRechargeConfirmNotification  @"RechareConfirmVCNotification"
//改变个人信息后发出通知
#define kUserInfoChangedNotification  @"kUserInfoChangedNotification"
//从新登录后发出的通知
#define kLoginOnceMoreNotification    @"kLoginOnceMoreNotification"
//
#define kBecomeActiveNotification     @"kLoginBecomeActiveNotification"
///////////********************//////////
//视频播放优先级
#define kNewLiveRoomPlayActiveNotification     @"kNewLiveRoomPlayActiveNotification"

///
#define kNetworkStatusChangedNotification @"kNetworkStatusChangedNotification"

/*
 *
 */

//loading页移除
#define NotificationLoadingViewRemove  @"LoadingViewRemove"
//刷新订单列表
#define kRefreshOrdersListNotification @"RefreshOrdersListNotification"


#endif
