//
//  AddressManagerCell.m
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "AddressManagerCell.h"

@interface AddressManagerCell ()
{
    UIView   *_bacView,*_line;
    UILabel  *_name,*_phone,*_address;
    UIButton *_editButton,*_deleteButton;
    
}
@end

@implementation AddressManagerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

-(void)defaultAddressClick:(UIButton *)btn{
    if(btn.isSelected){
        return;
    }
    if([self.delegate respondsToSelector:@selector(defaultAddressClick:indexPath:)]){
        [self.delegate defaultAddressClick:btn indexPath:self.indexPath];
    }
}

-(void)editAddressClick:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(editAddressClick:indexPath:)]){
        [self.delegate editAddressClick:btn indexPath:self.indexPath];
    }
}

-(void)deleteAddressClick:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(deleteAddressClick:indexPath:)]){
        [self.delegate deleteAddressClick:btn indexPath:self.indexPath];
    }
}

- (void)setCellData:(AddressInfoModel *)model{
    _name.text = model.consignee;
    _phone.text = model.mobile;
    _address.text = NSStringFormat(@"%@%@%@%@",model.province_info,model.city_info,model.area_info,model.address);
}

- (void)createUI{
    _bacView = [[UIView alloc] init];
    _bacView.frame = CGRectMake(15,80.5,345,112.5);
    _bacView.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0];
    _bacView.layer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
    _bacView.layer.shadowOffset = CGSizeMake(0,5);
    _bacView.layer.shadowOpacity = 1;
    _bacView.layer.shadowRadius = 9;
    _bacView.layer.cornerRadius = 5;
    [self addSubview:_bacView];
    
    _name = [UILabel new];
    _name.text = @"--";
    _name.textColor = rgba(51, 51, 51, 1);
    _name.font = tFont(13);
    [_bacView addSubview:_name];
    
    _phone = [UILabel new];
    _phone.text = @"--";
    _phone.textColor = rgba(153, 153, 153, 1);
    _phone.font = tFont(13);
    [_bacView addSubview:_phone];
   
    _address = [UILabel new];
    _address.text = @"--";
    _address.textColor = rgba(102, 102, 102, 1);
    _address.font = tFont(12);
    _address.numberOfLines = 0;
    [_bacView addSubview:_address];
    
    _line = [UIView new];
    _line.backgroundColor = rgba(204, 204, 204, 1);
    [_bacView addSubview:_line];
    
    _defultAddressButton = [self createButton:@"默认地址"];
    [_defultAddressButton setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
    [_defultAddressButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
    _defultAddressButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    _editButton = [self createButton:@"编辑"];
    _editButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_editButton setImage:[UIImage imageNamed:@"bianji"] forState:UIControlStateNormal];
    
    _deleteButton = [self createButton:@"删除"];
    _deleteButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _deleteButton.titleEdgeInsets = UIEdgeInsetsZero;
    _deleteButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [_deleteButton setImage:[UIImage imageNamed:@"sanchu"] forState:UIControlStateNormal];
    
    [_defultAddressButton addTarget:self action:@selector(defaultAddressClick:) forControlEvents:UIControlEventTouchUpInside];
    [_editButton addTarget:self action:@selector(editAddressClick:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteButton addTarget:self action:@selector(deleteAddressClick:) forControlEvents:UIControlEventTouchUpInside];
}

-(UIButton *)createButton:(NSString *)titleStr{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:titleStr forState:UIControlStateNormal];
    button.titleLabel.font = tFont(12);
    button.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
    [button setTitleColor:rgba(153, 153, 153, 1) forState:UIControlStateNormal];
    [_bacView addSubview:button];
    return button;
}

- (void)layoutSubview{
    [_bacView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(OverAllLeft_OR_RightSpace-5);
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-5);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bacView.mas_left).offset(11);
        make.top.mas_equalTo(_bacView.mas_top).offset(9.5);
    }];
    
    [_phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_bacView.mas_right).offset(-11);
        make.top.mas_equalTo(_bacView.mas_top).offset(9.5);
    }];
    
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_name.mas_bottom).offset(9);
        make.left.mas_equalTo(_name.mas_left);
        make.right.mas_equalTo(_phone.mas_right);
    }];
    
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_address.mas_bottom).offset(12);
        make.left.right.mas_equalTo(_bacView);
        make.height.mas_equalTo(0.5);
    }];
    
    [_defultAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_bacView.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(_line.mas_bottom).offset(13);
        make.bottom.mas_equalTo(_bacView.mas_bottom).offset(-13);
        make.size.mas_equalTo(CGSizeMake(100, 20));
    }];
    
    [_deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_bacView.mas_right).offset(-11.5);
        make.centerY.mas_equalTo(_deleteButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
    
    [_editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_deleteButton.mas_left).offset(-OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(_line.mas_bottom).offset(13);
        make.centerY.mas_equalTo(_deleteButton.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(80, 20));
    }];
}

@end
