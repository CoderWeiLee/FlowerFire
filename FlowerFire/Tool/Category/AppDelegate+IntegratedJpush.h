//
//  AppDelegate+IntegratedJpush.h
//  FireCoin
//
//  Created by 王涛 on 2019/7/6.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (IntegratedJpush)

-(void)initJPushSDK:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END
