//
//  PhonePickGiftView.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/4/1.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PhonePickGiftView.h"
#import "GiftListModel.h"
#import "PhoneGiftView.h"
#import "GiftOneModel.h"
@interface PhonePickGiftView ()<UIScrollViewDelegate,PhoneGiftViewDelegate>
{
    GiftListModel *_giftListModel;
    int _pageIndex;
    GiftOneModel *_currentChooseGift;//当前选择的礼物
}
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet M80AttributedLabel *userInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *chargeBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *giftScrollView;
@property (weak, nonatomic) IBOutlet UILabel *canNotSelectLabel;

@end
@implementation PhonePickGiftView
-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor=[[UIColor blackColor]colorWithAlphaComponent:0.7];
    _chargeBtn.backgroundColor=[UIColor clearColor];
    [_chargeBtn setTitleColor:[UIColor colorWithHexString:GiftUsualColor] forState:UIControlStateNormal];
    
    _sendBtn.backgroundColor = [UIColor colorWithHexString:@"0x313030"];
    [_sendBtn setTitleColor:[UIColor colorWithHexString:@"0x7f7f7f"] forState:UIControlStateNormal];
    
    _pageControl.currentPageIndicatorTintColor=[UIColor colorWithHexString:GiftUsualColor];
    _pageControl.pageIndicatorTintColor=[UIColor whiteColor];
    _giftScrollView.delegate = self;
    
    _userInfoLabel.backgroundColor = [UIColor clearColor];
    _userInfoLabel.font = [UIFont systemFontOfSize:13];
    _userInfoLabel.textColor = [UIColor colorWithHexString:@"0xb8b8b8"];

    
    _canNotSelectLabel.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.8];
    _canNotSelectLabel.textColor = [UIColor whiteColor];
    _canNotSelectLabel.hidden = YES;
    
}
- (IBAction)sendBtnClick:(UIButton *)sender {
    if ([_delegate respondsToSelector:@selector(didCilckPhoneSendButtonWithGiftOneModel:)]) {
        [_delegate didCilckPhoneSendButtonWithGiftOneModel:_currentChooseGift];
    }
}
- (IBAction)chargeBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didClickPhoneRechargeButton)]) {
        [self.delegate didClickPhoneRechargeButton];
    }
}
-(void)setDataWithGiftListModel:(GiftListModel*)giftListModel
{
    _giftListModel = giftListModel;
    [self rebuildGiftScrollViewUI];
    
}
-(void)setDataWithUserMoney
{
    NSString *string = [[NSUserDefaults standardUserDefaults]objectForKey:@"gold"];
    _userInfoLabel.attributedText = nil;
    if ([NSString isBlankString:string]) {
        [_userInfoLabel appendText:@"0"];
        [_userInfoLabel appendText:@"  "];
        [_userInfoLabel appendImage:[UIImage imageNamed:@"room_money"]];
        [_userInfoLabel appendText:@"  "];
        [_userInfoLabel  appendImage:[UIImage imageNamed:@"recharge_go"]];
    }else{
        [_userInfoLabel appendText:string];
        [_userInfoLabel appendText:@"  "];
        [_userInfoLabel appendImage:[UIImage imageNamed:@"room_money"]];
        [_userInfoLabel appendText:@"  "];
        [_userInfoLabel  appendImage:[UIImage imageNamed:@"recharge_go"]];
    }
}

-(void)rebuildGiftScrollViewUI
{
    [_giftScrollView removeAllSubviews];
    _pageControl.numberOfPages = _giftListModel.types.count;
    for (int index=0; index<_giftListModel.types.count; index++) {
        NSArray *dataArray = [self findgTypeGiftArrayWith:index];
            _giftScrollView.contentSize = CGSizeMake(self.width*(_giftListModel.types.count), _giftScrollView.height);
            _giftScrollView.showsHorizontalScrollIndicator = NO;
            _giftScrollView.showsVerticalScrollIndicator = NO;
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(index*self.width, 0, self.width, _giftScrollView.height)];
            [_giftScrollView addSubview:scrollView];
            float width = 0;
            for (int i=0; i<dataArray.count; i++) {
                int row = i/4;
                int loc = i%4;
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(loc*self.width/4, row*_giftScrollView.height/2, self.width/4, _giftScrollView.height/2)];
                PhoneGiftView *_giftView = [PhoneGiftView viewFromXIB];
                _giftView.backgroundColor=[UIColor clearColor];
                _giftView.centerX = view.width/2;
                _giftView.centerY = view.height/2;
                _giftView.picPath = self.picPath;
                GiftOneModel *oneModel = (GiftOneModel*)[dataArray objectAtIndex:i];
                [_giftView setDataWithModel:oneModel];
                _giftView.delegate = self;
                [view addSubview:_giftView];
                [scrollView addSubview:view];
                width = _giftScrollView.height/2*(row+1);
            }
            if (width > scrollView.height) {
                scrollView.contentSize = CGSizeMake(self.width, width);
            }
        }
}
-(NSArray *)findgTypeGiftArrayWith:(int)typeid
{
    GiftOneModel *oneModel;
    NSMutableArray *dataArray = [[NSMutableArray alloc]init];
    for (int index = 0; index<_giftListModel.list.count; index++) {
        NSDictionary *dict = [_giftListModel.list objectAtIndex:index];
        oneModel = [[GiftOneModel alloc]initWithDictionary:dict error:nil];
        if (oneModel.gtype.intValue == typeid) {
            [dataArray addObject:oneModel];
        }
    }
    return dataArray;
}
#pragma mark UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _giftScrollView) {
        _pageIndex = _giftScrollView.contentOffset.x/self.width;
        _pageControl.currentPage=_pageIndex;
    }
}
#pragma mark PhoneGiftViewDelegate
- (void)didSelectedOneGift:(GiftOneModel *)oneGiftModel{
//    int vip_type=[[[NSUserDefaults standardUserDefaults]objectForKey:@"vip_type"]intValue];
//    int richlevel=[[[NSUserDefaults standardUserDefaults]objectForKey:@"richlevel"]intValue];
//    if (vip_type==-1&&[oneGiftModel.gtype intValue]==5)
//    {
//        [self showPromptLabelWithType:[oneGiftModel.gtype intValue]];
//        return;
//    }
//    if (richlevel<10&&[oneGiftModel.gtype intValue]==4)
//    {
//        [self showPromptLabelWithType:[oneGiftModel.gtype intValue]];
//        return;
//    }
    _currentChooseGift=oneGiftModel;
    if ([_delegate respondsToSelector:@selector(didClickOneGiftViewSelectGiftOneModel:)]) {
        [_delegate didClickOneGiftViewSelectGiftOneModel:oneGiftModel];
    }
    for (int i=0; i<_giftScrollView.subviews.count; i++) {
        if (i == _pageIndex) {
            UIScrollView * scrollView = (UIScrollView*)[_giftScrollView.subviews objectAtIndex:_pageIndex];
            for (UIView *view in scrollView.subviews) {
                UIView *gView = (UIView*)view.subviews.firstObject;
                if ([gView class] == [PhoneGiftView class]) {
                    PhoneGiftView *_giftView = (PhoneGiftView*)gView;
                    if (_giftView.gid.intValue == oneGiftModel.gid.intValue){
                        _giftView.selectImageV.hidden = NO;
                    }else{
                        _giftView.selectImageV.hidden = YES;
                    }
                }
            }
        }else{
            UIScrollView * scrollView = (UIScrollView*)[_giftScrollView.subviews objectAtIndex:i];
            for (UIView *view in scrollView.subviews) {
                UIView *gView = (UIView*)view.subviews.firstObject;
                if ([gView class] == [PhoneGiftView class]) {
                    PhoneGiftView *_giftView = (PhoneGiftView*)gView;
                    _giftView.selectImageV.hidden = YES;
                }
            }
        }
    }
}

-(void)showPromptLabelWithType:(int)type
{
    _canNotSelectLabel.hidden = NO;
    _canNotSelectLabel.alpha = 0.8;
    [self bringSubviewToFront:_canNotSelectLabel];
    if (type == 4) {
        _canNotSelectLabel.text = @"10富以上才能赠送这个礼物";
    }
    if (type == 5) {
        _canNotSelectLabel.text = @"本房间的嘉宾才能赠送这个礼物";
    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:2.0];
    _canNotSelectLabel.alpha = 0;
    [UIView commitAnimations];
}
@end
