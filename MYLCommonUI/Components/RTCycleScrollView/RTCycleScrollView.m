//
//  RTCycleScrollView.m
//  Anjuke2
//
//  Created by liu lh on 14-5-15.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "RTCycleScrollView.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NSTimer (Addition)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;

@end

@implementation NSTimer (Addition)

-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end

@interface RTCycleScrollView () <UIScrollViewDelegate, ZoomingScrollImageViewDelegate>

@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, assign) NSInteger totalPageCount;
@property (nonatomic, strong) NSMutableArray *contentViews;
@property (nonatomic, strong) NSTimer *animationTimer;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;

@property (nonatomic, assign) CGPoint originalContentOffset;

@end

@implementation RTCycleScrollView

#pragma mark -- tapGesture
- (UITapGestureRecognizer *)singleTap
{
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTap.numberOfTapsRequired = 1;
    }
    return _singleTap;
}

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
    }
    return _doubleTap;
}

- (ZoomingScrollImageView *)defaultImageView
{
    if (!_defaultImageView) {
        _defaultImageView = [[ZoomingScrollImageView alloc] initWithFrame:self.bounds];
        _defaultImageView.userInteractionEnabled = YES;
        _defaultImageView.contentMode = UIViewContentModeScaleAspectFill;
        _defaultImageView.tapActionDelegate = self;
        _defaultImageView.hidden = YES;
    }
    return _defaultImageView;
}

- (void)addTapGestureForView:(UIView *)view{
    [self removeTapGestureForView:view];
    [view addGestureRecognizer:self.singleTap];
    [view addGestureRecognizer:self.doubleTap];
}

- (void)removeTapGestureForView:(UIView *)view{
    [view removeGestureRecognizer:self.singleTap];
    [view removeGestureRecognizer:self.doubleTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)tapGesture{
    [self singleTap:self.currentView];
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tapGesture{
    [self doubleTap:self.currentView];
}

#pragma mark -- animationTimer

- (void)pauseTimer
{
    [self.animationTimer pauseTimer];
}

- (void)resumeTimer
{
    [self.animationTimer resumeTimer];
}


- (void)invalidTime
{
    if (_animationTimer) {
        [_animationTimer invalidate];
    }
    _animationTimer = nil;
}

- (id)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)animationDuration
{
    self = [self initWithFrame:frame];
    if (animationDuration > 0.0) {
        [self invalidTime];
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:(self.animationDuration = animationDuration)
                                                           target:self
                                                         selector:@selector(animationTimerDidFired:)
                                                         userInfo:nil
                                                          repeats:YES];
        [_animationTimer pauseTimer];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.usePageControl = YES;
        self.isCycleScroll = YES;
        
        self.clipsToBounds = YES;
        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.autoresizingMask = 0xFF;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.contentSize = CGSizeMake(3 * CGRectGetWidth(self.scrollView.frame), CGRectGetHeight(self.scrollView.frame));
        self.scrollView.delegate = self;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.frame), 0);
        self.scrollView.pagingEnabled = YES;
        self.scrollView.clipsToBounds = YES;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.showsVerticalScrollIndicator = NO;
        
        [self addSubview:self.scrollView];
        
        
        self.pageControl = [[UIPageControl alloc] init];
        self.pageControl.numberOfPages = 0;
        self.pageControl.bottom = self.height - 6;
        self.pageControl.centerX = self.width/2;
        [self addSubview:_pageControl];
        self.pageControl.hidden = YES;
        
        
        self.pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
        self.pageLabel.backgroundColor = [UIColor clearColor];
        self.pageLabel.textAlignment = NSTextAlignmentCenter;
        self.pageLabel.textColor = [UIColor ajkWhiteColor];
        self.pageLabel.font = [UIFont ajkH4Font];
        self.pageLabel.bottom = self.height - 10;
        self.pageLabel.centerX = self.width / 2;
        self.pageLabel.text = @"";
        [self addSubview:_pageLabel];
        self.pageLabel.hidden = YES;

        self.currentPageIndex = 0;
        [self addTapGestureForView:self];
        [self addSubview:self.defaultImageView];

    }
    return self;
}

- (void)setMyContentMode:(MyContentMode)myContentMode
{
    switch (myContentMode) {
        case MyContentModeScrollImageView:
        {
            [self createScrollImageViews];
        }
            break;
        case MyContentModeImageView:
        {
            [self createImageViews];
        }
            break;
        default:
            break;
    }
    _myContentMode = myContentMode;
}

- (void)reloadImages
{
    for (UIView *view in self.contentViews) {
        if ([view isKindOfClass:[ZoomingScrollImageView class]]) {
            UIImageView *imageView = [(ZoomingScrollImageView *)view imageView];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageView.sd_imageURL]];
        }
    }
}

- (void)singleTap:(UIView *)view
{
    if (self.singTapActionBlock) {
        self.singTapActionBlock(view, self.currentPageIndex);
    }
}

- (void)doubleTap:(UIView *)view
{
    if (self.doubleTapActionBlock) {
        self.doubleTapActionBlock(view, self.currentPageIndex);
    }
}

- (void)reloadDataWithCurrentIndex:(NSUInteger)index {
    if ((self.totalPageCount <= 1 )) {
        self.pageLabel.hidden = YES;
    } else {
        self.pageLabel.hidden = NO;
        NSString *string = [NSString stringWithFormat:@"%@/%@", @(index + 1), @(self.totalPageCount)];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        NSUInteger length = string.length;
        [attrString addAttribute:NSStrokeColorAttributeName value:[UIColor colorWithHex:0x333333 alpha:0.5] range:NSMakeRange(0, length)];
        [attrString addAttribute:NSStrokeWidthAttributeName value:@(-3) range:NSMakeRange(0, length)];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor ajkWhiteColor] range:NSMakeRange(0, length)];
        self.pageLabel.attributedText = attrString;
    }
}
#pragma mark -
#pragma mark - 私有函数

- (NSInteger)getCorrectIndexWithIndex:(int)pageIndex
{
    if (pageIndex < 0) {
        pageIndex = 2;
    } else if (pageIndex > 2) {
        pageIndex = 0;
    }
    return pageIndex;
}

- (void)createScrollImageViews
{
    if (!_imageViews) {
        _imageViews = [[NSMutableArray alloc] init];
        for (int i = 0; i<3; i++) {
            ZoomingScrollImageView *scrollView = [[ZoomingScrollImageView alloc] initWithFrame:self.bounds];
            scrollView.userInteractionEnabled = YES;
            scrollView.tapActionDelegate = self;
            [self.imageViews addObject:scrollView];
        }
    }
}

- (void)createImageViews
{
    if (!_imageViews) {
        _imageViews = [[NSMutableArray alloc] init];
        for (int i = 0; i<3; i++) {
            UIImageView *scrollView = [[UIImageView alloc] initWithFrame:self.bounds];
            scrollView.userInteractionEnabled = YES;
            [self.imageViews addObject:scrollView];
        }
    }
}

- (void)configContentWithURL:(NSString *)imageUrlString
{
    self.defaultImageView.hidden = NO;
    
    __weak typeof(self) weakSelf = self;
    if (self.defaultImageView.imageView.sd_imageURL == nil) {
        [self.defaultImageView.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrlString] placeholderImage:[UIImage imageNamed:@"fy_pic_001"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        }];
    }
}

- (void)configContentViews
{
    [self setScrollViewContentDataSource];
    
    NSInteger counter = 0;
    for (UIView *contentView in self.contentViews) {
        contentView.userInteractionEnabled = YES;
        CGRect rightRect = contentView.frame;
        rightRect.origin = CGPointMake(CGRectGetWidth(self.scrollView.frame) * (counter ++), 0);
        contentView.frame = rightRect;
        contentView.hidden = NO;
        if (!contentView.superview) {
            [self.scrollView addSubview:contentView];
        }
    }
    for (UIView *temp in self.scrollView.subviews) {
        if (![self.contentViews containsObject:temp]) {
            temp.hidden = YES;
        }
    }
    
    switch (self.totalPageCount) {
        case 1:
        {
            [_scrollView setContentOffset:CGPointZero];
            _scrollView.scrollEnabled = NO;
        }
            break;
        default:
        {
            _scrollView.scrollEnabled = YES;
            [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
        }
            break;
    }
    if (!self.usePageControl) {
        [self reloadDataWithCurrentIndex:self.currentPageIndex];
    } else {
        self.pageControl.currentPage = self.currentPageIndex;
    }
    if (self.ScrollDidStopBlock) {
        self.ScrollDidStopBlock(self.currentPageIndex);
    }
}

/**
 *  设置scrollView的content数据源，即contentViews
 */
- (void)setScrollViewContentDataSource
{
    NSInteger previousPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
    NSInteger rearPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
    if (self.contentViews == nil) {
        self.contentViews = [NSMutableArray array];
    }
    
    if (self.myContentMode == MyContentModeScrollImageView || self.myContentMode == MyContentModeImageView) {
        self.contentViews = self.imageViews;
    } else {
        [self.contentViews removeAllObjects];
    }
    
    switch (self.totalPageCount) {
        case 1:
        {
            if (self.fetchCurrentContentViewAtIndex) {
                [self resetContentViewsAtPage:_currentPageIndex objectIndex:0 block:self.fetchCurrentContentViewAtIndex];
            }
        }
            break;
        default:
        {
            if (self.fetchCurrentContentViewAtIndex) {
                [self resetContentViewsAtPage:_currentPageIndex objectIndex:1 block:self.fetchCurrentContentViewAtIndex];
            }
            if (self.isCycleScroll) {
                if (self.fetchNextContentViewAtIndex) {
                    [self resetContentViewsAtPage:rearPageIndex objectIndex:2 block:self.fetchNextContentViewAtIndex];
                }
                if (self.fetchPreContentViewAtIndex) {
                    [self resetContentViewsAtPage:previousPageIndex objectIndex:0 block:self.fetchPreContentViewAtIndex];
                }
            } else {
                if (self.currentPageIndex != self.totalPageCount - 1) {
                    if (self.fetchNextContentViewAtIndex) {
                        [self resetContentViewsAtPage:rearPageIndex objectIndex:2 block:self.fetchNextContentViewAtIndex];
                    }
                }
                if (self.currentPageIndex != 0) {
                    if (self.fetchPreContentViewAtIndex) {
                        [self resetContentViewsAtPage:previousPageIndex objectIndex:0 block:self.fetchPreContentViewAtIndex];
                    }
                }
            }
        }
            break;
    }
}
//(void (^)(BOOL finished))completion
- (void)resetContentViewsAtPage:(NSInteger)page objectIndex:(NSInteger)index block:(UIView *(^)(UIView *view, NSInteger currentIndex, NSInteger pageIndex))block
{
    UIView *oldView = [self.contentViews aif_objectOrNilAtIndex:index];
    UIView *newView = block(oldView, _currentPageIndex, page);
    
    if (self.myContentMode == MyContentModeScrollImageView) {
        if ([oldView isKindOfClass:ZoomingScrollImageView.class]){
            [(ZoomingScrollImageView *)oldView setDefaultState];
        }
    }
    if (_currentPageIndex == page) {
        _currentView = newView;
    }
    if (self.myContentMode == MyContentModeScrollImageView || self.myContentMode == MyContentModeImageView) {
        if (newView != oldView) {
            [oldView removeFromSuperview];
            if (newView) {
                [self.contentViews replaceObjectAtIndex:1 withObject:newView];
            }
        }
    } else {
        if (newView) {
            [self.contentViews addObject:newView];
        }
    }
}

- (NSInteger)getValidNextPageIndexWithPageIndex:(NSInteger)currentPageIndex;
{
    if(currentPageIndex == -1) {
        return self.totalPageCount - 1;
    } else if (currentPageIndex == self.totalPageCount) {
        return 0;
    } else {
        return currentPageIndex;
    }
}

- (void)showViewAtIndex:(NSInteger)index
{
    self.currentPageIndex = index;
    [self configContentViews];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_animationTimer pauseTimer];
    self.originalContentOffset = scrollView.contentOffset;

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    int contentOffsetX = scrollView.contentOffset.x;

    if (!self.isCycleScroll) {
        if (contentOffsetX > self.originalContentOffset.x && self.currentPageIndex == self.totalPageCount - 1) {
            [self configContentViews];
            //[self.scrollView setContentOffset:self.originalContentOffset animated:NO];
            //[self.scrollView setContentOffset:CGPointMake(300, 0) animated:NO];

            return;
        }
        if (contentOffsetX < self.originalContentOffset.x && self.currentPageIndex == 0) {
            //[self.scrollView setContentOffset:self.originalContentOffset animated:NO];
            [self configContentViews];
            return;
        }

    }

    if(contentOffsetX >= (1.95 * CGRectGetWidth(scrollView.frame))) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex + 1];
        [self configContentViews];
    }
    if(contentOffsetX <= 0) {
        self.currentPageIndex = [self getValidNextPageIndexWithPageIndex:self.currentPageIndex - 1];
        [self configContentViews];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [scrollView setContentOffset:CGPointMake(CGRectGetWidth(scrollView.frame), 0) animated:YES];
}

#pragma mark -
#pragma mark - 响应事件

- (void)setTotalPagesCount:(NSInteger (^)(void))totalPagesCount
{
    _totalPageCount = totalPagesCount();
    if (_totalPageCount > 0) {
        self.pageControl.numberOfPages = _totalPageCount;
        if (_totalPageCount > 1) {
            //            self.pageControl.hidden = NO;
            [_animationTimer resumeTimerAfterTimeInterval:self.animationDuration];
        } else {
            //            self.pageControl.hidden = YES;
        }
    }
}

- (void)animationTimerDidFired:(NSTimer *)timer
{
    CGFloat x = .0;
    if (self.totalPageCount == 1) {
        
    } else {
        x = self.width;
    }
    CGPoint newOffset = CGPointMake(x + CGRectGetWidth(self.scrollView.frame), self.scrollView.contentOffset.y);
    [self.scrollView setContentOffset:newOffset animated:YES];
}

- (void)setImageZoomEnabled:(BOOL)imageZoomEnabled
{
    for (UIView *view in self.contentViews) {
        if ([view isKindOfClass:[ZoomingScrollImageView class]]) {
            [(ZoomingScrollImageView *)view setZoomEnabled:imageZoomEnabled];
        }
    }
}

- (void)showScaleMax:(BOOL)max{
    for (UIView *view in self.contentViews) {
        if ([view isKindOfClass:[ZoomingScrollImageView class]]) {
            ZoomingScrollImageView *temp = (ZoomingScrollImageView *)view;
            [temp showScale: max ? temp.maximumZoomScale : temp.minimumZoomScale];
        }
    }
}


#pragma mark -- ZoomingScrollImageViewDelegate
- (void)singleTapDetected:(ZoomingScrollImageView *)view touchPoint:(CGPoint)point
{
    [self singleTap:view];
}

- (void)doubleTapDetected:(ZoomingScrollImageView *)view touchPoint:(CGPoint)point
{
    [self doubleTap:view];
}

@end
