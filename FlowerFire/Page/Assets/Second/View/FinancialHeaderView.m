//
//  FinancialHeaderView.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/22.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "FinancialHeaderView.h"

@interface FinancialHeaderView ()
{
    UILabel *coinName;
    UILabel     *tip1,*tip2,*tip3;
    UILabel     *availableLabel;//可用
    UILabel     *freezeLabel;//冻结
    UILabel     *equivalent; //折合
}
@end

@implementation FinancialHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        coinName = [UILabel new];
        coinName.text = @"USDT";
        coinName.textColor = MainBlueColor;
        coinName.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        coinName.layer.masksToBounds = YES;
        coinName.font = [UIFont boldSystemFontOfSize:25];
        [self addSubview:coinName];
        [coinName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(self.mas_top).offset(20);
        }];
         
        tip1 = [UILabel new];
        tip1.textColor = rgba(94, 109, 133, 1);
        tip1.font =  tFont(14);
        tip1.text = LocalizationKey(@"Available");
        tip1.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        tip1.layer.masksToBounds = YES;
        [self addSubview:tip1];
        [tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(coinName.mas_bottom).offset(20);
        }];
        [tip1 sizeToFit];
        
        tip2 = [UILabel new];
        tip2.textColor = rgba(94, 109, 133, 1);
        tip2.font =  tFont(14);
        tip2.text = LocalizationKey(@"On orders");
        tip2.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        tip2.layer.masksToBounds = YES;
        [self addSubview:tip2];
        [tip2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(tip1.mas_centerY);
            make.left.mas_equalTo(ScreenWidth/5*2);
        }];
        [tip2 sizeToFit];
        
        tip3 = [UILabel new];
        tip3.textColor = rgba(94, 109, 133, 1);
        tip3.font =  tFont(14);
        tip3.text = LocalizationKey(@"Estimated(CNY)");
        tip3.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        tip3.layer.masksToBounds = YES;
        [self addSubview:tip3];
        [tip3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self. mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(tip1.mas_centerY);
        }];
        [tip3 sizeToFit];
        
        availableLabel = [UILabel new];
        availableLabel.text = @"0.00000000";
        availableLabel.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        availableLabel.layer.masksToBounds = YES;
        availableLabel.theme_textColor = THEME_TEXT_COLOR;
        availableLabel.font = tFont(15);
        [self addSubview:availableLabel];
        [availableLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(tip1.mas_left);
            make.top.mas_equalTo(tip1.mas_bottom).offset(5);
            make.width.mas_lessThanOrEqualTo((ScreenWidth - 40)/3);
        }];
        
        freezeLabel = [UILabel new];
        freezeLabel.text = @"0.00000000";
        freezeLabel.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        freezeLabel.layer.masksToBounds = YES;
        freezeLabel.theme_textColor = THEME_TEXT_COLOR;
        freezeLabel.font = tFont(15);
        [self addSubview:freezeLabel];
        [freezeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(tip2.mas_left);
            make.centerY.mas_equalTo(availableLabel.mas_centerY);
            make.width.mas_lessThanOrEqualTo((ScreenWidth - 40)/3);
        }];
        
        equivalent = [UILabel new];
        equivalent.text = @"0.00";
        equivalent.textColor = rgba(101, 126, 156, 1);
        equivalent.font = tFont(13);
        equivalent.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        equivalent.layer.masksToBounds = YES;
        equivalent.textAlignment = NSTextAlignmentRight;
        [self addSubview:equivalent];
        [equivalent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(tip3.mas_right);
            make.centerY.mas_equalTo(availableLabel.mas_centerY);
            make.width.mas_lessThanOrEqualTo((ScreenWidth - 40)/3);
        }];
        
        availableLabel.adjustsFontSizeToFitWidth = YES;
        freezeLabel.adjustsFontSizeToFitWidth = YES;
        equivalent.adjustsFontSizeToFitWidth = YES;
        
        UIView *xian = [UIView new];
        xian.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
        [self addSubview:xian];
        [xian mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 10));
        }];
    }
    return self;
}

-(void)setCellData:(NSDictionary *)dic{
    coinName.text = dic[@"symbol"];
    availableLabel.text = [NSString stringWithFormat:@"%.8f",[dic[@"money"] doubleValue]];
    freezeLabel.text =  [NSString stringWithFormat:@"%.8f",[dic[@"money_forzen"] doubleValue]];
    equivalent.text = [NSString stringWithFormat:@"%.2f",[dic[@"money_cny"] doubleValue]];
    
}


@end
