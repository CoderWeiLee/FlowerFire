//
//  AssetsViewController.m
//  FireCoin
//
//  Created by 赵馨 on 2019/5/27.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "AssetsViewController.h"
#import "AssetsHeaderView.h"
#import "CoinAccountChildVC.h"
#import "XDPagesView.h"
#import "FFAddNetSwitchViewController.h"
#import "WTMainRootViewController.h"
@interface AssetsViewController ()<XDPagesViewDataSourceDelegate>
{
    XDTitleBarLayout *_layout;
}
@property(nonatomic , strong) AssetsHeaderView  *tableHeaderView;
@property (nonatomic, strong) XDPagesView       *pagesView; //分页选择
@property (nonatomic, strong) __block NSArray   *titles;
@property (nonatomic, strong) UILabel           *pageTitle;
@end

@implementation AssetsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    //时间栏颜色
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
     
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WTMainRootViewController *rootVC = (WTMainRootViewController *)UIApplication.sharedApplication.keyWindow.rootViewController;
    rootVC.navigationBar.hidden = YES;
    self.gk_navBarAlpha = 0;
    self.gk_navigationItem.title = LocalizationKey(@"tabbar5");
    self.gk_navTitleColor = KWhiteColor;
    
    _titles = @[LocalizationKey(@"Exchange")];
    _layout = [[XDTitleBarLayout alloc]init];
    _layout.barItemSize = CGSizeMake(ScreenWidth/_titles.count - OverAllLeft_OR_RightSpace, 0);
    _layout.needBarBottomLine = NO;
    _layout.barFollowLineColor = MainColor;
    _layout.barTextFont = tFont(15);
    _layout.barFollowLinePercent = 1;
    _layout.barTextColor = [UIColor grayColor];
    _layout.barTextSelectedColor = KWhiteColor;
    
    _layout.barMarginTop = Height_NavBar;//标题栏距上方的悬停距离，默认为0
    _pagesView = [[XDPagesView alloc]initWithFrame:self.view.bounds dataSourceDelegate:self beginPage:0 titleBarLayout:_layout style:XDPagesViewStyleTablesFirst];
    _pagesView.cacheNumber = 1;
    _pagesView.headerView = self.tableHeaderView;
    _pagesView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    [self.view addSubview:_pagesView];
    
    
    
}
 
#pragma mark -- XDSlideViewDataSourceAndDelegate
#pragma mark -- 必须实现代理
- (NSArray<NSString *> *)xd_pagesViewPageTitles {
    return _titles;
}

- (UIViewController *)xd_pagesViewChildControllerToPagesView:(XDPagesView *)pagesView forIndex:(NSInteger)index {
    //复用
    CoinAccountChildVC *pageVc = (CoinAccountChildVC *)[pagesView dequeueReusablePageForIndex:index];
    
    if (!pageVc) {
        switch (index) {
            case 0:
            {
                pageVc = [CoinAccountChildVC new];
                __weak typeof(self) weakSelf = self;
                pageVc.setAssetsHeaderDataBlock = ^(NSString * _Nonnull data,NSString *CNYStr) {
                    [weakSelf.tableHeaderView setSumData:data CNYStr:CNYStr];
                };
                pageVc.coinAccountType = CoinAccountTypeBB;
            }
                break;
            default:
            {
                pageVc = [CoinAccountChildVC new];
                pageVc.coinAccountType = CoinAccountTypeFB;
            }
                break;
        }
    }
    
    return pageVc;
}

- (void)xd_pagesViewVerticalScrollOffsetyChanged:(CGFloat)changedy{
  //  NSLog(@"changedy:%f",changedy);
//    if(changedy<=-Height_NavBar){
//        self.tableHeaderView.backgroundColor = [UIColor whiteColor];
//        self.pageTitle.hidden = NO;
//        self.gk_statusBarStyle = UIStatusBarStyleDefault;
//    }else{
//        self.tableHeaderView.backgroundColor = MainColor;
//        self.pageTitle.hidden = YES;
//        self.gk_statusBarStyle = UIStatusBarStyleLightContent;
//    }
}

#pragma mark -- 非必须实现代理

#pragma mark - ui

-(AssetsHeaderView *)tableHeaderView{
    if(!_tableHeaderView){
        CGFloat hiddenPriceButtonHeight = 23;
        if(IS_IPHONE_X){
            _tableHeaderView = [[AssetsHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,  115 + SafeIS_IPHONE_X + hiddenPriceButtonHeight)];
        }else{
            _tableHeaderView = [[AssetsHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,  110 + SafeIS_IPHONE_X + hiddenPriceButtonHeight)];
        }
        @weakify(self)
        [_tableHeaderView.addNetSwitch addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self)
            [[UniversalViewMethod sharedInstance] activationStatusCheck:self];
            
            FFAddNetSwitchViewController *fvc = [FFAddNetSwitchViewController new];
            [self.navigationController pushViewController:fvc animated:YES];
        }];
    }
    return _tableHeaderView;
}

-(UILabel *)pageTitle{
    if(!_pageTitle){
        _pageTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tableHeaderView.ly_maxY - 50, ScreenWidth, 50)];
        _pageTitle.font = tFont(NAVIGATATIONBAR_TITLE_FONT);
        _pageTitle.textAlignment = NSTextAlignmentCenter;
        [self.tableHeaderView addSubview:_pageTitle];
        _pageTitle.text = LocalizationKey(@"tabbar5");
        _pageTitle.textColor = [UIColor blackColor];
        _pageTitle.hidden = YES;
    }
    return _pageTitle;
}

@end
