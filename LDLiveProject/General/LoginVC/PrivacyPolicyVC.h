//
//  PrivacyPolicyVC.h
//  LDLiveProject
//
//  Created by MAC on 16/7/16.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BasisVC.h"

typedef enum {
    kLoginPolicyType=0,//登录页过来的
    kUserPolicyType=1,//关于我们页跳转过来-用户协议
    kAnchorPolicyType=2,//关于我们页跳转过来-主播协议
}PrivacyPolicyType;

@interface PrivacyPolicyVC : BasisVC

@property (nonatomic,assign)PrivacyPolicyType policyType;

@end
