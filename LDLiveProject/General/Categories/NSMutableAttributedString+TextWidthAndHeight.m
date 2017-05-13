//
//  NSAttributedString+TextWidthAndHeight.m
//  TextKitDemo
//
//  Created by coolyouimac01 on 16/3/31.
//  Copyright © 2016年 coolyouimac01. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "NSMutableAttributedString+TextWidthAndHeight.h"

@implementation NSMutableAttributedString (TextWidthAndHeight)
//获取文本宽度，高度
- (CGFloat)widthWithSize:(CGSize)size{
    return [self sizeWithFont:nil boundingRectWithSize:size].width;
}
- (CGFloat)heightWithSize:(CGSize)size{
    return [self sizeWithFont:nil boundingRectWithSize:size].height;
}
- (CGFloat)widthWithFont:(UIFont*)font boundingRectWithSize:(CGSize)size{
    return [self sizeWithFont:font boundingRectWithSize:size].width;
}
- (CGFloat)heightWithFont:(UIFont*)font boundingRectWithSize:(CGSize)size{
    return [self sizeWithFont:font boundingRectWithSize:size].height;
}
- (CGSize)sizeWithFont:(UIFont*)font boundingRectWithSize:(CGSize)size{
    if (font) {
        [self addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.length)];
    }
    CGSize resultSize=[self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil ].size;
    return resultSize;
}
@end
