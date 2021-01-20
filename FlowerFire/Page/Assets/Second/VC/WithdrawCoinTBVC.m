//
//  WithdrawCoinTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/22.
//  Copyright © 2019 王涛. All rights reserved.
//  提币

#import "WithdrawCoinTBVC.h"
#import "WithdrawCoinCell.h"
#import "PayMentBottomView.h"
#import "WithdrawHelpView.h"
#import "SendVerificationCodeModalVC.h"
#import "ChooseCoinTBVC.h"
#import "CoinFlowHistoryTBVC.h"
#import "QRCodeVC.h"
#import "StyleDIY.h"
#import "ShowWithdrawAddressTBVC.h"
#import "FFBuyRecordViewController.h"
#import "SettingFundPwdViewController.h"
#import "FFChainNameView.h"
#import "ChangeEmailViewController.h"
#import "BindGoogleVerificationViewController.h"

static const CGFloat Threshold = 80;
static const CGFloat bottomViewHeight = 120;
@interface WithdrawCoinTBVC ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    UIButton *submitBtn;
    UILabel  *_coinName;
    UILabel  *_arrivalsNum;//到账数量
    NSString *_paramsArrivals;//到账数量参数
    double    _walletNum;//钱包余额
    UIButton *_headerBtn;
}

@property (nonatomic, strong)UIScrollView            *scrollView;
@property (nonatomic, assign)CGFloat                  marginTop;
@property (nonatomic, strong)PayMentBottomView       *bottomView;
@property (nonatomic, strong)NSArray<NSDictionary *> *dataArray;
@property (nonatomic, strong)WithdrawHelpView        *withdrawAddress;
@property (nonatomic, strong)WithdrawHelpView        *withdrawAmount;
@property (nonatomic, strong)WithdrawHelpView        *withdrawTag;//标签
@property (nonatomic, strong)WithdrawHelpView        *feeView;
@property (nonatomic, strong)FFChainNameView         *chainNameView;


@end

@implementation WithdrawCoinTBVC

@synthesize dataArray = _dataArray;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
   
    [self setUpView];
    
    [self getWalletData];
    [self initData];
    
    
    [self setLabelData];
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
    }
    
    if([[WTUserInfo shareUserInfo].is_googleauth integerValue] == 0){
//        UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:LocalizationKey(@"googleVerificationTip3") message:nil preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:LocalizationKey(@"Go to set") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            BindGoogleVerificationViewController *svc = [BindGoogleVerificationViewController new];
//            [self.navigationController pushViewController:svc animated:YES];
//        }];
//        UIAlertAction *action2 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//            [self closeVC];
//        }];
//        [actionSheet addAction:action2];
//        [actionSheet addAction:action1];
//        [self presentViewController:actionSheet animated:YES completion:nil];
    }
}

#pragma mark - action
-(void)submitClick{
    if([HelpManager isBlankString:self.withdrawAddress.inputTextField.text]){
        printAlert(LocalizationKey(@"WithdrawTip12"), 2.f);
        return;
    }
    if([HelpManager isBlankString:self.withdrawAmount.inputTextField.text]){
        printAlert(LocalizationKey(@"WithdrawTip13"), 2.f);
        return;
    }
    
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:LocalizationKey(@"leverageRiskWarning") message:LocalizationKey(@"WithdrawTip9") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *bank = [UIAlertAction actionWithTitle:LocalizationKey(@"determine") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([self.coinListModel.coin_id isEqual:@"21"]){
            SendVerificationCodeModalVC *mvc = [SendVerificationCodeModalVC new];
           mvc.sendVerificationCodeWhereJump = SendVerificationCodeWhereJumpWithdrawSD;
           NSMutableDictionary *md = [NSMutableDictionary dictionary];
           md[@"coin_id"] = @"21";
           md[@"target"] = self.withdrawAddress.inputTextField.text;
           md[@"money"] = self.withdrawAmount.inputTextField.text;
           md[@"is_transfer"] = @"2";
           mvc.withdrawNetDic = md;
         
           if([[WTUserInfo shareUserInfo].is_googleauth integerValue] == 1){
               mvc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
               UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:mvc];
               nav.modalPresentationStyle = UIModalPresentationOverFullScreen;;
               self.modalPresentationStyle = UIModalPresentationCurrentContext;
               [self presentViewController:nav animated:YES completion:nil];
           }else{
               mvc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
               mvc.modalPresentationStyle = UIModalPresentationOverFullScreen;;
               self.modalPresentationStyle = UIModalPresentationCurrentContext;
               [self presentViewController:mvc animated:YES completion:nil];
           }
           
           @weakify(self)
           mvc.backRefreshBlock = ^{
               @strongify(self)
               [self getWalletData];
               [self setLabelData];
           };
        }else{
               SendVerificationCodeModalVC *mvc = [SendVerificationCodeModalVC new];
               mvc.sendVerificationCodeWhereJump = SendVerificationCodeWhereJumpWithdraw;
               NSMutableDictionary *md = [NSMutableDictionary dictionary];
               md[@"coin_id"] = self.coinListModel.coin_id;
               md[@"address"] = self.withdrawAddress.inputTextField.text;
               md[@"tag"] = self->_withdrawTag.inputTextField.text;
               md[@"money"] = self.withdrawAmount.inputTextField.text;
               md[@"fee"] = self.feeView.inputTextField.text;
               md[@"amount"] = self->_paramsArrivals;
               mvc.withdrawNetDic = md;
               
               if([[WTUserInfo shareUserInfo].is_googleauth integerValue] == 1){
                   
                                       

                   
                   mvc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                   UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:mvc];
                   nav.modalPresentationStyle = UIModalPresentationOverFullScreen;;
                   self.modalPresentationStyle = UIModalPresentationCurrentContext;
                   [self presentViewController:nav animated:YES completion:nil];
                   
                   
                   
               }else{
                   //未授权直接获取
                   
                   [self.afnetWork jsonPostDict:@"/api/cc/ccTransfers" JsonDict:md Tag:@"3"];

//                   mvc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//                   mvc.modalPresentationStyle = UIModalPresentationOverFullScreen;;
//                   self.modalPresentationStyle = UIModalPresentationCurrentContext;
//                   [self presentViewController:mvc animated:YES completion:nil];
               }
               
               @weakify(self)
               mvc.backRefreshBlock = ^{
                   @strongify(self)
                   [self getWalletData];
                   [self setLabelData];
               };
        }
    }];
    
    [ua addAction:bank];
    [self presentViewController:ua animated:YES completion:nil];
    
}
//切换币
-(void)coinSwitchClick{
    ChooseCoinTBVC *cvc = [ChooseCoinTBVC new];
    cvc.isSwitchCoin = YES;
    
    @weakify(self);
    cvc.switchCoinBlock = ^(ChooseCoinListModel * _Nonnull model) {
        @strongify(self)
        self.coinListModel = model;
        [self setLabelData];
        [self getWalletData];
        //TODO:是否显示tag
    };
    
    [self.navigationController pushViewController:cvc animated:YES];
}

/**
 跳转记录页面
 */
-(void)jumpRecordClick{
    if([self.coinListModel.coin_id isEqual:@"21"]){
        FFBuyRecordViewController *fvc = [[FFBuyRecordViewController alloc] initWithFFBuyRecordType:FFBuyRecordTypeHidtoryRecord];
        [self.navigationController pushViewController:fvc animated:YES];
    }else{
        if(![HelpManager isBlankString:self.coinListModel.coin_id] &&
           ![HelpManager isBlankString:self.coinListModel.symbol]){
            CoinFlowHistoryTBVC *cvc = [[CoinFlowHistoryTBVC alloc] initWithCoinFlowHistoryType:CoinFlowHistoryTypeWithdraw CoinId:self.coinListModel.coin_id Symbol:self.coinListModel.symbol];
            [self.navigationController pushViewController:cvc animated:YES];
        }else{
            printAlert(LocalizationKey(@"NetWorkErrorTip"), 1.f);
        }
    }
}

/**
 二维码扫描
 */
-(void)jumpQRCodeVC{
    QRCodeVC *qvc = [QRCodeVC new];
    qvc.libraryType = SLT_Native;
    qvc.scanCodeType = SCT_QRCode;
    qvc.style = [StyleDIY qqStyle];
    qvc.isVideoZoom = YES;
    @weakify(self)
    qvc.qrCodeBlock = ^(NSString * _Nonnull scanResult) {
      @strongify(self)
        self.withdrawAddress.inputTextField.text = scanResult;
    };
    [self.navigationController pushViewController:qvc animated:YES];
}

/**
 添加账户
 */
-(void)jumpAddAddress{
    if(![HelpManager isBlankString:self.coinListModel.coin_id]){
        ShowWithdrawAddressTBVC *avc = [ShowWithdrawAddressTBVC new];
        avc.coinId = self.coinListModel.coin_id;
        @weakify(self)
        avc.didSeletedAddressBlock = ^(NSString * _Nonnull address, NSString * _Nonnull tag) {
            @strongify(self)
            self.withdrawAddress.inputTextField.text = address;
            if(![HelpManager isBlankString:tag]){
                self->_withdrawTag.inputTextField.text = tag;
            }
        };
        [self.navigationController pushViewController:avc animated:YES];
    }
}

-(void)allClick{
    self.withdrawAmount.inputTextField.text = NSStringFormat(@"%f",_walletNum);
    [self changedTextField:self.withdrawAmount.inputTextField];
    
}

-(void)tipClick{
    [[UniversalViewMethod sharedInstance] alertShowMessage:NSStringFormat(@"%@ %f %@",LocalizationKey(@"WithdrawTip15"),self.coinListModel.withdraw_max,self.coinListModel.symbol) WhoShow:self CanNilTitle:nil];
}

-(void)changedTextField:(UITextField *)textfield{
    if([HelpManager isBlankString:textfield.text]){
        submitBtn.enabled = NO;
    }else{
        submitBtn.enabled = YES;
    }
    if(textfield == self.withdrawAmount.inputTextField){
        double inputNum = [textfield.text doubleValue];
        double fee = self.coinListModel.withdraw_fee;
        double arrivalsNum = inputNum - fee;
        if(arrivalsNum <= 0){
            arrivalsNum = 0;
        }
        _paramsArrivals =  NSStringFormat(@"%f",arrivalsNum);
        _arrivalsNum.text = NSStringFormat(@"%@ %@",_paramsArrivals,self.coinListModel.symbol);
        self.feeView.inputTextField.text = NSStringFormat(@"%0.6f",self.coinListModel.withdraw_fee);
    }
}

#pragma mark - dataSource
/**
 用户钱包信息
 */
-(void)getWalletData{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"account_type"] = Coin_Account;
    md[@"coin_id"] = self.coinListModel.coin_id;
    [self.afnetWork jsonGetDict:@"/api/account/getAccountByTypeCoin" JsonDict:md Tag:@"1"];
}

//获取提币提示语句
-(void)initData{
    [self.afnetWork jsonGetDict:@"/api/account/withdraw" JsonDict:nil Tag:@"2"];
}

/**
 label赋值，使用上页面传来的model
 */
-(void)setLabelData{
    if(self.coinListModel){
        _coinName.text = self.coinListModel.symbol;
        self.withdrawAmount.inputTextField.text = @"";
        self.withdrawAddress.inputTextField.text = @"";
        self.withdrawAmount.inputTextField.placeholder = NSStringFormat(@"%@ %f",LocalizationKey(@"WithdrawTip2"),self.coinListModel.withdraw_min);
        [self.withdrawAmount.leftBtn setTitle:self.coinListModel.symbol forState:UIControlStateNormal];
        self.withdrawAmount.bottomLabel.text = NSStringFormat(@"%@ 0.0000 %@",LocalizationKey(@"Available"),self.coinListModel.symbol);
        [self.feeView.rightBtn setTitle:self.coinListModel.symbol forState:UIControlStateNormal];
        self.feeView.inputTextField.text = NSStringFormat(@"%0.6f",self.coinListModel.withdraw_fee);
        _arrivalsNum.text = NSStringFormat(@"0.0 %@",self.coinListModel.symbol);
        [self.bottomView.showTitleBtn setTitle:NSStringFormat(@"%@ %f%@",LocalizationKey(@"WithdrawTip3"),self.coinListModel.withdraw_min,self.coinListModel.symbol) forState:UIControlStateNormal];
    }
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqual:@"1"]){
        _walletNum = [dict[@"data"][@"money"] doubleValue];
        self.withdrawAmount.bottomLabel.text = NSStringFormat(@"%@ %f %@",LocalizationKey(@"Available"),_walletNum,self.coinListModel.symbol);
         
        if([self.coinListModel.coin_id isEqual:@"21"]){
            self.chainNameView.hidden = YES;
             
            [self.withdrawAddress mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.top.mas_equalTo(_headerBtn.mas_bottom).offset(20);
                make.left.mas_equalTo(self.scrollView.mas_left);
                make.width.mas_equalTo(ScreenWidth);
                make.bottom.mas_equalTo(self.withdrawAddress.bottomLabel.mas_bottom).offset(0);
            }];
        }else{
            self.chainNameView.hidden = NO;
             
            [self.withdrawAddress mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.chainNameView.mas_bottom).offset(20);
                make.left.mas_equalTo(self.scrollView.mas_left);
                make.width.mas_equalTo(ScreenWidth);
                make.bottom.mas_equalTo(self.withdrawAddress.bottomLabel.mas_bottom).offset(0);
            }];
        }
    }else if([type isEqual:@"2"]){
        _bottomView.showTextLabel.text = NSStringFormat(@"%@",dict[@"data"][@"prompt"]);
    }else if([type isEqual:@"3"]){
        [self getWalletData];
        [self setLabelData];
    }
    
}

#pragma mark - privateMethod
-(void)showTagView{
    [self.withdrawAmount mas_remakeConstraints:^(MASConstraintMaker *make) {  make.top.mas_equalTo(self.withdrawTag.mas_bottom).offset(OverAllLeft_OR_RightSpace);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.width.mas_equalTo(ScreenWidth);
        make.bottom.mas_equalTo(self.withdrawAmount.bottomLabel.mas_bottom).offset(0);
    }];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, 830);
}

-(void)hideTagView{
    [self.withdrawTag removeFromSuperview];
    self.withdrawTag = nil;
    [self.withdrawAmount mas_remakeConstraints:^(MASConstraintMaker *make) {  make.top.mas_equalTo(self.withdrawAddress.mas_bottom).offset(OverAllLeft_OR_RightSpace);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.width.mas_equalTo(ScreenWidth);
        make.bottom.mas_equalTo(self.withdrawAmount.bottomLabel.mas_bottom).offset(0);
    }];
    self.scrollView.contentSize = CGSizeMake(ScreenWidth, 720);
}

#pragma mark - UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *toString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSInteger limitCount;
    if(textField == self.withdrawAmount.inputTextField){
        NSString *walletNumStr = NSStringFormat(@"%f",_walletNum);
        NSRange dRange = [walletNumStr rangeOfString:@"."];
        walletNumStr = [walletNumStr substringFromIndex:dRange.location];
        limitCount = walletNumStr.length - 1;
        if (toString.length > 0) {
            NSString *stringRegex = NSStringFormat(@"(([0]|(0[.]\\d{0,2}))|([1-9]\\d{0,7}(([.]\\d{0,%ld})?)))?",limitCount); ;
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stringRegex];
            BOOL flag = [phoneTest evaluateWithObject:toString];
            if (!flag) {
                return NO;
            }
        }
    }
    return YES;
}



#pragma mark ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 实时监测scrollView.contentInset.top， 系统优化以及手动设置contentInset都会影响contentInset.top。
    if (self.marginTop != self.scrollView.contentInset.top) {
        self.marginTop = self.scrollView.contentInset.top;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat newoffsetY = offsetY + self.marginTop;
    
    // 临界值150，向上拖动时变透明
    if (newoffsetY >= 0 && newoffsetY <= -Threshold) {
        self.title = @"";
    }else if (newoffsetY > Threshold){
        self.title = LocalizationKey(@"Withdraw");
    }else{
        self.title = @"";
    }
}

#pragma mark - ui
-(void)setUpView{
    
    UIButton *barBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    barBtn.frame = CGRectMake(0, 0, 30, 30);
    [barBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 0, 4, 0)];//调整图片大小5:2
    barBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [barBtn theme_setImage:@"otc_market_history_btn" forState:UIControlStateNormal];
    self.gk_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barBtn];
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 0, ScreenWidth, Threshold)];
    la.text = LocalizationKey(@"Withdraw");
    la.theme_textColor = THEME_TEXT_COLOR;
    la.font = [UIFont boldSystemFontOfSize:30];
    la.backgroundColor = self.view.backgroundColor;
    la.layer.masksToBounds = YES;
    [self.scrollView addSubview:la];
    
    _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _headerBtn.layer.cornerRadius = 3; 
    _headerBtn.frame = CGRectMake(OverAllLeft_OR_RightSpace, CGRectGetMaxY(la.frame)+10, ScreenWidth - OverAllLeft_OR_RightSpace * 2, 50);
    _headerBtn.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
    [self.scrollView addSubview:_headerBtn];
    
    _coinName = [[UILabel alloc] init];
    _coinName.theme_textColor = THEME_TEXT_COLOR;
    _coinName.text = @"--";
    _coinName.font = tFont(15);
    _coinName.backgroundColor = _headerBtn.backgroundColor;
    _coinName.layer.masksToBounds = YES;
    [_headerBtn addSubview:_coinName];
    [_coinName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_headerBtn.mas_centerY);
        make.left.mas_equalTo(_headerBtn.mas_left).offset(15);
    }];
    
    UIImageView *goImg = [[UIImageView alloc] init];
    goImg.theme_image = @"history_order_right_arrow";
    goImg.backgroundColor = _headerBtn.backgroundColor;
    [_headerBtn addSubview:goImg];
    [goImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_headerBtn.mas_right).offset(-15);
        make.centerY.mas_equalTo(_headerBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 17));
    }];
    
    UILabel *tip = [[UILabel alloc] init];
    tip.textColor = ContractDarkBlueColor;
    tip.text = LocalizationKey(@"SelectCurrency");
    tip.font = tFont(14);
    tip.backgroundColor = _headerBtn.backgroundColor;
    tip.layer.masksToBounds = YES;
    [_headerBtn addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(goImg.mas_left).offset(-5);
        make.centerY.mas_equalTo(_headerBtn.mas_centerY);
    }];
    
    CGFloat LineSpacing = OverAllLeft_OR_RightSpace * 2 - 10;
    
    self.chainNameView = [[FFChainNameView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _headerBtn.bottom + LineSpacing, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 60)];
    [self.scrollView addSubview:self.chainNameView];
    
    self.withdrawAddress = [WithdrawHelpView new];
    self.withdrawAddress.backgroundColor = self.scrollView.backgroundColor;
    self.withdrawAddress.title.text = LocalizationKey(@"WithdrawAddress");
   // self.withdrawAddress.inputTextField.placeholder = LocalizationKey(@"WithdrawTip1");
    [self.withdrawAddress.leftBtn theme_setImage:@"address_scan_normal_icon" forState:UIControlStateNormal];
    [self.withdrawAddress.rightBtn theme_setImage:@"account_address_list_image" forState:UIControlStateNormal];
   // [self.withdrawAddress.inputTextField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
    
    self.withdrawAddress.inputTextField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizationKey(@"WithdrawTip1") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
    
    [self.scrollView addSubview:self.withdrawAddress];
    [self.withdrawAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.chainNameView.mas_bottom).offset(15);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.width.mas_equalTo(ScreenWidth);
        make.bottom.mas_equalTo(self.withdrawAddress.bottomLabel.mas_bottom).offset(0);
    }];
   
    self.withdrawAmount = [WithdrawHelpView new];
    self.withdrawAmount.backgroundColor = self.scrollView.backgroundColor;
    self.withdrawAmount.title.text = LocalizationKey(@"Amount");
    self.withdrawAmount.inputTextField.delegate = self;
  //  self.withdrawAmount.inputTextField.placeholder = NSStringFormat(@"%@ 0",LocalizationKey(@"WithdrawTip2"));
    [self.withdrawAmount.rightBtn setTitle:LocalizationKey(@"All") forState:UIControlStateNormal];
    self.withdrawAmount.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
     
 //   [self.withdrawAmount.inputTextField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
    [self.scrollView addSubview:self.withdrawAmount];
    [self.withdrawAmount mas_makeConstraints:^(MASConstraintMaker *make) {  make.top.mas_equalTo(self.withdrawAddress.mas_bottom).offset(OverAllLeft_OR_RightSpace);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.width.mas_equalTo(ScreenWidth);
        make.bottom.mas_equalTo(self.withdrawAmount.bottomLabel.mas_bottom).offset(0);
    }];
    
    UIButton *tipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [tipBtn theme_setImage:@"risk_rate_instruction" forState:UIControlStateNormal];
    tipBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.withdrawAmount addSubview:tipBtn];
    [tipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.withdrawAmount.bottomLabel.mas_centerY);
        make.left.mas_equalTo(self.withdrawAmount.bottomLabel.mas_right).offset(3);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    [tipBtn addTarget:self action:@selector(tipClick) forControlEvents:UIControlEventTouchUpInside];
    //578隐藏最大提币数量
    tipBtn.hidden = YES;
    
    self.feeView = [WithdrawHelpView new];
    self.feeView.backgroundColor = self.scrollView.backgroundColor;
    self.feeView.title.text = LocalizationKey(@"Fee");
  
    [self.feeView.leftBtn setHidden:YES];
    self.feeView.line.hidden = YES;
    self.feeView.inputTextField.enabled = NO;
   
    [self.scrollView addSubview:self.feeView];
    [self.feeView mas_makeConstraints:^(MASConstraintMaker *make) {  make.top.mas_equalTo(self.withdrawAmount.mas_bottom).offset(OverAllLeft_OR_RightSpace);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.width.mas_equalTo(ScreenWidth);
        make.bottom.mas_equalTo(self.feeView.bottomLabel.mas_bottom).offset(0);
    }];
    
    self.bottomView.showTextLabel.text = LocalizationKey(@"WithdrawTip6");
    [self.scrollView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.feeView.mas_bottom).offset(LineSpacing);
        make.left.mas_equalTo(_headerBtn.mas_left);
        make.width.mas_equalTo(ScreenWidth - OverAllLeft_OR_RightSpace * 2);
    }];
    UIView *bottomView;
  
    if(IS_IPHONE_X){
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame), ScreenWidth, bottomViewHeight)];
    }else{
        bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.scrollView.frame) , ScreenWidth, bottomViewHeight - 10)];
    }
    
    
    bottomView.backgroundColor = self.scrollView.backgroundColor;
    [self.view addSubview:bottomView];
    
    UILabel *tip1 = [UILabel new];
    tip1.text = LocalizationKey(@"Number of arrivals");
    tip1.font = tFont(16);
    tip1.textColor = ContractDarkBlueColor;
    tip1.layer.masksToBounds = YES;
    tip1.backgroundColor = self.scrollView.backgroundColor;
    [bottomView addSubview:tip1];
    [tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView.mas_top).offset(OverAllLeft_OR_RightSpace);
        make.left.mas_equalTo(bottomView.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
    
    _arrivalsNum = [UILabel new];
    _arrivalsNum.theme_textColor = THEME_TEXT_COLOR;
    _arrivalsNum.font = tFont(16);
    _arrivalsNum.layer.masksToBounds = YES;
    _arrivalsNum.backgroundColor = self.scrollView.backgroundColor;
    [bottomView addSubview:_arrivalsNum];
    [_arrivalsNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView.mas_top).offset(OverAllLeft_OR_RightSpace);
        make.right.mas_equalTo(bottomView.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.layer.cornerRadius = 2;
    [submitBtn setBackgroundImage:[UIImage imageWithColor:ButtonDisabledColor] forState:UIControlStateDisabled];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:MainBlueColor] forState:UIControlStateNormal];
    submitBtn.enabled = NO;
    [submitBtn setTitle:LocalizationKey(@"Withdraw") forState:UIControlStateNormal];
    [bottomView addSubview:submitBtn];
    
    if(IS_IPHONE_X){
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(bottomView.mas_bottom).offset(-20);
            make.left.mas_equalTo(bottomView.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth - OverAllLeft_OR_RightSpace * 2, 50));
        }];
    }else{
        [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(bottomView.mas_bottom).offset(-10);
            make.left.mas_equalTo(bottomView.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth - OverAllLeft_OR_RightSpace * 2, 50));
        }];
    }
    
    [submitBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    [_headerBtn addTarget:self action:@selector(coinSwitchClick) forControlEvents:UIControlEventTouchUpInside];
    [barBtn addTarget:self action:@selector(jumpRecordClick) forControlEvents:UIControlEventTouchUpInside];
    [self.withdrawAmount.inputTextField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.withdrawAmount.rightBtn addTarget:self action:@selector(allClick) forControlEvents:UIControlEventTouchUpInside];
    [self.withdrawAddress.leftBtn addTarget:self action:@selector(jumpQRCodeVC) forControlEvents:UIControlEventTouchUpInside];
    [self.withdrawAddress.rightBtn addTarget:self action:@selector(jumpAddAddress) forControlEvents:UIControlEventTouchUpInside];
 
}

#pragma mark - lazyInit
-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - bottomViewHeight - Height_NavBar)];
        [self.view addSubview:_scrollView];
        _scrollView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        _scrollView.delegate = self;
        _scrollView.contentSize = CGSizeMake(ScreenWidth, 720);
    }
    return _scrollView;
}

-(PayMentBottomView *)bottomView{
    if(!_bottomView){
        _bottomView = [PayMentBottomView new];
        _bottomView.theme_backgroundColor = THEME_INPUT_BACKGROUNDCOLOR;
        _bottomView.showTitleBtn.titleLabel.font = tFont(16);
        _bottomView.showTextLabel.text = @"";
    }
    return _bottomView;
}

-(WithdrawHelpView *)withdrawTag{
    if(!_withdrawTag){
        _withdrawTag = [WithdrawHelpView new];
        _withdrawTag.backgroundColor = self.scrollView.backgroundColor;
        _withdrawTag.title.text = LocalizationKey(@"Tag");
       // _withdrawTag.inputTextField.placeholder = NSStringFormat(@"%@",LocalizationKey(@"WithdrawTip10"));
        [_withdrawTag.leftBtn setHidden:YES];
        [_withdrawTag.rightBtn setHidden:YES];
        _withdrawTag.line.hidden = YES;
      //  [_withdrawTag.inputTextField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
        
        _withdrawTag.inputTextField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"WithdrawTip10")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
        
        [self.scrollView addSubview:_withdrawTag];
        [_withdrawTag mas_makeConstraints:^(MASConstraintMaker *make) {  make.top.mas_equalTo(self.withdrawAddress.mas_bottom).offset(OverAllLeft_OR_RightSpace);
            make.left.mas_equalTo(self.scrollView.mas_left);
            make.width.mas_equalTo(ScreenWidth);
            make.bottom.mas_equalTo(_withdrawTag.bottomLabel.mas_bottom).offset(0);
        }];
        
        UILabel *tip = [UILabel new];
        tip.textColor = qutesRedColor;
        tip.backgroundColor = self.scrollView.backgroundColor;
        tip.layer.masksToBounds = YES;
        tip.text = LocalizationKey(@"WithdrawTip11");
        tip.font = tFont(13);
        [_withdrawTag addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_withdrawTag.title.mas_right).offset(5);
            make.centerY.mas_equalTo(_withdrawTag.title.mas_centerY);
        }];
    }
    return _withdrawTag;
}

@end
