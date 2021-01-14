//
//  RegisteredSetPwdViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/14.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "RegisteredSetPwdViewController.h"
#import "SettingUpdateHeaderView.h"
#import "SettingUpdateFormCell.h"
#import "SettingUpdateSubmitButton.h"
#import "LoginViewController.h"

@interface RegisteredSetPwdViewController ()
{
    NSString *_newPwd;
    NSString *_newPwd2;
    SettingUpdateSubmitButton *_bottomView;
}
@end

@implementation RegisteredSetPwdViewController

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

/// 注册
-(void)submitClick{
    if(![_newPwd isEqualToString:_newPwd2]){
        printAlert(LocalizationKey(@"changeLoginPwdTip13"), 1.f);
        return;
    }
    
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
    md[@"username"] = self.userNameStr;
    md[@"password"] = _newPwd;
    md[@"pid"] = @"";
    md[@"email"] = self.emailStr;
    md[@"mobile"] = @"";
     
    [self.afnetWork jsonGetDict:@"/api/user/register" JsonDict:md Tag:@"2"];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    printAlert(dict[@"msg"], 1.f);
   //回到登录页面
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - initViewDelegate
- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"registeredTip15");
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    
    _bottomView = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    [_bottomView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = _bottomView;
    [self.view addSubview:self.tableView];
     
}

- (void)initData{
    self.dataArray = @[@{@"title":@"registeredTip11",@"details":@"registeredTip12",@"rightBtnImage":@"icon-test",@"isSafeInput":@"1"},
    @{@"title":@"registeredTip13",@"details":@"registeredTip14",@"rightBtnImage":@"icon-test",@"isSafeInput":@"1"}, ].copy;
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
            _newPwd = textField.text;
            break;
        case 1:
            _newPwd2 = textField.text;
            break;
        default:
            break;
    }
    if(_newPwd.length && _newPwd2.length){
        _bottomView.submitButton.enabled = YES;
    }else{
        _bottomView.submitButton.enabled = NO;
    }
}


@end
