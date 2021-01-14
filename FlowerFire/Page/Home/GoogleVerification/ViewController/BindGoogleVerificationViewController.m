//
//  BindGoogleVerificationViewController.m
//  FireCoin
//
//  Created by 王涛 on 2019/12/3.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BindGoogleVerificationViewController.h"
#import "InputGoogleVerficationViewController.h"
#import <LBXScanNative.h>

@interface BindGoogleVerificationViewController ()
{
    UILabel *_tip1,*_tip2;
    UILabel *_keyStr,*_tip3;
    UIImageView *_qrCodeImage;
    UIButton *_copyBtn;
    UIButton *_nextBtn;
}
@end

@implementation BindGoogleVerificationViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    [self initData];
}

-(void)setUpView{
    self.gk_navigationItem.title = LocalizationKey(@"googleVerificationTip3");
    
    CGFloat imageWidth = ScreenWidth/2.5;
    
    _tip1 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.center.y - imageWidth/2 - 30 - Height_NavBar - 25, ScreenWidth, 25)];
    _tip1.textAlignment = NSTextAlignmentCenter;
    _tip1.theme_textColor = THEME_TEXT_COLOR;
    _tip1.font = tFont(16);
    _tip1.text = LocalizationKey(@"googleVerificationTip4");
    [self.view addSubview:_tip1];
    
    
    _qrCodeImage = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth/2 - (imageWidth)/2, self.view.center.y - imageWidth/2 - Height_NavBar, imageWidth, imageWidth)];
    _qrCodeImage.image = [UIImage imageNamed:@"address_unabled_image"];
    [self.view addSubview:_qrCodeImage];
    
    _keyStr = [UILabel new];
    _keyStr.theme_textColor = THEME_TEXT_COLOR;
    _keyStr.font = tFont(14);
    _keyStr.text = @"--";
    [self.view addSubview:_keyStr];
    
    _copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_copyBtn setTitle:LocalizationKey(@"googleVerificationTip7") forState:UIControlStateNormal];
    [_copyBtn setTitleColor:MainBlueColor forState:UIControlStateNormal];
    [_copyBtn.titleLabel setFont:tFont(16)];
    [_copyBtn addTarget:self action:@selector(copyKeyStrClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_copyBtn];
    
    [_keyStr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(-30);
        make.top.mas_equalTo(_qrCodeImage.mas_bottom).offset(30);
    }];
    
    [_copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_keyStr.mas_right).offset(10);
        make.centerY.mas_equalTo(_keyStr.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(60, 40));
    }];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:LocalizationKey(@"googleVerificationTip6") forState:UIControlStateNormal];
    [_nextBtn setBackgroundColor:MainBlueColor];
    _nextBtn.layer.cornerRadius = 2;
    [_nextBtn addTarget:self action:@selector(jumpNextVCClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextBtn];
    
    _tip3 = [UILabel new];
    _tip3.theme_textColor = THEME_GRAY_TEXTCOLOR;
    _tip3.font = tFont(12);
    _tip3.textAlignment = NSTextAlignmentCenter;
    _tip3.adjustsFontSizeToFitWidth = YES;
    _tip3.text = LocalizationKey(@"googleVerificationTip5");
    [self.view addSubview:_tip3];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-10-SafeAreaBottomHeight);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 45));
    }];
    
    [_tip3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_nextBtn.mas_top).offset(-20);
        make.centerX.mas_equalTo(_nextBtn.mas_centerX);
        make.width.mas_equalTo(ScreenWidth - 4 * OverAllLeft_OR_RightSpace);
    }];
}

- (void)initData{
    //生成生成两步验证密钥
    [self.afnetWork jsonPostDict:@"/api/account/addGoogleAuth" JsonDict:nil Tag:@"1" LoadingInView:self.view];
} 

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if(dict[@"data"] != nil){
       // otpauth://totp/15653931620?secret=VQG2S2I4LB4LLRUR&issuer=Huobi

        _keyStr.text = dict[@"data"][@"secret"];
        NSString *qrCodeStr = NSStringFormat(@"otpauth://totp/%@?secret=%@&issuer=%@",[WTUserInfo shareUserInfo].mobile,_keyStr.text,APP_NAME);
        _qrCodeImage.image = [LBXScanNative createQRWithString:qrCodeStr QRSize:_qrCodeImage.size];
    }
}

#pragma mark - action
-(void)jumpNextVCClick{
    if(![HelpManager isBlankString:_keyStr.text]){
        InputGoogleVerficationViewController *vc = [InputGoogleVerficationViewController new];
        vc.secret = _keyStr.text;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        printAlert(LocalizationKey(@"googleVerificationTip9"), 1.f);
    }
}

-(void)copyKeyStrClick{
    if([_keyStr.text isEqualToString:@"--"]){
         printAlert(LocalizationKey(@"googleVerificationTip17"), 1.f);
     }else{
         UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
         pasteboard.string = _keyStr.text;
         printAlert(LocalizationKey(@"Successful copy"), 1.f);
     }
}

@end
