//
//  CreditTwoCell.m
//  LDLiveProject
//
//  Created by MAC on 16/9/2.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "CreditTwoCell.h"
#import "CreditModel.h"

@implementation CreditTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lineView.backgroundColor = [UIColor lightGrayColor];
    _headerImageView.layer.cornerRadius = _headerImageView.height/2;
    _headerImageView.layer.masksToBounds = YES;
    
    _nameViewLabel.backgroundColor = [UIColor clearColor];
    _nameViewLabel.textColor = [UIColor darkGrayColor];
    _nameViewLabel.font = [UIFont systemFontOfSize:14];
    _nameViewLabel.textAlignment = NSTextAlignmentRight;
    
    _creditNumViewLabel.backgroundColor = [UIColor clearColor];
    _creditNumViewLabel.textColor = [UIColor darkGrayColor];
    _creditNumViewLabel.font = [UIFont systemFontOfSize:14];
    _creditNumViewLabel.textAlignment = NSTextAlignmentRight;
    // Initialization code
}

- (void)setTwoCellUIWithImageHost:(NSString*)imageHost CreditModel:(CreditModel*)model
{
    [_headerImageView setImageWithUrlString:[NSString stringWithFormat:@"%@%@",imageHost,model.img]];
    
    _nameViewLabel.attributedText = nil;
    [_nameViewLabel appendText:[NSString stringWithFormat:@"%@ ",model.nick]];
    if (model.sex.intValue) {
        [_nameViewLabel appendView:[self getUserSexViewWithString:@"1"]];
    }else{
        [_nameViewLabel appendView:[self getUserSexViewWithString:@"0"]];
    }
    [_nameViewLabel appendText:@" "];
    [_nameViewLabel appendView:[self getUserLevelViewWithLevelString:model.level]];
    [_nameViewLabel appendText:@" "];
    
    _creditNumViewLabel.attributedText = nil;
    [_creditNumViewLabel appendText:@"贡献"];
    [_creditNumViewLabel appendText:@" "];
    [_creditNumViewLabel appendView:[self getUsercreditNumViewWithString:model.ticket]];
    [_creditNumViewLabel appendText:@" "];
    [_creditNumViewLabel appendText:@"球票"];
}

- (UIView *)getUsercreditNumViewWithString:(NSString *)str
{
    UILabel *view = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 14, 25)];
    view.font = [UIFont systemFontOfSize:14];
    view.textColor = [UIColor colorWithHexString:@"0xdc677d"];
    CGSize size = [str sizeWithFont:view.font constrainedToSize: CGSizeMake(MAXFLOAT,view.frame.size.height) lineBreakMode:NSLineBreakByWordWrapping];
    view.width = size.width;
    view.text = str;
    view.backgroundColor = [UIColor clearColor];
    
    return view;
}

#pragma mark 获取用男女视图
- (UIView *)getUserSexViewWithString:(NSString *)sex
{
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 14, 14)];
    if (sex.intValue) {
        view.image = [UIImage imageNamed:@"me_sex1"];
    }else{
        view.image = [UIImage imageNamed:@"me_sex2"];
    }
    view.clipsToBounds = YES;
    view.contentMode = UIViewContentModeScaleAspectFill;
    return view;
}
#pragma mark 获取用等级视图
- (UIView *)getUserLevelViewWithLevelString:(NSString *)level
{
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 30, 14)];
    if (level.intValue == 0) {
        return nil;
    }
    view.image = [UIImage imageNamed:[NSString stringWithFormat:@"level_%@",level]];
    return view;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
