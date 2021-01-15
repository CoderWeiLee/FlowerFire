//
//  WTMainRootViewController.m
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/6.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "WTMainRootViewController.h"
#import "MainTabBarController.h"
 
@interface WTMainRootViewController ()

@property(nonatomic, assign) BOOL darkMode;
@end

@implementation WTMainRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self createNewTabBar];
    self.navigationBar.hidden = YES;
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
    MainTabBarController *tabBarController = [[MainTabBarController alloc] initWithContext:context themeChange:self.darkMode]; 
    self.viewControllers = @[tabBarController];
    return tabBarController;
}

@end
