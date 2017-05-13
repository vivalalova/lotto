//
//  ModifyProfessionVC.h
//  LDLiveProject
//
//  Created by MAC on 16/9/3.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BasisVC.h"

@protocol ModifyProfessionVCDelegate <NSObject>

-(void)ModifyProfessionDidChanged;

@end

@interface ModifyProfessionVC : BasisVC

@property (nonatomic,assign)id<ModifyProfessionVCDelegate>delegate;

@end
