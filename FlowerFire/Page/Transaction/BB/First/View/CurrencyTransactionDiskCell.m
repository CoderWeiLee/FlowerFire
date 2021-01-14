//
//  CurrencyTransactionDiskCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//  盘口cell

#import "CurrencyTransactionDiskCell.h"

@implementation CurrencyTransactionDiskCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
      //  self.backgroundColor = navBarColor;
        self.priceLabel = [UILabel new];
        self.priceLabel.text = @"0.00";
        self.priceLabel.textColor = qutesRedColor;
        self.priceLabel.font = tFont(10);
      //  self.priceLabel.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        self.priceLabel.layer.masksToBounds = YES;
        [self addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(6.6);
            make.left.mas_equalTo(self.mas_left);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-6.6);
            make.width.mas_lessThanOrEqualTo(((ScreenWidth/3) - 20)/2);
        }];
        
        self.amountLabel = [UILabel new];
        self.amountLabel.text = @"0.00";
        self.amountLabel.textColor = rgba(100, 113, 136, 1);
        self.amountLabel.textAlignment = NSTextAlignmentRight;
        self.amountLabel.font = tFont(10);
      //  self.amountLabel.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        self.amountLabel.layer.masksToBounds = YES;
        [self addSubview:self.amountLabel];
        [self.amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.priceLabel);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.width.mas_lessThanOrEqualTo(((ScreenWidth/3) - 20)/2);
            
        }];
        self.amountLabel.adjustsFontSizeToFitWidth = YES;
        self.priceLabel.adjustsFontSizeToFitWidth =  YES;
    }
    return self;
}

-(void)setCellData:(NSDictionary *)dic
             isBuy:(BOOL)isBuy
        priceScale:(int)priceScale
       amountScale:(int)amountScale
{
    double amount = [dic[@"total_surplus"] doubleValue];
   
    if([NSStringFormat(@"%@",dic[@"price"]) isEqualToString:@"--"]){
        self.priceLabel.text = @"--";
        self.amountLabel.text = @"--";
    }else{
        self.priceLabel.text = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[dic[@"price"] doubleValue] withlimit:priceScale]];
        
        if(amount>=1000){
            amount = amount/1000;
            self.amountLabel.text = [NSString stringWithFormat:@"%@k",[ToolUtil stringFromNumber:amount withlimit:amountScale]];
            //self.amountLabel.text = [NSString stringWithFormat:@"%lfk",amount];
        }else{
            self.amountLabel.text = [NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:amount withlimit:amountScale]];
            //self.amountLabel.text = [NSString stringWithFormat:@"%lf",amount];
        }
        
        
        
        if(isBuy){
            self.priceLabel.textColor = qutesGreenColor;
        }else{
            self.priceLabel.textColor = qutesRedColor;
        }
    }
    
    
}

@end
