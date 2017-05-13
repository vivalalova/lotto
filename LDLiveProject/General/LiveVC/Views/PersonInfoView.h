//
//  PersonInfoView.h
//  LDLiveProject
//
//  Created by MAC on 16/7/4.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "XibView.h"
#import "PersonInfoModel.h"

@protocol PersonInfoViewDelegate <NSObject>

- (void)closePersonInfoViewButtonAction;
- (void)personInfoViewAttButtonAction:(PersonInfoModel*)personInfoModel;
- (void)personInfoViewInboxButtonAction:(PersonInfoModel*)personInfoModel;
- (void)personInfoViewSelfButtonAction:(PersonInfoModel*)personInfoModel;
- (void)personInfoViewLeftTopButtonManageAction:(PersonInfoModel *)personInfoModel;
- (void)personInfoViewHeaderImageButtonClickAction:(PersonInfoModel *)personInfoModel;
@end

@interface PersonInfoView : XibView<UIGestureRecognizerDelegate>

@property (assign,nonatomic)id <PersonInfoViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *leftTopButton;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;
@property (weak, nonatomic) IBOutlet UIView *headerBGView;
@property (weak, nonatomic) IBOutlet WebImageView *headerImageView;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *nameLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *roomIdLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *signatureLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *attLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *fansLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *sendMoneyLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *ticketLabel;
@property (weak, nonatomic) IBOutlet UIButton *attButton;
@property (weak, nonatomic) IBOutlet UIButton *inboxButton;
@property (weak, nonatomic) IBOutlet UIButton *selfButton;
@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *linLabel1;
@property (weak, nonatomic) IBOutlet UILabel *linLabel2;
@property (weak, nonatomic) IBOutlet UILabel *linLabel3;
@property (weak, nonatomic) IBOutlet UILabel *linLabel4;

- (void)setPersonInfoViewUIwithPersonInfoModel:(PersonInfoModel*)personInfoModel;

@end
