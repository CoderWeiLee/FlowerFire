//
//  TransferViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/29.
//  Copyright © 2020 Celery. All rights reserved.
//  转账

#import "TransferViewController.h"
#import "SettingUpdateSubmitButton.h"
#import "SettingUpdateFormCell.h"
#import "LightningChargeFormView.h"
#import "SettingFundPwdViewController.h"
#import "ScanCodeViewController.h"

@interface TransferViewController ()<UITextFieldDelegate>
{
    LightningChargeFormView *_herIDFormView,*_transNumFormView,*_pwdFormView,*_selectedCoinFormView,*_emailFormView;
    WTLabel *_moneyLabel;
    NSString *_min_amount_transfer,*_max_amount_transfer,*_coin_id;
    NSMutableArray *_coinArray;
    NSString       *_currentCoinName;
    NSString       *_herID;
    WTButton       *_sendCodeButton;
//    SettingUpdateSubmitButton *_bottomView;
//    UITextField   *_transferNum,*_herAccount,*_fee;
//    WTLabel       *_balanceLabel;
}
/// 扫码后对方的提币地址数组
@property(nonatomic, strong)NSMutableArray *herAddressArray;
@end

@implementation TransferViewController

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
    _coin_id = [NSString stringWithFormat:@"%@",self.coin_id];
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
            [self textFieldDidEndEditing:_herIDFormView];
        }
    }

}

-(void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"578Tip80");
}

- (void)createUI{
    _herIDFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 22+Height_NavBar, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"578Tip124") placeHolderStr:LocalizationKey(@"578Tip125")];
     
    WTBacView *rightBac = [[WTBacView alloc] initWithFrame:CGRectMake(0, 0, 50, 45) backGroundColor:_herIDFormView.backgroundColor parentView:nil];
    WTButton *scanButton = [[WTButton alloc] initWithFrame:CGRectMake(10, 7.5, 30, 30) buttonImage:[UIImage imageNamed:@"address_scan_normal_icon"] parentView:rightBac];
    [scanButton addTarget:self action:@selector(jumpScanQRCodeVC) forControlEvents:UIControlEventTouchUpInside];
    _herIDFormView.rightView = rightBac;
    _herIDFormView.rightViewMode = UITextFieldViewModeAlways;
    
    _herIDFormView.delegate = self;
    [self.view addSubview:_herIDFormView];
    
    // 去掉对方ID、
//    _herNameFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _herIDFormView.bottom + 22, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"575Tip22") placeHolderStr:LocalizationKey(@"575Tip23")];
//    _herNameFormView.userInteractionEnabled = NO;
//    [self.view addSubview:_herNameFormView];
    
    _selectedCoinFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _herIDFormView.bottom + 22, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"575Tip59") placeHolderStr:LocalizationKey(@"575Tip60")];
    _selectedCoinFormView.userInteractionEnabled = NO;
    [self.view addSubview:_selectedCoinFormView];
    _selectedCoinFormView.text = self.symbol;
    WTButton *selectedCoinButton = [[WTButton alloc] initWithFrame:_selectedCoinFormView.frame];
    [self.view addSubview:selectedCoinButton];
    
    _transNumFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _selectedCoinFormView.bottom + 22, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"575Tip24") placeHolderStr:@""];//LocalizationKey(@"575Tip25")
    _transNumFormView.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_transNumFormView];
    
    _moneyLabel = [[WTLabel alloc] initWithFrame:CGRectMake(_transNumFormView.left + 15, _transNumFormView.bottom + 13, ScreenWidth, 20) Text:[NSString stringWithFormat:@"%@",LocalizationKey(@"575Tip27eee")] Font:tFont(15) textColor:rgba(51, 51, 51, 1) parentView:self.view];
    
    _pwdFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _moneyLabel.bottom + 22, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"575Tip28") placeHolderStr:LocalizationKey(@"575Tip29")];
    _pwdFormView.secureTextEntry = YES;
    [self.view addSubview:_pwdFormView];
     
//    _emailFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(_pwdFormView.left, _pwdFormView.bottom + 22, _pwdFormView.width, _pwdFormView.height) leftText:@"" placeHolderStr:@""];
//    _emailFormView.textAlignment = NSTextAlignmentLeft;
//    _emailFormView.placeholder = LocalizationKey(@"changeLoginPwdTip11");
//
//    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 45)];
//    _emailFormView.leftView = leftView;
//    _emailFormView.leftViewMode = UITextFieldViewModeAlways;
//
//    _sendCodeButton = [[WTButton alloc] initWithFrame:CGRectMake(0, 0, 100, 45) titleStr:NSStringFormat(@"%@   ",LocalizationKey(@"changeLoginPwdTip12")) titleFont:tFont(13) titleColor:MainBlueColor parentView:nil];
//    [_sendCodeButton addTarget:self action:@selector(getCaptchaClick) forControlEvents:UIControlEventTouchUpInside];
//
//    _emailFormView.rightView = _sendCodeButton;
//    _emailFormView.rightViewMode = UITextFieldViewModeAlways;
    
    [self.view addSubview:_emailFormView];
    
    WTButton *submitButton = [[WTButton alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _pwdFormView.bottom + 65, _pwdFormView.width, 50) titleStr:LocalizationKey(@"575Tip30") titleFont:tFont(15) titleColor:KWhiteColor parentView:self.view];
    submitButton.backgroundColor = MainColor;
    submitButton.layer.cornerRadius = 5;
    [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [selectedCoinButton addTarget:self action:@selector(selectedCoinClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initData{
    //获取币币转账基础配置 /api/cc/getBasicset
    [self.afnetWork jsonPostDict:@"/api/cc/getBasicset" JsonDict:nil Tag:@"2"];
    [self searchWallet];
     
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
        
        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};

        NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@ %@%@",LocalizationKey(@"575Tip27eee"),useableStr,self.symbol) attributes:dic];
        [ma yy_setColor:rgba(51, 51, 51, 1) range:[[ma string] rangeOfString:[NSString stringWithFormat:@"%@",LocalizationKey(@"575Tip27eee")]]];
        [ma yy_setColor:MainBlueColor range:[[ma string] rangeOfString:useableStr]];
        [ma yy_setColor:MainBlueColor range:[[ma string] rangeOfString:self.symbol]];
    


        _moneyLabel.attributedText = ma;
    }else if([type isEqualToString:@"2"]){
        //最低转账金额
        _min_amount_transfer = dict[@"data"][@"min_amount_transfer"];
        //最高转账金额0不限制
        _max_amount_transfer = dict[@"data"][@"max_amount_transfer"];
//        _transNumFormView.placeholder = NSStringFormat(@"%@%@,%@%@",LocalizationKey(@"575Tip25"),_min_amount_transfer,LocalizationKey(@"575Tip26"),_max_amount_transfer);
    }else if([type isEqualToString:@"3"]){
        NSLog(@"token:%@",[WTUserInfo shareUserInfo].token);
        _herID = NSStringFormat(@"%@",dict[@"data"][@"id"]);
          
    }else if([type isEqualToString:@"4"]){
        printAlert(dict[@"msg"], 1.f);
        [self closeVC];
    }else if([type isEqualToString:@"5"]){
        _coinArray = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"data"]) {
            [_coinArray addObject:dic];
        }
        
        [self showChooseCoinView];
    }else{
        printAlert(dict[@"msg"], 1.f);
        [[HelpManager sharedHelpManager] sendVerificationCode:_sendCodeButton];
    }
}

-(void)dataErrorHandle:(NSDictionary *)dict type:(NSString *)type{
    if(![HelpManager isBlankString:dict[@"msg"]]  ){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            printAlert(dict[@"msg"], 1.5f);
        });
        
        if([type isEqualToString:@"3"]){
            _herID = @"";
            _herIDFormView.text = @"";
        }else{
            [self initData];
        }
    }
    
}
 

#pragma mark - action
-(void)submitClick{
    NSLog(@"%@",[WTUserInfo shareUserInfo].token);
    //去设置
    if([HelpManager isBlankString:_herID]){
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
//    if([HelpManager isBlankString:_emailFormView.text]){
//        printAlert(LocalizationKey(@"changeLoginPwdTip11"), 1.f);
//        return;
//    }

    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:5];
    md[@"target"] = _herID; //对方的用户id或者SD钱包地址
    md[@"money"] = _transNumFormView.text;
    md[@"coin_id"] = _coin_id;
    md[@"paypass"] = _pwdFormView.text;
    md[@"is_transfer"] = @"1";//0代表是SD充值,1为转账
    md[@"email"] = [WTUserInfo shareUserInfo].email;
    md[@"code"] = _emailFormView.text;
    [self.afnetWork jsonPostDict:@"/api/cc/ccTransfers" JsonDict:md Tag:@"4"];
}
//币币闪充转账获取货币列表
-(void)selectedCoinClick{
    if(_coinArray.count>0){
        [self showChooseCoinView];
    }else{
        [self.afnetWork jsonPostDict:@"/api/cc/getccTransfersCoin" JsonDict:nil Tag:@"5"];
    }
}
-(void)showChooseCoinView{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:nil message:LocalizationKey(@"575Tip60") preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i<_coinArray.count; i++) {
        UIAlertAction *abc = [UIAlertAction actionWithTitle:self->_coinArray[i][@"symbol"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             
            self->_coin_id = NSStringFormat(@"%@",self->_coinArray[i][@"coin_id"]);
            self->_currentCoinName = self->_coinArray[i][@"symbol"];
            self->_selectedCoinFormView.text = self->_currentCoinName;
            [self searchWallet];
        }];
        [ua addAction:abc];
    }
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [ua addAction:cancel];
    [self presentViewController:ua animated:YES completion:nil];
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

-(void)getCaptchaClick{ // 验证码
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"email"] = [WTUserInfo shareUserInfo].email;
    md[@"event"] = @"usdt_SD_transfer";
    
    [self.afnetWork jsonGetDict:HTTP_SEND_EMS JsonDict:md Tag:@"1000"];
}

//扫码后根据用户名获取对方 username 获取钱包地址
//-(void)searchHerWallertAddress:(NSString *)herName{
//    if(![HelpManager isBlankString:herName]){
//        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:1];
//        md[@"username"] = herName;
//        [self.afnetWork jsonPostDict:@"/api/cc/getccTransfersAddress" JsonDict:md Tag:@"3"];
//    }
//}


#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    // 币币转账获取对方用户id
    if(![HelpManager isBlankString:textField.text]){
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:1];
        md[@"username"] = textField.text;
        [self.afnetWork jsonPostDict:@"/api/cc/getccTransfersName" JsonDict:md Tag:@"3"];
    }

}



//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    [self createNavBar];
//    [self createUI];
//    [self initData];
//}
//
///// 提交修改
//-(void)submitClick{
//    [self closeVC];
//}
//
//-(void)allClick{
//    _transferNum.text = @"0";
//}
//
//-(void)scanClick{
//
//}
//
//- (void)createNavBar{
//    self.gk_navigationItem.title = LocalizationKey(@"578Tip80");
//}
//
//- (void)createUI{
//    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
//    self.tableView.bounces = NO;
//
//    _bottomView = [[SettingUpdateSubmitButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
//    [_bottomView.submitButton setTitle:LocalizationKey(@"578Tip26") forState:UIControlStateNormal];
//    [_bottomView.submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
//    self.tableView.tableFooterView = _bottomView;
//    [self.view addSubview:self.tableView];
//
//}
//
//- (void)initData{
//    self.dataArray = @[@{@"title":@"578Tip124",@"details":@"578Tip125",@"rightBtnTitle":@"578Tip83"},
//                       @{@"title":@"578Tip126",@"details":@"578Tip127",@"keyBoardType":@"2",@"rightBtnTitle":@"578Tip129"},
//                       @{@"title":@"578Tip130",@"details":@"578Tip92",@"keyBoardType":@"2"} ,
//    ].copy;
//
//    [self.tableView reloadData];
//}
//
//#pragma mark - tableViewDelegate
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *identifier = @"cell";
//    [self.tableView registerClass:[SettingUpdateFormCell class] forCellReuseIdentifier:identifier];
//    SettingUpdateFormCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
//    if(self.dataArray.count>0){
//        [cell setCellData:self.dataArray[indexPath.section]];
//    }
//    cell.loginInputView.tag = indexPath.section;
//
//    switch (indexPath.section) {
//        case 0:
//        {
//            _herAccount = cell.loginInputView;
//            [cell.rightButton addTarget:self action:@selector(scanClick) forControlEvents:UIControlEventTouchUpInside];
//        }
//            break;
//        case 1:
//        {
//            _transferNum = cell.loginInputView;
//            [cell.rightButton addTarget:self action:@selector(allClick) forControlEvents:UIControlEventTouchUpInside];
//        }
//            break;
//        default:
//        {
//            _fee = cell.loginInputView;
//        }
//            break;
//    }
//    [cell.loginInputView addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
//    cell.loginInputView.clearButtonMode = UITextFieldViewModeWhileEditing;
//
//    return cell;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 1;
//}
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return self.dataArray.count;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 91;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if(section == 2){
//        return 0;
//    }
//    return 30;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    switch (section) {
//        case 0:
//        {
//            return nil;
//        }
//        case 1:
//        {
//            UIView *bac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
//            CGFloat width = [HelpManager getLabelWidth:13 labelTxt:LocalizationKey(@"578Tip86")].width;
//            WTLabel *la = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 0, width, 30) Text:LocalizationKey(@"578Tip86") Font:tFont(13) textColor:grayTextColor parentView:bac];
//
//            _balanceLabel = [[WTLabel alloc] initWithFrame:CGRectMake(la.right+2, 0, 120, 30) Text:@"--USDT" Font:tFont(13) textColor:qutesRedColor parentView:bac];
//
//            return bac;
//        }
//            break;
//        default:
//            return nil;
//    }
//}
//
//- (void)textFieldWithText:(UITextField *)textField
//{
//    if(_herAccount.text.length && _transferNum.text.length && _fee.text.length){
//        _bottomView.submitButton.enabled = YES;
//    }else{
//        _bottomView.submitButton.enabled = NO;
//    }
//}

 

@end
