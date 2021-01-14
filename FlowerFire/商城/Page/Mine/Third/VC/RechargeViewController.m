//
//  RechargeViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "RechargeViewController.h"
#import "UIImage+jianbianImage.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"

@interface RechargeViewController ()
{
    UILabel *_currentMoneyLabel;
}
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
}

- (void)createUI{
    self.chooseAccountButton.frame = CGRectMake(OverAllLeft_OR_RightSpace, OverAllLeft_OR_RightSpace + Height_NavBar, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 50);
 
    self.whitBac = [[UIView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, self.chooseAccountButton.ly_maxY + 20, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 151)];
    self.whitBac.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    self.whitBac.layer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
    self.whitBac.layer.shadowOffset = CGSizeMake(0,5);
    self.whitBac.layer.shadowOpacity = 1;
    self.whitBac.layer.shadowRadius = 9;
    self.whitBac.layer.borderWidth = 0.5;
    self.whitBac.layer.borderColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0].CGColor;
    self.whitBac.layer.cornerRadius = 5;
    [self.view addSubview:self.whitBac];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.5, 14.5, 100, 13)];
    self.titleLabel.textColor = rgba(153, 153, 153, 1);
    self.titleLabel.font = tFont(13);
    [self.whitBac addSubview:self.titleLabel];
    
    self.numTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.titleLabel.ly_x, self.titleLabel.ly_maxY + 25, self.whitBac.width - 13.5 * 2, 50)];
    self.numTextField.backgroundColor = KWhiteColor;
    self.numTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.numTextField.font = [UIFont boldSystemFontOfSize:25];
    [self.whitBac addSubview:self.numTextField];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    
    UIImageView *placeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"¥"]];
    [placeView setFrame:CGRectMake(0, 10, 30, 30)];
    [leftView addSubview:placeView];
    self.numTextField.leftView = leftView;
    self.numTextField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.numTextField.ly_x, self.numTextField.ly_maxY, self.numTextField.width, 0.5)];
    line.backgroundColor = rgba(28, 43, 69, 1);
    [self.whitBac addSubview:line];
    
    _currentMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(line.ly_x, self.numTextField.ly_maxY + 13, self.numTextField.ly_width, 20)];
    NSString *moenyStr = NSStringFormat(@"当前钱包余额%@元",self.balanceNumStr);
    _currentMoneyLabel.textColor = rgba(28, 43, 69, 1);
    _currentMoneyLabel.font = tFont(13);
    [self.whitBac addSubview:_currentMoneyLabel];
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:moenyStr];
    [attr addAttribute:NSForegroundColorAttributeName value:MainColor range:[attr.string rangeOfString:self.balanceNumStr]];
    _currentMoneyLabel.attributedText = attr;
    
    self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.submitButton.layer.cornerRadius = 5;
    self.submitButton.layer.masksToBounds = YES;
    [self.view addSubview:self.submitButton];
    [self.submitButton addTarget:self action:@selector(WalletSubmitClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initData{
    self.submitButton.frame = CGRectMake(_whitBac.ly_x, _whitBac.ly_maxY + 40, _whitBac.ly_width, 50); 
    [self.submitButton setBackgroundImage:[UIImage gradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight imgSize:self.submitButton.size] forState:UIControlStateNormal];
    
    self.gk_navigationItem.title = @"充值";
    [self.submitButton setTitle:@"确定充值" forState:UIControlStateNormal];
    self.titleLabel.text = @"工资充值";
}

-(void)chooseAccountClick:(UIButton *)button{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:@"选择充值账户:" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ua1 = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.withrdawChooseAccountType = WalletChooseAccountTypeAliPay;
        [button setTitle:@"充值方式:   支付宝" forState:UIControlStateNormal];
    }];
    UIAlertAction *ua2 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.withrdawChooseAccountType = WalletChooseAccountTypeWeChat;
        [button setTitle:@"充值方式:   微信" forState:UIControlStateNormal];
    }];
    UIAlertAction *ua3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ua addAction:ua1];
    [ua addAction:ua2];
    [ua addAction:ua3];
    [self presentViewController:ua animated:YES completion:nil];
     
}

-(void)WalletSubmitClick:(UIButton *)button{
    if([HelpManager isBlankString:self.numTextField.text]){
        printAlert(@"请输入充值金额", 1.f);
        return;
    }
    switch (self.withrdawChooseAccountType) {
        case WalletChooseAccountTypeAliPay:
        {
//            // TODO: 调用支付结果开始支付
//            [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//                NSLog(@"充值结果reslut = %@",resultDic);
//            }];
        }
            break;
        default:
        {
//            PayReq* req             = [[PayReq alloc] init];
//            req.partnerId           = [dict objectForKey:@"partnerid"];
//            req.prepayId            = [dict objectForKey:@"prepayid"];
//            req.nonceStr            = [dict objectForKey:@"noncestr"];
//            req.timeStamp           = stamp.intValue;
//            req.package             = [dict objectForKey:@"package"];
//            req.sign                = [dict objectForKey:@"sign"];
//            [WXApi  sendReq:req completion:^(BOOL success) {
//                
//            }];
        }
            break;
    }
   
}

-(UIButton *)chooseAccountButton{
    if(!_chooseAccountButton){
        _chooseAccountButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseAccountButton setTitle:@"充值方式:   支付宝" forState:UIControlStateNormal];
        [_chooseAccountButton setTitleColor:KBlackColor forState:UIControlStateNormal];
        [self.view addSubview:_chooseAccountButton];
        _chooseAccountButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _chooseAccountButton.titleLabel.font = tFont(15);
        _chooseAccountButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
        [_chooseAccountButton addTarget:self action:@selector(chooseAccountClick:)  forControlEvents:UIControlEventTouchUpInside];
        _chooseAccountButton.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
        _chooseAccountButton.layer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
        _chooseAccountButton.layer.shadowOffset = CGSizeMake(0,5);
        _chooseAccountButton.layer.shadowOpacity = 1;
        _chooseAccountButton.layer.shadowRadius = 9;
        _chooseAccountButton.layer.borderWidth = 0.5;
        _chooseAccountButton.layer.borderColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0].CGColor;
         _chooseAccountButton.layer.cornerRadius = 5;
        [self.view addSubview:_chooseAccountButton];
        
    }
    return _chooseAccountButton;
}

@end
