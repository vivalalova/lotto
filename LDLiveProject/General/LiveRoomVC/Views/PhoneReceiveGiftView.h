//
//  PhoneReceiveGiftView.h
//  LiveProject
//
//  Created by coolyouimac01 on 16/4/5.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "XibView.h"
@class UserSendGiftModel;
@class THLabel;
@interface PhoneReceiveGiftView : XibView
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *giftNameLbl;
@property (weak, nonatomic) IBOutlet WebImageView *giftImageView;
@property (weak, nonatomic) IBOutlet WebImageView *headIV;
@property (weak, nonatomic) IBOutlet THLabel *numLbl;

@property (strong,nonatomic)UserSendGiftModel *userSendGiftModel;
- (void)showInView:(UIView *)view position:(CGPoint)point duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay userSendGiftModel:(UserSendGiftModel *)model;
@end
