//
//  CurrencyTransactionLimitPriceView.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//  限价视图

#import "CurrencyTransactionLimitPriceView.h"

@interface CurrencyTransactionLimitPriceView ()<StepSliderDelegate>
{
     double previousValue;  // *用来记录Stepper.value*的上一次值
    UILabel *coinName;
}
@end

@implementation CurrencyTransactionLimitPriceView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.PriceTF = [UITextField new];
        self.PriceTF.theme_textColor = THEME_TEXT_COLOR;
       // [self.PriceTF setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
    
        self.PriceTF.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizationKey(@"Price") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
        self.PriceTF.font = tFont(14); 
        self.PriceTF.layer.cornerRadius = 1;
        self.PriceTF.layer.borderWidth = 1;
        self.PriceTF.keyboardType = UIKeyboardTypeDecimalPad;
        self.PriceTF.layer.theme_borderColor = THEME_LINE_INPUTBORDERCOLOR;
        self.PriceTF.tag = 1;
        [self.PriceTF addTarget:self action:@selector(textfieldValueChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:self.PriceTF];
        [self.PriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(10);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth/3*2 - 30, 40));
        }];
        
        UIView *placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        self.PriceTF.leftView = placeholderView;
        self.PriceTF.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 94, 40)];
  
        UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 40)];
        line2.theme_backgroundColor = THEME_LINE_INPUTBORDERCOLOR;
        [rightView addSubview:line2];
        
        _stepper = [[UIStepper alloc] initWithFrame:CGRectMake(0, 5.5, 94, 29)];
        [_stepper setBackgroundImage:nil forState:(UIControlStateNormal)];
        [_stepper setDividerImage:nil forLeftSegmentState:(UIControlStateNormal) rightSegmentState:(UIControlStateNormal)];
       // _stepper.tintColor = rgba(107, 138, 174, 1) ;
        _stepper.value = 1;
        [_stepper setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forState:UIControlStateNormal];
//        [_stepper setIncrementImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
//        [_stepper setDecrementImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
        [_stepper addTarget:self action:@selector(steper:) forControlEvents:UIControlEventValueChanged];
        [rightView addSubview:_stepper];
        self.PriceTF.rightView = rightView;
        self.PriceTF.rightViewMode = UITextFieldViewModeAlways;
        
        self.CNYPrice = [UILabel new];
        self.CNYPrice.textColor = rgba(57, 73, 93, 1);
        self.CNYPrice.font = tFont(14);
        self.CNYPrice.text = @"≈0.0CNY";
        self.CNYPrice.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        self.CNYPrice.layer.masksToBounds = YES;
        [self addSubview:self.CNYPrice];
        [self.CNYPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.PriceTF.mas_bottom).offset(0);
            make.left.mas_equalTo(self.PriceTF.mas_left);
        }]; 
        
        self.AmountTF = [UITextField new];
        self.AmountTF.placeholder = LocalizationKey(@"Amount");
        self.AmountTF.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizationKey(@"Amount") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
        
     //   [self.AmountTF setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
        self.AmountTF.font = tFont(14);
        self.AmountTF.theme_textColor = THEME_TEXT_COLOR;
        self.AmountTF.layer.cornerRadius = 1;
        self.AmountTF.layer.borderWidth = 1;
        self.AmountTF.layer.theme_borderColor = THEME_LINE_INPUTBORDERCOLOR;
        self.AmountTF.keyboardType = UIKeyboardTypeDecimalPad;
        self.AmountTF.tag = 2;
        [self.AmountTF addTarget:self action:@selector(textfieldValueChange:) forControlEvents:UIControlEventEditingChanged];
        [self addSubview:self.AmountTF];
        [self.AmountTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.CNYPrice.mas_bottom).offset(10);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth/3*2 - 30, 40));
        }];
        
        placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
        self.AmountTF.leftView = placeholderView;
        self.AmountTF.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *placeholderRightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 40)];
        coinName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
        coinName.textColor = ContractDarkBlueColor;
        coinName.text = @"BTC";
        coinName.font = tFont(15);
        coinName.textAlignment = NSTextAlignmentRight;
        coinName.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        coinName.layer.masksToBounds = YES;
        [placeholderRightView addSubview:coinName];
        self.AmountTF.rightViewMode = UITextFieldViewModeAlways;
        self.AmountTF.rightView = placeholderRightView;
       
        [self.PriceTF setAdjustsFontSizeToFitWidth:YES];
        [self.AmountTF setAdjustsFontSizeToFitWidth:YES];
        
        self.baseCoin = coinName;
        
        self.Useable = [UILabel new];
        self.Useable.textColor = ContractDarkBlueColor;
        self.Useable.font = tFont(15.5);
        self.Useable.text = NSStringFormat(@"%@0.00BTC",LocalizationKey(@"Available"))  ;
        self.Useable.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        self.Useable.layer.masksToBounds = YES;
        [self addSubview:self.Useable];
        [self.Useable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.AmountTF.mas_bottom).offset(5);
            make.right.mas_equalTo(self.AmountTF.mas_right);
        }];
        
        self.slider = [[StepSlider alloc] init];
        self.slider.delegate = self;
        self.slider.trackHeight = 3;
        self.slider.trackCircleRadius = 6;
        self.slider.sliderCircleRadius = 6;
        self.slider.trackColor= rgba(230, 230, 230, 1);
        self.slider.tintColor = qutesGreenColor;
        self.slider.sliderCircleImage = [UIImage imageNamed:@"circularGreen"];
        [self.slider setMaxCount:5];
        [self.slider setIndex:0 animated:NO];
        //self.slider.backgroundColor = navBarColor;
        
        [self.slider setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
        [self addSubview:self.slider];
        [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.Useable.mas_bottom).offset(15);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(40);
        }];
        
        self.sliderNum = [UILabel new];
        self.sliderNum.textColor = ContractDarkBlueColor;
        self.sliderNum.font = tFont(14);
        self.sliderNum.text = @"0";
        self.sliderNum.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        self.sliderNum.layer.masksToBounds = YES;
        [self addSubview:self.sliderNum];
        [self.sliderNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.slider.mas_bottom).offset(-5);
            make.left.mas_equalTo(self.slider.mas_left);
        }];
        
        self.sliderMaxValue = [UILabel new];
        self.sliderMaxValue.textColor = ContractDarkBlueColor;
        self.sliderMaxValue.font = tFont(14);
        self.sliderMaxValue.text = @"0 BTC";
        self.sliderMaxValue.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        self.sliderMaxValue.layer.masksToBounds = YES;
        [self addSubview:self.sliderMaxValue];
        [self.sliderMaxValue mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.slider.mas_bottom).offset(-5);
            make.right.mas_equalTo(self.slider.mas_right);
        }];
        
        self.TradeNumber = [UILabel new];
        self.TradeNumber.textColor = ContractDarkBlueColor;
        self.TradeNumber.font = tFont(15);
        self.TradeNumber.text = LocalizationKey(@"ccTotal");
        self.TradeNumber.adjustsFontSizeToFitWidth = YES;
        self.TradeNumber.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        self.TradeNumber.layer.masksToBounds = YES;
        [self addSubview:self.TradeNumber];
        [self.TradeNumber mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.sliderMaxValue.mas_bottom).offset(15);
            make.left.mas_equalTo(self.slider.mas_left);
            make.right.mas_equalTo(self.mas_right);
        }];
        
        self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.buyBtn.layer.cornerRadius = 2;
        self.buyBtn.layer.masksToBounds = YES;
        self.buyBtn.backgroundColor = qutesGreenColor;
    
        [self addSubview:self.buyBtn];
        [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.TradeNumber.mas_bottom).offset(8);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.right.mas_equalTo(self.mas_right).offset(-0);
            make.height.mas_equalTo(@45);
        }];
        
        if(![WTUserInfo isLogIn]){
            [self.buyBtn setTitle:LocalizationKey(@"Login") forState:UIControlStateNormal];
        }else{
            [self.buyBtn setTitle:NSStringFormat(@"%@ BTC",LocalizationKey(@"ccBuy1")) forState:UIControlStateNormal];
        }
        
      //  self.exchangeRate = 0.23;
   //   [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchTheme) name:SDThemeChangedNotification object:nil];
    }
    return self;
}

//-(void)switchTheme{
//    if([[SDThemeManager sharedInstance].themeName isEqualToString:WHITE_THEME]){
//      //  [_stepper setBackgroundImage:[UIImage imageWithColor:white] forState:UIControlStateNormal];
//         _stepper.tintColor = rgba(107, 138, 174, 1) ;
//    }else{
//         _stepper.tintColor = [UIColor whiteColor] ;
//      //  [_stepper setBackgroundImage:[UIImage imageWithColor:navBarColor] forState:UIControlStateNormal];
//    }
//}

#pragma mark - action
-(void)steper:(UIStepper *)stepper{
    double i = stepper.value ;
    //加
    if (stepper.value > previousValue) {
        self.PriceTF.text=[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue] + stepper.stepValue withlimit:self.priceScale];//10的N次幂
    } else { //减
        self.PriceTF.text=[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue] - stepper.stepValue withlimit:self.priceScale];//10的N次幂
    }
    previousValue = i;
    NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
    self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*1];
    self.TradeNumber.text=[NSString stringWithFormat:@"%@ %f%@",LocalizationKey(@"ccTotal"),[self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue],self.baseCoinName];
    
    self.sliderMaxValue.text=[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[self.moneyNum doubleValue]/[self.PriceTF.text doubleValue] withlimit:self.fromScale],self.baseCoin.text];

}

//输入框监听
- (void)textfieldValueChange:(UITextField *)textField{
    self.TradeNumber.text=[NSString stringWithFormat:@"%@ %f%@",LocalizationKey(@"ccTotal"),[self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue],self.baseCoinName];
//    self.TradeNumber.text=[NSString stringWithFormat:@"%@ %@%@",@"交易额",[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue] withlimit:self.coinScale],self.baseCoinName];
    NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
    self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*1];
    //数量
    NSArray *array = [self.sliderMaxValue.text componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
    NSString *numStr = array[0];
    if ([textField.text floatValue] <= 0) {
        [self.slider setIndex:0 animated:NO];
    }
    else if ([textField.text floatValue] > [numStr floatValue]){
    //    printAlert(LocalizationKey(@"ccTip8"), 1.f);
    //    textField.text = @"";
    //    [self.slider setIndex:0 animated:NO];
        self.TradeNumber.text=[NSString stringWithFormat:@"%@ %@%@",LocalizationKey(@"ccTotal"),[ToolUtil stringFromNumber:0.00000000 withlimit:8],self.baseCoinName];
    }else{
        [self.slider setIndex:[textField.text doubleValue]/[numStr doubleValue]*4 animated:NO];
    }
    self.sliderMaxValue.text=[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[self.moneyNum doubleValue]/[self.PriceTF.text doubleValue] withlimit:self.fromScale],self.baseCoin.text];

}
 

#pragma mark - sliderDelegate
-(void)getSliderValue:(CGFloat)sliderValue{
    NSArray *array = [self.sliderMaxValue.text componentsSeparatedByString:@" "]; //从字符A中分隔成2个元素的数组
    NSString *numStr = array[0];
    self.AmountTF.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[numStr doubleValue]*sliderValue/4 withlimit:self.fromScale]];
//    self.TradeNumber.text=[NSString stringWithFormat:@"交易额 %@%@",[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue] withlimit:self.coinScale],self.baseCoinName];
    self.TradeNumber.text=[NSString stringWithFormat:@"%@ %f%@",LocalizationKey(@"ccTotal"),[self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue],self.baseCoinName];
}

-(void)setBaseCoinName:(NSString *)baseCoinName{
    if([HelpManager isBlankString:baseCoinName]){
        _baseCoinName = @"--";
    }else{
        _baseCoinName = baseCoinName;
        CGSize btnSize = [HelpManager getLabelWidth:15 labelTxt:baseCoinName];
        coinName.width = btnSize.width+15;
    }
}

-(void)setPriceScale:(int)priceScale{
    _priceScale = priceScale;
    
    self.stepper.stepValue = (1/(double)pow(10, priceScale));
    self.stepper.minimumValue = - [self.PriceTF.text doubleValue];
}

-(void)setFromScale:(int)fromScale{
    _fromScale = fromScale;
}

-(void)setToScale:(int)toScale{
    _toScale = toScale;
}


@end
