//
//  UIViewController+Loading.m
//  AnjukeBroker_New
//
//  Created by Wu sicong on 13-11-8.
//  Copyright (c) 2013年 Wu sicong. All rights reserved.
//

#import "UIViewController+BKToast.h"
#import <AIFCommonUI/AIFCommonUI.h>
#import "BKUIUtils.h"

@implementation UIViewController (BKToast)

- (void)hideLoadWithAnimated:(BOOL)animated
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (MBProgressHUD *)showLoadingActivity:(BOOL)activity
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (DEVICE_IS_IPHONE4) {
        hud.yOffset = -45;
    } else
        hud.yOffset = -20;
    hud.labelText = @"加载中...";
    return hud;
}

- (MBProgressHUD *)showLoadingActivity:(BOOL)activity transform:(CGAffineTransform)transform
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    if (DEVICE_IS_IPHONE4) {
        hud.yOffset = -45;
    } else
        hud.yOffset = -20;
    hud.labelText = @"加载中...";
    hud.transform = transform;
    return hud;
}

- (void)showInfo:(NSString *)info transform:(CGAffineTransform)transform
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = info;
    hud.hidden = NO;
    if (DEVICE_IS_IPHONE4) {
        hud.yOffset = -85;
    } else {
        hud.yOffset = -40;
    }
    hud.transform = transform;
    [hud hide:YES afterDelay:1.5];
}

- (void)showShootInfo:(NSString *)info transform:(CGAffineTransform)transform
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = info;
    hud.hidden = NO;
    if (DEVICE_IS_IPHONE4) {
        hud.yOffset = -85;
    } else {
        hud.yOffset = -10;
    }
    hud.transform = transform;
    [hud hide:YES afterDelay:1.5];
}

- (void)showInfo:(NSString *)info
{
    
    [self showDetailInfo:info];
}

- (void)showInfoOnWindow:(NSString *)info
{
    UIWindow *win = UIApplication.sharedApplication.delegate.window;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:win animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = info;
    hud.hidden = NO;
    if (DEVICE_IS_IPHONE4) {
        hud.yOffset = -85;
    } else {
        hud.yOffset = -40;
    }
    [hud hide:YES afterDelay:1.5];
}

- (void)showInfoWithTitle:(NSString *)title andDetail: (NSString *)detail
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.detailsLabelText = detail;
    hud.hidden = NO;
    if (DEVICE_IS_IPHONE4) {
        hud.yOffset = -85;
    } else {
        hud.yOffset = -40;
    }
    [hud hide:YES afterDelay:2];
}

- (void)showDetailInfo:(NSString *)info
{
    if ([info length] == 0) {
        return;
    }
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = info;
    hud.hidden = NO;
    if (DEVICE_IS_IPHONE4) {
        hud.yOffset = -85;
    } else {
        hud.yOffset = -40;
    }
    [hud hide:YES afterDelay:1.5];
}

- (void)showDetailInfo:(NSString *)info afterDelay:(NSTimeInterval)afterDelaySecond
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = info;
    hud.hidden = NO;
    if (DEVICE_IS_IPHONE4) {
        hud.yOffset = -85;
    } else {
        hud.yOffset = -40;
    }
    [hud hide:YES afterDelay:afterDelaySecond];
}

- (void)showDetailInfo:(NSString *)info image:(UIImage *)image hideAfterDelay:(NSTimeInterval)delay
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 129, 101)];
    customView.backgroundColor = [UIColor blackColor];
    customView.alpha = 0.7;
    customView.layer.cornerRadius = 5;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [customView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(customView).offset(25);
        make.centerX.equalTo(customView);
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.font = [UIFont ajkH4Font];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = info;
    [customView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(customView).offset(5);
        make.right.equalTo(customView).offset(-5);
        make.bottom.equalTo(customView).offset(-25);
    }];
    
    hud.color = [UIColor clearColor];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = customView;
    if (delay > 0) {
        [hud hide:YES afterDelay:delay];
    }
}

// 便利方法
- (void)showSucceedToastWithText:(NSString *)text hideAfterDelay:(NSTimeInterval)delay
{
    [self showDetailInfo:text image:[UIImage imageNamed:@"icon_zq_toast"] hideAfterDelay:delay];
}

- (void)showFailedToastWithText:(NSString *)text hideAfterDelay:(NSTimeInterval)delay
{
    [self showDetailInfo:text image:[UIImage imageNamed:@"icon_cw_toast.png"] hideAfterDelay:delay];
}

@end
