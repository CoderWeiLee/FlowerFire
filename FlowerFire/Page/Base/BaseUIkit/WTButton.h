//
//  WTButton.h
//  CarcartUser
//
//  Created by 王涛 on 2020/7/7.
//  Copyright © 2020 Celery. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTButton : UIButton

-(instancetype)initWithFrame:(CGRect)frame 
                buttonImage:(UIImage * _Nullable)buttonImage
                  parentView:(UIView * _Nullable)parentView;

-(instancetype)initWithFrame:(CGRect)frame
                buttonImage:(UIImage * _Nullable)buttonImage
               selectedImage:(UIImage * _Nullable)selectedImage
                  parentView:(UIView * _Nullable)parentView;

- (instancetype)initWithFrame:(CGRect)frame titleStr:(NSString *)titleStr titleFont:(UIFont *)titleFont titleColor:(UIColor *)titleColor buttonImage:(UIImage *)buttonImage selectedImage:(UIImage *)selectedImage parentView:(UIView *)parentView;

-(instancetype)initWithFrame:(CGRect)frame
                    titleStr:(NSString *)titleStr
                   titleFont:(UIFont *)titleFont
                titleColor:(UIColor *)titleColor
                  parentView:(UIView * _Nullable)parentView;

-(instancetype)initWithFrame:(CGRect)frame
                    titleStr:(NSString *_Nullable)titleStr
                   titleFont:(UIFont *_Nullable)titleFont
                titleColor:(UIColor *_Nullable)titleColor
                buttonImage:(UIImage * _Nullable)buttonImage
                  parentView:(UIView * _Nullable)parentView;

@end

NS_ASSUME_NONNULL_END
