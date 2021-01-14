
//
//  TransferVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/1.
//  Copyright © 2019 王涛. All rights reserved.
//  划转

#import "TransferVC.h"
#import "TransferHeaderView.h"
#import "ReleaseFiledBaseView.h"
@interface TransferVC ()
{
    UILabel         *amountLabel; //可用多少币
    UILabel         *coinName; //币名
    
    NSMutableArray  *dataOneArray;
}
@property(nonatomic, strong) UIScrollView            *scrollView;
@property(nonatomic, strong) TransferHeaderView      *headerView;
@property(nonatomic, strong) ReleaseFiledBaseView    *coinKind; //币种
@property(nonatomic, strong) ReleaseFiledBaseView    *turnAmount; //划转数量
@property(nonatomic, strong) NSString                *coinId; //划转数量
@property(nonatomic, strong) NSString                *amountNum; //可用数量
@property(nonatomic, strong) NSString                *from_account;  //用什么转 默认法币
@property(nonatomic, strong) NSString                *to_account;     //转成什么 默认币币
@property(nonatomic, strong) UIButton                *switchTypeBtn;     //切换划转类型按钮
@property(nonatomic, strong) NSString                *accountName;
@end

@implementation TransferVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gk_navigationItem.title = LocalizationKey(@"Transfer");
    
    [self setUpView];
    
    if(self.defaultSymbol){
        coinName.text = self.defaultSymbol;
        amountLabel.text = [NSString stringWithFormat:@"%@0.00000000%@",LocalizationKey(@"Available"),self.defaultSymbol];
        _coinKind.inputField.text = self.defaultSymbol;
        self.accountName = LocalizationKey(@"Contract account");
        self.headerView.legalCurrencyAccount.text = LocalizationKey(@"Coin account");
        self.headerView.coinAccount.text = LocalizationKey(@"Contract account");
        
        [self.headerView.coinAccount addSubview:self.switchTypeBtn];
        [self.switchTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.headerView.coinAccount.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.headerView.coinAccount.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12, 17));
        }];
    }else{
        self.accountName = LocalizationKey(@"Legal currency account");
        self.headerView.legalCurrencyAccount.text = LocalizationKey(@"Legal currency account");
        self.headerView.coinAccount.text = LocalizationKey(@"Coin account");
        
        [self.headerView.legalCurrencyAccount addSubview:self.switchTypeBtn];
        [self.switchTypeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.headerView.legalCurrencyAccount.mas_right).offset(-15);
            make.centerY.mas_equalTo(self.headerView.legalCurrencyAccount.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12, 17));
        }];
    }
    //TODO:不要合约，暂放
    self.switchTypeBtn.hidden = YES;
    self.headerView.legalCurrencyAccount.userInteractionEnabled = YES;
    self.headerView.coinAccount.userInteractionEnabled = YES;
    
    [self initData];
}

#pragma mark - action

-(void)setParams{
    if(self.defaultSymbol){ //如果是合约跳转进来的
        self.headerView.coinAccount.text = self.accountName;
        if([self.accountName containsString:LocalizationKey(@"Legal currency")]){
            if(self.headerView.isCoinAccountAbove){
                self.from_account = LegalCurrency_Account;
                self.to_account = Coin_Account;
            }else{
                self.from_account = Coin_Account;
                self.to_account = LegalCurrency_Account;
            }
        }else{
            if(self.headerView.isCoinAccountAbove){
                self.from_account = Contract_Account ;
                self.to_account = Coin_Account;
            }else{
                self.from_account =  Coin_Account;
                self.to_account =  Contract_Account;
            }
        }
    }else{
        self.headerView.legalCurrencyAccount.text = self.accountName;
        if([self.accountName containsString:LocalizationKey(@"Legal currency")]){
            if(self.headerView.isCoinAccountAbove){
                self.from_account = Coin_Account;
                self.to_account = LegalCurrency_Account;
            }else{
                self.from_account = LegalCurrency_Account;
                self.to_account = Coin_Account;
            }
        }else{
            if(self.headerView.isCoinAccountAbove){
                self.from_account = Coin_Account ;
                self.to_account = Contract_Account;
            }else{
                self.from_account =  Contract_Account;
                self.to_account = Coin_Account;
            }
        }
    }
}

-(void)changedTextField:(UITextField *)textField{
   
}
//切换币种
-(void)switchKindClick{
    NSMutableArray *coinNameArray = [NSMutableArray array];
    for (int i =0; i<dataOneArray.count; i++) {
        [coinNameArray addObject:dataOneArray[i][@"symbol"]];
    }
    
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:nil message:LocalizationKey(@"SelectCurrency") preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0 ; i<coinNameArray.count; i++) {
        UIAlertAction *bank = [UIAlertAction actionWithTitle:coinNameArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            self.coinKind.inputField.text = coinNameArray[i];
            coinName.text = coinNameArray[i];
            self.coinId = dataOneArray[i][@"coin_id"];
            [self getAccountByTypeCoin];
        }];
        [ua addAction:bank];
    }
    
    UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
 
    [ua addAction:cancel1];
    [self. navigationController presentViewController:ua animated:YES completion:nil];
}
//划转全部
-(void)turnAllClick{
    if(![HelpManager isBlankString:self.amountNum]){
        self.turnAmount.inputField.text = self.amountNum;
    }else{
        printAlert(LocalizationKey(@"NetWorkErrorTip"), 1.f);
    }
}
//开始划转
-(void)startTurnClick{
    if([HelpManager isBlankString:self.turnAmount.inputField.text]){
        printAlert(LocalizationKey(@"TransferTip1"), 1.f);
        return;
    }
    
    if(fabs([self.amountNum doubleValue]) < DBL_EPSILON){
        printAlert(LocalizationKey(@"TransferTip2"), 1.f);
        return;
    }
    
    if([self.turnAmount.inputField.text doubleValue] > [self.amountNum doubleValue]){
        printAlert(LocalizationKey(@"TransferTip3"), 1.f);
        return;
    }
    
    NSMutableDictionary *netDic = [NSMutableDictionary dictionary];
    netDic[@"from_account"] = self.from_account;
    netDic[@"to_account"] = self.to_account;
    netDic[@"coin_id"] = self.coinId;
    netDic[@"amount"] = self.turnAmount.inputField.text;
    [self.afnetWork jsonPostDict:@"/api/account/transfer" JsonDict:netDic Tag:@"3" LoadingInView:self.view];
}
#pragma mark - netWork

-(void)initData{
    //TODO : 币id
    if(self.defaultSymbol){
        self.from_account = Coin_Account;
        self.to_account = Contract_Account;
        self.coinId = @"1";
        
    }else{
        self.from_account = LegalCurrency_Account;
        self.to_account = Coin_Account;
        self.coinId = @"1";
        
    }
    
    
    [self getTransfer_before];
 
}

//划转资金前获取参数
-(void)getTransfer_before {
    [self.afnetWork jsonGetDict:@"/api/account/transfer_before" JsonDict:@{@"from_account":self.from_account,@"to_account":self.to_account} Tag:@"1" LoadingInView:self.view];
    [self getAccountByTypeCoin];
}
//通过账户类型和货币ID获取可用资金数量
-(void)getAccountByTypeCoin{
    [self.afnetWork jsonGetDict:@"/api/account/getAccountByTypeCoin" JsonDict:@{@"account_type":self.from_account,@"coin_id":self.coinId} Tag:@"2" LoadingInView:self.view];
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        dataOneArray = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"data"]) {
            [dataOneArray addObject:dic];
        }
    }else if ([type isEqualToString:@"2"]){
        self.amountNum = [NSString stringWithFormat:@"%.8f",[dict[@"data"][@"money"] doubleValue]];
        amountLabel.text = [NSString stringWithFormat:@"%@%@%@",LocalizationKey(@"Available"),self.amountNum,coinName.text];
        self.turnAmount.inputField.text = @"";
    }else{
        printAlert(dict[@"msg"], 1.f);
        [self getAccountByTypeCoin];
    }
}

#pragma mark - ui
-(void)setUpView{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.headerView];
    [self.scrollView addSubview:self.coinKind];
    [self.coinKind mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.headerView.mas_bottom);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.coinKind.inputField.mas_bottom).offset(17);
    }];
    
    [self.scrollView addSubview:self.turnAmount];
    
    UIView *rightInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
    coinName = [UILabel new];
    coinName.text = @"BTC";
    coinName.textColor = grayTextColor;
    coinName.textAlignment = NSTextAlignmentCenter;
    coinName.font = tFont(18);
    [rightInputView addSubview:coinName];
    [coinName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(rightInputView.mas_left);
        make.centerY.mas_equalTo(rightInputView.mas_centerY);
    }];
    
    UIView *xian = [UIView new];
    xian.backgroundColor = rgba(76, 90, 113, 1);
    [rightInputView addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(coinName.mas_top);
        make.bottom.mas_equalTo(coinName.mas_bottom);
        make.left.mas_equalTo(coinName.mas_right).offset(5);
        
        make.width.mas_equalTo(2);
    }];
    
    UIButton *turnAllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    turnAllBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [turnAllBtn setTitle:LocalizationKey(@"All") forState:UIControlStateNormal];
    [turnAllBtn setTitleColor:MainColor forState:UIControlStateNormal];
    turnAllBtn.titleLabel.font = tFont(18);
    [rightInputView addSubview:turnAllBtn];
    [turnAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(xian.mas_right).offset(10);
        make.right.mas_equalTo(rightInputView.mas_right).offset(-10);
        make.centerY.mas_equalTo(rightInputView.mas_centerY);
    }];
    
    [turnAllBtn addTarget:self action:@selector(turnAllClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.turnAmount.inputField.rightView = rightInputView;
    
    amountLabel = [UILabel new];
    amountLabel.text = @"可用0.00000000BTC";
    amountLabel.textColor = grayTextColor;
    amountLabel.font = tFont(14);
    [self.turnAmount addSubview:amountLabel];
    [amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.turnAmount.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(self.turnAmount.inputField.mas_bottom).offset(10);
    }];
    
    [self.turnAmount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.coinKind.mas_bottom);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(amountLabel.mas_bottom).offset(17);
    }];
    
    UIView *bottomView = [UIView new];
  //  bottomView.backgroundColor = navBarColor;
    [bottomView setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
    [self.scrollView addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.turnAmount.mas_bottom);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.height.mas_equalTo(110);
    }];
    
    xian = [UIView new];
    xian.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [bottomView addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomView.mas_left);
        make.top.mas_equalTo(bottomView.mas_top);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 2));
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = rgba(144, 157, 180, 1);
    titleLabel.font = tFont(18);
    titleLabel.text = LocalizationKey(@"TransferTip4");
    [bottomView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(xian.mas_bottom).offset(15);
        make.left.mas_equalTo(bottomView.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
    
    UILabel *tip = [UILabel new];
    tip.text = LocalizationKey(@"TransferTip6");
    tip.textColor = rgba(140, 146, 157, 1);
    tip.font = tFont(16);
    tip.numberOfLines = 0;
    [bottomView addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(titleLabel.mas_left);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
        make.right.mas_equalTo(bottomView.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
    
    [bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(tip.mas_bottom).offset(15);
    }];
    
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [bottomBtn setTitle:LocalizationKey(@"Transfer") forState:UIControlStateNormal];
    bottomBtn.layer.cornerRadius = 3;
    bottomBtn.backgroundColor = qutesRedColor;
    [self.view addSubview:bottomBtn];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30,  50));
    }];
    
    [bottomBtn addTarget:self action:@selector(startTurnClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.scrollView.bounces = NO;
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, 530);
}

#pragma mark - lazyInit
-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - 70 - Height_NavBar)];
    }
    return _scrollView;
}

-(TransferHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[TransferHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
        __weak typeof(self) weakSelf = self;
        _headerView.switchTransTypeBlock = ^(BOOL isCoinAccountAbove) {
            [weakSelf setParams];
            [weakSelf getTransfer_before];
        };
    }
    return _headerView;
}

-(ReleaseFiledBaseView *)coinKind{
    if(!_coinKind){
        _coinKind = [[ReleaseFiledBaseView alloc] init];
        _coinKind.titleLabel.text = LocalizationKey(@"Currency");
        _coinKind.inputField.userInteractionEnabled = NO;
        _coinKind.userInteractionEnabled =YES;
        _coinKind.inputField.text = @"BTC";
        [_coinKind addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchKindClick)]];
    }
    return _coinKind;
}

-(ReleaseFiledBaseView *)turnAmount{
    if(!_turnAmount){
        _turnAmount = [[ReleaseFiledBaseView alloc] init];
        _turnAmount.titleLabel.text = LocalizationKey(@"TransferTip5");
        _turnAmount.inputField.keyboardType = UIKeyboardTypeDecimalPad;
     //   _turnAmount.inputField.placeholder = LocalizationKey(@"TransferTip1");
        [_turnAmount.rightBtn setHidden:YES];
        [_turnAmount.inputField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    //    [_turnAmount.inputField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
        _turnAmount.inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"TransferTip1")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
    }
    return _turnAmount;
}

-(UIButton *)switchTypeBtn{
    if(!_switchTypeBtn){
        _switchTypeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchTypeBtn theme_setImage:@"history_order_right_arrow" forState:UIControlStateNormal];
        _switchTypeBtn.userInteractionEnabled = NO;
    }
    return _switchTypeBtn;
}

@end
