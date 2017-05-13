//
//  VIPSelectView.h
//  LDLiveProject
//
//  Created by MAC on 16/9/24.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VIPSelectViewDelegate <NSObject>

- (void)didSelectOpenVIPButtonWithDateStr:(NSString *)dateStr;

@end


@interface VIPSelectView : XibView
@property (strong,nonatomic)NSMutableArray *dataArr;
@property (strong,nonatomic) NSString *VIPCode;
@property (assign,nonatomic)id<VIPSelectViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *month1Button;
@property (weak, nonatomic) IBOutlet UIButton *month2Button;
@property (weak, nonatomic) IBOutlet UIButton *month3Button;
@property (weak, nonatomic) IBOutlet UIButton *month4Button;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *totalMLabel;
@property (weak, nonatomic) IBOutlet UIButton *openVIPButton;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel1;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel2;
@property (weak, nonatomic) IBOutlet UIView *bgView;

- (void)setUIWithDataArray:(NSMutableArray *)dataArray;
- (void)showInSupeView;
- (void)hideFromSuperView;
@end
