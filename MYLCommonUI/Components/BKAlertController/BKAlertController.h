//
//  BKAlertController.h
//  JFTransitionDemo
//
//  Created by James on 2017/7/21.
//  Copyright © 2017年 IJFT. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_CLASS_AVAILABLE_IOS(8_0) @interface BKAlertAction : NSObject

@property (nonatomic, readonly) NSString           *title;
@property (nonatomic, readonly) UIAlertActionStyle style;
@property (nonatomic, strong)   UIColor            *titleColor;
@property (nonatomic, strong)   UIFont             *titleFont;
/*
 *  当在addAction之后设置action属性时,会回调这个block,设置相应控件的字体、颜色等
 */
@property (nonatomic, copy)     void (^propertyEvent)(BKAlertAction *action);

+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(BKAlertAction *action))handler;

@end

NS_CLASS_AVAILABLE_IOS(8_0) @interface BKAlertController : UIViewController

@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSArray<BKAlertAction *> *actions;

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message;
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredMaxHeight:(CGFloat)preferredMaxHeight;
+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message deviceOrientation:(UIDeviceOrientation)deviceOrientation;
+ (instancetype)alertControllerWithTitle:(NSString *)title customView:(UIView *)customView edgeInsets:(UIEdgeInsets)edgeInsets;

- (void)addAction:(BKAlertAction *)action;

@end
