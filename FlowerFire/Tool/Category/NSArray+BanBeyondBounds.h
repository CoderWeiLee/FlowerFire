//
//  NSArray+BanBeyondBounds.h
//  FireCoin
//
//  Created by 王涛 on 2019/8/15.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (BanBeyondBounds)

/**
 为数组分类添加的方法  可以在应用中直接调用 可以防止数组越界导致的crash
 
 @param index 传入的取值下标
 @return id类型的数据
 */
- (id)objectAtIndexVerify:(NSUInteger)index;
- (id)objectAtIndexedSubscriptVerify:(NSUInteger)idx;

@end

NS_ASSUME_NONNULL_END
