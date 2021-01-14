//
//  UIImage+jianbianImage.h
//  aiyuanliaotian
//
//  Created by mac on 2018/12/23.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, GradientType) {
    
    GradientTypeTopToBottom = 0,//从上到小
    
    GradientTypeLeftToRight = 1,//从左到右
    
    GradientTypeUpleftToLowright = 2,//左上到右下
    
    GradientTypeUprightToLowleft = 3,//右上到左下
    
};

@interface UIImage(GradientColor)

+ (UIImage *)gradientColorImageFromColors:(NSArray*)colors gradientType:(GradientType)gradientType imgSize:(CGSize)imgSize;

@end

 
