//
//  SubmitOrderHeaderView.m
//  531Mall
//
//  Created by 王涛 on 2020/5/23.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "SubmitOrderHeaderView.h"

@interface SubmitOrderHeaderView ()
{

    UIImageView    *_bacImageView;
    UILabel        *_titleLabel;
    UIButton       *_backButton;
     
    UIImageView    *_addressImageView,*_goImageView;
    UILabel        *_userNmae,*_address;
}
@property(nonatomic, strong)UIButton *addAddressButton;
@property(nonatomic, strong)UIButton *hasAddressButton;
@end

@implementation SubmitOrderHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

-(void)addAddressButtonClick{
    !self.chooseAddressBlock ? : self.chooseAddressBlock();
}

- (void)createUI{
    _bacImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.height)];
    _bacImageView.image = [UIImage imageNamed:@"bg6"];
    [self addSubview:_bacImageView];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.text = @"确认订单";
    _titleLabel.font = tFont(17);
    _titleLabel.textColor = KWhiteColor;
    [self addSubview:_titleLabel];
     
    
}

- (void)layoutSubview{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(SafeIS_IPHONE_X);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
     
}

- (void)layoutNoAddress{
    self.addAddressButton.hidden = NO;
    self.hasAddressButton.hidden = YES;
}

- (void)layoutHasAddress:(AddressInfoModel *)model{
    self.hasAddressButton.hidden = NO;
    self.addAddressButton.hidden = YES;
    _userNmae.text = model.consignee;
    _address.text = NSStringFormat(@"%@%@%@%@",model.province_info,model.city_info,model.area_info,model.address);
}

-(UIButton *)addAddressButton{
    if(!_addAddressButton){
        _addAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addAddressButton setTitle:@"添加地址 +" forState:UIControlStateNormal];
        [_addAddressButton addTarget:self action:@selector(addAddressButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_addAddressButton.titleLabel setFont:tFont(13)];
        _addAddressButton.hidden = YES;
        [self addSubview:_addAddressButton];
        [self.addAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY).offset(10);
            make.size.mas_equalTo(CGSizeMake(200, 60));
        }];
    }
    return _addAddressButton;
}

-(UIButton *)hasAddressButton{
    if(!_hasAddressButton){
        _hasAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _hasAddressButton.hidden = NO;
        [self addSubview:_hasAddressButton];
        [_hasAddressButton addTarget:self action:@selector(addAddressButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [_hasAddressButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.centerY.mas_equalTo(self.mas_centerY).offset(10);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 60));
        }];
        
        _addressImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dizhi"]];
        [_hasAddressButton addSubview:_addressImageView];
         
        _userNmae = [UILabel new];
        _userNmae.text = @"--";
        _userNmae.textColor = KWhiteColor;
        _userNmae.font = tFont(13);
        [_hasAddressButton addSubview:_userNmae];
        
        _address = [UILabel new];
        _address.text = @"--";
        _address.textColor = KWhiteColor;
        _address.font = tFont(11);
        _address.numberOfLines = 0;
        [_hasAddressButton addSubview:_address];
        
        _goImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"8"]];
        [_hasAddressButton addSubview:_goImageView];
        
        [_addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_hasAddressButton.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(_hasAddressButton.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [_userNmae mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_addressImageView.mas_top).offset(-5.5);
            make.left.mas_equalTo(_addressImageView.mas_right).offset(6);
        }];
        
        [_address mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_userNmae.mas_left);
            make.top.mas_equalTo(_userNmae.mas_bottom).offset(5);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        }];
        
        [_goImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_hasAddressButton.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(_hasAddressButton.mas_centerY);
        }];
    }
    return _hasAddressButton;
}

@end
