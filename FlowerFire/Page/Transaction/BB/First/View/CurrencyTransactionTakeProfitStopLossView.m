//
//  CurrencyTransactionTakeProfitStopLossView.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//  止盈止损视图

#import "CurrencyTransactionTakeProfitStopLossView.h"

@interface CurrencyTransactionTakeProfitStopLossView ()
{
    UIStepper *stepper1;
}
@end

@implementation CurrencyTransactionTakeProfitStopLossView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.TriggerPriceTF = [UITextField new];
       // self.TriggerPriceTF.placeholder = @"触发价";
        self.TriggerPriceTF.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"触发价" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18],  SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
      //  [self.TriggerPriceTF setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
        self.TriggerPriceTF.font = tFont(14);
        self.TriggerPriceTF.theme_textColor = THEME_TEXT_COLOR;
        self.TriggerPriceTF.layer.cornerRadius = 1;
        self.TriggerPriceTF.layer.borderWidth = 1;
        self.TriggerPriceTF.layer.theme_borderColor = THEME_LINE_INPUTBORDERCOLOR;
        [self addSubview:self.TriggerPriceTF];
        [self.TriggerPriceTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(10);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth/3*2 - 40, 50));
        }];
        
        UIView *placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)];
        self.TriggerPriceTF.leftView = placeholderView;
        self.TriggerPriceTF.leftViewMode = UITextFieldViewModeAlways;
        
        stepper1 = [[UIStepper alloc] initWithFrame:CGRectMake(0, 0, 80, 70)];
        [stepper1 setBackgroundImage:nil forState:(UIControlStateNormal)];
        [stepper1 setDividerImage:nil forLeftSegmentState:(UIControlStateNormal) rightSegmentState:(UIControlStateNormal)];
        stepper1.stepValue = 1;
        stepper1.tintColor = [UIColor colorWithCGColor:self.TriggerPriceTF.layer.borderColor] ;
       // [stepper1 setIncrementImage:[UIImage imageNamed:@"transaction_1"] forState:UIControlStateNormal];
      //  [stepper1 setDecrementImage:[UIImage imageNamed:@"transaction_2"] forState:UIControlStateNormal];
        [stepper1 addTarget:self action:@selector(steper:) forControlEvents:UIControlEventValueChanged];
        self.TriggerPriceTF.rightView = stepper1;
        self.TriggerPriceTF.rightViewMode = UITextFieldViewModeAlways;
        
        self.TriggerCNYLabel = [UILabel new];
        self.TriggerCNYLabel.textColor = rgba(57, 73, 93, 1);
        self.TriggerCNYLabel.font = tFont(14);
        self.TriggerCNYLabel.text = @"≈0.0CNY";
        [self addSubview:self.TriggerCNYLabel];
        [self.TriggerCNYLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.TriggerPriceTF.mas_bottom).offset(5);
            make.left.mas_equalTo(self.TriggerPriceTF.mas_left);
        }];
        
        [self.PriceTF mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.TriggerCNYLabel.mas_bottom).offset(15);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth/3*2 - 40, 50));
        }];
    }
    return self;
}

-(void)steper:(UIStepper *)steper{
//    if(steper == self.stepper){
//        double i = steper.value ;
//        //  double now = [self.PriceTF.text doubleValue];
//        self.PriceTF.text = [NSString stringWithFormat:@"%.4f",i];
//        self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.PriceTF.text doubleValue]* self.exchangeRate];
//    }else{
//        double i = steper.value ;
//        //  double now = [self.PriceTF.text doubleValue];
//        self.TriggerPriceTF.text = [NSString stringWithFormat:@"%.4f",i];
//        self.TriggerCNYLabel.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.TriggerPriceTF.text doubleValue]* self.exchangeRate];
//
//    }

}


@end
