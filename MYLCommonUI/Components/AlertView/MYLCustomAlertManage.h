//
//  MYLCustomAlertManage.h
//  BKUIModule
//
//  Created by Muyuli on 2019/3/22.
//  Copyright © 2019年 Muyuli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, CustomAlertVerticalType) {
    CustomAlertVerticalCenter,
    CustomAlertVerticalTop,
    CustomAlertVerticalBottom,
    
};


@interface MYLCustomAlertManage : UIControl

@property (nonatomic, assign) BOOL bolNoHaveBgEvent;
//弹出keywindow上
- (void)showInView;
//弹出到指定view
- (void)showInView:(UIView *)inView;
- (void)dismissView;

/**
 * 带灰底的弹出view
 *
 *  @param view   需要在屏幕中间显示的view
 *  @param isShow 灰底是否覆盖顶部导航，NO覆盖，YES,不覆盖
 *
 *  @return 整个view
 */
+ (UIView *)showAlertView:(UIView *)view
               bolShowNav:(BOOL)isShow
                  offseth:(NSInteger)offseth;


//bgcolor背景色值，alpha 透明度
+ (UIView *)showAlertView:(UIView *)view
               bolShowNav:(BOOL)isShow
                  bgcolor:(UIColor *)bgColor
                  bgAlpha:(float)alpha;

/**
 *  弹出背景框
 *
 *  @param view           想要加在上层的view
 *  @param isShow         是否显示导航 yes显示， no不显示
 *  @param bgColor        背景颜色
 *  @param alpha          底透明度
 *  @param offseth        偏移量
 *  @param bolHaveBgEvent 底部半透明是否有点击事件，yes有
 *
 *  @return 整个弹出view
 */
+ (UIView *)showAlertView:(UIView *)view
               bolShowNav:(BOOL)isShow
                  bgcolor:(UIColor *)bgColor
                  bgAlpha:(float)alpha
                  offseth:(NSInteger)offseth
           bolHaveBgEvent:(BOOL)bolHaveBgEvent;

+ (UIView *)showAlertView:(UIView *)view
               bolShowNav:(BOOL)isShow
                  offseth:(NSInteger)offseth
           bolHaveBgEvent:(BOOL)bolHaveBgEvent;

/**
 *  弹出背景框
 *
 *  @param view           想要加在上层的view
 *  @param isShow         是否显示导航 yes显示， no不显示
 *  @param bgColor        背景颜色
 *  @param alpha          底透明度
 *  @param offseth        向上偏移量
 *  @param bolHaveBgEvent 底部半透明是否有点击事件，yes有
 *  @param inview          指定的view
 *  @return 整个弹出view
 */
+ (UIView *)showAlertView:(UIView *)view
               bolShowNav:(BOOL)isShow
                  bgcolor:(UIColor *)bgColor
                  bgAlpha:(float)alpha
                  offseth:(NSInteger)offseth
           bolHaveBgEvent:(BOOL)bolHaveBgEvent
                   inView:(nullable UIView *)inview;


/**
 *  弹出背景框
 *
 *  @param view           想要加在上层的view
 *  @param isShow         是否显示导航 yes显示， no不显示
 *  @param bgColor        背景颜色
 *  @param alpha          底透明度
 *  @param offseth        向上偏移量
 *  @param bolHaveBgEvent 底部半透明是否有点击事件，yes有
 *  @param inview          指定的view
 *  @prarm verticalType    顶中底，默认中
 *  @return 整个弹出view
 */
+ (UIView *)showAlertView:(UIView *)view
               bolShowNav:(BOOL)isShow
                  bgcolor:(UIColor *)bgColor
                  bgAlpha:(float)alpha
                  offseth:(NSInteger)offseth
           bolHaveBgEvent:(BOOL)bolHaveBgEvent
            alertVertical:(CustomAlertVerticalType)verticalType
                   inView:(nullable UIView *)inview;



@end

NS_ASSUME_NONNULL_END
