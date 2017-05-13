//
//  DatePickView.m
//  LDLiveProject
//
//  Created by MAC on 16/9/3.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "DatePickView.h"
#import "UUDatePicker.h"

@interface DatePickView ()<UUDatePickerDelegate>
{
    UUDatePicker *datePicker;
}
@end

@implementation DatePickView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self buildUI];
    }
    return self;
}

- (void)buildUI
{
    [self addSubview:self.bgView];
    [self addSubview:self.bottomView];
    [self.bottomView addSubview:self.titleLabel];
    NSDate *now = [NSDate date];
    datePicker= [[UUDatePicker alloc]initWithframe:CGRectMake(0, 40, self.width, 220)
                                                            Delegate:self
                                                         PickerStyle:UUDateStyle_YearMonthDay];
    datePicker.maxLimitDate = now;
    [self.bottomView addSubview:datePicker];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenSelf)];
    [_bgView addGestureRecognizer:tap];
}

#pragma mark - UUDatePicker's delegate
- (void)uuDatePicker:(UUDatePicker *)datePicker
                year:(NSString *)year
               month:(NSString *)month
                 day:(NSString *)day
                hour:(NSString *)hour
              minute:(NSString *)minute
             weekDay:(NSString *)weekDay
{
    _timeStr = [NSString stringWithFormat:@"%@年%@月%@日",year,month,day];
}

-(UIView *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 40)];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width, 40)];
        label.backgroundColor = [UIColor whiteColor];
        label.textColor = [UIColor colorWithHexString:GiftUsualColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:16];
        label.text = @"滚动时间,选择您的生日";
        [_titleLabel addSubview:label];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 39.5, self.width-30, 0.5)];
        label1.backgroundColor = [UIColor colorWithHexString:GiftUsualColor];
        [_titleLabel addSubview:label1];
    }
    return _titleLabel;
}

-(UIView *)bottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height, self.width, 220+40)];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

-(UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc]initWithFrame:self.frame];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0;
    }
    return _bgView;
}

- (void)showInView:(UIView *)view withSelectStr:(NSString*)selectStr
{
    [view addSubview:self];
    if ([selectStr isEqualToString:@"保密"]) {
        NSDate *now = [NSDate date];
        datePicker.ScrollToDate = now;
    }else{
        selectStr = [selectStr stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
        selectStr = [selectStr stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
        selectStr = [selectStr stringByReplacingOccurrencesOfString:@"日" withString:@" "];
        selectStr = [NSString stringWithFormat:@"%@00:00:00",selectStr];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
        NSDate* date = [formatter dateFromString:selectStr]; //------------将字符串按formatter转成nsdate
        datePicker.ScrollToDate = date;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        _bgView.alpha = 0.5;
        self.bottomView.bottom = self.bottom;
    }];
}
- (void)hiddenSelf
{
    [UIView animateWithDuration:0.5 animations:^{
        _bgView.alpha = 0;
        self.bottomView.top = self.bottom;
    }];
    if ([_delegate respondsToSelector:@selector(DatePickViewDidSelectWithStr:)]) {
        [_delegate DatePickViewDidSelectWithStr:_timeStr];
    }
    [self removeFromSuperview];
}

@end
