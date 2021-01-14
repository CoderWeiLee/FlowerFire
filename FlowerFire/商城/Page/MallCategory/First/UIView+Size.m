

#import "UIView+Size.h"

@implementation UIView (Size)


- (void)setRTLFrame:(CGRect)frame width:(CGFloat)width
{
//    if ([ArGetUSERLanguage isEqualToString:@"ar"]) {
//        if (self.superview == nil) {
//            NSAssert(0, @"must invoke after have superView");
//        }
//        CGFloat x = width - frame.origin.x - frame.size.width;
//        frame.origin.x = x;
//    }else {
//
//    }
    self.frame = frame;
}

- (void)setRTLFrame:(CGRect)frame
{
    [self setRTLFrame:frame width:self.superview.frame.size.width];
}

- (void)resetFrameToFitRTL{
    [self setRTLFrame:self.frame];
}

- (CGFloat)asLeft {
    return self.frame.origin.x;
}

- (void)setAsLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)asTop {
    return self.frame.origin.y;
}

- (void)setAsTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)asRight {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setAsRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)asBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setAsBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)asCenterX {
    return self.center.x;
}

- (void)setAsCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)asCenterY {
    return self.center.y;
}

- (void)setAsCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)asWidth {
    return self.frame.size.width;
}

- (void)setAsWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)asHeight {
    return self.frame.size.height;
}

- (void)setAsHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)asOrigin {
    return self.frame.origin;
}

- (void)setAsOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)asSize {
    return self.frame.size;
}

- (void)setAsSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)asBoundsHeight
{
    return self.bounds.size.height;
}

- (CGFloat)asBoundsWidth
{
    return self.bounds.size.width;
}
@end
