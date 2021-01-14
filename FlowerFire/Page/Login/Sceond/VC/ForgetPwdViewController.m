//
//  ForgetPwdViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/14.
//  Copyright © 2020 Celery. All rights reserved.
//  忘记密码

#import "ForgetPwdViewController.h" 
#import "SettingUpdateHeaderView.h"
#import "SettingUpdateFormCell.h"
#import "SettingUpdateSubmitButton.h"

@interface ForgetPwdViewController ()
{
    NSString *_email;
    NSString *_newPwd;
    NSString *_newPwd2;
    NSString *_captcha;
    
    SettingUpdateSubmitButton *_bottomView;
}
@end

@implementation ForgetPwdViewController

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
    if([HelpManager isBlankString:_email] ||
       [HelpManager isBlankString:_newPwd2] ||
       [HelpManager isBlankString:_newPwd]){
        printAlert(LocalizationKey(@"changeLoginPwdTip14"), 1.f);
        return;
    }
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"email"] = _email;
    md[@"event"] = @"resetpwd";
    
    [self.afnetWork jsonGetDict:HTTP_SEND_EMS JsonDict:md Tag:@"1"];
}

/// 提交修改
-(void)submitClick{
    if(![_newPwd isEqualToString:_newPwd2]){
        printAlert(LocalizationKey(@"changeLoginPwdTip13"), 1.f);
        return;
    }
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:4];
    md[@"email"] = _email;
    md[@"newpassword"] = _newPwd2;
    md[@"captcha"] = _captcha;
    md[@"type"] = @"email";
    [self.afnetWork jsonGetDict:@"/api/user/resetpwd" JsonDict:md Tag:@"2"];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        SettingUpdateFormCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]];
        [[HelpManager sharedHelpManager] sendVerificationCode:cell.rightButton];
    }else{
        printAlert(dict[@"msg"], 1.f);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - initViewDelegate
- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"forgetPwdTip5");
}

- (void)createUI{
    SettingUpdateHeaderView *headerView = [[SettingUpdateHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50) changeTitle:self.gk_navigationItem.title];
    self.tableView.tableHeaderView = headerView;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    
    _bottomView = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    [_bottomView.submitButton setTitle:LocalizationKey(@"determine") forState:UIControlStateNormal];
    [_bottomView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = _bottomView;
    [self.view addSubview:self.tableView];
     
}

- (void)initData{
    self.dataArray = @[@{@"title":@"forgetPwdTip6",@"details":@"forgetPwdTip7", },
    @{@"title":@"forgetPwdTip1",@"details":@"forgetPwdTip2",@"rightBtnImage":@"icon-test",@"isSafeInput":@"1"},
    @{@"title":@"forgetPwdTip3",@"details":@"forgetPwdTip4",@"rightBtnImage":@"icon-test",@"isSafeInput":@"1"},
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
    if(indexPath.row<3){
        [cell.rightButton addTarget:self action:@selector(secureTextEntrySwitch:) forControlEvents:UIControlEventTouchUpInside];
        cell.loginInputView.keyboardType = UIKeyboardTypeDefault ;
    }else{
        [cell.rightButton addTarget:self action:@selector(getCaptchaClick) forControlEvents:UIControlEventTouchUpInside];
        cell.loginInputView.keyboardType = UIKeyboardTypeNumberPad;
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
        case 1:
            _newPwd = textField.text;
            break;
        case 2:
            _newPwd2 = textField.text;
            break;
        default:
            _captcha = textField.text;
            break;
    }
    if(_email.length && _newPwd.length && _newPwd2.length && _captcha.length){
        _bottomView.submitButton.enabled = YES;
    }else{
        _bottomView.submitButton.enabled = NO;
    }
}
 

@end
