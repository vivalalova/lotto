//
//  VIPSelectView.m
//  LDLiveProject
//
//  Created by MAC on 16/9/24.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "VIPSelectView.h"
#import "VIPModel.h"

@implementation VIPSelectView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
    _lineLabel1.height = 0.5;
    _lineLabel1.backgroundColor = UIColorFromRGB(240, 240, 240);
    _lineLabel2.height = 0.5;
    _lineLabel2.backgroundColor = UIColorFromRGB(240, 240, 240);
    [_month1Button setBackgroundColor:[UIColor whiteColor]];
    [_month2Button setBackgroundColor:[UIColor whiteColor]];
    [_month3Button setBackgroundColor:[UIColor whiteColor]];
    [_month4Button setBackgroundColor:[UIColor whiteColor]];
    
    _month1Button.layer.cornerRadius = 3;
    _month1Button.layer.borderColor = [UIColor colorWithHexString:@"0xe73962"].CGColor;
    _month1Button.layer.borderWidth = 1;
    [_month1Button setTitleColor:[UIColor colorWithHexString:@"0xe73962"] forState:UIControlStateNormal];
    
    _month2Button.layer.cornerRadius = 3;
    _month2Button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _month2Button.layer.borderWidth = 1;
    [_month2Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _month3Button.layer.cornerRadius = 3;
    _month3Button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _month3Button.layer.borderWidth = 1;
    [_month3Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _month4Button.layer.cornerRadius = 3;
    _month4Button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _month4Button.layer.borderWidth = 1;
    [_month4Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    [_openVIPButton setBackgroundColor:[UIColor colorWithHexString:@"0x00a2e6"]];
    
    _totalMLabel.backgroundColor = [UIColor clearColor];
    _totalMLabel.textColor = [UIColor blueColor];
    _totalMLabel.font = [UIFont systemFontOfSize:15];
    self.VIPCode = @"0";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideFromSuperView)];
    [_bgView addGestureRecognizer:tap];
}

- (IBAction)month1ButtonClick:(id)sender {
    _month1Button.layer.cornerRadius = 3;
    _month1Button.layer.borderColor = [UIColor colorWithHexString:@"0xe73962"].CGColor;
    _month1Button.layer.borderWidth = 1;
    [_month1Button setTitleColor:[UIColor colorWithHexString:@"0xe73962"] forState:UIControlStateNormal];
    
    _month2Button.layer.cornerRadius = 3;
    _month2Button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _month2Button.layer.borderWidth = 1;
    [_month2Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _month3Button.layer.cornerRadius = 3;
    _month3Button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _month3Button.layer.borderWidth = 1;
    [_month3Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _month4Button.layer.cornerRadius = 3;
    _month4Button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _month4Button.layer.borderWidth = 1;
    [_month4Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _totalMLabel.attributedText = nil;
    [_totalMLabel appendText:@"合计消耗："];
    VIPModel *model = [self.dataArr objectAtIndex:0];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:model.price];
    [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)[UIColor colorWithHexString:@"0xe73962"].CGColor
                        range:NSMakeRange(0, attriString.length)];
    [_totalMLabel appendAttributedText:attriString];
    [_totalMLabel appendText:@" "];
    [_totalMLabel appendImage:[UIImage imageNamed:@"diam"]];
    
    self.VIPCode = @"0";
}
- (IBAction)month2ButtonClick:(id)sender {
    _month2Button.layer.cornerRadius = 3;
    _month2Button.layer.borderColor = [UIColor colorWithHexString:@"0xe73962"].CGColor;
    _month2Button.layer.borderWidth = 1;
    [_month2Button setTitleColor:[UIColor colorWithHexString:@"0xe73962"] forState:UIControlStateNormal];
    
    _month1Button.layer.cornerRadius = 3;
    _month1Button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _month1Button.layer.borderWidth = 1;
    [_month1Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _month3Button.layer.cornerRadius = 3;
    _month3Button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _month3Button.layer.borderWidth = 1;
    [_month3Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _month4Button.layer.cornerRadius = 3;
    _month4Button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _month4Button.layer.borderWidth = 1;
    [_month4Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _totalMLabel.attributedText = nil;
    [_totalMLabel appendText:@"合计消耗："];
    VIPModel *model = [self.dataArr objectAtIndex:1];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:model.price];
    [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)[UIColor colorWithHexString:@"0xe73962"].CGColor
                        range:NSMakeRange(0, attriString.length)];
    [_totalMLabel appendAttributedText:attriString];
    [_totalMLabel appendText:@" "];
    [_totalMLabel appendImage:[UIImage imageNamed:@"diam"]];
    self.VIPCode = @"1";
}
- (IBAction)month3ButtonClick:(id)sender {
    _month3Button.layer.cornerRadius = 3;
    _month3Button.layer.borderColor = [UIColor colorWithHexString:@"0xe73962"].CGColor;
    _month3Button.layer.borderWidth = 1;
    [_month3Button setTitleColor:[UIColor colorWithHexString:@"0xe73962"] forState:UIControlStateNormal];
    
    _month2Button.layer.cornerRadius = 3;
    _month2Button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _month2Button.layer.borderWidth = 1;
    [_month2Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _month1Button.layer.cornerRadius = 3;
    _month1Button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _month1Button.layer.borderWidth = 1;
    [_month1Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _month4Button.layer.cornerRadius = 3;
    _month4Button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _month4Button.layer.borderWidth = 1;
    [_month4Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _totalMLabel.attributedText = nil;
    [_totalMLabel appendText:@"合计消耗："];
    VIPModel *model = [self.dataArr objectAtIndex:2];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:model.price];
    [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)[UIColor colorWithHexString:@"0xe73962"].CGColor
                        range:NSMakeRange(0, attriString.length)];
    [_totalMLabel appendAttributedText:attriString];
    [_totalMLabel appendText:@" "];
    [_totalMLabel appendImage:[UIImage imageNamed:@"diam"]];
    self.VIPCode = @"2";
}
- (IBAction)month4ButtonClick:(id)sender {
    _month4Button.layer.cornerRadius = 3;
    _month4Button.layer.borderColor = [UIColor colorWithHexString:@"0xe73962"].CGColor;
    _month4Button.layer.borderWidth = 1;
    [_month4Button setTitleColor:[UIColor colorWithHexString:@"0xe73962"] forState:UIControlStateNormal];
    
    _month2Button.layer.cornerRadius = 3;
    _month2Button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _month2Button.layer.borderWidth = 1;
    [_month2Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _month3Button.layer.cornerRadius = 3;
    _month3Button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _month3Button.layer.borderWidth = 1;
    [_month3Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    _month1Button.layer.cornerRadius = 3;
    _month1Button.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _month1Button.layer.borderWidth = 1;
    [_month1Button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    _totalMLabel.attributedText = nil;
    [_totalMLabel appendText:@"合计消耗："];
    VIPModel *model = [self.dataArr objectAtIndex:3];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:model.price];
    [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)[UIColor colorWithHexString:@"0xe73962"].CGColor
                        range:NSMakeRange(0, attriString.length)];
    [_totalMLabel appendAttributedText:attriString];
    [_totalMLabel appendText:@" "];
    [_totalMLabel appendImage:[UIImage imageNamed:@"diam"]];
    self.VIPCode = @"3";
}
- (IBAction)openVipButtonClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(didSelectOpenVIPButtonWithDateStr:)]) {
        [_delegate didSelectOpenVIPButtonWithDateStr:self.VIPCode];
    }
}

- (void)setUIWithDataArray:(NSMutableArray *)dataArray
{
    self.dataArr = dataArray;
    _totalMLabel.attributedText = nil;
    [_totalMLabel appendText:@"合计消耗："];
    VIPModel *model = [self.dataArr objectAtIndex:0];
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:model.price];
    [attriString addAttribute:(NSString *)kCTForegroundColorAttributeName
                        value:(id)[UIColor colorWithHexString:@"0xe73962"].CGColor
                        range:NSMakeRange(0, attriString.length)];
    [_totalMLabel appendAttributedText:attriString];
    [_totalMLabel appendText:@" "];
    [_totalMLabel appendImage:[UIImage imageNamed:@"diam"]];
    
    for (int i=0; i<dataArray.count; i++) {
        VIPModel *model = [dataArray objectAtIndex:i];
        if (i == 0) {
            [_month1Button setTitle:model.desc forState:UIControlStateNormal];
            _month1Button.hidden = NO;
            _month2Button.hidden = YES;
            _month3Button.hidden = YES;
            _month4Button.hidden = YES;
        }
        if (i == 1) {
            [_month2Button setTitle:model.desc forState:UIControlStateNormal];
            _month2Button.hidden = NO;
        }
        if (i == 2) {
            [_month3Button setTitle:model.desc forState:UIControlStateNormal];
            _month3Button.hidden = NO;
        }
        if (i == 3) {
            [_month4Button setTitle:model.desc forState:UIControlStateNormal];
            _month4Button.hidden = NO;
        }
    }

}

- (void)showInSupeView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.8];
    _bottomView.bottom = self.bottom;
    [UIView commitAnimations];
}

- (void)hideFromSuperView
{
    [UIView animateKeyframesWithDuration:0.5 delay:0 options:0 animations:^{
        _bottomView.top = self.bottom;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}




@end
