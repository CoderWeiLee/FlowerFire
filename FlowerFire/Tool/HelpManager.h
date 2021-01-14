//
//  HelpManager.h
//  tongchengqiuou
//
//  Created by 1 on 17/11/17.
//  Copyright © 2017年 com.hengzhong. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
 

@interface HelpManager : NSObject

//单例模式
+ (instancetype)sharedHelpManager;
 
// 16进制颜色
+ (UIColor *) stringTOColor:(NSString *)str;
// 图标模糊处理
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur;
/**
 * 压缩图片暂时方案
 */
- (NSData *)imageWithImageSimple:(UIImage*)scaledImage;

// 特殊字符处理
+(NSString *)removeUnescapedCharacter:(NSString *)inputStr;


/**
 根据文字个数算宽度
 
 */
+(CGSize )getLabelWidth:(CGFloat)labelFont labelTxt:(NSString *)labelTxt;

/**
 根据文字个数算高度

 @param font 文字font
 @param text 文字内容
 @param textWidth 文本宽度
 @return 高度
 */
+(float)getMultiLineWithFont:(NSInteger)font andText:(NSString *)text textWidth:(float)textWidth;


-(void)netWorkStateCheck;
+ (NSString *) compareCurrentTime:(NSString *)str;

+(void)Share;


//聊天显示日期
-(NSString *)time_format:(NSString *) time;

//当前系统时间
-(NSString *)getSystemTime;

/**
 将当前时间与指定时间进行对比

 @param oneDay 当前时间
 @param anotherDay 指定时间
 @return
 ①如果result == NSOrderedDescending，说明当前时间大于指定时间
 ②如果result == NSOrderedAscending，说明当前时间小于指定时间
 ③如果以上两种都不是，说明当前时间与指定时间相同
 */
-(int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay;

/**
 是否是空字符串
 
 */
+(BOOL) isBlankString:(NSString *)string;

+(NSArray *)getRunTimeClassProperty:(Class) getClass;

- (UIViewController*)viewController:(UIView *)view;

/**
  获取当前时间戳  （以毫秒为单位）

 */
+(NSString *)getNowTimeTimestamp;

/**
 根据传入的毫秒转成格式化时间
 
 @param paramsTime 毫秒字符串
 @param dataFormat 123
 @return 格式化时间
 
 */
+(NSString *)getTimeStr:(NSString *)paramsTime dataFormat:(NSString *)dataFormat;

/**
 传入字符串时间转为毫秒

 @param time 字符串时间
 @param formatStr 转化格式
 @return 毫秒
 */
+ (long long)getTimeTimestampStr:(NSString*)time FormatStr:(NSString *)formatStr;
/**
 切部分圆角
 
 UIRectCorner有五种
 UIRectCornerTopLeft //上左
 UIRectCornerTopRight //上右
 UIRectCornerBottomLeft // 下左
 UIRectCornerBottomRight // 下右
 UIRectCornerAllCorners // 全部
 
 @param cornerRadius 圆角半径
 */
- (void)setPartRoundWithView:(UIView *)view corners:(UIRectCorner)corners cornerRadius:(float)cornerRadius;

/**
 图片合成文字
 @param text            文字
 @param fontSize        字体大小
 @param textColor       字体颜色
 @param textFrame       字体位置
 @param image           原始图片
 @param viewFrame       图片所在View的位置
 @return UIImage *
 */
+ (UIImage *)imageWithText:(NSString *)text
                  textFont:(NSInteger)fontSize
                 textColor:(UIColor *)textColor
                 textFrame:(CGRect)textFrame
               originImage:(UIImage *)image
    imageLocationViewFrame:(CGRect)viewFrame;


-(void)jianbianMainColor:(UIView *)view size:(CGSize)size;

/// 发送验证码
/// @param sendBtn 发送的按钮
-(void)sendVerificationCode:(UIButton *)sendBtn;

/// 复制到剪贴板
/// @param stirng 复制的字符串
+(void)copyStringOnPasteboard:(NSString *)stirng;
 
@end


