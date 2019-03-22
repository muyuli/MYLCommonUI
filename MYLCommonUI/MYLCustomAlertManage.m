//
//  MYLCustomAlertManage.m
//  BKUIModule
//
//  Created by Muyuli on 2019/3/22.
//  Copyright © 2019年 Muyuli. All rights reserved.
//

#import "MYLCustomAlertManage.h"
#import "UIView+AF.h"
@implementation MYLCustomAlertManage

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(action_disMiss:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)action_disMiss:(UIControl *)control
{
    if (self.bolNoHaveBgEvent) {
        return;
    }
    @synchronized(self)
    {
        [self dismissView];
    }
    
}
- (void)dismissView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)showInView:(UIView *)inView
{
    if (inView)
        [inView addSubview:self];
    else
        [self showInView];
    
}

- (void)showInView
{
    //动画暂时先去掉
    //    self.alpha = 0;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    //    [UIView animateWithDuration:0.2 animations:^{
    //        self.alpha = 1.0;
    //    }];
}

+ (UIView *)showAlertView:(UIView *)view
               bolShowNav:(BOOL)isShow
                  bgcolor:(UIColor *)bgColor
                  bgAlpha:(float)alpha
                  offseth:(NSInteger)offseth
           bolHaveBgEvent:(BOOL)bolHaveBgEvent
                   inView:(UIView *)inview
{
    
    CGRect tempFrame = [[UIScreen mainScreen] bounds];
    
    if (inview) {
        tempFrame = inview.bounds;
    }
    
    tempFrame.origin.y = isShow?(64):0;
    tempFrame.size.height -= CGRectGetMinY(tempFrame);
    MYLCustomAlertManage *alert = [[MYLCustomAlertManage alloc] initWithFrame:tempFrame];
    alert.backgroundColor = [UIColor clearColor];
    alert.bolNoHaveBgEvent = !bolHaveBgEvent;
    
    UIView *bottomView = [[UIView alloc] initWithFrame:alert.bounds];
    bottomView.backgroundColor = bgColor;
    [alert addSubview:bottomView];
    bottomView.alpha = alpha;
    bottomView.userInteractionEnabled = NO;
    
    CGRect viewFrame = view.frame;
    viewFrame.origin.x = (tempFrame.size.width-viewFrame.size.width)/2.0;
    viewFrame.origin.y = (tempFrame.size.height - viewFrame.size.height)/2.0-offseth;
    view.frame = viewFrame;
    
    if (view) {
        [alert addSubview:view];
    }
    
    [alert showInView:inview];
    return alert;
}

+ (UIView *)showAlertView:(UIView *)view
               bolShowNav:(BOOL)isShow
                  bgcolor:(UIColor *)bgColor
                  bgAlpha:(float)alpha
                  offseth:(NSInteger)offseth
           bolHaveBgEvent:(BOOL)bolHaveBgEvent
            alertVertical:(CustomAlertVerticalType)verticalType
                   inView:(UIView *)inview
{
    UIView *alert = [self showAlertView:view bolShowNav:isShow bgcolor:bgColor bgAlpha:alpha offseth:offseth bolHaveBgEvent:bolHaveBgEvent inView:inview];
    CGFloat ypoint = view.y;
    switch (verticalType) {
        case CustomAlertVerticalTop:
            ypoint = 0 - offseth;
            break;
        case CustomAlertVerticalBottom:
            ypoint = alert.height - view.height - offseth;
            break;
            
        default:
            break;
    }
    
    view.y = ypoint;
    return alert;
}

+ (UIView *)showAlertView:(UIView *)view
               bolShowNav:(BOOL)isShow
                  bgcolor:(UIColor *)bgColor
                  bgAlpha:(float)alpha
                  offseth:(NSInteger)offseth
           bolHaveBgEvent:(BOOL)bolHaveBgEvent
{
    return [MYLCustomAlertManage showAlertView:view bolShowNav:isShow bgcolor:bgColor bgAlpha:alpha offseth:offseth bolHaveBgEvent:bolHaveBgEvent inView:nil];
}

+ (UIView *)showAlertView:(UIView *)view
               bolShowNav:(BOOL)isShow
                  bgcolor:(UIColor *)bgColor
                  bgAlpha:(float)alpha
{
    return [MYLCustomAlertManage showAlertView:view bolShowNav:isShow bgcolor:bgColor bgAlpha:alpha offseth:0 bolHaveBgEvent:YES];
}

+ (UIView *)showAlertView:(UIView *)view
               bolShowNav:(BOOL)isShow
                  bgcolor:(UIColor *)bgColor
                  bgAlpha:(float)alpha
                  offseth:(NSInteger)offseth
{
    return [self showAlertView:view bolShowNav:isShow bgcolor:bgColor bgAlpha:alpha offseth:offseth bolHaveBgEvent:YES];
}

+ (UIView *)showAlertView:(UIView *)view
               bolShowNav:(BOOL)isShow
                  offseth:(NSInteger)offseth
{
    return [MYLCustomAlertManage showAlertView:view bolShowNav:isShow bgcolor:[UIColor blackColor] bgAlpha:0.7 offseth:offseth];
}

+ (UIView *)showAlertView:(UIView *)view
               bolShowNav:(BOOL)isShow
                  offseth:(NSInteger)offseth
           bolHaveBgEvent:(BOOL)bolHaveBgEvent
{
    return [MYLCustomAlertManage showAlertView:view bolShowNav:isShow bgcolor:[UIColor blackColor] bgAlpha:0.6 offseth:offseth bolHaveBgEvent:bolHaveBgEvent];
}



@end
