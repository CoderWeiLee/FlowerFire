//
//  UIFont+AdaptiveFont.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/12.
//  Copyright © 2019 王涛. All rights reserved.
//  自适应字体大小

/**
 4/4s
 320*480 pt
 
 5/5S/5c/SE
 320*568 pt
 
 6/6S/7/8
 375*667 pt
 
 6+/6S+/7+/8+
 414*736 pt

 X
 375*812 pt
 
 XS
 375*812 pt
 
 XS Max
 414*896 pt

 XR
 414*896 pt

 */
#define MyUIScreen  375 // UI设计原型图的手机尺寸宽度(X), 6p的--414
#import "UIFont+AdaptiveFont.h"

@implementation UIFont (AdaptiveFont)

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
    //如果横屏了
    if([UIScreen mainScreen].bounds.size.width > 500){
        newFont = [UIFont adjustFont:fontSize + 2]; //
    }else{
        newFont = [UIFont adjustFont:fontSize + 2];//* [UIScreen mainScreen].bounds.size.width/MyUIScreen];
    }
   
    return newFont;
}

@end
