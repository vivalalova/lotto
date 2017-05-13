//
//  PhoneReceiveGiftManager.m
//  LiveProject
//
//  Created by coolyouimac01 on 16/4/6.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "PhoneReceiveGiftManager.h"
#import "PhoneReceiveGiftView.h"
#import "UserSendGiftModel.h"
#import "THLabel.h"
@interface PhoneReceiveGiftManager ()
@property (nonatomic,weak)PhoneReceiveGiftView *firstGiftView;
@property (nonatomic,weak)PhoneReceiveGiftView *secondGiftView;
@property (nonatomic,assign)BOOL firstGiftIsShow;
@property (nonatomic,assign)BOOL secondGiftIsShow;
@property (nonatomic,strong)UserSendGiftModel *firstModel;
@property (nonatomic,strong)UserSendGiftModel *secondModel;
@end
@implementation PhoneReceiveGiftManager
- (NSMutableArray *)dataArray{
    if (_dataArray==nil) {
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
- (PhoneReceiveGiftView *)firstGiftView{
    if (_firstGiftView==nil) {
        _firstGiftView=[PhoneReceiveGiftView viewFromXIB];
    }
    return _firstGiftView;
}
- (PhoneReceiveGiftView *)secondGiftView{
    if (_secondGiftView==nil) {
        _secondGiftView=[PhoneReceiveGiftView viewFromXIB];
    }
    return _secondGiftView;
}
- (void)startSendGiftAnimation{
    if (_dataArray.count>0) {
        UserSendGiftModel *model=nil;
        model=[_dataArray firstObject];
        if (_firstGiftIsShow==NO) {
            if (_secondModel) {
                if (![_secondModel.uid isEqualToString:model.uid]) {
                    _firstGiftIsShow=YES;
                    [self showInView:_superView position:CGPointMake(_position.x, _position.y) duration:0.4 delay:0 userSendGiftModel:[_dataArray firstObject] currentView:self.firstGiftView];
                }
            }else{
                _firstGiftIsShow=YES;
                [self showInView:_superView position:CGPointMake(_position.x, _position.y) duration:0.4 delay:0 userSendGiftModel:[_dataArray firstObject] currentView:self.firstGiftView];
            }
        }else if(_secondGiftIsShow==NO){
            if (_firstModel) {
                if (![_firstModel.uid isEqualToString:model.uid]) {
                    _secondGiftIsShow=YES;
                    [self showInView:_superView position:CGPointMake(_position.x, _position.y-self.firstGiftView.height-30) duration:0.4 delay:0 userSendGiftModel:[_dataArray firstObject] currentView:self.secondGiftView];
                }
            }else{
                _secondGiftIsShow=YES;
                [self showInView:_superView position:CGPointMake(_position.x, _position.y-self.firstGiftView.height-30) duration:0.4 delay:0 userSendGiftModel:[_dataArray firstObject] currentView:self.secondGiftView];
            }
        }
    }
}
- (void)showInView:(UIView *)view position:(CGPoint)point duration:(NSTimeInterval)duration delay:(NSTimeInterval)delay userSendGiftModel:(UserSendGiftModel *)model currentView:(PhoneReceiveGiftView *)giftView{
    if (giftView==_firstGiftView) {
        _firstModel=model;
    }else{
        _secondModel=model;
    }
    giftView.nameLbl.text=[NSString stringWithFormat:@"%@",[model.fromUser stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ]];
    giftView.giftImageView.backgroundColor = [UIColor clearColor];
    giftView.giftImageView.image=model.giftImage;
    [giftView.headIV setImageWithUrlString:[NSString stringWithFormat:@"%@%@",URI_BASE_SERVER,model.user_head_img] placeholderImage:[UIImage imageNamed:@"lp_home_imageloader_defult.png"]];
    giftView.giftNameLbl.text=[NSString stringWithFormat:@"送一个%@",model.giftName];
    giftView.hidden=NO;
    [giftView setTop:point.y];
    [giftView setLeft:point.x];
    [view addSubview:giftView];
   
    giftView.transform = CGAffineTransformMakeTranslation(-CGRectGetWidth([UIScreen mainScreen].bounds), 0);
    giftView.giftImageView.transform=CGAffineTransformMakeTranslation(-CGRectGetWidth([UIScreen mainScreen].bounds), 0);
    giftView.numLbl.hidden=YES;
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        giftView.transform = CGAffineTransformMakeTranslation(0, 0);
        [UIView animateKeyframesWithDuration:duration delay:duration/2 options:0 animations:^{
            giftView.giftImageView.transform=CGAffineTransformMakeTranslation(0, 0);
        } completion:^(BOOL finished) {
            [self showNumWithDuration:duration delay:0 userSendGiftModel:model currentView:giftView];
        }];
    } completion:^(BOOL finished) { }];
}
- (void)showNumWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay userSendGiftModel:(UserSendGiftModel *)model currentView:(PhoneReceiveGiftView *)giftView{
    if (giftView==_firstGiftView) {
        _firstModel=model;
    }else{
        _secondModel=model;
    }
    giftView.numLbl.hidden=NO;
    giftView.numLbl.transform = CGAffineTransformMakeScale(3, 3);
    giftView.numLbl.alpha = 0;
    if ([model.serial_count intValue]==0) {
        giftView.numLbl.text=@"X 1";
    }else{
        giftView.numLbl.text=[NSString stringWithFormat:@"X %@",model.serial_count];
    }
    [UIView animateKeyframesWithDuration:duration delay:delay options:0 animations:^{
        giftView.numLbl.transform = CGAffineTransformMakeScale(1, 1);
        giftView.numLbl.alpha = 1;
    } completion:^(BOOL finished) {
        if(_dataArray.count>0){
            [_dataArray removeObject:model];
        }
        if (_dataArray.count>0) {
            UserSendGiftModel *model1=[_dataArray firstObject];
            if ([model1.uid isEqualToString:model.uid]) {
                [self showNumWithDuration:duration delay:delay userSendGiftModel:model1 currentView:giftView];
            }else{
                if (giftView==_firstGiftView&&_secondGiftIsShow==YES&&[model1.uid isEqualToString:_secondModel.uid]){
                    [self performSelector:@selector(hideFromView:) withObject:giftView afterDelay:0.2];
                    [self showNumWithDuration:duration delay:delay userSendGiftModel:model1 currentView:_secondGiftView];
                }else if(giftView==_secondGiftView&&_firstGiftIsShow==YES&&[model1.uid isEqualToString:_firstModel.uid]){
                    [self performSelector:@selector(hideFromView:) withObject:giftView afterDelay:0.2];
                     [self showNumWithDuration:duration delay:delay userSendGiftModel:model1 currentView:_firstGiftView];
                }else if(_firstGiftIsShow==NO|| _secondGiftIsShow==NO){
                    [self startSendGiftAnimation];
                }else{
                    [self performSelector:@selector(hideFromView:) withObject:giftView afterDelay:1.0];
                }
            }
        }else{
            [self performSelector:@selector(hideAllFromView) withObject:nil afterDelay:1.0];
        }
    }];
}
- (void)hideAllFromView{
    if (_firstGiftIsShow==YES) {
        _firstGiftView.hidden=YES;
        _firstGiftIsShow=NO;
        _firstModel=nil;
    }
    if (_secondGiftIsShow==YES) {
        _secondGiftView.hidden=YES;
        _secondGiftIsShow=NO;
        _secondModel=nil;
    }
    if (_dataArray.count>0) {
        [self startSendGiftAnimation];
    }
}
- (void)hideFromView:(PhoneReceiveGiftView *)giftView{
    if (giftView==_firstGiftView) {
        _firstGiftIsShow=NO;
        _firstModel=nil;
    }
    if (giftView==_secondGiftView) {
        _secondGiftIsShow=NO;
        _secondModel=nil;
    }
    giftView.hidden=YES;
    if (_dataArray.count>0) {
        [self startSendGiftAnimation];
    }
}
@end
