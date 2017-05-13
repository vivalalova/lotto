//
//  PhoneGiftView.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/4/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PhoneGiftView.h"
#import "GiftOneModel.h"
@interface PhoneGiftView ()
@property (weak, nonatomic) IBOutlet UIImageView *giftlockIV;

@end
@implementation PhoneGiftView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _giftLabel.backgroundColor = [UIColor clearColor];
    _giftLabel.textColor = [UIColor colorWithHexString:GiftUsualColor];
    _giftLabel.font = [UIFont systemFontOfSize:13];
    _giftLabel.textAlignment = NSTextAlignmentRight;
    
    _selectImageV.layer.cornerRadius = 2;
    _selectImageV.layer.masksToBounds = YES;
    
    _is_lineLabel.backgroundColor = [UIColor clearColor];
    _is_lineLabel.layer.cornerRadius = 2;
    _is_lineLabel.layer.borderColor = [UIColor whiteColor].CGColor;
    _is_lineLabel.layer.borderWidth = 1;
    
}
-(void)setDataWithModel:(GiftOneModel *)giftModel
{
    _giftOneModel = giftModel;
    [self.giftImageView setImageWithUrlString:[NSString stringWithFormat:@"%@%@.png",self.picPath,giftModel.gpic]];
    
    self.giftLabel.attributedText = nil;
    [self.giftLabel appendText:[NSString stringWithFormat:@"%@",giftModel.gprice]];
    [self.giftLabel appendImage:[UIImage imageNamed:@"room_money"]];
    
    
    self.gid = giftModel.gid;
    self.giftPriceLabel.text = [NSString stringWithFormat:@"%@",giftModel.gname];
    
    if (![giftModel.is_line intValue]) {
        _is_lineLabel.hidden = YES;
    }
    
//    int vip_type=[[[NSUserDefaults standardUserDefaults]objectForKey:@"vip_type"]intValue];
//    int richlevel=[[[NSUserDefaults standardUserDefaults]objectForKey:@"richlevel"]intValue];
//    if (((vip_type==-1&&[_giftOneModel.gtype intValue]==5)||(richlevel<10&&[_giftOneModel.gtype intValue]==4))) {
//        _giftlockIV.hidden=NO;
//        _giftImageView.alpha=0.5;
//    }else{
        _giftlockIV.hidden=YES;
        _giftImageView.alpha=1.0;
//    }
}

- (IBAction)giftButtonClick:(id)sender {
//    int vip_type=[[[NSUserDefaults standardUserDefaults]objectForKey:@"vip_type"]intValue];
//    int richlevel=[[[NSUserDefaults standardUserDefaults]objectForKey:@"richlevel"]intValue];
//    if (!((vip_type==-1&&[_giftOneModel.gtype intValue]==5)||(richlevel<10&&[_giftOneModel.gtype intValue]==4))) {
        if ([_delegate respondsToSelector:@selector(didSelectedOneGift:)]) {
            [_delegate didSelectedOneGift:_giftOneModel];
        }
//    }
}


@end
