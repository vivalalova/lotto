//
//  VideoView.h
//  EasyPlayer
//
//  Created by 霍红雷 on 16/2/24.
//  Copyright © 2016年 霍红雷. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#define PlayerPlaybackEndedNotification  @"PlayerPlaybackEndedNotification"

@interface PlayerView : UIView

-(instancetype)initWithFrame:(CGRect)frame;

-(BOOL) openUrl:(NSString*)URL useVTB:(int)useVTB;
-(void) closeUrl;
-(void) playerPause;
-(void) playerPlay;
-(void) playerShutdown;
- (void) onReplay;

@property(atomic, retain) id<IJKMediaPlayback> player;
@property(nonatomic,retain)NSString *imageUrl;
@end
