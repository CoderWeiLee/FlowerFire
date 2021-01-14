//
//  WTPageRouterManager.h
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/5.
//  Copyright © 2019 Celery. All rights reserved.
//  页面路由管理

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTPageRouterManager : NSObject

+ (instancetype)sharedInstance;

/// 跳转登陆页面
/// @param currentVC 当前控制器
/// @param isModalMode YES 模态 NO 推入
/// @param whatProject 0SD1商城
-(void)jumpLoginViewController:(UIViewController *)currentVC
                      isModalMode:(BOOL)isModalMode
                   whatProject:(NSInteger)whatProject;

/// 跳转tabBar页面
/// @param selectedIndex 索引从0开始 要选中的tabbar页面
-(void)jumpTabBarController:(NSInteger)selectedIndex;
-(void)jumpMallTabBarController:(NSInteger)selectedIndex;

/// 跳转网页
/// @param urlString 网页url
/// @param currentViewController 当前控制器
-(void)jumpToWebView:(UINavigationController *)currentViewController urlString:(NSString *)urlString ;

/// 回到指定页面
/// @param currentViewController 当前控制器
/// @param toViewController 回到的控制器
-(void)popToViewController:(UINavigationController *)currentViewController ToViewController:(Class )toViewController ;

/// 登录成功创建新tabBar
-(void)LoginSuccessCreateNewTabBar;

-(void)LoginSuccessCreateNewMallTabBar:(NSString *)context;

/// 跳转下个页面的时候关闭自己页面
/// @param currentVC 自己页面
/// @param nextVC 下个页面
-(void)pushNextCloseCurrentViewController:(UIViewController *)currentVC
                                   nextVC:(UIViewController *)nextVC;

@end

NS_ASSUME_NONNULL_END
