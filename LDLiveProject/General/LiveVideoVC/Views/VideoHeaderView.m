//
//  VideoHeaderView.m
//  LDLiveProject
//
//  Created by MAC on 16/9/13.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "VideoHeaderView.h"

@implementation VideoHeaderView

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.newmButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.newmButton setTitleColor:[UIColor colorWithHexString:GiftUsualColor] forState:UIControlStateSelected];
    [self.hotButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [self.hotButton setTitleColor:[UIColor colorWithHexString:GiftUsualColor] forState:UIControlStateSelected];
    self.newmButton.selected = YES;
    self.hotButton.selected = NO;
}

- (IBAction)newmButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClidkVideoHeaderViewwithNewButton)]) {
        [_delegate didClidkVideoHeaderViewwithNewButton];
    }
    self.newmButton.selected = YES;
    self.hotButton.selected = NO;
}
- (IBAction)hotButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(didClidkVideoHeaderViewwithNewButton)]) {
        [_delegate didClidkVideoHeaderViewwithNewButton];
    }
    self.newmButton.selected = NO;
    self.hotButton.selected = YES;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
