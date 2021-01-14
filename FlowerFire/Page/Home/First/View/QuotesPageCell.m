//
//  QuotesPageCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/1.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "QuotesPageCell.h"

@interface QuotesPageCell ()
{
    UILabel *coinName;//头部的币名
    UILabel *dayAmount ; //24小时交易量
    UILabel *newPrice ; // 价格
    UILabel *qutesPrice; //价格下边的label
    UILabel *quoteChange; //涨跌幅
}
@end

@implementation QuotesPageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
       // self.backgroundColor = navBarColor;
         
        coinName = [UILabel new];
        coinName.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        coinName.layer.masksToBounds = YES;
        coinName.textColor = KBlackColor;
        coinName.text = @"BTC";
        coinName.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:coinName];
        [coinName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(self.mas_top).offset(10);
            
        }];
        
        dayAmount = [UILabel new];
        dayAmount.textColor = [UIColor grayColor];
        dayAmount.text = @"24H量 0000";
        dayAmount.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        dayAmount.layer.masksToBounds = YES;
        dayAmount.font = tFont(14);
        [self addSubview:dayAmount];
        [dayAmount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(coinName.mas_left);
            make.top.mas_equalTo(coinName.mas_bottom).offset(5);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
            make.width.mas_lessThanOrEqualTo((ScreenWidth - 40)/3);
        }];
        
        dayAmount.adjustsFontSizeToFitWidth = YES;
        
        newPrice = [UILabel new];
        newPrice.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        newPrice.layer.masksToBounds = YES;
        newPrice.textColor = KBlackColor;
        newPrice.text = @"0.00";
        newPrice.font = [UIFont boldSystemFontOfSize:15];
        [self addSubview:newPrice];
        [newPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(coinName.mas_centerY).offset(0);
            make.width.mas_lessThanOrEqualTo((ScreenWidth - 40)/3);
        }];
        
        qutesPrice = [UILabel new];
        qutesPrice.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        qutesPrice.layer.masksToBounds = YES;
        qutesPrice.textColor = [UIColor grayColor];
        qutesPrice.text = @"¥ 0.00";
        qutesPrice.font = tFont(14);
        [self addSubview:qutesPrice];
        [qutesPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(dayAmount.mas_centerY).offset(0);
          //  make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
            make.width.mas_lessThanOrEqualTo((ScreenWidth - 40)/3);
        }];
        newPrice.adjustsFontSizeToFitWidth = YES;
        qutesPrice.adjustsFontSizeToFitWidth = YES;
         
        quoteChange = [UILabel new];
        quoteChange.backgroundColor = qutesRedColor;
        quoteChange.layer.masksToBounds = YES;
        quoteChange.textColor = KWhiteColor ;
        quoteChange.text = @"0.00";
        quoteChange.font = tFont(15);
        quoteChange.textAlignment = NSTextAlignmentCenter;
        quoteChange.layer.cornerRadius = 3;
        quoteChange.layer.masksToBounds = YES;
        [self addSubview:quoteChange];
        [quoteChange mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(35);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.width.mas_equalTo(80);
        }];
        
        UIView *xian = [UIView new];
        xian.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
        [self addSubview:xian];
        [xian mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
        }];
    }
    return self;
}

#pragma mark - data
-(void)setCellData:(QuotesTransactionPairModel *)model{
    coinName.attributedText = [self changefondstr:model.from_symbol fondstr:model.to_symbol];
    dayAmount.text = [NSString stringWithFormat:@"24H%@ %.f",LocalizationKey(@"Vol"),[model.deal_amount_24h doubleValue]];
    NSDecimalNumber *close = [NSDecimalNumber decimalNumberWithString:model.New_price];
    newPrice.text = [NSString stringWithFormat:@"%@",[ToolUtil judgeStringForDecimalPlaces:[close stringValue]]];
    if (((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate) {
        NSDecimalNumber *baseUsdRate = ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate;
        //乘法运算
        NSDecimalNumber *result = [close decimalNumberByMultiplyingBy:baseUsdRate];
        NSString *resultStr = [result stringValue];
        if ([resultStr containsString:@"."]) {
            NSArray *arr = [resultStr componentsSeparatedByString:@"."];
            if (arr.count > 1 && [arr[1] length] > 2) {
                resultStr = [NSString stringWithFormat:@"%@.%@",arr[0],[arr[1] substringWithRange:NSMakeRange(0, 2)]];
            }
        }
        qutesPrice.text=[NSString stringWithFormat:@"¥ %@",resultStr];
    }else{
        qutesPrice.text = @"¥ 0.00";
    }
    
    double change = [model.change doubleValue];
    if (change <0) {
        quoteChange.backgroundColor = qutesRedColor;
        quoteChange.text = [NSString stringWithFormat:@"%.2f%%", change];
        
    }else if (change >0) {
        quoteChange.backgroundColor = qutesGreenColor;
        quoteChange.text = [NSString stringWithFormat:@"+%.2f%%", change];
    }else{
        quoteChange.backgroundColor = qutesDefaultColor;
        quoteChange.text = @"0.00%";
    }

}

-(NSMutableAttributedString *)changefondstr:(NSString *)firststr fondstr:(NSString *)fondstr{
    NSMutableAttributedString *Str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@/%@",firststr,fondstr]];
    [Str addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFang SC" size:13] range:NSMakeRange(firststr.length, fondstr.length + 1)];
    [Str addAttribute:NSForegroundColorAttributeName value:rgba(105, 122, 149, 1) range:NSMakeRange(firststr.length, fondstr.length + 1)];
    
    return Str;
    
}
@end
