//
//  AssetsHeaderView.m
//  FireCoin
//
//  Created by 赵馨 on 2019/5/27.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "AssetsHeaderView.h"
#import  <UICountingLabel.h>

BOOL ISHIDDENPRICE; //  全局是否隐藏价格变量
@interface AssetsHeaderView ()
{
    UIImageView     *_bacImageView;
    UICountingLabel *assetsSum;
    UILabel         *transformCNY;
    BOOL            _isFirstInit;//是否第一次初始化，只有第一次才跳钱动画
    UIView          *_whiteBac;
}
@end

@implementation AssetsHeaderView

-(instancetype)initWithFrame:(CGRect)frame{
    self  = [super initWithFrame:frame];
    if(self){
        _isFirstInit = YES;
        
        _bacImageView = [[UIImageView alloc] initWithFrame:frame];
        [self addSubview:_bacImageView];
        _bacImageView.image = [UIImage imageNamed:@"img32"];
        
        UIButton *hiddenPriceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        hiddenPriceButton.adjustsImageWhenHighlighted = NO;
        [hiddenPriceButton setImage:[[UIImage imageNamed:@"icon-test"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        hiddenPriceButton.imageView.tintColor = KWhiteColor;
        [hiddenPriceButton setImage:[[UIImage imageNamed:@"icon-test-2"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateSelected];
        [hiddenPriceButton addTarget:self action:@selector(hiddenPriceClick:) forControlEvents:UIControlEventTouchUpInside];
        hiddenPriceButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:hiddenPriceButton];
        [hiddenPriceButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top).offset(Height_NavBar);
            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.size.mas_equalTo(CGSizeMake(40, 23));
        }];
        
        UILabel *tip = [UILabel new];
        tip.text = LocalizationKey(@"Total Balances(BTC)");
        tip.textColor =  [UIColor colorWithWhite:1 alpha:0.5];
        tip.font = [UIFont systemFontOfSize:14] ;
        [self addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(hiddenPriceButton.mas_centerY).offset(0);
            make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        }];
        
        assetsSum = [UICountingLabel new];
        assetsSum.textColor = KWhiteColor;
        assetsSum.text = @"0.00000000";
        assetsSum.format = @"%.8f";
        assetsSum.method = UILabelCountingMethodEaseIn;
        assetsSum.font = [UIFont boldSystemFontOfSize:30];
        assetsSum.layer.masksToBounds = YES;
        [self addSubview:assetsSum];
        [assetsSum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(tip.mas_bottom).offset(5);
            make.left.mas_equalTo(tip.mas_left);
            make.width.mas_lessThanOrEqualTo((ScreenWidth - 30)/5*3);
        }];
        assetsSum.adjustsFontSizeToFitWidth = YES;
        
        transformCNY = [UILabel new];
        transformCNY.textColor = [UIColor colorWithWhite:1 alpha:0.5];
        transformCNY.text = @"≈0.00CNY";
        transformCNY.font = tFont(14);
        transformCNY.layer.masksToBounds = YES;
        [self addSubview:transformCNY];
        [transformCNY mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.bottom.mas_equalTo(assetsSum.mas_bottom).offset(-5);
           // make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace).priority(100);
            make.left.mas_equalTo(assetsSum.mas_right).offset(2).priority(200);
            make.width.mas_equalTo((ScreenWidth - 30)/5*2 );
            
        }];
        transformCNY.adjustsFontSizeToFitWidth = YES;
         
//        self.addNetSwitch = [[WTButton alloc] initWithFrame:CGRectZero titleStr:LocalizationKey(@"578Tip2") titleFont:tFont(12) titleColor:KWhiteColor buttonImage:[UIImage imageNamed:@"zctj"] parentView:self];
//        [self.addNetSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
//            make.top.mas_equalTo(transformCNY.mas_bottom);
//            make.size.mas_equalTo(CGSizeMake(80, 30));
//        }];
//
//        self.addNetSwitch.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
//        
//        _whiteBac = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 13, ScreenWidth, 13)];
//        _whiteBac.backgroundColor = KWhiteColor;
//        [self addSubview:_whiteBac];
    }
    return self;
}

#pragma mark - action
-(void)hiddenPriceClick:(UIButton *)btn{
    btn.selected = !btn.selected;
    ISHIDDENPRICE = btn.isSelected;
    //发送是否隐藏文字的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:@"HiddenPriceNotice" object:nil userInfo:nil];
}
  
#pragma mark - privateMethod
-(void)setSumData:(NSString *)data CNYStr:(nonnull NSString *)CNYStr{
   // assetsSum.text = data;
    if(ISHIDDENPRICE){
        assetsSum.text = @"*****";
        transformCNY.text = @"*****";
    }else{
        if(_isFirstInit){
            [assetsSum countFrom:0.00000000 to:[data doubleValue] withDuration:.5f];
            _isFirstInit = NO;
        }else{
            assetsSum.text = data;
        } 
        transformCNY.text = [NSString stringWithFormat:@"≈%@CNY",CNYStr];
    }
    
    
}
   

@end
