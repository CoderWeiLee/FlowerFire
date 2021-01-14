//
//  InvitationActivateViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "InvitationActivateViewController.h"
#import "SettingUpdateSubmitButton.h"
#import "LoginTextField.h"

@interface InvitationActivateViewController ()
{
    SettingUpdateSubmitButton *_bottomView;
    LoginTextField            *_accountTextField;
    WTLabel                   *_activateNum;
    
}
@end

@implementation InvitationActivateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

#pragma mark - action
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        NSString *activateNum = dict[@"data"][@"activation_num"];
        if(![HelpManager isBlankString:activateNum]){
            _activateNum.text = NSStringFormat(@"%@%@%@",LocalizationKey(@"InvitationActivateTip4"),activateNum,LocalizationKey(@"InvitationActivateTip4jihuoma"));
            
        }
    }else{
        printAlert(dict[@"msg"], 1.f);
        [self closeVC];
    }
}

-(void)submitClick{
    if([HelpManager isBlankString:_accountTextField.loginInputView.text]){
        printAlert(LocalizationKey(@"InvitationActivateTip3"), 1.f);
        return;
    }
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:1];
    md[@"username"] = _accountTextField.loginInputView.text;
    [self.afnetWork jsonPostDict:@"/api/user/activationUser" JsonDict:md Tag:@"2"];
    
}
 
#pragma mark - initViewDelegate
- (void)theme_didChanged{
     self.gk_navLineHidden = NO;
}

- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"InvitationActivateTip1");
     
    _accountTextField = [[LoginTextField alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, Height_NavBar , ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 95) titleStr:LocalizationKey(@"InvitationActivateTip2") placeholderStr:LocalizationKey(@"InvitationActivateTip3")];
    [self.view addSubview:_accountTextField];
    
    _activateNum = [[WTLabel alloc] initWithFrame:CGRectMake(_accountTextField.left, _accountTextField.bottom + 10, SCREEN_WIDTH, 20) Text:NSStringFormat(@"%@0.000%@",LocalizationKey(@"InvitationActivateTip4"),LocalizationKey(@"InvitationActivateTip4jihuoma")) Font:tFont(14) textColor:MainColor parentView:self.view];
    
    _bottomView = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, _activateNum.bottom, ScreenWidth, 100)];
    [_bottomView.submitButton setTitle:LocalizationKey(@"MiningPollTip8") forState:UIControlStateNormal];
    [_bottomView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_bottomView];
     
    _bottomView.submitButton.enabled = YES;
}

- (void)initData{
    [self.afnetWork jsonPostDict:@"/api/configset/getBasicset" JsonDict:nil Tag:@"1"];
}

@end
