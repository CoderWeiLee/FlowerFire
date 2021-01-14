//
//  FFVerifyEmailViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/25.
//  Copyright © 2020 Celery. All rights reserved.
//  验证邮箱

#import "FFVerifyEmailViewController.h"
#import "SettingUpdateSubmitButton.h"
#import "RegisteredTableViewCell.h"
#import "LoginViewController.h"
#import "FFAcountManager.h"
 
#define KEY_UUID_DATA [UIApplication sharedApplication].appBundleID
#define KEY_UUID_TEXT @"UUID_TEXT"

@interface FFVerifyEmailViewController ()
{
    NSString *_email,*_captcha;
    SettingUpdateSubmitButton *_nextButton;
}
@end

@implementation FFVerifyEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self createUI];
    
}

/// 下一步注册
-(void)submitClick{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:5];
    md[@"username"] = self.registeredParamsModel.username;
    md[@"mnemonic"] = self.registeredParamsModel.mnemonic;
    md[@"email"]    = _email;
    md[@"captcha"]  = _captcha;
    md[@"device_number"] = [self getUUID];
    NSLog(@"IDFV:%@",[self getUUID]);
    [self.afnetWork jsonPostDict:@"/api/user/register" JsonDict:md Tag:@"2"];
    
}
//78F5032D-388D-4AFB-8401-1BF5BD48D236

//chuangke4589230@dingtalk.com
//jjuBRxfvcVt0YMYNPt6NAawUL09qxjpT0EBKUcm2N0N49w2yRAS1kZP+X+gew4O9ez34qhmkl1raQULjWgqzyz0hG1nYH3u0tTqvfRGrzxk=
-(void)getCaptchaClick{ //邮箱验证码
    if(![[UniversalViewMethod sharedInstance] checkEmail:_email]){
        printAlert(LocalizationKey(@"changeEmailTip5"), 1.f);
        return;
    }
    
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"email"] = _email;
    md[@"event"] = @"register";
    
    [self.afnetWork jsonGetDict:HTTP_SEND_EMS JsonDict:md Tag:@"1"];
}


- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        RegisteredTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataArray.count-1 inSection:0]];
        [[HelpManager sharedHelpManager] sendVerificationCode:cell.textField.rightButton];
    }else{
        printAlert(dict[@"msg"], 1.f);
        
        [WTUserInfo getuserInfoWithDic:dict[@"data"][@"userinfo"]];
         
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:4];
        md[@"username"] = self.registeredParamsModel.username;
        md[@"type"] = @(1); // type 0 密码登录 1 助记词 2 私钥
        md[@"pwd"] = self.registeredParamsModel.mnemonic;
        [[FFAcountManager sharedInstance] saveUserAccount:md];
        
        [self.navigationController popToRootViewControllerAnimated:YES];
       
        [[NSNotificationCenter defaultCenter] postNotificationName:LOGIN_SUCCESS_NOTIFICATION object:nil userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:SWITCH_ACCOUNT_SUCCESS_NOTIFICATION object:nil userInfo:nil];
//        [[WTPageRouterManager sharedInstance] popToViewController:self.navigationController ToViewController:[LoginViewController class]];
        
    }
}


- (void)createUI{
    UIView *bacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/4)];
    [self.view addSubview:bacView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(LoginModuleLeftSpace, ScreenHeight / 7+80 - Height_NavBar, ScreenWidth - 2 * LoginModuleLeftSpace, 30)];
    title.text = LocalizationKey(@"578Tip108");
    title.font = [UIFont boldSystemFontOfSize:25];
    title.theme_textColor = THEME_TEXT_COLOR;
    [bacView addSubview:title];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
    _nextButton = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    [_nextButton.submitButton setTitle:LocalizationKey(@"578Tip111") forState:UIControlStateNormal];
    [bottomView addSubview:_nextButton];
    
    self.tableView.tableHeaderView = bacView;
    self.tableView.tableFooterView = bottomView;
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight-Height_NavBar);
    [self.view addSubview:self.tableView];
     
    [_nextButton.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initData{
    self.dataArray = @[
                       @{@"details":@"registeredTip3"},
                        ].copy;
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[RegisteredTableViewCell class] forCellReuseIdentifier:identifier];
    RegisteredTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setCellData:self.dataArray[indexPath.row]];
    cell.textField.loginInputView.tag = indexPath.row;
    [cell.textField.loginInputView addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
//    if(indexPath.row == self.dataArray.count-1){
//        [cell.textField.rightButton addTarget:self action:@selector(getCaptchaClick) forControlEvents:UIControlEventTouchUpInside];
//        cell.textField.loginInputView.keyboardType = UIKeyboardTypeNumberPad;
//    }else{
        cell.textField.loginInputView.keyboardType = UIKeyboardTypeEmailAddress;
//    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 71;
}
 
- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
        {
            _email = textField.text;
        }
            break;
    }
    if(_email.length){
        _nextButton.submitButton.enabled = YES;
    }else{
        _nextButton.submitButton.enabled = NO;
    }
    
}

#pragma mark - priveteMethod
- (NSString *)getUUID {
    NSString *UUIDString = @"";
    NSDictionary *UUID_Dict = (NSDictionary *)[ToolUtil load:KEY_UUID_DATA];
    if ([UUID_Dict.allKeys containsObject:KEY_UUID_TEXT]) {
        UUIDString = UUID_Dict[KEY_UUID_TEXT];
    }else {
        //没有就获取
        UUIDString = [UIDevice currentDevice].identifierForVendor.UUIDString;
        //保存
        [ToolUtil save:KEY_UUID_DATA data:@{KEY_UUID_TEXT:UUIDString}];
    }
    NSLog(@"UUIDString:%@",UUIDString);
    return UUIDString;
}

@end
