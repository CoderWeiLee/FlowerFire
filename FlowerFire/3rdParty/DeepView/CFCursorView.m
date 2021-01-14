//
//  CFCursorView.m
//  CCLineChart
//
//  Created by ZM on 2018/9/14.
//  Copyright © 2018年 hexuren. All rights reserved.
//

#import "CFCursorView.h"

 
@implementation CFCursorView

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    NSString *priceString;
    NSString *volumeString;
    NSString *volumeAmountString;
    //精确位数都为0，说明是合约进来的，合约的小数位服务端已处理，手机不再处理
    if(self.priceScale == 0 && self.fromScale == 0 && self.toScale == 0){
        priceString = NSStringFormat(@"%@: %@ %@",LocalizationKey(@"cursorTip1"),[self.priceModel objectForKey:@"price"],self.priceCoinName) ;
        volumeString = [[self.selectModel objectForKey:@"total_surplus"] doubleValue] > 100000 ?  NSStringFormat(@"%@: %.2fK",LocalizationKey(@"cursorTip2"),[[self.selectModel objectForKey:@"total_surplus"] doubleValue] / 1000) : NSStringFormat(@"%@: %f",LocalizationKey(@"cursorTip2"),[[self.selectModel objectForKey:@"total_surplus"] doubleValue]);
        volumeString = [volumeString stringByAppendingString:@" "];
        volumeString = [volumeString stringByAppendingString:[self.symbol uppercaseString]];
        volumeAmountString = NSStringFormat(@"%@: %f %@",LocalizationKey(@"cursorTip3"),[[self.selectModel objectForKey:@"total_surplus"] doubleValue] * [[self.priceModel objectForKey:@"price"] doubleValue],self.priceCoinName);
    }else{
        priceString = [NSString stringWithFormat:@"%@: %@ %@",LocalizationKey(@"cursorTip1"),[self calculateWithRoundingMode:NSRoundPlain roundingValue:[[self.priceModel objectForKey:@"price"] doubleValue] afterPoint:self.priceScale],self.priceCoinName];
        volumeString = [[self.selectModel objectForKey:@"total_surplus"] doubleValue] > 100000 ? [NSString stringWithFormat:@"%@: %.2fK",LocalizationKey(@"cursorTip2"),[[self.selectModel objectForKey:@"total_surplus"] doubleValue]/1000] : [NSString stringWithFormat:@"%@: %@",LocalizationKey(@"cursorTip2"),[self calculateWithRoundingMode:NSRoundPlain roundingValue:[[self.selectModel objectForKey:@"total_surplus"] doubleValue] afterPoint:self.fromScale]];
        volumeString = [volumeString stringByAppendingString:@" "];
        volumeString = [volumeString stringByAppendingString:[self.symbol uppercaseString]];
        volumeAmountString = [NSString stringWithFormat:@"%@: %@ %@",LocalizationKey(@"cursorTip3"),[self calculateWithRoundingMode:NSRoundPlain roundingValue:[[self.selectModel objectForKey:@"total_surplus"] doubleValue] * [[self.priceModel objectForKey:@"price"] doubleValue] afterPoint:self.priceScale],self.priceCoinName];
    }
    
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:9],NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    CGSize priceSize = [self rectOfNSString:priceString attribute:attribute].size;
    CGSize volumeSize = [self rectOfNSString:volumeString attribute:attribute].size;
    CGSize volumeAmountSize = [self rectOfNSString:volumeAmountString attribute:attribute].size;
    
    CGFloat width = volumeSize.width>volumeAmountSize.width ? volumeSize.width + 10:volumeAmountSize.width + 10;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat radius = 10;
    
    CGFloat arcX = self.selectedPoint.x  > radius ? self.selectedPoint.x : radius;
    if (radius > self.selectedPoint.x ) {
        arcX = radius;
    }
    CGFloat arcY = self.selectedPoint.y > radius ? self.selectedPoint.y : radius;
    
    //画圆。
    CGContextAddArc(ctx, arcX, arcY, 10, 0, 4 * M_PI, 0);
    //    64,75,107  404B6B
    [[UIColor colorWithRed:64/255.0 green:75/255.0 blue:107/255.0 alpha:1] set];
    //填充(沿着矩形内围填充出指定大小的圆)
    CGContextFillPath(ctx);
    CGContextAddArc(ctx, arcX, arcY , 5, 0, 4 * M_PI, 0);
    CGContextSetLineWidth(ctx, 5);
    
    [[UIColor colorWithRed:123/255.0 green:154/255.0 blue:244/255.0 alpha:1] set];
    CGContextFillPath(ctx);
    
    // 画提示框
    CGContextSetStrokeColorWithColor(ctx,  [UIColor colorWithRed:38/255.0 green:43/255.0 blue:65/255.0 alpha:1].CGColor);
    CGContextSetLineWidth(ctx, 0.5);
    //    CGFloat originX = arcX - 120;
    CGFloat originX = rect.size.width/2 - width/2;
    //    CGFloat originY = arcY - radius;
    CGFloat originY = 10;
    
    if (originX < 0) {
        originX = 2*radius + self.selectedPoint.x ;
    }
    
    if (originY > (self.frame.size.height - 50)) {
        originY -= 75;
        
    }
    CGContextStrokeRect(ctx, CGRectMake(originX, originY, width, 70));
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRed:38/255.0 green:43/255.0 blue:65/255.0 alpha:1].CGColor);
    CGContextFillRect(ctx, CGRectMake(originX, originY, width, 70));
    
    CGFloat stringY = (50 - priceSize.height - volumeSize.height - 5)/2 + originY;
    //    CGFloat priceStringX = (150 - priceSize.width)/2 + originX;
    //    CGFloat volumeStringX = (150 - volumeSize.width)/2 + originX;
    //    CGFloat volumeAmountStringX = (150 - volumeAmountSize.width)/2 + originX;
    [priceString drawAtPoint:CGPointMake(originX+5 , stringY) withAttributes:attribute];
    [volumeString drawAtPoint:CGPointMake(originX+5, stringY + priceSize.height + 5) withAttributes:attribute];
    [volumeAmountString drawAtPoint:CGPointMake(originX+5, stringY + priceSize.height + volumeSize.height + 10) withAttributes:attribute];
}

- (UIColor *)colorWithHex:(UInt32)hex alpha:(CGFloat)alpha {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:alpha];
}

- (UIColor *)colorWithHex:(UInt32)hex {
    return [self colorWithHex:hex alpha:1.f];
}

- (CGRect)rectOfNSString:(NSString *)string attribute:(NSDictionary *)attribute {
    CGRect rect = [string boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                       options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                    attributes:attribute
                                       context:nil];
    return rect;
}


- (NSString *)calculateWithRoundingMode:(NSRoundingMode )roundingMode roundingValue:(double)roundingValue afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:roundingMode scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithDouble:roundingValue];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSMutableString * value = [NSMutableString stringWithFormat:@"%@",roundedOunces];
    //补0
    NSArray * array = [value componentsSeparatedByString:@"."];
    if (array.count>1) {
        NSString * str = array[1];
        if (str.length != position) {
            for (NSInteger i = str.length; i<position; i++) {
                [value appendString:@"0"];
            }
        }
    } else {
        if (position != 0) {
            [value appendString:@"."];
            for (NSInteger i = 0; i <position; i++) {
                [value appendString:@"0"];
            }
        }
    }
    return value;
}

@end
