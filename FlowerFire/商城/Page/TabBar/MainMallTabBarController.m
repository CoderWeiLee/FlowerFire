//
//  MainTabBarController.m
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/6.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "MainMallTabBarController.h"
#import "MallLoginViewController.h"
#import "MallCategoryMainViewController.h"
#import "MineMainViewController.h"
#import "MallHomeMainViewController.h"
#import "TaskMainViewController.h"

NSNotificationName const SelectedTabBarIndexNotice = @"SelectedTabBarIndexNotice";

@interface MainMallTabBarController ()<UITabBarControllerDelegate>

@property(nonatomic, assign) BOOL darkMode;

@end

@implementation MainMallTabBarController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    @weakify(self)
    [[NSNotificationCenter defaultCenter] addObserverForName:SelectedTabBarIndexNotice object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self)
        NSInteger index = [note.userInfo[@"index"] integerValue];
        [self setSelectedIndex:index];
    }];
}

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
    MallHomeMainViewController *firstViewController = [[MallHomeMainViewController alloc] init];
    BaseNavigationController *firstNavigationController = [BaseNavigationController rootVC:firstViewController] ;
    [firstNavigationController cyl_setHideNavigationBarSeparator:YES];
    
   MallCategoryMainViewController *secondViewController = [[MallCategoryMainViewController alloc] init];
   BaseNavigationController *secondNavigationController = [BaseNavigationController rootVC:secondViewController];
   [secondNavigationController cyl_setHideNavigationBarSeparator:YES];
    
   TaskMainViewController *thirdViewController = [[TaskMainViewController alloc] init];
   BaseNavigationController *thirdNavigationController = [BaseNavigationController rootVC:thirdViewController] ;
   [thirdNavigationController cyl_setHideNavigationBarSeparator:YES];
     
    MineMainViewController *fourthViewController = [[MineMainViewController alloc] init];
    BaseNavigationController *fourthNavigationController = [BaseNavigationController rootVC:fourthViewController] ;
    [fourthNavigationController cyl_setHideNavigationBarSeparator:YES];
    
   NSArray *viewControllers = @[
                                firstNavigationController,
                                secondNavigationController,
                                thirdNavigationController,
                                fourthNavigationController,
                                ];
   return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
   NSDictionary *firstTabBarItemsAttributes = @{
                                                CYLTabBarItemTitle : @"首页",
                                                CYLTabBarItemImage : self.darkMode ? @"shou2" : @"shou2",   CYLTabBarItemSelectedImage : @"shou1",
                                                };
   NSDictionary *secondTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"商城",
                                                 CYLTabBarItemImage : self.darkMode ? @"shang2" : @"shang2",
                                                 CYLTabBarItemSelectedImage : @"shang1",
                                                 };
   NSDictionary *thirdTabBarItemsAttributes = @{
       CYLTabBarItemTitle : @"任务",
       CYLTabBarItemImage : self.darkMode ? @"ren2" : @"ren2",
       CYLTabBarItemSelectedImage : @"ren1",
   };
    
   NSDictionary *fourthTabBarItemsAttributes = @{
        CYLTabBarItemTitle : @"我的",
        CYLTabBarItemImage : self.darkMode ? @"user2" : @"user2",
        CYLTabBarItemSelectedImage : @"user1",
   };

   NSArray *tabBarItemsAttributes = @[
                                      firstTabBarItemsAttributes,
                                      secondTabBarItemsAttributes,
                                      thirdTabBarItemsAttributes,
                                      fourthTabBarItemsAttributes,
                                      ];
   return tabBarItemsAttributes;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance {
    // Customize UITabBar height
    // 自定义 TabBar 高度
    // tabBarController.tabBarHeight = CYL_IS_IPHONE_X ? 65 : 40;
    
    [self rootWindow].backgroundColor = [UIColor cyl_systemBackgroundColor];
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = rgba(88, 88, 88, 1);
    normalAttrs[NSFontAttributeName] = tFont(12);
 
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = MainColor;
    selectedAttrs[NSFontAttributeName] = tFont(12);
    
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
    if(([[viewController.childViewControllers objectAtIndex:0] isKindOfClass:[MineMainViewController class]] ||
       [[viewController.childViewControllers objectAtIndex:0] isKindOfClass:[TaskMainViewController class]])  && ![WTMallUserInfo isLogIn]){
        [[WTPageRouterManager sharedInstance] jumpLoginViewController:self isModalMode:YES whatProject:1];
            return NO;
    }
     
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectControl:(UIControl *)control {
   
}
 

@end
