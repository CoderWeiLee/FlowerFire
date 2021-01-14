//
//  AddDepositAddressCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/8/2.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "ShowWithdrawAddressCell.h"

@interface ShowWithdrawAddressCell ()
{
    UIImageView  *_pic;
    UILabel      *_titleLabel;
    UILabel      *_detailsLabel;
    UILabel      *_tipLabel;
}
@end

@implementation ShowWithdrawAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        UIView *line = [UIView new];
        line.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 10));
        }];
        
        _pic = [UIImageView new];
        _pic.theme_image = @"add_address_item_logo";
        _pic.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_pic];
        [_pic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(line.mas_bottom).offset(20);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.size.mas_equalTo(CGSizeMake(20,20));
        }];
        
        _titleLabel = [UILabel new];
        _titleLabel.theme_textColor = THEME_TEXT_COLOR;
        _titleLabel.font = tFont(15);
        _titleLabel.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        _titleLabel.layer.masksToBounds = YES;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_pic.mas_centerY);
            make.left.mas_equalTo(_pic.mas_right).offset(OverAllLeft_OR_RightSpace);
            make.width.mas_lessThanOrEqualTo(ScreenWidth - OverAllLeft_OR_RightSpace * 4 - 30 - 50);
        }];
        
        _tipLabel = [UILabel new];
        _tipLabel.textColor = MainBlueColor;
        _tipLabel.font = tFont(13);
        _tipLabel.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        _tipLabel.layer.masksToBounds = YES;
        [self addSubview:_tipLabel];
        [_tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_pic.mas_centerY);
            make.left.mas_equalTo(_titleLabel.mas_right).offset(OverAllLeft_OR_RightSpace);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        }];
        
        _detailsLabel = [UILabel new];
        _detailsLabel.textColor = ContractDarkBlueColor;
        _detailsLabel.font = tFont(13);
        _detailsLabel.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        _detailsLabel.layer.masksToBounds = YES;
        _detailsLabel.numberOfLines = 0;
     //   _detailsLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_detailsLabel];
        [_detailsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_titleLabel.mas_bottom).offset(OverAllLeft_OR_RightSpace);
            make.left.mas_equalTo(_titleLabel.mas_left);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
             make.bottom.mas_equalTo(self.mas_bottom).offset(-20);
        }];
        
    }
    return self;
}

- (void)setCellData:(NSDictionary *)dic symbol:(nonnull NSString *)symbol{
    _titleLabel.text = dic[@"info"];
    _detailsLabel.text = dic[@"address"]; 
    _tipLabel.text = [symbol stringByAppendingString:LocalizationKey(@"chain")];
}

@end
