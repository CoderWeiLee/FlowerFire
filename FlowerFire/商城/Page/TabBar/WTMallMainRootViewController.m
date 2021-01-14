//
//  WTMainRootViewController.m
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/6.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "WTMallMainRootViewController.h"
#import "MainMallTabBarController.h"
 
@interface WTMallMainRootViewController ()

@property(nonatomic, assign) BOOL darkMode;
@end

@implementation WTMallMainRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNewTabBar];
     
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(theme_didChanged) name:SDThemeChangedNotification object:nil];
}

/// 通知换肤
- (void)theme_didChanged{
    self.darkMode = !self.darkMode;
    [self createNewTabBar];
}

- (CYLTabBarController *)createNewTabBar {
     
    return [self createNewTabBarWithContext:nil];
}

- (CYLTabBarController *)createNewTabBarWithContext:(NSString *)context {
    MainMallTabBarController *tabBarController = [[MainMallTabBarController alloc] initWithContext:context themeChange:self.darkMode]; 
    self.viewControllers = @[tabBarController];
    return tabBarController;
}

@end
