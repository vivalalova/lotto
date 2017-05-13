//  WHScrollAndPageView.h
//  循环滚动视图
//
//  Created by jereh on 15-3-15.
//  Copyright (c) 2015年 jereh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScrollViewViewDelegate;

@interface ScrollAndPageView : UIView <UIScrollViewDelegate>
{
    __unsafe_unretained id <ScrollViewViewDelegate> _delegate;
}

@property (nonatomic, assign) id <ScrollViewViewDelegate> delegate;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) NSMutableArray *imageViewAry;

@property (nonatomic, readonly) UIScrollView *scrollView;

@property (nonatomic, readonly) UIPageControl *pageControl;

-(void)shouldAutoShow:(BOOL)shouldStart;

@end

@protocol ScrollViewViewDelegate <NSObject>

@optional
- (void)didClickPage:(ScrollAndPageView *)view atIndex:(NSInteger)index;

@end