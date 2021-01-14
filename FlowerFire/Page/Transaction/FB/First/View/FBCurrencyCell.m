//
//  FBCurrencyCell.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/8.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "FBCurrencyCell.h"

@interface FBCurrencyCell ()
{
    UIImageView *_userPhoto;
    UILabel     *_userName;
    UIView      *_line;
    UILabel     *_priceNum;
    UILabel     *_amountNum,*_limitNum;
    NSMutableArray<UIImageView *> *imageArray;
    UIButton    *_buyButton;
}
@end

@implementation FBCurrencyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    self.theme_backgroundColor = THEME_MAIN_BACKGROUNDCOLOR;
    
    _userPhoto = [[UIImageView alloc] initWithImage:[UIImage imageWithColor:MainColor]];
    _userPhoto.layer.cornerRadius = 15;
    _userPhoto.layer.masksToBounds = YES;
    [self addSubview:_userPhoto];
    
    _userName = [UILabel new];
    _userName.theme_textColor = THEME_TEXT_COLOR;
    _userName.text = @"xx";
    _userName.font = tFont(16);
    [self addSubview:_userName];
    
    _line = [UIView new];
    _line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [self addSubview:_line];
    
    _priceNum = [UILabel new];
    _priceNum.textColor = MainColor;
    _priceNum.font = [UIFont boldSystemFontOfSize:20];
    _priceNum.text = @"0.0CNY";
    [self addSubview:_priceNum];
    
    _amountNum = [self creatLabel:@"FBTip6" unit:@"USDT"];
    _limitNum = [self creatLabel:@"FBTip7" unit:@"CNY"];
    
     imageArray = [NSMutableArray array];
     for (int i = 0; i<3; i++) {
         UIImageView *payMenthodImg = [[UIImageView alloc] init];
         payMenthodImg.hidden = NO;
         [self addSubview:payMenthodImg];
         [imageArray addObject:payMenthodImg];
     }
     
    _buyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _buyButton.titleLabel.font = tFont(15);
    _buyButton.layer.cornerRadius = 5;
    _buyButton.backgroundColor = MainColor;
    [_buyButton setTitle:LocalizationKey(@"FBTip1") forState:UIControlStateNormal];
    _buyButton.enabled = NO;
    [self addSubview:_buyButton];
}

- (void)layoutSubview{
    _userPhoto.frame = CGRectMake(OverAllLeft_OR_RightSpace, 10, 30, 30);
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_userPhoto.mas_right).offset(10);
        make.centerY.mas_equalTo(_userPhoto.mas_centerY);
    }];
    
    _line.frame = CGRectMake(_userPhoto.ly_x, _userPhoto.ly_maxY + 10, ScreenWidth - 4*OverAllLeft_OR_RightSpace, 1);
    
    _priceNum.frame = CGRectMake(_userPhoto.ly_x, _line.ly_maxY + 15, ScreenWidth - 6*OverAllLeft_OR_RightSpace, 20);
    _amountNum.frame = CGRectMake(_userPhoto.ly_x, _priceNum.ly_maxY + 10, ScreenWidth - 6*OverAllLeft_OR_RightSpace, 20);
    _limitNum.frame = CGRectMake(_userPhoto.ly_x, _amountNum.ly_maxY + 10, ScreenWidth - 6*OverAllLeft_OR_RightSpace, 20);
     
    
    
    [imageArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:20 leadSpacing:ScreenWidth - 4 *OverAllLeft_OR_RightSpace - 20 * 3 - 2.5 * 2 tailSpacing:OverAllLeft_OR_RightSpace];
    [imageArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_priceNum.mas_centerY).offset(0);
        make.height.equalTo(@20);
        
    }];
    
    [_buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(65, 35));
    }];
}

- (void)setCellData:(LegalCurrencyModel *)model coinName:(nonnull NSString *)coinName buyOrSeal:(NSString *)buyOrSeal{
    if ([buyOrSeal isEqualToString:@"0"]) {
        [_buyButton setTitle:LocalizationKey(@"FBTip2") forState:UIControlStateNormal];
        _buyButton.backgroundColor = qutesGreenColor;
       // isSeal = YES;
    }else{
        [_buyButton setTitle:LocalizationKey(@"FBTip1") forState:UIControlStateNormal];
         _buyButton.backgroundColor = MainColor;
      //  isSeal = NO;
    }
 
//    NSInteger verifyLevel = [model.verify_level integerValue];
//    //TODO: 暂时取消判定
//    if([[UniversalViewMethod sharedUniverMthod] getKycLevel] < verifyLevel){
//        if(verifyLevel == 2){
//            [self.buyBtn setTitle:LocalizationKey(@"委托方已设限") forState:UIControlStateNormal];
//            [self.buyBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
//        }
//
//    }
    
    _priceNum.text = [NSString stringWithFormat:@"%@ CNY",model.price];
    _userName.text = model.ower.nickname;
    _amountNum.text   = [NSString stringWithFormat:@"%@ %@ %@",LocalizationKey(@"Amount"),model.surplus,coinName];
    
    if([model.limit_min doubleValue] == 0 && [model.limit_max doubleValue] == 0){
       _limitNum.text = LocalizationKey(@"FiatLimit1");
    }else{
        _limitNum.text = [NSString stringWithFormat:@"%@ ¥ %@ - ¥ %@ ",LocalizationKey(@"FBTip7"),model.limit_min,model.limit_max] ;
    }
    
    NSArray<payMethodModel *> *payMenthodArray = model.pay_list;
    for (int i = 0; i<imageArray.count; i++) {
        imageArray[i].hidden = YES;
    }
    
    if(payMenthodArray.count <= imageArray.count){
        for (int i = 0 ; i<payMenthodArray.count; i++) {
            imageArray[i].hidden = NO;
            if([payMenthodArray[i].type_id isEqualToString:@"1"]){
                imageArray[i].image = [UIImage imageNamed:@"mycenter_4"];
            }else if ([payMenthodArray[i].type_id isEqualToString:@"2"]){
                imageArray[i].image = [UIImage imageNamed:@"mycenter_5"];
            }else{
                imageArray[i].image = [UIImage imageNamed:@"mycenter_7"];
            }
        }
    }else{
        for (int i = 0 ; i<3; i++) {
            imageArray[i].hidden = NO;
            if([payMenthodArray[i].type_id isEqualToString:@"1"]){
                imageArray[i].image = [UIImage imageNamed:@"mycenter_4"];
            }else if ([payMenthodArray[i].type_id isEqualToString:@"2"]){
                imageArray[i].image = [UIImage imageNamed:@"mycenter_5"];
            }else{
                imageArray[i].image = [UIImage imageNamed:@"mycenter_7"];
            }
        }
    }
   
}

-(UILabel *)creatLabel:(NSString *)tip unit:(NSString *)Unit{
    UILabel *la = [UILabel new];
    la.theme_textColor = THEME_GRAY_TEXTCOLOR;
    la.font = tFont(13);
    la.text = NSStringFormat(@"%@--%@",LocalizationKey(tip),Unit);
    [self addSubview:la];
    return la;
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x += OverAllLeft_OR_RightSpace;
    frame.origin.y += 10;
    frame.size.height -= OverAllLeft_OR_RightSpace;
    frame.size.width -= 2 * OverAllLeft_OR_RightSpace;
    [super setFrame:frame];
}

@end
