//
//  MyStockCell.m
//  531Mall
//
//  Created by 王涛 on 2020/5/21.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "MyStockCell.h"

@interface MyStockCell ()
{
    UILabel *_time,*_type,*_shopName,*_num;
}
@end

@implementation MyStockCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _time = [UILabel new];
    _time.textColor = rgba(102, 102, 102, 1);
    _time.font = tFont(10);
    _time.numberOfLines = 0;
    _time.text = @"0000-00-00\n00:00:00";
    _time.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_time];
    
    _type = [UILabel new];
    _type.textColor = rgba(102, 102, 102, 1);
    _type.font = tFont(13);
    _type.text = @"--";
    _type.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_type];
    
    _shopName = [UILabel new];
    _shopName.textColor = rgba(102, 102, 102, 1);
    _shopName.font = tFont(13);
    _shopName.text = @"--";
    _shopName.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_shopName];
    
    _num = [UILabel new];
    _num.textColor = MainColor;
    _num.font = tFont(13);
    _num.text = @"0";
    _num.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_num];
    

}

- (void)layoutSubview{
    CGFloat labelWidth = ScreenWidth/4;
    
    _time.frame = CGRectMake(0, 0, labelWidth, 50);
    _type.frame = CGRectMake(_time.ly_maxX, 0, labelWidth, 50);
    _shopName.frame = CGRectMake(_type.ly_maxX, 0, labelWidth, 50);
    _num.frame = CGRectMake(_shopName.ly_maxX, 0, labelWidth, 50);
}

- (void)setCellData:(MyStockSkuListModel *)model{
    _time.text = model.created_time;
    _type.text = model.reason;
    _shopName.text = model.name;
    _num.text = model.stock;
    
    if([model.type isEqualToString:@"0"]){
        _num.textColor = rgba(255, 174, 0, 1);
        _num.text = NSStringFormat(@"-%@",_num.text);
    }else{
        _num.textColor = MainColor;
        _num.text = NSStringFormat(@"+%@",_num.text);
    }
}

@end
