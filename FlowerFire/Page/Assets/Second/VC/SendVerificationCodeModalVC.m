//
//  SendVerificationCodeModalVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/7/5.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "SendVerificationCodeModalVC.h"
#import "BindGoogleVerificationViewController.h"

static CGFloat const viewHeight = 260;

@interface SendVerificationCodeModalVC ()
{
    UIButton *_submitBtn;
 
    UIButton *_sendBtn;
 
}
@property(nonatomic, strong)UITextField *googleCodeField;
@end

@implementation SendVerificationCodeModalVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.gk_navigationBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
     
    [self setUpView];
}

#pragma mark - action
-(void)submitClick{
//    if([HelpManager isBlankString:[WTUserInfo shareUserInfo].email] && self.sendVerificationCodeWhereJump != SendVerificationCodeWhereJumpLogin){
//        printAlert(LocalizationKey(@"BindingPhoneTip2"), 1.f);
//        return;
//    }
    
    switch (self.sendVerificationCodeWhereJump) {
        case SendVerificationCodeWhereJumpWithdraw:
        {   //提币net
            if([[WTUserInfo shareUserInfo].is_googleauth integerValue] == 1){
                [self.withdrawNetDic setValue:self.googleCodeField.text forKey:@"googlecode"];
            }
            [self.afnetWork jsonPostDict:@"/api/account/withdraw" JsonDict:self.withdrawNetDic Tag:@"2"];
        }
            break;
        case SendVerificationCodeWhereJumpWithdrawSD:
        {
            NSLog(@"token:%@",[WTUserInfo shareUserInfo].token);
            [self.withdrawNetDic setValue:self.googleCodeField.text forKey:@"paypass"];
            [self.withdrawNetDic setValue:[WTUserInfo shareUserInfo].email forKey:@"email"];
            [self.withdrawNetDic setValue:_textField.text forKey:@"code"];
             
            [self.afnetWork jsonPostDict:@"/api/cc/ccTransfers" JsonDict:self.withdrawNetDic Tag:@"2"];
        }
            break;
        case SendVerificationCodeWhereJumpAddWithdrawAddress:
        {   //添加提币地址net
            [self.afnetWork jsonPostDict:@"/api/account/addWithdrawAddress" JsonDict:self.addWithdrawAddressNetDic Tag:@"3"];
        }
            break;
        case SendVerificationCodeWhereJumpBindGoogleCode:
        {
            //绑定谷歌
            [self.sendCodeNetDic setValue:_textField.text forKey:@"emscode"];
            [self.sendCodeNetDic setValue:[WTUserInfo shareUserInfo].email forKey:@"email"];
            [self.afnetWork jsonPostDict:@"/api/account/bindGoogleAuth" JsonDict:self.sendCodeNetDic Tag:@"4"];
        }
            break;
        case SendVerificationCodeWhereJumpSwitchGoogleCode:
        {
            [self.sendCodeNetDic setValue:_textField.text forKey:@"emscode"];
            [self.sendCodeNetDic setValue:self.googleCodeField.text forKey:@"googlecode"];
            [self.afnetWork jsonPostDict:@"/api/account/setGoogleAuth" JsonDict:self.sendCodeNetDic Tag:@"5"];
        }
            break;
        case SendVerificationCodeWhereJumpLogin:
        {
            if([HelpManager isBlankString:self.googleCodeField.text]){
                printAlert(LocalizationKey(@"googleVerificationTip18"), 1.f);
                return;
            }
            !self.getGoogleCodeBlock ? : self.getGoogleCodeBlock(self.googleCodeField.text);
            [self closeVC];
        }
            break;
        default:
        {
            //重置密码
            NSMutableDictionary *md = [NSMutableDictionary dictionary];
            md[@"email"] = [WTUserInfo shareUserInfo].email;
            md[@"newpassword"] = [HelpManager isBlankString:self.freshPwdStr] ? @"":self.freshPwdStr;
            md[@"captcha"] = _textField.text;
            md[@"type"] = @"email";
            [self.afnetWork jsonGetDict:@"/api/user/resetpwd" JsonDict:md Tag:@"1"];
        }
            break;
    }
}

-(void)sendVerficationCodeClick{
    if([HelpManager isBlankString:[WTUserInfo shareUserInfo].email]){
        printAlert(LocalizationKey(@"BindingPhoneTip2"), 1.f);
        return;
    }
    
    NSString *eventType;
    switch (self.sendVerificationCodeWhereJump) {
        case SendVerificationCodeWhereJumpWithdraw:
        {   //提币net
            eventType = @"addpay";
        }
            break;
        case SendVerificationCodeWhereJumpWithdrawSD:
        {
            eventType = @"usdt_SD_transfer";
        }
            break;
        case SendVerificationCodeWhereJumpAddWithdrawAddress:
        {   //添加提币地址net
             eventType = @"addpay";
        }
            break;
        case SendVerificationCodeWhereJumpAddPayAccount:
            eventType = @"addpay";
            break;
        case SendVerificationCodeWhereJumpDeletePayAccount:
            eventType = @"delpay";
            break;
        case SendVerificationCodeWhereJumpBindGoogleCode:
            eventType = @"bindGoogleAuth";
            break;
        case SendVerificationCodeWhereJumpSwitchGoogleCode:
            eventType = @"setGoogleAuth";
            break;
        default:
        {
            //重置密码
            eventType = @"resetpwd";
        }
            break;
    }
    // 验证码
    [self.afnetWork jsonGetDict:HTTP_SEND_EMS JsonDict:@{@"email":[WTUserInfo shareUserInfo].email,
    @"event":eventType
    } Tag:@"1000"];
     
  //  _textField.text = @"777777";
     
    return;
    
}

-(void)changedTextField:(UITextField *)textfield{
    if([HelpManager isBlankString:textfield.text]){
        _submitBtn.enabled = NO;
    }else{
        _submitBtn.enabled = YES;
    }
}

-(void)jumpBinGooleCodeVCClick{
    BindGoogleVerificationViewController *vc = [BindGoogleVerificationViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

///粘贴
-(void)pasteClick{
    self.googleCodeField.text = [UIPasteboard generalPasteboard].string;
}
 
-(void)dismissVC{
    !self.dissmissVCBlock ? : self.dissmissVCBlock();
    [self closeVC];
}

#pragma mark - netWork
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1000"]){
        __block int timeout= 60; //倒计时时间
           dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
           dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
           dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
           dispatch_source_set_event_handler(_timer, ^{
               if(timeout<=0){ //倒计时结束，关闭
                   dispatch_source_cancel(_timer);
                   dispatch_async(dispatch_get_main_queue(), ^{
                       [self->_sendBtn setTitle:LocalizationKey(@"Resend Code") forState:UIControlStateNormal];
                       self->_sendBtn.userInteractionEnabled = YES;
                       [self->_sendBtn sizeToFit];
                   });
               }else{
                   dispatch_async(dispatch_get_main_queue(), ^{
                       
                       [UIView beginAnimations:nil context:nil];
                       [UIView setAnimationDuration:1];
                       [self->_sendBtn setTitle:[NSString stringWithFormat:@"%d%@",timeout,LocalizationKey(@"Resend after seconds")] forState:UIControlStateNormal];
                       [UIView commitAnimations];
                       self->_sendBtn.userInteractionEnabled = NO;
                       [self->_sendBtn sizeToFit];
                   });
                   timeout--;
               }
           });
           dispatch_resume(_timer);
           
    }else{
        
        if(self.sendVerificationCodeWhereJump == SendVerificationCodeWhereJumpResetPwd){
            //修改密码后更新一波密码
             
            [[NSUserDefaults standardUserDefaults] setObject:[HelpManager isBlankString:self.freshPwdStr] ? @"":self.freshPwdStr forKey:@"userPwd"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        printAlert(dict[@"msg"], 2.f);
        [self closeVC];
        !self.backRefreshBlock ? : self.backRefreshBlock();
    }
}

#pragma mark - ui
-(void)setUpView{
    if(self.sendVerificationCodeWhereJump == SendVerificationCodeWhereJumpLogin){
        [self createOnlyGoogleCodeView];
        return;
    }
    if(self.sendVerificationCodeWhereJump == SendVerificationCodeWhereJumpWithdrawSD){
        [self createFundPwdCodeView];
        return;
    }
    
    if([[WTUserInfo shareUserInfo].is_googleauth integerValue] == 1){
        if(self.sendVerificationCodeWhereJump ==  SendVerificationCodeWhereJumpWithdraw || self.sendVerificationCodeWhereJump ==   SendVerificationCodeWhereJumpSwitchGoogleCode){
            //提币需要谷歌验证
            [self  createOnlyGoogleCodeView];
        }else{
            [self createDefultView];
        }
    }else if([[WTUserInfo shareUserInfo].is_googleauth integerValue] == 2){
         //开启，关闭谷歌验证需要谷歌验证
         if(self.sendVerificationCodeWhereJump ==   SendVerificationCodeWhereJumpSwitchGoogleCode){
              [self createOnlyGoogleCodeView];
         }else{
             [self createDefultView];
         }
    }else{
        [self createDefultView];
    }
  
}

#pragma mark - 谷歌验证视图 + 验证码视图
-(void)createGoogleCodeView{
    //点击灰色背景也关闭
    CGFloat newHeight = 100;//多出谷歌验证码的高度
      UIButton *grayBac = [UIButton buttonWithType:UIButtonTypeCustom];
      grayBac.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - viewHeight - newHeight - 50);
      grayBac.backgroundColor = rgba(0, 0, 0, 0.5);
      [grayBac addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
      [self.view addSubview:grayBac];
      
     UIView *googleTopBac = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - viewHeight - newHeight - 50, ScreenWidth, 50)];
     googleTopBac.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
     [self.view addSubview:googleTopBac];
     [[HelpManager sharedHelpManager] setPartRoundWithView:googleTopBac corners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:5];
    
     UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(googleTopBac.frame), ScreenWidth, 1)];
     line3.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
     [self.view addSubview:line3];
    
    WTLabel *googleTip1 = [WTLabel new];
    googleTip1.theme_textColor = THEME_GRAY_TEXTCOLOR;
    googleTip1.font = tFont(15);
    googleTip1.text = LocalizationKey(@"googleVerificationTip12");
    [googleTopBac addSubview:googleTip1];
    [googleTip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(googleTopBac.mas_centerY);
        make.left.mas_equalTo(googleTopBac.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
    
    UIButton *forgetGooleCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetGooleCodeBtn setTitle:LocalizationKey(@"googleVerificationTip13") forState:UIControlStateNormal];
    [forgetGooleCodeBtn setTitleColor:MainBlueColor forState:UIControlStateNormal];
    forgetGooleCodeBtn.titleLabel.font = tFont(15);
    [googleTopBac addSubview:forgetGooleCodeBtn];
    [forgetGooleCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(googleTip1.mas_centerY);
        make.left.mas_equalTo(googleTip1.mas_right).offset(0);
    }];
    
      UIView *bac = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(line3.frame), SCREEN_WIDTH, viewHeight + newHeight)];
      bac.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      [self.view addSubview:bac];
      
      UILabel *tip = [UILabel new];
      tip.text = LocalizationKey(@"Safety verification");
      tip.theme_textColor = THEME_TEXT_COLOR;
      tip.font = tFont(16);
      tip.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      tip.layer.masksToBounds = YES;
      [bac addSubview:tip];
      [tip mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(bac.mas_top).offset(15);
          make.left.mas_equalTo(bac.mas_left).offset(15);
      }];
      
      UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [dismissBtn theme_setBackgroundColor:THEME_NAVBAR_BACKGROUNDCOLOR forState:UIControlStateNormal];
      [dismissBtn theme_setTitleColor:THEME_GRAY_TEXTCOLOR forState:UIControlStateNormal];
      [dismissBtn setTitle:LocalizationKey(@"cancel") forState:UIControlStateNormal];
      [dismissBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
      dismissBtn.titleLabel.font = tFont(14);
      [bac addSubview:dismissBtn];
      [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.mas_equalTo(bac.mas_right).offset(-15);
          make.centerY.mas_equalTo(tip.mas_centerY);
      }];
      [dismissBtn sizeToFit];
      
      UIView *line = [UIView new];
      line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
      [bac addSubview:line];
      [line mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(tip.mas_bottom).offset(15);
          make.left.mas_equalTo(bac.mas_left);
          make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
      }];
      
      UILabel *tip1 = [UILabel new];
      tip1.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      tip1.layer.masksToBounds = YES;
    tip1.text = [HelpManager isBlankString:[WTUserInfo shareUserInfo].email] ? [WTUserInfo shareUserInfo].mobile : [WTUserInfo shareUserInfo].email;
      tip1.font = tFont(14.5);
      tip1.theme_textColor = THEME_TEXT_COLOR;
      [bac addSubview:tip1];
      [tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(line.mas_bottom).offset(30);
          make.left.mas_equalTo(bac.mas_left).offset(15);
      }];
      
      _textField = [UITextField new];
      _textField.keyboardType = UIKeyboardTypeNumberPad;
      _textField.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      _textField.font = tFont(16);
    //  _textField.placeholder = LocalizationKey(@"SMS verification code");
      _textField.theme_textColor = THEME_TEXT_COLOR;
    //  [_textField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
      _textField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"SMS verification code")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
      [bac addSubview:_textField];
      [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(tip1.mas_left);
          make.right.mas_equalTo(bac.mas_right).offset(-15);
          make.top.mas_equalTo(tip1.mas_bottom).offset(20);
          make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 40));
      }];
      
      _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [_sendBtn setTitle:LocalizationKey(@"Send") forState:UIControlStateNormal];
      [_sendBtn setTitleColor:MainBlueColor forState:UIControlStateNormal];
      _sendBtn.titleLabel.font = tFont(14);
      _sendBtn.frame = CGRectMake(0, 0, 50, 40);
      [_sendBtn sizeToFit];
      _textField.rightView = _sendBtn;
      _textField.rightViewMode = UITextFieldViewModeAlways;
      
      UIView *line1 = [UIView new];
      line1.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
      [_textField addSubview:line1];
      [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
          make.bottom.mas_equalTo(_textField.mas_bottom);
          make.width.mas_equalTo(_textField.mas_width);
          make.height.mas_equalTo(1);
      }];
      
      UILabel *tip2 = [UILabel new];
      tip2.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      tip2.layer.masksToBounds = YES;
      tip2.text = LocalizationKey(@"googleVerificationTip8");
      tip2.font = tFont(14.5);
      tip2.theme_textColor = THEME_TEXT_COLOR;
      [bac addSubview:tip2];
      [tip2 mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(line1.mas_bottom).offset(30);
          make.left.mas_equalTo(bac.mas_left).offset(15);
      }];
      
      self.googleCodeField = [UITextField new];
      self.googleCodeField.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      self.googleCodeField.font = tFont(16);
      self.googleCodeField.keyboardType = UIKeyboardTypeNumberPad;
      self.googleCodeField.theme_textColor = THEME_TEXT_COLOR;
      self.googleCodeField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"googleVerificationTip8")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
      [bac addSubview:self.googleCodeField];
      [self.googleCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(tip2.mas_left);
          make.right.mas_equalTo(bac.mas_right).offset(-15);
          make.top.mas_equalTo(tip2.mas_bottom).offset(20);
          make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 40));
      }];
      
      UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [copyBtn setTitle:LocalizationKey(@"googleVerificationTip14") forState:UIControlStateNormal];
      [copyBtn setTitleColor:MainBlueColor forState:UIControlStateNormal];
      copyBtn.titleLabel.font = tFont(14);
      copyBtn.frame = CGRectMake(0, 0, 50, 40);
      [copyBtn sizeToFit];
      self.googleCodeField.rightView = copyBtn;
      self.googleCodeField.rightViewMode = UITextFieldViewModeAlways;
      
      UIView *line2 = [UIView new];
      line2.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
      [self.googleCodeField addSubview:line2];
      [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
          make.bottom.mas_equalTo(self.googleCodeField.mas_bottom);
          make.width.mas_equalTo(self.googleCodeField.mas_width);
          make.height.mas_equalTo(1);
      }];
       
      _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [_submitBtn setBackgroundImage:[UIImage imageWithColor:ButtonDisabledColor] forState:UIControlStateDisabled];
      [_submitBtn setBackgroundImage:[UIImage imageWithColor:MainBlueColor] forState:UIControlStateNormal];
      [_submitBtn setTitle:LocalizationKey(@"confirm") forState:UIControlStateNormal];
      _submitBtn.enabled = NO;
      [bac addSubview:_submitBtn];
      [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.bottom.mas_equalTo(bac.mas_bottom).offset(-20);
          make.left.mas_equalTo(bac.mas_left).offset(15);
          make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 45));
      }];
    
      [_submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
      [_textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
      [_sendBtn addTarget:self action:@selector(sendVerficationCodeClick) forControlEvents:UIControlEventTouchUpInside];
      [forgetGooleCodeBtn addTarget:self action:@selector(jumpBinGooleCodeVCClick) forControlEvents:UIControlEventTouchUpInside];
      [copyBtn addTarget:self action:@selector(pasteClick) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 只有谷歌验证的视图
-(void)createOnlyGoogleCodeView{
    //点击灰色背景也关闭
      UIButton *grayBac = [UIButton buttonWithType:UIButtonTypeCustom];
      grayBac.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - viewHeight );
      grayBac.backgroundColor = rgba(0, 0, 0, 0.5);
      [grayBac addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
      [self.view addSubview:grayBac];
      
     UIView *bac = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - viewHeight  , ScreenWidth, viewHeight)];
     bac.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
     [self.view addSubview:bac];
     [[HelpManager sharedHelpManager] setPartRoundWithView:bac corners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:5];
    
    UIView *forgeBbac = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , ScreenWidth, 50)];
    forgeBbac.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    [bac addSubview:forgeBbac];
    [[HelpManager sharedHelpManager] setPartRoundWithView:forgeBbac corners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:5];
        
     UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(forgeBbac.frame)-1, ScreenWidth, 1)];
     line3.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
     [forgeBbac addSubview:line3];
    
    WTLabel *tip = [WTLabel new];
    tip.theme_textColor = THEME_GRAY_TEXTCOLOR;
    tip.font = tFont(15);
    tip.text = LocalizationKey(@"googleVerificationTip12");
    [forgeBbac addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(forgeBbac.mas_centerY);
        make.left.mas_equalTo(forgeBbac.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
    
    UIButton *forgetGooleCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [forgetGooleCodeBtn setTitle:LocalizationKey(@"googleVerificationTip13") forState:UIControlStateNormal];
    [forgetGooleCodeBtn setTitleColor:MainBlueColor forState:UIControlStateNormal];
    forgetGooleCodeBtn.titleLabel.font = tFont(15);
    [forgeBbac addSubview:forgetGooleCodeBtn];
    [forgetGooleCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tip.mas_centerY);
        make.left.mas_equalTo(tip.mas_right).offset(0);
    }];
    
     
      UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [dismissBtn theme_setBackgroundColor:THEME_NAVBAR_BACKGROUNDCOLOR forState:UIControlStateNormal];
      [dismissBtn theme_setTitleColor:THEME_GRAY_TEXTCOLOR forState:UIControlStateNormal];
      [dismissBtn setTitle:LocalizationKey(@"cancel") forState:UIControlStateNormal];
      [dismissBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
      dismissBtn.titleLabel.font = tFont(14);
      [forgeBbac addSubview:dismissBtn];
      [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.mas_equalTo(forgeBbac.mas_right).offset(-15);
          make.centerY.mas_equalTo(tip.mas_centerY);
      }];
      [dismissBtn sizeToFit];
      
      UILabel *tip2 = [UILabel new];
      tip2.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      tip2.layer.masksToBounds = YES;
      tip2.text = LocalizationKey(@"googleVerificationTip8");
      tip2.font = tFont(14.5);
      tip2.theme_textColor = THEME_TEXT_COLOR;
      [bac addSubview:tip2];
      [tip2 mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(line3.mas_bottom).offset(30);
          make.left.mas_equalTo(bac.mas_left).offset(15);
      }];
      
      self.googleCodeField = [UITextField new];
      self.googleCodeField.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      self.googleCodeField.font = tFont(16);
      self.googleCodeField.keyboardType = UIKeyboardTypeNumberPad;
      self.googleCodeField.theme_textColor = THEME_TEXT_COLOR;
      self.googleCodeField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"googleVerificationTip8")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
      [bac addSubview:self.googleCodeField];
      [self.googleCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(tip2.mas_left);
          make.right.mas_equalTo(bac.mas_right).offset(-15);
          make.top.mas_equalTo(tip2.mas_bottom).offset(20);
          make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 40));
      }];
      
      UIButton *copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [copyBtn setTitle:LocalizationKey(@"googleVerificationTip14") forState:UIControlStateNormal];
      [copyBtn setTitleColor:MainBlueColor forState:UIControlStateNormal];
      copyBtn.titleLabel.font = tFont(14);
      copyBtn.frame = CGRectMake(0, 0, 50, 40);
      [copyBtn sizeToFit];
      self.googleCodeField.rightView = copyBtn;
      self.googleCodeField.rightViewMode = UITextFieldViewModeAlways;
      
      UIView *line2 = [UIView new];
      line2.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
      [self.googleCodeField addSubview:line2];
      [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
          make.bottom.mas_equalTo(self.googleCodeField.mas_bottom);
          make.width.mas_equalTo(self.googleCodeField.mas_width);
          make.height.mas_equalTo(1);
      }];
       
      _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [_submitBtn setBackgroundImage:[UIImage imageWithColor:ButtonDisabledColor] forState:UIControlStateDisabled];
      [_submitBtn setBackgroundImage:[UIImage imageWithColor:MainBlueColor] forState:UIControlStateNormal];
      [_submitBtn setTitle:LocalizationKey(@"confirm") forState:UIControlStateNormal];
 
      [bac addSubview:_submitBtn];
      [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.bottom.mas_equalTo(bac.mas_bottom).offset(-20);
          make.left.mas_equalTo(bac.mas_left).offset(15);
          make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 45));
      }];
    
      [_submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
      [forgetGooleCodeBtn addTarget:self action:@selector(jumpBinGooleCodeVCClick) forControlEvents:UIControlEventTouchUpInside];
      [copyBtn addTarget:self action:@selector(pasteClick) forControlEvents:UIControlEventTouchUpInside];
     
}

#pragma mark - 没有谷歌验证的视图
-(void)createDefultView{
    UIButton *grayBac = [UIButton buttonWithType:UIButtonTypeCustom];
      grayBac.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - viewHeight);
      grayBac.backgroundColor = rgba(0, 0, 0, 0.5);
      [grayBac addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
      [self.view addSubview:grayBac];
      
      UIView *bac = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - viewHeight, SCREEN_WIDTH, viewHeight)];
      bac.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      [self.view addSubview:bac];
      
      UILabel *tip = [UILabel new];
      tip.text = LocalizationKey(@"Safety verification");
      tip.theme_textColor = THEME_TEXT_COLOR;
      tip.font = tFont(16);
      tip.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      tip.layer.masksToBounds = YES;
      [bac addSubview:tip];
      [tip mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(bac.mas_top).offset(15);
          make.left.mas_equalTo(bac.mas_left).offset(15);
      }];
      
      UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [dismissBtn theme_setBackgroundColor:THEME_NAVBAR_BACKGROUNDCOLOR forState:UIControlStateNormal];
      [dismissBtn theme_setTitleColor:THEME_GRAY_TEXTCOLOR forState:UIControlStateNormal];
      [dismissBtn setTitle:LocalizationKey(@"cancel") forState:UIControlStateNormal];
      [dismissBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
      dismissBtn.titleLabel.font = tFont(14);
      //去除高亮色
      dismissBtn.adjustsImageWhenHighlighted = NO;
      dismissBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
      [bac addSubview:dismissBtn];
      [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.mas_equalTo(bac.mas_right).offset(-15);
          make.centerY.mas_equalTo(tip.mas_centerY);
          make.size.mas_equalTo(CGSizeMake(60, 40));
      }];
   //   [dismissBtn sizeToFit];
      
      UIView *line = [UIView new];
      line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
      [bac addSubview:line];
      [line mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(tip.mas_bottom).offset(15);
          make.left.mas_equalTo(bac.mas_left);
          make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
      }];
      
      UILabel *tip1 = [UILabel new];
      tip1.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      tip1.layer.masksToBounds = YES;
    tip1.text = [HelpManager isBlankString:[WTUserInfo shareUserInfo].email] ? [WTUserInfo shareUserInfo].mobile : [WTUserInfo shareUserInfo].email;
      tip1.font = tFont(14.5);
      tip1.theme_textColor = THEME_TEXT_COLOR;
      [bac addSubview:tip1];
      [tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(line.mas_bottom).offset(30);
          make.left.mas_equalTo(bac.mas_left).offset(15);
      }];
      
      _textField = [UITextField new];
    _textField.keyboardType = UIKeyboardTypeNumberPad;
      _textField.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      _textField.font = tFont(16);
    //  _textField.placeholder = LocalizationKey(@"SMS verification code");
      _textField.theme_textColor = THEME_TEXT_COLOR;
    //  [_textField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
      _textField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"SMS verification code")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
      [bac addSubview:_textField];
      [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(tip1.mas_left);
          make.right.mas_equalTo(bac.mas_right).offset(-15);
          make.top.mas_equalTo(tip1.mas_bottom).offset(20);
          make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 40));
      }];
      
      _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [_sendBtn setTitle:LocalizationKey(@"Send") forState:UIControlStateNormal];
      [_sendBtn setTitleColor:MainBlueColor forState:UIControlStateNormal];
      _sendBtn.titleLabel.font = tFont(14);
      _sendBtn.frame = CGRectMake(0, 0, 50, 40);
      [_sendBtn sizeToFit];
      _textField.rightView = _sendBtn;
      _textField.rightViewMode = UITextFieldViewModeAlways;
      
      UIView *line1 = [UIView new];
      line1.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
      [_textField addSubview:line1];
      [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
          make.bottom.mas_equalTo(_textField.mas_bottom);
          make.width.mas_equalTo(_textField.mas_width);
          make.height.mas_equalTo(1);
      }];
      
      _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [_submitBtn setBackgroundImage:[UIImage imageWithColor:ButtonDisabledColor] forState:UIControlStateDisabled];
      [_submitBtn setBackgroundImage:[UIImage imageWithColor:MainBlueColor] forState:UIControlStateNormal];
      [_submitBtn setTitle:LocalizationKey(@"confirm") forState:UIControlStateNormal];
      _submitBtn.enabled = NO;
      [bac addSubview:_submitBtn];
      [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.bottom.mas_equalTo(bac.mas_bottom).offset(-20);
          make.left.mas_equalTo(bac.mas_left).offset(15);
          make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 45));
      }];
      [_submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
      [_textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
      [_sendBtn addTarget:self action:@selector(sendVerficationCodeClick) forControlEvents:UIControlEventTouchUpInside];
    
    if(self.sendVerificationCodeWhereJump == SendVerificationCodeWhereJumpWithdrawSD){//575验证资金密码 添加或删除收款账号
        tip1.text = LocalizationKey(@"Fund password");
        _textField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"InputPaymentPassword")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
        _textField.rightView = nil;
    }
}

#pragma mark - 资金密码 + 验证码视图
-(void)createFundPwdCodeView{
    //点击灰色背景也关闭
    CGFloat newHeight = 100;//多出谷歌验证码的高度
      UIButton *grayBac = [UIButton buttonWithType:UIButtonTypeCustom];
      grayBac.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - viewHeight - newHeight);
      grayBac.backgroundColor = rgba(0, 0, 0, 0.5);
      [grayBac addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
      [self.view addSubview:grayBac];
       
       
      UIView *bac = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - viewHeight - newHeight , SCREEN_WIDTH, viewHeight + newHeight)];
      bac.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      [self.view addSubview:bac];
      
      UILabel *tip = [UILabel new];
      tip.text = LocalizationKey(@"Safety verification");
      tip.theme_textColor = THEME_TEXT_COLOR;
      tip.font = tFont(16);
      tip.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      tip.layer.masksToBounds = YES;
      [bac addSubview:tip];
      [tip mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(bac.mas_top).offset(15);
          make.left.mas_equalTo(bac.mas_left).offset(15);
      }];
      
      UIButton *dismissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [dismissBtn theme_setBackgroundColor:THEME_NAVBAR_BACKGROUNDCOLOR forState:UIControlStateNormal];
      [dismissBtn theme_setTitleColor:THEME_GRAY_TEXTCOLOR forState:UIControlStateNormal];
      [dismissBtn setTitle:LocalizationKey(@"cancel") forState:UIControlStateNormal];
      [dismissBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
      dismissBtn.titleLabel.font = tFont(14);
      [bac addSubview:dismissBtn];
      [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.right.mas_equalTo(bac.mas_right).offset(-15);
          make.centerY.mas_equalTo(tip.mas_centerY);
      }];
      [dismissBtn sizeToFit];
      
      UIView *line = [UIView new];
      line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
      [bac addSubview:line];
      [line mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(tip.mas_bottom).offset(15);
          make.left.mas_equalTo(bac.mas_left);
          make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
      }];
      
      UILabel *tip1 = [UILabel new];
      tip1.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      tip1.layer.masksToBounds = YES;
    tip1.text = [HelpManager isBlankString:[WTUserInfo shareUserInfo].email] ? [WTUserInfo shareUserInfo].mobile : [WTUserInfo shareUserInfo].email;
      tip1.font = tFont(14.5);
      tip1.theme_textColor = THEME_TEXT_COLOR;
      [bac addSubview:tip1];
      [tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(line.mas_bottom).offset(30);
          make.left.mas_equalTo(bac.mas_left).offset(15);
      }];
      
      _textField = [UITextField new];
      _textField.keyboardType = UIKeyboardTypeNumberPad;
      _textField.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      _textField.font = tFont(16);
    //  _textField.placeholder = LocalizationKey(@"SMS verification code");
      _textField.theme_textColor = THEME_TEXT_COLOR;
    //  [_textField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
      _textField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"SMS verification code")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
      [bac addSubview:_textField];
      [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(tip1.mas_left);
          make.right.mas_equalTo(bac.mas_right).offset(-15);
          make.top.mas_equalTo(tip1.mas_bottom).offset(20);
          make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 40));
      }];
      
      _sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [_sendBtn setTitle:LocalizationKey(@"Send") forState:UIControlStateNormal];
      [_sendBtn setTitleColor:MainBlueColor forState:UIControlStateNormal];
      _sendBtn.titleLabel.font = tFont(14);
      _sendBtn.frame = CGRectMake(0, 0, 50, 40);
      [_sendBtn sizeToFit];
      _textField.rightView = _sendBtn;
      _textField.rightViewMode = UITextFieldViewModeAlways;
      
      UIView *line1 = [UIView new];
      line1.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
      [_textField addSubview:line1];
      [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
          make.bottom.mas_equalTo(_textField.mas_bottom);
          make.width.mas_equalTo(_textField.mas_width);
          make.height.mas_equalTo(1);
      }];
      
      UILabel *tip2 = [UILabel new];
      tip2.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      tip2.layer.masksToBounds = YES;
      tip2.text = LocalizationKey(@"Fund password");
      tip2.font = tFont(14.5);
      tip2.theme_textColor = THEME_TEXT_COLOR;
      [bac addSubview:tip2];
      [tip2 mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(line1.mas_bottom).offset(30);
          make.left.mas_equalTo(bac.mas_left).offset(15);
      }];
      
      self.googleCodeField = [UITextField new];
      self.googleCodeField.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      self.googleCodeField.font = tFont(16);
      self.googleCodeField.keyboardType = UIKeyboardTypeNumberPad;
      self.googleCodeField.theme_textColor = THEME_TEXT_COLOR;
      self.googleCodeField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"InputPaymentPassword")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
      [bac addSubview:self.googleCodeField];
      [self.googleCodeField mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.mas_equalTo(tip2.mas_left);
          make.right.mas_equalTo(bac.mas_right).offset(-15);
          make.top.mas_equalTo(tip2.mas_bottom).offset(20);
          make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 40));
      }];
       
      UIView *line2 = [UIView new];
      line2.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
      [self.googleCodeField addSubview:line2];
      [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
          make.bottom.mas_equalTo(self.googleCodeField.mas_bottom);
          make.width.mas_equalTo(self.googleCodeField.mas_width);
          make.height.mas_equalTo(1);
      }];
       
      _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
      [_submitBtn setBackgroundImage:[UIImage imageWithColor:ButtonDisabledColor] forState:UIControlStateDisabled];
      [_submitBtn setBackgroundImage:[UIImage imageWithColor:MainBlueColor] forState:UIControlStateNormal];
      [_submitBtn setTitle:LocalizationKey(@"confirm") forState:UIControlStateNormal];
      _submitBtn.enabled = NO;
      [bac addSubview:_submitBtn];
      [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
          make.bottom.mas_equalTo(bac.mas_bottom).offset(-20);
          make.left.mas_equalTo(bac.mas_left).offset(15);
          make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 45));
      }];
    
      [_submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
      [_textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
      [_sendBtn addTarget:self action:@selector(sendVerficationCodeClick) forControlEvents:UIControlEventTouchUpInside];
}

@end
