//
//  PhoneLiveCellTool.h
//  LiveProject
//
//  Created by coolyouimac01 on 16/4/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SocketMessageModel;
@class GiftOneModel;
@class UserWelcomeModel;
@class UserSendGiftModel;
@interface PhoneLiveCellTool : NSObject
@property (strong, nonatomic)NSString *giftPicBaseUrlStr;

-(CGSize)cellSizeWithModel:(SocketMessageModel *)sMessageModel maxWidth:(CGFloat)maxWidth minHeight:(CGFloat)minHeight font:(CGFloat)font;
-(CGSize)cellSizeWithMsg:(NSString *)msgStr maxWidth:(CGFloat)maxWidth minHeight:(CGFloat)minHeight font:(CGFloat)font;
-(CGSize)cellSizeWithWelcomeModel:(UserWelcomeModel *)model maxWidth:(CGFloat)maxWidth minHeight:(CGFloat)minHeight font:(CGFloat) font;
-(CGSize)cellSizeWithGiftModel:(UserSendGiftModel *)model giftOneModel:(GiftOneModel *)giftOneModel maxWidth:(CGFloat)maxWidth minHeight:(CGFloat)minHeight font:(CGFloat) font isAnchorBool:(BOOL)isAnchorBool;
-(CGSize)cellSizeWithMsgDict:(NSDictionary *)dict maxWidth:(CGFloat)maxWidth minHeight:(CGFloat)minHeight font:(CGFloat) font;
-(CGSize)cellSizeWithUpdateDict:(NSDictionary *)dict maxWidth:(CGFloat)maxWidth minHeight:(CGFloat)minHeight font:(CGFloat) font;
-(CGSize)cellSizeWithBubbleDict:(NSDictionary *)dict maxWidth:(CGFloat)maxWidth minHeight:(CGFloat)minHeight font:(CGFloat) font;
@end
