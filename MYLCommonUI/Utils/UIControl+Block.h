//
//  UIControl+Block.h
//  BKUIModule
//
//  Created by Muyuli on 2019/3/27.
//  Copyright © 2019年 Muyuli. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^ActionBlock)();


@interface UIControl (Block)

@property (readonly) NSMutableDictionary *event;

- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(ActionBlock)action;


@end

NS_ASSUME_NONNULL_END
