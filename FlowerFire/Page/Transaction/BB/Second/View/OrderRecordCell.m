//
//  OrderRecordCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/30.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "OrderRecordCell.h"

@interface OrderRecordCell ()
{
    UILabel *orderStatus; //订单状态:-1=取消,0=待付款,1=已付款,待放币,2=交易成功
    UILabel *coinName; //币名字
    UILabel *pleasePay ; //请付款  已取消等等
    UILabel *timeTip,*amountTip,*totalPriceTip;
    UILabel *time,*amountNum,*totalPriceNum;
    UILabel *merchantName; //j商家昵称
}
@end

@implementation OrderRecordCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if(self){
        self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
      
        orderStatus = [UILabel new];
        orderStatus.textColor = MainColor;
        orderStatus.font = [UIFont boldSystemFontOfSize:20];
        orderStatus.text = @"购买";
        [self addSubview:orderStatus];
        [orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(self.mas_top).offset(20);
        }];
    
        coinName  = [UILabel new];
        coinName.textColor = rgba(89, 112, 142, 1);
        coinName.text = @"BTC";
        coinName.font = [UIFont boldSystemFontOfSize:20];
        [self addSubview:coinName];
        [coinName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(orderStatus.mas_right);
            make.centerY.mas_equalTo(orderStatus.mas_centerY);
        }];
        
        UIImageView *goImage = [[UIImageView alloc] init];
        goImage.theme_image = @"history_order_right_arrow";
        [self addSubview:goImage];
        [goImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(coinName.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(12, 17));
        }];
        
        pleasePay = [UILabel new];
        pleasePay.textColor = rgba(89, 112, 142, 1);
        pleasePay.text = @"请付款";
        pleasePay.font = tFont(18);
        [self addSubview:pleasePay];
        [pleasePay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(goImage.mas_left).offset(-5);
            make.centerY.mas_equalTo(orderStatus.mas_centerY);
        }];
        
        timeTip = [UILabel new];
        timeTip.textColor = rgba(63, 86, 128, 1);
        timeTip.text = LocalizationKey(@"Date");
        timeTip.font = tFont(14);
        [self addSubview:timeTip];
        [timeTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(orderStatus.mas_bottom).offset(25);
        }];
        
        amountTip = [UILabel new];
        amountTip.textColor = rgba(63, 86, 128, 1);
        amountTip.text = @"数量（BTC）";
        amountTip.font = tFont(14);
        [self addSubview:amountTip];
        [amountTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
            make.centerY.mas_equalTo(timeTip.mas_centerY).offset(0);
        }];
        
        totalPriceTip = [UILabel new];
        totalPriceTip.textColor = rgba(63, 86, 128, 1);
        totalPriceTip.text = NSStringFormat(@"%@(CNY)",LocalizationKey(@"Payment total"));
        totalPriceTip.font = tFont(14);
        [self addSubview:totalPriceTip];
        [totalPriceTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(timeTip.mas_centerY).offset(0);
        }];
        
        CGFloat viewWidth = (ScreenWidth - OverAllLeft_OR_RightSpace * 2 )/3;
        
        time =  [UILabel new];
        time.textColor = rgba(138, 150, 172, 1);
        time.text = @"14:25 05/08";
        time.font = tFont(18);
        [self addSubview:time];
        [time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(timeTip.mas_bottom).offset(10);
            make.width.mas_lessThanOrEqualTo(viewWidth);
        }];
        time.adjustsFontSizeToFitWidth = YES;
        
        amountNum =  [UILabel new];
        amountNum.textColor = rgba(138, 150, 172, 1);
        amountNum.text = @"0.002356";
        amountNum.font = tFont(18);
        [self addSubview:amountNum];
        [amountNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX).offset(0);
            make.top.mas_equalTo(timeTip.mas_bottom).offset(10);
            make.width.mas_lessThanOrEqualTo(viewWidth);
        }];
        amountNum.adjustsFontSizeToFitWidth = YES;
        
        totalPriceNum =  [UILabel new];
        totalPriceNum.textColor = rgba(138, 150, 172, 1);
        totalPriceNum.text = @"1000.00";
        totalPriceNum.font = tFont(18);
        [self addSubview:totalPriceNum];
        [totalPriceNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(timeTip.mas_bottom).offset(10);
            make.width.mas_lessThanOrEqualTo(viewWidth);
        }];
        
        totalPriceNum.adjustsFontSizeToFitWidth = YES;
        
        merchantName =  [UILabel new];
        merchantName.theme_textColor = THEME_TEXT_COLOR;
        merchantName.text = @"我是商家昵称";
        merchantName.font = tFont(16);
        [self addSubview:merchantName];
        [merchantName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(time.mas_bottom).offset(15);
        }];
        
        UIView *xian = [UIView new];
        xian.theme_backgroundColor = THEME_LINE_INPUT_SEPARATORCOLOR;
        [self addSubview:xian];
        [xian mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
        }];
    }
    return self;
}

//订单状态:-1=取消,0=待付款,1=已付款,待放币,2=交易成功-2申诉
-(void)setCellData:(OrderRecordModel *)model{
    if([model.order_status isEqualToString:@"-1"]){
        pleasePay.text = LocalizationKey(@"OrderTip3");
    }else if ([model.order_status isEqualToString:@"0"]){
        pleasePay.text = LocalizationKey(@"OrderTip1");
    }else if ([model.order_status isEqualToString:@"1"]){
        if(model.is_timeout == 1){
            pleasePay.text = LocalizationKey(@"FiatOrderTip22");
        }else{
            pleasePay.text = LocalizationKey(@"OrderTip5");
        }

    }else if ([model.order_status isEqualToString:@"2"]){
        pleasePay.text = LocalizationKey(@"OrderTip6");
    }else if ([model.order_status isEqualToString:@"-2"]){
        pleasePay.text = LocalizationKey(@"OrderTip4");
    }
    
    if([model.order_type isEqualToString:@"0"]){
        orderStatus.text = LocalizationKey(@"FiatBuy");
    }else{
        orderStatus.text = LocalizationKey(@"FiatSell");
    }
    
    coinName.text = model.symbol;
    amountTip.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"Amount"),model.symbol];
    merchantName.text = model.ower.nickname;
    amountNum.text = model.amount;
    totalPriceNum.text = model.total_price;
    
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    = [model.addtime doubleValue] ;// / 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm MM/dd"];
    time.text      = [formatter stringFromDate: date];
}

@end
