//
//  UIViewController+Loading.h
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-8.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIViewController (BKToast)

- (void)hideLoadWithAnimated:(BOOL)animated;
- (MBProgressHUD *)showLoadingActivity:(BOOL)activity;
- (MBProgressHUD *)showLoadingActivity:(BOOL)activity transform:(CGAffineTransform)transform;
- (void)showInfo:(NSString *)info transform:(CGAffineTransform)transform;
- (void)showInfo:(NSString *)info;
- (void)showInfoOnWindow:(NSString *)info;
- (void)showDetailInfo:(NSString *)info;
- (void)showDetailInfo:(NSString *)info afterDelay:(NSTimeInterval)afterDelaySecond;
- (void)showInfoWithTitle:(NSString *)title andDetail: (NSString *)detail;
- (void)showShootInfo:(NSString *)info transform:(CGAffineTransform)transform;
// 指定toast icon 样式
- (void)showDetailInfo:(NSString *)info image:(UIImage *)image hideAfterDelay:(NSTimeInterval)delay;
// 默认成功样式
- (void)showSucceedToastWithText:(NSString *)text hideAfterDelay:(NSTimeInterval)delay;
// 默认失败样式
- (void)showFailedToastWithText:(NSString *)text hideAfterDelay:(NSTimeInterval)delay;

@end
