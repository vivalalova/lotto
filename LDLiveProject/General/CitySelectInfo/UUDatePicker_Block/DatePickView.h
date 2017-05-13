//
//  DatePickView.h
//  LDLiveProject
//
//  Created by MAC on 16/9/3.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "XibView.h"

@protocol DatePickViewDelegate <NSObject>

-(void)DatePickViewDidSelectWithStr:(NSString *)selectStr;

@end

@interface DatePickView : UIView

@property (assign,nonatomic)id<DatePickViewDelegate>delegate;
@property (strong, nonatomic)NSString *timeStr;

@property (strong, nonatomic)UIView *bgView;
@property (strong, nonatomic)UIView *bottomView;
@property (strong, nonatomic)UIView *titleLabel;
- (void)showInView:(UIView *)view withSelectStr:(NSString*)selectStr;
@end
