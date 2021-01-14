//
//  FinancialRecordDetailsCell.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/24.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "FinancialRecordDetailCell.h"

@interface FinancialRecordDetailCell ()
{
    UIView  *_line;
    UILabel *_title;
    UILabel *_type;
    UILabel *_memo;
}
@end

@implementation FinancialRecordDetailCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        _line = [UIView new];
        _line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
        [self addSubview:_line];
        [_line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.height.mas_equalTo(1);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(self.mas_top);
        }];
        
        _title = [UILabel new];
        _title.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        _title.layer.masksToBounds = YES;
        _title.theme_textColor = THEME_GRAY_TEXTCOLOR;
        _title.font = tFont(15);
        [self addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_line.mas_left);
            make.top.mas_equalTo(_line.mas_bottom).offset(10);
        }];
        
        _type = [UILabel new];
        _type.theme_textColor = THEME_TEXT_COLOR;
        _type.font = tFont(15);
        _type.textAlignment = NSTextAlignmentRight;
        _type.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        _type.layer.masksToBounds = YES;
        _type.numberOfLines = 0;
        [self addSubview:_type];
        [_type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_line.mas_right);
            make.top.mas_equalTo(_line.mas_bottom).offset(10);
            make.width.mas_lessThanOrEqualTo(ScreenWidth/3*2);
        }];
        
        _memo = [UILabel new];
        _memo.theme_textColor = THEME_GRAY_TEXTCOLOR;
        _memo.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        _memo.layer.masksToBounds = YES;
        _memo.font = tFont(14);
        [self addSubview:_memo];
        [_memo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_line.mas_right);
            make.top.mas_equalTo(_type.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        }];
    }
    return self;
}

-(void)setCellData:(NSDictionary *)dic{
    _title.text = dic[@"title"];
   
    if([dic[@"title"] isEqualToString:LocalizationKey(@"Date")]){
        _type.text = [HelpManager getTimeStr:dic[@"type"] dataFormat:@"HH:mm:ss MM/dd/yyyy"];
    }else{
        _type.text = dic[@"type"];
    }
    
    if([HelpManager isBlankString:dic[@"memo"]]){
        _memo.text = @"";
        [_type mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_line.mas_right);
            make.centerY.mas_equalTo(_title.mas_centerY);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        }];
    }else{
        _memo.text = dic[@"memo"];
        [_memo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_line.mas_right);
            make.top.mas_equalTo(_type.mas_bottom).offset(10);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        }];
    }
    
}



@end
