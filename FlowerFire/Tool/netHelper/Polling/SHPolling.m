//
//  Observer.m
//  dd
//
//  Created by ssyzh  on 2017/5/8.
//  Copyright © 2017年 TongFangCloud . All rights reserved.
//

#import "SHPolling.h"

#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);

@interface SHPolling ()
{
    dispatch_semaphore_t _lock;
}
@property(nonatomic,assign)SHPollingStatus currentOrder;
@property(nonatomic,assign)SHPollingStatus nextStatus;
@property(nonatomic,assign)NSTimeInterval interval;
@property(nonatomic,assign)NSTimeInterval nowTimeInterval;
@end
@implementation SHPolling{

}

+ (instancetype)pollingWithInterval:(NSTimeInterval)interval block:(void (^)(SHPolling *observer,SHPollingStatus pollingStatus))block {
    return [[SHPolling alloc] initPollingWithIntervalWithInterval:interval block:block];
}

- (instancetype)initPollingWithIntervalWithInterval:(NSTimeInterval)interval block:(void (^)(SHPolling *observer,SHPollingStatus pollingStatus))block {
    self = [super init];
    if (self) {
        _interval = interval;
        self.block = block;
        self.currentOrder = SHPollingPause;
        self.nextStatus = SHPollingPause;
        _lock = dispatch_semaphore_create(1);
    }
    return self;
}

- (BOOL)runing {
    return self.currentOrder == SHPollingStart && self.currentOrder == SHPollingStart;
}

- (instancetype)start {
    self.currentOrder = SHPollingStart;
    if (self.nextStatus != SHPollingStart) {
        self.nextStatus = SHPollingStart;
        [self next:SHPollingStart];
    }
    return self;
}

- (instancetype)pause {
    self.currentOrder = SHPollingPause;
    return self;
}
- (instancetype)callBlock {
    [self next:SHPollingCallBlock];
    return self;
}
- (instancetype)next:(SHPollingStatus)pollingStatus {
    switch (pollingStatus) {
        case SHPollingStart:
        {
            
            if (self.currentOrder == SHPollingStart) {
                NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
                if (self.nowTimeInterval != 0) {
                    if (now - self.nowTimeInterval >= 3) {
                        self.nowTimeInterval = now;
                        [self nextCall:pollingStatus];
                    }else{
                        [self afterNextCall:self.interval - (now - self.nowTimeInterval) :pollingStatus];
                    }
                }else{
                    [self afterNextCall:self.interval : pollingStatus];
                }
                self.nextStatus = SHPollingStart;
            }else{
                self.nextStatus = SHPollingPause;
            }
        }
            break;
        case SHPollingPause:
        {
            self.nextStatus = SHPollingPause;
        }
            break;
        case SHPollingCallBlock:
        {
            [self nextCall:SHPollingPause];
        }
            break;
            
        default:
            break;
    }
    return self;
}

- (void)nextCall:(SHPollingStatus)pollingStatus{
    dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER);
    typeof(self) __weak wSelf = self;
    if (self.block) {
        typeof(self) __strong sSelf = wSelf;
        sSelf.block(sSelf,pollingStatus);
    }
    dispatch_semaphore_signal(_lock);
}
- (void)afterNextCall:(NSTimeInterval)after :(SHPollingStatus)pollingStatus{
    typeof(self) __weak wSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(after * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        typeof(self) __strong sSelf = wSelf;
        sSelf.nowTimeInterval = [[NSDate date] timeIntervalSince1970];
        [sSelf nextCall:pollingStatus];
    });
}
- (NSTimeInterval)nowTimeInterval {
    LOCK(NSTimeInterval t = _nowTimeInterval) return t;
}


/**
 start  self.repetNum 和 next:(RepetData)repetData.num     归0 重新计数    next:(RepetData)repetData.status  为 YES  表示下次要轮询
 pause  self.pasueNext  为NO  不让在调用block  直接return
 callBlock   self.repetNum 保持和 next:(RepetData)repetData.num 一致   next:(RepetData)repetData.status  为 NO  表示下次要轮询
 
 
 
 next:(RepetData)repetData.status
 callBlock   status 为NO 说明这次nex产生的回调不会进行下一次的nex回调     而star 产生的status为YES  已经传出去了，轮询成功之后又传回来供下次nex判断使用
 
 
 */
@end
