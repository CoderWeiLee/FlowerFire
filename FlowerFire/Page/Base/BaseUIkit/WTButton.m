//
//  WTButton.m
//  CarcartUser
//
//  Created by 王涛 on 2020/7/7.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTButton.h"

@implementation WTButton

- (instancetype)initWithFrame:(CGRect)frame buttonImage:(UIImage *)buttonImage parentView:(UIView *)parentView{
    return [self initWithFrame:frame titleStr:nil titleFont:nil titleColor:nil buttonImage:buttonImage parentView:parentView];
}

- (instancetype)initWithFrame:(CGRect)frame buttonImage:(UIImage *)buttonImage selectedImage:(UIImage *)selectedImage parentView:(UIView *)parentView{
    [self setImage:selectedImage forState:UIControlStateSelected];
    return [self initWithFrame:frame titleStr:nil titleFont:nil titleColor:nil buttonImage:buttonImage parentView:parentView];
}

- (instancetype)initWithFrame:(CGRect)frame titleStr:(NSString *)titleStr titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor buttonImage:(UIImage *)buttonImage selectedImage:(UIImage *)selectedImage parentView:(UIView *)parentView{
    [self setImage:selectedImage forState:UIControlStateSelected];
    return [self initWithFrame:frame titleStr:titleStr titleFont:titleFont titleColor:titleColor buttonImage:buttonImage parentView:parentView];
}

- (instancetype)initWithFrame:(CGRect)frame titleStr:(NSString *)titleStr titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor parentView:(UIView *)parentView{
    return [self initWithFrame:frame titleStr:titleStr titleFont:titleFont titleColor:titleColor buttonImage:nil parentView:parentView];
}

- (instancetype)initWithFrame:(CGRect)frame titleStr:(NSString *)titleStr titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor buttonImage:(UIImage *)buttonImage parentView:(UIView *)parentView{
    self = [super initWithFrame:frame];
    if(self){
        [self setTitle:titleStr forState:UIControlStateNormal];
        [self.titleLabel setFont:titleFont];
        [self setTitleColor:titleColor forState:UIControlStateNormal];
        [self setImage:buttonImage forState:UIControlStateNormal];
        if(parentView){
            [parentView addSubview:self];
        }
    }
    return self;
}

@end
