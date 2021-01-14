//
//  ForgetFundPwdViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/29.
//  Copyright © 2020 Celery. All rights reserved.
//。忘记交易密码

#import "ForgetFundPwdViewController.h"
#import "SettingUpdateHeaderView.h"
#import "SettingUpdateFormCell.h"
#import "SettingUpdateSubmitButton.h"

@interface ForgetFundPwdViewController ()
{
    NSString *_newPwd;
    NSString *_newPwd2;
    NSString *_captcha;
    UITextField * _googleCodeField;
     
    SettingUpdateSubmitButton *_bottomView;
}
@end

@implementation ForgetFundPwdViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

#pragma mark - action
-(void)secureTextEntrySwitch:(UIButton *)button{
    button.selected = !button.selected;
    for (UIView* next = [button superview]; next; next = next.superview) {
        if([next isMemberOfClass:[SettingUpdateFormCell class]]){
           SettingUpdateFormCell * cell = (SettingUpdateFormCell *)next;
           cell.loginInputView.secureTextEntry = !cell.rightButton.isSelected;
        }
    }
   
}

-(void)getCaptchaClick{ //邮箱验证码
    
    _googleCodeField.text = [UIPasteboard generalPasteboard].string;
    
    [self textFieldWithText:_googleCodeField];
//    if(
//       [HelpManager isBlankString:_newPwd2] ||
//       [HelpManager isBlankString:_newPwd]){
//        printAlert(LocalizationKey(@"changeLoginPwdTip14"), 1.f);
//        return;
//    }
//    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
//    md[@"email"] = [WTUserInfo shareUserInfo].email;
//    md[@"event"] = @"resetpaypass";
//
//    [self.afnetWork jsonGetDict:HTTP_SEND_EMS JsonDict:md Tag:@"1"];
}

/// 提交修改
-(void)submitClick{
    if(![_newPwd isEqualToString:_newPwd2]){
        printAlert(LocalizationKey(@"changeLoginPwdTip13"), 1.f);
        return;
    }
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
//    md[@"email"] = [WTUserInfo shareUserInfo].email;
    md[@"paypass"] = _newPwd;
    md[@"captcha"] = _captcha;
    md[@"confirm_paypass"] = _newPwd2;
    [self.afnetWork jsonGetDict:@"/api/user/retrievePaypass" JsonDict:md Tag:@"2"];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        SettingUpdateFormCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        [[HelpManager sharedHelpManager] sendVerificationCode:cell.rightButton];
        
    }else{
        printAlert(dict[@"msg"], 1.f);
        
        WTUserInfo *userInfo = [WTUserInfo shareUserInfo];
        userInfo.paypass = _newPwd;
        [WTUserInfo saveUser:userInfo]; 
        [self closeVC];
    }
}

#pragma mark - initViewDelegate
- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"578Tip120");
}

- (void)createUI{
    SettingUpdateHeaderView *headerView = [[SettingUpdateHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50) changeTitle:self.gk_navigationItem.title];
    self.tableView.tableHeaderView = headerView;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    
    _bottomView = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    [_bottomView.submitButton setTitle:LocalizationKey(@"578Tip140") forState:UIControlStateNormal];
    [_bottomView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = _bottomView;
    [self.view addSubview:self.tableView];
    self.tableView.bounces = NO;
}

- (void)initData{
    self.dataArray = @[@{@"title":@"578Tip131",@"details":@"578Tip132",@"rightBtnImage":@"icon-test",@"isSafeInput":@"1"},
    @{@"title":@"578Tip133",@"details":@"578Tip134",@"rightBtnImage":@"icon-test",@"isSafeInput":@"1"},
    @{@"title":@"googleVerificationTip8",@"details":@"googleVerificationTip18",@"rightBtnTitle":@"googleVerificationTip14",},
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
    if(indexPath.row<2){
        [cell.rightButton addTarget:self action:@selector(secureTextEntrySwitch:) forControlEvents:UIControlEventTouchUpInside];
        cell.loginInputView.keyboardType = UIKeyboardTypeDefault ;
    }else if(indexPath.row == 2){
        [cell.rightButton addTarget:self action:@selector(getCaptchaClick) forControlEvents:UIControlEventTouchUpInside];
        cell.loginInputView.keyboardType = UIKeyboardTypeNumberPad;
        _googleCodeField = cell.loginInputView;
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
            _newPwd = textField.text;
            break;
        case 1:
            _newPwd2 = textField.text;
            break;
        case 2:
            _captcha = textField.text;
            break;
        default:
            break;
    }
    if(_newPwd.length && _newPwd2.length && _captcha.length){
        _bottomView.submitButton.enabled = YES;
    }else{
        _bottomView.submitButton.enabled = YES;
    }
}
@end
