//
//  TransferViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/29.
//  Copyright © 2020 Celery. All rights reserved.
//  转账

#import "JiaoYiVC.h"
#import "SettingUpdateSubmitButton.h"
#import "SettingUpdateFormCell.h"
#import "LightningChargeFormView.h"
#import "SettingFundPwdViewController.h"
#import "ScanCodeViewController.h"

@interface JiaoYiVC ()<UITextFieldDelegate>
{
    UIButton *button2;
    LightningChargeFormView *_herIDFormView,*_transNumFormView, *_pledgeNumFormView,*_pwdFormView,*_pwdFormViewB,*_selectedCoinFormView,*_emailFormView,*_dayview;
    WTLabel *_moneyLabel;
    WTLabel *_pledgeMoneyLabel;
    NSString *_min_amount_transfer,*_max_amount_transfer,*_coin_id;
    NSMutableArray *_coinArray;
    NSMutableArray *_dayArray;
    NSString       *_currentCoinName;
    NSString       *_herID;
    WTButton       *_sendCodeButton;
}
/// 扫码后对方的提币地址数组
@property(nonatomic, strong)NSMutableArray *herAddressArray;
@end

@implementation JiaoYiVC

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
    _coin_id = @"21";
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
    self.gk_navigationItem.title = LocalizationKey(@"578Tip999");
}

- (void)createUI{
//    _herIDFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 22+Height_NavBar, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"578Tip12444444") placeHolderStr:LocalizationKey(@"578Tip125")];
    _herIDFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 22+Height_NavBar, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"578Tip125555555") placeHolderStr:@""];
    _herIDFormView.userInteractionEnabled = NO;
    WTBacView *rightBac = [[WTBacView alloc] initWithFrame:CGRectMake(0, 0, 50, 45) backGroundColor:_herIDFormView.backgroundColor parentView:nil];
    WTButton *scanButton = [[WTButton alloc] initWithFrame:CGRectMake(10, 7.5, 30, 30) buttonImage:[UIImage imageNamed:@"address_scan_normal_icon"] parentView:rightBac];
    [scanButton addTarget:self action:@selector(jumpScanQRCodeVC) forControlEvents:UIControlEventTouchUpInside];
  //  _herIDFormView.rightView = rightBac;
  //  _herIDFormView.rightViewMode = UITextFieldViewModeAlways;
    
    _herIDFormView.delegate = self;
    [self.view addSubview:_herIDFormView];

    _selectedCoinFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _herIDFormView.bottom + 22, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:@"SD" placeHolderStr:@""];

    _selectedCoinFormView.userInteractionEnabled = NO;
    [self.view addSubview:_selectedCoinFormView];
    

    
    _transNumFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _selectedCoinFormView.bottom + 22, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"575Tip24777777") placeHolderStr:@""];
    _transNumFormView.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_transNumFormView];
    _moneyLabel = nil;
    _moneyLabel = [[WTLabel alloc] initWithFrame:CGRectMake(_transNumFormView.left + 15, _transNumFormView.bottom + 13, ScreenWidth, 20) Text:LocalizationKey(@"575Tip278989") Font:tFont(13) textColor:rgba(51, 51, 51, 1) parentView:self.view];

    _pwdFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _moneyLabel.bottom + 22, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"575Tip28") placeHolderStr:LocalizationKey(@"575Tip29")];
    _pwdFormView.secureTextEntry = YES;
    [self.view addSubview:_pwdFormView];
    
    WTButton *submitButton = [[WTButton alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _pwdFormView.bottom + 45, _pwdFormView.width, 50) titleStr:@"提交" titleFont:tFont(15) titleColor:KWhiteColor parentView:self.view];
    submitButton.backgroundColor = MainColor;
    submitButton.layer.cornerRadius = 25;
    [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    //输入质押数量
    _pledgeNumFormView = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, submitButton.bottom + 22, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"575Tip24444444444") placeHolderStr:@""];
    _pledgeNumFormView.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:_pledgeNumFormView];
    
    _pledgeMoneyLabel = nil;
    _pledgeMoneyLabel = [[WTLabel alloc] initWithFrame:CGRectMake(_pledgeNumFormView.left + 15, _pledgeNumFormView.bottom + 13, ScreenWidth, 20) Text:LocalizationKey(@"575Tip27777777777") Font:tFont(13) textColor:rgba(51, 51, 51, 1) parentView:self.view];
    
    _dayview = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _pledgeMoneyLabel.bottom + 22, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"575Tip28888888888") placeHolderStr:@""];
    _dayview.userInteractionEnabled = NO;
    [self.view addSubview:_dayview];

    button2 = [UIButton buttonWithType:0];
    [button2 setImage:[UIImage imageNamed:@"jiantouarrow492"] forState:0];
    button2.frame = CGRectMake(_selectedCoinFormView.right - 40,0,25,25);
    [_dayview addSubview:button2];
    
    WTButton *selectedCoinButton = [[WTButton alloc] initWithFrame:_dayview.frame];
    [self.view addSubview:selectedCoinButton];
    
    _pwdFormViewB = [[LightningChargeFormView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _dayview.bottom + 22, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 45) leftText:LocalizationKey(@"575Tip28") placeHolderStr:LocalizationKey(@"575Tip29")];
    _pwdFormViewB.secureTextEntry = YES;
    [self.view addSubview:_pwdFormViewB];
    
    WTButton *submitButtonB = [[WTButton alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _pwdFormViewB.bottom + 45, _pwdFormView.width, 50) titleStr:@"提交" titleFont:tFont(15) titleColor:KWhiteColor parentView:self.view];
    submitButtonB.backgroundColor = MainColor;
    submitButtonB.layer.cornerRadius = 25;
    [submitButtonB addTarget:self action:@selector(submitClickB) forControlEvents:UIControlEventTouchUpInside];
    [selectedCoinButton addTarget:self action:@selector(selectedCoinClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initData{
    //获取币币转账基础配置 /api/cc/getBasicset
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self.afnetWork jsonPostDict:@"/api/cc/getBasicset" JsonDict:nil Tag:@"2"];
    });
    dispatch_async(queue, ^{
        [self.afnetWork jsonGetDict:@"/api/account/bonusinfo" JsonDict:nil Tag:@"109"];
    });
    dispatch_async(queue, ^{
    //    [self.afnetWork jsonGetDict:@"/api/account/getAccountByTypeCoin" JsonDict:@{@"account_type":Coin_Account,@"coin_id":_coin_id} Tag:@"1"];

//        [self searchWallet];
    });
    
    //获取锁仓规则
    [self.afnetWork jsonGetDict:@"/api/lock/rule" JsonDict:nil Tag:@"8888"];
}
//查下钱包
-(void)searchWallet{
   // if(![HelpManager isBlankString:_coin_id]){
  //  }
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    
    if([type isEqualToString:@"109"]){
    NSString *useableStr = [NSString stringWithFormat:@"%@%@",dict[@"data"][@"balance"],_currentCoinName];
   
   NSString *countStr = [NSString stringWithFormat:@"%@%@",dict[@"data"][@"count"],@"次"];

    // 575Tip2775678
    NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@ %@ %@ %@",LocalizationKey(@"575Tip2775678"),countStr,LocalizationKey(@"575Tip278989"),useableStr)];
    // 575Tip2775678

    [ma yy_setColor:rgba(51, 51, 51, 1) range:[[ma string] rangeOfString:LocalizationKey(@"575Tip278989")]];
        
    [ma yy_setColor:MainBlueColor range:[[ma string] rangeOfString:useableStr]];
        
    [ma yy_setColor:MainBlueColor range:[[ma string] rangeOfString:countStr]];

    _moneyLabel.attributedText = ma;
        
        //质押数量
        NSMutableAttributedString *pledgeMa = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@ %@",LocalizationKey(@"575Tip27777777777"),useableStr)];
        [pledgeMa yy_setColor:rgba(51, 51, 51, 1) range:[[pledgeMa string] rangeOfString:LocalizationKey(@"575Tip27777777777")]];
        [pledgeMa yy_setColor:MainBlueColor range:[[pledgeMa string] rangeOfString:useableStr]];
        
        _pledgeMoneyLabel.attributedText = pledgeMa;
    }
   else if([type isEqualToString:@"1"]){
        NSString *useableStr = [NSString stringWithFormat:@"%@%@",dict[@"data"][@"money"],_currentCoinName];
        // 575Tip2775678
        NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@ %@",LocalizationKey(@"575Tip278989"),useableStr)];
        [ma yy_setColor:rgba(51, 51, 51, 1) range:[[ma string] rangeOfString:LocalizationKey(@"575Tip278989")]];
        [ma yy_setColor:MainBlueColor range:[[ma string] rangeOfString:useableStr]];
        
        _moneyLabel.attributedText = ma;
       
       
       //质押数量
       NSMutableAttributedString *pledgeMa = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@ %@",LocalizationKey(@"575Tip27777777777"),useableStr)];
       [pledgeMa yy_setColor:rgba(51, 51, 51, 1) range:[[pledgeMa string] rangeOfString:LocalizationKey(@"575Tip27777777777")]];
       [pledgeMa yy_setColor:MainBlueColor range:[[pledgeMa string] rangeOfString:useableStr]];
       
       _pledgeMoneyLabel.attributedText = pledgeMa;
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
        
      //  [self showChooseCoinView];
    }else if ([type isEqualToString:@"8888"]) {
        _dayArray = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"data"][@"lock_rule"]) {
            [_dayArray addObject:dic];
        }
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
    md[@"money"] = _transNumFormView.text;
    md[@"paypass"] = _pwdFormView.text;
    [self.afnetWork jsonPostDict:@"/api/account/transfortobusiness" JsonDict:md Tag:@"4"];
}

-(void)submitClickB{
    NSLog(@"%@",[WTUserInfo shareUserInfo].token);
    //去设置
    if([HelpManager isBlankString:_pledgeNumFormView.text]){
        printAlert(LocalizationKey(@"575Tip42"), 1.f);
        return;
    }
    if([HelpManager isBlankString:_pwdFormViewB.text]){
        printAlert(LocalizationKey(@"575Tip29"), 1.f);
        return;
    }
    if([HelpManager isBlankString:_coin_id]){
        printAlert(LocalizationKey(@"575Tip600"), 1.f);
        return;
    }
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:5];
    md[@"day"] = self->_dayview.text;
    md[@"amount"] = _pledgeNumFormView.text;
    md[@"paypass"] = _pwdFormViewB.text;
    [self.afnetWork jsonPostDict:@"/api/lock/enterb" JsonDict:md Tag:@"4"];
}

//币币闪充转账获取货币列表
-(void)selectedCoinClick{
    if(_dayArray.count>0){
        [self showChooseCoinView];
    }else{
        [self.afnetWork jsonPostDict:@"/api/cc/getccTransfersCoin" JsonDict:nil Tag:@"5"];
    }
    
}

-(void)showChooseCoinView{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:nil message:LocalizationKey(@"575Tip600") preferredStyle:UIAlertControllerStyleActionSheet];
//    NSArray *dayarray = @[@"10天",@"50天",@"100天"];
    for (int i = 0; i<_dayArray.count; i++) {
        UIAlertAction *abc = [UIAlertAction actionWithTitle:_dayArray[i][@"day"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self->button2.hidden = YES;
            self->_dayview.text = action.title;
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
//            _balanceLabel = [[WTLabel alloc] initWithFrame:CGRectMake(la.right+2, 0, 120, 30) Text:@"--" Font:tFont(13) textColor:qutesRedColor parentView:bac];
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
