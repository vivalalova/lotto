//
//  IAPHelperManager.m
//  LiveProject
//
//  Created by coolyouimac01 on 15/11/19.
//  Copyright © 2015年 Mac. All rights reserved.
//

#import "IAPHelperManager.h"
static IAPHelperManager * _sharedHelper;
@implementation IAPHelperManager
+ (IAPHelperManager *) sharedHelper {
    
    if (_sharedHelper != nil) {
        return _sharedHelper;
    }
    _sharedHelper = [[IAPHelperManager alloc] init];
    return _sharedHelper;
    
}

@end
