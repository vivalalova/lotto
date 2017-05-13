//
//  PhonePickGiftView.h
//  LiveProject
//
//  Created by coolyouimac01 on 16/4/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "XibView.h"
@class GiftListModel;
@class GiftOneModel;
@protocol PhonePickGiftViewDelegate <NSObject>
-(void)didClickPhoneRechargeButton;
-(void)didClickOneGiftViewSelectGiftOneModel:(GiftOneModel*)giftOneModel;
-(void)didCilckPhoneSendButtonWithGiftOneModel:(GiftOneModel*)giftOneModel;
@end
@interface PhonePickGiftView : UIView
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomBgView;
@property (strong,nonatomic) NSString *picPath;
@property (assign, nonatomic) id<PhonePickGiftViewDelegate>delegate;
-(void)setDataWithGiftListModel:(GiftListModel*)giftListModel;
-(void)setDataWithUserMoney;
@end
