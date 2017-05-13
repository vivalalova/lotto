


//
//  HeaderScrollView.m
//  HDHLProject
//
//  Created by coolyouimac02 on 15/9/28.
//  Copyright (c) 2015年 Mac. All rights reserved.
//

#import "HeaderScrollImageView.h"
#import "WebImageView.h"
#define TITLE_LABEL_HEIGHT SCREEN_WIDTH/12

@interface HeaderScrollImageView()

@end

@implementation HeaderScrollImageView

- (id)initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        [self buildUI];
        
    }
    return self;
}

-(void)buildUI
{
    _bgImageView = [[WebImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.height)];
    _bgImageView.userInteractionEnabled = YES;
    [self addSubview:_bgImageView];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - TITLE_LABEL_HEIGHT, self.frame.size.width, TITLE_LABEL_HEIGHT)];
    _bottomView.backgroundColor = [UIColor clearColor];
    _bottomView.alpha = 0.8;
    [self addSubview:_bottomView];
    
    _titlelabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, SCREEN_WIDTH-80, TITLE_LABEL_HEIGHT)];
    _titlelabel.backgroundColor = [UIColor clearColor];
    _titlelabel.numberOfLines = 0;
    _titlelabel.font = [UIFont systemFontOfSize:14];
    _titlelabel.textColor = [UIColor whiteColor];
    [_bottomView addSubview:_titlelabel];
}




@end
