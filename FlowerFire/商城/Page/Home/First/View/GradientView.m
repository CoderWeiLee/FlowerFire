//
//  GradientView.m
//  531Mall
//
//  Created by 王涛 on 2020/5/18.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "GradientView.h"

@implementation GradientView

- (instancetype)initWithFrame:(CGRect)frame gradientColorImageFromColors:(NSArray *)colors gradientType:(GradientType)gradientType{
    self = [super initWithFrame:frame];
    if(self ){
        self.image = [UIImage gradientColorImageFromColors:colors gradientType:gradientType imgSize:frame.size];
    }
    return self;
}
 
- (void)setGradientColorImageFromColors:(NSArray *)colors gradientType:(GradientType)gradientType{
    self.image = [UIImage gradientColorImageFromColors:colors gradientType:gradientType imgSize:self.bounds.size];
}


@end
