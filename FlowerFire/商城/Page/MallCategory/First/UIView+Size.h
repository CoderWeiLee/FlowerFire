
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Size)

@property (nonatomic) CGFloat asLeft;

@property (nonatomic) CGFloat asTop;

@property (nonatomic) CGFloat asRight;

@property (nonatomic) CGFloat asBottom;

@property (nonatomic) CGFloat asWidth;

@property (nonatomic) CGFloat asHeight;

@property (nonatomic) CGFloat asCenterX;

@property (nonatomic) CGFloat asCenterY;

@property (nonatomic) CGPoint asOrigin;

@property (nonatomic) CGSize asSize;

@property (nonatomic, readonly) CGFloat asBoundsWidth;
@property (nonatomic, readonly) CGFloat asBoundsHeight;

///只有Ar状态下会修改，正常的使用不会修改
///通过父视图宽度适配RTL，滑动视图宽度超过父视图的
- (void)setRTLFrame:(CGRect)frame width:(CGFloat)width;
///通过自己的宽度来适配，直接给frame
- (void)setRTLFrame:(CGRect)frame;


///通过自己的宽度来适配,提前给frame
- (void)resetFrameToFitRTL;
@end

NS_ASSUME_NONNULL_END
