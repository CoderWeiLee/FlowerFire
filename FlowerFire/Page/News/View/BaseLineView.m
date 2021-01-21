//
//  BaseLineView.m
//  FlowerFire
//
//  Created by 李伟 on 2021/1/21.
//  Copyright © 2021 Celery. All rights reserved.
//

#import "BaseLineView.h"

@implementation BaseLineView
- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
   
    CGContextRef cont = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(cont, [UIColor colorWithHexString:@"#F0F0F0"].CGColor);
    // 设置线宽
    CGContextSetLineWidth(cont, 1);
    // lengths的值｛3,3｝表示先绘制3个点，再跳过3个点，如此反复
    CGFloat lengths[] = {3,1};
    CGContextSetLineDash(cont, 0, lengths, 2);  //画虚线
    CGContextBeginPath(cont);
    CGContextMoveToPoint(cont, rect.size.width * 0.5, 0);    //开始画线
    CGContextAddLineToPoint(cont, rect.size.width * 0.5, rect.size.height-1);
    CGContextStrokePath(cont);
}


@end
