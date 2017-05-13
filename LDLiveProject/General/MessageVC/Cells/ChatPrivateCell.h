//
//  ChatPrivateCell.h
//  LiveProject
//
//  Created by coolyouimac01 on 16/5/26.
//  Copyright © 2016年 Mac. All rights reserved.
//  私聊

#import <UIKit/UIKit.h>
@class ChatPrivateModel;
@class MessListModel;
@class M80AttributedLabel;
@protocol ChatPrivateCellDelegate <NSObject>
-(void)delSingleMsgWithMsgID:(NSString *)msgid rect:(CGRect)frame;
@end
@interface ChatPrivateCell : UITableViewCell
@property(nonatomic,assign)id<ChatPrivateCellDelegate>delegate;
- (void)setChatPrivateModel:(ChatPrivateModel *)chatPrivateModel chatListModel:(MessListModel *)chatListModel;
@end
