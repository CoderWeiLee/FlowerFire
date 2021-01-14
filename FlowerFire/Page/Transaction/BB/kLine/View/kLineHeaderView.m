//
//  kLineHeaderView.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/5.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "kLineHeaderView.h"

@implementation kLineHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpView];
    }
    return self;
}

-(void)setUpView{
    self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    
    self.nowPrice = [UILabel new];
    self.nowPrice.font = [UIFont boldSystemFontOfSize:25];
    self.nowPrice.text = @"--";
    self.nowPrice.textColor = qutesRedColor;
    self.nowPrice.backgroundColor = self.backgroundColor;
    self.nowPrice.layer.masksToBounds = YES;
    [self addSubview:self.nowPrice];
    [self.nowPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
    
    self.CNYLabel = [UILabel new];
    self.CNYLabel.font = tFont(15);
    self.CNYLabel.text = @"--";
    self.CNYLabel.backgroundColor = self.backgroundColor;
    self.CNYLabel.layer.masksToBounds = YES;
    self.CNYLabel.textColor = ContractDarkBlueColor;
    [self addSubview:self.CNYLabel];
    [self.CNYLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nowPrice.mas_bottom).offset(20);
        make.left.mas_equalTo(self.nowPrice.mas_left);
    }];
    
    self.changeLabel = [UILabel new];
    self.changeLabel.font = tFont(15);
    self.changeLabel.text = @"--";
    self.changeLabel.textColor = qutesRedColor;
    self.changeLabel.backgroundColor = self.backgroundColor;
    self.changeLabel.layer.masksToBounds = YES;
    [self addSubview:self.changeLabel];
    [self.changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.CNYLabel.mas_centerY).offset(0);
        make.left.mas_equalTo(self.CNYLabel.mas_right).offset(5);
    }];
    
    self.hightPrice = [UILabel new];
    self.hightPrice.font = tFont(14);
    self.hightPrice.text = @"--";
    self.hightPrice.theme_textColor = THEME_TEXT_COLOR;
    self.hightPrice.backgroundColor = self.backgroundColor;
    self.hightPrice.layer.masksToBounds = YES;
    [self addSubview:self.hightPrice];
    [self.hightPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nowPrice.mas_top).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
    
    self.Hlabel = [UILabel new];
    self.Hlabel.font = tFont(14);
    self.Hlabel.text = LocalizationKey(@"H");
    self.Hlabel.textColor = ContractDarkBlueColor;
    self.Hlabel.backgroundColor = self.backgroundColor;
    self.Hlabel.layer.masksToBounds = YES;
    [self addSubview:self.Hlabel];
    [self.Hlabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.hightPrice.mas_centerY).offset(0);
        make.left.mas_equalTo(self.mas_centerX).offset(20);
    }];
    
    self.LowPrice = [UILabel new];
    self.LowPrice.font = tFont(14);
    self.LowPrice.text = @"--";
    self.LowPrice.theme_textColor = THEME_TEXT_COLOR;
    self.LowPrice.backgroundColor = self.backgroundColor;
    self.LowPrice.layer.masksToBounds = YES;
    [self addSubview:self.LowPrice];
    [self.LowPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hightPrice.mas_bottom).offset(8);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
    
    self.Llabel = [UILabel new];
    self.Llabel.font = tFont(14);
    self.Llabel.text = LocalizationKey(@"L");
    self.Llabel.textColor = ContractDarkBlueColor;
    self.Llabel.backgroundColor = self.backgroundColor;
    self.Llabel.layer.masksToBounds = YES;
    [self addSubview:self.Llabel];
    [self.Llabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.LowPrice.mas_centerY).offset(0);
        make.left.mas_equalTo(self.mas_centerX).offset(20);
    }];
    
    self.numberLabel = [UILabel new];
    self.numberLabel.font = tFont(14);
    self.numberLabel.text = @"--";
    self.numberLabel.theme_textColor = THEME_TEXT_COLOR;
    self.numberLabel.backgroundColor = self.backgroundColor;
    self.numberLabel.layer.masksToBounds = YES;
    [self addSubview:self.numberLabel];
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.CNYLabel.mas_bottom).offset(0);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
    
    self.Alabel = [UILabel new];
    self.Alabel.font = tFont(14);
    self.Alabel.text = @"24H";
    self.Alabel.textColor = ContractDarkBlueColor;
    self.Alabel.backgroundColor = self.backgroundColor;
    self.Alabel.layer.masksToBounds = YES;
    [self addSubview:self.Alabel];
    [self.Alabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.numberLabel.mas_centerY).offset(0);
        make.left.mas_equalTo(self.mas_centerX).offset(20);
    }];
}

-(void)setModel:(QuotesTransactionPairModel *)model{
    _model = model;
    self.nowPrice.text = [ToolUtil stringFromNumber:[model.New_price doubleValue] withlimit:model.dec];
    NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
    self.CNYLabel.text = [NSString stringWithFormat:@"≈%.2f CNY",[self.nowPrice.text doubleValue]*[cnyRate doubleValue]*1];
    double change = [model.change doubleValue];
    
    if (change <0) {
        self.changeLabel.textColor = qutesRedColor;
        self.changeLabel.text = [NSString stringWithFormat:@"%.2f%%", change];
    }else if (change >0) {
        self.changeLabel.textColor = qutesGreenColor;
        self.changeLabel.text = [NSString stringWithFormat:@"+%.2f%%", change];
    }else{
        self.changeLabel.textColor = qutesRedColor;
        self.changeLabel.text = @"0.00%";
    }
   
    self.hightPrice.text = [ToolUtil stringFromNumber:[model.high_price doubleValue] withlimit:model.dec];
    self.LowPrice.text = [ToolUtil stringFromNumber:[model.low_price doubleValue] withlimit:model.dec];
    self.numberLabel.text = model.deal_amount_24h;
}


-(void)setY_KLineModel:(Y_KLineModel *)Y_KLineModel{
    self.nowPrice.text = NSStringFormat(@"$%f",(Y_KLineModel.High.doubleValue + Y_KLineModel.Low.doubleValue)/2);
    self.CNYLabel.hidden = YES;
//    double change = [model.change doubleValue];
//
//    if (change <0) {
//        self.changeLabel.textColor = qutesRedColor;
//        self.changeLabel.text = [NSString stringWithFormat:@"%.2f%%", change];
//    }else if (change >0) {
         self.changeLabel.textColor = qutesGreenColor;
    self.changeLabel.text = [NSString stringWithFormat:@"+%@%%", @"0.12"];
//    }else{
//        self.changeLabel.textColor = qutesRedColor;
//        self.changeLabel.text = @"0.00%";
//    }
    
    self.hightPrice.text = NSStringFormat(@"%@",Y_KLineModel.High);
    self.LowPrice.text = NSStringFormat(@"%@",Y_KLineModel.Low);
    self.Alabel.text = LocalizationKey(@"Executed");
    self.numberLabel.text = NSStringFormat(@"%f",Y_KLineModel.Volume);
}

@end
