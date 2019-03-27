//
//  BKAlertAnimationController.m
//  AnjukeBroker_New
//
//  Created by James on 2017/6/5.
//  Copyright © 2017年 Anjuke. All rights reserved.
//

#import "BKAlertAnimationController.h"

@implementation BKAlertAnimationController

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.2;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext
{
    UIView *containerView = transitionContext.containerView;
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    if (toViewController.beingPresented) {
        
        [containerView addSubview:toView];
        
        CGFloat toViewWidth = self.presentedViewSize.width;
        CGFloat toViewHeight = self.presentedViewSize.height;
        
        toView.center = containerView.center;
        toView.bounds = CGRectMake(0, 0, toViewWidth, toViewHeight);
        toView.layer.cornerRadius = 5;
        toView.layer.masksToBounds = YES;
        
        [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
        
    } else if (fromViewController.beingDismissed) {
        
        [UIView animateWithDuration:duration animations:^{
            fromView.alpha = 0;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
        }];
    }
}

@end
