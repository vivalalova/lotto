//
//  BaseModel.m
//  AFNetworking-demo
//
//  Created by Jakey on 14-7-22.
//  Copyright (c) 2014年 Jakey. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

#pragma mark -
#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)json {
    
    NSDictionary *dictOfObject = [self dictionary];
    
    NSError *error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictOfObject options:NSJSONWritingPrettyPrinted error:&error];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return json;
}

- (NSDictionary *)dictionary {
    return [self toDictionary];
}
+(BOOL)propertyIsOptional:(NSString*)propertyName
{
    return YES;
}
@end
