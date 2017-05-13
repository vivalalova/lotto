//
//  PhoneChatTextCell.h
//  LiveProject
//
//  Created by coolyouimac01 on 15/12/28.
//  Copyright © 2015年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneChatTextCell : UITableViewCell
@property (nonatomic,strong)NSString *chatTextStr;
@property (nonatomic,strong)NSDictionary *messageDict;
@property (weak, nonatomic) IBOutlet UILabel *chatText;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (assign, nonatomic)CGFloat textFont;
@end
