//
//  LevelUpMemberCellTwo.m
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "LevelUpMemberCellTwo.h"

@interface LevelUpMemberCellTwo ()
{
    UILabel *_title;
    UILabel *_shopName,*_shopNum;
}
@end

@implementation LevelUpMemberCellTwo

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _title = [self createLabel];
    _title.text = @"包含产品:";
    
    _shopName = [self createLabel];
    _shopNum = [self createLabel];
    _shopNum.textAlignment = NSTextAlignmentRight;
}

- (void)layoutSubview{
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [_shopName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_title.mas_centerY);
        make.left.mas_equalTo(_title.mas_right).offset(2); 
    }];
    
    [_shopNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_title.mas_centerY);
        make.left.mas_equalTo(_shopName.mas_right).offset(10);
    }];
}

-(UILabel *)createLabel{
    UILabel *la = [UILabel new];
    la.textColor = rgba(51, 51, 51, 1);
    la.font = tFont(13);
    [self addSubview:la];
    return la;
}

- (void)setCellData:(DeclarationProductsGoodsModel *)model{
    if(model.isShowLeftText){
        _title.hidden = NO;
    }else{
        _title.hidden = YES;
    }
    _shopName.text = model.good_name;
    _shopNum.text = model.amount;
}

@end
