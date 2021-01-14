//
//  WTBacView.m
//  CarcartUser
//
//  Created by 王涛 on 2020/7/13.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTBacView.h"

@implementation WTBacView

- (instancetype)initWithFrame:(CGRect)frame backGroundColor:(nonnull UIColor *)backgroundColor parentView:(  UIView * _Nullable)parentView
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = backgroundColor;
        if(parentView){
            [parentView addSubview:self];
        }
    }
    return self;
}

@end
