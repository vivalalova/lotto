//
//  AdminVC.h
//  LDLiveProject
//
//  Created by MAC on 16/7/23.
//  Copyright © 2016年 MAC. All rights reserved.
//

#import "BasisVC.h"
@class AdminModel;
@protocol  AdminVCDelegate <NSObject>

- (void)didClickDeleteAdminWithAdminModel:(AdminModel*)adminModel;

@end

@interface AdminVC : BasisVC
@property (nonatomic,assign)id<AdminVCDelegate>delegate;
- (void)sendURI_FansRequest;
@end
