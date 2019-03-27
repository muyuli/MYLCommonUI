//
//  BKPopActionItem.m
//  BKUIModule
//
//  Created by Muyuli on 2019/3/26.
//  Copyright © 2019年 Muyuli. All rights reserved.
//

#import "BKPopActionItem.h"

#define DefaultWidth ([[UIScreen mainScreen] bounds].size.width)

#define commonHeight 45

@interface BKPopActionItem () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UITextField *inputTextField;


@end

@implementation BKPopActionItem


#pragma mark   -- init

- (id)init
{
    return [self initWithFrame:CGRectMake(0, 0, DefaultWidth, commonHeight)];
}

- (id)initWithW:(NSInteger)offx
{
    return [self initWithFrame:CGRectMake(0, 0, DefaultWidth - offx * 2, commonHeight)];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        _itemHeight = commonHeight;
        _contentBorderSpace = 15;
        [self addSubview:self.titleLabel];
        [self addSubview:self.subTitleLabel];
    }
    return self;
}

+ (instancetype)actionItemWithW:(NSInteger)offx
{
    return [[[self class] alloc] initWithW:(NSInteger)offx];
}

+ (instancetype)actionItem
{
    return [[[self class] alloc] init];
}


#pragma mark -- status override

- (void)setItemHeight:(float)itemHeight
{
    _itemHeight = itemHeight;
    CGRect originFrame = self.frame;
    originFrame.size.height = itemHeight;
    self.frame = originFrame;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected){
        _titleLabel.textColor = [UIColor colorWithRed:255/255. green:135/255. blue:0 alpha:1];
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = title;
    self.titleLabel.frame = CGRectMake(_contentBorderSpace, 0, self.frame.size.width - _contentBorderSpace * 2, _itemHeight);
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
  
    self.subTitleLabel.text = subTitle;
    self.titleLabel.frame = CGRectMake(_contentBorderSpace, 0, self.frame.size.width-_contentBorderSpace*2, _itemHeight/2.);
    self.subTitleLabel.frame = CGRectMake(_contentBorderSpace, _itemHeight/2, self.titleLabel.frame.size.width, _itemHeight/2.);
    
}

- (void)setTitleFont:(CGFloat)titleFont
{
    self.titleLabel.font = [UIFont systemFontOfSize:titleFont];
}

- (void)setSupTitleFont:(CGFloat)supTitleFont
{
    self.subTitleLabel.font = [UIFont systemFontOfSize:supTitleFont];
}

#pragma mark -- override widgt getter method

- (UILabel *)titleLabel
{
    if (_titleLabel == nil)
    {
        _titleLabel = [[UILabel alloc] init];
     
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor colorWithRed:51/255. green:51/255. blue:51/255. alpha:1];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textAlignment = NSTextAlignmentCenter;

    }
    return _titleLabel;
}


- (UILabel *)subTitleLabel
{
    if (_subTitleLabel == nil)
    {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.backgroundColor = [UIColor clearColor];
        _subTitleLabel.textColor =  [UIColor colorWithRed:153/255. green:153/255. blue:153/255. alpha:1];
        _subTitleLabel.font = [UIFont systemFontOfSize:12];
        _subTitleLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    return _subTitleLabel;
}

- (UIImageView *)iconImageView
{
    if (_iconImageView == nil)
    {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.userInteractionEnabled = NO;
        [self addSubview:_iconImageView];
    }
    return _iconImageView;
}

// 有了inputtextField调整titlelabel的布局为默认布局
- (UITextField *)inputTextField
{
    if (_inputTextField == nil)
    {
        // 需要调整titleLabel的默认样式
        self.titleLabel.frame = CGRectMake(_contentBorderSpace, 0, self.frame.size.width - _contentBorderSpace*2 , _itemHeight/2.);
        self.titleLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight; // 避免宽度被拉伸
        
        _inputTextField = [[UITextField alloc] initWithFrame:
                           CGRectMake(_contentBorderSpace ,
                                      _itemHeight/2.,
                                      self.frame.size.width - _contentBorderSpace*2 ,
                                      _itemHeight/2.)];
        _inputTextField.backgroundColor = [UIColor clearColor];
        _inputTextField.delegate = self;
        [self addSubview:_inputTextField];
    }
    return _inputTextField;
}


#pragma mark -- UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}


@end
