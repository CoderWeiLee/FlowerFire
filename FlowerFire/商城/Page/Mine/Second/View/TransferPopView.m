//
//  TransferPopView.m
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "TransferPopView.h"
#import <CRBoxInputView.h>

@interface TransferPopView ()<UITextFieldDelegate>
{
    UIView       *_bacView;
    UILabel      *_title,*_payTiplabel;
    UIImageView  *_closeImage;
    UITextField  *_transNumField,*_herNameField,*_herMemberNumField;
    CRBoxInputView      *_pwdInputView;
    UIButton            *_pickUpButton;
}
@property(nonatomic,assign)TransferPopType transferPopType;

@end

@implementation TransferPopView

- (instancetype)initWithFrame:(CGRect)frame TransferPopType:(TransferPopType)type{
    self = [super initWithFrame:frame];
    if(self){
        [self createUI];
        [self layoutSubview];
        
        self.transferPopType = type;
        
      
//      RACSignal *signal = [RACSignal combineLatest:@[_transNumField.rac_textSignal, _herNameField.rac_textSignal,_herMemberNumField.rac_textSignal] reduce:^id _Nonnull(NSString *account , NSString *pwd){
//            return @(account.length && pwd.length);
//      }];
//
//      RAC(_pwdInputView,userInteractionEnabled) = signal;
//
//      _pwdInputView.textDidChangeblock = ^(NSString * _Nullable text, BOOL isFinished) {
//          if(isFinished){
//              printAlert(@"转账 ", 1.f);
//          }
//      };
    }
    return self;
}

-(void)pickUpClick{
    if([HelpManager isBlankString:_transNumField.text]){
        printAlert(@"请输入转账数量", 1.f);
        return;
    }
    switch (self.transferPopType) {
        case TransferPopBalance:
        {
            NSMutableDictionary *md = [NSMutableDictionary dictionary];
            md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
            md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
            md[@"sheet"] = self.bankName;
            md[@"username"] = _herNameField.text;
            md[@"money"] = _transNumField.text;
            md[@"give_title"] = self.giveTitle;
            md[@"confirm_pass2"] = _pwdInputView.textValue;
            [self.afnetWork jsonMallPostDict:@"/api/finance/transfers" JsonDict:md Tag:@"1"];
        }
            break;
        case TransferPopIntegralExchange://兑换购物积分
        {
            NSMutableDictionary *md = [NSMutableDictionary dictionary];
            md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
            md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
            md[@"num"] = _transNumField.text;
            md[@"confirm_pass2"] = _pwdInputView.textValue;
            [self.afnetWork jsonMallPostDict:@"/api/finance/exchange" JsonDict:md Tag:@"1"];
        }
            break;
        default: //转赠股权
        {
            NSMutableDictionary *md = [NSMutableDictionary dictionary];
            md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
            md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
            md[@"num"] = _transNumField.text;
            md[@"confirm_pass2"] = _pwdInputView.textValue;
            md[@"username"] = _herNameField.text;
            [self.afnetWork jsonMallPostDict:@"/api/finance/turnUp" JsonDict:md Tag:@"1"];
        }
            break;
    }
}

-(void)closePopClick{
    !self.closePopViewBlock ? : self.closePopViewBlock();
}

- (void)createUI{
    _bacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.height - 54)];
    _bacView.backgroundColor = KWhiteColor;
    _bacView.layer.cornerRadius = 5;
    [self addSubview:_bacView];
    
    _title = [[UILabel alloc] initWithFrame:CGRectMake(_bacView.ly_x, _bacView.ly_y+21.5,_bacView.width, 17.5)];
    _title.textAlignment = NSTextAlignmentCenter;
    _title.textColor = rgba(51, 51, 51, 1);
    _title.font = tFont(18);
    [_bacView addSubview:_title];
    
    _transNumField = [self createField:CGRectMake(_bacView.ly_x + 14, _title.ly_maxY + 17, _bacView.width - 14 * 2, 30)];
    _transNumField.keyboardType = UIKeyboardTypeDecimalPad;
    
    _herNameField = [self createField:CGRectMake(_transNumField.ly_x, _transNumField.ly_maxY + 14, _transNumField.width, _transNumField.height)];
     
    _payTiplabel = [[UILabel alloc] initWithFrame:CGRectMake(_bacView.ly_x + 13.5, _herNameField.ly_maxY + 29.5, _bacView.width, 13)];
    _payTiplabel.textColor = rgba(51, 51, 51, 1);
    _payTiplabel.font = tFont(13);
    _payTiplabel.text = @"支付密码";
    [_bacView addSubview:_payTiplabel];
    [_payTiplabel sizeToFit];
   
    _pwdInputView = [[CRBoxInputView alloc] initWithCodeLength:6];
    _pwdInputView.frame = CGRectMake(_bacView.ly_x + 14, _payTiplabel.ly_maxY + 27, _bacView.width - 14 * 2, 32);
    _pwdInputView.ifNeedSecurity = YES;
    [_pwdInputView loadAndPrepareViewWithBeginEdit:NO];
    [_bacView addSubview:_pwdInputView];
     
    _pickUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _pickUpButton.layer.cornerRadius = 20;
    _pickUpButton.layer.masksToBounds = YES;
    _pickUpButton.titleLabel.font = tFont(15);
    [_bacView addSubview:_pickUpButton];
    [_pickUpButton addTarget:self action:@selector(pickUpClick) forControlEvents:UIControlEventTouchUpInside];
  
    _closeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close"]];
    _closeImage.userInteractionEnabled = YES;
    [_closeImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopClick)]];
    [self addSubview:_closeImage];
}

- (void)layoutSubview{
    _pickUpButton.frame = CGRectMake(_pwdInputView.ly_x, _pwdInputView.ly_maxY + 22, _pwdInputView.width, 40);
    [[HelpManager sharedHelpManager] jianbianMainColor:_pickUpButton size:_pickUpButton.size];
    _closeImage.frame = CGRectMake((_bacView.width-54)/2, _bacView.ly_maxY, 54, 54);
}

-(UITextField *)createField:(CGRect)frame{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.backgroundColor = KWhiteColor;
    textField.font = tFont(13);
    textField.layer.borderWidth = 0.5;
    textField.layer.borderColor = rgba(204, 204, 204, 1).CGColor;
    textField.layer.cornerRadius = 10;
    textField.layer.masksToBounds = YES;
    [_bacView addSubview:textField];
    
    UIView *lefView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, frame.size.height)];
    textField.leftView = lefView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    return textField;
}

- (void)setTransferPopType:(TransferPopType)transferPopType{
    _transferPopType = transferPopType;
    switch (transferPopType) {
        case TransferPopBalance:
        {
            _title.text = @"工资转账";
            _transNumField.placeholder = @"输入转账数量";
            _herNameField.placeholder = @"输入接收人编号";
            [_pickUpButton setTitle:@"确定转账" forState:UIControlStateNormal];
         
            [self createMeberNameUI];
        }
            break;
        case TransferPopIntegralExchange:
        {
            _title.text = @"兑换购物积分";
            [_herNameField removeFromSuperview];
            
            _transNumField.placeholder = @"输入兑换数量";
            [_payTiplabel setTop:_transNumField.ly_maxY + 29.5];
            [_pwdInputView setTop:_payTiplabel.ly_maxY + 17];
             
            _pickUpButton.frame = CGRectMake(_pwdInputView.ly_x, _pwdInputView.ly_maxY + 22, _pwdInputView.width, 40);
            [_pickUpButton setTitle:@"确定兑换" forState:UIControlStateNormal];
          
        }
            break;
        default:
        {
            _title.text = @"转赠股权";
            _transNumField.placeholder = @"输入转赠数量";
            _herNameField.placeholder = @"输入接收人编号";
            [_pickUpButton setTitle:@"确定转赠" forState:UIControlStateNormal];
            
            [self createMeberNameUI];
        }
            break;
    }
}

/// 创建显示会员编号的ui
-(void)createMeberNameUI{
    _herMemberNumField = [self createField:CGRectMake(_transNumField.ly_x, _herNameField.ly_maxY + 14, _transNumField.width, _transNumField.height)];
    _herMemberNumField.placeholder = @"请输入接受人编号获取接受人姓名";
    _herMemberNumField.enabled = NO;  
    _herNameField.delegate = self;
    
    _payTiplabel.top = _herMemberNumField.ly_maxY + 14;
    _pwdInputView.top = _payTiplabel.ly_maxY + 27;
    [self layoutSubview];
}

#pragma mark - textFieldDelegate
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"username"] = textField.text;
    [self.afnetWork jsonMallPostDict:@"/api/member/getName" JsonDict:md Tag:@"2"];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        printAlert(dict[@"msg"], 1.f);
        !self.transferSuccessBlock ? : self.transferSuccessBlock();
    }else{
        NSString *truename = dict[@"data"][@"truename"];
        if([HelpManager isBlankString:truename]){
            _herMemberNumField.text = @" ";
        }else{
            _herMemberNumField.text = truename;
        }
        
    }

}

@end
