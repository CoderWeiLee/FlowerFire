//
//  ChangeFundPasswordViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/13.
//  Copyright © 2020 Celery. All rights reserved.
//  修改资金密码

#import "ChangeFundPasswordViewController.h"
#import "SettingUpdateHeaderView.h"
#import "SettingUpdateFormCell.h"
#import "SettingUpdateSubmitButton.h"

@interface ChangeFundPasswordViewController ()
{
    NSString *_oldPwd;
    NSString *_newPwd;
    NSString *_newPwd2;
    
    SettingUpdateSubmitButton *_bottomView;
}
@end

@implementation ChangeFundPasswordViewController

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
    if([HelpManager isBlankString:_oldPwd] ||
       [HelpManager isBlankString:_newPwd2] ||
       [HelpManager isBlankString:_newPwd]){
        printAlert(LocalizationKey(@"changeLoginPwdTip14"), 1.f);
        return;
    }
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"email"] = [WTUserInfo shareUserInfo].email;
    md[@"event"] = @"resetpaypass";
    
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
    md[@"confirm_password"] = _newPwd2;
    md[@"type"] = @"pay";
    [self.afnetWork jsonGetDict:@"/api/user/editpwd" JsonDict:md Tag:@"2"];
}
 

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    printAlert(dict[@"msg"], 1.f);
    
    WTUserInfo *userInfo = [WTUserInfo shareUserInfo];
    userInfo.paypass = _newPwd;
    [WTUserInfo saveUser:userInfo];
    
    [self closeVC];
    
}

#pragma mark - initViewDelegate
- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"changeFundPwdTip1");
}

- (void)createUI{
    SettingUpdateHeaderView *headerView = [[SettingUpdateHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50) changeTitle:self.gk_navigationItem.title];
    self.tableView.tableHeaderView = headerView;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    
    _bottomView = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    [_bottomView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = _bottomView;
    [self.view addSubview:self.tableView];
    self.tableView.bounces = NO;
}

- (void)initData{
    self.dataArray = @[@{@"title":@"changeFundPwdTip2",@"details":@"changeFundPwdTip3",@"rightBtnImage":@"icon-test",@"isSafeInput":@"1"},
    @{@"title":@"changeFundPwdTip4",@"details":@"changeFundPwdTip5",@"rightBtnImage":@"icon-test",@"isSafeInput":@"1"},
    @{@"title":@"changeFundPwdTip6",@"details":@"changeFundPwdTip7",@"rightBtnImage":@"icon-test",@"isSafeInput":@"1"},
   
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
