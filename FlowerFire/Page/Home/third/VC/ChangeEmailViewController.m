//
//  ChangeEmailViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/13.
//  Copyright © 2020 Celery. All rights reserved.
//  修改邮箱

#import "ChangeEmailViewController.h"
#import "SettingUpdateHeaderView.h"
#import "SettingUpdateFormCell.h"
#import "SettingUpdateSubmitButton.h"
#import "MainTabBarController.h"

@interface ChangeEmailViewController ()
{
    NSString *_email;
    NSString *_captcha;
    SettingUpdateFormCell     *cell;
    SettingUpdateSubmitButton *_bottomView;
}
@end

@implementation ChangeEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self createNavBar];
    [self createUI];
    [self initData];
}

#pragma mark - action
-(void)getCaptchaClick{ //邮箱验证码
    if(![[UniversalViewMethod sharedInstance] checkEmail:_email]){
        printAlert(LocalizationKey(@"changeEmailTip5"), 1.f);
        return;
    }
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"email"] = _email;
    md[@"event"] = @"changeemail";
    
    [self.afnetWork jsonGetDict:HTTP_SEND_EMS JsonDict:md Tag:@"1"];
}

/// 提交修改
-(void)submitClick{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"email"] = _email;
    md[@"captcha"] = _captcha;
    [self.afnetWork jsonGetDict:@"/api/user/changeemail" JsonDict:md Tag:@"2"];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        SettingUpdateFormCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]];
        [[HelpManager sharedHelpManager] sendVerificationCode:cell.rightButton];
    }else{
        printAlert(dict[@"msg"], 1.f);
        WTUserInfo *userInfo = [WTUserInfo shareUserInfo];
        userInfo.email = _email;
        [WTUserInfo saveUser:userInfo];
        [self closeVC];
          
    }
}

- (void)createNavBar{
    self.gk_navigationBar.hidden = NO;
    self.gk_navigationItem.title = LocalizationKey(@"changeEmailTip1");
}

- (void)createUI{
    SettingUpdateHeaderView *headerView = [[SettingUpdateHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50) changeTitle:self.gk_navigationItem.title];
    self.tableView.tableHeaderView = headerView;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    
    _bottomView = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    [_bottomView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = _bottomView;
    [self.view addSubview:self.tableView];
     
}

- (void)initData{
    self.dataArray = @[@{@"title":@"changeEmailTip2",@"details":@"changeEmailTip3"},
    @{@"title":@"changeLoginPwdTip10",@"details":@"changeLoginPwdTip11",@"rightBtnTitle":@"changeLoginPwdTip12",},
    ].copy;
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[SettingUpdateFormCell class] forCellReuseIdentifier:identifier];
    SettingUpdateFormCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(self.dataArray.count>0){
        [cell setCellData:self.dataArray[indexPath.row]];
    }
    cell.loginInputView.tag = indexPath.row;
    [cell.loginInputView addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    if(indexPath.row == self.dataArray.count-1){ 
        [cell.rightButton addTarget:self action:@selector(getCaptchaClick) forControlEvents:UIControlEventTouchUpInside];
        cell.loginInputView.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        cell.loginInputView.keyboardType = UIKeyboardTypeEmailAddress;
    }
     
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 91;
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            _email = textField.text;
            break;
        default:
            _captcha = textField.text;
            break;
    }
    if(_email.length && _captcha.length){
        _bottomView.submitButton.enabled = YES;
    }else{
        _bottomView.submitButton.enabled = NO;
    }
}


@end
