//
//  PhoneReceiveGiftView.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/4/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PhoneReceiveGiftView.h"
#import "UserSendGiftModel.h"
#import "THLabel.h"
@interface PhoneReceiveGiftView ()
@end
@implementation PhoneReceiveGiftView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor=[UIColor clearColor];
    _headIV.layer.cornerRadius=_headIV.height/2;
    _headIV.layer.masksToBounds=YES;
    
    _nameLbl.textColor=[UIColor whiteColor];
    _giftNameLbl.textColor=[UIColor colorWithRed:213/255.0 green:228/255.0 blue:112/255.0 alpha:1];
    _giftNameLbl.adjustsFontSizeToFitWidth=YES;
    _numLbl.strokeColor=[UIColor colorWithRed:213/255.0 green:228/255.0 blue:112/255.0 alpha:1];
    _numLbl.strokeSize=1.0;
    _numLbl.gradientStartColor=[UIColor colorWithRed:95/255.0 green:180/255.0 blue:95/255.0 alpha:1];
}
- (void)showInView:(UIView *)view position:(CGPoint)point duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay userSendGiftModel:(UserSendGiftModel *)model{
    _nameLbl.text=[NSString stringWithFormat:@"%@",[model.fromUser stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
    _numLbl.text=[NSString stringWithFormat:@"X %@",model.serial_count];
    _giftImageView.image=model.giftImage;
    [_headIV setImageWithUrlString:[NSString stringWithFormat:@"%@%@",URI_BASE_SERVER,model.user_head_img] placeholderImage:[UIImage imageNamed:@"lp_home_imageloader_defult.png"]];
    self.hidden=NO;
    [self setTop:point.y];
    [self setLeft:point.x];
    [view addSubview:self];
    // Start
    self.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth([UIScreen mainScreen].bounds), 0);
     _giftImageView.transform=CGAffineTransformMakeTranslation(-CGRectGetWidth([UIScreen mainScreen].bounds), 0);
    _numLbl.hidden=YES;
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        // End
        self.transform = CGAffineTransformMakeTranslation(0, 0);
        [UIView animateKeyframesWithDuration:duration delay:duration/2 options:0 animations:^{
            _giftImageView.transform=CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            [self showNumWithDuration:duration/2 delay:0];
        }];
    } completion:^(BOOL finished) { }];
}
- (void)showNumWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay{
  
    // Start
    _numLbl.hidden=NO;
    _numLbl.transform = CGAffineTransformMakeScale(3, 3);
    _numLbl.alpha = 0;
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        // End
        _numLbl.transform = CGAffineTransformMakeScale(1, 1);
        _numLbl.alpha = 1;
    } completion:^(BOOL finished) {
      [self performSelector:@selector(hideFromView) withObject:nil afterDelay:1.0];
    }];
}
- (void)hideFromView{
    self.hidden=YES;
}
@end
