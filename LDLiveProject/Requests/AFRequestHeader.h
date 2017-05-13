//
//  AFRequestHeader.h
//  LDLiveProject
//
//  Created by MAC on 16/5/30.
//  Copyright © 2016年 MAC. All rights reserved.
//

#ifndef AFRequestHeader_h
#define AFRequestHeader_h


#warning:IOS后台接口应用地址

//#define URI_BASE_SERVER      @"http://www.golf8.tv/"
#define URI_BASE_SERVER      @"http://tank37.3322.org:28001/"

//#define URI_BASE_SERVER      @"http://gf.myxstar.cn/"
//#define URI_BASE_SERVER      @"http://gtv.daofeng365.com/"

#define URI_ROOT             @"app/"
//socket成功发送的消息
#define URI_IndexText        @"index/txt"
//搜索
#define KEY_USER_NAME        @"index/search"
//第三方登录
#define URI_ThirdLogin       @"user/checkThirdLogin"
//用户个人信息
#define URI_GetInfo          @"user/getInfo"
//热门开播
#define URI_IndexShow        @"index/show"
//最新开播
#define URI_LastAnchor       @"index/lastAnchor"
//关注列表
#define URI_AttentionList    @"attention/AttentionpageList"
//首页滚屏
#define URI_HomeScroll       @"index/homeScroll"
//首页滚动停止详细信息
#define URI_IndexInfos       @"index/infos"
//个人财务信息
#define URI_UserFinance      @"user/finance"
//昵称
#define URI_UserNick         @"user/nick"
//性别
#define URI_UserGender       @"user/sex"
//个性签名
#define URI_UserEmotion      @"user/emotion"
//个人直播推流信息
#define URI_UserOwnTv        @"user/ownTv"
//socket信息
#define URI_ChatList         @"index/chatlist"
//开播
#define URI_RoomStart        @"room/start"
//停播
#define URI_RoomStop         @"room/stop"
//礼物列表
#define URI_GiftList         @"gift/getList"
//添加关注
#define URI_AddAttention     @"attention/addAttention"
//取消关注
#define URI_CancelAttention  @"attention/cancelAttention"
//查询关注状态
#define URI_IsAttention      @"attention/isAttention"
//上传头像
#define URI_HeadImgUpload    @"user/headImgUpload"
//获取用户信息
#define URI_GetInfoByAesId   @"index/getInfoByAesId"
//粉丝列表
#define URI_FansList         @"attention/fanspageList"
//搜索
#define URI_IndexSearch      @"index/search"
//支付列表
#define URI_IosProduceList   @"pay/iosProduceList"
//支付验证
#define URI_IosReceipt       @"pay/iosReceipt"
//手机获取验证码
#define URI_PCodeByPhone     @"user/PCodeByPhone"
//手机获取验证码后登录
#define URI_LoginByCode      @"user/loginByCode"
//举报
#define URI_IssueReport      @"issue/report"
//管理员列表
#define URI_GetManagerList   @"room/getManagerList"
//马甲列表
#define URI_VestList         @"user/vestList"
//开通马甲
#define URI_OpenVest         @"user/openVest"
//使用马甲
#define URI_UseVest          @"user/useVest"
//查询马甲等级
#define URI_VestLv           @"user/vestLv"

//查询未读消息
#define URI_GetTotalNotRead  @"message/getTotalNotRead"
//消息列表
#define URI_MessageList      @"message/list"
//发送消息
#define URI_SendMsg          @"message/sendMsg"
//消息记录
#define URI_GetHistoryMsg    @"message/getHistoryMsg"
//消息删除
#define URI_MsglogDel        @"message/del"
//最新消息
#define URI_GetLastMsg       @"message/getLastMsg"
//删除与别人消息的全部消息
#define URI_DelUserAll       @"message/delUser"
//忽略所有未读消息
#define URI_readAllMsg       @"message/readAllMsg"
//贡献排行榜
#define URI_AnchorContribution   @"user/anchorContribution"
//个人修改城市
#define URI_UserHometown     @"user/hometown"
//个人修改生日
#define URI_UserBirthday     @"user/birthday"
//个人修改情感状态
#define URI_UserWood         @"user/mood"
//个人修改职业
#define URI_UserProfession   @"user/profession"
//黑名单列表
#define URI_AttBlacklist     @"attention/blacklist"
//添加黑名单
#define URI_AttAddBlack      @"attention/addblack"
//删除黑名单
#define URI_AttDelBlack      @"attention/delblack"
//查询用户等级信息
#define URI_GetExpInfo       @"index/getExpInfo"
//绑定微信
#define URI_BindWeiXin       @"pay/bindWeiXin"
//绑定手机
#define URI_SetPhone         @"user/setPhone"
//微信提现
#define URI_WXWithdrawals    @"pay/weixinWithdrawals"
//获取录像
#define URI_GetVideo         @"index/videorecord"
//Vip列表
#define URI_GetVIPList       @"user/viplist"
//购买Vip
#define URI_BuyVIP           @"user/buyvip"
//访问视频录像
#define URI_VisitVedio       @"index/visitvedio"
//视频录像删除
#define URI_DelVedio         @"index/delvedio"
//vip购买验证
#define URI_PayIosVip        @"pay/iosvip"
//他人关注列表
#define URI_attentionaesid   @"attention/attentionaesid"
//他人粉丝列表
#define URI_fansaesid        @"attention/fansaesid"
//提现记录
#define URI_PayWXCash        @"pay/wxcash"

#endif /* AFRequestHeader_h */
