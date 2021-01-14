//
//  NSMutableArray+BanBeyondBounds.h
//  FireCoin
//
//  Created by 王涛 on 2019/8/15.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (BanBeyondBounds)

/**
 数组中插入数据
 
 @param object 数据
 @param index 下标
 */
- (void)insertObjectVerify:(id)object atIndex:(NSInteger)index;
/**
 数组中添加数据
 
 @param object 数据
 */
- (void)addObjectVerify:(id)object;

- (id)objectAtIndexVerify:(NSUInteger)index;
- (id)objectAtIndexedSubscriptVerify:(NSUInteger)idx;

@end

NS_ASSUME_NONNULL_END
