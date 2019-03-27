//
//  UIView+BKToast.h
//  BKCommonUI
//
//  Created by anjuke on 2019/3/22.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface UIView (BKToast)

- (void)hideLoadWithAnimated:(BOOL)animated;
- (void)showLoadWithAnimated:(BOOL)animated;
- (void)showLoadingActivity:(BOOL)activity;
- (void)showLoadingActivity:(BOOL)activity below:(UIView *)view;
- (void)showInfo:(NSString *)info;
- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide;
- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide;
- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds;
- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide yOffset:(int)yOffset;
- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide font:(UIFont *)font;
- (void)showInfo:(NSString *)info activity:(BOOL)activity;

/**
 * userInteractionEnabled default is NO
 */
- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide interval:(NSInteger)seconds userInteractionEnabled:(BOOL)userEnable;

@end

