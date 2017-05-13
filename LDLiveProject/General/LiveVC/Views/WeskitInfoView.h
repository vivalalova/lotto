//
//  WeskitInfoView.h
//  LDLiveProject
//
//  Created by MAC on 16/8/13.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "XibView.h"
@class PersonInfoModel;

@protocol WeskitInfoViewDelegate <NSObject>

- (void)closeWeskitInfoViewButtonAction;
- (void)WeskitInfoViewManButtonAction:(PersonInfoModel*)personInfoModel;

@end

@interface WeskitInfoView : XibView<UIGestureRecognizerDelegate>

@property (nonatomic,assign) id<WeskitInfoViewDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *infoViewLabel;
@property (weak, nonatomic) IBOutlet UIButton *manButton;
@property (nonatomic,strong)PersonInfoModel*perInfoModel;

- (void)setWeskitInfoViewWithModel:(PersonInfoModel*)personInfoModel;

@end
