//
//  WithrdawViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WithrdawViewController.h"
#import "UIImage+jianbianImage.h"
#import <LSTPopView.h>
#import "InputPwdPopView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"

NSNotificationName const AuthAlipaySuccessNotice = @"AuthAlipaySuccessNotice";



@interface WithrdawViewController ()<UITextFieldDelegate>
{
    UILabel  *_tip;
    BOOL      _cashPass2;//是否需要输入密码
}


@end

@implementation WithrdawViewController
  
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AuthAlipaySuccessNotice:) name:AuthAlipaySuccessNotice object:nil];
}

#pragma mark - notice
-(void)AuthAlipaySuccessNotice:(NSNotification *)notice{
    //拿到SDK反给的code等信息传给后台就可以提现咯😊
    NSString *authCode = notice.userInfo[@"authCode"];
    NSLog(@"%@",authCode);
}

 - (void)initData{
     //提现前接口
     NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
     md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
     md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
     md[@"isblock"] = @"1";
     md[@"sheet"] = self.bankName;
     [self.afnetWork jsonMallPostDict:@"/api/finance/withdraw" JsonDict:md Tag:@"1" LoadingInView:self.view];
 }

-(void)chooseAccountClick:(UIButton *)button{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:@"选择提现账号:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ua1 = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.withrdawChooseAccountType = WalletChooseAccountTypeAliPay;
        [button setTitle:@"提现到:   支付宝" forState:UIControlStateNormal];
    }];
    UIAlertAction *ua2 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.withrdawChooseAccountType = WalletChooseAccountTypeWeChat;
        [button setTitle:@"提现到:   微信" forState:UIControlStateNormal];
    }];
    UIAlertAction *ua3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ua addAction:ua1];
    [ua addAction:ua2];
    [ua addAction:ua3];
    [self presentViewController:ua animated:YES completion:nil];
     
}

//提现点击
-(void)WalletSubmitClick:(UIButton *)button{
    if([HelpManager isBlankString:self.numTextField.text]){
        printAlert(@"请输入提现金额", 1.f);
        return;
    }
    
    if(_cashPass2){ //需要验证支付密码
        InputPwdPopView *inputPwdView = [[InputPwdPopView alloc] initWithFrame:CGRectMake(0, ScreenHeight / 2 - 92, ScreenWidth * 0.8, 184)];
        LSTPopView *popView = [LSTPopView initWithCustomView:inputPwdView];
        [popView pop];
        
        @weakify(popView)
        inputPwdView.closePopViewBlock = ^{
         @strongify(popView)
            [popView dismiss];
        };
        inputPwdView.pwdInputView.textDidChangeblock = ^(NSString * _Nullable text, BOOL isFinished) {
            @strongify(popView)
            if(isFinished){
                 [self withdrawsaveNetWork:text];
                //TODO: 支付宝微信线上转账
                
//                if(self.withrdawAccountType == WithrdawAccountTypeWeChat){
//                    //WXApi
//                }else{
//// 只需让后台给咱们反一个authStr(和支付的差不多),然后调SDK授权,在回调中拿到SDK反给的code等信息传给后台就可以提现咯😊
//                     [[AlipaySDK defaultService] auth_V2WithInfo:@"1" fromScheme:AlipayScheme callback:^(NSDictionary *resultDic) {
//                          NSLog(@"%@",resultDic);
//                     }];
//
//                }
                
                [popView dismiss];
            }
        };
    }else{
        [self withdrawsaveNetWork:@""];
    }
}

/// 提现网络请求
-(void)withdrawsaveNetWork:(NSString *)pass2Str{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:6];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"isblock"] = @"1";
    md[@"sheet"] = self.bankName;
    md[@"tixian_money"] = self.numTextField.text;
    md[@"confirm_pass2"] = pass2Str;
    [self.afnetWork jsonMallPostDict:@"/api/finance/withdrawsave" JsonDict:md Tag:@"2" LoadingInView:self.view];
}
 
#pragma mark - dataSource
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        //NSString *tax = dict[@"data"][@"tax"];
        _cashPass2 = dict[@"data"][@"cashPass2"];
        NSString *tipStr = dict[@"data"][@"remarks"];// NSStringFormat(@"注:1.提现会收取提现金额%@%%的手续费，直接从提现金额中扣除。\n    2.提现金额必须是50的整数倍\n    3.提现金额会在2小时以内到账，请耐心等待",tax);
          
    
        [self.chooseAccountButton setTitle:@"提现到:   支付宝" forState:UIControlStateNormal];
        
        _tip = [[UILabel alloc] initWithFrame:CGRectMake(self.whitBac.ly_x, self.whitBac.ly_maxY + 21.5, self.whitBac.ly_width - 25, 40)];
        _tip.numberOfLines = 0;
        _tip.font = tFont(11);
        _tip.textColor = rgba(153, 153, 153, 1);
        
        _tip.text = tipStr;
        [self.view addSubview:_tip];
        [_tip sizeToFit];
           
        self.submitButton.frame = CGRectMake(self.whitBac.ly_x, _tip.ly_maxY + 27, self.whitBac.ly_width, 50);
        [self.submitButton setBackgroundImage:[UIImage gradientColorImageFromColors:MaingradientColor  gradientType:GradientTypeLeftToRight imgSize:self.submitButton.size] forState:UIControlStateNormal];
           
        self.gk_navigationItem.title = @"提现";
        [self.submitButton setTitle:@"提现" forState:UIControlStateNormal];
        self.titleLabel.text = @"提现";
        
        self.numTextField.delegate = self;
    }else{
        printAlert(dict[@"msg"], 1.f);
        !self.backFreshBlock ? : self.backFreshBlock();
        [self closeVC];
    }
    
     
}

@end
