//
//  FFAcountManagerCell.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/24.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "FFAcountManagerCell.h"

@interface FFAcountManagerCell ()
{
    WTBacView *_whiteBac;
    
    WTLabel   *_acountName,*_moneyNum,*_tokenNum;
}
@end

@implementation FFAcountManagerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    _whiteBac = [[WTBacView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, OverAllLeft_OR_RightSpace, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 90) backGroundColor:KWhiteColor parentView:self.contentView];
    _whiteBac.layer.cornerRadius = 1;
    _whiteBac.layer.borderWidth = 1;
    _whiteBac.layer.borderColor = FlowerFireBorderColor.CGColor;
    
    _singleButton = [[WTButton alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _whiteBac.height/2 - 11, 22, 22) buttonImage:[UIImage imageNamed:@"Unselected"] selectedImage:[UIImage imageNamed:@"zhglxz"] parentView:_whiteBac];
  
    _acountName = [[WTLabel alloc] initWithFrame:CGRectZero Text:@"--" Font:tFont(15) textColor:rgba(45, 45, 45, 1) parentView:_whiteBac];
    
    _tip = [[WTLabel alloc] initWithFrame:CGRectZero Text:LocalizationKey(@"578Tip30") Font:tFont(10) textColor:MainColor parentView:_whiteBac];
    
    _moneyNum = [[WTLabel alloc] initWithFrame:CGRectMake(_singleButton.right + 18, _singleButton.centerY - 5, _whiteBac.width - 50, 15) Text:@"" Font:tFont(12) textColor:[UIColor redColor] parentView:_whiteBac];
    
    _tokenNum = [[WTLabel alloc] initWithFrame:CGRectMake(_singleButton.right + 18, _moneyNum.bottom + 8, _whiteBac.width - 50, 15) Text:@"--" Font:tFont(10) textColor:rgba(137, 137, 137, 1) parentView:_whiteBac];
     
    self.arrowButton = [[WTButton alloc] initWithFrame:CGRectMake(_whiteBac.width - OverAllLeft_OR_RightSpace - 50, _singleButton.centerY - 25, 50, 50) buttonImage:[[UIImage imageNamed:@"xyy"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] selectedImage:[UIImage imageNamed:@"sanchu"] parentView:_whiteBac];
    self.arrowButton.tintColor = rgba(137, 137, 137, 1);
    self.arrowButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
     
}

- (void)layoutSubview{
    [_acountName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_singleButton.mas_right).offset(18);
        make.top.mas_equalTo(_whiteBac.mas_top).offset(15);
    }];
    
    [_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_acountName.mas_right).offset(2);
        make.centerY.mas_equalTo(_acountName);
    }];
}

- (void)setCellData:(UserAccount *)userAccount{
    _acountName.text = userAccount.username;
    _moneyNum.text = NSStringFormat(@"%@SD",userAccount.vbg);
    _tokenNum.text = userAccount.address;
}

@end
