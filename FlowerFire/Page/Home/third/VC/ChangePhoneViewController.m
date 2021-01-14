//
//  ChangePhoneViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/13.
//  Copyright © 2020 Celery. All rights reserved.
//。修改手机号

#import "ChangePhoneViewController.h"
#import "SettingUpdateHeaderView.h"
#import "SettingUpdateFormCell.h"
#import "SettingUpdateSubmitButton.h"
#import "MainTabBarController.h"

@interface ChangePhoneViewController ()
{
    NSString *_phone;
    NSString *_captcha;
    SettingUpdateFormCell     *cell;
    SettingUpdateSubmitButton *_bottomView;
}
@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self createNavBar];
    [self createUI];
    [self initData];
}

#pragma mark - action
-(void)getCaptchaClick{ //手机验证码
    if(![[UniversalViewMethod sharedInstance] checkPhone:_phone]){
        printAlert(LocalizationKey(@"changePhoneTip5"), 1.f);
        return;
    }
    
    //TODO:没有手机验证码
    SettingUpdateFormCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]];
    cell.loginInputView.text = @"777777";
    _captcha = @"777777";
    return;
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"email"] = _phone;
    md[@"event"] = @"changeemail";
    
    [self.afnetWork jsonGetDict:HTTP_SEND_EMS JsonDict:md Tag:@"1"];
}

/// 提交修改
-(void)submitClick{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"mobile"] = _phone;
    md[@"captcha"] = _captcha;
    [self.afnetWork jsonGetDict:@"/api/user/changemobile" JsonDict:md Tag:@"2"];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        SettingUpdateFormCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]];
        [[HelpManager sharedHelpManager] sendVerificationCode:cell.rightButton];
    }else{
        printAlert(dict[@"msg"], 1.f);
        MainTabBarController *tabViewController = (MainTabBarController *)[MainTabBarController cyl_tabBarController];
        tabViewController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:NO];
         
    }
}

- (void)createNavBar{
    self.gk_navigationBar.hidden = NO;
    self.gk_navigationItem.title = LocalizationKey(@"changePhoneTip1");
}

- (void)createUI{
    SettingUpdateHeaderView *headerView = [[SettingUpdateHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50) changeTitle:self.gk_navigationItem.title];
    self.tableView.tableHeaderView = headerView;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    
    _bottomView = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
    [_bottomView.submitButton setTitle:LocalizationKey(@"changePhoneTip4") forState:UIControlStateNormal];
    [_bottomView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    self.tableView.tableFooterView = _bottomView;
    [self.view addSubview:self.tableView];
     
}

- (void)initData{
    self.dataArray = @[@{@"title":@"changePhoneTip2",@"details":@"changePhoneTip3"},
    @{@"title":@"changePhoneTip6",@"details":@"changePhoneTip7",@"rightBtnTitle":@"changeLoginPwdTip12",},
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
        cell.loginInputView.keyboardType = UIKeyboardTypePhonePad;
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
            _phone = textField.text;
            break;
        default:
            _captcha = textField.text;
            break;
    }
    if(_phone.length){
        _bottomView.submitButton.enabled = YES;
    }else{
        _bottomView.submitButton.enabled = NO;
    }
}



@end
