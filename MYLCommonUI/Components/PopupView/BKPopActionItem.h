//
//  BKPopActionItem.h
//  BKUIModule
//
//  Created by Muyuli on 2019/3/26.
//  Copyright © 2019年 Muyuli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BKPopActionItem : UIControl

@property (nonatomic) float itemHeight;

@property (nonatomic) CGFloat contentBorderSpace;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic) CGFloat titleFont;

@property (nonatomic) CGFloat subTitleFont;

+ (instancetype)actionItem;

+ (instancetype)actionItemWithW:(NSInteger)offx;

@end

NS_ASSUME_NONNULL_END
