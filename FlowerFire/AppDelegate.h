//
//  AppDelegate.h
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/4.
//  Copyright © 2019 Celery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(nonatomic, strong)UIWindow *window;

@property (nonatomic, assign) BOOL isEable;
/**
 USDT对人民币汇率
 */
@property (nonatomic, strong) NSDecimalNumber *CNYRate;
/**
 币币交易默认交易对
 */
@property (nonatomic, strong) NSString *displayName;
/**
 币币交易默认交易对ID
 */
@property (nonatomic, strong) NSString *marketId;

@end

