//
//  WoodPickView.h
//  LDLiveProject
//
//  Created by MAC on 16/9/3.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "XibView.h"

@protocol WoodPickViewDelegate <NSObject>

-(void)woodPickViewDidSelectWithStr:(NSString *)selectStr;

@end

@interface WoodPickView : XibView
@property (assign,nonatomic)id<WoodPickViewDelegate>delegate;
@property (nonatomic,strong)NSString *selectStr;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *pickView;
@property (weak, nonatomic) IBOutlet UIButton *baomiButton;
@property (weak, nonatomic) IBOutlet UIButton *danshenButton;
@property (weak, nonatomic) IBOutlet UIButton *lianaizhongButton;
@property (weak, nonatomic) IBOutlet UIButton *yihunButton;
@property (weak, nonatomic) IBOutlet UIButton *tongxingButton;

- (void)showInView:(UIView *)view withSelectStr:(NSString*)selectStr;

@end
