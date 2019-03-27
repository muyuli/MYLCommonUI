//
//  UIControl+Block.m
//  BKUIModule
//
//  Created by Muyuli on 2019/3/27.
//  Copyright © 2019年 Muyuli. All rights reserved.
//

#import "UIControl+Block.h"
#import <objc/runtime.h>

static char overviewKey;



@implementation UIControl (Block)
@dynamic event;

- (void)handleControlEvent:(UIControlEvents)event withBlock:(ActionBlock)block {
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}


- (void)callActionBlock:(id)sender {
    ActionBlock block = (ActionBlock)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}
@end
