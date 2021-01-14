//
//  WTPageRouterManager.m
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/5.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "WTPageRouterManager.h"
#import "MainTabBarController.h"
#import "MainMallTabBarController.h"
#import "WTWebViewController.h"
#import "BaseNavigationController.h"
#import "WTMainRootViewController.h"
#import "WTMallMainRootViewController.h"

@implementation WTPageRouterManager

static WTPageRouterManager *_gizManager = nil;

+ (instancetype)sharedInstance{
    if (_gizManager == nil) {
        _gizManager = [[self alloc] init];
    }
    return _gizManager;
}
 
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        if (_gizManager == nil) {
            _gizManager = [super allocWithZone:zone];
        }
    });
    
    return _gizManager;
}
 
-(id)copyWithZone:(NSZone *)zone{
    return [[self class] sharedInstance];
}
-(id)mutableCopyWithZone:(NSZone *)zone{
    return [[self class] sharedInstance];
}

- (void)jumpLoginViewController:(UIViewController *)currentVC isModalMode:(BOOL)isModalMode whatProject:(NSInteger)whatProject{
    Class class;
    if(whatProject == 0){
        class = NSClassFromString(LOGIN_VIEW_CONTROLLER);
    }else{
        class = NSClassFromString(Mall_LOGIN_VIEW_CONTROLLER);
    }
    if(!class) return;
    UIViewController *loginVC=[[class alloc]init];
    if(isModalMode){ //加上导航栏
        BaseNavigationController *nav = [BaseNavigationController rootVC:loginVC];
        nav.modalPresentationStyle = UIModalPresentationFullScreen;
        [currentVC presentViewController:nav animated:YES completion:nil];
    }else{
        if([currentVC isKindOfClass:[UINavigationController class]]){
            [(UINavigationController *)currentVC pushViewController:loginVC animated:YES];
        }else{
            loginVC.modalPresentationStyle = UIModalPresentationFullScreen;
            [currentVC presentViewController:loginVC animated:YES completion:nil];
        }
    }
    
}
 
- (void)jumpTabBarController:(NSInteger)selectedIndex{
    MainTabBarController *tabViewController = (MainTabBarController *)[MainTabBarController cyl_tabBarController];
    NSAssert(tabViewController.viewControllers.count >    selectedIndex, @"索引下标不能超过tabBar总数");
    tabViewController.selectedIndex = selectedIndex;
     
}

- (void)jumpMallTabBarController:(NSInteger)selectedIndex{
//    MainMallTabBarController *tabViewController = (MainMallTabBarController *)[MainTabBarController cyl_tabBarController];
//    NSAssert(tabViewController.viewControllers.count >    selectedIndex, @"索引下标不能超过tabBar总数");
//    tabViewController.selectedIndex = selectedIndex;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SelectedTabBarIndexNotice object:nil userInfo:@{@"index":@(selectedIndex)}];
     
}
 

- (void)jumpToWebView:(UINavigationController *)currentViewController urlString:(NSString *)urlString{
    WTWebViewController *webView = [[WTWebViewController alloc] initWithURLString:urlString];
    webView.progressTintColor = MainColor;
    [currentViewController pushViewController:webView animated:YES];
}

- (void)popToViewController:(UINavigationController *)currentViewController ToViewController:(Class )toViewController{
    UINavigationController *getmoney = nil;
    for (UIViewController * VC in currentViewController.viewControllers) {
        if ([VC isKindOfClass:toViewController]) {
            getmoney = (UINavigationController *)VC;
            [currentViewController popToViewController:getmoney animated:YES];
        }
    }
}

- (void)LoginSuccessCreateNewTabBar{
    AppDelegate *appdelegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
    WTMainRootViewController *rootVC = (WTMainRootViewController *)appdelegate.window.rootViewController;
    [rootVC createNewTabBarWithContext:nil];
}

- (void)LoginSuccessCreateNewMallTabBar:(NSString *)context{
    AppDelegate *appdelegate =(AppDelegate *) [UIApplication sharedApplication].delegate;
    WTMallMainRootViewController *rootVC = (WTMallMainRootViewController *)appdelegate.window.rootViewController;
    [rootVC createNewTabBarWithContext:context];
}

- (void)pushNextCloseCurrentViewController:(UIViewController *)currentVC nextVC:(UIViewController *)nextVC{
    NSArray *viewControlles = currentVC.navigationController.viewControllers;
    NSMutableArray *newviewControlles = [NSMutableArray array];
       if ([viewControlles count] > 0) {
           for (int i=0; i < [viewControlles count]-1; i++) {
               [newviewControlles addObject:[viewControlles objectAtIndex:i]];
           }
       }
    [newviewControlles addObject:nextVC];
    [currentVC.navigationController setViewControllers:newviewControlles animated:YES];
}

@end
