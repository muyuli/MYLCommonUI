//
//  ZoomingScrollImageView.m
//  Anjuke2
//
//  Created by liu lh on 14-5-15.
//  Copyright (c) 2014年 anjuke inc. All rights reserved.
//

#import "ZoomingScrollImageView.h"


@interface ZoomingScrollImageView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;


@end

@implementation ZoomingScrollImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.delegate = self;
        self.maximumZoomScale = 2;
        self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.userInteractionEnabled = YES;
        [self addSubview:self.imageView];
        
        float minimumScale = self.frame.size.width / self.imageView.frame.size.width;
        [self setMinimumZoomScale:minimumScale];
        [self setZoomScale:minimumScale];
        self.userInteractionEnabled = YES;
        self.multipleTouchEnabled = YES;
    }
    return self;
}

- (void)setDefaultState
{
    self.zoomScale = 1;
   // [self resetImageViewFrame];
}

- (void)showScale:(CGFloat)scale
{
    self.zoomScale = scale;
    [self resetImageViewFrame];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.imageView.frame.size.height / scale;
    zoomRect.size.width  = self.imageView.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}

- (void)resetImageViewFrame
{
    if (self.imageView.image) {
        CGRect photoImageViewFrame;
        photoImageViewFrame.origin = CGPointZero;
        photoImageViewFrame.size = [self getMaxSizeWith:self.imageView.image.size];
        photoImageViewFrame.size.height += 30;
        
        self.imageView.frame = photoImageViewFrame;
       // self.contentSize = photoImageViewFrame.size;
        self.contentSize = CGSizeMake(MIN(photoImageViewFrame.size.width, 320), photoImageViewFrame.size.height);
        //[self setNeedsLayout];
    }
   
}

- (void)imageView:(UIImageView *)imageView singleTapDetected:(CGPoint)point
{
    if (self.tapActionDelegate && [self.tapActionDelegate respondsToSelector:@selector(singleTapDetected:touchPoint:)]) {
        [self.tapActionDelegate singleTapDetected:self touchPoint:point];
    }
}

- (void)imageView:(UIImageView *)imageView doubleTapDetected:(CGPoint)point
{
    if (![self.tapActionDelegate respondsToSelector:@selector(doubleTapDetected:touchPoint:)]) {
        return;
    }
    
    if (self.zoomEnabled) {
        if (self.zoomScale != self.minimumZoomScale) {
            [self setZoomScale:1 animated:YES];
        } else {
            CGRect zoomRect = [self zoomRectForScale:self.maximumZoomScale withCenter:point];
            [self zoomToRect:zoomRect animated:YES];
        }
        [self setNeedsLayout];
    }
    
    [self.tapActionDelegate doubleTapDetected:self touchPoint:point];
}

- (CGSize)getMaxSizeWith:(CGSize)size
{
    CGFloat horizontalRatio = self.width / size.width;
    CGFloat verticalRatio = self.height / size.height;
    CGFloat ratio = MIN(horizontalRatio, verticalRatio);

    
    CGSize newSize = CGSizeMake(size.width * ratio, size.height * ratio);
    
    return newSize;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(self.imageView.frame, frameToCenter))
        self.imageView.frame = frameToCenter;
}

#pragma mark - UIScrollViewDelegate

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    if (self.zoomEnabled) {
        return self.imageView;
    }
    return nil;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
}

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

- (void)responseSingleTap:(BOOL)response{
    [self removeGestureRecognizer:self.singleTap];
    if (response) {
        [self addGestureRecognizer:self.singleTap];
    }
}


- (void)responseDoubleTap:(BOOL)response{
    [self removeGestureRecognizer:self.doubleTap];
    if (response) {
        [self addGestureRecognizer:self.doubleTap];
        [self.singleTap requireGestureRecognizerToFail:self.doubleTap];
    }
}


- (void)setTapActionDelegate:(id<ZoomingScrollImageViewDelegate>)tapActionDelegate
{
    BOOL temp = !tapActionDelegate ? NO : YES;
    self.userInteractionEnabled = temp;
    _tapActionDelegate = tapActionDelegate;
    [self responseSingleTap:temp];
    [self responseDoubleTap:temp];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)gesture {
	if (self.tapActionDelegate && [self.tapActionDelegate respondsToSelector:@selector(singleTapDetected:touchPoint:)])
    {
        CGPoint touchPoint = [gesture locationInView:self];
        [self.tapActionDelegate singleTapDetected:self touchPoint:touchPoint];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)gesture {
	if (self.tapActionDelegate && [self.tapActionDelegate respondsToSelector:@selector(doubleTapDetected:touchPoint:)])
    {
        CGPoint touchPoint = [gesture locationInView:self];
        if (self.zoomEnabled) {
            if (self.zoomScale != self.minimumZoomScale) {
                [self setZoomScale:1 animated:YES];
            } else {
                CGRect zoomRect = [self zoomRectForScale:self.maximumZoomScale withCenter:touchPoint];
                [self zoomToRect:zoomRect animated:YES];
            }
            [self setNeedsLayout];
        }
		[self.tapActionDelegate doubleTapDetected:self touchPoint:touchPoint];
    }
}


@end
