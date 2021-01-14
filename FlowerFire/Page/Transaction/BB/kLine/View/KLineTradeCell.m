//
//  KLineTradeCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/6.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "KLineTradeCell.h"

@implementation KLineTradeCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        
        self.timeLabel = [UILabel new];
        self.timeLabel.theme_textColor = THEME_TEXT_COLOR;
        self.timeLabel.text = @"00:00:00";
        self.timeLabel.font = tFont(13);
        self.timeLabel.layer.masksToBounds = YES;
        self.timeLabel.backgroundColor = self.backgroundColor;
        [self addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          //  make.top.mas_equalTo(self.mas_top).offset(10);
          //  make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.width.mas_equalTo((ScreenWidth-30)/4);
        }];
        
        self.buyType = [UILabel new];
        self.buyType.textColor = qutesGreenColor;
        self.buyType.text = @"--";
        self.buyType.font = tFont(13);
        self.buyType.layer.masksToBounds = YES;
        self.buyType.backgroundColor = self.backgroundColor;
        [self addSubview:self.buyType];
        [self.buyType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
            make.left.mas_equalTo(self.timeLabel.mas_right).offset(0);
            make.width.mas_equalTo((ScreenWidth-30)/4);
        }];
        
        self.amountLabel = [UILabel new];
        self.amountLabel.theme_textColor = THEME_TEXT_COLOR;
        self.amountLabel.text = @"0.0000";
        self.amountLabel.font = tFont(13);
        self.amountLabel.adjustsFontSizeToFitWidth= YES;
        self.amountLabel.layer.masksToBounds = YES;
        self.amountLabel.backgroundColor = self.backgroundColor;
        self.amountLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.amountLabel];
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.width.mas_equalTo((ScreenWidth-30)/4);
        }];
        
        self.priceLabel = [UILabel new];
        self.priceLabel.theme_textColor = THEME_TEXT_COLOR;
        self.priceLabel.text = @"0.000000";
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.adjustsFontSizeToFitWidth = YES;
        self.priceLabel.font = tFont(13);
        self.priceLabel.layer.masksToBounds = YES;
        self.priceLabel.backgroundColor = self.backgroundColor;
        [self addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.timeLabel.mas_centerY);
            make.right.mas_equalTo(self.amountLabel.mas_left).offset(0);
            make.width.mas_equalTo((ScreenWidth-30)/4);
        }];
    }
    return self;
}

-(void)setCellData:(NSDictionary *)dic priceScale:(int)priceScale fromScale:(int)fromScale{
    if ([dic[@"price"] doubleValue] <0) {
        self.buyType.text=@"--";
        self.priceLabel.text=@"--";
        self.amountLabel.text=@"--";
        self.timeLabel.text=@"--";
//        //防止客户说闪
//        self.buyType.text=@"";
//        self.priceLabel.text=@"";
//        self.amountLabel.text=@"";
//        self.timeLabel.text=@"";
    }else{
        if ([dic[@"order_type"] intValue] == 0) {
            self.buyType.text= LocalizationKey(@"Buy");
            self.buyType.textColor= qutesGreenColor;
        }else{
            self.buyType.text= LocalizationKey(@"Sell");
            self.buyType.textColor=qutesRedColor;
        }
        self.timeLabel.text= [HelpManager getTimeStr:dic[@"addtime"] dataFormat:@"HH:mm:ss"];
        self.priceLabel.text=[ToolUtil stringFromNumber:[dic[@"price"] doubleValue] withlimit:priceScale];
        self.amountLabel.text=[ToolUtil stringFromNumber:[dic[@"amount"] doubleValue] withlimit:fromScale];
    }
}

-(void)setCellData:(NSDictionary *)dic{
//    if ([dic[@"price"] doubleValue] <0) {
//        self.buyType.text=@"--";
//        self.priceLabel.text=@"--";
//        self.amountLabel.text=@"--";
//        self.timeLabel.text=@"--";
//    }else{
//        if ([dic[@"order_type"] intValue] == 0) {
//            self.buyType.text= LocalizationKey(@"Buy");
//            self.buyType.textColor= qutesGreenColor;
//        }else{
//            self.buyType.text= LocalizationKey(@"Sell");
//            self.buyType.textColor=qutesRedColor;
//        }
//        self.timeLabel.text= [HelpManager getTimeStr:dic[@"addtime"] dataFormat:@"HH:mm:ss"];
//        self.priceLabel.text= NSStringFormat(@"%@",dic[@"price"]);
//        if([[UniversalViewMethod getContractSetting] isEqualToString:LocalizationKey(@"Cont")]){
//            self.amountLabel.text= NSStringFormat(@"%@",dic[@"cont"]);
//        }else{
//            self.amountLabel.text= NSStringFormat(@"%@",dic[@"amount"]);
//        }
//        
//    }
}

@end
