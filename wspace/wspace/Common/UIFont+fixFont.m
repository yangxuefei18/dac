//
//  UIFont+fixFont.m
//  wspace
//
//  Created by 汉德 on 2019/2/15.
//  Copyright © 2019 wspace. All rights reserved.
//

#import "UIFont+fixFont.h"
#import <objc/runtime.h>
#import "Common.h"

@implementation UIFont (fixFont)


+ (void)load {
    // 获取替换后的类方法
    Method newMethod = class_getClassMethod([self class], @selector(adjustFont:));
    // 获取替换前的类方法
    Method method = class_getClassMethod([self class], @selector(systemFontOfSize:));
    // 然后交换类方法，交换两个方法的IMP指针，(IMP代表了方法的具体的实现）
    method_exchangeImplementations(newMethod, method);
}

+ (UIFont *)adjustFont:(CGFloat)fontSize {
    UIFont *newFont = nil;
    newFont = [UIFont adjustFont:fontSize * [UIScreen mainScreen].bounds.size.width/375];
    return newFont;
}

@end
