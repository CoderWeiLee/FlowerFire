//
//  AppDelegate+IntegratedBugly.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/25.
//  Copyright © 2019 王涛. All rights reserved.
//  集成腾讯bugly

#import "AppDelegate+IntegratedBugly.h"
//#import <Bugly/Bugly.h>

@implementation AppDelegate (IntegratedBugly)

-(void)startWithBugly{
//    BuglyConfig *config = [[BuglyConfig alloc] init];
//    
//    config.unexpectedTerminatingDetectionEnable = YES; //非正常退出事件记录开关，默认关闭
//    config.reportLogLevel = BuglyLogLevelWarn; //报告级别
//    //config.deviceIdentifier = [UIDevice currentDevice].identifierForVendor.UUIDString; //设备标识
//    config.blockMonitorEnable = YES; //开启卡顿监控
//    config.blockMonitorTimeout = 2; //卡顿监控判断间隔，单位为秒
//    //    config.delegate = self;
//    
//#if DEBUG
//    config.debugMode = YES; //SDK Debug信息开关, 默认关闭
//    config.channel = @"debug";
//#else
//    config.channel = @"release";
//#endif
//    
//    [Bugly startWithAppId:BUGLY_APPID
//#if DEBUG
//        developmentDevice:YES
//#endif
//                   config:config];
//    int userId = [[[UniversalViewMethod sharedInstance] getUserId] intValue];
//    if(userId != 0){
//        [Bugly setUserIdentifier:[[UniversalViewMethod sharedInstance] getUserId]];
//    }
}

@end
