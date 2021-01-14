//
//  ReleaseWantBuyChildVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/31.
//  Copyright © 2019 王涛. All rights reserved.
//  发布委托单

#import "ReleaseWantBuyChildVC.h"
#import "ReleaseFiledBaseView.h"
#import "SZCalendarPicker.h"  
#import "AccountsReceivableSettingTBVC.h"

@interface ReleaseWantBuyChildVC ()
{
    UILabel  *priceLabel; //货币交易当前价格
    UILabel  *_accountBalance; //可用数量
    UIView   *bottomView;
    UIButton *releaseBtn; //发布按钮
    UILabel  *buyMargin; //b买单保证金
    UILabel  *serviceFee; //服务费
    NSString *buOrSeal;
    double   availableNum;//可用数量
    NSString *content; //默认备注d内容
    
    NSString *paramsVerifyLevel;
    NSString *paramsPaymentTime;
    NSString *paramsRegTime;
}
@property(nonatomic, strong) ReleaseFiledBaseView *pricingMethod;      //定价方式
@property(nonatomic, strong) ReleaseFiledBaseView *priceField;         //交易价格
@property(nonatomic, strong) UILabel              *USDPrice;         //美元价格
@property(nonatomic, strong) ReleaseFiledBaseView *amountField;        //交易数量
@property(nonatomic, strong) ReleaseFiledBaseView *cnyNum;             //人民币总数
@property(nonatomic, strong) ReleaseFiledBaseView *paymentTime;        //付款时间
@property(nonatomic, strong) ReleaseFiledBaseView *verifyLevel;        //限制认证等级
@property(nonatomic, strong) ReleaseFiledBaseView *limitRegTime;       //限制注册时间
@property(nonatomic, strong) ReleaseFiledBaseView *transactionLegend;  //交易说明
@property(nonatomic, strong) ReleaseFiledBaseView *limitMinPrice;      //限制最小金额
@property(nonatomic, strong) UIScrollView         *scrollView;

@property(nonatomic, strong) NSMutableArray       *payTimeArray; //限制时间
@end

@implementation ReleaseWantBuyChildVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setUpView];
    
    [self setData];
}

#pragma mark dataSource
-(void)setData{
    paramsVerifyLevel = @"1";
    paramsPaymentTime = [self.netDic[@"pay_time_list"] allKeys].lastObject;
    paramsRegTime = @"";//[HelpManager getNowTimeTimestamp];
    priceLabel.text = [NSString stringWithFormat:@"%@%@CNY",LocalizationKey(@"FiatTip2"),self.netDic[@"price"]];
}

#pragma mark - action
//切换限制注册时间
-(void)switchLimitRegTimeClick{
    SZCalendarPicker *calendarPicker = [SZCalendarPicker showOnView:self.view];
    calendarPicker.today = [NSDate date];
    calendarPicker.date = calendarPicker.today;
    calendarPicker.frame = CGRectMake(20, 100, self.view.frame.size.width - 40, 352);
    __weak typeof(self) weakSelf = self;
    calendarPicker.calendarBlock = ^(NSInteger day, NSInteger month, NSInteger year){
        weakSelf.limitRegTime.inputField.text = [NSString stringWithFormat:@"%li-%li-%li %@",(long)year,(long)month,(long)day,LocalizationKey(@"Pre-registration")];
        long timetamp = [HelpManager getTimeTimestampStr:[NSString stringWithFormat:@"%li-%li-%li",(long)year,(long)month,(long)day] FormatStr:@"yy-mm-dd"];
        paramsRegTime = [NSString stringWithFormat:@"%ld",timetamp];
    };
}
//切换限制认证等级
-(void)switchVerifyLevelClick{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:nil message:LocalizationKey(@"Limit certification level") preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *bank = [UIAlertAction actionWithTitle:@"KYC1" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.verifyLevel.inputField.text = @"KYC1";
        paramsVerifyLevel = @"1";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"KYC2" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.verifyLevel.inputField.text = @"KYC2";
        paramsVerifyLevel = @"2";
    }];
    UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [ua addAction:bank];
    [ua addAction:cancel];
    [ua addAction:cancel1];
    [self. navigationController presentViewController:ua animated:YES completion:nil];
}
//切换付款时间
-(void)switchPaymentTimeClick{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:nil message:LocalizationKey(@"Limit certification level") preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *bank = [UIAlertAction actionWithTitle:self.netDic[@"pay_time_list"][@"10"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.paymentTime.inputField.text = self.netDic[@"pay_time_list"][@"10"];
        paramsPaymentTime = @"10";
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:self.netDic[@"pay_time_list"][@"20"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.paymentTime.inputField.text = self.netDic[@"pay_time_list"][@"20"];
        paramsPaymentTime = @"20";
    }];
    UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    
    [ua addAction:bank];
    [ua addAction:cancel];
    [ua addAction:cancel1];
    [self. navigationController presentViewController:ua animated:YES completion:nil];
}
//出售全部
-(void)saleAllClick{
    self.amountField.inputField.text = [NSString stringWithFormat:@"%f",availableNum];
}
//发布点击
-(void)releaseClick{
    if([HelpManager isBlankString:self.transactionLegend.inputField.text]){
        self.transactionLegend.inputField.text = content;
    }
    
    if(self.releaseWantBuyType == ReleaseWantBuyTypeSale){
        if([self.amountField.inputField.text doubleValue] > availableNum){
            printAlert(LocalizationKey(@"FiatTip29"), 1);
            return;
        }
    }
    double limitMinPrice = [self.limitMinPrice.inputField.text doubleValue];
    if(limitMinPrice < [self.netDic[@"trade_min"] doubleValue]){
        NSString *msg = [NSString stringWithFormat:@"%@ >=¥ %@",LocalizationKey(@"FiatTip6"),self.netDic[@"trade_min"]];
        printAlert(msg, 1.f);
        return;
    }
    double cnyNum = [self.cnyNum.inputField.text doubleValue];
    if(cnyNum < [self.netDic[@"trade_min"] doubleValue]){
        NSString *msg = [NSString stringWithFormat:@"%@ >=¥ %@",LocalizationKey(@"FiatTip5"),self.netDic[@"trade_min"]];
        printAlert(msg, 1.f);
        return;
    }
    
    NSMutableDictionary *netDic = [NSMutableDictionary dictionaryWithCapacity:0];
    netDic[@"type"] = buOrSeal;         //发布类型 0 购买 1 出售
    netDic[@"coin_id"] = self.coinId;   //货币ID
    netDic[@"price_type"] = @"1";  //价格类型 1 固定价格 2 浮动价格
    netDic[@"price_float"] = @"";      //浮动比例%   否
    netDic[@"price_hidden"] = @"";         //隐藏价格    否
    netDic[@"price"] = self.priceField.inputField.text;         //单价       否
    netDic[@"amount"] = self.amountField.inputField.text;         //数量
    netDic[@"verify_level"] = paramsVerifyLevel;         //认证等级
    netDic[@"limit_reg_time"] = paramsRegTime;         //限制注册时间
    netDic[@"desc"] = self.transactionLegend.inputField.text;         //备注
    netDic[@"limit_min"] = self.limitMinPrice.inputField.text;         //限制最小金额 0不限制  否
    netDic[@"limit_max"] = self.cnyNum.inputField.text;         //限制最大金额 0不限制  否
    netDic[@"limit_paytime"] = paramsPaymentTime;         //限制支付时间
    [self.afnetWork jsonPostDict:@"/api/otc/addOtc" JsonDict:netDic Tag:@"1"];
}

#pragma mark - netBack
-(void)getHttpData_array:(NSDictionary *)dict response:(Response)flag Tag:(NSString *)tag{
    [super getHttpData_array:dict response:flag Tag:tag];
    if (flag == Success) {
        switch ([dict[@"code"] integerValue]) {
            case 0:
                if([[NSString stringWithFormat:@"%@",dict[@"msg"]] containsString:LocalizationKey(@"FiatTip23")]){
                    UIAlertController *ua = [UIAlertController alertControllerWithTitle:nil message:LocalizationKey(@"FiatTip23") preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *bank = [UIAlertAction actionWithTitle:LocalizationKey(@"Go add") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                        AccountsReceivableSettingTBVC *arVC = [AccountsReceivableSettingTBVC new];
                        [self.navigationController pushViewController:arVC animated:YES];
                    }];
                    UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
                    [ua addAction:bank];
                    [ua addAction:cancel1];
                    [self. navigationController presentViewController:ua animated:YES completion:nil];
                }else{
                    printAlert(dict[@"msg"], 1) ;
                }
                break;
 
        }
    }
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        printAlert(dict[@"msg"], 1.f);
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        availableNum = [dict[@"data"][@"money"] doubleValue];
        self.amountField.inputField.placeholder = [NSString stringWithFormat:@"%@%f",LocalizationKey(@"Available"),availableNum];
        _accountBalance.text = [NSString stringWithFormat:@"%@:%f %@",LocalizationKey(@"Currently available"),availableNum,self.coinName];
    }
    
}

#pragma mark - textFieldDelegate
-(void)changedTextField:(UITextField *)textField{
    if (self.amountField.inputField == textField) {
       [self changedTextField:self.cnyNum.inputField];
    }else if (self.priceField.inputField == textField){
       [self changedTextField:self.cnyNum.inputField];
    }else if (self.limitMinPrice.inputField == textField){
        self.limitMinPrice.inputField.text = textField.text;
    }else{
        double amount = [self.amountField.inputField.text doubleValue];
        double price = [self.priceField.inputField.text doubleValue];
        self.cnyNum.inputField.text = [NSString stringWithFormat:@"%.2f",amount * price];
        self.USDPrice.text = NSStringFormat(@"$%.2f",price / 7);
    }
    if([self.cnyNum.inputField.text doubleValue] >0){
        releaseBtn.enabled = YES;
        releaseBtn.backgroundColor = rgba(34, 133, 210, 1);
    }else{
        releaseBtn.enabled = NO;
        releaseBtn.backgroundColor = rgba(222, 222, 222, 1);
    }
}

#pragma mark - ui
-(void)setUpView{
    self.gk_navigationBar.hidden = YES;
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.pricingMethod];
    [self.scrollView addSubview:self.priceField];
    [self.scrollView addSubview:self.amountField];
    [self.scrollView addSubview:self.cnyNum];
    [self.scrollView addSubview:self.paymentTime];
    [self.scrollView addSubview:self.verifyLevel];
    [self.scrollView addSubview:self.limitRegTime];
    [self.scrollView addSubview:self.transactionLegend];
    [self.scrollView addSubview:self.limitMinPrice];
    
    [self LayoutScrollSubviews];
    
    //底部视图
    bottomView = [UIView new];
    bottomView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    [self.view addSubview:bottomView];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    releaseBtn.backgroundColor = rgba(222, 222, 222, 1);
    releaseBtn.enabled = NO;
    releaseBtn.layer.cornerRadius = 3;
    releaseBtn.layer.masksToBounds = YES;
    [releaseBtn setTitle:LocalizationKey(@"Issue order") forState:UIControlStateNormal];
    [bottomView addSubview:releaseBtn];
    [releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bottomView.mas_top).offset(15);
        make.left.mas_equalTo(bottomView.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth-30, 45));
    }];
    
    [releaseBtn addTarget:self action:@selector(releaseClick) forControlEvents:UIControlEventTouchUpInside];

    buyMargin = [UILabel new];
    //TODO: 隐藏掉
 //   buyMargin.text = @"买单保证金: 100.00BTC";
    buyMargin.font = [UIFont systemFontOfSize:14];
    buyMargin.textColor = rgba(144, 157, 180, 1);
    [bottomView addSubview:buyMargin];
    [buyMargin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(releaseBtn.mas_bottom).offset(15);
        make.left.mas_equalTo(releaseBtn.mas_left);
    }];
    
    serviceFee = [UILabel new];
 //   serviceFee.text = @"平台服务费0.0%";
    serviceFee.font = [UIFont systemFontOfSize:14];
    serviceFee.textColor = rgba(144, 157, 180, 1);
    [bottomView addSubview:serviceFee];
    [serviceFee mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(releaseBtn.mas_bottom).offset(15);
        make.right.mas_equalTo(releaseBtn.mas_right);
    }];
    
  
}

//布局滚动部分视图
-(void)LayoutScrollSubviews{
    [self.pricingMethod mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_top);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.right.mas_equalTo(self.view.mas_right);  //加上盘口价格
        make.bottom.mas_equalTo(self.pricingMethod.inputField.mas_bottom).offset(17 + 30);
    }];
    
//    priceLabel = [UILabel new];
//    priceLabel.text = @"当前盘口价格:CNY";
//    priceLabel.textColor = rgba(77, 91, 114, 1);
//    priceLabel.font = tFont(15);
//    [self.pricingMethod addSubview:priceLabel];
//    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.pricingMethod.inputField.mas_bottom).offset(10);
//        make.right.mas_equalTo(self.pricingMethod.mas_right).offset(-OverAllLeft_OR_RightSpace);
//    }];
    
//    //添加了最小限额的控件，位置替换隐藏的
//    [self.limitMinPrice mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.scrollView.mas_top);
//        make.left.mas_equalTo(self.scrollView.mas_left);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.bottom.mas_equalTo(self.limitMinPrice.inputField.mas_bottom).offset(17 + 30);
//    }];
//
//    priceLabel = [UILabel new];
//    priceLabel.text = @"当前盘口价格:CNY";
//    priceLabel.textColor = rgba(77, 91, 114, 1);
//    priceLabel.font = tFont(15);
//    [self.limitMinPrice addSubview:priceLabel];
//    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.limitMinPrice.inputField.mas_bottom).offset(10);
//        make.right.mas_equalTo(self.limitMinPrice.mas_right).offset(-OverAllLeft_OR_RightSpace);
//    }];
    
    //TODO:隐藏掉固定价格后约束跟着变
    [self.priceField mas_makeConstraints:^(MASConstraintMaker *make) {
      //  make.top.mas_equalTo(self.limitMinPrice.mas_bottom);
          make.top.mas_equalTo(self.scrollView.mas_top);
       // make.top.mas_equalTo(self.pricingMethod.mas_bottom);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.priceField.inputField.mas_bottom).offset(17 + 30);
    }];
    
    priceLabel = [UILabel new];
    priceLabel.text = NSStringFormat(@"%@CNY",LocalizationKey(@"FiatTip2"));
    priceLabel.textColor = rgba(77, 91, 114, 1);
    priceLabel.font = tFont(15);
    [self.priceField addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceField.inputField.mas_bottom).offset(10);
        make.right.mas_equalTo(self.priceField.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
    
    self.amountField.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"FiatAmount"),self.coinName];
    
    if(self.releaseWantBuyType == ReleaseWantBuyTypeBuy){
        [self.amountField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.priceField.mas_bottom);
            make.left.mas_equalTo(self.scrollView.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(self.amountField.inputField.mas_bottom).offset(17);
        }];
    }else{
        [self.amountField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.priceField.mas_bottom);
            make.left.mas_equalTo(self.scrollView.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(self.amountField.inputField.mas_bottom).offset(17 + 30);
        }];
        
        _accountBalance = [UILabel new];
        _accountBalance.text = [NSString stringWithFormat:@"%@:%f %@",LocalizationKey(@"Currently available"),availableNum,self.coinName] ;
        _accountBalance.textColor = rgba(77, 91, 114, 1);
        _accountBalance.font = tFont(15);
        [self.amountField addSubview:_accountBalance];
        [_accountBalance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.amountField.inputField.mas_bottom).offset(10);
            make.right.mas_equalTo(self.amountField.mas_right).offset(-OverAllLeft_OR_RightSpace);
        }];
    }
    
 
    
    [self.cnyNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.amountField.mas_bottom);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.cnyNum.inputField.mas_bottom).offset(17);
    }];
    
    //添加了最小限额的控件，位置替换隐藏的
    [self.limitMinPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.cnyNum.mas_bottom);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.limitMinPrice.inputField.mas_bottom).offset(17  );
    }];
    
    //对手头部
    UIView *opponentView = [UIView new];
    opponentView.theme_backgroundColor = THEME_INPUT_BACKGROUNDCOLOR;
    [self.view addSubview:opponentView];
    [opponentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.limitMinPrice.mas_bottom);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 40));
    }];
    
    UILabel *opponentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth-20, 40)];
    opponentLabel.text = LocalizationKey(@"FiatTip7");
    opponentLabel.textColor = rgba(77, 91, 114, 1);
    opponentLabel.font = tFont(15);
    [opponentView addSubview:opponentLabel];
    
    if(self.releaseWantBuyType == ReleaseWantBuyTypeBuy){
        [self.paymentTime removeFromSuperview];
        [self.verifyLevel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(opponentView.mas_bottom);
            make.left.mas_equalTo(self.scrollView.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(self.verifyLevel.inputField.mas_bottom).offset(17);
        }];
        
        content = LocalizationKey(@"FiatTip11");
    }else{
        [self.paymentTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(opponentView.mas_bottom);
            make.left.mas_equalTo(self.scrollView.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(self.paymentTime.inputField.mas_bottom).offset(17);
        }];
        [self.verifyLevel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.paymentTime.mas_bottom);
            make.left.mas_equalTo(self.scrollView.mas_left);
            make.right.mas_equalTo(self.view.mas_right);
            make.bottom.mas_equalTo(self.verifyLevel.inputField.mas_bottom).offset(17);
        }];
       content = LocalizationKey(@"FiatTip13");
    }
    
    [self.limitRegTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.verifyLevel.mas_bottom);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.limitRegTime.inputField.mas_bottom).offset(17);
    }];
    
    //交易说明
    [self.transactionLegend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.limitRegTime.mas_bottom);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.right.mas_equalTo(self.view.mas_right);    // 加上textView的高度
        make.bottom.mas_equalTo(self.transactionLegend.inputField.mas_bottom).offset(17 + 30);
    }];
    
    UITextView *textView = [UITextView new];
   // textView.backgroundColor = navBarColor;
    [textView setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
    textView.returnKeyType = UIReturnKeyDone;
    textView.font = [UIFont systemFontOfSize:16];
    textView.theme_textColor = THEME_TEXT_COLOR;
    textView.textAlignment = NSTextAlignmentLeft;
    [self.transactionLegend addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.transactionLegend.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.right.mas_equalTo(self.transactionLegend.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(self.transactionLegend.inputField.mas_top);
        make.height.mas_equalTo(80);
    }];
    
    UILabel *placeholderLabel = [UILabel new];
    placeholderLabel.text = content;
    placeholderLabel.numberOfLines = 0;
    placeholderLabel.font = [UIFont systemFontOfSize:16];
    placeholderLabel.textColor = rgba(144, 157, 180, 1);
    [placeholderLabel sizeToFit];
    [textView addSubview:placeholderLabel];
    [textView setValue:placeholderLabel forKey:@"_placeholderLabel"];
    
    self.USDPrice = [UILabel new];
    self.USDPrice.font = tFont(15);
    self.USDPrice.theme_textColor = THEME_TEXT_COLOR;
    self.USDPrice.text = @"$0.00";
    [self.priceField addSubview:self.USDPrice];
    [self.USDPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(priceLabel.mas_centerY);
        make.left.mas_equalTo(self.priceField.inputField.mas_left);
    }];
    
    
}

#pragma mark - lazyInit
//TODO:暂时隐藏。
-(ReleaseFiledBaseView *)pricingMethod{
    if(!_pricingMethod){
        _pricingMethod = [[ReleaseFiledBaseView alloc] init];
        _pricingMethod.titleLabel.text = @"定价方式";
        _pricingMethod.inputField.text = @"固定价格";
        _pricingMethod.userInteractionEnabled = NO;
        _pricingMethod.rightBtn.hidden = YES;
        _pricingMethod.hidden = YES;
    }
    return _pricingMethod;
}

-(ReleaseFiledBaseView *)priceField{
    if(!_priceField){
        _priceField = [[ReleaseFiledBaseView alloc] init];
        _priceField.titleLabel.text = LocalizationKey(@"Trading price");
      //  _priceField.inputField.placeholder = LocalizationKey(@"FiatTip1");
        _priceField.rightBtn.hidden = YES;
        _priceField.inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"Trading price")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
      //  [_priceField.inputField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
        [_priceField.inputField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    }
    return _priceField;
}

-(ReleaseFiledBaseView *)amountField{
    if(!_amountField){
        _amountField = [[ReleaseFiledBaseView alloc] init];
        
     //   _amountField.inputField.placeholder = LocalizationKey(@"FiatTip24");
        _amountField.rightBtn.hidden = YES;
        [_amountField.inputField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
      //  [_amountField.inputField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
        _amountField.inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"FiatTip24")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18], SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
    }
    return _amountField;
}

-(ReleaseFiledBaseView *)cnyNum{
    if(!_cnyNum){
        _cnyNum = [[ReleaseFiledBaseView alloc] init];
        _cnyNum.titleLabel.text = LocalizationKey(@"FiatTip25");
      //  _cnyNum.inputField.placeholder = LocalizationKey(@"FiatTip26");
        _cnyNum.rightBtn.hidden = YES;
        _cnyNum.userInteractionEnabled = NO;
        [_cnyNum.inputField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
        
       // [_cnyNum.inputField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
          _cnyNum.inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"FiatTip25")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],  SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
    }
    return _cnyNum;
}

-(ReleaseFiledBaseView *)paymentTime{
    if(!_paymentTime){
        _paymentTime = [[ReleaseFiledBaseView alloc] init];
        _paymentTime.titleLabel.text = LocalizationKey(@"FiatTip12");
        _paymentTime.inputField.text = LocalizationKey(@"FiatTip27");
        _paymentTime.rightBtn.hidden = NO;
        _paymentTime.inputField.userInteractionEnabled = NO;
        _paymentTime.userInteractionEnabled = YES;
        [_paymentTime addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchPaymentTimeClick)]];
      //  [_paymentTime.inputField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
           _paymentTime.inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"FiatTip27")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],  SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
    }
    return _paymentTime;
}

-(ReleaseFiledBaseView *)verifyLevel{
    if(!_verifyLevel){
        _verifyLevel = [[ReleaseFiledBaseView alloc] init];
        _verifyLevel.titleLabel.text = LocalizationKey(@"FiatTip8");
        _verifyLevel.inputField.text = @"KYC1";
        _verifyLevel.rightBtn.hidden = NO;
        _verifyLevel.inputField.userInteractionEnabled = NO;
        _verifyLevel.userInteractionEnabled = YES;
        [_verifyLevel addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchVerifyLevelClick)]];
     //   [_verifyLevel.inputField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
          _verifyLevel.inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"KYC1")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],  SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
    }
    return _verifyLevel;
}

-(ReleaseFiledBaseView *)limitRegTime{
    if(!_limitRegTime){
        _limitRegTime = [[ReleaseFiledBaseView alloc] init];
        _limitRegTime.titleLabel.text = LocalizationKey(@"FiatTip9");
        //去掉默认值
     //   NSDateFormatter *dateFormat=[[NSDateFormatter alloc]init];
     //   [dateFormat setDateFormat:@"yyyy-MM-dd "];
     //   NSString* string=[dateFormat stringFromDate:[NSDate date]];
        
      //  _limitRegTime.inputField.text = [NSString stringWithFormat:@"%@前注册",string];
        _limitRegTime.rightBtn.hidden = NO;
        _limitRegTime.inputField.userInteractionEnabled = NO;
        _limitRegTime.userInteractionEnabled = YES;
        [_limitRegTime addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(switchLimitRegTimeClick)]];
     //   [_limitRegTime.inputField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
      //   _limitRegTime.inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"KYC1")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],  SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
    }
    return _limitRegTime;
}

-(ReleaseFiledBaseView *)transactionLegend{
    if(!_transactionLegend){
        _transactionLegend = [[ReleaseFiledBaseView alloc] init];
        _transactionLegend.titleLabel.text = LocalizationKey(@"FiatTip10");
        _transactionLegend.inputField.hidden = YES;
        _transactionLegend.rightBtn.hidden = YES;
    }
    return _transactionLegend;
}

-(ReleaseFiledBaseView *)limitMinPrice{
    if(!_limitMinPrice){
        _limitMinPrice = [[ReleaseFiledBaseView alloc] init];
        _limitMinPrice.titleLabel.text = LocalizationKey(@"FiatTip4");
        _limitMinPrice.inputField.hidden = NO;
        _limitMinPrice.rightBtn.hidden = YES;
     //   _limitMinPrice.inputField.placeholder = LocalizationKey(@"FiatTip28");
       [_limitMinPrice.inputField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
     //  [_limitMinPrice.inputField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
        
        _limitMinPrice.inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"FiatTip28")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],  SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
    }
    return _limitMinPrice;
}


-(UIScrollView *)scrollView{
    if(!_scrollView){      //TODO: 隐藏掉保证金后列表变高点 + 30
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 130 - Height_TabBar -  50 + 30)];
        _scrollView.bounces = NO;
    }
    return _scrollView;
}

#pragma mark - set
-(void)setReleaseWantBuyType:(ReleaseWantBuyType)releaseWantBuyType{
    _releaseWantBuyType = releaseWantBuyType;
    switch (_releaseWantBuyType) {
        case ReleaseWantBuyTypeBuy:
            self.amountField.inputField.placeholder = LocalizationKey(@"FiatTip24");
            //TODO:隐藏了定价方式所以减1，加了最小限额控件，再加1
            [self.scrollView setContentSize:CGSizeMake(ScreenWidth, 115 * 8 - 115 +115)];
            buOrSeal = @"0";
            break;
        default:
            //通过账户类型和货币ID获取可用资金数量
            [self.afnetWork jsonGetDict:@"/api/account/getAccountByTypeCoin" JsonDict:@{@"account_type":LegalCurrency_Account,@"coin_id":self.coinId} Tag:@"2"];
        
            self.amountField.rightBtn.hidden = NO;
            [self.amountField.rightBtn setImage:nil forState:UIControlStateNormal];
            [self.amountField.rightBtn setTitle:LocalizationKey(@"All") forState:UIControlStateNormal];
            [self.amountField.rightBtn setTitleColor:MainColor forState:UIControlStateNormal];
            self.amountField.rightBtn.userInteractionEnabled = YES;
            [self.amountField.rightBtn addTarget:self action:@selector(saleAllClick) forControlEvents:UIControlEventTouchUpInside];
              //TODO:隐藏了定价方式所以减1，加了最小限额控件，再加1
            [self.scrollView setContentSize:CGSizeMake(ScreenWidth, 115 * 9 -  115+ 115 + 60)];
            buOrSeal = @"1";
            break;
    }
}

-(void)setNetDic:(NSDictionary *)netDic{
    _netDic = netDic;
 //   self.cnyNum.inputField.placeholder = [NSString stringWithFormat:@"¥ %@ ～ ¥ %@",netDic[@"trade_min"],netDic[@"trade_max"]];
    self.limitMinPrice.inputField.placeholder = [NSString stringWithFormat:@"%@ >=¥ %@",LocalizationKey(@"FiatTip6"),netDic[@"trade_min"]];
    self.cnyNum.inputField.placeholder = [NSString stringWithFormat:@"%@ >=¥ %@",LocalizationKey(@"FiatTip5"),netDic[@"trade_min"]];
}

@end
