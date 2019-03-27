//
//  BKCommonPopupView.m
//  BKUIModule
//
//  Created by Muyuli on 2019/3/26.
//  Copyright © 2019年 Muyuli. All rights reserved.
//

#import "BKCommonPopupView.h"
#import "BKCustomViewPopupManager.h"
#import "BKPopActionItem.h"
#import "UIControl+Block.h"

#define DefaultPopupViewWidth ([[UIScreen mainScreen] bounds].size.width)

@interface BKCommonPopupView ()

@property (nonatomic, strong) BKCustomViewPopupManager *popupViewManager;

@end


@implementation BKCommonPopupView

+ (void)showCommonPopupView:(NSString *)title needCancleItem:(BOOL)isNeedCancleItem modelArray:(NSArray <BKCommonPopupModel*> *)modelArray selectItemBlock:(SelectItemBlock)block
{
    if (modelArray.count > 0) {
        BKCommonPopupView *popupView = [[BKCommonPopupView alloc] initWithFrame:CGRectMake(0, 0, DefaultPopupViewWidth, 100)];
        popupView.backgroundColor = [UIColor redColor];
        CGFloat totalHeightY = 0;
        if (title.length) {
            
            BKPopActionItem *item = [[BKPopActionItem alloc] init];
            item.itemHeight = 45;
            item.titleFont = 18;
            item.title = title;
            item.selected = NO;
            [popupView addSubview:item];
            item.frame = CGRectMake(0, 0, DefaultPopupViewWidth, 45);
            totalHeightY += 45;
            [popupView createLine:CGRectMake(15, totalHeightY-1, DefaultPopupViewWidth-30, 1) inView:popupView];
        }
        for (BKCommonPopupModel *model in modelArray) {
            if ([model isKindOfClass:[BKCommonPopupModel class]]) {
                
                BKPopActionItem *item = [[BKPopActionItem alloc] init];
                item.itemHeight = model.itemHeight;
                item.titleFont = 15;
                item.title = model.title;
    
                if (model.subTitle.length) {
                    item.subTitle = model.subTitle;
                }
                
                item.selected = model.selected;
                [popupView addSubview:item];
                
                [item handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                    
                    NSInteger index = [modelArray indexOfObject:model];
                    
                    if (block) {
                        block(index);
                    }
                    [popupView.popupViewManager dismissView];
                }];
                
                item.frame = CGRectMake(0, totalHeightY, DefaultPopupViewWidth, model.itemHeight);
                totalHeightY += model.itemHeight;
                
                [popupView createLine:CGRectMake(15, totalHeightY-1, DefaultPopupViewWidth-30, 1) inView:popupView];
            }
        }
        
        if (isNeedCancleItem) {

            [popupView createLine:CGRectMake(0, totalHeightY, DefaultPopupViewWidth, 5) inView:popupView];
        
            totalHeightY = totalHeightY + 5;
            
            BKPopActionItem *item = [[BKPopActionItem alloc] init];
            item.itemHeight = 45;
            item.titleFont = 18;
            item.title = @"取消";
            [popupView addSubview:item];
            [item handleControlEvent:UIControlEventTouchUpInside withBlock:^{
                [popupView.popupViewManager dismissView];
            }];
            item.frame = CGRectMake(0, totalHeightY, DefaultPopupViewWidth, 45);
            totalHeightY += 45;
        }
        popupView.frame = CGRectMake(0, 0, DefaultPopupViewWidth, totalHeightY);
        
        popupView.popupViewManager = (BKCustomViewPopupManager *)[BKCustomViewPopupManager showPopupView:popupView bolShowNav:NO bgcolor:[UIColor blackColor] bgAlpha:0.5 offseth:40 bolHaveBgEvent:YES alertVertical:CustomPopupVerticalBottom inView:nil];
    }
}

- (void)createLine:(CGRect )frame inView:(UIView *)supView
{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = [UIColor colorWithRed:215/255. green:215/255. blue:215/255. alpha:1];
    [supView addSubview:line];
}


@end

@implementation BKCommonPopupModel


+ (BKCommonPopupModel *)initModelWithTitle:(NSString *)title subTitle:(nullable NSString *)subTitle itemHeight:(CGFloat)itemHeight selected:(BOOL)isSelected
{
    BKCommonPopupModel *popupModel = [[BKCommonPopupModel alloc] init];
    
    popupModel.title = title;
    popupModel.subTitle = subTitle;
    popupModel.itemHeight = itemHeight;
    popupModel.selected = isSelected;
    
    return popupModel;
}

@end
