//
//  LegalCurrencyCell.m
//  FireCoin
//
//  Created by 赵馨 on 2019/5/28.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "LegalCurrencyCell.h"
#import "LegalCurrencyModel.h"
#import "payMethodModel.h"

#define legalTextColor rgba(74, 90, 122, 1);
@interface LegalCurrencyCell ()
{
    UIImageView *photo;
    UILabel     *userName;
    UILabel     *amount;
    UILabel     *limitAmount;//限额
    UILabel     *pieceTip; //单件
    UILabel     *_usdPriceTip;
    UILabel     *pieceNum;
    BOOL         isSeal;
    NSMutableArray<UIImageView *> *imageArray;
}
@end

@implementation LegalCurrencyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if(self){
        self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        
        photo = [[UIImageView alloc] initWithImage:[defaultUserPhoto imageByRoundCornerRadius:30]];
//        photo.layer.cornerRadius = 15;
//        photo.layer.masksToBounds = YES;
        photo.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        [self addSubview:photo];
        [photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.size.mas_equalTo(CGSizeMake(30, 30));
            make.top.mas_equalTo(self.mas_top).offset(20);
        }];
        
        userName = [UILabel new];
        userName.text = @"张三";
        userName.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        userName.layer.masksToBounds = YES;
        userName.theme_textColor = THEME_TEXT_COLOR;
        userName.font = [UIFont systemFontOfSize:18];
        [self addSubview:userName];
        [userName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(photo.mas_right).offset(10);
            make.centerY.mas_equalTo(photo.mas_centerY);
        }];
        
        amount = [UILabel new];
        amount.textColor = legalTextColor;
        amount.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        amount.layer.masksToBounds = YES;
        amount.font = [UIFont systemFontOfSize:14];
        amount.text = LocalizationKey(@"Amount");
        [self addSubview:amount];
        [amount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(photo.mas_bottom).offset(15);
            make.left.mas_equalTo(photo.mas_left);
        }];
        
        limitAmount = [UILabel new];
        limitAmount.textColor = legalTextColor;
        limitAmount.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        limitAmount.layer.masksToBounds = YES;
        limitAmount.numberOfLines = 0;
        limitAmount.font = [UIFont systemFontOfSize:14];
        limitAmount.text = LocalizationKey(@"FiatLimit");
        [self addSubview:limitAmount];
        [limitAmount mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(amount.mas_bottom).offset(5);
            make.left.mas_equalTo(photo.mas_left);
        }];
        
        pieceTip = [UILabel new];
        pieceTip.textColor = legalTextColor;
        pieceTip.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        pieceTip.layer.masksToBounds = YES;
        pieceTip.font = [UIFont systemFontOfSize:14];
        pieceTip.text = LocalizationKey(@"FiatPrice");
        [self addSubview:pieceTip];
        [pieceTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(amount.mas_centerY);
        }];
        
        pieceNum = [UILabel new];
        pieceNum.textColor = rgba(34, 129, 205, 1);
        pieceNum.font = [UIFont boldSystemFontOfSize:20];
        pieceNum.text = @"¥0.00";
        pieceNum.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        pieceNum.layer.masksToBounds = YES;
        [self addSubview:pieceNum];
        [pieceNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(limitAmount.mas_centerY);
        }];
        
        _usdPriceTip = [UILabel new];
        _usdPriceTip.textColor = rgba(34, 129, 205, 1);
        _usdPriceTip.font = [UIFont boldSystemFontOfSize:20];
        _usdPriceTip.text = @"$0.00";
        _usdPriceTip.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        _usdPriceTip.layer.masksToBounds = YES;
        [self addSubview:_usdPriceTip];
        [_usdPriceTip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(limitAmount.mas_bottom).offset(10);
            make.centerX.mas_equalTo(pieceNum.mas_centerX);
        }];
        
        self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.buyBtn setTitle:LocalizationKey(@"FiatBuy") forState:UIControlStateNormal];
        self.buyBtn.layer.cornerRadius = 5;
       // self.buyBtn.layer.masksToBounds = YES;
        self.buyBtn.backgroundColor = rgba(34, 129, 205, 1);
        self.buyBtn.opaque = YES;
        self.buyBtn.titleLabel.layer.masksToBounds = YES;
        self.buyBtn.titleLabel.backgroundColor = self.buyBtn.backgroundColor;
        [self addSubview:self.buyBtn];
        [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.top.mas_equalTo(_usdPriceTip.mas_bottom).offset(15);
            make.size.mas_equalTo(CGSizeMake(110, 35));
        }];
        
        UIView *xian = [UIView new];
        xian.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
        [self addSubview:xian];
        [xian mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        
        self.buyBtn.enabled = NO;
      //  [self.buyBtn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        imageArray = [NSMutableArray array];
        for (int i = 0; i<3; i++) {
            UIImageView *payMenthodImg = [[UIImageView alloc] init];
            payMenthodImg.hidden = YES; 
            [self addSubview:payMenthodImg];
            [imageArray addObject:payMenthodImg];
        }
        
        [imageArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:20 leadSpacing:20 tailSpacing:ScreenWidth - 20 - (20 * imageArray.count) - ((imageArray.count-1) * 10) ];
        [imageArray mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_usdPriceTip.mas_centerY).offset(0);
            make.height.equalTo(@20);
            
        }];
        
    }
    return self;
}

-(void)buyBtnClick:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(btnClick:cell:)]){
        [self.delegate btnClick:btn cell:self];
    }
}

- (void)setCellData:(LegalCurrencyModel *)model coinName:(nonnull NSString *)coinName buyOrSeal:(NSString *)buyOrSeal{
    if ([buyOrSeal isEqualToString:@"0"]) {
        [self.buyBtn setTitle:LocalizationKey(@"Sell") forState:UIControlStateNormal];
        self.buyBtn.backgroundColor = rgba(78, 101, 130, 1);
       // isSeal = YES;
    }else{
        [self.buyBtn setTitle:LocalizationKey(@"FiatBuy") forState:UIControlStateNormal];
         self.buyBtn.backgroundColor = rgba(34, 129, 205, 1);
      //  isSeal = NO;
    }
    self.buyBtn.titleLabel.backgroundColor = self.buyBtn.backgroundColor;
    
//    NSInteger verifyLevel = [model.verify_level integerValue];
    //TODO: 暂时取消判定
//    if([[WTUserInfo shareUserInfo].kyc integerValue] < verifyLevel){
//        if(verifyLevel == 2){
//            [self.buyBtn setTitle:LocalizationKey(@"委托方已设限") forState:UIControlStateNormal];
//            [self.buyBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
//        }
//    }
    
    pieceNum.text = [NSString stringWithFormat:@"¥ %@ ",model.price];
    _usdPriceTip.text = [NSString stringWithFormat:@"$ %.2f ",[model.price doubleValue] / 7];
    userName.text = model.ower.nickname;
    amount.text   = [NSString stringWithFormat:@"%@ %@ %@",LocalizationKey(@"Amount"),model.surplus,coinName];
    
    if([model.limit_min doubleValue] == 0 && [model.limit_max doubleValue] == 0){
       limitAmount.text = LocalizationKey(@"FiatLimit1");
    }else{
        limitAmount.text = [NSString stringWithFormat:@"%@ ¥ %@ - ¥ %@ \n         $ %.2f - $ %.2f",LocalizationKey(@"FiatLimit"),model.limit_min,model.limit_max,
                             [model.limit_min doubleValue]/7,[model.limit_max doubleValue]/7 ] ;
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

@end
