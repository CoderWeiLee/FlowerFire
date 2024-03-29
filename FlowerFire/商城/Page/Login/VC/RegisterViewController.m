//
//  RegisterViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginCell.h"
#import "UserProtocolTextView.h"
#import <UIButton+YYWebImage.h>

@interface RegisterViewController ()
{
    NSString *_userNumer,*_phoneStr,*_loginPwdStr,*_loginPwdStr2;
    NSString *_payPwdStr,*_payPwdStr2,*_herIDStr,*_imageCodeStr,*_codeStr;
}

@property(nonatomic, strong)NSString             *encryptCode;
/// 后台生成的默认会员编号
@property(nonatomic, strong)NSString             *defaultname;
@property(nonatomic, strong)UserProtocolTextView *userProtocolTextView;
@end

@implementation RegisterViewController
 
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{ 
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
    self.gk_navigationItem.title = @"注册";
}

- (void)createUI{
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, Height_NavBar+15, ScreenWidth, ScreenHeight-Height_NavBar - 15);
     
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 125)];
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:@"注册" forState:UIControlStateNormal];
    CGSize buttonSize = CGSizeMake(ScreenWidth - 45 * 2, 40);
    [[HelpManager sharedHelpManager] jianbianMainColor:submitButton size:buttonSize];
    submitButton.layer.shadowColor = [UIColor colorWithRed:255/255.0 green:115/255.0 blue:80/255.0 alpha:0.35].CGColor;
    submitButton.layer.shadowOffset = CGSizeMake(0,2);
    submitButton.layer.shadowOpacity = 1;
    submitButton.layer.shadowRadius = 4;
    submitButton.layer.cornerRadius = 20;
    submitButton.layer.masksToBounds = YES;
    submitButton.titleLabel.font = tFont(15);
    submitButton.frame = CGRectMake(45, 30,buttonSize.width,buttonSize.height);
    [bottomView addSubview:submitButton];
    
    [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.userProtocolTextView = [[UserProtocolTextView alloc] initWithFrame:CGRectMake(0, submitButton.ly_maxY + 20, ScreenWidth, 30)];
    [bottomView addSubview:self.userProtocolTextView];
    
    self.tableView.tableFooterView = bottomView;
    [self.view addSubview:self.tableView];
    
}

-(void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"username"] = @"";
    md[@"type"] = @"1";
    
    [self.afnetWork jsonMallPostDict:@"/api/webmember/register" JsonDict:nil Tag:@"2"];
   
    self.dataArray = @[@{@"placeholderStr":@"请输入会员编号"},
                       @{@"placeholderStr":@"请输入手机号码",@"keyBoardType":@"phone"},
                       @{@"placeholderStr":@"请输入密码",@"isSafeInput":@"1"},
                       @{@"placeholderStr":@"确认密码",@"isSafeInput":@"1"},
                       @{@"placeholderStr":@"请输入支付密码",@"isSafeInput":@"1"},
                       @{@"placeholderStr":@"确认支付密码",@"isSafeInput":@"1"},
                       @{@"placeholderStr":@"推荐人编号" },
                       @{@"placeholderStr":@"请输入图形验证码",@"rightView":@"imageCode",@"getCode":@"1"},
                       @{@"placeholderStr":@"请输入验证码",@"rightView":@"phoneCode"},
                       
                       ].copy;
    
}

#pragma mark - action
-(void)submitClick{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"type"] = @"1";
    md[@"username"] = _userNumer; //会员编号
    md[@"mobile_phone"] = _phoneStr;
    md[@"pass1"] = _loginPwdStr;
    md[@"pass1c"] = _loginPwdStr2;
    md[@"pass2"] = _payPwdStr;
    md[@"pass2c"] = _payPwdStr2;
    md[@"introduce"] = _herIDStr;
    md[@"mobile_code"] = _codeStr;
    md[@"is_tick"] = @"1";  //用户协议 0未选中，1选中
    [self.afnetWork jsonMallPostDict:@"/api/webmember/registersave" JsonDict:md Tag:@"1"];
}
 
#pragma mark - netData
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        printAlert(dict[@"msg"], 1.f);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        if(dict[@"data"] != [NSNull null]){
            if([dict[@"data"] isKindOfClass:[NSDictionary class]]){
                self.defaultname = dict[@"data"][@"defaultname"];
                LoginCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
                cell.loginInputView.text = self.defaultname;
                _userNumer = self.defaultname;
            }
        }
    }
}


#pragma makr - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[LoginCell class] forCellReuseIdentifier:identifier];
    LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setLoginCellData:self.dataArray[indexPath.row]];
    cell.loginInputView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    cell.loginInputView.layer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
    cell.loginInputView.layer.shadowOffset = CGSizeMake(0,5);
    cell.loginInputView.layer.shadowOpacity = 1;
    cell.loginInputView.layer.shadowRadius = 9;
    cell.loginInputView.layer.cornerRadius = 20;
    
    cell.loginInputView.tag = indexPath.row;
    [cell.loginInputView addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    @weakify(self)
    cell.getCodeBlock = ^(UIButton * btn) {
        @strongify(self)
        if([ToolUtil checkPhoneNumInput:self->_phoneStr]){
            if([HelpManager isBlankString:self->_imageCodeStr]){
                printAlert(@"请输入图形验证码", 1.f);
                return;
            }
            NSMutableDictionary *md = [NSMutableDictionary dictionary];
            md[@"verify_code"] = self->_imageCodeStr;
            md[@"encrypt_code"] = self.encryptCode;
            md[@"content_type"] = @"1";
            md[@"mobile"] = self->_phoneStr; 
            [self.afnetWork jsonMallPostDict:@"/api/login/mobileVerify" JsonDict:md Tag:@"1000"];
            [[HelpManager sharedHelpManager] sendVerificationCode:btn];
        }else{
            printAlert(@"请输入正确的手机号", 1.f);
        };
    };
     
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
            _userNumer = textField.text;
            break;
        case 1:
            _phoneStr = textField.text;
            break;
        case 2:
            _loginPwdStr = textField.text;
            break;
        case 3:
            _loginPwdStr2 = textField.text;
            break;
        case 4:
            _payPwdStr = textField.text;
            break;
        case 5:
            _payPwdStr2 = textField.text;
            break;
        case 6:
            _herIDStr = textField.text;
            break;
        case 7:
            _imageCodeStr = textField.text;
        default:
            _codeStr = textField.text;
            break;
    }
}

@end
