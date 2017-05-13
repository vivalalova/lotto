//
//  PhoneLiveCell.h
//  LiveProject
//
//  Created by coolyouimac01 on 16/4/14.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SocketMessageModel;
@class GiftOneModel;
@class UserWelcomeModel;
@class UserSendGiftModel;
@class M80AttributedLabel;
@protocol PhoneLiveCellDelegate <NSObject>
@optional
-(void)showVisitorInfoOfChatUsualCell:(NSString*)uid;
@end

@interface PhoneLiveCell : UITableViewCell
@property (assign, nonatomic) CGFloat font;
@property (strong,nonatomic) UIColor *msgColor;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet M80AttributedLabel *contentLbl;
@property (assign, nonatomic)id<PhoneLiveCellDelegate>delegate;
@property (strong, nonatomic)NSString *uid;
@property (strong, nonatomic)SocketMessageModel *socketMessageModel;//聊天信息
@property (strong, nonatomic)NSString *msgStr;//一句话文字信息
@property (strong, nonatomic)UserWelcomeModel *userWelcomeModel;//欢迎用户信息
@property (strong, nonatomic)UserSendGiftModel *userSendGiftModel;
@property (strong, nonatomic)GiftOneModel *giftOneModel;
@property (strong, nonatomic)NSString *giftPicBaseUrlStr;

@property(assign,nonatomic)BOOL isAnchorBool;//送礼物时用到
@property (strong, nonatomic)NSDictionary *messageDict;
@property (strong, nonatomic)NSDictionary *updateDict;//用户升级
@property (strong, nonatomic)NSDictionary *bubbleDict;//气泡
-(void)setDataWithUserSendGiftModel:(UserSendGiftModel*)userSendGiftModel withGiftOneModel:(GiftOneModel*)giftOneModel;//送礼物信息
@end
