//
//  InputGoogleVerficationViewController.m
//  FireCoin
//
//  Created by 王涛 on 2019/12/3.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "InputGoogleVerficationViewController.h"
#import <CRBoxInputView/CRLineView.h>
#import <CRBoxInputCellProperty.h>
#import <CRBoxInputView.h>
#import "SendVerificationCodeModalVC.h"
#import "MainTabBarController.h"

@interface InputGoogleVerficationViewController ()

@end

@implementation InputGoogleVerficationViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [IQKeyboardManager sharedManager].enable = NO;
     
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
}

-(void)setUpView{
    self.gk_navigationItem.title = LocalizationKey(@"googleVerificationTip8");
     
    CRBoxInputCellProperty *cellProperty = [CRBoxInputCellProperty new];
    cellProperty.cellCursorColor = MainBlueColor; 
    cellProperty.cornerRadius = 0;
    cellProperty.borderWidth = 0;
    cellProperty.cellFont = [UIFont boldSystemFontOfSize:24];
    cellProperty.showLine = YES;
    cellProperty.customLineViewBlock = ^CRLineView * _Nonnull{
        CRLineView *lineView = [CRLineView new];
        lineView.underlineColorNormal = rgba(245, 245, 245, 1);
        lineView.underlineColorSelected =  MainBlueColor;
        lineView.lineView.layer.shadowOpacity = 0;
        [lineView.lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(3);
            make.left.right.bottom.offset(0);
        }];

        return lineView;
    };
    CRBoxInputView *boxInputView = [[CRBoxInputView alloc] initWithCodeLength:6];
    
    if([[SDThemeManager sharedInstance].themeName isEqualToString:WHITE_THEME]){
        cellProperty.cellTextColor = [UIColor blackColor];
        boxInputView.backgroundColor = [UIColor whiteColor];
    }else{
        cellProperty.cellTextColor = [UIColor whiteColor];
        boxInputView.backgroundColor = MainCellColor;
    }
    cellProperty.cellBgColorNormal =  boxInputView.backgroundColor;
    cellProperty.cellBgColorSelected = boxInputView.backgroundColor;
    boxInputView.customCellProperty = cellProperty;
    boxInputView.frame = CGRectMake(2 * OverAllLeft_OR_RightSpace, Height_NavBar+30, ScreenWidth - 4 * OverAllLeft_OR_RightSpace, 50);
    [boxInputView loadAndPrepareViewWithBeginEdit:YES];
    [self.view addSubview:boxInputView];
    
    @weakify(self)
    boxInputView.textDidChangeblock = ^(NSString *text, BOOL isFinished) {
        NSLog(@"text:%@", text);
        if(text.length == 6){
            @strongify(self)
            NSMutableDictionary *md = [NSMutableDictionary dictionary];
            md[@"googlecode"] = text;
            md[@"secret"] = self.secret;
//            SendVerificationCodeModalVC *mvc = [SendVerificationCodeModalVC new];
//            mvc.sendVerificationCodeWhereJump = SendVerificationCodeWhereJumpBindGoogleCode;
//            mvc.sendCodeNetDic = md;
//            mvc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//            mvc.modalPresentationStyle = UIModalPresentationOverFullScreen;;
//            self.modalPresentationStyle = UIModalPresentationCurrentContext;
//            [self presentViewController:mvc animated:YES completion:nil];
          
            [self.afnetWork jsonPostDict:@"/api/account/bindGoogleAuth" JsonDict:md Tag:@"4"];
            
            
            
//            @weakify(self)
//            mvc.backRefreshBlock = ^{
//                @strongify(self)
//                //成功后存为绑定成功
//                WTUserInfo *userInfo = [WTUserInfo shareUserInfo];
//                userInfo.is_googleauth = @"1";
//                [WTUserInfo saveUser:userInfo];
//                
//                MainTabBarController *tabViewController = (MainTabBarController *)[MainTabBarController cyl_tabBarController];
//                tabViewController.selectedIndex = 0;
//                [self.navigationController popToRootViewControllerAnimated:NO];
//                        
//            };
        }
    };
    
}


- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    
    WTUserInfo *userInfo = [WTUserInfo shareUserInfo];
    userInfo.is_googleauth = @"1";
    [WTUserInfo saveUser:userInfo];
    
    MainTabBarController *tabViewController = (MainTabBarController *)[MainTabBarController cyl_tabBarController];
    tabViewController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}

#pragma mark - action
@end
