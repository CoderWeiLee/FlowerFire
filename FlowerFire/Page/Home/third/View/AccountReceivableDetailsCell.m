//
//  AccountReceivableDetailsCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/7/13.
//  Copyright © 2019 王涛. All rights reserved.
//  收款账户详情cell

#import "AccountReceivableDetailsCell.h"

@interface AccountReceivableDetailsCell ()
{
    UILabel *_leftLabel;
    UILabel *_rightLabel;
}
@end

@implementation AccountReceivableDetailsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if(self){
        self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        _leftLabel = [self createLabel];
        _rightLabel = [self createLabel];
        
        [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(ScreenWidth/3);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        
        UIView *line = [UIView new];
        line.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
        }];
    }
    return self;
}

#pragma mark - dataSource
- (void)setCellData:(NSDictionary *)dic{
    _leftLabel.text = dic[@"title"];
    _rightLabel.text = dic[@"details"];
}

#pragma mark - privateMethod
-(UILabel *)createLabel{
    UILabel *la = [UILabel new];
    la.text = @"--";
    la.theme_textColor = THEME_TEXT_COLOR;
    la.font = tFont(15);
    la.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    la.layer.masksToBounds = YES;
    la.adjustsFontSizeToFitWidth = YES;
    [self addSubview:la];
    return la;
}

@end
