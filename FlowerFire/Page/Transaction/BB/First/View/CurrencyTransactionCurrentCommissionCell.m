//
//  CurrencyTransactionCurrentCommissionCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//  当前委托cell

#import "CurrencyTransactionCurrentCommissionCell.h"

#define  CurrentCommissionGrayTextColor rgba(161, 164, 171, 1)
@interface CurrencyTransactionCurrentCommissionCell()
{
    UILabel *type,*time,*price,*amount,*trueTotalPrice ;
    UIButton *cancelBtn;
    UILabel *priceNum,*amountNum,*totalPriceNum;
    NSString *_tradeId; //委托单id
}
@end

@implementation CurrencyTransactionCurrentCommissionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
       // self.backgroundColor = navBarColor;
        [self setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
        line.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
        }];
        
        type  = [UILabel new];
        type.text = @"类型  买入";
        type.textColor = CurrentCommissionGrayTextColor;
        type.font = tFont(14);
        type.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        type.layer.masksToBounds = YES;
        [self addSubview:type];
        [type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).offset(15);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        }];
        
        time = [UILabel new];
        time.text = @"时间  0000-00-00 00:00";
        time.textColor = CurrentCommissionGrayTextColor;
        time.font = tFont(14);
        time.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        time.layer.masksToBounds = YES;
        [self addSubview:time];
        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(type.mas_bottom).offset(10);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        }];
        
        price = [UILabel new];
        price.text = @"价格  (USDT)";
        price.textColor = CurrentCommissionGrayTextColor;
        price.font = tFont(14);
        price.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        price.layer.masksToBounds = YES;
        [self addSubview:price];
        [price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(time.mas_bottom).offset(10);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        }];
        
        amount = [UILabel new];
        amount.text = @"数量  (BTC)";
        amount.textColor = CurrentCommissionGrayTextColor;
        amount.font = tFont(14);
        amount.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        amount.layer.masksToBounds = YES;
        [self addSubview:amount];
        [amount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(price.mas_centerY).offset(0);
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        }];
        
        trueTotalPrice = [UILabel new];
        trueTotalPrice.text = @"实际成交额  (BTC)";
        trueTotalPrice.textColor = CurrentCommissionGrayTextColor;
        trueTotalPrice.font = tFont(14);
        trueTotalPrice.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        trueTotalPrice.layer.masksToBounds = YES;
        trueTotalPrice.adjustsFontSizeToFitWidth = YES;
        [self addSubview:trueTotalPrice];
        [trueTotalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(price.mas_centerY).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.width.mas_lessThanOrEqualTo(ScreenWidth/3-30);
        }];
        
        priceNum = [UILabel new];
        priceNum.text = @"0000";
        priceNum.theme_textColor = THEME_TEXT_COLOR;
        priceNum.font = tFont(13);
        priceNum.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        priceNum.layer.masksToBounds = YES;
        priceNum.adjustsFontSizeToFitWidth = YES;
        [self addSubview:priceNum];
        [priceNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(price.mas_bottom).offset(10);
            make.centerX.mas_equalTo(price.mas_centerX).offset(0).priority(500);
            make.left.mas_lessThanOrEqualTo(self.mas_left).offset(0).priority(200);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-25);
            make.width.mas_lessThanOrEqualTo(ScreenWidth/3-30);
        }];
        
        amountNum = [UILabel new];
        amountNum.text = @"0000";
        amountNum.theme_textColor = THEME_TEXT_COLOR;
        amountNum.font = tFont(13);
        amountNum.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        amountNum.layer.masksToBounds = YES;
         amountNum.adjustsFontSizeToFitWidth = YES;
        [self addSubview:amountNum];
        [amountNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(priceNum.mas_centerY).offset(0);
            make.centerX.mas_equalTo(amount.mas_centerX).offset(0);
            make.width.mas_lessThanOrEqualTo(ScreenWidth/3-30);
        }];
        
        totalPriceNum = [UILabel new];
        totalPriceNum.text = @"0000";
        totalPriceNum.theme_textColor = THEME_TEXT_COLOR;
        totalPriceNum.font = tFont(13);
        totalPriceNum.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        totalPriceNum.layer.masksToBounds = YES;
         totalPriceNum.adjustsFontSizeToFitWidth = YES;
        [self addSubview:totalPriceNum];
        [totalPriceNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(priceNum.mas_centerY).offset(0);
            make.centerX.mas_equalTo(trueTotalPrice.mas_centerX).offset(0);
            make.width.mas_lessThanOrEqualTo(ScreenWidth/3-30);
        }];
   
        
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:@"撤销" forState:UIControlStateNormal];
        [cancelBtn setBackgroundColor:MainBlueColor];
        cancelBtn.layer.cornerRadius = 2;
        cancelBtn.titleLabel.font = tFont(13);
        cancelBtn.layer.masksToBounds = YES;
        [self addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(type.mas_centerY);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.size.mas_equalTo(CGSizeMake(60, 25));
        }];
        
        [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}
//-1 已撤销。0挂售中 1已完成
-(void)setCellData:(CurrencyTransactionModel *)model fromScale:(int)fromScale toScale:(int)toScale priceScale:(int)priceScale{
    _tradeId = model.tradeId;
    type.text = [NSString stringWithFormat:@"%@  %@",LocalizationKey(@"Type"),model.order_type_name];
    time.text = [NSString stringWithFormat:@"%@  %@",LocalizationKey(@"Date"),[HelpManager getTimeStr:model.addtime dataFormat:@"yyyy-MM-dd HH:mm"]];
    
    price.text = [NSString stringWithFormat:@"%@ (%@)",LocalizationKey(@"Price"),model.to_symbol];
    trueTotalPrice.text = [NSString stringWithFormat:@"%@ (%@)",LocalizationKey(@"578Tip175"),model.from_symbol] ;
   
    amountNum.text = [NSString stringWithFormat:@"%@",model.amount];
//    amountNum.text = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[model.surplus doubleValue] withlimit:fromScale]];
    totalPriceNum.text = model.trade_amount;
    if(model.order_status == 0){
        [cancelBtn setTitle:LocalizationKey(@"cancel1") forState:UIControlStateNormal];
        [cancelBtn setBackgroundColor:MainBlueColor];
        [cancelBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
        cancelBtn.enabled = YES;
    }else if (model.order_status == -1){
        [cancelBtn setTitle:LocalizationKey(@"cancel2") forState:UIControlStateNormal];
        [cancelBtn setBackgroundColor:self.backgroundColor];
        [cancelBtn theme_setTitleColor:THEME_TEXT_COLOR forState:UIControlStateNormal];
        cancelBtn.enabled = NO;
    }else{
        [cancelBtn setTitle:LocalizationKey(@"ccTip9") forState:UIControlStateNormal];
        [cancelBtn setBackgroundColor:self.backgroundColor];
        [cancelBtn theme_setTitleColor:THEME_TEXT_COLOR forState:UIControlStateNormal];
        cancelBtn.enabled = NO;
    }
    
    if([model.price_type_name isEqualToString:LocalizationKey(@"market")]){
        priceNum.text = LocalizationKey(@"market");
    }else{
        priceNum.text = [NSString stringWithFormat:@"%@",model.price]; 
    }
    amount.text = [NSString stringWithFormat:@"%@ (%@)",LocalizationKey(@"578Tip174"),model.from_symbol];
    
    NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString:type.text];
    
    if([model.order_type integerValue] == 0){
        [ma yy_setColor:qutesGreenColor range:[[ma string] rangeOfString:model.order_type_name]];
    }else{
        [ma yy_setColor:qutesRedColor range:[[ma string] rangeOfString:model.order_type_name]];
    }
    type.attributedText = ma;
    
}

//撤销
-(void)cancelClick{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:nil message:LocalizationKey(@"Revocation order") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *bank = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:LocalizationKey(@"determine") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if([HelpManager isBlankString:self->_tradeId]){
            printAlert(LocalizationKey(@"NetWorkErrorTip"), 1);
            return;
        }
        [[ReqestHelpManager share] requestPost:@"/api/cc/cancelCc" andHeaderParam:@{@"cc_id":self->_tradeId} finish:^(NSDictionary *dicForData, ReqestType flag) {
            if(flag == Success){
                if([dicForData[@"code"] intValue] == 1){
                    printAlert(dicForData[@"msg"], 1);
                    !self.cancelBlcok ? :self.cancelBlcok(self);
                }else{
                    printAlert(dicForData[@"msg"], 1);
                }
            }else{
                printAlert(LocalizationKey(@"NetWorkErrorTip"), 1);
            }
        }];
    }];
    [ua addAction:bank];
    [ua addAction:cancel];
    [[self viewController].navigationController presentViewController:ua animated:YES completion:nil];
    
}

@end
