//
//  LoginViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "MallLoginViewController.h"
#import "RegisterViewController.h"
#import "MallForgetPwdViewController.h"
#import "LoginCell.h"
#import "PooCodeView.h"
#import <UIButton+YYWebImage.h>
#import "UserProtocolTextView.h"

NSNotificationName const CloseLoginVCNotice = @"CloseLoginVCNotice";

@interface MallLoginViewController ()
{
    NSString *_phoneStr;
    NSString *_codeStr;
    NSString *_pwdStr;
}
@property(nonatomic, strong)NSString *encryptCode;
@property(nonatomic, strong)UserProtocolTextView *userProtocolTextView;

@end

@implementation MallLoginViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:CloseLoginVCNotice object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
     
}

- (void)createNavBar{
    self.gk_navigationBar.hidden = YES;
}

- (void)createUI{
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    UIImageView *bacImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg5"]];
    bacImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.tableView.backgroundView = bacImageView;
    [self.view addSubview:self.tableView];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, ceil(ScreenHeight / 2.5 - Height_StatusBar))];
    UIImageView *logoImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    logoImage.frame = CGRectMake(64, headerView.height - 63 - ceil(ScreenHeight / 6.66) , ceil(ScreenHeight / 6.66), ceil(ScreenHeight / 6.66));
    [headerView addSubview:logoImage];
  
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.titleLabel.font = tFont(15);
    [backButton setTitle:@"关闭" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(closeVC) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(OverAllLeft_OR_RightSpace, OverAllLeft_OR_RightSpace, 100, 40);
    [backButton sizeToFit];
    [headerView addSubview:backButton];
     
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton setTitleColor:rgba(74, 74, 74, 1) forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:tFont(16)];
    loginButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.8];
    loginButton.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:85/255.0 blue:190/255.0 alpha:0.14].CGColor;
    loginButton.layer.shadowOffset = CGSizeMake(-4,6);
    loginButton.layer.shadowOpacity = 1;
    loginButton.layer.shadowRadius = 11;
    loginButton.layer.cornerRadius = 20.5;
    [bottomView addSubview:loginButton];
    loginButton.frame = CGRectMake(47.5, 30, ScreenWidth - 47.5 * 2, 41);
    
    UIButton *forgetPwdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetPwdButton setTitle:@"忘记密码" forState:UIControlStateNormal];
    forgetPwdButton.titleLabel.font = tFont(13);
    [bottomView addSubview:forgetPwdButton];
    forgetPwdButton.frame = CGRectMake(loginButton.ly_x + 20.5, loginButton.ly_maxY + 13, 100, 40);
    forgetPwdButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    forgetPwdButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    bottomView.height = forgetPwdButton.ly_maxY;
    [bottomView addSubview:forgetPwdButton];
    
    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [registerButton setTitle:@"注册账号" forState:UIControlStateNormal];
    registerButton.titleLabel.font = tFont(13);
    [bottomView addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(loginButton.mas_right).offset(-20.5);
        make.top.mas_equalTo(forgetPwdButton.mas_top);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    [registerButton.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(forgetPwdButton.titleLabel.mas_centerY);
    }];
    
    registerButton.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    registerButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    [loginButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [registerButton addTarget:self action:@selector(jumpRegisterVC) forControlEvents:UIControlEventTouchUpInside];
    [forgetPwdButton addTarget:self action:@selector(jumpForgetPwdVC) forControlEvents:UIControlEventTouchUpInside];
    
    self.userProtocolTextView = [[UserProtocolTextView alloc] initWithFrame:CGRectMake(0, ScreenHeight - SafeAreaBottomHeight - 10 - 30, ScreenWidth, 30)];
    [self.view addSubview:self.userProtocolTextView];
    
    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = bottomView;
}

-(void)initData{
    self.dataArray = @[@{@"placeholderStr":@"请输入手机号",@"keyBoardType":@"phone"},
                       @{@"placeholderStr":@"请输入验证码",@"rightView":@"imageCode",@"getCode":@"1"},
                       @{@"placeholderStr":@"请输入密码",@"isSafeInput":@"1"}].copy;
     
}

#pragma mark - action
-(void)loginClick{
    if(_codeStr && _phoneStr && _pwdStr){
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        md[@"username"] = _phoneStr;
        md[@"password"] = _pwdStr;
        md[@"verify_code"] = _codeStr;
        md[@"encrypt_code"] = self.encryptCode;
        md[@"is_tick"] = @"1";   //用户协议 0未选中，1选中
        [self.afnetWork jsonMallPostDict:@"/api/login/login" JsonDict:md Tag:@"1"];
    }else{
        printAlert(@"请填写完整信息", 1.f);
    }
 
     
}

#pragma mark - netBack
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    [WTMallUserInfo getuserInfoWithDic:dict[@"result"]];
    int userId = [[WTMallUserInfo shareUserInfo].ID intValue];
    
    [self closeVC];
     [[WTPageRouterManager sharedInstance] jumpMallTabBarController:0];
//    [[WTPageRouterManager sharedInstance] LoginSuccessCreateNewMallTabBar:NSStringFromClass([self class])];
}

-(void)jumpRegisterVC{
    RegisterViewController *rvc = [RegisterViewController new];
    [self.navigationController pushViewController:rvc animated:YES];
}

-(void)jumpForgetPwdVC{
    MallForgetPwdViewController *rvc = [MallForgetPwdViewController new];
    [self.navigationController pushViewController:rvc animated:YES];
}
 
#pragma makr - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[LoginCell class] forCellReuseIdentifier:identifier];
    LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setLoginCellData:self.dataArray[indexPath.row]];
    cell.backgroundColor = [UIColor clearColor];
    cell.loginInputView.backgroundColor = rgba(255, 255, 255, 0.8);
    cell.loginInputView.layer.cornerRadius = 20.5;
    cell.loginInputView.layer.masksToBounds = YES;
    cell.loginInputView.tag = indexPath.row;
    [cell.loginInputView addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
     
    @weakify(self)
    cell.getImageCodeBlock = ^(UIButton * view) {
        [MBManager showLoading];
        [[ReqestHelpManager share] requestMallPost:@"/api/login/getVerifyCode" andHeaderParam:nil finish:^(NSDictionary *dicForData, ReqestType flag) {
            @strongify(self)
            [MBManager hideAlert];
            [view setTitle:@"" forState:UIControlStateNormal];
            [view yy_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dicForData[@"image"]]] forState:UIControlStateNormal placeholder:nil];
            self.encryptCode = dicForData[@"encryptCode"];
        }];
    };
    
    //直接显示验证码
    if([self.dataArray[indexPath.row][@"getCode"] isEqualToString:@"1"]){
        for (UIView *button in cell.loginInputView.rightView.subviews) {
            if([button isKindOfClass:[UIButton class]]){
                !cell.getImageCodeBlock ? : cell.getImageCodeBlock((UIButton *)button);
            }
        }
    
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45 +  1 * OverAllLeft_OR_RightSpace;
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            _phoneStr = textField.text;
            break;
        case 1:
            _codeStr = textField.text;
            break;
        case 2:
            _pwdStr = textField.text;
            break;
    }
}

@end
