//
//  VersionServiceManager.m
//  ZWProject
//
//  Created by hdcai on 15/6/11.
//  Copyright (c) 2015年 ZGX. All rights reserved.
//

#import "VersionServiceManager.h"

@interface VersionServiceManager () <UIAlertViewDelegate>{
    BOOL _foreUpate; //是否强制更新
}
@end

@implementation VersionServiceManager

DEF_SINGLETON(VersionServiceManager)

- (void)dealloc {

}

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)isHasNewVersionWithDict:(NSDictionary*)dict
{
    _foreUpate = [dict[@"data"][@"isudpate"] intValue];
    NSString *appVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    if ([self decideVersionIsUpdateWithVersion:appVersion serverVersion:dict[@"data"][@"ver"]]) {
        if (!_foreUpate) {
            UIAlertView *alv=[[UIAlertView alloc]initWithTitle:@"秀播高尔夫客户端有新版本啦,是否更新?" message:@"" delegate:self cancelButtonTitle:@"不,谢谢" otherButtonTitles:@"更新", nil];
            alv.tag = 999;
            [alv show];
        }else{
            UIAlertView *alv=[[UIAlertView alloc]initWithTitle:@"秀播高尔夫客户端有新版本啦,为了您的更好体验请前往更新。" message:@"" delegate:self cancelButtonTitle:@"更新" otherButtonTitles: nil];
            alv.tag = 888;
            [alv show];
        }
    }else{
        NSLog(@"没有更新的版本");
    }
}

- (BOOL)decideVersionIsUpdateWithVersion:(NSString *)nVersion serverVersion:(NSString *)sVersion{
    //  2.2.2 1.1.1
    NSArray *nArray=[nVersion componentsSeparatedByString:@"."];
    NSArray *sArray=[sVersion componentsSeparatedByString:@"."];
    int a=0;
    for (NSString *str in nArray) {
        if ([str intValue]<[sArray[a] intValue]) {
            return YES;
        }
        a++;
    }
    return NO;
}
/**
 *  启动app store
 */
- (void)startAppStore
{
    if (IOS_VERSION_CODE  < 7) {
        NSString * appstoreUrlString = [NSString stringWithFormat:@"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?mt=8&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software&id=%@",[ConfigHelper appleID]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrlString]];
    } else {
        NSString * appstoreUrlString = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",[ConfigHelper appleID]];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:appstoreUrlString]];
    }
}
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1 && alertView.tag == 999) {
        [self startAppStore];
    }
    if (buttonIndex == 0 && alertView.tag == 888) {
        [self startAppStore];
    }
}
@end
