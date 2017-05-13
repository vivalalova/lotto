//
//  PhoneLiveAnchorIsLeavingView.h
//  LiveProject
//
//  Created by coolyouimac02 on 16/4/13.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "XibView.h"
//#import "AnchorModel.h"

@protocol PhoneLiveAnchorIsLeavingDelegate <NSObject>

-(void)selectAnchorIsLeaveingButtonWithTag:(NSInteger)tag;
-(void)selectAttentionButton:(UIButton *)button;
-(void)selectBackButton:(UIButton *)button;

@end

@interface PhoneLiveAnchorIsLeavingView : XibView

//@property (nonatomic, strong) AnchorModel *anchormodel;

@property(nonatomic,assign)id<PhoneLiveAnchorIsLeavingDelegate>delegate;


@property (weak, nonatomic) IBOutlet UIButton *attentonButon;
@property (nonatomic, assign) BOOL is_att_Room;
- (void)removeFromPhoneLiveVC;

@end
