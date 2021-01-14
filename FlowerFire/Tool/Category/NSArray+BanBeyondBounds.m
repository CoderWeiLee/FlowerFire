//
//  NSArray+BanBeyondBounds.m
//  FireCoin
//
//  Created by 王涛 on 2019/8/15.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "NSArray+BanBeyondBounds.h"

@implementation NSArray (BanBeyondBounds)

/**
 *  防止数组越界
 */
- (id)objectAtIndexVerify:(NSUInteger)index{
    if (index < self.count) {
        return [self objectAtIndex:index];
    }else{
        return nil;
    }
}
/**
 *  防止数组越界
 */
- (id)objectAtIndexedSubscriptVerify:(NSUInteger)idx{
    if (idx < self.count) {
        return [self objectAtIndexedSubscript:idx];
    }else{
        return nil;
    }
}

@end
