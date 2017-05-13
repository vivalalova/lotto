//
//  AnchorProVC.h
//  LDLiveProject
//
//  Created by MAC on 16/8/6.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BasisVC.h"

@protocol AnchorProVCDelegate <NSObject>

- (void)didClickAgreeButtonAction;

@end

@interface AnchorProVC : BasisVC
@property (nonatomic,assign)id<AnchorProVCDelegate>delegate;
@end
