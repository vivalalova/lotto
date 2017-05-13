//
//  MBAnimationView.h
//  AnimationTest
//
//  Created by Michael Behan on 02/03/2014.
//  Copyright (c) 2014 Michael Behan. All rights reserved.
//

#define kMBAnimationImageViewOptionRepeatForever INT_MAX

#import <UIKit/UIKit.h>
@protocol MBAnimationViewDelegate <NSObject>
@optional
- (void)animationViewIsFinished;//动画完成
@end
@interface MBAnimationView : UIView
{
    UIImageView *imageView;
    NSArray *animationData;
    NSInteger animationNumFrames;
}
@property (nonatomic, readonly)NSInteger currentFrameNumber;
@property (nonatomic, readonly) UIImage *currentFrameImage;
@property (nonatomic, assign)id<MBAnimationViewDelegate>delegate;

-(void)playAnimation:(NSString *)animationName withRange:(NSRange)range numberPadding:(int)padding ofType:(NSString *)ext fps:(NSInteger)fps repeat:(int)repeat completion:(void (^)())completionBlock;

-(void)setImage:(UIImage *)image;
- (void) startAnimating;

- (void) stopAnimating;
- (BOOL) isAnimating;

@end
