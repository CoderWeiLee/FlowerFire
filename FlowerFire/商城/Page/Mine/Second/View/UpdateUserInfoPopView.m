//
//  UpdateUserInfoPopView.m
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "UpdateUserInfoPopView.h"
#import "UIImage+jianbianImage.h"
#import "LoginInputView.h"
#import <UIButton+YYWebImage.h>

@interface UpdateUserInfoPopView ()
{
    UILabel      *_title;
    UITextField  *_updateTextField;
    UIButton     *_updateButton;
    UIView       *_bacView;
    UIImageView  *_closeImage;
   
}
@property (nonatomic, copy) void(^block)(NSString* ,NSString*,NSString*);
/// 原密码
@property (nonatomic, strong)UITextField    *olePwdTextField;
/// 确认密码
@property (nonatomic, strong)UITextField    *submitPwdTextField;
@property (nonatomic, strong)LoginInputView *loginInputView,*imageCodeInputView;

@property(nonatomic, strong)NSString        *encryptCode;
@end

@implementation UpdateUserInfoPopView
  
- (instancetype)initWithFrame:(CGRect)frame updateUserInfoType:(UpdateUserInfoType)type updateTextBlock:(void (^)(NSString * _Nonnull, NSString * _Nonnull, NSString * _Nonnull))block{
    self = [super initWithFrame:frame];
      if(self){
          [self createUI];
          [self layoutSubview];
          self.block = block;
          self.updateUserInfoType = type;
      }
      return self;
}

-(void)updateClick{
    NSString *twoStr = self.olePwdTextField.text;
    if(self.updateUserInfoType == UpdateUserInfoTypePhone){
        twoStr = self.loginInputView.text;
    }
    !self.block ? :  self.block(_updateTextField.text,twoStr,self.submitPwdTextField.text);
}

//发手机验证码
-(void)getCodeClick:(UIButton *)btn{
    if([ToolUtil checkPhoneNumInput:_updateTextField.text]){
        if(![HelpManager isBlankString:self.imageCodeInputView.text]){
            NSMutableDictionary *md = [NSMutableDictionary dictionary];
            md[@"verify_code"] = self.imageCodeInputView.text;
            md[@"encrypt_code"] = self.encryptCode;
            md[@"content_type"] = @"1";
            md[@"mobile"] = _updateTextField.text;
            [self.afnetWork jsonMallPostDict:@"/api/login/mobileVerify" JsonDict:md Tag:@"1000"];
            [[HelpManager sharedHelpManager] sendVerificationCode:btn];
        }else{
            printAlert(@"请输入图形验证码", 1.f);
        }
    }else{
        printAlert(@"请输入正确的手机号", 1.f);
    }

}
 
//发图形验证码
-(void)getImageCodeClick:(UIButton *)btn{
    @weakify(self)
    [MBManager showLoading];
    
    [[ReqestHelpManager share] requestMallPost:@"/api/login/getVerifyCode" andHeaderParam:nil finish:^(NSDictionary *dicForData, ReqestType flag) {
        @strongify(self)
        [MBManager hideAlert];
        [btn setTitle:@"" forState:UIControlStateNormal];
        [btn yy_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dicForData[@"image"]]] forState:UIControlStateNormal placeholder:nil];
        self.encryptCode = dicForData[@"encryptCode"];
    }];
}



-(void)closePopClick{
    !self.closePopViewBlock ? : self.closePopViewBlock();
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    
}

- (void)createUI{
    _bacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 211)];
    _bacView.backgroundColor = KWhiteColor;
    _bacView.layer.cornerRadius = 10;
    [self addSubview:_bacView];
    
    _title = [UILabel new];
    _title.textColor = rgba(51, 51, 51, 1);
    _title.font = tFont(17);
    [_bacView addSubview:_title];
    
    _updateTextField = [UITextField new];
    _updateTextField.textColor = rgba(51, 51, 51, 1);
    _updateTextField.font = tFont(13);
    _updateTextField.backgroundColor = KWhiteColor;
    _updateTextField.layer.cornerRadius = 5;
    _updateTextField.layer.borderWidth = 0.5;
    _updateTextField.layer.borderColor = rgba(204, 204, 204, 1).CGColor;
    [_bacView addSubview:_updateTextField];
    
    UIView *placeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    _updateTextField.leftView = placeView;
    _updateTextField.leftViewMode = UITextFieldViewModeAlways;
    
    _updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_updateButton setTitle:@"确认修改" forState:UIControlStateNormal];
    [_updateButton setBackgroundImage:[UIImage gradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(_bacView.width - 25 * 2, 40)] forState:UIControlStateNormal];
    _updateButton.layer.cornerRadius = 20;
    _updateButton.layer.masksToBounds = YES;
    _updateButton.titleLabel.font = tFont(15);
    [_bacView addSubview:_updateButton];
    [_updateButton addTarget:self action:@selector(updateClick) forControlEvents:UIControlEventTouchUpInside];
    
    _closeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close"]];
    _closeImage.userInteractionEnabled = YES;
    [_closeImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopClick)]];
    [self addSubview:_closeImage];
}

- (void)layoutSubview{
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bacView.mas_top).offset(27);
        make.centerX.mas_equalTo(_bacView.mas_centerX);
    }];
    
    [_updateTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_title.mas_bottom).offset(31.5);
        make.left.mas_equalTo(_bacView.mas_left).offset(25);
        make.right.mas_equalTo(_bacView.mas_right).offset(-25);
        make.height.mas_equalTo(40);
    }];
    
    [_updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_bacView.mas_bottom).offset(-27.5);
        make.centerX.mas_equalTo(_bacView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(_bacView.width - 25 * 2, 40));
    }];
    
    _closeImage.frame = CGRectMake((_bacView.width-54)/2, _bacView.ly_maxY, 54, 54);
}

- (void)setUpdateUserInfoType:(UpdateUserInfoType)updateUserInfoType{
    _updateUserInfoType = updateUserInfoType;
    switch (updateUserInfoType) {
        case UpdateUserInfoTypeName:
        {
            _title.text = @"修改姓名";
            _updateTextField.placeholder = @"输入姓名";
        }
            break;  
        case UpdateUserInfoTypeLoginPwd:
        {
            _title.text = @"修改登录密码";
            _updateTextField.placeholder = @"输入原登录密码";
              
            [self layoutIfNeeded];
            
            self.olePwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(_updateTextField.ly_x, _updateTextField.ly_maxY + 20, _updateTextField.ly_width, _updateTextField.ly_height)];
            self.olePwdTextField.textColor = rgba(51, 51, 51, 1);
            self.olePwdTextField.font = tFont(13);
            self.olePwdTextField.backgroundColor = KWhiteColor;
            self.olePwdTextField.layer.cornerRadius = 5;
            self.olePwdTextField.layer.borderWidth = 0.5;
            self.olePwdTextField.placeholder = @"输入新登录密码";
            self.olePwdTextField.layer.borderColor = rgba(204, 204, 204, 1).CGColor;
            [_bacView addSubview:self.olePwdTextField];
            
            UIView *placeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
            self.olePwdTextField.leftView = placeView;
            self.olePwdTextField.leftViewMode = UITextFieldViewModeAlways;
             
            self.submitPwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(_updateTextField.ly_x, self.olePwdTextField.ly_maxY + 20, _updateTextField.ly_width, _updateTextField.ly_height)];
            self.submitPwdTextField.textColor = rgba(51, 51, 51, 1);
            self.submitPwdTextField.font = tFont(13);
            self.submitPwdTextField.backgroundColor = KWhiteColor;
            self.submitPwdTextField.layer.cornerRadius = 5;
            self.submitPwdTextField.layer.borderWidth = 0.5;
            self.submitPwdTextField.placeholder = @"确认新登录密码";
            self.submitPwdTextField.layer.borderColor = rgba(204, 204, 204, 1).CGColor;
            [_bacView addSubview:self.submitPwdTextField];
            
            placeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
            self.submitPwdTextField.leftView = placeView;
            self.submitPwdTextField.leftViewMode = UITextFieldViewModeAlways;
            
            _bacView.height += (_updateTextField.ly_height + 20) * 2;
            self.height += (_updateTextField.ly_height + 20) * 2;
            [self layoutSubview];
            
        }
            break;
        case UpdateUserInfoTypePayPwd:
        {
            _title.text = @"修改支付密码";
            _updateTextField.placeholder = @"输入原支付密码";
            [self layoutIfNeeded];
            
            self.olePwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(_updateTextField.ly_x, _updateTextField.ly_maxY + 20, _updateTextField.ly_width, _updateTextField.ly_height)];
            self.olePwdTextField.textColor = rgba(51, 51, 51, 1);
            self.olePwdTextField.font = tFont(13);
            self.olePwdTextField.backgroundColor = KWhiteColor;
            self.olePwdTextField.layer.cornerRadius = 5;
            self.olePwdTextField.layer.borderWidth = 0.5;
            self.olePwdTextField.placeholder = @"输入新支付密码";
            self.olePwdTextField.layer.borderColor = rgba(204, 204, 204, 1).CGColor;
            [_bacView addSubview:self.olePwdTextField];
            
            UIView *placeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
            self.olePwdTextField.leftView = placeView;
            self.olePwdTextField.leftViewMode = UITextFieldViewModeAlways;
            
            self.submitPwdTextField = [[UITextField alloc] initWithFrame:CGRectMake(_updateTextField.ly_x, self.olePwdTextField.ly_maxY + 20, _updateTextField.ly_width, _updateTextField.ly_height)];
            self.submitPwdTextField.textColor = rgba(51, 51, 51, 1);
            self.submitPwdTextField.font = tFont(13);
            self.submitPwdTextField.backgroundColor = KWhiteColor;
            self.submitPwdTextField.layer.cornerRadius = 5;
            self.submitPwdTextField.layer.borderWidth = 0.5;
            self.submitPwdTextField.placeholder = @"确认新支付密码";
            self.submitPwdTextField.layer.borderColor = rgba(204, 204, 204, 1).CGColor;
            [_bacView addSubview:self.submitPwdTextField];
            
            placeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
            self.submitPwdTextField.leftView = placeView;
            self.submitPwdTextField.leftViewMode = UITextFieldViewModeAlways;
            
            _bacView.height += (_updateTextField.ly_height + 20) * 2;
            self.height += (_updateTextField.ly_height + 20) * 2;
             
            [self layoutSubview];
        }
            break;
        case UpdateUserInfoTypePhone:
        {
            _title.text = @"修改电话号码";
            _updateTextField.placeholder = @"输入电话号码";
            _updateTextField.keyboardType = UIKeyboardTypePhonePad;
            
            [self layoutIfNeeded];
            UIButton *rightView = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightView setTitle:@"获取验证码" forState:UIControlStateNormal];
            rightView.layer.cornerRadius = 5;
            rightView.layer.masksToBounds = YES;
            rightView.frame = CGRectMake(0,0, 100, 25);
            [[rightView titleLabel] setFont:tFont(13)];
            [rightView setBackgroundImage:[UIImage gradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight imgSize:rightView.size] forState:UIControlStateNormal];
            [rightView addTarget:self action:@selector(getCodeClick:) forControlEvents:UIControlEventTouchUpInside];
                        
            UIButton *rightView2 = [UIButton buttonWithType:UIButtonTypeCustom];
            [rightView2 setTitle:@"获取图形验证码" forState:UIControlStateNormal];
            rightView2.layer.cornerRadius = 5;
            rightView2.layer.masksToBounds = YES;
            rightView2.frame = CGRectMake(0,0, 100, 25);
            [[rightView2 titleLabel] setFont:tFont(13)];
            [rightView2 setTitleColor:KBlackColor forState:UIControlStateNormal];
            [rightView2 addTarget:self action:@selector(getImageCodeClick:) forControlEvents:UIControlEventTouchUpInside];
                  
            self.imageCodeInputView = [[LoginInputView alloc] initWithFrame:CGRectMake(_updateTextField.ly_x, _updateTextField.ly_maxY + 20, _updateTextField.ly_width, _updateTextField.ly_height) placeholderStr:@"请输入图形验证码" rightView:rightView2];
            self.imageCodeInputView.layer.cornerRadius = 5;
            self.imageCodeInputView.layer.borderWidth = 0.5;
            self.imageCodeInputView.layer.shadowOffset = CGSizeMake(0,0);
            self.imageCodeInputView.layer.shadowOpacity = 0;
            self.imageCodeInputView.layer.shadowRadius = 0;
            self.imageCodeInputView.layer.borderColor = rgba(204, 204, 204, 1).CGColor;
            [_bacView addSubview:self.imageCodeInputView];
            
            self.loginInputView = [[LoginInputView alloc] initWithFrame:CGRectMake(_updateTextField.ly_x, self.imageCodeInputView.ly_maxY + 20, _updateTextField.ly_width, _updateTextField.ly_height) placeholderStr:@"请输入验证码" rightView:rightView];
            self.loginInputView.layer.cornerRadius = 5;
            self.loginInputView.layer.borderWidth = 0.5;
            self.loginInputView.layer.shadowOffset = CGSizeMake(0,0);
            self.loginInputView.layer.shadowOpacity = 0;
            self.loginInputView.layer.shadowRadius = 0;
            self.loginInputView.layer.borderColor = rgba(204, 204, 204, 1).CGColor;
            [_bacView addSubview:self.loginInputView];
            
            
            _bacView.height += (_updateTextField.ly_height + 20) * 2;
            self.height += (_updateTextField.ly_height + 20) * 2;
            [self layoutSubview];
        
            [self getImageCodeClick:rightView2];
            
        }
            break;
        default:
            break;
    }
}

@end
