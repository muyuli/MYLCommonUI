//
//  ZoomingScrollImageView.h
//  Anjuke2
//
//  Created by liu lh on 14-5-15.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZoomingScrollImageView;
@protocol ZoomingScrollImageViewDelegate <NSObject>

@optional
- (void)singleTapDetected:(ZoomingScrollImageView *)view touchPoint:(CGPoint)point;
- (void)doubleTapDetected:(ZoomingScrollImageView *)view touchPoint:(CGPoint)point;

@end

@interface ZoomingScrollImageView : UIScrollView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, weak) id<ZoomingScrollImageViewDelegate> tapActionDelegate;
@property (nonatomic, assign) BOOL zoomEnabled;

- (void)setDefaultState;
- (void)showScale:(CGFloat)scale;

@end
