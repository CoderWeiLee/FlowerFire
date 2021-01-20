//
//  MainTabBarController.m
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/6.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "MainTabBarController.h"
#import "ViewController.h"
#import "BaseViewController.h"
#import "HomeMainViewController.h"
#import "QuotesMainViewController.h"
#import "AssetsViewController.h"
#import "TransactionMainViewController.h"
#import "FFMineMainViewController.h"
#import "NewsMainViewController.h"
@interface MainTabBarController ()<UITabBarControllerDelegate>

@property(nonatomic, assign) BOOL darkMode;

@end

@implementation MainTabBarController

- (instancetype)initWithContext:(NSString *)context themeChange:(BOOL)themeChange{
    self.darkMode = themeChange;
    /**
     * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
     * 等 效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
     * 更推荐后一种做法。
     */
    UIEdgeInsets imageInsets = UIEdgeInsetsZero;//UIEdgeInsetsMake(4.5, 0, -4.5, 0);
    UIOffset titlePositionAdjustment = UIOffsetMake(0, -3.5);
    if (self = [super initWithViewControllers:[self viewControllersForTabBar]
                        tabBarItemsAttributes:[self tabBarItemsAttributesForController]
                                  imageInsets:imageInsets
                      titlePositionAdjustment:titlePositionAdjustment
                                      context:context
                ]) {
        [self customizeTabBarAppearance];
        
           
        self.delegate = self;
        self.navigationController.navigationBar.hidden = YES;
    }
    return self;
}

- (NSArray *)viewControllersForTabBar {
    HomeMainViewController *firstViewController = [[HomeMainViewController alloc] init];
    UIViewController *firstNavigationController = [BaseNavigationController rootVC:firstViewController];
    [firstViewController cyl_setHideNavigationBarSeparator:YES];
  
    NewsMainViewController *secondViewController = [[NewsMainViewController alloc] init];
    UINavigationController *secondNavigationController = [[UINavigationController alloc] initWithRootViewController:secondViewController];
    [secondViewController cyl_setHideNavigationBarSeparator:YES];
     
    TransactionMainViewController *thirdViewController = [[TransactionMainViewController alloc] init];
    UIViewController *thirdNavigationController = [BaseNavigationController rootVC:thirdViewController] ;
    [thirdViewController cyl_setHideNavigationBarSeparator:YES];
    
    AssetsViewController *fouthViewController = [[AssetsViewController alloc] init];
    UIViewController *fouthNavigationController = [BaseNavigationController rootVC:fouthViewController] ;
    [fouthViewController cyl_setHideNavigationBarSeparator:YES];
    
    FFMineMainViewController *fiveViewController = [[FFMineMainViewController alloc] init];
    UIViewController *fiveNavigationController = [BaseNavigationController rootVC:fiveViewController] ;
    [fiveNavigationController cyl_setHideNavigationBarSeparator:YES];
    
    
   NSArray *viewControllers = @[
                                firstNavigationController,
                                secondNavigationController,
                                thirdNavigationController,
                                fouthNavigationController,
                                fiveNavigationController,
                                ];
   return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
   NSDictionary *firstTabBarItemsAttributes = @{
                                                CYLTabBarItemTitle : LocalizationKey(@"tabbar1"),
                                                CYLTabBarItemImage : self.darkMode ? @"home_not_ic" : @"home_not_ic",   CYLTabBarItemSelectedImage : @"home_cli_ic",
                                                };
   NSDictionary *secondTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : LocalizationKey(@"tabbar2"),
                                                 CYLTabBarItemImage : self.darkMode ? @"price_not_ic" : @"price_not_ic",
                                                 CYLTabBarItemSelectedImage : @"price_cli_ic",
                                                 };
   NSDictionary *thirdTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : LocalizationKey(@"tabbar3"),
                                                 CYLTabBarItemImage : self.darkMode ? @"deal_not_ic" : @"deal_not_ic",
                                                 CYLTabBarItemSelectedImage : @"deal_cli_ic",
   };
    
   NSDictionary *fourthTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : LocalizationKey(@"tabbar5"),
                                                  CYLTabBarItemImage : self.darkMode ? @"property_not_ic" : @"property_not_ic",
                                                  CYLTabBarItemSelectedImage : @"property_cli_ic",
  };
    NSDictionary *fivethTabBarItemsAttributes = @{
                                                   CYLTabBarItemTitle : LocalizationKey(@"tabbar6"),
                                                   CYLTabBarItemImage : self.darkMode ? @"my_not_ic" : @"my_not_ic",
                                                   CYLTabBarItemSelectedImage : @"my_cli_ic",
   };
    
    
    
   NSArray *tabBarItemsAttributes = @[
                                      firstTabBarItemsAttributes,
                                      secondTabBarItemsAttributes,
                                      thirdTabBarItemsAttributes,
                                      fourthTabBarItemsAttributes,
                                      fivethTabBarItemsAttributes
                                      ];
   return tabBarItemsAttributes;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance {
    // Customize UITabBar height
    // 自定义 TabBar 高度
  //  self.tabBarHeight = CYL_IS_IPHONE_X ? 165 : 40;
    
    [self rootWindow].backgroundColor = [UIColor cyl_systemBackgroundColor];
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor cyl_systemGrayColor];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = MainColor;
     
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    //背景色改变
    // self.tabBar.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    //不透明
    self.tabBar.translucent =  NO;
}

#pragma mark - delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    //加入震动感反馈
    UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle: UIImpactFeedbackStyleLight];
    [generator prepare];
    [generator impactOccurred];
    
    NSLog(@"viewcontoller===%@",viewController.childViewControllers);
    if(([[viewController.childViewControllers objectAtIndex:0] isKindOfClass:[AssetsViewController class]] || [[viewController.childViewControllers objectAtIndex:0] isKindOfClass:[FFMineMainViewController class]]) && ![WTUserInfo isLogIn]){
        [[WTPageRouterManager sharedInstance] jumpLoginViewController:self isModalMode:YES whatProject:0];
            return NO;
    }
    
    
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
    UIView *animationView;
    if ([control cyl_isTabButton]) {
        //更改红标状态
//        if ([self.selectedViewController cyl_isShowBadge]) {
//            [self.selectedViewController cyl_clearBadge];
//        } else {
//            [self.selectedViewController cyl_showBadge];
//        }
        animationView = [control cyl_tabImageView];
    }
    [self addScaleAnimationOnView:animationView repeatCount:1];
}

//缩放动画
- (void)addScaleAnimationOnView:(UIView *)animationView repeatCount:(float)repeatCount {
    //需要实现的帧动画，这里根据需求自定义
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
    animation.keyPath = @"transform.scale";
    //animation.values = @[@1.0,@1.3,@0.9,@1.15,@0.95,@1.02,@1.0];
    animation.values = @[@1.0,@1.3,@1.0];
    animation.duration = 0.2;
    animation.repeatCount = repeatCount;
    animation.calculationMode = kCAAnimationCubic;
    [animationView.layer addAnimation:animation forKey:nil];
}

@end
