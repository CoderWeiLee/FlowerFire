////
////  AppDelegate+IntegratedJpush.m
////  FireCoin
////
////  Created by 王涛 on 2019/7/6.
////  Copyright © 2019 王涛. All rights reserved.
////  集成jPush
//
//#import "AppDelegate+IntegratedJpush.h"
//
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
//
//
//@interface AppDelegate () <JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>
//
//@end
//
//@implementation AppDelegate (IntegratedJpush)
//
///**
// 初始化极光sdk
// */
//-(void)initJPushSDK:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
//    [self OpenPermission:application];
//    //初始化 APNs 代码
//    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
//    if (@available(iOS 12.0, *)) {
//        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
//    } else {
//        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
//    }
//
//    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//
//    //始化 JPush 代码
//    [JPUSHService setupWithOption:launchOptions appKey:JPUSH_APPKEY
//                          channel:@"Corporate signature" //渠道名 ： 企业签名
//                 apsForProduction:YES //生产证书
//            advertisingIdentifier:nil]; //IDFA
//}
//
///**
// 打开权限
// */
//-(void)OpenPermission:(UIApplication *)application{
//    //    注册远程通知服务
//    if (@available(iOS 10.0, *)) {
//        //iOS 10 later
//        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
//        //必须写代理，不然无法监听通知的接收与点击事件
//        center.delegate = self;
//        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
//            if (!error && granted) {
//                //用户点击允许
//                //                NSLog(@"注册成功");
//            }else{
//                //用户点击不允许
//                NSLog(@"注册失败");
//            }
//        }];
//
//        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
//        //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。注意UNNotificationSettings是只读对象哦，不能直接修改！
//        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
//            //            NSLog(@"========%@",settings);
//        }];
//    }else {
//        //iOS 8 - iOS 10系统
//        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
//        [application registerUserNotificationSettings:settings];
//    }
//
//}
//
////在 AppDelegate.m 实现该回调方法并添加回调方法中的代码
//- (void)application:(UIApplication *)application
//didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//
//    /// Required - 注册 DeviceToken
//    [JPUSHService registerDeviceToken:deviceToken];
//}
////注册 APNs 失败接口（可选）
//- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    //Optional
//    NSLog(@"注册 APNs 失败: %@", error);
//}
//
//#pragma mark- JPUSHRegisterDelegate
//// iOS 12 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification API_AVAILABLE(ios(10.0)){
//    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        //从通知界面直接进入应用
//    }else{
//        //从通知设置界面进入应用
//    }
//}
//
//// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)){
//    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有 Badge、Sound、Alert 三种类型可以选择设置
//}
//
//// iOS 10 Support
//- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler  API_AVAILABLE(ios(10.0)){
//    // Required
//    NSDictionary * userInfo = response.notification.request.content.userInfo;
//    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
//        [JPUSHService handleRemoteNotification:userInfo];
//    }
//    completionHandler();  // 系统要求执行这个方法
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
//
//    // Required, iOS 7 Support
//    [JPUSHService handleRemoteNotification:userInfo];
//    completionHandler(UIBackgroundFetchResultNewData);
//}
//
//- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
//
//    // Required, For systems with less than or equal to iOS 6
//    [JPUSHService handleRemoteNotification:userInfo];
//}
//
//#pragma clang diagnostic pop
//
//@end
