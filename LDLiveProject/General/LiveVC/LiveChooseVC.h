//
//  LiveChooseVC.h
//  LiveProject
//
//  Created by MAC on 16/3/31.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserTVInfoModel.h"

@protocol LiveChooseVCDelegate <NSObject>

- (void)LiveChooseVCDelegateCloseButtonClick;
- (void)LiveChooseVCDelegateStartButtonClick;

@end

@interface LiveChooseVC : UIViewController

@property (nonatomic,assign)id<LiveChooseVCDelegate>delegate;
@property (nonatomic,strong)NSString *titleString;
@property (strong, nonatomic) UserTVInfoModel *userTVInfoModel;
@end
