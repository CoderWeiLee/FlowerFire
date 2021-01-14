//
//  NKColorSwitch.h
//  CustomUISwitch
//
//  Created by 赵群涛 on 16/5/5.
//  Copyright © 2016年 愚非愚余. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    kNKColorSwitchShapeOval,
    kNKColorSwitchShapeRectangle,
    kNKColorSwitchShapeRectangleNoCorner
} NKColorSwitchShape;

@interface ZQTColorSwitch : UIControl <UIGestureRecognizerDelegate>


@property (nonatomic, getter = isOn) BOOL on;

@property (nonatomic, assign) NKColorSwitchShape shape;


@property (nonatomic, strong) UIColor *onTintColor;


@property (nonatomic, strong) UIColor *tintColor;

@property (nonatomic, strong) UIColor *thumbTintColor;

@property (nonatomic, assign) BOOL shadow;

@property (nonatomic, strong) UIColor *tintBorderColor;

@property (nonatomic, strong) UIColor *onTintBorderColor;


@property (nonatomic, strong) UILabel *onBackLabel;//打开时候的文字
@property (nonatomic, strong) UILabel *offBackLabel;//关闭时候的文字

@end
