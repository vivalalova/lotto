//
//  PhoneLiveVipCell.h
//  LiveProject
//
//  Created by coolyouimac01 on 16/5/11.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserChatModel;
@class M80AttributedLabel;
@protocol PhoneLiveVipCellDelegate <NSObject>
@optional
-(void)showVisitorInformationOfChatCell:(UserChatModel*)model;
@end
@interface PhoneLiveVipCell : UITableViewCell
@property (assign, nonatomic) CGFloat font;
@property (strong, nonatomic)UserChatModel *userChatModel;
@property (assign, nonatomic)id<PhoneLiveVipCellDelegate>delegate;
@end
