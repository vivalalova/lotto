//
//  PhoneLiveBoxView.h
//
//  Created by coolyouimac01 on 16/1/4.
//  Copyright © 2016年 coolyouimac01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneLiveBoxView : UIView
@property(nonatomic,strong)UIView *contentView;//所有的视图都加在该View上
@property(nonatomic,strong)UIColor *bgColor;
@property(nonatomic,assign)CGFloat arrowX;
@property(nonatomic,assign)CGFloat arrowSite;//该值在0~1之间箭头的位置,默认为0.5中间位置
@end
