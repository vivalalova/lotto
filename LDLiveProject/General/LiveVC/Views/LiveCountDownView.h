//
//  LiveCountDownView.h
//  LiveProject
//
//  Created by coolyouimac01 on 15/12/10.
//  Copyright © 2015年 Mac. All rights reserved.
//  倒计时

#import "XibView.h"

@protocol LiveCountDownViewDelegat <NSObject>

-(void)didHideFromSuperView;

@end

@interface LiveCountDownView : XibView

@property (weak, nonatomic) IBOutlet UILabel *countNum;
@property (weak, nonatomic) IBOutlet UILabel *countText;
@property (assign,nonatomic)id <LiveCountDownViewDelegat>delegate;
-(void)showInSuperView:(UIView *)view;
@end
