//
//  AccountHelper.m
//  Carte
//
//  Created by ligh on 14-4-29.
//
//

#import "AccountHelper.h"

@implementation AccountHelper

+ (BOOL)isLogin {
    return [self userInfo] != nil && ![NSString isBlankString:[self uid]];
}

+ (UserModel *)userInfo {
    return (UserModel *)[[DataCacheManager sharedManager] getCachedObjectByKey:Store_UserInfoKey];
}

+ (NSString *)uid
{
    NSString *u_id = [self userInfo].u_id;
    return u_id;
}
+ (NSString *)user_token
{
    UserModel *userModel = [self userInfo];
    NSString *token = userModel.token;
    return token;
}
+ (NSString *)currentUserToken
{
    UserModel *userModel = [self userInfo];
    NSString *token = userModel.currentToken;
    if ([NSString isBlankString:token]) {
        return [self user_token];
    }
    return token;
}
+ (void)saveUserInfo:(UserModel *)userInfoModel {
    [[DataCacheManager sharedManager] addObject:userInfoModel forKey:Store_UserInfoKey];
}

+ (void)logout {
    [[DataCacheManager sharedManager] removeObjectInCacheByKey:Store_UserInfoKey];
}

//DeviceToken
+ (void)saveDeviceToken:(NSString *)token {
    [[DataCacheManager sharedManager] addObject:token forKey:KDeviceTokenKey];
}

+ (NSString *)getDeviceToken {
    NSString *deviceToken;
    NSObject *deviceToken_Object = [[DataCacheManager sharedManager] getCachedObjectByKey:KDeviceTokenKey];
    if ([deviceToken_Object isKindOfClass:[NSString class]]) {
        deviceToken = [NSString stringWithFormat:@"%@",deviceToken_Object];
    }
    if ([NSString isBlankString:deviceToken]) {
        deviceToken = @"";
    }
    return deviceToken;
}

//单点登录唯一识别字段
+ (void)saveLoginTypeCode {
    NSTimeInterval timeDate=[[NSDate date] timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", timeDate];
    [[DataCacheManager sharedManager] addObject:timeString forKey:kLoginTypeCodeKey];
}

+ (NSString *)getLoginTypeCode {
    NSString *loginTime;
    NSObject *loginTimeObject = [[DataCacheManager sharedManager] getCachedObjectByKey:kLoginTypeCodeKey];
    if ([loginTimeObject isKindOfClass:[NSString class]]) {
        loginTime = [NSString stringWithFormat:@"%@",loginTimeObject];
    }
    if ([NSString isBlankString:loginTime]) {
        loginTime = @"";
    }
    return loginTime;
}

////弹幕设置的信息
//+(void)saveDanMuSettingModel:(DanMuSettingModel*)danmuModel;
//{
//    [[DataCacheManager sharedManager] addObject:danmuModel forKey:Danmu_SettingKey];
//}
//+(DanMuSettingModel*)getDanmuSettingModel;
//{
//    return (DanMuSettingModel *)[[DataCacheManager sharedManager] getCachedObjectByKey:Danmu_SettingKey];
//}
////观看历史
//+(void)saveWatchHistoryModel:(WatchHistoryModel *)watchHistoryModel{
//    [[DataCacheManager sharedManager]addObject:watchHistoryModel forKey:Watch_HistoryKey];
//}
//+(WatchHistoryModel*)getWatchHistoryModel
//{
//    return (WatchHistoryModel*)[[DataCacheManager sharedManager]getCachedObjectByKey:Watch_HistoryKey];
//}
////搜索历史
//+(void)saveSearchHistoryModel:(SearchHistoryModel*)searchHistoryModel
//{
//    [[DataCacheManager sharedManager]addObject:searchHistoryModel forKey:Search_HistoryKey];
//}
//+(SearchHistoryModel*)getSearchHistoryModel
//{
//    return (SearchHistoryModel*)[[DataCacheManager sharedManager]getCachedObjectByKey:Search_HistoryKey];
//}
//是否绑定微信
+(BOOL)isBindWX{
    return NO;
//    return ![NSString isBlankString:[self userInfo].wxOpenid];
}
@end
