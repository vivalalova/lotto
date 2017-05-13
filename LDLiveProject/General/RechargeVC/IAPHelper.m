//
//  IAPHelper.m
//  LiveProject
//
//  Created by coolyouimac01 on 15/11/19.
//  Copyright © 2015年 Mac. All rights reserved.
//

#import "IAPHelper.h"
#import "MPNotificationView.h"

@interface IAPHelper ()<SKProductsRequestDelegate,SKPaymentTransactionObserver>
@property(strong,nonatomic)SKProductsRequest *request;
@property(strong,nonatomic)NSMutableSet *productIdentifiers;
@property(strong,nonatomic)NSArray *products;
@end
@implementation IAPHelper
- (void)requestProducts:(NSSet *)productIdentifiers{
    self.request = [[SKProductsRequest alloc] initWithProductIdentifiers:productIdentifiers];
    _request.delegate = self;
    [_request start];
    [[SKPaymentQueue defaultQueue]addTransactionObserver:self];
}
- (void)paymentWithProduct:(SKProduct *)product{
    if ([SKPaymentQueue canMakePayments]) {
        SKPayment *payment=[SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue]addPayment:payment];
    }
}
#pragma mark  SKProductsRequestDelegate
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    self.products=response.products;
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_products];
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    self.products=nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductsLoadedNotification object:_products];
}
#pragma mark SKPaymentTransactionObserver
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchased:
            [self completeTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"商品添加进列表");
                break;
            default:
                break;
        }
    }
}
- (void)completeTransaction:(SKPaymentTransaction *)transaction {
    [self provideContent: transaction];
    [self verifyPruchase:transaction];
}

- (void)provideContent:(SKPaymentTransaction *)transaction {
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchasedNotification object:transaction];
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    [self provideContent: transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kProductPurchaseFailedNotification object:transaction];
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
}

#pragma mark 验证购买凭据
- (void)verifyPruchase:(SKPaymentTransaction *)transaction
{
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    // 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSString *encodeStr = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    
    NSString *orderID=transaction.transactionIdentifier;
    NSString *productID=transaction.payment.productIdentifier;
    NSLog(@"orderID:%@,productID:%@",orderID,productID);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:User_Token forKey:@"token"];
    [params setObject:encodeStr forKey:@"receipt-data"];
    [params setObject:orderID forKey:@"order_id"];
    [params setObject:productID forKey:@"produce_id"];
    [params setObject:Bundle_App_Version forKey:@"ios_version"];
    NSString *md5Str = [self createMd5Sign:params];
    [params setObject:md5Str forKey:@"sign"];
    
    if (self.VIPBOOL) {
        [AFRequestManager SafePOST:URI_PayIosVip parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([((NSDictionary*)responseObject)[@"status"] intValue] == 200) {
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                UserModel *usermodel=[AccountHelper userInfo];
                usermodel.points = responseObject[@"data"][@"points"];
                usermodel.vip_expire = responseObject[@"data"][@"vip_expire"];
                usermodel.super_vip = @"1";
                [AccountHelper saveUserInfo:usermodel];
                [[NSNotificationCenter defaultCenter]postNotificationName:kProductVerifyNodtification object:nil];
            }else{
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                [[NSNotificationCenter defaultCenter]postNotificationName:kProductVerifyFailedNodtification object:[responseObject objectForKey:@"status_msg"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kProductVerifyFailedNodtification object:nil];
        }];
    }else{
        [AFRequestManager SafePOST:URI_IosReceipt parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([((NSDictionary*)responseObject)[@"status"] intValue] == 200) {
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                UserModel *usermodel=[AccountHelper userInfo];
                usermodel.gold=[[responseObject objectForKey:@"data"]objectForKey:@"user_points"];
                [AccountHelper saveUserInfo:usermodel];
                [[NSNotificationCenter defaultCenter]postNotificationName:kProductVerifyNodtification object:nil];
            }else{
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                [[NSNotificationCenter defaultCenter]postNotificationName:kProductVerifyFailedNodtification object:[responseObject objectForKey:@"status_msg"]];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kProductVerifyFailedNodtification object:nil];
        }];
    }
}

//创建package签名
-(NSString*) createMd5Sign:(NSMutableDictionary*)dict
{
    NSMutableString *contentString  =[NSMutableString string];
    NSArray *keys = [dict allKeys];
    //按字母顺序排序
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    //拼接字符串
    for (NSString *categoryId in sortedArray) {
        if (   ![[dict objectForKey:categoryId] isEqualToString:@""]
            && ![categoryId isEqualToString:@"sign"]
            && ![categoryId isEqualToString:@"key"]
            )
        {
            [contentString appendFormat:@"%@=%@&", categoryId, [dict objectForKey:categoryId]];
        }
        
    }
    //添加key字段
    [contentString appendFormat:@"key=%@", WXPartnerSecret];
    //得到MD5 sign签名
    NSString *md5Sign =[self md5:contentString];
    
    return md5Sign;
}

- (NSString *)md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}
@end
