//
//  timer.h
//  circleDemo
//
//  Created by coolyouimac01 on 16/4/1.
//  Copyright © 2016年 coolyouimac01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendGiftButton : UIButton
@property(assign,nonatomic)float progress;
@property(assign,nonatomic)float currentProgress;
@property(nonatomic,strong)UIColor *tintColor;
@property(nonatomic,strong)UIColor *tintBgColor;
@property(nonatomic,strong)UIColor *textBgColor;
@property(nonatomic,strong)NSString *text;
- (id)initWithFrame:(CGRect)frame;
- (void)refreshUI:(float)a;
@end
