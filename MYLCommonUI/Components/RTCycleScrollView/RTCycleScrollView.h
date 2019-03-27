//
//  RTCycleScrollView.h
//  Anjuke2
//
//  Created by liu lh on 14-5-15.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "ZoomingScrollImageView.h"

typedef NS_ENUM(NSInteger, MyContentMode) {
    MyContentModeCustom = 0,
    MyContentModeScrollImageView,
    MyContentModeImageView
};


@interface RTCycleScrollView : UIView

@property (nonatomic , strong) UIScrollView *scrollView;
@property (nonatomic, strong ) ZoomingScrollImageView *defaultImageView;

/**
 *  初始化
 *
 *  @param frame             frame
 *  @param animationDuration 自动滚动的间隔时长。如果<=0，不自动滚动。
 *
 *  @return instance
 */
- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration;

/**
 数据源：获取总的page个数
 **/
@property (nonatomic , strong) NSInteger (^totalPagesCount)(void);

/**
 前一个显示内容
 **/
@property (nonatomic , strong) UIView *(^fetchPreContentViewAtIndex)(UIView *view, NSInteger currentIndex, NSInteger pageIndex);
/**
 当前显示内容
 **/
@property (nonatomic , strong) UIView *(^fetchCurrentContentViewAtIndex)(UIView *view, NSInteger currentIndex, NSInteger pageIndex);
/**
 下一个显示内容
 **/
@property (nonatomic , strong) UIView *(^fetchNextContentViewAtIndex)(UIView *view, NSInteger currentIndex, NSInteger pageIndex);
/**
 单击的时候，执行的block
 **/
@property (nonatomic , strong) void (^singTapActionBlock)(UIView *view, NSInteger pageIndex);
/**
 双击的时候，执行的block
 **/
@property (nonatomic , strong) void (^doubleTapActionBlock)(UIView *view, NSInteger pageIndex);
/**
 图片翻页完成
 **/
@property (nonatomic , strong) void (^ScrollDidStopBlock)(NSInteger pageIndex);

/**
 如果是MyContentModeImage模式则自动创建ImageView
 **/
@property (nonatomic, assign) MyContentMode myContentMode;
@property (nonatomic, assign) BOOL imageZoomEnabled;

// 默认pageControl和pageLael都是隐藏的，如果要显示pageControl，则hidden为NO, 如果要显示pageLabel,则usePageControl为NO

@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, assign) BOOL usePageControl;            // 默认为YES
@property (nonatomic, assign) BOOL useCustomTouch;
@property (nonatomic, assign) BOOL isCycleScroll; //是否循环滚动，有需求为滚到最后不一张不能继续滚动（如抢房源单页）。默认YES

@property (nonatomic, readonly) UIView *currentView;
@property (nonatomic, readonly) NSInteger currentPageIndex;
@property (nonatomic, readonly) NSInteger totalPageCount;

- (void)reloadImages;
- (void)invalidTime;
- (void)pauseTimer;
- (void)resumeTimer;
- (void)showScaleMax:(BOOL)max;
- (void)showViewAtIndex:(NSInteger)index;
- (void)configContentWithURL:(NSString *)imageUrlString;
- (void)reloadDataWithCurrentIndex:(NSUInteger)index;

@end
