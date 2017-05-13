//
//  BaseModel.h
//  AFNetworking-demo
//
//  Created by Jakey on 14-7-22.
//  Copyright (c) 2014年 Jakey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "NSDictionary+JSONString.h"
#import "NSString+DictionaryValue.h"
//https://github.com/icanzilb/JSONModel  JSONModel使用
@interface BaseModel : JSONModel
- (NSString *)json;
- (NSDictionary *)dictionary;

//若果需要缓存，则必须实现的方法
- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;
@end
