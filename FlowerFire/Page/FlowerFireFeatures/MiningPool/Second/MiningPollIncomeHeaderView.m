//
//  MiningPollIncomeHeaderView.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/14.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "MiningPollIncomeHeaderView.h"
#import "MiningPollIncomeDetailsViewController.h"

@interface MiningPollIncomeHeaderView ()
{
    UIImageView  *_imageBac;
    WTLabel      *_tip1,*_num1;
    WTButton     *_detailsButton;
    WTBacView    *_lineBac;
}
@property(nonatomic, strong)NSString *coinName;
@end

@implementation MiningPollIncomeHeaderView

- (instancetype)initWithFrame:(CGRect)frame coinName:(nonnull NSString *)coinName
{
    self = [super initWithFrame:frame];
    if (self) {
        self.coinName = coinName;
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _imageBac = [[UIImageView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 20, SCREEN_WIDTH - 2 * OverAllLeft_OR_RightSpace, self.height - 30)];
    _imageBac.image = [UIImage imageNamed:@"img24"];
    [self addSubview:_imageBac];
    
    _tip1 = [[WTLabel alloc] initWithFrame:CGRectZero Text:[NSString stringWithFormat:@"累计收益(%@)",self.coinName] Font:tFont(14) textColor:KWhiteColor parentView:_imageBac];
    
    _num1 = [[WTLabel alloc] initWithFrame:CGRectZero Text:@"0" Font:[UIFont boldSystemFontOfSize:20] textColor:KWhiteColor parentView:_imageBac];
    
    _detailsButton = [[WTButton alloc] initWithFrame:CGRectZero titleStr:@"收益明细>" titleFont:tFont(14) titleColor:KWhiteColor parentView:self];
    
    _lineBac = [[WTBacView alloc] initWithFrame:CGRectMake(0, self.height - 30, SCREEN_WIDTH, 30) backGroundColor:FlowerFirexianColor parentView:self];
    
    [self sendSubviewToBack:_lineBac];
    
    @weakify(self)
    [_detailsButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        MiningPollIncomeDetailsViewController *m = [MiningPollIncomeDetailsViewController new];
        m.coinName = self.coinName;
        [[self viewController].navigationController pushViewController:m animated:YES];
    }];
}

- (void)layoutSubview{
    [_tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_imageBac.mas_centerY);
        make.left.mas_equalTo(_imageBac.mas_left).offset(10);
    }];
    
    [_num1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_tip1.mas_left);
        make.top.mas_equalTo(_tip1.mas_bottom).offset(5);
    }];
    
    [_detailsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_tip1.mas_centerY);
        make.right.mas_equalTo(_imageBac.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
}



@end
