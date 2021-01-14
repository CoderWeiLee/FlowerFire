//
//  BaseViewController.m
//  FireCoin
//
//  Created by 赵馨 on 2019/5/24.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseViewController.h"
#import "FirstLevelCertificationVC.h"
#import "SecondaryLevelCertificationVC.h"
#import "Kyc1PopView.h"
#import <LSTPopView.h>
#import "ShowPaymentMethodTBVC.h"

@interface BaseViewController ()
{
    BOOL _isJumpAfterLoginVC;//是否跳转过登录页面
    NSInteger _whatProject;//0是SD，1是商城
}

@end

@implementation BaseViewController 
//ios13黑夜模式适配
- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection{
    [super traitCollectionDidChange:previousTraitCollection];
    // trait发生了改变
    if (@available(iOS 13.0, *)) {
        if ([self.traitCollection hasDifferentColorAppearanceComparedToTraitCollection:previousTraitCollection]) {
            if(UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleLight){
             //   [[SDThemeManager sharedInstance] changeTheme:WHITE_THEME];
            }else{
              //  [[SDThemeManager sharedInstance] changeTheme:BLACK_THEME];
            }
        }
    } else {
        // Fallback on earlier versions
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self theme_didChanged];
         
    [self.view setTheme_backgroundColor:THEME_MAIN_BACKGROUNDCOLOR];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStatusNotice:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
}

//监听网络
-(void)netStatusNotice:(NSNotification *)noti{
    NSDictionary *dic = noti.userInfo;
    NSInteger status = [[dic objectForKey:@"AFNetworkingReachabilityNotificationStatusItem"] integerValue];
    [self monitorNetStateChanged:status];
//    switch (status) {
            
//        case AFNetworkReachabilityStatusNotReachable:
//            NSLog(@"无网");
//            break;
//        case AFNetworkReachabilityStatusReachableViaWiFi:
//            NSLog(@"wifi");
//            break;
//        case AFNetworkReachabilityStatusReachableViaWWAN:
//            NSLog(@"wwan");
//            break;
//        default://未知网络
//            NSLog(@"未知");
//            break;
//    }
}
#pragma mark - publickMethod
-(void)monitorNetStateChanged:(AFNetworkReachabilityStatus)netState{
    if(netState == AFNetworkReachabilityStatusNotReachable){
        [[UniversalViewMethod sharedInstance] alertShowMessage:nil WhoShow:self CanNilTitle:LocalizationKey(@"NetWorkErrorTip3")];
    }else{
         
    }
}
 

-(void)getHttpData_array:(NSDictionary *)dict response:(Response)flag Tag:(NSString *)tag{
    _whatProject = 0;
    if (flag == Success) {
        switch ([dict[@"code"] integerValue]) {
            case 0:
                if(![dict[@"msg"] isEqualToString:LocalizationKey(@"netTip")]){
                    [self dataErrorHandle:dict type:tag];
                }
                break;
            case 1:
                {
                    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithDictionary:dict];
                    if([md[@"data"] isKindOfClass:[NSNull class]]){
                        md[@"data"] = [NSMutableDictionary dictionary];
                    }else if([md[@"data"] isKindOfClass:[NSString class]]){
                        md[@"data"] = [NSMutableDictionary dictionary];
                    }
                    [self dataNormal:md type:tag];
                }
                break;
            case 200:
            {
               //未登录
               if(!_isJumpAfterLoginVC){
                   [self jumpLogin];
                   _isJumpAfterLoginVC = YES;
               }
                [WTUserInfo logout];
            }
                break;
            case 201:
                printAlert(LocalizationKey(@"NetWorkErrorTip1"), 1);
                break;
            case 300:
            {
                [self jumpKycVC:dict];
            }
                break;
            case 301:
            {
                [self jumpKycVC2:dict];
            }
                break;
            case 400:
            {
                [self jumpAddAccount:dict];
                break;
            }
            case 600:
            {
                [self jumpGoogleCodeVC:dict];
                break;
            }
            default:
                printAlert(LocalizationKey(@"NetWorkErrorTip2"), 1);
                break;
        }
    }else{
        [self.view ly_showEmptyView];
        [self dataErrorHandle:dict type:tag];
    }
    
}

- (void)getMallHttpData_array:(NSDictionary *)dict response:(Response)flag Tag:(NSString *)tag{
    _whatProject = 1;
    if (flag == Success) {
        if([dict[@"status"] integerValue] == 1){
            [self dataNormal:dict type:tag];
        }else if([dict[@"status"] integerValue] == 9){
            [self jumpLogin];
            [WTMallUserInfo logout];
        }else{
            [self dataErrorHandle:dict type:tag];
        }
    }else{
        [self.view ly_showEmptyView];
        [self dataErrorHandle:dict type:tag];
    }
}

-(void)jumpLogin{
    [[WTPageRouterManager sharedInstance] jumpLoginViewController:self isModalMode:YES whatProject:_whatProject];
}
  
-(void)jumpKycVC:(NSDictionary *)dict{
    Kyc1PopView *popView = [[Kyc1PopView alloc] initWithFrame:CGRectMake(0, ScreenHeight/2 - 200, ScreenWidth - 50, 350)];
    LSTPopView *v = [LSTPopView initWithCustomView:popView parentView:self.view popStyle:LSTPopStyleSpringFromBottom dismissStyle:LSTDismissStyleSmoothToBottom];
    @weakify(v)
    v.bgClickBlock = ^{
        @strongify(v)
        [v dismiss];
    };
    [v pop];
    
    popView.dissmissPopBlock = ^{
        @strongify(v)
        [v dismiss];
    };
    popView.jumpKycVCBlock = ^{
        FirstLevelCertificationVC *fv = [FirstLevelCertificationVC new];
        [self.navigationController pushViewController:fv animated:YES];
    };
  
}

-(void)jumpKycVC2:(NSDictionary *)dict{
    Kyc1PopView *popView = [[Kyc1PopView alloc] initWithFrame:CGRectMake(0, ScreenHeight/2 - 200, ScreenWidth - 50, 350)];
    LSTPopView *v = [LSTPopView initWithCustomView:popView parentView:self.view popStyle:LSTPopStyleSpringFromBottom dismissStyle:LSTDismissStyleSmoothToBottom];
    @weakify(v)
    v.bgClickBlock = ^{
        @strongify(v)
        [v dismiss];
    };
    [v pop];
    
    popView.dissmissPopBlock = ^{
        @strongify(v)
        [v dismiss];
    };
    popView.jumpKycVCBlock = ^{
        SecondaryLevelCertificationVC *fv = [SecondaryLevelCertificationVC new];
        [self.navigationController pushViewController:fv animated:YES];
    };
}
//添加收款账户
-(void)jumpAddAccount:(NSDictionary *)dict{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:nil message:[NSString stringWithFormat:@"%@",dict[@"msg"]] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *bank = [UIAlertAction actionWithTitle:LocalizationKey(@"Go add") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
          ShowPaymentMethodTBVC *arVC = [ShowPaymentMethodTBVC new];
          [self.navigationController pushViewController:arVC animated:YES];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [ua addAction:bank];
    [ua addAction:cancel];
    [self presentViewController:ua animated:YES completion:nil];
}

-(void)jumpGoogleCodeVC:(NSDictionary *)dict{
    
}


-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    
}

-(void)dataErrorHandle:(NSDictionary *)dict type:(NSString *)type{
    if(![HelpManager isBlankString:dict[@"msg"]]  ){
        printAlert(dict[@"msg"], 1.5f);
    }
}

-(void)closeVC{//https://www.jianshu.com/p/f8a8c11cbcd7
    if (self.presentingViewController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else
    { 
        [self.navigationController popViewControllerAnimated:YES];
    }
}
  
- (void)dealloc
{
    NSLog(@"%@ dealloc了",[self className]);
}

- (BOOL)prefersHomeIndicatorAutoHidden{
    return YES;
}

-(void)theme_didChanged{ 
    [super theme_didChanged];
    self.gk_navTitleFont = [UIFont systemFontOfSize:18.0f];
    self.gk_navLineHidden = YES;
    if([[SDThemeManager sharedInstance].themeName isEqualToString:WHITE_THEME]){
        self.gk_navBackgroundColor   = [UIColor whiteColor];
        self.gk_statusBarStyle       = UIStatusBarStyleDefault;
        self.gk_backStyle            = GKNavigationBarBackStyleBlack;
        self.gk_navTitleColor = KBlackColor;
    }else{
        self.gk_navBackgroundColor   = [UIColor blackColor];
        self.gk_statusBarStyle       = UIStatusBarStyleLightContent;
        self.gk_backStyle            = GKNavigationBarBackStyleWhite;
        self.gk_navTitleColor = KWhiteColor;
    }
    if (self.navigationController.childViewControllers.count <= 1) return;
    if (self.gk_NavBarInit) { //更改返回按钮
        self.gk_navigationItem.leftBarButtonItem = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"top_bar_back_nomal"] target:self action:@selector(backItemClick:)];
    }
    
}

//Xcode 11.4 在调试的时候会出现状态栏样式改变不了的情况 解决办法：在基类控制器里实现下面两个方法
- (BOOL)prefersStatusBarHidden {
    return self.gk_statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.gk_statusBarStyle;
}

#pragma mark - InitViewControllerProtocol
-(void)initData{
    
}

- (void)createNavBar {
     
}
 
- (void)createUI {
     
}

#pragma mark - privateMethod
 
#pragma mark - lazyInit
-(AFNetworkClass *)afnetWork{
    if(!_afnetWork){
        _afnetWork = [AFNetworkClass new];
        _afnetWork.delegate = self;
    }
    return _afnetWork;
}
 
-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
 

@end
