//
//  UserDetailVCViewController.h
//  LDLiveProject
//
//  Created by MAC on 16/9/5.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BasisVC.h"
#import "PersonInfoModel.h"

@protocol UserDetailVCDelegate <NSObject>

- (void)attStatusDidChangedWithIsAttention:(NSString *)isAttention;

@end

@interface UserDetailVCViewController : BasisVC

@property (assign,nonatomic)id<UserDetailVCDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *b_lineView1;
@property (weak, nonatomic) IBOutlet UIView *b_lineView2;
@property (weak, nonatomic) IBOutlet UIView *b_lineView3;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *attViewLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *inboxViewLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *blackViewLabel;

@property (nonatomic,strong)PersonInfoModel *personInfoModel;
@property (nonatomic,assign)CGFloat screenWidth;
@property (nonatomic,assign)CGFloat screenHeight;
@end
