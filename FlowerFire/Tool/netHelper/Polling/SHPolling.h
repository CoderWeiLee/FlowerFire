//
//  Observer.h
//  dd
//
//  Created by ssyzh  on 2017/5/8.
//  Copyright © 2017年 TongFangCloud . All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, SHPollingStatus)
{
    SHPollingStart = 0,
    SHPollingPause,
    SHPollingCallBlock,
};
@interface SHPolling : NSObject

/**
 当前执行的代码块 [observer next:repet]; 必须传入repet 参数不可更改
 */
@property (nonatomic, copy) void (^block)(SHPolling *observer,SHPollingStatus pollingStatus);

/**
 当前是否在运行中
 */
@property (nonatomic, readonly) BOOL runing;
@property (nonatomic, strong) id userData;//随意存放任何数据在 observer 对象中
/**
 启动 影响 runing  多次start，不影响轮询，维持第一次start状态
 */
- (instancetype)start;

/**
 暂停 影响 runing
 */
- (instancetype)pause;

/**
 继续执行下一次 轮询成功或者失败调用 必须传入repet 参数不可更改

 @param pollingStatus 传入block返回的repet
 */

- (instancetype)next:(SHPollingStatus)pollingStatus;

/**
 手动执行一次代码块 runing不受影响
  */
- (instancetype)callBlock;


/**
 创建一个轮询 需要调用 start 方法来启动

 @param interval 指定时间间隔, 单位：秒
 @param block 注意回调方法不一定是主线程
 @return 需要维持全局属性
 */
+ (instancetype)pollingWithInterval:(NSTimeInterval)interval block:(void (^)(SHPolling *observer,SHPollingStatus pollingStatus))block;
@end
