//
//  EditAddressCell.m
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "EditAddressCell.h"

@interface EditAddressCell ()
{
    UIView      *_whiteBac;
    UILabel     *_leftLabel;
    UIView      *_line;

}
@end

@implementation EditAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _whiteBac = [UIView new];
    _whiteBac.backgroundColor = KWhiteColor;
    [self addSubview:_whiteBac];
    
    _textField = [UITextField new];
    _textField.backgroundColor = KWhiteColor;
    _textField.font = tFont(13);
    [self addSubview:_textField];
    
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    _leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 70, 30)];
    _leftLabel.textColor = rgba(51, 51, 51, 1);
    _leftLabel.font = tFont(13);
    [leftView addSubview:_leftLabel];
    _textField.leftView = leftView;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    
    _line = [UIView new];
    _line.backgroundColor = rgba(204, 204, 204, 1);
    [self addSubview:_line];
    
}

- (void)layoutSubview{
    [_whiteBac mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);

    }];
    
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_whiteBac.mas_left).offset(10);
        make.right.mas_equalTo(_whiteBac.mas_right).offset(-10);
        make.height.mas_equalTo(30);
        make.top.mas_equalTo(_whiteBac.mas_top).offset(10);
        
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_textField.mas_bottom).offset(5);
        make.left.mas_equalTo(_textField.mas_left);
        make.height.mas_equalTo(0.5);
        make.right.mas_equalTo(_whiteBac.mas_right).offset(-10);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-1);
    }];
    
}

- (void)setCellData:(NSDictionary *)dic{
    _textField.placeholder = dic[@"placeholder"];
    _textField.text = dic[@"details"];
    _leftLabel.text = dic[@"title"];
    
    if([dic[@"keyBoardType"] isEqualToString:@"phone"]){
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }else{
        _textField.keyboardType = UIKeyboardTypeDefault;
    }
    
    if([dic[@"hiddenLine"] integerValue] == 1){
        _line.hidden = YES;
        [_line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_textField.mas_bottom).offset(10);
        }];
    }else{
        _line.hidden = NO;
        [_line mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_textField.mas_bottom).offset(5);
        }];
    }
    
    if([dic[@"disable"] integerValue] == 1){
        _textField.userInteractionEnabled = NO;
    }else{
        _textField.userInteractionEnabled = YES;
    }
}

@end
