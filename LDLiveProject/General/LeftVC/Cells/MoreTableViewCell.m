//
//  MoreTableViewCell.m
//  LDLiveProject
//
//  Created by MAC on 16/6/21.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "MoreTableViewCell.h"

@implementation MoreTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _bgView1 = [[UIView alloc]init];
    _bgView2 = [[UIView alloc]init];
    _bgView3 = [[UIView alloc]init];
    
    _bgView1.frame = CGRectMake(10, 0, (SCREEN_WIDTH-20)/3-1, (SCREEN_WIDTH-20)/3-1+30);
    _bgView2.frame = CGRectMake(_bgView1.right+2, 0, (SCREEN_WIDTH-20)/3-1, (SCREEN_WIDTH-20)/3-1+30);
    _bgView3.frame = CGRectMake(_bgView2.right+2, 0, (SCREEN_WIDTH-20)/3-1, (SCREEN_WIDTH-20)/3-1+30);
    [self addSubview:_bgView1];
    [self addSubview:_bgView2];
    [self addSubview:_bgView3];
    
    _headerImageV1 = [[WebImageView alloc]init];
    _headerImageV2 = [[WebImageView alloc]init];
    _headerImageV3 = [[WebImageView alloc]init];
    
    _headerImageV1.frame = CGRectMake(0, 10, (SCREEN_WIDTH-20)/3-1, (SCREEN_WIDTH-20)/3-1);
    _headerImageV2.frame = CGRectMake(0, 10, (SCREEN_WIDTH-20)/3-1, (SCREEN_WIDTH-20)/3-1);
    _headerImageV3.frame = CGRectMake(0, 10, (SCREEN_WIDTH-20)/3-1, (SCREEN_WIDTH-20)/3-1);\
//    _headerImageV1.layer.cornerRadius = 1;
//    _headerImageV1.layer.masksToBounds = YES;
//    _headerImageV2.layer.cornerRadius = 1;
//    _headerImageV2.layer.masksToBounds = YES;
//    _headerImageV3.layer.cornerRadius = 1;
//    _headerImageV3.layer.masksToBounds = YES;
    [_bgView1 addSubview:_headerImageV1];
    [_bgView2 addSubview:_headerImageV2];
    [_bgView3 addSubview:_headerImageV3];
    
    _titleLabel1 = [[M80AttributedLabel alloc]init];
    _titleLabel2 = [[M80AttributedLabel alloc]init];
    _titleLabel3 = [[M80AttributedLabel alloc]init];
    
    _titleLabel1.frame = CGRectMake(0, _bgView1.bottom-15, _bgView1.width, 18);
    _titleLabel2.frame = CGRectMake(0, _bgView2.bottom-15, _bgView2.width, 18);
    _titleLabel3.frame = CGRectMake(0, _bgView3.bottom-15, _bgView3.width, 18);
    _titleLabel1.font = [UIFont systemFontOfSize:8];
    _titleLabel2.font = [UIFont systemFontOfSize:8];
    _titleLabel3.font = [UIFont systemFontOfSize:8];
    [_bgView1 addSubview:_titleLabel1];
    [_bgView2 addSubview:_titleLabel2];
    [_bgView3 addSubview:_titleLabel3];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setBackgroundColor:[UIColor clearColor]];
    button1.frame = _bgView1.bounds;
    [button1 addTarget:self action:@selector(button1Click:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView1 addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setBackgroundColor:[UIColor clearColor]];
    button2.frame = _bgView2.bounds;
    [button2 addTarget:self action:@selector(button2Click:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView2 addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setBackgroundColor:[UIColor clearColor]];
    button3.frame = _bgView3.bounds;
    [button3 addTarget:self action:@selector(button3Click:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView3 addSubview:button3];
    
    
    // Initialization code
}

- (void)setUIwithModel
{
    [_headerImageV1 setImageWithUrlString:_hostInfoModel1.portrait placeholderImage:[UIImage imageByApplyingAlpha:1 color:[UIColor lightGrayColor]]];
    [_headerImageV2 setImageWithUrlString:_hostInfoModel2.portrait placeholderImage:[UIImage imageByApplyingAlpha:1 color:[UIColor lightGrayColor]]];
    [_headerImageV3 setImageWithUrlString:_hostInfoModel3.portrait placeholderImage:[UIImage imageByApplyingAlpha:1 color:[UIColor lightGrayColor]]];
    
    [_titleLabel1 appendView:[self getUserLevelViewWithLevelString:_hostInfoModel1.level]];
    [_titleLabel1 appendText:@"  "];
    [_titleLabel1 appendText:_hostInfoModel1.nick];
    
    [_titleLabel2 appendView:[self getUserLevelViewWithLevelString:_hostInfoModel2.level]];
    [_titleLabel2 appendText:@"  "];
    [_titleLabel2 appendText:_hostInfoModel2.nick];
    
    [_titleLabel3 appendView:[self getUserLevelViewWithLevelString:_hostInfoModel3.level]];
    [_titleLabel3 appendText:@"  "];
    [_titleLabel3 appendText:_hostInfoModel3.nick];
    
}

- (UIView *)getUserLevelViewWithLevelString:(NSString *)level
{
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 30, 14)];
    if (level.intValue == 0) {
        return nil;
    }
    view.image = [UIImage imageNamed:[NSString stringWithFormat:@"level_%@",level]];
    return view;
}


- (void)button1Click:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(didSelectMoreTableviewWithHostInfoModel:)]) {
        [_delegate didSelectMoreTableviewWithHostInfoModel:_hostInfoModel1];
    }
}
- (void)button2Click:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(didSelectMoreTableviewWithHostInfoModel:)]) {
        [_delegate didSelectMoreTableviewWithHostInfoModel:_hostInfoModel2];
    }
}
- (void)button3Click:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(didSelectMoreTableviewWithHostInfoModel:)]) {
        [_delegate didSelectMoreTableviewWithHostInfoModel:_hostInfoModel3];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
