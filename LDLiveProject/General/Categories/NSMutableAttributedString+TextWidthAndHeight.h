//
//  NSAttributedString+TextWidthAndHeight.h
//  TextKitDemo
//
//  Created by coolyouimac01 on 16/3/31.
//  Copyright © 2016年 coolyouimac01. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSMutableAttributedString (TextWidthAndHeight)
//获取文本宽度，高度
- (CGFloat)widthWithSize:(CGSize)size;
- (CGFloat)heightWithSize:(CGSize)size;
- (CGFloat)widthWithFont:(UIFont*)font boundingRectWithSize:(CGSize)size;
- (CGFloat)heightWithFont:(UIFont*)font boundingRectWithSize:(CGSize)size;
- (CGSize)sizeWithFont:(UIFont*)font boundingRectWithSize:(CGSize)size;
@end
