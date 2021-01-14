//
//  FirstLevelCertificationVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/30.
//  Copyright © 2019 王涛. All rights reserved.
//  一级kyc认证

#import "FirstLevelCertificationVC.h"
#import "LoginTextField.h"
#import "SettingUpdateSubmitButton.h"

@interface FirstLevelCertificationVC ()
{ 
    LoginTextField             *_nameField;
    LoginTextField             *_idCardField;
    SettingUpdateSubmitButton  *_submitButton;
}
@end

@implementation FirstLevelCertificationVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.gk_navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.gk_navigationItem.title = LocalizationKey(@"KYC1 certification");
    
    [self setUpView];
}

#pragma mark - action
-(void)saveClick{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"true_name"] = _nameField.loginInputView.text;
    md[@"sn"] = _idCardField.loginInputView.text; 
    
    [self.afnetWork jsonPostDict:@"/api/account/addVerifyKyc1" JsonDict:md Tag:@"1"];
}

#pragma mark netBack
-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    NSString *message = [NSString stringWithFormat:@"%@",dict[@"msg"]];
    printAlert(message, 1);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ui
-(void)setUpView{
    _nameField = [[LoginTextField alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, Height_NavBar, ScreenWidth-OverAllLeft_OR_RightSpace*2, 90) titleStr:LocalizationKey(@"Name") placeholderStr:@"InputTrueName"];
    [self.view addSubview:_nameField];
    
    _idCardField = [[LoginTextField alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _nameField.ly_maxY , ScreenWidth-OverAllLeft_OR_RightSpace*2, 90) titleStr:LocalizationKey(@"ID card Number") placeholderStr:@"Kyc1Tip2"];
    [self.view addSubview:_idCardField];
    
    _submitButton = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, _idCardField.ly_maxY, ScreenWidth, 150)];
    [_submitButton.submitButton setTitle:LocalizationKey(@"Save") forState:UIControlStateNormal];
    [self.view addSubview:_submitButton];
    
    [_submitButton.submitButton addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
 
    //用户名和密码都输入了按钮可以点
    RACSignal *signal = [RACSignal combineLatest:@[_nameField.loginInputView.rac_textSignal, _idCardField.loginInputView.rac_textSignal] reduce:^id _Nonnull(NSString *account , NSString *pwd){
          return @(account.length && pwd.length);
    }];

    RAC(_submitButton.submitButton,enabled) = signal;
}


@end
