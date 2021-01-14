//
//  PYHandleDate.h
//  Prome
//
//  Created by 李鹏跃 on 17/2/14.
//  Copyright © 2017年 品一. All rights reserved.
//

#import <Foundation/Foundation.h>

/**枚举，表示返回的是早或晚些的时间*/
typedef enum : NSUInteger {
    PYHandleCompareType_returnLittle,//返回较晚时间
    PYHandleCompareType_returnLong,//返回较早时间
} PYHandleCompareType;



@interface PYHandleDate : NSObject

//单利
+ (instancetype) sharedHandleDate;

 
/**
 * 关于时间与当前时间 比较早晚 的方法
 * date_OBJ : 传入一个字符串或者时间对象
 */
- (BOOL)isLateCurrentDateWithDate: (NSObject *)date_OBJ andDateForMatter: (NSString *)dateForMatter;



/**
 * 传入一个对象 获取对应的时间
 * date 对象（将被转化成时间对象）
 * dateFormatter 时间格式
 * dateBlock 转化成时间后的年月日
 */
#pragma mark - 获取时间的年月日
- (void)getDate: (NSObject *)getDate andDateFormatter: (NSString *)dateFormatter andDateBlock: (void(^)(NSInteger year, NSInteger month, NSInteger day, NSInteger hour,NSInteger minute, NSInteger second))dateBlock;



/**
 * 关于对象转化成对象的方法
 * date_OBJ: 一个对象
 * 如果 转化失败，那么返回nil，并打印无法转化
 */
- (NSDate *)returnDateWithOBJ: (NSObject *)date_OBJ andDateFormatter: (NSString *)dateFormatterStr;



/**
 * 关于两个时间差的方法
 * CompareDate: 比较的 第一个时间
 * forcedCompareDate: 比较的第二个时间
 * block返回的是第一个时间 减去第二个时间
 * 返回值是 差的时间；
 */
#pragma mark - 两个时间相比的差值
- (NSString *)compareDateWithandDateFormatter: (NSString *)dateFormatterStr andCompareDate: (NSObject *)startTime andSecondCompareDate: (NSString *)endTime andDateBlock: (void(^)(NSInteger year, NSInteger month, NSInteger day, NSInteger hour,NSInteger minute, NSInteger second))dateBlock;

/**
 开始到结束的时间差

 @param startTime 开始时间
 @param endTime 结束时间
 @param dateFormatter 转化格式
 @return 时间差
 */
- (NSString *)compareDateGapWithCompareDate: (NSObject *)startTime andSecondCompareDate: (NSObject *)endTime andDateFormatter: (NSString *)dateFormatter;

/**
 获取当前时间戳  （以毫秒为单位）
 
 */
-(NSString *)getNowTimeTimestamp;

-(long)getNowTimeStamp;


/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineStr : 截止时间
 *  @return 时间戳差值
 */
- (NSInteger)getDateDifferenceWithNowDateStr:(NSString*)nowDateStr deadlineStr:(NSString*)deadlineStr;
@end
