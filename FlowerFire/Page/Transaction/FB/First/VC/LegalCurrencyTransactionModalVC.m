//
//  LegalCurrencyTransactionModalVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/29.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "LegalCurrencyTransactionModalVC.h"

extern CGFloat const transactionDecimalPoint;
@interface LegalCurrencyTransactionModalVC ()<UITextFieldDelegate>
{
    UIButton        *priceBtn;
    UIButton        *numBtn;
    UIView          *btnBottomView,*btnBottomView1;
    UITextField     *inputField;
    UILabel         *coinName;
    UILabel         *moneySum;
    UILabel         *amount;
    UIButton        *orderBtn;
    dispatch_source_t timer; //倒计时时间
    UIButton        *autoCloseBtn;
    UILabel         *limitNum;
}
@property(nonatomic, strong) NSString *buyNum;  //购买数量
@property(nonatomic, strong) NSString *totalMoney; //购买总金额

@end

@implementation LegalCurrencyTransactionModalVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

#pragma mark - action
-(void)closeClick{
    !self.closeBlock ? : self.closeBlock(NO,@"",1);
    [self dismissViewControllerAnimated:YES completion:nil];
}

//全部买入
-(void)buyAllClick{
   if(priceBtn.isSelected){
       double apeie = [self.model.price doubleValue]; //单价 * 数量
       double amount = [self.model.surplus doubleValue];
       inputField.text = [NSString stringWithFormat:@"%.2f",apeie * amount];
   }else{
       inputField.text = self.model.surplus;
   }
   [self changedTextField:inputField];
}

#pragma mark -给 textfield添加事件，只要值改变就调用此函数
-(void)changedTextField:(UITextField *)textField
{
    NSInteger maxLenth = 0;
    NSInteger inputLenth = [textField.text componentsSeparatedByString:@"."][0].length;
    if([self.model.limit_max doubleValue] >0){
        maxLenth = [self.model.limit_max componentsSeparatedByString:@"."][0].length;
    }else{
        maxLenth = 10000000000;
    }

    //限制输入长度，超过最大金额不让继续输入了
    if (maxLenth < inputLenth) {
       textField.text = [textField.text substringToIndex: maxLenth];
    }
    
    if(textField.text.length == 0){
        moneySum.text = @"¥ 0.00 \n $ 0.00";
        self.totalMoney = @"0.00";
        self.buyNum = [NSString stringWithFormat:@"%.8f",[@"0" doubleValue]];
        [orderBtn setBackgroundColor:rgba(69, 83, 117, 1)];
        orderBtn.enabled = NO;
    }else{
        //按价格购买 交易总额 = 输入的数字 购买数量 = 总额(输入的数字) / 单价
        if(priceBtn.isSelected){
            moneySum.text = [NSString stringWithFormat:@"¥ %.2f \n $ %.2f",[textField.text doubleValue],[textField.text doubleValue]/7];
            self.totalMoney = [NSString stringWithFormat:@"%.2f",[textField.text doubleValue]];
            //购买数量
            double amount = [textField.text doubleValue] / [self.model.price doubleValue];
            self.buyNum = [NSString stringWithFormat:@"%.8f",amount];
        }else{ //按数量购买 交易总额 = 输入的数量 * 单价  购买数量 = 输入的数字
            double apeie = [self.model.price doubleValue];
            double amount = [textField.text doubleValue];
            double sumNum = apeie * amount;
            
            moneySum.text = [NSString stringWithFormat:@"¥ %.2f \n $ %.2f",sumNum,sumNum/7];
            self.totalMoney = [NSString stringWithFormat:@"%.2f",sumNum];
            self.buyNum = [NSString stringWithFormat:@"%.8f",[textField.text doubleValue]];
        }
        [orderBtn setBackgroundColor:MainColor];
        orderBtn.enabled = YES;
    }
    
    amount.text = [NSString stringWithFormat:@"%@ %@ %@",LocalizationKey(@"FiatAmount"),self.buyNum,self.model.symbol];
}

-(void)numClick:(UIButton *)btn{
    numBtn.selected = YES;
    priceBtn.selected = NO;
    numBtn.userInteractionEnabled = NO;
    priceBtn.userInteractionEnabled = YES;
    
    btnBottomView.hidden = YES;
    btnBottomView1.hidden = NO;
    
    inputField.text = @"";
//    if([self.buyOrSell isEqualToString:@"1"]){
//       inputField.placeholder = LocalizationKey(@"Buy amount1");
//    }else{
//       inputField.placeholder = LocalizationKey(@"Buy amount2");
//    }
    [self setInputFieldPlaceHolder:YES];
     
    coinName.text = self.model.symbol;
    self.buyNum = [NSString stringWithFormat:@"%.8f",[@"0" doubleValue]];
    amount.text = [NSString stringWithFormat:@"%@ %@ %@",LocalizationKey(@"FiatAmount"),self.buyNum,self.model.symbol];
    moneySum.text = @"¥ 0.00 \n $ 0.00";
    self.totalMoney = @"0.00";
    [orderBtn setBackgroundColor:rgba(69, 83, 117, 1)];
    orderBtn.enabled = NO;
}

-(void)priceClick:(UIButton *)btn{
    numBtn.selected = NO;
    priceBtn.selected = YES;
    numBtn.userInteractionEnabled = YES;
    priceBtn.userInteractionEnabled = NO;
    
    btnBottomView1.hidden = YES;
    btnBottomView.hidden = NO;
    
    inputField.text = @"";
//    if([self.buyOrSell isEqualToString:@"1"]){
//        inputField.placeholder = LocalizationKey(@"Total buy amount1");
//    }else{
//        inputField.placeholder = LocalizationKey(@"Total buy amount2");
//    }
    [self setInputFieldPlaceHolder:NO];
    coinName.text = @"CNY";
    self.buyNum = [NSString stringWithFormat:@"%.8f",[@"0" doubleValue]];
    amount.text = [NSString stringWithFormat:@"%@ %@ %@",LocalizationKey(@"FiatAmount"),self.buyNum,self.model.symbol];
    moneySum.text = @"¥ 0.00 \n $ 0.00";
    self.totalMoney = @"0.00";
    [orderBtn setBackgroundColor:rgba(69, 83, 117, 1)];
    orderBtn.enabled = NO;
}

/**
 下单  各种条件判断
 */
-(void)orderClick{
    //输入金额为0
    if([inputField.text doubleValue] == 0){
        printAlert(LocalizationKey(@"FiatTip16"), 1.f);
        return;
    }
    
    //限制注册时间
    if(![self.model.limit_reg_time isEqualToString:@"0"]){
        printAlert(LocalizationKey(@"FiatTip17"), 1.f);
        return;
    }
    
    //限制认证等级
  //  NSInteger verifyLevel = [self.model.verify_level integerValue];
    
    
    //按价格下单
    double inputBeforMinNum;
    if(priceBtn.isSelected){
        if([limitNum.text isEqualToString:LocalizationKey(@"No limit")]){
            
        }else{
            //输入后的总金额
            double inputNum = [self.totalMoney doubleValue];
            
            //买家定的最小金额
            inputBeforMinNum = [self.model.limit_min doubleValue];
            
            //买家定的最大金额
            double inputBeforMaxNum = [self.model.limit_max doubleValue];
            
            if(inputNum > inputBeforMaxNum){
                printAlert(LocalizationKey(@"FiatTip18"), 1.f);
                return;
            }
            
            if(inputNum < inputBeforMinNum){
                printAlert(LocalizationKey(@"FiatTip19"), 1.f);
                return;
            }
        }
       
    }else{ //按数量下单
        if([limitNum.text isEqualToString:LocalizationKey(@"No limit")]){
            
        }else{
            double inputCoinNum = [self.buyNum doubleValue];
            
            //买家定的最小数量
            double inputBeforCoinMinNum = [self.model.limit_min doubleValue] / [self.model.price doubleValue];
            
            //买家定的最大数量
            double inputBeforCoinMaxNum = [self.model.surplus doubleValue];
            
            if(inputCoinNum < inputBeforCoinMinNum){
                printAlert(LocalizationKey(@"FiatTip20"), 1.f);
                return;
            }
            
            if(inputCoinNum > inputBeforCoinMaxNum){
                printAlert(LocalizationKey(@"FiatTip21"), 1.f);
                return;
            }
        } 
    }
   
    //总价
    double totalMoney = [self.totalMoney doubleValue];
    //单价
    double price =  [self.model.price doubleValue];
    //购买的数量 防止精度问题不用buyNum变量了  [self.buyNum doubleValue]
    NSString *amount =  [self decimalNumberMutiplyWithString:self.totalMoney multiplicandValue:self.model.price]; //totalMoney / price;
    
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:0];
    
    md[@"otc_id"] =  [NSString stringWithFormat:@"%@",self.model.otcId] ;
    md[@"buy_num"] = amount;
    md[@"total_money"] = [ToolUtil stringFromNumber:totalMoney withlimit:2];
    md[@"price"] = [ToolUtil stringFromNumber:price withlimit:2]   ;
//    md[@"otc_id"] =  [NSString stringWithFormat:@"%@",self.model.otcId] ;
//    md[@"buy_num"] = [self changeDoubleToString:[self.buyNum doubleValue]];
//    md[@"total_money"] = [self changeDoubleToString:[self.self.totalMoney doubleValue]];;
//    md[@"price"] = [self changeDoubleToString:[self.model.price doubleValue]];   ;
    if([self.buyOrSell isEqualToString:@"0"]){   //我要卖 进行出售
         [self.afnetWork jsonPostDict:@"/api/otc/sellOtc" JsonDict:md Tag:@"1"];
    }else{  //我要买。进行购买
         [self.afnetWork jsonPostDict:@"/api/otc/buyOtc" JsonDict:md Tag:@"1"];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    NSInteger flag=0;
    //价格下单
    NSInteger limited;
    if(priceBtn.isSelected){
        limited = 2;
    }else{
        limited = transactionDecimalPoint;
    }

   //小数点后需要限制的个数
    for (int i = (int)(futureString.length - 1); i>=0; i--) {
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

-(NSString *)decimalNumberMutiplyWithString:(NSString *)multiplierValue multiplicandValue:(NSString *)multiplicandValue{
    NSDecimalNumber *multiplierNumber = [NSDecimalNumber decimalNumberWithString:multiplierValue];
    NSDecimalNumber *multiplicandNumber = [NSDecimalNumber decimalNumberWithString:multiplicandValue];
    NSDecimalNumber *product = [multiplierNumber decimalNumberByDividingBy:multiplicandNumber];

    return [ToolUtil stringFromNumber:[product doubleValue] withlimit:transactionDecimalPoint];
  
}


- (NSString *)changeDoubleToString:(double)d{
    NSString *dStr = [NSString stringWithFormat:@"%f", d];
    NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithString:dStr];
    return dn.stringValue;
}

#pragma mark - netBack
- (void)getHttpData_array:(NSDictionary *)dict response:(Response)flag Tag:(NSString *)tag{
    [MBManager hideAlert];
    if (flag == Success) {
        switch ([dict[@"code"] integerValue]) {
            case 0:
            {
                if([[NSString stringWithFormat:@"%@",dict[@"msg"]] containsString:@"KYC1"]){
                    [self dismissViewControllerAnimated:YES completion:^{
                        !self.closeBlock ? : self.closeBlock(YES,dict[@"msg"],300);
                    }];
                }else{
                   printAlert(dict[@"msg"], 1);
                }
            }
                break;
            case 1:
               {
                   if([dict[@"msg"] isEqualToString:LocalizationKey(@"FiatTip22")]){
                       [self dismissViewControllerAnimated:YES completion:^{
                          !self.closeBlock ? : self.closeBlock(YES,dict[@"data"][@"otc_order_id"],1);
                       }];
                   }else{
                       printAlert(dict[@"msg"], 1);
                   }
               }
                break;
            case 200:
            {
                
                [self dismissViewControllerAnimated:YES completion:^{
                   !self.closeBlock ? : self.closeBlock(YES,dict[@"msg"],200);
                }];
            }
                break;
            case 201:
                printAlert(LocalizationKey(@"NetWorkErrorTip1"), 1);  
                break;
            case 300:
            {
                if([[NSString stringWithFormat:@"%@",dict[@"msg"]] containsString:@"KYC1"]){
                    [self dismissViewControllerAnimated:YES completion:^{
                        !self.closeBlock ? : self.closeBlock(YES,dict[@"msg"],300);
                    }];
                }else{
                    printAlert(dict[@"msg"], 1);
                }
            }
                break;
            case 301:
            {
                if([[NSString stringWithFormat:@"%@",dict[@"msg"]] containsString:@"KYC2"]){
                    [self dismissViewControllerAnimated:YES completion:^{
                        !self.closeBlock ? : self.closeBlock(YES,dict[@"msg"],301);
                    }];
                }else{
                   printAlert(dict[@"msg"], 1);
                }
            }
                break;
            case 400:
                [self dismissViewControllerAnimated:YES completion:^{
                    !self.closeBlock ? : self.closeBlock(YES,dict[@"msg"],400);
                }];
                break;
        }
    }
}

#pragma mark - timer
-(void)startTime{
    __block NSInteger second = 45;
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second > 0) {
                [autoCloseBtn setTitle:[NSString stringWithFormat:@"%ldS%@",(long)second,LocalizationKey(@"Cancelled in")]  forState:UIControlStateNormal];
                second--;
            }
            else
            {
                [self closeClick];
                dispatch_source_cancel(timer);
            }
        });
    });
    dispatch_resume(timer);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    dispatch_source_cancel(timer);
}

- (void)viewDidLoad {
    [super viewDidLoad];
  
    [self setUpView];
    [self startTime];
}

#pragma mark - ui
-(void)setUpView{
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.view.mas_top);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, ScreenHeight - 450));
    }];
    
    UIView *bac = [UIView new];
    bac.theme_backgroundColor = THEME_BAC_GRAYCOLOR;
    [self.view addSubview:bac];
    [bac mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 450));
    }];
    
    UILabel *buyName = [UILabel new];
    buyName.text = [NSString stringWithFormat:@"%@%@",LocalizationKey(@"Buy"),self.model.symbol];
    buyName.theme_textColor = THEME_TEXT_COLOR;
    buyName.font = [UIFont boldSystemFontOfSize:25];
    [bac addSubview:buyName];
    [buyName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bac.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(bac.mas_top).offset(20);
    }];
    
    UIImageView *coinImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.model.symbol]];
    coinImage.layer.cornerRadius = 20;
    coinImage.layer.masksToBounds = YES;
    [bac addSubview:coinImage];
    [coinImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bac.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(bac.mas_top).offset(30);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    UILabel *apiece = [UILabel new];
    apiece.text = LocalizationKey(@"FiatPrice");
    apiece.theme_textColor = THEME_TEXT_COLOR;
    apiece.font = [UIFont systemFontOfSize:15];
    [bac addSubview:apiece];
    [apiece mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(buyName.mas_left);
        make.top.mas_equalTo(buyName.mas_bottom).offset(5);
    }];
    
    UILabel *pieceNum = [UILabel new];
    pieceNum.text = [NSString stringWithFormat:@"¥ %@\n$ %.2f",self.model.price,[self.model.price doubleValue]/7];
    pieceNum.textColor = MainColor;
    pieceNum.numberOfLines = 2;
    pieceNum.font = [UIFont systemFontOfSize:17];
    [bac addSubview:pieceNum];
    [pieceNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(apiece.mas_right).offset(5);
        make.top.mas_equalTo(apiece.mas_top);
    }];
    
    UIView *xian = [UIView new];
    xian.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [bac addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(pieceNum.mas_bottom).offset(10);
        make.left.mas_equalTo(bac.mas_left);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
    }];
    
    priceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [priceBtn setTitle:LocalizationKey(@"By Price1") forState:UIControlStateNormal];
    [priceBtn setTitleColor:MainColor forState:UIControlStateSelected];
    [priceBtn theme_setTitleColor:THEME_GRAY_TEXTCOLOR forState:UIControlStateNormal];
    priceBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [bac addSubview:priceBtn];
    [priceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(buyName.mas_left);
        make.top.mas_equalTo(xian.mas_bottom).offset(20);
    }];
    [priceBtn sizeToFit];
    [priceBtn setSelected:YES];
    
    numBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [numBtn setTitle:LocalizationKey(@"By amount1") forState:UIControlStateNormal];
    [numBtn setTitleColor:MainColor forState:UIControlStateSelected];
    [numBtn theme_setTitleColor:THEME_GRAY_TEXTCOLOR forState:UIControlStateNormal];
    numBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [bac addSubview:numBtn];
    [numBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(priceBtn.mas_right).offset(30);
        make.centerY.mas_equalTo(priceBtn.mas_centerY).offset(0);
    }];
    [numBtn sizeToFit];
    
    [priceBtn addTarget:self action:@selector(priceClick:) forControlEvents:UIControlEventTouchUpInside];
    [numBtn addTarget:self action:@selector(numClick:) forControlEvents:UIControlEventTouchUpInside];
    
    btnBottomView = [UIView new];
    btnBottomView.backgroundColor = MainColor;
    [bac addSubview:btnBottomView];
    [btnBottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(priceBtn.mas_left);
        make.width.mas_equalTo(priceBtn.mas_width);
        make.bottom.mas_equalTo(priceBtn.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    btnBottomView1 = [UIView new];
    btnBottomView1.backgroundColor = MainColor;
    btnBottomView1.hidden = YES;
    [bac addSubview:btnBottomView1];
    [btnBottomView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(numBtn.mas_left);
        make.width.mas_equalTo(numBtn.mas_width);
        make.bottom.mas_equalTo(numBtn.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    inputField = [UITextField new];
    inputField.layer.theme_borderColor = THEME_LINE_INPUTBORDERCOLOR;
    inputField.layer.borderWidth = 1;
    inputField.theme_textColor = THEME_TEXT_COLOR;
    inputField.font = tFont(16);
    inputField.keyboardType = UIKeyboardTypeDecimalPad;
    inputField.delegate = self;
    [bac addSubview:inputField];
    [inputField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(priceBtn.mas_bottom).offset(20);
        make.left.mas_equalTo(bac.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.right.mas_equalTo(bac.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 50));
    }];
    [inputField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    
    UIView *placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    inputField.leftView = placeholderView;
    inputField.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *rightFieldView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
    [inputField addSubview:rightFieldView];
    [rightFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(inputField.mas_right);
        make.centerY.mas_equalTo(inputField.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(180, 50));
    }];
  
    UIButton *buyAll = [UIButton buttonWithType:UIButtonTypeCustom];
    buyAll.titleLabel.font = tFont(18);
    [buyAll setTitleColor:MainColor forState:UIControlStateNormal];
    [rightFieldView addSubview:buyAll];
    [buyAll mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rightFieldView.mas_right).offset(-10);
        make.centerY.mas_equalTo(rightFieldView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(82, 50));
    }];
    [buyAll addTarget:self action:@selector(buyAllClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line = [UIView new];
    line.backgroundColor = rgba(20, 39, 74, 1);
    [rightFieldView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(buyAll.mas_left).offset( - 7.5);
        make.top.mas_equalTo(buyAll.mas_top).offset(15);
        make.bottom.mas_equalTo(buyAll.mas_bottom).offset(-15);
        make.width.mas_equalTo(1);
    }];
    
    coinName = [UILabel new];
    coinName.text = @"CNY";
    coinName.theme_textColor = THEME_TEXT_COLOR;
    coinName.font = tFont(18);
    [rightFieldView addSubview:coinName];
    [coinName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(rightFieldView.mas_centerY);
        make.right.mas_equalTo(line.mas_left).offset(-7.5);
    }];
    
    inputField.rightView = rightFieldView;
    inputField.rightViewMode = UITextFieldViewModeAlways;
    
    limitNum = [UILabel new];
    
    limitNum.font = tFont(16);
    limitNum.textColor = rgba(126, 139, 163, 1);
    [bac addSubview:limitNum];
    [limitNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(inputField.mas_left);
        make.top.mas_equalTo(inputField.mas_bottom).offset(10);
    }];
    
    if([self.model.limit_min doubleValue] == 0 && [self.model.limit_max doubleValue] == 0){
        limitNum.text = LocalizationKey(@"No limit");
    }else{
        limitNum.text = [NSString stringWithFormat:@"¥ %@ - ¥ %@",self.model.limit_min,self.model.limit_max];
    }
    
    amount = [UILabel new];
    amount.text = [NSString stringWithFormat:@"%@ 0.00000000 %@",LocalizationKey(@"FiatAmount"),self.model.symbol];
    amount.font = tFont(18);
    amount.textColor = rgba(126, 139, 163, 1);
    [bac addSubview:amount];
    [amount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bac.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(limitNum.mas_bottom).offset(5);
    }];
    
    UILabel *moenySumTip = [UILabel new];
    moenySumTip.textColor = rgba(126, 139, 163, 1);
    moenySumTip.text = LocalizationKey(@"Payment total");
    moenySumTip.font = tFont(18);
    [bac addSubview:moenySumTip];
    [moenySumTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(inputField.mas_left);
        make.top.mas_equalTo(amount.mas_bottom).offset(5);
    }];
    
    moneySum = [UILabel new];
    moneySum.textColor = MainColor;
    moneySum.text = @"¥0.00 \n $ 0.00";
    moneySum.font = tFont(22);
    moneySum.numberOfLines = 2;
    [bac addSubview:moneySum];
    [moneySum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bac.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(moenySumTip.mas_top).offset(0);
    }];
    
    autoCloseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [autoCloseBtn setTitle:NSStringFormat(@"45%@",LocalizationKey(@"Cancelled in")) forState:UIControlStateNormal];
    [autoCloseBtn setBackgroundColor:rgba(39, 53, 79, 1)];
    autoCloseBtn.titleLabel.font = tFont(18);
    autoCloseBtn.layer.cornerRadius = 3;
    [bac addSubview:autoCloseBtn];
    
    CGFloat bottomSpacing;
    if(IS_IPHONE_X){
        bottomSpacing = 15;
    }else{
        bottomSpacing = 20;
    }
    
    [autoCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bac.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(moneySum.mas_bottom).offset(bottomSpacing);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth / 2 - 30, 50) );
    }];
    
    orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [orderBtn setTitle:LocalizationKey(@"FiatOrder") forState:UIControlStateNormal];
    orderBtn.enabled = NO;
    [orderBtn setBackgroundColor:rgba(69, 83, 117, 1)];
    orderBtn.titleLabel.font = tFont(18);
    orderBtn.layer.cornerRadius = 3;
    [bac addSubview:orderBtn];
    [orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(bac.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(moneySum.mas_bottom).offset(bottomSpacing);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth / 2 - 30, 50) );
    }];
    
    [autoCloseBtn addTarget:self action:@selector(closeClick) forControlEvents:UIControlEventTouchUpInside];
    [orderBtn addTarget:self action:@selector(orderClick) forControlEvents:UIControlEventTouchUpInside];

    if([self.buyOrSell isEqualToString:@"1"]){
        buyName.text = [NSString stringWithFormat:@"%@%@",LocalizationKey(@"FiatBuy"),self.model.symbol];
        [priceBtn setTitle:LocalizationKey(@"By Price1") forState:UIControlStateNormal];
        [numBtn setTitle:LocalizationKey(@"By amount1") forState:UIControlStateNormal];
    //    inputField.placeholder = LocalizationKey(@"Total buy amount1");
    //    [inputField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
       // inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"Total buy amount1")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
        [buyAll setTitle:LocalizationKey(@"BuyAll") forState:UIControlStateNormal];
    }else{
        buyName.text = [NSString stringWithFormat:@"%@%@",LocalizationKey(@"FiatSell"),self.model.symbol];
        [priceBtn setTitle:LocalizationKey(@"By Price2") forState:UIControlStateNormal];
        [numBtn setTitle:LocalizationKey(@"By amount2") forState:UIControlStateNormal];
     //   inputField.placeholder = LocalizationKey(@"Total buy amount2");
     //   [inputField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
        [buyAll setTitle:LocalizationKey(@"SellAll") forState:UIControlStateNormal];
        
    }
    [self setInputFieldPlaceHolder:NO];
}

/// 设置输入框默认文字
/// @param clickType 点击类型 ture是num点击 false是price点击
-(void)setInputFieldPlaceHolder:(BOOL)clickType {
    if([self.buyOrSell isEqualToString:@"1"]){
        if (clickType) {
            inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"Buy amount1")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
        }else{
            inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"Total buy amount1")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
        }
    }else{
        if (clickType) {
            inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"Buy amount2")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
        }else{
             inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"Total buy amount2")) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
        }
    }
}

/**
 我要买 参数用1
 我要卖 参数用0
 */
-(void)setBuyOrSell:(NSString *)buyOrSell{
    _buyOrSell = buyOrSell;
    
}

@end
