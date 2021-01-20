//
//  AppDelegate.m
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/4.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "AppDelegate.h"
#import "WTMainRootViewController.h"
#import "TYFPSLabel.h"
#import "AppDelegate+LaunchAnimation.h"
#import <MagicalRecord/MagicalRecord.h> 
#import <GKNavigationBar/GKNavigationBar.h>
//交易小数点
CGFloat transactionDecimalPoint = 6;
@interface AppDelegate ()

@end

@implementation AppDelegate
 
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [self startLaunchAnimation];
    [self initTheme];
//    [self configureNavBar];
    
    [ChangeLanguage initUserLanguage];//初始化应用语言
    [ChangeLanguage setUserlanguage:[ChangeLanguage userLanguage]];
    
    [self initCoreData];
    
    [self initData];
    
    [self initIQkeyBoardManager];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds]; 
    self.window.rootViewController = [WTMainRootViewController new];
    [self.window makeKeyAndVisible];
 
    #if defined(DEBUG)||defined(_DEBUG)
   // [TYFPSLabel showInStutasBar];
    #endif
    
    if(@available(iOS 13.0,*)){ //代码关闭黑暗模式
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
     
 
    return YES;
}

//皮肤初始化
-(void)initTheme{
    [[SDThemeManager sharedInstance] setupThemeNameArray:@[WHITE_THEME, BLACK_THEME]];
    NSString *currentThemeName = [[NSUserDefaults standardUserDefaults] objectForKey:CURRENT_THEME];
    if([HelpManager isBlankString:currentThemeName]){ //默认白色主题
        [[SDThemeManager sharedInstance] changeTheme:WHITE_THEME];
    }else{
        [[SDThemeManager sharedInstance] changeTheme:currentThemeName];
    }
    [[UIApplication sharedApplication] theme_setStatusBarColor:THEME_TEXT_COLOR animated:YES];
}

//-(void)configureNavBar{
//    // 配置导航栏属性
//     [GKConfigure setupCustomConfigure:^(GKNavigationBarConfigure * _Nonnull configure) {
//         configure.gk_translationX = 15;
//         configure.gk_translationY = 20;
//         configure.gk_scaleX = 0.90;
//         configure.gk_scaleY = 0.92;
//         configure.gk_navItemRightSpace = OverAllLeft_OR_RightSpace;
//         configure.gk_navItemLeftSpace = 5;
//     }];
//}

  //默认数据
-(void)initData{
    self.CNYRate = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    self.displayName = @"";
    self.marketId = @"";
}

-(void)initCoreData{
    [MagicalRecord setupCoreDataStackWithStoreNamed:APP_NAME];
    [MagicalRecord setLoggingLevel:MagicalRecordLoggingLevelOff];
}

//屏幕旋转
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if(self.isEable) {
        return UIInterfaceOrientationMaskLandscape;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

  //IQKeyboardManager
-(void)initIQkeyBoardManager{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = YES;
}

@end
