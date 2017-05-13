//
//  PhoneGiftView.h
//  LiveProject
//
//  Created by coolyouimac01 on 16/4/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "XibView.h"
@class GiftOneModel;

@protocol PhoneGiftViewDelegate <NSObject>

-(void)didSelectedOneGift:(GiftOneModel*)oneGiftModel;

@end
@interface PhoneGiftView : XibView
@property (assign, nonatomic)id<PhoneGiftViewDelegate>delegate;

@property (strong,nonatomic) NSString *picPath;

@property (weak, nonatomic) IBOutlet UILabel *is_lineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageV;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *giftLabel;
@property (weak, nonatomic) IBOutlet WebImageView *giftImageView;
@property (weak, nonatomic) IBOutlet UILabel *giftPriceLabel;
@property (strong, nonatomic) NSString *gid;
@property (retain, nonatomic) GiftOneModel *giftOneModel;
-(void)setDataWithModel:(GiftOneModel *)giftModel;
@end
