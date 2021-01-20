//
//  NewsMainViewController.m
//  FlowerFire
//
//  Created by 李伟 on 2021/1/14.
//  Copyright © 2021 Celery. All rights reserved.
//  咨询页面

#import "NewsMainViewController.h"
#import <JXCategoryView/JXCategoryView.h>
#import "HeadlinesViewController.h"
#import "LWNewsViewController.h"
#import "PolicyViewController.h"
#import "AllDayViewController.h"
#import <LSTCategory/UIView+LSTView.h>
#import "WTMainRootViewController.H"
@interface NewsMainViewController () <JXCategoryViewDelegate, JXCategoryListContainerViewDelegate>
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) JXCategoryListContainerView *listContainerView;
@property (nonatomic, strong) NSArray<NSString *> *titles;
@end

@implementation NewsMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    self.gk_navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor blackColor], NSFontAttributeName: [UIFont systemFontOfSize:18]};
    self.gk_navigationBar.backgroundColor = [UIColor whiteColor];
    self.gk_navTitle = @"资讯中心";
    //1.初始化 JXCategoryTitleView
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, LSTStatusBarHeight() + LSTNavBarHeight(), kScreenWidth, [self preferredCategoryViewHeight])];
    self.categoryView.delegate = self;
    [self.view addSubview:self.categoryView];
    
    //2.配置 JXCategoryTitleView 的属性
    self.titles = @[@"7*24新闻",@"头条", @"新闻", @"政策"];
    self.categoryView.titles = self.titles;
    self.categoryView.titleColorGradientEnabled = YES;
    self.categoryView.backgroundColor = [UIColor colorWithHexString:@"#3583FC"];
    self.categoryView.titleColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    self.categoryView.titleSelectedColor = [UIColor colorWithWhite:1.0 alpha:1.0];
    self.categoryView.titleFont = [UIFont systemFontOfSize:15];
    self.categoryView.titleSelectedFont = [UIFont systemFontOfSize:17];
    
    //3.添加指示器
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    lineView.indicatorWidth = JXCategoryViewAutomaticDimension;
    self.categoryView.indicators = @[lineView];
    
    //4.初始化列表容器视图
    self.listContainerView = [[JXCategoryListContainerView alloc] initWithType:JXCategoryListContainerType_ScrollView delegate:self];
    self.listContainerView.frame = CGRectMake(0, [self preferredCategoryViewHeight], self.view.bounds.size.width, self.view.bounds.size.height);
    [self.view addSubview:self.listContainerView];
    // 关联到 categoryView
    self.categoryView.listContainer = self.listContainerView;
    
    
}

- (CGFloat)preferredCategoryViewHeight {
    return 50;
}

////重写让导航栏不隐藏
//-(void)theme_didChanged{
//    [super theme_didChanged];
//    self.gk_navTitleFont = [UIFont systemFontOfSize:18.0f];
//    self.gk_navLineHidden = YES;
//    self.gk_navigationBar.hidden = NO;
//    if([[SDThemeManager sharedInstance].themeName isEqualToString:WHITE_THEME]){
//        self.gk_navBackgroundColor   = [UIColor whiteColor];
//        self.gk_statusBarStyle       = UIStatusBarStyleDefault;
//        self.gk_backStyle            = GKNavigationBarBackStyleBlack;
//        self.gk_navTitleColor = KBlackColor;
//    }else{
//        self.gk_navBackgroundColor   = [UIColor blackColor];
//        self.gk_statusBarStyle       = UIStatusBarStyleLightContent;
//        self.gk_backStyle            = GKNavigationBarBackStyleWhite;
//        self.gk_navTitleColor = KWhiteColor;
//    }
//    if (self.navigationController.childViewControllers.count <= 1) return;
//    if (self.gk_NavBarInit) { //更改返回按钮
//        self.gk_navigationItem.leftBarButtonItem = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"top_bar_back_nomal"] target:self action:@selector(backItemClick:)];
//    }
//
//}

# pragma mark - JXCategoryViewDelegate
// 点击选中或者滚动选中都会调用该方法。适用于只关心选中事件，不关心具体是点击还是滚动选中的。
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index {
    
}

// 点击选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didClickSelectedItemAtIndex:(NSInteger)index {
    
}

// 滚动选中的情况才会调用该方法
- (void)categoryView:(JXCategoryBaseView *)categoryView didScrollSelectedItemAtIndex:(NSInteger)index {
    
}

// 正在滚动中的回调
- (void)categoryView:(JXCategoryBaseView *)categoryView scrollingFromLeftIndex:(NSInteger)leftIndex toRightIndex:(NSInteger)rightIndex ratio:(CGFloat)ratio {
    
}


#pragma mark - JXCategoryListContainerViewDelegate
// 返回列表的数量
- (NSInteger)numberOfListsInlistContainerView:(JXCategoryListContainerView *)listContainerView {
    return self.titles.count;
}
// 根据下标 index 返回对应遵守并实现 `JXCategoryListContentViewDelegate` 协议的列表实例
- (id<JXCategoryListContentViewDelegate>)listContainerView:(JXCategoryListContainerView *)listContainerView initListForIndex:(NSInteger)index {
    switch (index) {
        case 0:
            return [[HeadlinesViewController alloc] init];
            break;
        case 1:
            return [[LWNewsViewController alloc] init];
            break;;
        case 2:
            return [[PolicyViewController alloc] init];
            break;;
        default:
            return [[AllDayViewController alloc] init];
            break;
    }
}



@end
