//
//  FFFeedbackViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/24.
//  Copyright © 2020 Celery. All rights reserved.
//  意见反馈

#import "FFFeedbackViewController.h"
#import "LoginTextField.h"
#import "SettingUpdateSubmitButton.h"

@interface FFFeedbackViewController ()
{
    UITextView      *_content;
    LoginTextField  *_email;
    SettingUpdateSubmitButton *_bottomView;
}
@end

@implementation FFFeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

/// 提交修改
-(void)submitClick{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"title"] = _email.loginInputView.text;
    md[@"content"] = _content.text;
    
    [self.afnetWork jsonPostDict:@"/api/article/saveQuest" JsonDict:md Tag:@"1"];
    
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    printAlert(dict[@"msg"], 1.f);
    [self closeVC];
}

- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"578Tip54");
}

- (void)createUI{
    WTLabel *_tip = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, Height_NavBar + 20, ScreenWidth, 20)];
    _tip.font = tFont(16);
    _tip.theme_textColor = THEME_TEXT_COLOR;
    _tip.text = LocalizationKey(@"578Tip55");
    [self.view addSubview:_tip];
    
    _content = [[UITextView alloc] initWithFrame:CGRectMake(_tip.left, _tip.bottom + 10, ScreenWidth - 2 * _tip.left, 200)];
    _content.layer.cornerRadius = 5;
    _content.layer.borderWidth = 1;
    _content.layer.borderColor = FlowerFireBorderColor.CGColor;
    [self.view addSubview:_content];
    
    _email = [[LoginTextField alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _content.bottom + 20 , ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 95) titleStr:LocalizationKey(@"578Tip56") placeholderStr:@""];
    [self.view addSubview:_email];
    _email.loginInputView.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    _bottomView = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, _email.bottom+10, ScreenWidth, 100)];
    [_bottomView.submitButton setTitle:LocalizationKey(@"578Tip57") forState:UIControlStateNormal];
    [_bottomView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    _bottomView.submitButton.frame = CGRectMake(OverAllLeft_OR_RightSpace,  50, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 50);
    
    [self.view addSubview:_bottomView];
     
    //用户名和密码都输入了按钮可以点
    RACSignal *signal = [RACSignal combineLatest:@[_email.loginInputView.rac_textSignal, _content.rac_textSignal] reduce:^id _Nonnull(NSString *account , NSString *pwd){
        return @(account.length && pwd.length);
    }];

    RAC(_bottomView.submitButton,enabled) = signal;
}

- (void)initData{
     
}

@end
