//
//  CoinAccountHeaderView.m
//  FireCoin
//
//  Created by 赵馨 on 2019/5/27.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "CoinAccountHeaderView.h"

extern BOOL ISHIDDENPRICE;
@interface CoinAccountHeaderView ()
{
    WTLabel   *_tip;
    WTBacView *_lineView,*_whiteBac,*_lineView2;
    
}
@end

@implementation CoinAccountHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineView = [[WTBacView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        _lineView.backgroundColor = RGB(239, 243, 246);
        [self addSubview:_lineView];
        
        _whiteBac = [[WTBacView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _lineView.bottom + 10, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 80)];
        [self addSubview:_whiteBac];
        _whiteBac.layer.borderWidth = 1;
        _whiteBac.layer.borderColor = FlowerFirexianColor.CGColor;
        _whiteBac.layer.cornerRadius = 2;
        
        _tip = [[WTLabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, OverAllLeft_OR_RightSpace, 100, 20) Text:LocalizationKey(@"578Tip117") Font:[UIFont boldSystemFontOfSize:18] textColor:KBlackColor parentView:_whiteBac];
         
        _time = [[WTLabel alloc] initWithFrame:CGRectMake(_tip.left, _tip.bottom + 10, 200, 20) Text:@"--" Font:tFont(13) textColor:grayTextColor parentView:_whiteBac];
       
        _goBuyButton = [[WTButton alloc] initWithFrame:CGRectMake(_whiteBac.right - 100 - OverAllLeft_OR_RightSpace, (80-40)/2, 100, 40) titleStr:LocalizationKey(@"578Tip1") titleFont:tFont(14) titleColor:KBlackColor parentView:_whiteBac];
        
        _lineView2 = [[WTBacView alloc] initWithFrame:CGRectMake(0, _whiteBac.bottom + OverAllLeft_OR_RightSpace, ScreenWidth, 10)];
        _lineView2.backgroundColor = RGB(239, 243, 246);
        [self addSubview:_lineView2];
    }
    return self;
}

-(void)setHeaderData:(CoinAccountType)coinAccountType SumAssets:(nonnull NSString *)SumAssets CNYStr:(nonnull NSString *)CNYStr{
 
}

@end
