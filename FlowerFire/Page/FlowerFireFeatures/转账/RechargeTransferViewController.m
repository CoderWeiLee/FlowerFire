//
//  RechargeTransferViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/9/10.
//  Copyright © 2020 Celery. All rights reserved.
//  充值

#import "RechargeTransferViewController.h"
#import "SettingUpdateSubmitButton.h"
#import "SettingUpdateFormCell.h"
#import "LightningChargeFormView.h"
#import "SettingFundPwdViewController.h"
#import "ScanCodeViewController.h"

@interface RechargeTransferViewController ()<UITextFieldDelegate>
{
    LightningChargeFormView *_herIDFormView,*_transNumFormView,*_pwdFormView,*_selectedCoinFormView;
    WTLabel *_moneyLabel;
    NSString *_min_amount_transfer,*_max_amount_transfer,*_coin_id;
    NSMutableArray *_coinArray;
    NSString       *_currentCoinName;
}
/// 扫码后对方的提币地址数组
@property(nonatomic, strong)NSMutableArray *herAddressArray;
@end

@implementation RechargeTransferViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        _currentCoinName = @"";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}
 
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
     
    if([HelpManager isBlankString:[WTUserInfo shareUserInfo].paypass]){
        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:LocalizationKey(@"578Tip121") message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:LocalizationKey(@"Go to set") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SettingFundPwdViewController *svc = [SettingFundPwdViewController new];
            [self.navigationController pushViewController:svc animated:YES];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self closeVC];
        }];
        [actionSheet addAction:action2];
        [actionSheet addAction:action1];
        [self presentViewController:actionSheet animated:YES completion:nil];
    }else{
        if(self.herName.length>0){
            _herIDFormView.text = self.herName;
            _coin_id = @"21";
            [self searchWallet];
        }
    }

}

-(void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"578Tip163");
}

- (void)createUI{
    _herIDFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 22+Height_NavBar, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"578Tip124") placeHolderStr:LocalizationKey(@"578Tip125")];
    _herIDFormView.userInteractionEnabled = NO;
    [self.view addSubview:_herIDFormView];
    
    // 去掉对方ID、
//    _herNameFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _herIDFormView.bottom + 22, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"575Tip22") placeHolderStr:LocalizationKey(@"575Tip23")];
//    _herNameFormView.userInteractionEnabled = NO;
//    [self.view addSubview:_herNameFormView];
    
    _selectedCoinFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _herIDFormView.bottom + 22, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"575Tip59") placeHolderStr:LocalizationKey(@"575Tip60")];
    _selectedCoinFormView.userInteractionEnabled = NO;
    _selectedCoinFormView.text = @"SD";
    [self.view addSubview:_selectedCoinFormView];
    
    WTButton *selectedCoinButton = [[WTButton alloc] initWithFrame:_selectedCoinFormView.frame];
    [self.view addSubview:selectedCoinButton];
    
    _transNumFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _selectedCoinFormView.bottom + 22, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"578Tip164") placeHolderStr:LocalizationKey(@"575Tip25")];
    _transNumFormView.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_transNumFormView];
    
    _moneyLabel = [[WTLabel alloc] initWithFrame:CGRectMake(_transNumFormView.left + 15, _transNumFormView.bottom + 13, ScreenWidth, 20) Text:LocalizationKey(@"575Tip27") Font:tFont(13) textColor:rgba(51, 51, 51, 1) parentView:self.view];
    
    _pwdFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _moneyLabel.bottom + 22, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"575Tip28") placeHolderStr:LocalizationKey(@"575Tip29")];
    _pwdFormView.secureTextEntry = YES;
    [self.view addSubview:_pwdFormView];
    
    WTButton *submitButton = [[WTButton alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _pwdFormView.bottom + 65, _pwdFormView.width, 50) titleStr:LocalizationKey(@"578Tip166") titleFont:tFont(15) titleColor:KWhiteColor parentView:self.view];
    submitButton.backgroundColor = MainColor;
    submitButton.layer.cornerRadius = 5;
    [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initData{
    //获取币币转账基础配置 /api/cc/getBasicset
    [self.afnetWork jsonPostDict:@"/api/cc/getBasicset" JsonDict:nil Tag:@"2"];
     
}
//查下钱包
-(void)searchWallet{
    if(![HelpManager isBlankString:_coin_id]){
        [self.afnetWork jsonGetDict:@"/api/account/getAccountByTypeCoin" JsonDict:@{@"account_type":Coin_Account,@"coin_id":_coin_id} Tag:@"1"];
    }
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        NSString *useableStr = [NSString stringWithFormat:@"%@%@",dict[@"data"][@"money"],_currentCoinName];
        
        NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@ %@",LocalizationKey(@"575Tip27"),useableStr)];
        [ma yy_setColor:rgba(51, 51, 51, 1) range:[[ma string] rangeOfString:LocalizationKey(@"575Tip27")]];
        [ma yy_setColor:MainBlueColor range:[[ma string] rangeOfString:useableStr]];
        
        _moneyLabel.attributedText = ma;
    }else if([type isEqualToString:@"2"]){
        //最低转账金额
        _min_amount_transfer = dict[@"data"][@"min_amount_transfer"];
        //最高转账金额0不限制
        _max_amount_transfer = dict[@"data"][@"max_amount_transfer"];
        _transNumFormView.placeholder = NSStringFormat(@"%@%@,%@%@",LocalizationKey(@"575Tip25"),_min_amount_transfer,LocalizationKey(@"575Tip26"),_max_amount_transfer);
    }else if([type isEqualToString:@"4"]){
        printAlert(dict[@"msg"], 1.f);
        [self closeVC];
    }else if([type isEqualToString:@"5"]){
        _coinArray = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"data"]) {
            [_coinArray addObject:dic];
        }
        
        
    }
}

-(void)dataErrorHandle:(NSDictionary *)dict type:(NSString *)type{
    if(![HelpManager isBlankString:dict[@"msg"]]  ){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            printAlert(dict[@"msg"], 1.5f);
        });
        
        [self initData];
        
    }
    
}
 

#pragma mark - action
-(void)submitClick{
    NSLog(@"%@",[WTUserInfo shareUserInfo].token);
    //去设置
    if([HelpManager isBlankString:self.herName]){
        printAlert(LocalizationKey(@"575Tip23"), 1.f);
        return;
    }
    if([HelpManager isBlankString:_transNumFormView.text]){
        printAlert(LocalizationKey(@"575Tip42"), 1.f);
        return;
    }
    if([HelpManager isBlankString:_pwdFormView.text]){
        printAlert(LocalizationKey(@"575Tip29"), 1.f);
        return;
    }
    if([HelpManager isBlankString:_coin_id]){
        printAlert(LocalizationKey(@"575Tip60"), 1.f);
        return;
    }

    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:5];
    md[@"target"] = self.herName; //对方的用户id或者SD钱包地址
    md[@"money"] = _transNumFormView.text;
    md[@"coin_id"] = _coin_id;
    md[@"paypass"] = _pwdFormView.text;
    md[@"is_transfer"] = @"0";//0代表是SD充值,1为转账
    [self.afnetWork jsonPostDict:@"/api/cc/ccTransfers" JsonDict:md Tag:@"4"];
}

-(void)jumpScanQRCodeVC{
    ScanCodeViewController *svc = [ScanCodeViewController new];
    @weakify(self)
    svc.qrCodeBlock = ^(NSString * _Nonnull scanResult) {
        @strongify(self)
        self.herName = scanResult;
    };
    [self.navigationController pushViewController:svc animated:YES];
}
//扫码后根据用户名获取对方 username 获取钱包地址
//-(void)searchHerWallertAddress:(NSString *)herName{
//    if(![HelpManager isBlankString:herName]){
//        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:1];
//        md[@"username"] = herName;
//        [self.afnetWork jsonPostDict:@"/api/cc/getccTransfersAddress" JsonDict:md Tag:@"3"];
//    }
//}
  


@end
