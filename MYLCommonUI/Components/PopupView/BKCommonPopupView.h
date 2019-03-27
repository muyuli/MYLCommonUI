//
//  BKCommonPopupView.h
//  BKUIModule
//
//  Created by Muyuli on 2019/3/26.
//  Copyright © 2019年 Muyuli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class BKCommonPopupModel;

typedef void (^SelectItemBlock)(NSInteger index);

@interface BKCommonPopupView : UIView

@property (nonatomic, copy) SelectItemBlock selectItemBlock;

+ (void)showCommonPopupView:(NSString *)title needCancleItem:(BOOL)isNeedCancleItem modelArray:(NSArray <BKCommonPopupModel*> *)modelArray selectItemBlock:(SelectItemBlock)block;

@end

NS_ASSUME_NONNULL_END


@interface BKCommonPopupModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic) CGFloat itemHeight;

@property (nonatomic) BOOL selected;

+ (BKCommonPopupModel *)initModelWithTitle:(NSString *)title subTitle:(nullable NSString *)subTitle itemHeight:(CGFloat)itemHeight selected:(BOOL)isSelected;


@end
