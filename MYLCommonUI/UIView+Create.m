//
//  UIView+Create.m
//  AnjukeBroker_New
//
//  Created by Muyuli on 2018/8/23.
//  Copyright © 2018年 MYL. All rights reserved.
//

#import "UIView+Create.h"

@implementation UIView (Create)

+ (UIView *)viewForColor:(UIColor *)color withFrame:(CGRect)frame
{
    UIView *view = [[self alloc] initWithFrame:frame];
    view.backgroundColor = color;
    return view;
}

- (UIView *)buildView:(CGRect)frame bgColor:(UIColor *)bgColor
{
    UIView *tempView = [[UIView alloc] initWithFrame:frame];
    tempView.backgroundColor = bgColor;
    [self addSubview:tempView];
    return tempView;
}

- (UILabel *)buildLabel:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font text:(NSString *)text
{
    return [self buildLabel:frame textColor:textColor font:font text:text textAlignment:NSTextAlignmentLeft];
}

- (UILabel *)buildLabel:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font text:(NSString *)text textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *templab = [[UILabel alloc] initWithFrame:frame];
    templab.backgroundColor = [UIColor clearColor];
    templab.textAlignment = textAlignment;
    templab.textColor = textColor;
    templab.font = font;
    templab.text = text;
    [self addSubview:templab];
    return templab;
}

- (UIButton *)buildButtonWithTitle:(NSString *)title frame:(CGRect)frame cornerRadius:(float)radius target:(id)obj action:(SEL)selector block:(void (^)(UIButton *btn))block
{
    UIButton *tempBtn = [[UIButton alloc ] init];
    tempBtn.frame = frame;
    tempBtn.backgroundColor = [UIColor clearColor];
    [tempBtn setTitle:title forState:UIControlStateNormal];
    tempBtn.layer.cornerRadius = radius;
    tempBtn.layer.masksToBounds = YES;
    [tempBtn addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tempBtn];
    if (block) {
        block(tempBtn);
    }
    return tempBtn;
}

- (UIButton *)buildButtonWithTitle:(NSString *)title frame:(CGRect)frame target:(id)obj action:(SEL)selector block:(void (^)(UIButton *btn))block
{
    UIButton *tempBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    tempBtn.frame = frame;
    tempBtn.backgroundColor = [UIColor clearColor];
    [tempBtn setTitle:title forState:UIControlStateNormal];
    [tempBtn addTarget:obj action:selector forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tempBtn];
    if (block) {
        block(tempBtn);
    }
    return tempBtn ;
}

- (UIImageView *)buildImage:(CGRect)frame image:(NSString *)imageName
{
    UIImageView *tempView = [[UIImageView alloc] initWithFrame:frame];
    tempView.backgroundColor = [UIColor clearColor];
    tempView.image = [UIImage imageNamed:imageName];
    [self addSubview:tempView];
    return tempView;
}

- (void)addTapTarget:(nullable id)target selector:(nullable SEL)selector
{
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
    tapGest.numberOfTapsRequired = 1;
    tapGest.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGest];
}


@end



#pragma mark - UILabel

@implementation UILabel (Create)

+ (UILabel *)creatLableWithTitleColor:(UIColor*)titleColor withFont:(UIFont *)font withFrame:(CGRect)frame
{
    return [[self class] labelWithFrame:frame text:@"" textColor:titleColor font:font backColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
}

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font backColor:(UIColor*)backColor textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [[self alloc] initWithFrame:frame];
    label.textAlignment = textAlignment;
    label.backgroundColor = [UIColor clearColor];
    
    if (text){
        label.text = text;
    }
    if(backColor){
        label.backgroundColor = backColor;
    }
    if(font){
        label.font = font;
    }
    if(textColor){
        label.textColor = textColor;
    }
    return label;
}

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font backColor:(UIColor*)backColor
{
    return [[self class] labelWithFrame:frame text:text textColor:textColor font:font backColor:backColor textAlignment:NSTextAlignmentCenter];
}

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font textAlignment:(NSTextAlignment)textAlignment;
{
    return [[self class] labelWithFrame:frame text:text textColor:textColor font:font backColor:[UIColor clearColor] textAlignment:textAlignment];
}

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font
{
    return [[self class] labelWithFrame:frame text:text textColor:textColor font:font backColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
}

+ (UILabel *)labelWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor
{
    return [[self class] labelWithFrame:frame text:text textColor:textColor font:nil backColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
}

+ (UILabel *)labelLeftAlignWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font
{
    return [[self class] labelWithFrame:frame text:text textColor:textColor font:font backColor:[UIColor clearColor] textAlignment:NSTextAlignmentLeft];
}

+ (nullable UILabel *)lableWithText:(NSString *)text textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font textAlignment:(NSTextAlignment)textAlignment
{
    return [[self class] labelWithFrame:CGRectZero text:text textColor:textColor font:font backColor:nil textAlignment:textAlignment];
}

+ (nullable UILabel *)lableWithText:(NSString *)text textColor:(nullable UIColor *)textColor font:(nullable UIFont *)font
{
    return [[self class] lableWithText:text textColor:textColor font:font textAlignment:NSTextAlignmentCenter];
}
+ (UILabel *)labelCenterAlignWithFrame:(CGRect)frame text:(NSString *)text textColor:(UIColor *)textColor font:(UIFont *)font
{
    return [[self class] labelWithFrame:frame text:text textColor:textColor font:font backColor:[UIColor clearColor] textAlignment:NSTextAlignmentCenter];
}
@end



#pragma mark - UIButton

@implementation UIButton  (Create)

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor bgImage:(UIImage *)bgImage backColor:(UIColor *)backColor tag:(NSInteger)tag
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    if (font){
        button.titleLabel.font = font;
    }
    if (titleColor){
        [button setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (bgImage){
        [button setBackgroundImage:bgImage forState:UIControlStateNormal];
    }
    if(backColor){
        [button setBackgroundColor:backColor];
    }
    [button setTag:tag];
    return button;
}

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor bgImage:(UIImage *)bgImage tag:(NSInteger)tag
{
    return [[self class] buttonWithFrame:frame target:target action:action title:title font:font titleColor:titleColor bgImage:bgImage backColor:[UIColor clearColor] tag:tag];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action title:(NSString *)title font:(UIFont *)font titleColor:(UIColor *)titleColor backColor:(UIColor *)backColor tag:(NSInteger)tag
{
    return [[self class] buttonWithFrame:frame target:target action:action title:title font:font titleColor:titleColor bgImage:nil backColor:backColor tag:tag];
}

+ (UIButton *)buttonWithFrame:(CGRect)frame target:(id)target action:(SEL)action bgImage:(UIImage *)bgImage tag:(NSInteger)tag
{
    return [[self class] buttonWithFrame:frame target:target action:action title:nil font:nil titleColor:nil bgImage:bgImage  backColor:[UIColor clearColor] tag:tag];
}

@end


#pragma mark - UITextField

@implementation UITextField (Create)

+ (nonnull UITextField *)textFieldWithFrame:(CGRect)frame placeholder:(nullable NSString *)placeholder font:(nullable UIFont *)font textColor:(nullable UIColor *)textColor bgImage:(nullable UIImage *)bgImage
{
    UITextField *textField = [[[self class] alloc] initWithFrame:frame];
    textField.placeholder = placeholder;
    if (font){
        textField.font = font;
    }
    if (textColor){
        textField.textColor = textColor;
    }
    if (bgImage){
        [textField setBackground:bgImage];
    }
    return textField;
}

@end
