//
//  ChangeLoginPwdViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/4.
//  Copyright © 2020 Celery. All rights reserved.
//。修改登录密码

#import "ChangeLoginPwdViewController.h"
#import "SettingUpdateHeaderView.h"
#import "SettingUpdateFormCell.h"
#import "SettingUpdateSubmitButton.h" 

@interface ChangeLoginPwdViewController ()
{
    NSString *_oldPwd;
    NSString *_newPwd;
    NSString *_newPwd2;
    SettingUpdateSubmitButton *_bottomView;
}
@end

@implementation ChangeLoginPwdViewController

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
    if([HelpManager isBlankString:_oldPwd] || [HelpManager isBlankString:_newPwd2] || [HelpManager isBlankString:_newPwd]){
        printAlert(LocalizationKey(@"changeLoginPwdTip14"), 1.f);
        return;
    }
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"email"] = [WTUserInfo shareUserInfo].email;
    md[@"event"] = @"resetpwd";
    
    [self.afnetWork jsonGetDict:HTTP_SEND_EMS JsonDict:md Tag:@"1"];
}

/// 提交修改
-(void)submitClick{
    if(![_newPwd isEqualToString:_newPwd2]){
        printAlert(LocalizationKey(@"changeLoginPwdTip13"), 1.f);
        return;
    }
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
    md[@"oldpassword"] = _oldPwd; //旧密码
    md[@"newpassword"] = _newPwd;
    md[@"type"] = @"login";
    [self.afnetWork jsonGetDict:@"/api/user/editpwd" JsonDict:md Tag:@"2"];
}

//changeLoginPwdTip1
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    printAlert(dict[@"msg"], 1.f);
    [self closeVC];
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        [WTUserInfo logout];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [[WTPageRouterManager sharedInstance] jumpTabBarController:0];
//            [self.navigationController popToRootViewControllerAnimated:YES];
//            //发退出通知
//            [[NSNotificationCenter defaultCenter] postNotificationName:EXIT_LOGIN_NOTIFICATION object:nil userInfo:nil];
//        });
//    });

}

#pragma mark - initViewDelegate
- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"changeLoginPwdTip1");
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
    self.dataArray = @[@{@"title":@"changeLoginPwdTip3",@"details":@"changeLoginPwdTip4",@"rightBtnImage":@"icon-test",@"isSafeInput":@"1"},
    @{@"title":@"changeLoginPwdTip5",@"details":@"changeLoginPwdTip6",@"rightBtnImage":@"icon-test",@"isSafeInput":@"1"},
    @{@"title":@"changeLoginPwdTip7",@"details":@"changeLoginPwdTip8",@"rightBtnImage":@"icon-test",@"isSafeInput":@"1"},
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
    
    [cell.rightButton addTarget:self action:@selector(secureTextEntrySwitch:) forControlEvents:UIControlEventTouchUpInside];
    cell.loginInputView.keyboardType = UIKeyboardTypeDefault;

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
            _oldPwd = textField.text;
            break;
        case 1:
            _newPwd = textField.text;
            break;
        case 2:
            _newPwd2 = textField.text;
            break;
    }
    if(_oldPwd.length && _newPwd.length && _newPwd2.length){
        _bottomView.submitButton.enabled = YES;
    }else{
        _bottomView.submitButton.enabled = NO;
    }
}

@end
