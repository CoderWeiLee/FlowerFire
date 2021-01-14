//
//  MyOrderPageCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/6.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "MyOrderPageCell.h"

@interface MyOrderPageCell ()
{
    UILabel  *type;
    UILabel  *time;
    UILabel  *status;
    UILabel  *priceTip,*amountTip,*trueTotalPriceTip;
    UILabel  *priceNum,*amountNum,*totalPriceNum;
    UIButton *cancelBtn;
}
@end

@implementation MyOrderPageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
      //  self.backgroundColor = navBarColor;
        [self setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
        type = [UILabel new];
        type.text = @"--";
        type.textColor = qutesGreenColor;
        type.font = tFont(16);
        type.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        type.layer.masksToBounds = YES;
        [self addSubview:type];
        [type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(15);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        }];
        
        time = [UILabel new];
        time.text = @"--";
        time.textColor = rgba(105, 129, 173, 1);
        time.font = tFont(13);
        time.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        time.layer.masksToBounds = YES;
        [self addSubview:time];
        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(type.mas_bottom).offset(0);
            make.left.mas_equalTo(type.mas_right).offset(10);
        }];
        
        status = [UILabel new];
        status.text = @"--";
        status.textColor = KWhiteColor;
        status.font = tFont(16);
        status.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        status.layer.masksToBounds = YES;
        [self addSubview:status];
        [status mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(type.mas_centerY).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        }];
        
        cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setTitle:LocalizationKey(@"cancel1") forState:UIControlStateNormal];
        [cancelBtn setTitleColor:qutesRedColor forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelBtn];
        cancelBtn.titleLabel.font = tFont( 15);
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(status.mas_left).offset(-15);
            make.centerY.mas_equalTo(status);
        }];
        [cancelBtn sizeToFit];
        
        priceTip = [UILabel new];
        priceTip.text = NSStringFormat(@"%@(USDT)",LocalizationKey(@"Price"));
        priceTip.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        priceTip.layer.masksToBounds = YES;
        priceTip.textColor = rgba(56, 77, 118, 1);
        priceTip.font = tFont(14);
        [self addSubview:priceTip];
        [priceTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(type.mas_bottom).offset(20);
            make.left.mas_equalTo(type.mas_left).offset(0);
        }];
        
        amountTip = [UILabel new];
        amountTip.text = NSStringFormat(@"%@(BTC)",LocalizationKey(@"Amount"));
        amountTip.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        amountTip.layer.masksToBounds = YES;
        amountTip.textColor = rgba(56, 77, 118, 1);
        amountTip.font = tFont(14);
        [self addSubview:amountTip];
        [amountTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(priceTip.mas_centerY).offset(0);
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        }];
        
        trueTotalPriceTip = [UILabel new];
        trueTotalPriceTip.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        trueTotalPriceTip.layer.masksToBounds = YES;
        trueTotalPriceTip.text = NSStringFormat(@"%@(BTC)",LocalizationKey(@"Actual transaction"));
        trueTotalPriceTip.textColor = rgba(56, 77, 118, 1);
        trueTotalPriceTip.font = tFont(14);
        [self addSubview:trueTotalPriceTip];
        [trueTotalPriceTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(priceTip.mas_centerY).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        }];
        
        priceNum = [UILabel new];
        priceNum.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        priceNum.layer.masksToBounds = YES;
        priceNum.text = @"00000";
        priceNum.textColor = rgba(132, 146, 168, 1);
        priceNum.font = tFont(14);
        [self addSubview:priceNum];
        [priceNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(priceTip.mas_bottom).offset(10);
            make.left.mas_equalTo(type.mas_left).offset(0);
        }];
        
        amountNum = [UILabel new];
        amountNum.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        amountNum.layer.masksToBounds = YES;
        amountNum.text = @"00000";
        amountNum.textColor = rgba(132, 146, 168, 1);
        amountNum.font = tFont(14);
        [self addSubview:amountNum];
        [amountNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(priceNum.mas_centerY).offset(0);
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
        }];
        
        totalPriceNum = [UILabel new];
        totalPriceNum.text = @"00000";
        totalPriceNum.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        totalPriceNum.layer.masksToBounds = YES;
        totalPriceNum.textColor = rgba(132, 146, 168, 1);
        totalPriceNum.font = tFont(14);
        [self addSubview:totalPriceNum];
        [totalPriceNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(priceNum.mas_centerY).offset(0);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        }];
        
        UIView *line = [UIView new];
        line.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
        [self addSubview:line];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(priceNum.mas_bottom).offset(25);
            make.bottom.mas_equalTo(self.mas_bottom).offset(0);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 5));
        }];
    }
    return self;
}

-(void)cancelClick:(UIButton *)btn{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:nil message:LocalizationKey(@"Revocation order") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *bank = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:LocalizationKey(@"determine") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if([self.delegate respondsToSelector:@selector(cancelOrder:cell:)]){
            [self.delegate cancelOrder:btn cell:self];
        }
    }];
     [ua addAction:bank];
     [ua addAction:cancel];
     [[self viewController].navigationController presentViewController:ua animated:YES completion:nil];
    
}

//TODO: cell
-(void)setCellData:(LegalCurrencyModel *)model type:(MyOrderPageWhereJump)MyOrderPageWhereJump{
    if(MyOrderPageWhereJump == MyOrderPageWhereJumpBB){
        priceNum.text = model.price;
        amountNum.text = model.amount;
        time.text = [HelpManager getTimeStr:model.addtime dataFormat:@"yyyy-MM-dd HH:mm:ss"];
        type.text = [self getOrderType:model.order_type];
        status.text = [self getOrderStatus:model.order_status];
    }else{
        priceNum.text = model.price;
        priceTip.text = NSStringFormat(@"%@(CNY)",LocalizationKey(@"Price"));
        amountNum.text = model.amount;
        amountTip.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"Amount"),model.symbol];
        trueTotalPriceTip.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"Actual transaction"),model.symbol];
        
        time.text = [HelpManager getTimeStr:model.addtime dataFormat:@"yyyy-MM-dd HH:mm:ss"];
        type.text = [self getOrderType:model.order_type];
        status.text = [self getOrderStatus:model.order_status];
        totalPriceNum.text = model.trade_amount;
    }
    
    
}
//订单状态:all=全部,-1=已撤销,0=挂售中,1=已完成
-(NSString *)getOrderStatus:(NSString *)orderStatus{
    if([orderStatus isEqualToString:@"1"]){
        status.theme_textColor = THEME_TEXT_COLOR;
        cancelBtn.hidden = YES;
        return LocalizationKey(@"ccTip9");
    }else if ([orderStatus isEqualToString:@"-1"]){
        status.theme_textColor = THEME_TEXT_COLOR;
        cancelBtn.hidden = YES;
        return LocalizationKey(@"cancel2");
    }else{
        status.textColor = rgba(32, 127, 202, 1);
        cancelBtn.hidden = NO;
        return LocalizationKey(@"Hanging up");
    }
}

-(NSString *)getOrderType:(NSString *)orderType{
    if([orderType isEqualToString:@"0"]){
        type.textColor = qutesGreenColor;
        return LocalizationKey(@"Buy");
    }else{
        type.textColor = qutesRedColor;
        return LocalizationKey(@"Sell");
    }
}



@end
