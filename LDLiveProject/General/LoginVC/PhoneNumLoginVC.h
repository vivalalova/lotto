//
//  PhoneNumLoginVC.h
//  LDLiveProject
//
//  Created by MAC on 16/6/15.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BasisVC.h"

@protocol PhoneNumLoginVCDelegate <NSObject>

- (void)BingPhoneNumSuccessDelegate;

@end

@interface PhoneNumLoginVC : BasisVC
@property (nonatomic,assign) id<PhoneNumLoginVCDelegate>delegate;
@property (nonatomic,assign)BOOL LoginVCBool;
@end
