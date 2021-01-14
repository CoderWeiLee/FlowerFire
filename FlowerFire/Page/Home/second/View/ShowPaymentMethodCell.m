//
//  ShowPaymentMethodCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/3.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "ShowPaymentMethodCell.h"

@interface ShowPaymentMethodCell ()
{
    UIImageView *paymentImg;
    UILabel     *paymentLabel;
    UILabel     *nickName;
    UILabel     *accountLabel;
    UILabel     *accountAddress;
    UIButton    *activationBtn;
}
@end

@implementation ShowPaymentMethodCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if(self){
    //    self.backgroundColor = navBarColor;
        [self setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
        UIView *line = [[UIView alloc] init];
        line.theme_backgroundColor = THEME_TRANSFER_BACKGROUNDCOLOR;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 10));
        }];
        
        paymentImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mycenter_4"]];
        [self addSubview:paymentImg];
        [paymentImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        }];
        
        paymentLabel = [UILabel new];
        paymentLabel.textColor = rgba(159, 167, 190, 1);
        paymentLabel.text = @"微信";
        paymentLabel.font = tFont(18);
        [self addSubview:paymentLabel];
        [paymentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(paymentImg.mas_right).offset(5);
            make.centerY.mas_equalTo(paymentImg.mas_centerY);
        }];
        
        nickName = [UILabel new];
        nickName.text = @"路人";
        nickName.textColor = rgba(134, 139, 147, 1);
        nickName.font = tFont(16);
        [self addSubview:nickName];
        [nickName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(paymentImg.mas_bottom).offset(10);
            make.left.mas_equalTo(paymentImg.mas_left);
        }];
        
        accountLabel = [UILabel new];
        accountLabel.text = @"00";
        accountLabel.theme_textColor = THEME_TEXT_COLOR;
        accountLabel.font = tFont(18);
        [self addSubview:accountLabel];
        [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nickName.mas_bottom).offset(10);
            make.left.mas_equalTo(paymentImg.mas_left);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-15);
        }];
        
        accountAddress = [UILabel new];
        accountAddress.text = @"开户行";
        accountAddress.textColor = rgba(132, 136, 145, 1);
        accountAddress.font = tFont(17);
        [self addSubview:accountAddress];
        [accountAddress mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(accountLabel.mas_centerY);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            
        }];
        
        activationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [activationBtn setTitle:LocalizationKey(@"ShowPaymentMethodTip1") forState:UIControlStateSelected];
        [activationBtn setTitle:LocalizationKey(@"ShowPaymentMethodTip2") forState:UIControlStateNormal];
        [activationBtn setImage:[UIImage imageNamed:@"mycenter_6"] forState:UIControlStateNormal];
        [activationBtn setImage:[UIImage imageNamed:@"mycenter_6"] forState:UIControlStateSelected];
        [activationBtn setTitleColor:rgba(132, 136, 145, 1) forState:UIControlStateNormal];
        [activationBtn setTitleColor:MainColor forState:UIControlStateSelected];
        activationBtn.titleLabel.font = tFont(18);
        activationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
        [self addSubview:activationBtn];
        [activationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(paymentImg.mas_centerY);
        }];
        [activationBtn sizeToFit];
    }
    return self;
}

-(void)setCellData:(NSDictionary *)dic{
    if([dic[@"type_id"] intValue] == 1){
        paymentImg.image = [UIImage imageNamed:@"mycenter_4"];
        paymentLabel.text = LocalizationKey(@"Bank card");
    }else if ([dic[@"type_id"] intValue] == 2){
        paymentImg.image = [UIImage imageNamed:@"mycenter_5"];
        paymentLabel.text = LocalizationKey(@"Alipay");
    }else{
        paymentImg.image = [UIImage imageNamed:@"mycenter_7"];
        paymentLabel.text = LocalizationKey(@"WChat");
    }
    if([dic[@"status"] intValue] == 1){
        activationBtn.selected = YES;
    }else{
       activationBtn.selected = NO;
    }
    
    nickName.text = dic[@"true_name"];
    accountLabel.text = dic[@"account"];
    accountAddress.text = dic[@"bank_address"];
    
}

@end
