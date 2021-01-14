//
//  RegisteredViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/14.
//  Copyright © 2020 Celery. All rights reserved.
//。注册页面

#import "RegisteredViewController.h"
#import "RegisteredTableViewCell.h"
#import "SettingUpdateSubmitButton.h"
#import "FFSaveMnemonicViewController.h"
#import "FFRegisteredParamsModel.h"

@interface RegisteredViewController ()
{
    NSString *_username;
    SettingUpdateSubmitButton *_nextButton;
}
@end

@implementation RegisteredViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    [self initData];
    
}


/// 下一步
-(void)submitClick{
    if([[UniversalViewMethod sharedInstance] checkIsHaveNumAndLetter:_username] == 3){
         //获取一波助记词
           NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:1];
           md[@"username"] = _username;
           [self.afnetWork jsonPostDict:@"/api/user/getMnemonic" JsonDict:md Tag:@"1"];
    }else{
        printAlert(LocalizationKey(@"578Tip44"), 1.f);
    }
   
//    if([_pwd1 isEqualToString:_pwd2]){
//
//
//    }else{
//        printAlert(LocalizationKey(@"changeLoginPwdTip13"), 1.f);
//    }
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        NSString *mnemonic = dict[@"data"][@"mnemonic"];
        if(![HelpManager isBlankString:mnemonic]){
            FFRegisteredParamsModel *model = [FFRegisteredParamsModel new];
            model.username = _username;
            model.password = @"";
            model.mnemonic = mnemonic;
            FFSaveMnemonicViewController *r = [FFSaveMnemonicViewController new];
            r.registeredParamsModel = model;
            [self.navigationController pushViewController:r animated:YES];
        }
    }
}



- (void)createUI{
    UIView *bacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/4)];
    [self.view addSubview:bacView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(LoginModuleLeftSpace, ScreenHeight / 7+80 - Height_NavBar, ScreenWidth - 2 * LoginModuleLeftSpace, 80)];
    title.text = LocalizationKey(@"registeredTip7");
    title.font = [UIFont boldSystemFontOfSize:25];
    title.theme_textColor = THEME_TEXT_COLOR;
    title.numberOfLines = 2;
    [bacView addSubview:title];
     
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 140)];
    _nextButton = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 100)];
    [_nextButton.submitButton setTitle:LocalizationKey(@"registeredTip4") forState:UIControlStateNormal];
    [bottomView addSubview:_nextButton];
    
    UIButton *privacyAgreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomView addSubview:privacyAgreementButton];
    privacyAgreementButton.frame = CGRectMake(_nextButton.submitButton.ly_x + 20, _nextButton.ly_maxY + 10, ScreenWidth - LoginModuleLeftSpace * 2 - 20 * 2, 30);
    [privacyAgreementButton.titleLabel setAdjustsFontSizeToFitWidth:YES];
     
    NSString *leftStr = LocalizationKey(@"registeredTip5");
    NSString *rightStr = LocalizationKey(@"registeredTip8");
    NSString *titleStr = NSStringFormat(@"%@%@",leftStr,rightStr);
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [attr addAttributes:@{NSForegroundColorAttributeName:MainColor} range:NSMakeRange(leftStr.length, rightStr.length)];
    [attr addAttributes:@{SDThemeForegroundColorAttributeName:THEME_GRAY_TEXTCOLOR} range:NSMakeRange(0,leftStr.length)];
    [privacyAgreementButton setAttributedTitle:attr forState:UIControlStateNormal];
    privacyAgreementButton.hidden = YES;
    
    UIButton *jumpLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:jumpLoginButton];
    jumpLoginButton.frame = CGRectMake(0, ScreenHeight - SafeIS_IPHONE_X - 20, ScreenWidth, 30);
    [jumpLoginButton.titleLabel setFont:tFont(12)];
     
    leftStr = LocalizationKey(@"registeredTip9");
    rightStr = LocalizationKey(@"registeredTip10");
    titleStr = NSStringFormat(@"%@%@",leftStr,rightStr);
    attr = [[NSMutableAttributedString alloc] initWithString:titleStr];
    [attr addAttributes:@{NSForegroundColorAttributeName:MainColor} range:NSMakeRange(leftStr.length, rightStr.length)];
    [attr addAttributes:@{SDThemeForegroundColorAttributeName:THEME_GRAY_TEXTCOLOR} range:NSMakeRange(0,leftStr.length)];
    [jumpLoginButton setAttributedTitle:attr forState:UIControlStateNormal];
    jumpLoginButton.hidden = YES;
    
    self.tableView.tableHeaderView = bacView;
    self.tableView.tableFooterView = bottomView;
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight-Height_NavBar);
    [self.view addSubview:self.tableView];
    
    [self.view bringSubviewToFront:jumpLoginButton];
    
    @weakify(self)
    [privacyAgreementButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        NSString *protocolURLStr = NSStringFormat(@"%@/web/#/help/articlelist/9",BASE_URL);
        [[WTPageRouterManager sharedInstance] jumpToWebView:self.navigationController urlString:protocolURLStr];
    }];
    
    [jumpLoginButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [_nextButton.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initData{
    self.dataArray = @[@{@"details":@"registeredTip1"},].copy;
}

#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[RegisteredTableViewCell class] forCellReuseIdentifier:identifier];
    RegisteredTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setCellData:self.dataArray[indexPath.row]];
    cell.textField.loginInputView.tag = indexPath.row;
    [cell.textField.loginInputView addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
     
    cell.textField.loginInputView.secureTextEntry = NO;
    
    
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
            _username = textField.text;
            break;
    }
    if(_username.length){
        _nextButton.submitButton.enabled = YES;
    }else{
        _nextButton.submitButton.enabled = NO;
    }
    
}



@end
