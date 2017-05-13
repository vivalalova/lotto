//
//  PhoneLiveAnchorIsLeavingView.m
//  LiveProject
//
//  Created by coolyouimac02 on 16/4/13.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PhoneLiveAnchorIsLeavingView.h"
#import <Accelerate/Accelerate.h>

@interface PhoneLiveAnchorIsLeavingView ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIImageView *bgimageView;

@end


@implementation PhoneLiveAnchorIsLeavingView

- (void)awakeFromNib
{
    // 圆角
    _attentonButon.layer.cornerRadius = 10;
    _attentonButon.layer.borderWidth = 1.0;
    _attentonButon.layer.borderColor = HomeColorForHexKey(AppColor_Home_Basic_Blue).CGColor;
    _attentonButon.layer.masksToBounds = YES;
    // 圆角
    _backButton.layer.cornerRadius = 10;
    _backButton.layer.borderWidth = 1.0;
    _backButton.layer.borderColor = HomeColorForHexKey(AppColor_Home_Basic_Blue).CGColor;
    _backButton.layer.masksToBounds = YES;
    
    [self setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    [_bgimageView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    
    self.alpha = 0;
    [UIView beginAnimations:@"ShowIsLeavingView" context:nil];
    [UIView setAnimationDuration:1];
    self.alpha = 1;
    [UIView commitAnimations];
}

//- (void)setAnchormodel:(AnchorModel *)anchormodel
//{
//    _anchormodel = anchormodel;
//    
//    NSURL *url = [NSURL URLWithString:[anchormodel.uhimg PicUrlStringWithHostUrl]];
//    
//    // 高斯模糊
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CIImage *image1 = [CIImage imageWithContentsOfURL:url];
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [filter setValue:image1 forKey:kCIInputImageKey];
//    [filter setValue:@1.f forKey: @"inputRadius"];
//    CIImage *result = [filter valueForKey:kCIOutputImageKey];
//    CGImageRef outImage = [context createCGImage: result fromRect:[result extent]];
//    UIImage * blurImage = [UIImage imageWithCGImage:outImage];
//
//    _bgimageView.image = blurImage;
//}

- (void)setIs_att_Room:(BOOL)is_att_Room
{
    _is_att_Room = is_att_Room;
    if (is_att_Room) {
        [self.attentonButon setTitle:@"已关注" forState:UIControlStateNormal];
    } else {
        [self.attentonButon setTitle:@"关注" forState:UIControlStateNormal];
    }
    
}

#pragma 分享按钮
- (IBAction)sinaClick:(UIButton *)sender {
    sender.tag=100;
    [self selectButtonWithTag:sender.tag];
}
- (IBAction)wXFriend:(UIButton *)sender {
    sender.tag=101;
    [self selectButtonWithTag:sender.tag];
}
- (IBAction)wXClick:(UIButton *)sender {
    sender.tag=102;
    [self selectButtonWithTag:sender.tag];
}

- (IBAction)qqClick:(UIButton *)sender {
    sender.tag=103;
    [self selectButtonWithTag:sender.tag];
}
- (IBAction)qqZoneClick:(UIButton *)sender {
    sender.tag=104;
    [self selectButtonWithTag:sender.tag];
}
#pragma 代理方法
-(void)selectButtonWithTag:(NSInteger)tag{
    if ([self.delegate respondsToSelector:@selector(selectAnchorIsLeaveingButtonWithTag:)]) {
        [self.delegate selectAnchorIsLeaveingButtonWithTag:tag-100];
    }
}

- (IBAction)didSelectionAttentionButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectAttentionButton:)]) {
        [self.delegate selectAttentionButton:sender];
    }
}

- (IBAction)didSelectBackButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(selectBackButton:)]) {
        [self.delegate selectBackButton:sender];
    }
}

- (void)removeFromPhoneLiveVC
{
    [UIView beginAnimations:@"ShowIsLeavingViewRemove" context:nil];
    [UIView setAnimationDuration:1];
    self.alpha = 0;
    [self removeFromSuperview];
    [UIView commitAnimations];
}

@end
