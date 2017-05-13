//
//  PhoneLiveAnchorPlayIsStop.h
//  LiveProject
//
//  Created by coolyouimac02 on 16/4/13.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "XibView.h"
//#import "AnchorModel.h"

@protocol PhoneLiveAnchorPlayIsStopDelegate <NSObject>

-(void)selectAnchorPlayIsStopButtonWithTag:(NSInteger)tag;
-(void)selectAnchorPlayIsStopAttentionButton:(UIButton *)button;
-(void)selectAnchorPlayIsStopBackButton:(UIButton *)button;

@end

@interface PhoneLiveAnchorPlayIsStop : XibView

//@property (nonatomic, strong) AnchorModel *anchormodel;

@property(nonatomic,assign)id<PhoneLiveAnchorPlayIsStopDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIButton *attentonButon;
@property (nonatomic, assign) BOOL is_att_Room;
@property (nonatomic, copy) NSString *user_countNums;

- (void)removeFromPhoneLiveVC;

@end
