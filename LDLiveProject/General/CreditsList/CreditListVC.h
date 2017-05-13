//
//  CreditListVC.h
//  LDLiveProject
//
//  Created by MAC on 16/9/2.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BasisVC.h"

@protocol CreditListVCDelegate <NSObject>

- (void)didClickHiddenCreditListVCAction;

@end

@interface CreditListVC : BasisVC<SRRefreshDelegate>
@property (nonatomic,assign) BOOL CreditListVCDelegateResponseBool;
@property (nonatomic,assign)id<CreditListVCDelegate>delegate;
@property (nonatomic,strong)NSString *aesIdStr;
@end
