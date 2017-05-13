//
//  SendCustomTextFiled.h
//  LDLiveProject
//
//  Created by MAC on 16/6/24.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DoneActionBlock)(id);

@interface SendCustomTextFiled : UITextField

@property(nonatomic,retain) UIButton* doneButton;
@property(nonatomic,retain) NSString* buttonTitle;
@property(nonatomic,copy)   DoneActionBlock doneEven;

@end
