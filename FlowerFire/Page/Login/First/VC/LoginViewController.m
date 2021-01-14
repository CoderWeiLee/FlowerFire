//
//  LoginViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/4/30.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "WTMainRootViewController.h"
#import "SendVerificationCodeModalVC.h"
#import "FFImportAccountViewController.h"
#import "RegisteredViewController.h"
#import "FFAcountManager.h"
 
@interface LoginViewController ()<LoginViewDelegate>
{
    LoginView *_loginView;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSuccessNotice) name:LOGIN_SUCCESS_NOTIFICATION object:nil];
}

-(void)loginSuccessNotice{
    WTMainRootViewController *view=[[WTMainRootViewController alloc]init];
    UIWindow * window = [UIApplication sharedApplication].delegate.window;
    
    [window.rootViewController dismissViewControllerAnimated:NO completion:^{
        window.rootViewController = view;
        [window makeKeyAndVisible];
    }];
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - netData
-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if(dict.count >0){
        printAlert(LocalizationKey(@"LoginSuccess"), 1.f);
        NSDictionary *userInforDic = dict[@"data"][@"userinfo"];
        [self saveUserInfor:userInforDic];
        
//        //设置jpush alias
//        [JPUSHService setAlias:[NSString stringWithFormat:@"%@",userInforDic[@"user_id"]] completion:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//
//        } seq:6];
        
        WTMainRootViewController *view=[[WTMainRootViewController alloc]init];
        UIWindow * window = [UIApplication sharedApplication].delegate.window;
        
        [window.rootViewController dismissViewControllerAnimated:NO completion:^{
            window.rootViewController = view;
            [window makeKeyAndVisible];
        }];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS_NOTIFICATION object:nil userInfo:nil];
        [self dismissViewControllerAnimated:NO completion:nil];
    }
}
// //返回600后到这里 进行谷歌验证
//- (void)jumpGoogleCodeVC:(NSDictionary *)dict{
//    //登录成功了，提前存储一波邮箱号，防止用户忘记谷歌验证吗，重新绑定的时候没有邮箱
//    WTUserInfo *userInfo = [WTUserInfo shareUserInfo];
//    userInfo.email = dict[@"data"][@"userinfo"][@"email"];
//    [WTUserInfo saveUser:userInfo];
//    
//    SendVerificationCodeModalVC *mvc = [SendVerificationCodeModalVC new];
//    mvc.sendVerificationCodeWhereJump = SendVerificationCodeWhereJumpLogin;
//    mvc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//
//    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:mvc];
//    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;;
//    self.modalPresentationStyle = UIModalPresentationCurrentContext;
//    [self presentViewController:nav animated:YES completion:nil];
//       
//    @weakify(self)
//    mvc.getGoogleCodeBlock = ^(NSString * _Nonnull code) {
//      @strongify(self)
//        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
//        dic[@"account"] =  self->_loginView.userNameField.loginInputView.text;
//        dic[@"password"] = self->_loginView.pwdField.loginInputView.text;
//        dic[@"googlecode"] = code;
//        [self.afnetWork jsonGetDict:@"/api/user/login" JsonDict:dic Tag:@"1" LoadingInView:self.view];
////        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"phone"];
////        [[NSUserDefaults standardUserDefaults] synchronize];
//    };
//}

//保存用户信息
-(void)saveUserInfor:(NSDictionary *)userInforDic{
    [WTUserInfo getuserInfoWithDic:userInforDic];
   
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:4];
    md[@"username"] = userInforDic[@"username"];;
    md[@"type"] = @(0); // type 0 密码登录 1 助记词 2 私钥 
   // md[@"pwd"] = self->_loginView.pwdField.loginInputView.text;
    [[FFAcountManager sharedInstance] saveUserAccount:md]; 
  //  [Bugly setUserIdentifier:userInforDic[@"user_id"]];
}

#pragma mark - LoginViewDelegate
//- (void)loginClick{
//    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:2];
//    dic[@"account"] =  _loginView.userNameField.loginInputView.text;
//    dic[@"password"] = _loginView.pwdField.loginInputView.text;
//    [self.afnetWork jsonGetDict:@"/api/user/login" JsonDict:dic Tag:@"1" LoadingInView:self.view];
//}
//
//- (void)forgetPwdClick{
//    ForgetPwdViewController *forgetPwdVC = [ForgetPwdViewController new];
//    [self.navigationController pushViewController:forgetPwdVC animated:YES];
//}
//
//- (void)registeredClick{
//    RegisteredViewController *r = [RegisteredViewController new];
//    [self.navigationController pushViewController:r animated:YES];
//}

- (void)popVC{
    [self closeVC];
}

- (void)createAccountClick{
    RegisteredViewController *r = [RegisteredViewController new];
    [self.navigationController pushViewController:r animated:YES];
}

- (void)improtAccountClick{
    FFImportAccountViewController *fvc = [FFImportAccountViewController new];
    [self.navigationController pushViewController:fvc animated:YES];
}



#pragma - ui
- (void)createNavBar{
    self.gk_navigationBar.hidden = YES;
}

- (void)createUI{
    _loginView = [[LoginView alloc] initWithFrame:self.view.bounds];
    _loginView.delegate = self;
    [self.view addSubview:_loginView];
}



@end
