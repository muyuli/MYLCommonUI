//
//  UIView+Create.h
//  AnjukeBroker_New
//
//  Created by Muyuli on 2018/8/23.
//  Copyright © 2018年 MYL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Create)

+ (nonnull UIView *)viewForColor:(nullable UIColor *)color withFrame:(CGRect)frame;

- (nonnull UIView *)buildView:(CGRect)frame bgColor:(nullable UIColor *)bgColor;

- (nonnull UILabel *)buildLabel:(CGRect)frame textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font text:(nullable NSString *)text;

- (nonnull UILabel *)buildLabel:(CGRect)frame textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font text:(nullable NSString *)text textAlignment:(NSTextAlignment)textAlignment;

- (nonnull UIButton *)buildButtonWithTitle:(nullable NSString *)title frame:(CGRect)frame cornerRadius:(float)radius target:(nullable id)obj action:(nullable SEL)selector block:(void (^__nullable)(UIButton * __nonnull btn))block;

- (nonnull UIButton *)buildButtonWithTitle:(nullable NSString *)title frame:(CGRect)frame target:(__nullable id)obj action:(__nullable SEL)selector block:(void (^__nullable)(UIButton *btn))block;

- (nonnull UIImageView *)buildImage:(CGRect)frame image:(nullable NSString *)imageName;

/**
 给View添加点击效果
 */
- (void)addTapTarget:(nullable id)target selector:(nullable SEL)selector;

@end


#pragma mark - UILabel

@interface UILabel (Create)

+ (nullable UILabel *)creatLableWithTitleColor:(nullable UIColor*)titleColor withFont:(nullable UIFont *)font withFrame:(CGRect)frame;

+ (nullable UILabel *)labelWithFrame:(CGRect)frame text:(nullable NSString *)text textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font backColor:(nullable UIColor *)backColor textAlignment:(NSTextAlignment)textAlignment;

+ (nullable UILabel *)labelWithFrame:(CGRect)frame text:(nullable NSString *)text textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font backColor:(nullable UIColor *)backColor;

+ (nullable UILabel *)labelWithFrame:(CGRect)frame text:(nullable NSString *)text textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font textAlignment:(NSTextAlignment)textAlignment;

+ (nullable UILabel *)labelWithFrame:(CGRect)frame text:(nullable NSString *)text textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font;

+ (nullable UILabel *)labelWithFrame:(CGRect)frame text:(nullable NSString *)text textColor:(nullable UIColor *)textColor;

+ (nullable UILabel *)labelLeftAlignWithFrame:(CGRect)frame text:(nullable NSString *)text textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font;

+ (nullable UILabel *)labelCenterAlignWithFrame:(CGRect)frame
                                           text:(nullable NSString *)text
                                      textColor:(nullable UIColor *)textColor
                                           font:(nullable UIFont *)font;

/**
 创建frame为CGRectZero的label 后面自行layout约束
 */
+ (nullable UILabel *)lableWithText:(nullable NSString *)text textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font textAlignment:(NSTextAlignment)textAlignment;

+ (nullable UILabel *)lableWithText:(nullable NSString *)text textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font;

@end


#pragma mark - UIButton

@interface UIButton (Create)

+ (nonnull UIButton *)buttonWithFrame:(CGRect)frame target:(nullable id)target action:(nullable SEL)action title:(nullable NSString *)title font:(nullable UIFont *)font titleColor:(nullable UIColor *)titleColor bgImage:(nullable UIImage *)bgImage backColor:(nullable UIColor *)backColor tag:(NSInteger)tag;

+ (nonnull UIButton *)buttonWithFrame:(CGRect)frame target:(nullable id)target action:(nullable SEL)action title:(nullable NSString *)title font:(nullable UIFont *)font titleColor:(nullable UIColor *)titleColor bgImage:(nullable UIImage *)bgImage tag:(NSInteger)tag;

+ (nonnull UIButton *)buttonWithFrame:(CGRect)frame target:(nullable id)target action:(nullable SEL)action bgImage:(nullable UIImage *)bgImage;

+ (nonnull UIButton *)buttonWithFrame:(CGRect)frame target:(nullable id)target action:(nullable SEL)action bgImage:(nullable UIImage *)bgImage tag:(NSInteger)tag;

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor bgImage:(UIImage *)bgImage backColor:(UIColor *)backColor;

+ (nonnull UIButton *)buttonWithFrame:(CGRect)frame target:(nullable id)target action:(nullable SEL)action title:(nullable NSString *)title font:(nullable UIFont *)font titleColor:(nullable UIColor *)titleColor backColor:(nullable UIColor *)backColor tag:(NSInteger)tag;

@end


#pragma mark - UITextField

@interface UITextField (Create)

+ (nonnull UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(nullable NSString *)placeholder font:(nullable UIFont *)font textColor:(nullable UIColor *)textColor bgImage:(nullable UIImage *)bgImage;

@end

