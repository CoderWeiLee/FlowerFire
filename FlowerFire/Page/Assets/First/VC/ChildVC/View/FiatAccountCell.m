
//
//  FiatAccountCell.m
//  FlowerFire
//
//  Created by 王涛 on 2020/4/30.
//  Copyright © 2020 Celery. All rights reserved.
//  法币cell

#import "FiatAccountCell.h"

extern BOOL ISHIDDENPRICE;
@interface FiatAccountCell ()
{
    UILabel     *_coinName;
    UIImageView *_coinImage;
    UILabel     *_coinValue,*_coinCNYValue;
    UIView      *_line4;
    UILabel     *_availableNum,*_freezeNum;
    UILabel     *_availableTip,*_freezeTip;
       
}
@end

@implementation FiatAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    self.layer.borderColor = FlowerFireBorderColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 2;
    
    _coinImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"USDT"]];
    [self addSubview:_coinImage];
    
    _coinName = [UILabel new];
    _coinName.theme_textColor = THEME_GRAY_TEXTCOLOR;
    _coinName.font = tFont(15);
    _coinName.text = @"USDT";
    [self addSubview:_coinName];
    
    _coinValue = [UILabel new];
    _coinValue.theme_textColor = THEME_TEXT_COLOR;
    _coinValue.font = [UIFont boldSystemFontOfSize:18];
    _coinValue.text = @"0.000";
    [self addSubview:_coinValue];
    [_coinValue setAdjustsFontSizeToFitWidth:YES];
    
    _coinCNYValue = [UILabel new];
    _coinCNYValue.theme_textColor = THEME_GRAY_TEXTCOLOR;
    _coinCNYValue.font = tFont(14);
    _coinCNYValue.text = @"≈0.00 CNY";
    [self addSubview:_coinCNYValue];
    
    [_coinCNYValue setAdjustsFontSizeToFitWidth:YES];
    
    _line4 = [UIView new];
    _line4.backgroundColor = FlowerFireBorderColor;
    [self addSubview:_line4];
    
    _availableTip = [self createLabel:@"assetsTip4"];
    _freezeTip = [self createLabel:@"assetsTip5"];
    _availableNum = [self createLabel:@"0"];
    _freezeNum = [self createLabel:@"0"];
    
    _availableNum.adjustsFontSizeToFitWidth = YES;
    _freezeNum.adjustsFontSizeToFitWidth = YES;
}

-(UILabel *)createLabel:(NSString *)labelStr{
    UILabel *la = [UILabel new];
    la.font = tFont(14);
    la.theme_textColor = THEME_GRAY_TEXTCOLOR;
    la.text = NSStringFormat(@"%@",LocalizationKey(labelStr));
    [self addSubview:la];
    return la;
}

- (void)layoutSubview{
    _coinImage.frame = CGRectMake(OverAllLeft_OR_RightSpace, 10, 30, 30);
    _coinName.frame = CGRectMake(_coinImage.ly_maxX+10, _coinImage.center.y-10, 100, 20);
     
    _line4.frame = CGRectMake(0, _coinImage.ly_maxY + 10, ScreenWidth - OverAllLeft_OR_RightSpace * 2, 1);
    
    [_coinValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coinImage.mas_left);
        make.top.mas_equalTo(_line4.mas_bottom).offset(20);
        make.width.mas_lessThanOrEqualTo((ScreenWidth - 2 * OverAllLeft_OR_RightSpace)/3*2);
    }];
    
    [_coinCNYValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coinValue.mas_right).offset(2);
        make.bottom.mas_equalTo(_coinValue.mas_bottom).offset(0);
        make.width.mas_lessThanOrEqualTo((ScreenWidth - 2 * OverAllLeft_OR_RightSpace)/3);
    }];
  
    [_availableTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coinValue.mas_left);
        make.top.mas_equalTo(_coinValue.mas_bottom).offset(10);
    }];
    
    [_availableNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_availableTip.mas_right);
        make.centerY.mas_equalTo(_availableTip.mas_centerY);
        make.width.mas_lessThanOrEqualTo((ScreenWidth - 4 * OverAllLeft_OR_RightSpace-60)/2);
    }];
    
    [_freezeTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_centerX).offset(OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(_availableTip.mas_centerY);
    }];
    
    [_freezeNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_freezeTip.mas_right);
        make.centerY.mas_equalTo(_freezeTip.mas_centerY);
        make.width.mas_lessThanOrEqualTo((ScreenWidth - 4 * OverAllLeft_OR_RightSpace-60)/2);
    }];
     
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x += OverAllLeft_OR_RightSpace;
    frame.size.height -= OverAllLeft_OR_RightSpace;
    frame.size.width -= 2 * OverAllLeft_OR_RightSpace;
    [super setFrame:frame];
}
  
-(void)setCellData:(NSDictionary *)dic CoinAccountType:(CoinAccountType)coinAccountType{
    _coinImage.image = [UIImage imageNamed:dic[@"symbol"]];
    _coinName.text = dic[@"symbol"];
    _coinValue.text = ISHIDDENPRICE ? @"*****" : [NSString stringWithFormat:@"%.8f",[dic[@"money"] doubleValue]];
    _coinCNYValue.text = ISHIDDENPRICE ? @"***** CNY" : [NSString stringWithFormat:@"≈%.8f CNY",[dic[@"money_cny"] doubleValue]];
    _freezeNum.text =  ISHIDDENPRICE ? @"*****" : [NSString stringWithFormat:@"%.8f",[dic[@"money_forzen"] doubleValue]];
    _availableNum.text = _coinValue.text;
}

@end
