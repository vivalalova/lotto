//
//  PhoneLiveShareView.h
//  LiveProject
//
//  Created by coolyouimac01 on 16/1/5.
//  Copyright © 2016年 Mac. All rights reserved.
//  手机播放分享页面

typedef enum
{
    ArrowToBottom=0,//箭头在下,默认
    ArrowToRight=1,//箭头在右
    ArrowToUp=2,//箭头在上
}ArrowDirectionType;
#import "XibView.h"

@protocol PhoneLiveShareDelegate <NSObject>

/*默认为0，自己的回放视频为1*/
-(void)selectButtonWithTag:(NSInteger)tag type:(int)type;

@end
@interface PhoneLiveShareView : XibView
-(void)showInView:(UIView *)view withRect:(CGRect)rect arrow:(CGFloat)position;
-(void)showInView:(UIView *)view withRect:(CGRect)rect;
-(void)hideFromView;
@property(nonatomic,assign)id<PhoneLiveShareDelegate>delegate;
@property(nonatomic,assign) ArrowDirectionType arrowtype;
@property(nonatomic,assign)BOOL isSelfVideo;//是否是自己的视频
@end
