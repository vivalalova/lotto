//
//  IAPHelper.h
//  LiveProject
//
//  Created by coolyouimac01 on 15/11/19.
//  Copyright © 2015年 Mac. All rights reserved.
//  内购

#import <Foundation/Foundation.h>
#import "StoreKit/StoreKit.h"

#define kProductsLoadedNotification         @"ProductsLoaded"
#define kProductPurchasedNotification       @"ProductPurchased"
#define kProductPurchaseFailedNotification  @"ProductPurchaseFailed"
#define kProductVerifyNodtification         @"ProductVerify"
#define kProductVerifyFailedNodtification   @"ProductVerifyFailed"
@interface IAPHelper : NSObject

@property (nonatomic, assign)BOOL VIPBOOL;
- (void)requestProducts:(NSSet *)productIdentifiers;
- (void)paymentWithProduct:(SKProduct *)product;
@end
