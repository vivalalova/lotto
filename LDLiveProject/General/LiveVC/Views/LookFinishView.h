//
//  LookFinishView.h
//  LDLiveProject
//
//  Created by MAC on 16/7/23.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "XibView.h"

@protocol LookFinishViewDelegate <NSObject>

-(void)lookFinishViewAttButtonClick;
-(void)lookFinishViewCloseButtonClick;

@end


@interface LookFinishView : XibView
@property (nonatomic, assign)id<LookFinishViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *tltleLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *lookPersonLabel;
@property (weak, nonatomic) IBOutlet UIButton *attButton;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (nonatomic,assign)BOOL IsAttHostBool;
- (void)setDataWithStopDict:(NSDictionary*)dict;

@end
