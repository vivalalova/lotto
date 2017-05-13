//
//  VideoHeaderView.h
//  LDLiveProject
//
//  Created by MAC on 16/9/13.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "XibView.h"

@protocol VideoHeaderViewDelegate <NSObject>

- (void)didClidkVideoHeaderViewwithHotButton;
- (void)didClidkVideoHeaderViewwithNewButton;

@end

@interface VideoHeaderView : XibView

@property (nonatomic,assign)id<VideoHeaderViewDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *hotButton;
@property (weak, nonatomic) IBOutlet UIButton *newmButton;

@end
