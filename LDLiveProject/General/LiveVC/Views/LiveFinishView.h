//
//  LiveFinishView.h
//  LDLiveProject
//
//  Created by MAC on 16/7/16.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "XibView.h"

@protocol LiveFinishViewDelegate <NSObject>

- (void)didClickLiveFinishViewCloseButton;

@end

@interface LiveFinishView : XibView
@property (assign,nonatomic) id<LiveFinishViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *personViewLabel;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *ticketViewLabel;
@property (weak, nonatomic) IBOutlet UIButton *closeButton;

- (void)setDataWithStopDict:(NSDictionary*)dict;

@end
