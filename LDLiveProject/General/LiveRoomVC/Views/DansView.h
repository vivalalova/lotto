//
//  DansView.h
//  DansDemo
//
//  Created by coolyouimac02 on 16/6/20.
//  Copyright © 2016年 coolyouimac02. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XibView.h"
@interface DansView : XibView

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *url;

- (void)star;

@end
