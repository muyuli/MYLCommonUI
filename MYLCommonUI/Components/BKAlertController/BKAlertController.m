//
//  BKAlertController.m
//  JFTransitionDemo
//
//  Created by James on 2017/7/21.
//  Copyright © 2017年 IJFT. All rights reserved.
//

#import "BKAlertController.h"
#import "BKAlertModalTransitionDelegate.h"

#define kAlertViewDefaultWidth 280
#define kCustomViewDefaultSize CGSizeMake(260, 240)
#define TAGDESCRIPTION         999

@interface BKAlertControllerModel : NSObject
@property (nonatomic,copy)  NSAttributedString *attributeStr;//富文本
@property (nonatomic,assign)CGFloat             height;//富文本高度
@property (nonatomic,assign)NSInteger           lines;//富文本行数
@end
@implementation BKAlertControllerModel
@end

@interface BKAlertAction ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) UIAlertActionStyle style;
@property (nonatomic, copy) void (^handler)(BKAlertAction *action);

@end

@implementation BKAlertAction

- (instancetype)initWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(BKAlertAction *action))handler {
    if (self = [super init]) {
        _title = title;
        _style = style;
        _handler = handler;
    }
    return self;
}

+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^)(BKAlertAction *action))handler {
    return [[BKAlertAction alloc] initWithTitle:title style:style handler:handler];
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    if (self.propertyEvent) {
        self.propertyEvent(self);
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    if (self.propertyEvent) {
        self.propertyEvent(self);
    }
}

@end

@interface BKAlertController () <UITextViewDelegate>

@property (nonatomic, strong) BKAlertModalTransitionDelegate *alertModalTransitionDelegate;
@property (nonatomic, copy)   NSString    *message;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UILabel     *messageLabel;
@property (nonatomic, strong) UIView      *customView;
@property (nonatomic, assign) CGFloat      alertViewWidth;           // 弹窗的宽度
@property (nonatomic, assign) CGFloat      titleViewHeight;          // 标题的高度
@property (nonatomic, assign) CGFloat      actionButtonHeight;       // 按钮的高度
@property (nonatomic, assign) CGFloat      contentHeight;            // 标题和按钮之间内容的高度
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets;        // 内容的边距
@property (nonatomic, assign) CGRect       customViewFrame;          // 自定义视图的frame
@property (nonatomic, strong) BKAlertControllerModel          *contentModel;
@property (nonatomic, strong) NSMutableArray<UIButton *>      *actionButtons;
@property (nonatomic, strong) NSMutableArray<BKAlertAction *> *privateActions;
@property (nonatomic, assign) UIDeviceOrientation              deviceOrientation;

@end

@implementation BKAlertController

#pragma mark - Life Cycle

- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message {
    if (self = [super init]) {
        self.title = title;
        _message = message;
        _alertViewWidth = kAlertViewDefaultWidth;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitioningDelegate = self.alertModalTransitionDelegate;
    }
    return self;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message deviceOrientation:(UIDeviceOrientation)deviceOrientation {
    BKAlertController *alertController = [[BKAlertController alloc] initWithTitle:title message:message];
    alertController.deviceOrientation = deviceOrientation;
    alertController.contentEdgeInsets = UIEdgeInsetsMake(15, 25, 25, 25);
    alertController.alertModalTransitionDelegate.presentedViewSize = [alertController sizeOfAlertView];
    return alertController;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message {
    BKAlertController *alertController = [[BKAlertController alloc] initWithTitle:title message:message];
    alertController.contentEdgeInsets = UIEdgeInsetsMake(15, 25, 25, 25);
    alertController.alertModalTransitionDelegate.presentedViewSize = [alertController sizeOfAlertView];
    return alertController;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredMaxHeight:(CGFloat)preferredMaxHeight {
    if (message.length == 0) {
        return [BKAlertController alertControllerWithTitle:title message:message];
    }
    
    UIFont *font = [UIFont ajkH3Font];
    UIColor *color = [UIColor brokerDarkGrayColor];
    CGFloat textViewWidth = kCustomViewDefaultSize.width;
    CGSize messageSize = [message boundingRectWithSize:CGSizeMake(textViewWidth, CGFLOAT_MAX)
                                               options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                            attributes:@{NSFontAttributeName:font}
                                               context:nil].size;
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, kCustomViewDefaultSize.width, messageSize.height > preferredMaxHeight ? preferredMaxHeight : messageSize.height)];
    textView.font = font;
    textView.textColor = color;
    textView.text = message;
    textView.textContainerInset = UIEdgeInsetsZero;
    
    BKAlertController *alertController = [BKAlertController alertControllerWithTitle:title customView:textView edgeInsets:UIEdgeInsetsMake(25, 25, 25, 25)];
    textView.delegate = alertController;    // 实现不可编辑，不可选择文本，不可复制和粘贴，但能滚动
    
    return alertController;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title customView:(UIView *)customView edgeInsets:(UIEdgeInsets)edgeInsets
{
    BKAlertController *alertController = [[BKAlertController alloc] initWithTitle:title message:nil];
    alertController.customView = customView;
    alertController.contentEdgeInsets = edgeInsets;
    if (CGSizeEqualToSize(customView.frame.size, CGSizeZero)) {
        alertController.customViewFrame = CGRectMake(customView.frame.origin.x, customView.frame.origin.y, kCustomViewDefaultSize.width, kCustomViewDefaultSize.height);
    } else {
        alertController.customViewFrame = customView.frame;
    }
    alertController.alertModalTransitionDelegate.presentedViewSize = [alertController sizeOfAlertView];
    return alertController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addPageSubviews];
}

#pragma mark - Event Response

- (void)actionButonResponse:(UIButton *)button {
    NSInteger index = button.tag - TAGDESCRIPTION;
    if (index < 0 || index >= self.privateActions.count) return;
    weakify(self);
    [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
        strongify(self);
        BKAlertAction *alertAction = self.privateActions[index];
        self.privateActions = nil;
        !alertAction.handler ?: alertAction.handler(alertAction);
    }];
}

#pragma mark - Public Method

- (void)addAction:(BKAlertAction *)action {
    if (!action) return;
    if (![action isKindOfClass:[BKAlertAction class]]) return;
    if ([self.actions containsObject:action]) return;
    
    [self.privateActions addObject:action];
    
    if (self.actionButtonHeight <= 0) {
        self.actionButtonHeight = 44;
        CGFloat oldHeight = self.alertModalTransitionDelegate.presentedViewSize.height;
        self.alertModalTransitionDelegate.presentedViewSize = CGSizeMake(self.alertViewWidth, oldHeight + self.actionButtonHeight);
    }
    
    // 当外面在addAction之后再设置action的属性时，会回调这个block
    weakify(self);
    action.propertyEvent = ^(BKAlertAction *action) {
        strongify(self);
        NSInteger tag  = [self.privateActions indexOfObject:action] + TAGDESCRIPTION;
        [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[UIButton class]] && obj.tag == tag) {
                UIButton *btn = (UIButton *)obj;
                if (action.titleColor != nil) {
                    [btn setTitleColor:action.titleColor forState:UIControlStateNormal];
                }
                if (action.titleFont != nil) {
                    btn.titleLabel.font = action.titleFont;
                }
                *stop = YES;
            }
        }];
    };
}

#pragma mark - Private Method

- (void)addPageSubviews {
    if (self.title.length > 0) {
        [self.view addSubview:self.titleLabel];
        [self.titleLabel sizeToFit];
        CGSize size = self.titleLabel.frame.size;
        self.titleLabel.frame = CGRectMake(0, self.titleViewHeight - size.height, self.alertViewWidth, size.height);
    }
    
    if (self.message.length > 0) {
        [self.view addSubview:self.messageLabel];
        self.messageLabel.frame = CGRectMake(self.contentEdgeInsets.left, self.titleViewHeight + self.contentEdgeInsets.top, self.alertViewWidth - self.contentEdgeInsets.left - self.contentEdgeInsets.right, self.contentHeight - self.contentEdgeInsets.top - self.contentEdgeInsets.bottom);
    } else if (self.customView) {
        [self.view addSubview:self.customView];
        self.customView.frame = CGRectMake(self.contentEdgeInsets.left, self.titleViewHeight + self.contentEdgeInsets.top, self.customViewFrame.size.width, self.customViewFrame.size.height);
    }
    
    CGFloat width = self.alertViewWidth / self.privateActions.count;
    CGFloat y = self.titleViewHeight + self.contentHeight;
    for (int index = 0; index < self.privateActions.count; index++) {
        BKAlertAction *alertAction = self.privateActions[index];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = index + TAGDESCRIPTION;
        button.frame = CGRectMake(index * width, y, width, self.actionButtonHeight);
        button.titleLabel.font = [UIFont ajkH2Font];
        [button setTitle:alertAction.title ?: @"" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(actionButonResponse:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:button];

        //
        if (self.privateActions.count == 1) {
            [button setTitleColor:[UIColor brokerOrangeColor] forState:UIControlStateNormal];
        } else {
            if (index == 0) {
                [button setTitleColor:[UIColor brokerMediumGrayColor] forState:UIControlStateNormal];
            } else {
                [button setTitleColor:[UIColor brokerOrangeColor] forState:UIControlStateNormal];
            }
        }
        
        CGFloat scaleDistance = 1 / UIScreen.mainScreen.scale;
        CGFloat lineX;
        CGFloat lineY;
        CGFloat lineWidth;
        CGFloat lineHeight;
        if (index == 0) {
            lineWidth = self.alertViewWidth;
            lineHeight = scaleDistance;
            lineX = 0;
            lineY = y - scaleDistance / 2;
        } else {
            lineWidth = scaleDistance;
            lineHeight = self.actionButtonHeight - scaleDistance / 2;
            lineX = button.frame.origin.x - scaleDistance / 2;
            lineY = y + scaleDistance / 2;
        }
        
        CALayer *lineLayer = [CALayer layer];
        lineLayer.frame = CGRectMake(lineX, lineY, lineWidth, lineHeight);
        lineLayer.backgroundColor = [UIColor brokerLineColor].CGColor;
        [self.view.layer addSublayer:lineLayer];
    }
    
    if (self.deviceOrientation == UIDeviceOrientationLandscapeLeft ||
        self.deviceOrientation == UIDeviceOrientationLandscapeRight) {
        [self.view setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    } else {
        [self.view setTransform:CGAffineTransformMakeRotation(0)];
    }
}

- (BOOL)isBlankString:(NSString *)string {
    return [string length] == 0;
}

- (CGSize)sizeOfAlertView {
    CGFloat height = 0;
    
    // title
    if (self.title.length > 0) {
        if ([self isBlankString:self.message] && !self.customView) {
            self.titleViewHeight = 37 + 17;
        } else {
            self.titleViewHeight = 44.5;
        }
    } else {
        self.titleViewHeight = 4;
    }
    height += self.titleViewHeight;
    
    // message
    if (self.message.length > 0) {
        _contentModel = [self paragrapStyleData:self.message font:self.messageLabel.font];

        if (_contentModel.lines > 1) {
            if ([self isBlankString:self.title]) {
                UIEdgeInsets inset = self.contentEdgeInsets;
                inset.top = 25;
                self.contentEdgeInsets = inset;
            }
            self.messageLabel.textAlignment = NSTextAlignmentLeft;
            self.messageLabel.attributedText = _contentModel.attributeStr;
        } else {
            if ([self isBlankString:self.title]) {
                UIEdgeInsets inset = self.contentEdgeInsets;
                inset.top = 37;
                inset.bottom = 37;
                self.contentEdgeInsets = inset;
            }
            self.messageLabel.textAlignment = NSTextAlignmentCenter;
            self.messageLabel.text = ![self isBlankString:self.message]?self.message:@"";
        }
        
        self.contentHeight = _contentModel.height + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
    } else if (self.customView) {
        self.contentHeight = self.customViewFrame.size.height + self.contentEdgeInsets.top + self.contentEdgeInsets.bottom;
        self.alertViewWidth = self.customViewFrame.size.width + self.contentEdgeInsets.left + self.contentEdgeInsets.right;
    } else {
        UIEdgeInsets inset = self.contentEdgeInsets;
        inset.top = 37;
        self.contentEdgeInsets = inset;
        self.contentHeight = self.contentEdgeInsets.top;
    }
    
    height += self.contentHeight;
    
    return CGSizeMake(self.alertViewWidth, height);
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return NO;
}

- (BKAlertControllerModel *)paragrapStyleData:(NSString *)title font:(UIFont *)font {
    BKAlertControllerModel *model = [BKAlertControllerModel new];
    if ([self isBlankString:title]) {
        model.attributeStr = [[NSMutableAttributedString alloc] init];
        model.height = 0;
        return model;
    }
    CGFloat lineSpacing = 10 - (font.lineHeight - font.pointSize);
    NSMutableParagraphStyle *parStyle = [self getParagraphStyle:lineSpacing alignment:NSTextAlignmentLeft];
    NSDictionary *dic = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:parStyle};
    CGSize size = [title boundingRectWithSize:CGSizeMake(_alertViewWidth - _contentEdgeInsets.left - _contentEdgeInsets.right, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    CGFloat height = size.height;
    CGFloat count = 0;
    if ((height-font.lineHeight) <= parStyle.lineSpacing) {
        count = 1;
        height = font.lineHeight;
        model.attributeStr = [[NSMutableAttributedString alloc] init];
    } else {
        count = 9; // 大于1的数即可
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:title];
        [text addAttribute:NSParagraphStyleAttributeName value:parStyle range:NSMakeRange(0,title.length)];
        [text addAttribute:NSFontAttributeName value:font range:NSMakeRange(0,title.length)];
        model.attributeStr = text;
    }
    model.height = height + 1;//1个长度的误差，因为在有些情况下，高度计算不准确
    model.lines  = count;
    return model;
}

- (NSMutableParagraphStyle *)getParagraphStyle:(CGFloat)lineSpacing alignment:(NSTextAlignment)alignment {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.lineSpacing = lineSpacing; //设置行间距
    return paraStyle;
}

#pragma mark - Getter and Setter

- (NSMutableArray<BKAlertAction *> *)privateActions {
    if (!_privateActions) {
        _privateActions = [NSMutableArray array];
    }
    return _privateActions;
}

- (BKAlertModalTransitionDelegate *)alertModalTransitionDelegate {
    if (!_alertModalTransitionDelegate) {
        _alertModalTransitionDelegate = [BKAlertModalTransitionDelegate new];
    }
    return _alertModalTransitionDelegate;
}

- (NSArray<BKAlertAction *> *)actions {
    return _privateActions.copy;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont ajkLargeH3Font];
        _titleLabel.textColor = [UIColor brokerBlackColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = self.title ?: @"";
    }
    return _titleLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [UILabel new];
        if (self.title.length == 0) {
            _messageLabel.font = [UIFont ajkLargeH3Font];
            _messageLabel.textColor = [UIColor brokerBlackColor];
        } else {
            _messageLabel.font = [UIFont ajkH3Font];
            _messageLabel.textColor = [UIColor brokerMediumGrayColor];
        }
        _messageLabel.numberOfLines = 0;
    }
    return _messageLabel;
}

@end
