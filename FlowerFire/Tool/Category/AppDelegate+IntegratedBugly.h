//
//  AppDelegate+IntegratedBugly.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/25.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (IntegratedBugly)

/**
 开始异常统计
 */
-(void)startWithBugly;

@end

NS_ASSUME_NONNULL_END
