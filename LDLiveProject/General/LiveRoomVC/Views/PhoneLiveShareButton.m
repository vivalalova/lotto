//
//  PhoneLiveShareButton.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/1/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PhoneLiveShareButton.h"

@implementation PhoneLiveShareButton
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    CGRect rect=CGRectMake(self.frame.size.width*0.4, 0, self.frame.size.width*0.6, self.frame.size.height);
    return rect;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    CGRect rect=CGRectMake(0, 0, self.frame.size.width*0.4, self.frame.size.height);
    return rect;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
