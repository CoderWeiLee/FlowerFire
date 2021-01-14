//
//  CurrencyTransactionTitleView.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "CurrencyTransactionTitleView.h"
#import "PopoverView.h"

//#import "TransferVC.h"
//#import "ChooseCoinTBVC.h"

@interface CurrencyTransactionTitleView ()
{
    UIView  *_changBac;
    UILabel *_changeLabel;
    UIImageView *_klineImageView;
}

@end

@implementation CurrencyTransactionTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
       // self.backgroundColor = navBarColor;
        self.switchTransactionPairBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.switchTransactionPairBtn theme_setTitleColor:THEME_TEXT_COLOR forState:UIControlStateNormal];
        [self.switchTransactionPairBtn setTitle:@"--/--" forState:UIControlStateNormal];
        self.switchTransactionPairBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        self.switchTransactionPairBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        [self addSubview:self.switchTransactionPairBtn];
        [self.switchTransactionPairBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(self.mas_centerY);
        }];
        [self.switchTransactionPairBtn sizeToFit];
        
        UIImageView *btnImage = [[UIImageView alloc] init];
//        btnImage.theme_image = @"under_arrow";
        [self.switchTransactionPairBtn addSubview:btnImage];
        [btnImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.switchTransactionPairBtn.mas_right).offset(2);
            make.centerY.mas_equalTo(self.switchTransactionPairBtn.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
         
        
        _changBac = [UIView new];
        _changBac.layer.cornerRadius = 2.5;
        _changBac.backgroundColor = qutesGreenColor;
        [self addSubview:_changBac];
        [_changBac mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(7.5);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-7.5);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        }];
        
        _changeLabel = [UILabel new];
        _changeLabel.textColor = KWhiteColor;
        _changeLabel.text = @"0.00%";
        _changeLabel.font = tFont(13);
        [_changBac addSubview:_changeLabel];
        [_changeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_changBac.mas_left).offset(10);
            make.centerY.mas_equalTo(_changBac.mas_centerY);
        }];
        
        _klineImageView = [[UIImageView alloc] init];
        _klineImageView.image = [[UIImage imageNamed:@"jybfb"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _klineImageView.tintColor = KWhiteColor;
        _klineImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_changBac addSubview:_klineImageView];
        [_klineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_changeLabel.mas_right).offset(5);
            make.centerY.mas_equalTo(_changeLabel.mas_centerY);
            make.right.mas_equalTo(_changBac.mas_right).offset(-10);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
        
//        UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [moreBtn theme_setImage:@"transaction_2" forState:UIControlStateNormal];
//        [self addSubview:moreBtn];
//        [moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
//            make.centerY.mas_equalTo(self.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(35, 35));
//        }];
        
//        UIButton *kLineBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [kLineBtn theme_setImage:@"transaction_1" forState:UIControlStateNormal];
//        [self addSubview:kLineBtn];
//        [kLineBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
//            make.centerY.mas_equalTo(self.mas_centerY);
//            make.size.mas_equalTo(CGSizeMake(35, 35));
//        }];
        
        UIView *line = [UIView new];
        line.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
        [self addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom);
            make.left.mas_equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 5));
        }];
        
        [self.switchTransactionPairBtn addTarget:self action:@selector(switchTransactionPairClick:) forControlEvents:UIControlEventTouchUpInside];
      //  [moreBtn addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
        _changBac.userInteractionEnabled = YES;
        [_changBac addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jumpKLineClick:)]];
//        [kLineBtn addTarget:self action:@selector(jumpKLineClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setChangeNum:(double)changeNum{
    _changeNum = changeNum;
    
    if (_changeNum <0) {
           _changBac.backgroundColor = qutesRedColor;
           _changeLabel.text = [NSString stringWithFormat:@"%.2f%%", _changeNum];
       }else if (_changeNum >0) {
           _changBac.backgroundColor = qutesGreenColor;
           _changeLabel.text = [NSString stringWithFormat:@"+%.2f%%", _changeNum];
       }else{
           _changBac.backgroundColor = qutesRedColor;
           _changeLabel.text = @"0.00%";
       }
    
}

#pragma mark - action
//切换交易对
-(void)switchTransactionPairClick:(UIButton *)btn{
//    if([self.delegate respondsToSelector:@selector(didTransactionPairClick:)]){
//       [self.delegate didTransactionPairClick:btn];
//    }
}
//更多点击
-(void)moreClick:(UIButton *)btn{
    PopoverView *popoverView = [PopoverView popoverView];
    if([[SDThemeManager sharedInstance].themeName isEqualToString:WHITE_THEME]){
        popoverView.style = PopoverViewStyleDefault;
    }else{
        popoverView.style = PopoverViewStyleDark;
    }
    PopoverAction *multichatAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"wode05"] title:LocalizationKey(@"Transfer") handler:^(PopoverAction *action) {
     //   TransferVC *tvc = [TransferVC new];
     //   [[self viewController].navigationController pushViewController:tvc animated:YES];
     }];
    
     PopoverAction *addFriAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"wode03"] title:LocalizationKey(@"Deposit") handler:^(PopoverAction *action) {
      //   ChooseCoinTBVC *rvc = [[ChooseCoinTBVC alloc] initWithChooseCoinType:ChooseCoinTypeDeposit];
      //   [[self viewController].navigationController pushViewController:rvc animated:YES];
     }];
//
//    PopoverAction *QRAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"nav01s"] title:@"收款方式" handler:^(PopoverAction *action) {
//
//    }];
//
//    PopoverAction *facetofaceAction = [PopoverAction actionWithImage:[UIImage imageNamed:@"nav01s"] title:@"修改密码" handler:^(PopoverAction *action) {
//
//    }];
    //,addFriAction,QRAction,facetofaceAction
    [popoverView showToView:btn withActions:@[multichatAction,addFriAction]];
}
//跳k线图
-(void)jumpKLineClick:(UIButton *)btn{
    [[UniversalViewMethod sharedInstance] activationStatusCheck:[self viewController]];
    if([self.delegate respondsToSelector:@selector(jumpKLineClick:)]){
        [self.delegate jumpKLineClick:btn];
    }
}


@end
