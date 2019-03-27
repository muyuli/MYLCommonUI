//
//  UIView+BKToast.m
//  BKCommonUI
//
//  Created by anjuke on 2019/3/22.
//

#import "UIView+BKToast.h"

static CGFloat const kMBProgressHUDAlpha = 0.7;

@implementation UIView (BKToast)

- (void)hideLoadWithAnimated:(BOOL)animated
{
    [MBProgressHUD hideAllHUDsForView:self animated:animated];
}

- (void)showLoadWithAnimated:(BOOL)animated
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:animated];
    hud.opacity = kMBProgressHUDAlpha;
    hud.labelText = @"加载中...";
}

- (void)showLoadingActivity:(BOOL)activity{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.opacity = kMBProgressHUDAlpha;
    hud.labelText = @"加载中...";
}

- (void)showLoadingActivity:(BOOL)activity below:(UIView *)view {
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.opacity = kMBProgressHUDAlpha;
    [hud show:activity];
    [self insertSubview:hud belowSubview:view];
    hud.labelText = @"加载中...";
}

- (void)showInfo:(NSString *)info {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.opacity = kMBProgressHUDAlpha;
    hud.labelText = info;
    
    [hud hide:YES afterDelay:2];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide {
    [self showInfo:info image:icon autoHidden:autoHide interval:1.5];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds{
    [self showInfo:info image:icon autoHidden:autoHide interval:seconds yOffset:0];
}

- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide{
    [self showInfo:info image:nil autoHidden:autoHide];
}

- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide yOffset:(int)yOffset{
    [self showInfo:info image:nil autoHidden:autoHide interval:1.5 yOffset:yOffset];
}

- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds {
    [self showInfo:info image:Nil autoHidden:autoHide interval:seconds];
}

- (void)showInfo:(NSString *)info autoHidden:(BOOL)autoHide interval:(NSInteger)seconds userInteractionEnabled:(BOOL)userEnable {
    [self showInfo:info image:nil autoHidden:autoHide interval:seconds yOffset:0 font:nil userInteractionEnabled:YES];
}

- (void)showInfo:(NSString *)info activity:(BOOL)activity{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    hud.opacity = kMBProgressHUDAlpha;
    
    hud.labelText = [NSString stringWithFormat:@"%@",info];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide font:(UIFont *)font
{
    [self showInfo:info image:icon autoHidden:autoHide interval:1.5 yOffset:0 font:font userInteractionEnabled:NO];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds yOffset:(int)yOffset{
    [self showInfo:info image:icon autoHidden:autoHide interval:seconds yOffset:yOffset font:nil userInteractionEnabled:NO];
}

- (void)showInfo:(NSString *)info image:(UIImage *)icon autoHidden:(BOOL)autoHide interval:(NSUInteger)seconds yOffset:(int)yOffset font:(UIFont *)font userInteractionEnabled:(BOOL)userEnable{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.removeFromSuperViewOnHide = YES;
    hud.opacity = kMBProgressHUDAlpha;
    
    [self addSubview:hud];
    
    if (icon) {
        hud.customView = [[UIImageView alloc] initWithImage:icon];
    }
    
    hud.mode = MBProgressHUDModeCustomView;
    hud.detailsLabelFont = hud.labelFont;
    hud.detailsLabelText = info;
    if (yOffset != 0) {
        hud.yOffset = yOffset;
    }
    if (font) {
        hud.labelFont = font;
    }
    
    [hud show:YES];
    if (autoHide) {
        [hud hide:YES afterDelay:(seconds > 0 ? seconds : 1.5)];
    }
    
    if (userEnable) {
        hud.userInteractionEnabled = NO;
    }
}

@end
