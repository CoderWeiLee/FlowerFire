//
//  ForgetPwdViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "MallForgetPwdViewController.h"
#import "LoginCell.h"
#import "UIImage+jianbianImage.h"
#import <UIButton+YYWebImage.h>

@interface MallForgetPwdViewController ()
{
    NSString *_phoneStr;
    NSString *_codeStr,*_imageCodeStr;
    NSString *_newPwdStr;
    NSString *_newPwdStr2;
}
@property(nonatomic, strong)NSString             *encryptCode;
@end

@implementation MallForgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
    self.gk_navigationItem.title = @"重置密码";
}

- (void)createUI{
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, Height_NavBar+15, ScreenWidth, ScreenHeight-Height_NavBar - 15);
     
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 75)];
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setTitle:@"确定修改" forState:UIControlStateNormal];
    CGSize buttonSize = CGSizeMake(ScreenWidth - 45 * 2, 40);
    [submitButton setBackgroundImage:[UIImage gradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight imgSize:buttonSize] forState:UIControlStateNormal];
    submitButton.layer.shadowColor = [UIColor colorWithRed:255/255.0 green:115/255.0 blue:80/255.0 alpha:0.35].CGColor;
    submitButton.layer.shadowOffset = CGSizeMake(0,2);
    submitButton.layer.shadowOpacity = 1;
    submitButton.layer.shadowRadius = 4;
    submitButton.layer.cornerRadius = 20;
    submitButton.layer.masksToBounds = YES;
    submitButton.titleLabel.font = tFont(15);
    submitButton.frame = CGRectMake(45, 75-buttonSize.height,buttonSize.width,buttonSize.height);
    [bottomView addSubview:submitButton];
    
    [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = bottomView;
    [self.view addSubview:self.tableView];
    
}

-(void)initData{
    self.dataArray = @[@{@"placeholderStr":@"请输入手机号码",@"keyBoardType":@"phone"},
                       @{@"placeholderStr":@"请输入图形验证码",@"rightView":@"imageCode",@"getCode":@"1"},
                       @{@"placeholderStr":@"请输入验证码",@"rightView":@"phoneCode"},
                       @{@"placeholderStr":@"请输入新密码",@"isSafeInput":@"1"},
                       @{@"placeholderStr":@"请确认新密码",@"isSafeInput":@"1"}].copy;
}

#pragma mark - action
-(void)submitClick{
    if(![_newPwdStr isEqualToString:_newPwdStr2]){
        printAlert(@"两次输入不一致", 1.f);
        return;
    }
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:4];
    md[@"mobile"] = _phoneStr;
    md[@"validate_code"] = _codeStr;
    md[@"password"] = _newPwdStr;
    md[@"password_passc"] = _newPwdStr2;
    
    [self.afnetWork jsonMallPostDict:@"/api/login/forgetPassByMobile" JsonDict:md Tag:@"1"];
}

#pragma mark - netData
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        printAlert(dict[@"msg"], 1.f);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        
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
            _phoneStr = textField.text;
            break;
        case 1:
            _imageCodeStr = textField.text;
            break;
        case 2:
            _codeStr = textField.text;
            break;
        case 3:
            _newPwdStr = textField.text;
            break;
        default:
            _newPwdStr2 = textField.text;
            break;
    }
}

@end
