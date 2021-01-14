//
//  WalletDetailsListCell.m
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WalletDetailsListCell.h"

@interface WalletDetailsListCell ()
{
    UILabel *_typeLabel,*_timeLabel,*_priceLabel,*_walletTypeLabel;
    UIView  *_line;
}
@end

@implementation WalletDetailsListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _typeLabel = [UILabel new];
    _typeLabel.text = @"--";
    _typeLabel.textColor = rgba(51, 51, 51, 1);
    _typeLabel.font = tFont(15);
    [self addSubview:_typeLabel];
    
    _timeLabel = [UILabel new];
    _timeLabel.text = @"--";
    _timeLabel.textColor = rgba(153, 153, 153, 1);
    _timeLabel.font = tFont(12);
    [self addSubview:_timeLabel];
    
    _priceLabel = [UILabel new];
    _priceLabel.text = @"--";
    _priceLabel.textColor = MainColor; //rgba(255, 221, 148, 1)
    _priceLabel.font = tFont(20);
    [self addSubview:_priceLabel];
    
    _walletTypeLabel = [UILabel new];
    _walletTypeLabel.text = @"--";
    _walletTypeLabel.textColor = rgba(153, 153, 153, 1);
    _walletTypeLabel.font = tFont(12);
    [self addSubview:_walletTypeLabel];
    
    _line = [UIView new];
    _line.backgroundColor = rgba(204, 204, 204, 1);
    [self addSubview:_line];
}

- (void)layoutSubview{
    [_typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(10);
        make.left.mas_equalTo(self.mas_left).offset(18.5);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_typeLabel.mas_bottom).offset(8.5);
        make.left.mas_equalTo(_typeLabel.mas_left);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-18.5);
        make.top.mas_equalTo(self.mas_top).offset(9.5);
    }];
    
    [_walletTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_timeLabel.mas_bottom);
        make.right.mas_equalTo(self.mas_right).offset(-18.5);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_timeLabel.mas_bottom).offset(8.5);
        make.left.mas_equalTo(self.mas_left).offset(14);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-1);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth -14 * 2, 0.5));
    }];
}

- (void)setCellData:(WalletDetailsListModel *)model{
    _typeLabel.text = model.type;
    _timeLabel.text = model.time;
    if([model.money doubleValue]>0){
        _priceLabel.text = NSStringFormat(@"+%@",model.money);
        _priceLabel.textColor = MainColor;
    }else{
        _priceLabel.text = NSStringFormat(@"%@",model.money);
        _priceLabel.textColor = rgba(255, 221, 148, 1);
    }
    
    _walletTypeLabel.text = model.bankname;
}

@end
