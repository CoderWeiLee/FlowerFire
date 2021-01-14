//
//  KLineTradeHeaderView.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/6.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "KLineTradeHeaderView.h"

@implementation KLineTradeHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        
        UIView *line = [UIView new];
        line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
        }];
        
        self.timeLabel = [UILabel new];
        self.timeLabel.text = LocalizationKey(@"Date");
        self.timeLabel.textColor = rgba(57, 75, 83, 1);
        self.timeLabel.font = tFont(13);
        self.timeLabel.layer.masksToBounds = YES;
        self.timeLabel.backgroundColor = self.backgroundColor;
        [self addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY).offset(0.5);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.width.mas_equalTo((ScreenWidth-30)/4);
        }];
        
        self.directionLabel = [UILabel new];
        self.directionLabel.text = LocalizationKey(@"direction");
        self.directionLabel.textColor = rgba(57, 75, 83, 1);
        self.directionLabel.font = tFont(13);
        self.directionLabel.layer.masksToBounds = YES;
        self.directionLabel.backgroundColor = self.backgroundColor;
        [self addSubview:self.directionLabel];
        [self.directionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY).offset(0.5);
            make.left.mas_equalTo(self.timeLabel.mas_right).offset(0);
            make.width.mas_equalTo((ScreenWidth-30)/4);
        }];
        
        self.amountLabel = [UILabel new];
        self.amountLabel.text = NSStringFormat(@"%@(ETC)",LocalizationKey(@"Amount"));
        self.amountLabel.textColor = rgba(57, 75, 83, 1);
        self.amountLabel.font = tFont(13);
        self.amountLabel.layer.masksToBounds = YES;
        self.amountLabel.backgroundColor = self.backgroundColor;
        self.amountLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.amountLabel];
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY).offset(0.5);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.width.mas_equalTo((ScreenWidth-30)/4);
        }];
        
        self.priceLabel = [UILabel new];
        self.priceLabel.text = NSStringFormat(@"%@(BTC)",LocalizationKey(@"Price"));
        self.priceLabel.textColor = rgba(57, 75, 83, 1);
        self.priceLabel.font = tFont(13);
        self.priceLabel.layer.masksToBounds = YES;
        self.priceLabel.backgroundColor = self.backgroundColor;;
        [self addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY).offset(0.5);
            make.right.mas_equalTo(self.amountLabel.mas_left);
              make.width.mas_equalTo((ScreenWidth-30)/4);
        }];
        
    }
    return self;
}

-(void)setPriceStr:(NSString *)priceStr amountStr:(NSString *)amountStr{
    self.priceLabel.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"Price"),priceStr];
    self.amountLabel.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"Amount"),amountStr];
}

-(void)setTradeHeaderLabelStr{
//    self.priceLabel.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"Price"),@"USD"];
//    self.amountLabel.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"Amount"),[UniversalViewMethod getContractSetting]];
}

-(void)setSecuritiesTradHeaderLabelStr:(NSString *)stockCode{
    self.priceLabel.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"Price"),@"USD"];
    self.amountLabel.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"Amount"),stockCode];
}

@end
