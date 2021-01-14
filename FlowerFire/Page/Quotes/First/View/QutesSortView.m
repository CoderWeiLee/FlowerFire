//
//  QutesSortView.m
//  FlowerFire
//
//  Created by 王涛 on 2020/4/29.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "QutesSortView.h"

@implementation QutesSortView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI{ 
        UIView *bac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
     //   bac.backgroundColor = navBarColor;
        [bac setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
        [self addSubview:bac];
    
        UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame = CGRectMake(0, 0, (ScreenWidth)/3, bac.height);
        [bac addSubview:btn1];
        
        UILabel *nameLabel = [UILabel new];
        nameLabel.text = LocalizationKey(@"quotesTip3");
        nameLabel.textColor = [UIColor grayColor];
        nameLabel.font = tFont(15);
        [btn1 addSubview:nameLabel];
        [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(btn1.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(btn1.mas_centerY);
        }];
        //market_selected_down_light market_selected_up_light market_selected_default
        _sortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sortBtn addTarget:self action:@selector(sortByName:) forControlEvents:UIControlEventTouchUpInside];
        [_sortBtn theme_setImage:@"market_selected_default" forState:UIControlStateNormal];
        [btn1 addSubview:_sortBtn];
        [_sortBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(btn1.mas_centerY);
            make.left.mas_equalTo(nameLabel.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(50, bac.height));
        }];
        
        UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame = CGRectMake(CGRectGetMaxX(btn1.frame), 0, (ScreenWidth)/3, bac.height);
        [bac addSubview:btn2];
        
        UILabel *newPriceLabel = [UILabel new];
        newPriceLabel.text = LocalizationKey(@"quotesTip4");
        newPriceLabel.textColor = [UIColor grayColor];
        newPriceLabel.font = tFont(15);
        [btn2 addSubview:newPriceLabel];
        [newPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(btn2.mas_centerX).offset(-10);
            make.centerY.mas_equalTo(btn2.mas_centerY);
        }];
        
        _sortBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sortBtn1 addTarget:self action:@selector(sortByPrice:) forControlEvents:UIControlEventTouchUpInside];
        [_sortBtn1 theme_setImage:@"market_selected_default" forState:UIControlStateNormal];
        [btn2 addSubview:_sortBtn1];
        [_sortBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(btn2.mas_centerY);
            make.left.mas_equalTo(newPriceLabel.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(50, bac.height));
        }];
        
        UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        btn3.frame = CGRectMake(CGRectGetMaxX(btn2.frame), 0, (ScreenWidth)/3, bac.height);
        [bac addSubview:btn3];
        
        UILabel *quoteChange = [UILabel new];
        quoteChange.text = LocalizationKey(@"quotesTip5");
        quoteChange.textColor = [UIColor grayColor];
        quoteChange.font = tFont(15);
        [btn3 addSubview:quoteChange];
        [quoteChange mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(bac.mas_right).offset(-35);
            make.centerY.mas_equalTo(btn3.mas_centerY);
        }];
        
        _sortBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sortBtn2 addTarget:self action:@selector(sortByChange:) forControlEvents:UIControlEventTouchUpInside];
        [_sortBtn2 theme_setImage:@"market_selected_default" forState:UIControlStateNormal];
        [btn3 addSubview:_sortBtn2];
        [_sortBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(btn3.mas_centerY);
            make.left.mas_equalTo(quoteChange.mas_right).offset(-15);
            make.size.mas_equalTo(CGSizeMake(50, bac.height));
        }];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 1, ScreenWidth, 1)];
    line.backgroundColor = rgba(248, 248, 248, 1);
    [bac addSubview:line];
     
}

-(void)sortByName:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(sortByName:)]){
        [self.delegate sortByName:btn];
    }
}

-(void)sortByPrice:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(sortByPrice:)]){
        [self.delegate sortByPrice:btn];
    }
}

-(void)sortByChange:(UIButton *)btn{
    if([self.delegate respondsToSelector:@selector(sortByChange:)]){
        [self.delegate sortByChange:btn];
    }
}



@end
