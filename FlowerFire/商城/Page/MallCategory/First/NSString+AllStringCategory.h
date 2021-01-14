


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSString (AllStringCategory)
///颜色
-(UIColor *)colorWithHexString;



///计算文字高度
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
///计算文字的宽度
- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;
///计算文字的大小固定宽
- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
///计算文字的大小固定高
- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;
///计算文字的大小约束宽高
- (CGSize)sizeWithFont:(UIFont *)font constrainedToRectSize:(CGSize)size;

///计算文字的大小约束宽高 设置过长时候显示格式
- (CGSize)sizeWithFont:(UIFont *)font constrainedToRectSize:(CGSize)size lineBreakMode:(NSLineBreakMode)lineBreakMode;
///字符串反向
+ (NSString *)reverseString:(NSString *)strSrc;

/** 是否纯数字*/
- (BOOL)isPureNumber;

/** 是否纯字母*/
- (BOOL)isPureEnglish;
/** 是否纯特殊字符*/
-(BOOL)isAllCharacterString;
@end

NS_ASSUME_NONNULL_END
