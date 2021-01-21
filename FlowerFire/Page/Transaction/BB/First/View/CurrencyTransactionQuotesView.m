//
//  CurrencyTransactionQuotesView.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//  币币交易行情视图

#import "CurrencyTransactionQuotesView.h"
#import "LoginViewController.h"
#import "CurrencyTransactionDiskCell.h"
#import "QuotesTransactionPairModel.h"
#import "QuotesTradingZoneModel.h"

@interface CurrencyTransactionQuotesView () <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
  
    UIView *diskView;
    UILabel *tip;
    UIButton *depthBtn;
    UIButton *switchDisk;
    NSString *leftSymbol,*rightSymbol,*leftCoinId,*rightCoinId;
   
}
@property(nonatomic, strong) UIView   *rightView;

@property(nonatomic, strong) UIButton *switchTransaType; //交易类型切换


@property(nonatomic, strong)NSArray<CurrencyTransactionLimitPriceView *>   *lefChildViewArray;
@property(nonatomic, assign)int HandicapDataCount; //盘口数据数量
@end

@implementation CurrencyTransactionQuotesView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
      //  self.backgroundColor = navBarColor;
        //初始值
        self.coinNameDic = @{@"leftSymbol":@"",@"rightSymbol":@"",@"leftCoinId":@"",@"rightCoinId":@""};
        [self createView];
        self.isSell = NO;
      
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exitLoginStatus) name:EXIT_LOGIN_NOTIFICATION object:nil];
    }
    return self;
}

#pragma mark - notice
-(void)exitLoginStatus{
    [self.limitPriceView.buyBtn setTitle:LocalizationKey(@"Login") forState:UIControlStateNormal];
}

#pragma mark - action
//买按钮
-(void)chooseBuyClick:(UIButton *)btn{
    [self.chooseBuyBtn setTitle:LocalizationKey(@"BUY") forState:UIControlStateNormal];
    self.isSell = NO;
    self.chooseBuyBtn.selected = YES;
    self.chooseSaleBtn.selected = NO;
    self.chooseBuyBtn.userInteractionEnabled = NO;
    self.chooseSaleBtn.userInteractionEnabled = YES;
  
    [self resignTextFieldResponder];
    if([self.switchTransaType.titleLabel.text isEqualToString:NSStringFormat(@"%@ ▼",LocalizationKey(@"Limit"))]){
        [self updateLimitPriceViewStatus:self.limitPriceView isSeal:NO];
        [self updateLeftViewBottom:self.limitPriceView];
    }else if ([self.switchTransaType.titleLabel.text isEqualToString:NSStringFormat(@"%@ ▼",LocalizationKey(@"market"))]){
        [self updateLimitPriceViewStatus:self.marketPriceView isSeal:NO];
        [self updateLeftViewBottom:self.marketPriceView];
    }else{
        [self updateLimitPriceViewStatus:self.takeProfitStopLossView isSeal:NO];
        [self updateLeftViewBottom:self.takeProfitStopLossView];
    }
    
    [self setViewStatus:YES];
    
    if([self.delegate respondsToSelector:@selector(getCCWaltWithCoinId:)]){
        [self.delegate getCCWaltWithCoinId:rightCoinId];
    }
    
    
  //  [self setNeedsLayout];
}
//卖出按钮
-(void)chooseSaleClick:(UIButton *)btn{
    [self.chooseSaleBtn setTitle:LocalizationKey(@"SELL") forState:UIControlStateNormal];
    self.isSell = YES;
    self.chooseBuyBtn.selected = NO;
    self.chooseSaleBtn.selected = YES;
    self.chooseBuyBtn.userInteractionEnabled = YES;
    self.chooseSaleBtn.userInteractionEnabled = NO;
    
    [self resignTextFieldResponder];
    if([self.switchTransaType.titleLabel.text isEqualToString:NSStringFormat(@"%@ ▼",LocalizationKey(@"Limit"))]){
        [self updateLimitPriceViewStatus:self.limitPriceView isSeal:YES];
        [self updateLeftViewBottom:self.limitPriceView];
    }else if ([self.switchTransaType.titleLabel.text isEqualToString:NSStringFormat(@"%@ ▼",LocalizationKey(@"market"))]){
        [self updateLimitPriceViewStatus:self.marketPriceView isSeal:YES];
        [self updateLeftViewBottom:self.marketPriceView];
    }else{
        [self updateLimitPriceViewStatus:self.takeProfitStopLossView isSeal:YES];
        [self updateLeftViewBottom:self.takeProfitStopLossView];
    }
    
    [self setViewStatus:NO];
    
    if([self.delegate respondsToSelector:@selector(getCCWaltWithCoinId:)]){
        [self.delegate getCCWaltWithCoinId:leftCoinId];
    }
    
  //  [self setNeedsLayout];
}
//切换交易类型
-(void)switchTransaTypeClick:(UIButton *)btn{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *bank = [UIAlertAction actionWithTitle:LocalizationKey(@"Limit") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.CCQuotesTransactionType = CCQuotesTransactionTypeLimitPrice;
        [btn setTitle:NSStringFormat(@"%@ ▼",LocalizationKey(@"Limit")) forState:UIControlStateNormal];
        [self initBtnStatus:btn];
       
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:LocalizationKey(@"market") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.CCQuotesTransactionType = CCQuotesTransactionTypeMarketPrice;
        self.marketPriceView.fromScale = self.fromScale;
        [btn setTitle:NSStringFormat(@"%@ ▼",LocalizationKey(@"market")) forState:UIControlStateNormal];
        [self initBtnStatus:btn];
         
    }];
    //TODO: 暂放止盈止损
//    UIAlertAction *cancel2 = [UIAlertAction actionWithTitle:@"止盈止损" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        self.CCQuotesTransactionType = CCQuotesTransactionTypeTakeProfitStopLoss;
//        [btn setTitle:@"止盈止损 ▼" forState:UIControlStateNormal];
//        [self initBtnStatus:btn];
//    }];
    UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [ua addAction:bank];
    [ua addAction:cancel];
    [ua addAction:cancel1];
  //  [ua addAction:cancel2];
    [[self viewController].navigationController presentViewController:ua animated:YES completion:nil];
    
}
//列表底部的现价手势
-(void)nowPriceTapClick{
    if ([self.nowPrice.text floatValue] > 0) {
        double cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate doubleValue];
        switch (self.CCQuotesTransactionType) {
            case CCQuotesTransactionTypeLimitPrice:
            {
                self.limitPriceView.PriceTF.text = [NSString stringWithFormat:@"%@",self.nowPrice.text];
                //                self.limitPriceView.PriceTF.text = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[self.nowPrice.text floatValue] withlimit:self.priceScale]];
                self.limitPriceView.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.limitPriceView.PriceTF.text doubleValue] * cnyRate];
                
                 
                //放大动画  高系统版本textField内文本控件是UITextFieldContentView ,低版本是UITextFieldLabel
                UILabel *label;
                for (UIView *childView in [self.limitPriceView.PriceTF subviews]) {
                    label = (UILabel *)childView;
                }
                
                label.transform = CGAffineTransformMakeScale(1.2, 1.2);
                [UIView animateWithDuration:0.3 animations:^{
                    label.transform = CGAffineTransformMakeScale(1, 1);
                }];
            }
                break;
            case CCQuotesTransactionTypeTakeProfitStopLoss:
                self.takeProfitStopLossView.PriceTF.text = [NSString stringWithFormat:@"%@",self.nowPrice.text ];
               // self.takeProfitStopLossView.PriceTF.text = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[self.nowPrice.text floatValue] withlimit:self.priceScale]];
                self.takeProfitStopLossView.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.limitPriceView.PriceTF.text doubleValue] * cnyRate];
                break;
            default:
                break;
        }
    }
}

/**
 发布委托
 */
-(void)releaseCommissionClick{
    if(![WTUserInfo isLogIn]){ 
        [[WTPageRouterManager sharedInstance] jumpLoginViewController:[self viewController] isModalMode:YES whatProject:0];
        return;
    }
    
    if(self.pairModel){
//        double buy_min = [self.pairModel.buy_min doubleValue];
//        double buy_max = [self.pairModel.buy_max doubleValue];
//        double sell_min = [self.pairModel.sell_min doubleValue];
//        double sell_max = [self.pairModel.sell_max doubleValue];
//        double market_min = [self.pairModel.market_min doubleValue];
//        double market_max = [self.pairModel.market_max doubleValue];
        //买
        if(!self.isSell){
            if(self.CCQuotesTransactionType == CCQuotesTransactionTypeLimitPrice){
                //限价买入
                if([HelpManager isBlankString:self.limitPriceView.PriceTF.text]){
                    printAlert(LocalizationKey(@"ccTip2"), 1.f);
                    return;
                }
                if([self.limitPriceView.PriceTF.text doubleValue] <=0){
                    printAlert(LocalizationKey(@"ccTip3"), 1.f);
                    return;
                }
                if([HelpManager isBlankString:self.limitPriceView.AmountTF.text]){
                    printAlert(LocalizationKey(@"ccTip4"), 1.f);
                    return;
                }
                if([self.limitPriceView.AmountTF.text doubleValue] <=0){
                    printAlert(LocalizationKey(@"ccTip5"), 1.f);
                    return;
                }
            }else if(self.CCQuotesTransactionType == CCQuotesTransactionTypeMarketPrice){
               //市价买入
                if([HelpManager isBlankString:self.marketPriceView.AmountTF.text]){
                    printAlert(LocalizationKey(@"ccTip6"), 1.f);
                    return;
                }
                if([self.marketPriceView.AmountTF.text doubleValue] <=0){
                    printAlert(LocalizationKey(@"ccTip7"), 1.f);
                    return;
                }
            }else{
                //TODO: 止盈止损暂放
            }
        }else{ //卖出
            if(self.CCQuotesTransactionType == CCQuotesTransactionTypeLimitPrice){
                //限价卖出
                if([HelpManager isBlankString:self.limitPriceView.PriceTF.text]){
                    printAlert(LocalizationKey(@"ccTip2"), 1.f);
                    return;
                }
                if([self.limitPriceView.PriceTF.text doubleValue] <=0){
                    printAlert(LocalizationKey(@"ccTip3"), 1.f);
                    return;
                }
                if([HelpManager isBlankString:self.limitPriceView.AmountTF.text]){
                    printAlert(LocalizationKey(@"ccTip4"), 1.f);
                    return;
                }
                if([self.limitPriceView.AmountTF.text doubleValue] <=0){
                    printAlert(LocalizationKey(@"ccTip5"), 1.f);
                    return;
                }
            }else if(self.CCQuotesTransactionType == CCQuotesTransactionTypeMarketPrice){
                //市价卖出
                if([HelpManager isBlankString:self.marketPriceView.AmountTF.text]){
                    printAlert(LocalizationKey(@"ccTip6"), 1.f);
                    return;
                }
                if([self.marketPriceView.AmountTF.text doubleValue] <=0){
                    printAlert(LocalizationKey(@"ccTip7"), 1.f);
                    return;
                }
            }else{
                //TODO: 止盈止损暂放
            }
        }
        
        NSString *type;
        NSString *price;
        NSString *amount;
        if(self.CCQuotesTransactionType == CCQuotesTransactionTypeLimitPrice){
            type = @"1";
            price = self.limitPriceView.PriceTF.text;
            amount = self.limitPriceView.AmountTF.text;
        }else if(self.CCQuotesTransactionType == CCQuotesTransactionTypeMarketPrice){
            type = @"2";
            //市价，单价为0
            price = @"0";//self.marketPriceView.PriceTF.text;
            amount = self.marketPriceView.AmountTF.text;
        }else{
            //TODO: 止盈止损暂放
        }
        
//        //总价
//        double totalMoney = [self.totalMoney doubleValue];
//        //单价
//        double price =  [self.model.price doubleValue];
//        //购买的数量 防止精度问题不用buyNum变量了  [self.buyNum doubleValue]
//        NSString *amount =  [self decimalNumberMutiplyWithString:self.totalMoney multiplicandValue:self.model.price]; //totalMoney / price;
        
        NSMutableDictionary *netDic = [NSMutableDictionary dictionaryWithCapacity:0];
        netDic[@"market_id"] = self.pairModel.market_id;
        netDic[@"type"] = self.isSell ? @"1" : @"0";
        netDic[@"from"] = self.pairModel.from;
        netDic[@"to"] = self.pairModel.to;
        netDic[@"price_type"] = type;
        netDic[@"price"] =  price;
        netDic[@"amount"] = amount;
        if([self.delegate respondsToSelector:@selector(releaseCommissionClick:)]){
            [self.delegate releaseCommissionClick:netDic];
        }
    }
}

-(NSString *)decimalNumberMutiplyWithString:(NSString *)multiplierValue multiplicandValue:(NSString *)multiplicandValue{
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:multiplierValue];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:multiplicandValue];
    NSDecimalNumber *product = [multiplierNumber decimalNumberByDividingBy:multiplicandNumber];
    
    return [ToolUtil stringFromNumber:[product doubleValue] withlimit:8];
    
}

// 切换盘
-(void)switchDiskClick:(UIButton *)sender{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *bank = [UIAlertAction actionWithTitle:LocalizationKey(@"Default") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender theme_setImage:@"trade_trend_default_green_red" forState:UIControlStateNormal];
        [self initHandicapView];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:LocalizationKey(@"BuyHandicap") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender theme_setImage:@"trade_trend_green" forState:UIControlStateNormal];
        [self BuyHandicapView];
    }];
    UIAlertAction *cancel2 = [UIAlertAction actionWithTitle:LocalizationKey(@"SellHandicap") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [sender theme_setImage:@"trade_trend_red" forState:UIControlStateNormal];
        [self SaleHandicapView];
    }];
    UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [ua addAction:bank];
    [ua addAction:cancel];
    [ua addAction:cancel2];
    [ua addAction:cancel1];
    [[self viewController]. navigationController presentViewController:ua animated:YES completion:nil];
}
//TODO: 深度切换
-(void)depthClick{
    
}

#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    switch (self.CCQuotesTransactionType) {
        case CCQuotesTransactionTypeLimitPrice:
        {
            NSString *price;
            if(tableView == self.BuyTableView){
                price = [NSString stringWithFormat:@"%@",self.bidcontentArr[indexPath.row][@"price"]];
            }else{
                price = [NSString stringWithFormat:@"%@",self.askcontentArr[indexPath.row][@"price"]];
            }
            
            if([price isEqualToString:@"--"]){
                return;
            }
            
            self.limitPriceView.PriceTF.text = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[price doubleValue] withlimit:self.priceScale]];
            
            self.limitPriceView.TradeNumber.text=[NSString stringWithFormat:@"%@ %f%@",LocalizationKey(@"ccTotal"),[self.limitPriceView.PriceTF.text doubleValue]*[self.limitPriceView.AmountTF.text doubleValue],rightSymbol];

            NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
            self.limitPriceView.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.limitPriceView.PriceTF.text doubleValue]*[cnyRate doubleValue]* 1 ];//_usdRate];
            
            if(!self.isSell){
                 self.limitPriceView.sliderMaxValue.text=[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[self.moneyNum doubleValue]/[self.limitPriceView.PriceTF.text doubleValue] withlimit:self.fromScale],leftSymbol];
            }else{
                 self.limitPriceView.sliderMaxValue.text=[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[self.moneyNum doubleValue] withlimit:self.fromScale],leftSymbol];
            }

            
            //放大动画  高系统版本textField内文本控件是UITextFieldContentView ,低版本是UITextFieldLabel
            UILabel *label;
            for (UIView *childView in [self.limitPriceView.PriceTF subviews]) {
                 label = (UILabel *)childView;
            }
           
            label.transform = CGAffineTransformMakeScale(1.2, 1.2);
            [UIView animateWithDuration:0.3 animations:^{
               label.transform = CGAffineTransformMakeScale(1, 1);
            }];
             
        }
            break;
        case CCQuotesTransactionTypeTakeProfitStopLoss:
            
            break;
        default://市价没有
            break;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self.switchTransaType.titleLabel.text isEqualToString:NSStringFormat(@"%@ ▼",LocalizationKey(@"Stop-Limit"))]){
       return 6;
    }else{
       return self.HandicapDataCount;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.BuyTableView){
        static NSString *identifier = @"cell1";
        [self.BuyTableView registerClass:[CurrencyTransactionDiskCell class] forCellReuseIdentifier:identifier];
        CurrencyTransactionDiskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[CurrencyTransactionDiskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.priceLabel.textColor = qutesGreenColor;
        //TODO:数量小数位先原样显示
        if(self.bidcontentArr.count > 0){
            
            [cell setCellData:self.bidcontentArr[indexPath.row] isBuy:YES priceScale:self.priceScale amountScale:8 - self.priceScale];;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor= rgba(28, 172, 144, 0.3);
        return cell;
    }else{
        static NSString *identifier = @"cell2";
        [self.SaleTableView registerClass:[CurrencyTransactionDiskCell class] forCellReuseIdentifier:identifier];
        CurrencyTransactionDiskCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[CurrencyTransactionDiskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.priceLabel.textColor = qutesRedColor;
        if(self.askcontentArr.count > 0){
            if (self.HandicapDataCount == 5) {
                
                if (self.askcontentArr.count <= 5) {
                    [cell setCellData:self.askcontentArr[indexPath.row] isBuy:NO priceScale:self.priceScale amountScale:8 - self.priceScale];

                }else{
                    NSArray *array = self.askcontentArr.mutableCopy;
                    
                    NSRange range = NSMakeRange(self.askcontentArr.count - 5, 5);
                    array = [array subarrayWithRange:range];
                    [cell setCellData:array[indexPath.row] isBuy:NO priceScale:self.priceScale amountScale:8 - self.priceScale];
                    

                }

                
            }else{
                
                
                
                [cell setCellData:self.askcontentArr[indexPath.row] isBuy:NO priceScale:self.priceScale amountScale:8 - self.priceScale];

                
            }
            
            
                    }
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor= rgba(208, 77, 102, 0.3);
        return cell;
    }
    
  
}

#pragma mark - UITextFieldDelegate+
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if(self.chooseBuyBtn.isSelected){
        textField.layer.borderColor = qutesGreenColor.CGColor;
    }else{
        textField.layer.borderColor = qutesRedColor.CGColor;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.theme_borderColor = THEME_LINE_INPUTBORDERCOLOR;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1) {
        //委托价格框
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        NSInteger flag=0;
        const NSInteger limited = self.priceScale;//小数点后需要限制的个数
        for (int i = (int)futureString.length-1; i>=0; i--) {
            
            if ([futureString characterAtIndex:i] == '.') {
                if (flag > limited) {
                    return YES;
                }
                break;
            }
            flag++;
        }
        return YES;
    }
    else{
        switch (self.CCQuotesTransactionType) {
            case CCQuotesTransactionTypeLimitPrice:
            {
                //限价买入或卖出
                NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
                [futureString  insertString:string atIndex:range.location];
                NSInteger flag=0;
                const NSInteger limited = self.fromScale;//小数点后需要限制的个数
                for (int i = (int)futureString.length-1; i>=0; i--) {
                    if ([futureString characterAtIndex:i] == '.') {
                        if (flag > limited) {
                            return NO;
                        }
                        break;
                    }
                    flag++;
                }
                return YES;
            }
            case CCQuotesTransactionTypeMarketPrice:
            {
                if (!self.isSell) {
                    //市价买入
                    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
                    [futureString  insertString:string atIndex:range.location];
                    NSInteger flag=0;
                    const NSInteger limited = self.toScale;//小数点后需要限制的个数
                    for (int i = (int)futureString.length-1; i>=0; i--) {
                        if ([futureString characterAtIndex:i] == '.') {
                            if (flag > limited) {
                                return NO;
                            }
                            break;
                        }
                        flag++;
                    }
                    return YES;
                }else{
                    //市价卖出
                    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
                    [futureString  insertString:string atIndex:range.location];
                    NSInteger flag=0;
                    const NSInteger limited = self.fromScale;//小数点后需要限制的个数
                    for (int i = (int)futureString.length-1; i>=0; i--) {
                        if ([futureString characterAtIndex:i] == '.') {
                            if (flag > limited) {
                                return NO;
                            }
                            break;
                        }
                        flag++;
                    }
                    return YES;
                    
                }
            }
            default:
                return NO;
        }
    }
}

#pragma mark - util
/**
 切换盘类型后初始化一波按钮状态
 */
-(void)initBtnStatus:(UIButton *)btn{
    if(self.chooseBuyBtn.isSelected){
        [self chooseBuyClick:btn];
    }else{
        [self chooseSaleClick:btn];
    }
}

/**
 切换买入卖出时候，各种控件状态联动

 @param isBuy YES为买 NO为卖
 */
-(void)setViewStatus:(BOOL)isBuy{
    switch (self.CCQuotesTransactionType) {
        case CCQuotesTransactionTypeLimitPrice:
            [self.limitPriceView.slider setIndex:0 animated:NO];
            self.limitPriceView.AmountTF.text = @"";
            self.limitPriceView.baseCoin.text = leftSymbol;
            self.limitPriceView.baseCoinName = rightSymbol;
            //余额 除以 价格 = sliderMaxValue
            self.limitPriceView.sliderMaxValue.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:0 withlimit:4],leftSymbol];
            
            if(isBuy){
                self.limitPriceView.Useable.text = [NSString stringWithFormat:@"%@%@%@",LocalizationKey(@"Available"),[ToolUtil stringFromNumber:0 withlimit:4],rightSymbol];
                [self.limitPriceView.buyBtn setTitle:[NSString stringWithFormat:@"%@ %@",LocalizationKey(@"BUY"),leftSymbol] forState:UIControlStateNormal];
                
            }else{
                self.limitPriceView.Useable.text = [NSString stringWithFormat:@"%@%@%@",LocalizationKey(@"Available"),[ToolUtil stringFromNumber:0 withlimit:4],leftSymbol];
                [self.limitPriceView.buyBtn setTitle:[NSString stringWithFormat:@"%@ %@",LocalizationKey(@"SELL"),leftSymbol] forState:UIControlStateNormal];
            }
            if(![WTUserInfo isLogIn]){
                [self.limitPriceView.buyBtn setTitle:LocalizationKey(@"Login") forState:UIControlStateNormal];
            }
            break;
        case CCQuotesTransactionTypeTakeProfitStopLoss:
            [self.takeProfitStopLossView.slider setIndex:0 animated:NO];
            self.takeProfitStopLossView.AmountTF.text = @"";
            self.takeProfitStopLossView.baseCoin.text = leftSymbol;
            //余额 除以 价格 = sliderMaxValue
            self.takeProfitStopLossView.sliderMaxValue.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:0 withlimit:4],leftSymbol];
            
            if(isBuy){
                self.takeProfitStopLossView.Useable.text = [NSString stringWithFormat:@"%@%@%@",LocalizationKey(@"Available"),[ToolUtil stringFromNumber:0 withlimit:4],rightSymbol];
                [self.takeProfitStopLossView.buyBtn setTitle:[NSString stringWithFormat:@"%@ %@",LocalizationKey(@"BUY"),leftSymbol] forState:UIControlStateNormal];
            }else{
                self.takeProfitStopLossView.Useable.text = [NSString stringWithFormat:@"%@%@%@",LocalizationKey(@"Available"),[ToolUtil stringFromNumber:0 withlimit:4],leftSymbol];
                [self.takeProfitStopLossView.buyBtn setTitle:[NSString stringWithFormat:@"%@ %@",LocalizationKey(@"SELL"),leftSymbol] forState:UIControlStateNormal];
            }
            if(![WTUserInfo isLogIn]){
                [self.takeProfitStopLossView.buyBtn setTitle:LocalizationKey(@"Login") forState:UIControlStateNormal];
            }
            break;
        default:
        {
            [self.marketPriceView.slider setIndex:0 animated:NO];
            self.marketPriceView.AmountTF.text = @"";
            NSString *coinName;
            if(isBuy){
                self.marketPriceView.AmountTF.placeholder = LocalizationKey(@"ccTotal");
                coinName = rightSymbol;
                [self.marketPriceView.buyBtn setTitle:[NSString stringWithFormat:@"%@ %@",LocalizationKey(@"BUY"),leftSymbol] forState:UIControlStateNormal];
            }else{
                self.marketPriceView.AmountTF.placeholder = LocalizationKey(@"Amount");
                coinName = leftSymbol;
                [self.marketPriceView.buyBtn setTitle:[NSString stringWithFormat:@"%@ %@",LocalizationKey(@"SELL"),leftSymbol] forState:UIControlStateNormal];
            }
            self.marketPriceView.Useable.text = [NSString stringWithFormat:@"%@%@%@",LocalizationKey(@"Available"),[ToolUtil stringFromNumber:0 withlimit:4],coinName];
            self.marketPriceView.baseCoin.text = coinName;
            //余额 除以 价格 = sliderMaxValue
            self.marketPriceView.sliderMaxValue.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:0 withlimit:4],coinName];
            if(![WTUserInfo isLogIn]){
                [self.marketPriceView.buyBtn setTitle:LocalizationKey(@"Login") forState:UIControlStateNormal];
            }
        }
            break;
    }
  
    
}
/**
 切换盘口后重新布局
 */
-(void)updateLeftViewBottom:(CurrencyTransactionLimitPriceView *)view{
    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(-(ScreenWidth/3));
        make.bottom.mas_equalTo(view.mas_bottom).offset(0);
    }];
    
    CGFloat viewHeight = [self contentViewFittingSize:self.leftView];
    viewHeight = viewHeight - 15 - 30 - 10  - 30 - 15;
    
    [depthBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(view.buyBtn.mas_bottom);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.rightView.mas_left);
        make.width.mas_equalTo((ScreenWidth/3) - 15 - 30 - 5);
    }];
    
}

/**
 切换盘口后修改子视图的控件状态
 */
-(void)updateLimitPriceViewStatus:(CurrencyTransactionLimitPriceView *)view isSeal:(BOOL )isSeal{
    if(isSeal){
        view.buyBtn.backgroundColor = qutesRedColor;
        [view.buyBtn setTitle:LocalizationKey(@"ccSell1") forState:UIControlStateNormal];
        view.slider.tintColor = qutesRedColor;
        view.slider.sliderCircleImage = [UIImage imageNamed:@"circularRed"];
    }else{
        view.buyBtn.backgroundColor = qutesGreenColor;
        [view.buyBtn setTitle:LocalizationKey(@"ccBuy1") forState:UIControlStateNormal];
        view.slider.tintColor = qutesGreenColor;
        view.slider.sliderCircleImage = [UIImage imageNamed:@"circularGreen"];
    }
    
 
    for (int i = 0; i<self.lefChildViewArray.count; i++) {
        if([self.lefChildViewArray[i] isEqual:view]){
            self.lefChildViewArray[i].hidden = NO;
        }else{
            self.lefChildViewArray[i].hidden = YES;
        }
    }
}

-(void)resignTextFieldResponder{
    if(self.CCQuotesTransactionType == CCQuotesTransactionTypeLimitPrice){
        for (UITextField *tf in self.limitPriceView.subviews) {
            if([tf isKindOfClass:[UITextField class]]){
                [tf resignFirstResponder];
            }
        }
    }else if(self.CCQuotesTransactionType == CCQuotesTransactionTypeMarketPrice){
        for (UITextField *tf in self.marketPriceView.subviews) {
            if([tf isKindOfClass:[UITextField class]]){
                [tf resignFirstResponder];
            }
        }
    }else{
        for (UITextField *tf in self.takeProfitStopLossView.subviews) {
            if([tf isKindOfClass:[UITextField class]]){
                [tf resignFirstResponder];
            }
        }
    }
}

#pragma mark - ui
-(void)createView{
    [self createLeftView];
    [self createRightView];
}

-(void)createLeftView{
    //左边视图
    [self addSubview:self.leftView];
    [self.leftView addSubview:self.chooseBuyBtn];
    [self.chooseBuyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftView.mas_top).offset(10);
        make.left.mas_equalTo(_leftView.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.size.mas_equalTo(CGSizeMake(((ScreenWidth/3 * 2 - 30)/2), 40));
    }];
    
    [self.leftView addSubview:self.chooseSaleBtn];
    [self.chooseSaleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_leftView.mas_top).offset(10);
        make.left.mas_equalTo(self.chooseBuyBtn.mas_right).offset(0);
        make.right.mas_equalTo(self.leftView.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.height.equalTo(@40);
    }];
    
    [self.leftView addSubview:self.switchTransaType];
    [self.switchTransaType mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.chooseBuyBtn.mas_bottom).offset(10);
        make.left.mas_equalTo(self.chooseBuyBtn.mas_left);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }]; 
    self.limitPriceView.hidden = NO;
    
}

-(void)createRightView{
    self.HandicapDataCount = 5;
    //右边视图
    [self addSubview:self.rightView];
    
    tip = [UILabel new];
    tip.text = LocalizationKey(@"Price");
    tip.font = tFont(14);
    tip.textColor = rgba(65, 87, 101, 1);
    tip.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    tip.layer.masksToBounds = YES;
    [self.rightView addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rightView.mas_top).offset(10);
        make.left.mas_equalTo(self.rightView.mas_left);
    }];
    
    UILabel *tip1 = [UILabel new];
    tip1.text = LocalizationKey(@"Amount");
    tip1.font = tFont(14);
    tip1.textColor = rgba(65, 87, 101, 1);
    tip1.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    tip1.layer.masksToBounds = YES;
    [self.rightView addSubview:tip1];
    [tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(tip.mas_centerY).offset(0) ;
        make.right.mas_equalTo(self.rightView.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
    
    //TODO:隐藏掉
    depthBtn = [UIButton buttonWithType:UIButtonTypeCustom];
 //   depthBtn.hidden = YES;
    [depthBtn setTitle:NSStringFormat(@"%@ 1",LocalizationKey(@"Depth")) forState:UIControlStateNormal];
   // [depthBtn setTitle:@"深度 1 ▼" forState:UIControlStateNormal];
    depthBtn.titleLabel.font = tFont(15);
    [depthBtn setTitleColor:rgba(99, 124, 144, 1) forState:UIControlStateNormal];
    depthBtn.layer.borderWidth = 1;
    depthBtn.layer.borderColor = rgba(99, 124, 144, 1).CGColor;
    depthBtn.layer.cornerRadius = 1;
    [self.rightView addSubview:depthBtn];
    [depthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.limitPriceView.buyBtn.mas_bottom);
        make.height.mas_equalTo(30);
        make.left.mas_equalTo(self.rightView.mas_left);
        make.width.mas_equalTo((ScreenWidth/3) - 15 - 30 - 5);
    }];
    
    switchDisk = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchDisk theme_setImage:@"trade_trend_default_green_red" forState:UIControlStateNormal];
    
    [self addSubview:switchDisk];
    [switchDisk mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(depthBtn.mas_bottom);
        make.height.mas_equalTo(30);
        make.right.mas_equalTo(tip1.mas_right).offset(0);
        make.width.mas_equalTo(30);
    }];
    [switchDisk sizeToFit];
    
    diskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    diskView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    [diskView addSubview:self.nowPrice];
    [diskView addSubview:self.nowCNY];
    
    [self.nowPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(diskView.mas_top).offset(5);
        make.left.mas_equalTo(diskView.mas_left).offset(0);
        make.right.mas_equalTo(diskView.mas_right);
    }];
    
    [self.nowCNY mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(diskView.mas_bottom).offset(-5);
        make.left.mas_equalTo(diskView.mas_left).offset(0);
        make.right.mas_equalTo(diskView.mas_right);
    }];
    
    //加在self上，不然点击事件不执行
    [self addSubview:self.SaleTableView];
    [self addSubview:self.BuyTableView];
    
    CGFloat viewHeight = [self contentViewFittingSize:self.leftView];
    viewHeight = viewHeight - 15 - 30 - 10  - 30 - 0;
    
    [self.SaleTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rightView.mas_left);
        make.top.mas_equalTo(tip.mas_bottom).offset(15);
        make.width.mas_equalTo(self.rightView.mas_width);
        make.height.mas_equalTo(viewHeight/2+25);
    }];
    [self.SaleTableView setTableFooterView:diskView];
    
    [self.BuyTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.SaleTableView.mas_bottom);
        make.left.mas_equalTo(self.rightView.mas_left);
        make.width.mas_equalTo(self.rightView.mas_width);
        make.height.mas_equalTo(viewHeight/2 - 25);
        make.bottom.mas_equalTo(switchDisk.mas_top).offset(-10);
    }];
    [depthBtn addTarget:self action:@selector(depthClick) forControlEvents:UIControlEventTouchUpInside];
    [switchDisk addTarget:self action:@selector(switchDiskClick:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 默认盘口布局
 */
-(void)initHandicapView{
    self.HandicapDataCount = 5;
    
    CGFloat viewHeight = [self contentViewFittingSize:self.leftView];
    viewHeight = viewHeight - 15 - 30 - 10  - 30 - 0;
   
    [self.SaleTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(viewHeight/2+25);
    }];
    
    self.SaleTableView.tableHeaderView = nil;
    self.SaleTableView.tableFooterView = nil;
    self.BuyTableView.tableHeaderView = nil;
    self.BuyTableView.tableFooterView = nil;
    [self.SaleTableView setTableFooterView:diskView];
    
    [self.BuyTableView mas_updateConstraints:^(MASConstraintMaker *make) {
          make.height.mas_equalTo(viewHeight/2 - 25);
    }];
    [self.SaleTableView reloadData];
    [self.BuyTableView reloadData];
}

/**
 买盘布局
 */
-(void)BuyHandicapView{
    self.HandicapDataCount = 10;
   
    CGFloat viewHeight = [self contentViewFittingSize:self.leftView];
    viewHeight = viewHeight - 15 - 30 - 10  - 30 - 0;
    
    [self.SaleTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    
    [self.BuyTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(viewHeight);
    }];
    
    self.SaleTableView.tableHeaderView = nil;
    self.SaleTableView.tableFooterView = nil;
    self.BuyTableView.tableHeaderView = nil;
    self.BuyTableView.tableFooterView = nil;
    [self.BuyTableView setTableHeaderView:diskView];
    
    [self.SaleTableView reloadData];
    [self.BuyTableView reloadData];
}

/**
 卖盘布局
 */
-(void)SaleHandicapView{
    self.HandicapDataCount = 10;
    CGFloat viewHeight = [self contentViewFittingSize:self.leftView];
    viewHeight = viewHeight - 15 - 30 - 10  - 30 - 0;
  
    [self.BuyTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0);
    }];
    
    [self.SaleTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(viewHeight  );
    }];
    
    self.SaleTableView.tableHeaderView = nil;
    self.SaleTableView.tableFooterView = nil;
    self.BuyTableView.tableHeaderView = nil;
    self.BuyTableView.tableFooterView = nil;
    [self.SaleTableView setTableFooterView:diskView];
    
    
    [self.SaleTableView reloadData];
    [self.BuyTableView reloadData];
    
}

//约束后获取高度
- (CGFloat)contentViewFittingSize:(UIView *)contentView {
    // 获得父容器的宽度，我这里是获取控制器View的宽度
    CGFloat contentViewWidth = CGRectGetWidth(self.frame);
    // 新建一个宽度约束
    NSLayoutConstraint *widthFenceConstraint = [NSLayoutConstraint constraintWithItem:contentView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:contentViewWidth];
    // 添加宽度约束
    [contentView addConstraint:widthFenceConstraint];
    // 获取约束后的size
    CGSize fittingSize = [contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    // 记得移除
    [contentView removeConstraint:widthFenceConstraint];
    return fittingSize.height;
}

#pragma mark - lazyInit
-(UIView *)leftView{
    if(!_leftView){
        _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth/3 * 2, 0)];
    }
    return _leftView;
}

-(UIView *)rightView{
    if(!_rightView){
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftView.frame), 0, ScreenWidth/3 * 1, _leftView.frame.size.height)];
        _rightView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    }
    return _rightView;
}

-(UIButton *)chooseBuyBtn{
    if(!_chooseBuyBtn){
        _chooseBuyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseBuyBtn setTitle:LocalizationKey(@"BUY") forState:UIControlStateNormal];
        [_chooseBuyBtn setBackgroundImage:[UIImage imageNamed:@"transaction_4"] forState:UIControlStateNormal];
        [_chooseBuyBtn setBackgroundImage:[UIImage imageNamed:@"transaction_5"] forState:UIControlStateSelected];
      //  [_chooseBuyBtn setBackgroundImage:[UIImage imageNamed:@"transaction_5"] forState:UIControlStateDisabled];
        _chooseBuyBtn.selected = YES;
        [_chooseBuyBtn addTarget:self action:@selector(chooseBuyClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseBuyBtn;
}

-(UIButton *)chooseSaleBtn{
    if(!_chooseSaleBtn){
        _chooseSaleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseSaleBtn setTitle:LocalizationKey(@"SELL") forState:UIControlStateNormal];
        [_chooseSaleBtn setBackgroundImage:[UIImage imageNamed:@"transaction_7"] forState:UIControlStateNormal];
        [_chooseSaleBtn setBackgroundImage:[UIImage imageNamed:@"transaction_6"] forState:UIControlStateSelected];
    //    [_chooseSaleBtn setBackgroundImage:[UIImage imageNamed:@"transaction_6"] forState:UIControlStateDisabled];
        _chooseSaleBtn.selected = NO;
        [_chooseSaleBtn addTarget:self action:@selector(chooseSaleClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseSaleBtn;
}


-(UIButton *)switchTransaType{
    if(!_switchTransaType){
        _switchTransaType = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchTransaType setTitle:NSStringFormat(@"%@ ▼",LocalizationKey(@"Limit")) forState:UIControlStateNormal];
        [_switchTransaType theme_setTitleColor:THEME_GRAY_TEXTCOLOR forState:UIControlStateNormal];
        _switchTransaType.titleLabel.font = tFont(15);
        _switchTransaType.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_switchTransaType addTarget:self action:@selector(switchTransaTypeClick:) forControlEvents:UIControlEventTouchUpInside];
       
    }
    return _switchTransaType;
}

-(CurrencyTransactionLimitPriceView *)limitPriceView{
    if(!_limitPriceView){
        _limitPriceView = [[CurrencyTransactionLimitPriceView alloc] init];
        _limitPriceView.hidden = NO;
        _limitPriceView.baseCoinName = rightSymbol;
        _limitPriceView.PriceTF.delegate = self;
        _limitPriceView.AmountTF.delegate = self;
        [_limitPriceView.buyBtn addTarget:self action:@selector(releaseCommissionClick) forControlEvents:UIControlEventTouchUpInside];
        [self.leftView addSubview:_limitPriceView];
        
        [_limitPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.switchTransaType.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.leftView.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.bottom.mas_equalTo(_limitPriceView.buyBtn.mas_bottom).offset(15);
        }];
        
        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(-(ScreenWidth/3));
            make.bottom.mas_equalTo(_limitPriceView.mas_bottom).offset(0);
        }];
    }
    return _limitPriceView;
}

-(CurrencyTransactionMarketPriceView *)marketPriceView{
    if(!_marketPriceView){
        _marketPriceView = [[CurrencyTransactionMarketPriceView alloc] init];
        _marketPriceView.hidden = YES;
        _marketPriceView.baseCoinName = rightSymbol;
        _marketPriceView.PriceTF.delegate = self;
        _marketPriceView.AmountTF.delegate = self;
        [_marketPriceView.buyBtn addTarget:self action:@selector(releaseCommissionClick) forControlEvents:UIControlEventTouchUpInside];
        [self.leftView addSubview:_marketPriceView];
        [_marketPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.switchTransaType.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.leftView.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.bottom.mas_equalTo(_marketPriceView.buyBtn.mas_bottom).offset(15);
        }];
        
        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(-(ScreenWidth/3));
            make.bottom.mas_equalTo(_marketPriceView.mas_bottom).offset(0);
        }];
    }
    return _marketPriceView;
}

-(CurrencyTransactionTakeProfitStopLossView *)takeProfitStopLossView{
    if(!_takeProfitStopLossView){
        _takeProfitStopLossView = [[CurrencyTransactionTakeProfitStopLossView alloc] init];
        _takeProfitStopLossView.hidden = YES;
        _takeProfitStopLossView.baseCoinName = rightSymbol;
        _takeProfitStopLossView.PriceTF.delegate = self;
        _takeProfitStopLossView.AmountTF.delegate = self;
        [_takeProfitStopLossView.buyBtn addTarget:self action:@selector(releaseCommissionClick) forControlEvents:UIControlEventTouchUpInside];
        [self.leftView addSubview:_takeProfitStopLossView];
        [_takeProfitStopLossView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.switchTransaType.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.leftView.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.bottom.mas_equalTo(_takeProfitStopLossView.buyBtn.mas_bottom).offset(15);
        }];
        
        [self.leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(-(ScreenWidth/3));
            make.bottom.mas_equalTo(_takeProfitStopLossView.mas_bottom).offset(0);
        }];
    }
    return _takeProfitStopLossView;
}

-(UITableView *)BuyTableView{
    if(!_BuyTableView){
        _BuyTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
     //   _BuyTableView.backgroundColor = navBarColor;
         [_BuyTableView setTheme_backgroundColor:THEME_NAVBAR_BACKGROUNDCOLOR];
        _BuyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _BuyTableView.delegate = self;
        _BuyTableView.dataSource = self;
        _BuyTableView.estimatedRowHeight = 28.667;
        _BuyTableView.bounces = NO;
        _BuyTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _BuyTableView;
}

-(UITableView *)SaleTableView{
    if(!_SaleTableView){
        _SaleTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _SaleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _SaleTableView.delegate = self;
        _SaleTableView.dataSource = self;
        _SaleTableView.estimatedRowHeight = 28.667;
        _SaleTableView.bounces = NO;
         [_SaleTableView setTheme_backgroundColor:THEME_NAVBAR_BACKGROUNDCOLOR];
        _SaleTableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _SaleTableView;
}

-(NSArray *)lefChildViewArray{
    if(!_lefChildViewArray){
        _lefChildViewArray = @[self.limitPriceView,self.marketPriceView,self.takeProfitStopLossView];
    }
    return _lefChildViewArray;
}

-(UILabel *)nowPrice{
    if(!_nowPrice){
        _nowPrice = [UILabel new];
        _nowPrice.text = @"0.00";
        _nowPrice.font = [UIFont boldSystemFontOfSize:16];
        _nowPrice.textColor = qutesRedColor;
        UITapGestureRecognizer *tapRecognizerNowPrice=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nowPriceTapClick)];
        _nowPrice.userInteractionEnabled=YES;
        [_nowPrice addGestureRecognizer:tapRecognizerNowPrice];
         _nowPrice.adjustsFontSizeToFitWidth = YES;
        _nowPrice.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        _nowPrice.layer.masksToBounds = YES;
    }
    return _nowPrice;
}

-(UILabel *)nowCNY{
    if(!_nowCNY){
        _nowCNY = [UILabel new];
        _nowCNY.text = @"≈0.0CNY";
        _nowCNY.font = [UIFont boldSystemFontOfSize:15];
        _nowCNY.textColor =  rgba(57, 73, 93, 1);
        _nowCNY.adjustsFontSizeToFitWidth = YES;
        _nowCNY.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        _nowCNY.layer.masksToBounds = YES;
    }
    return _nowCNY;
}

-(void)setCoinNameDic:(NSDictionary *)coinNameDic{
    _coinNameDic = coinNameDic;
    leftSymbol  = coinNameDic[@"leftSymbol"];
    rightSymbol = coinNameDic[@"rightSymbol"];
    leftCoinId  = coinNameDic[@"leftCoinId"];
    rightCoinId = coinNameDic[@"rightCoinId"];
    _limitPriceView.baseCoinName = rightSymbol;
}

-(void)setFromScale:(int)fromScale{
    _fromScale = fromScale;
    _limitPriceView.fromScale = fromScale;
    _takeProfitStopLossView.fromScale = fromScale;
    _marketPriceView.fromScale = fromScale;
}

-(void)setToScale:(int)toScale{
    _toScale = toScale;
    _limitPriceView.toScale = toScale;
    _takeProfitStopLossView.toScale = toScale;
    _marketPriceView.toScale = toScale;
}

-(void)setPriceScale:(int)priceScale{
    _priceScale = priceScale;
    _limitPriceView.priceScale = priceScale;
    _takeProfitStopLossView.priceScale = priceScale;
    _marketPriceView.priceScale = priceScale;
}

@end
