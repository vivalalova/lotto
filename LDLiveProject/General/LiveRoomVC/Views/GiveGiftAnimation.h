//
//  GiveGiftAnimation.h
//  气泡Demo
//
//  Created by coolyouimac01 on 15/12/17.
//  Copyright © 2015年 coolyouimac01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface GiveGiftAnimation : NSObject
@property(nonatomic,strong)UIView *view;//动画要展示在那个View上 必传
@property(nonatomic,strong)UIImage *image;
@property(nonatomic,assign)int number;
+(instancetype)shareAnimation;
-(void)start;//开始动画
@end
