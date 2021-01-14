//
//  MineMainHeaderView.m
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "MineMainHeaderView.h"
#import "SQCustomButton.h"
#import "UIImage+jianbianImage.h"

@interface MineMainHeaderView ()
{
    UIImageView    *_imageBac;
    UIButton       *_signInButton,*_certificationButton;
    UILabel        *_userName,*_mebmerLevel;
    UIImageView    *_userPhoto;

}
@end

@implementation MineMainHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
        [self updateUserInfoCache];
    }
    return self;
}

- (void)createUI{
    _imageBac = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg2"]];
    _imageBac.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageBac];
    
    _signInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_signInButton setTitle:@"签到" forState:UIControlStateNormal];
    [_signInButton setTitleColor:rgba(88, 88, 88, 1) forState:UIControlStateNormal];
    [_signInButton setBackgroundImage:[UIImage gradientColorImageFromColors:@[rgba(254, 213, 132, 1),rgba(255, 230, 181, 1)] gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(60, 30)] forState:UIControlStateNormal];
    _signInButton.titleLabel.font = tFont(12);
    _signInButton.layer.cornerRadius = 15;
    _signInButton.layer.masksToBounds = YES;
    _signInButton.layer.shadowColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:0.35].CGColor;
    _signInButton.layer.shadowOffset = CGSizeMake(0,2);
    _signInButton.layer.shadowOpacity = 1;
    _signInButton.layer.shadowRadius = 4;
    [self addSubview:_signInButton];
    
    _certificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_certificationButton setTitle:@"实名认证" forState:UIControlStateNormal];
    [_certificationButton setBackgroundImage:[UIImage gradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(50, 30)] forState:UIControlStateNormal];
    _certificationButton.titleLabel.font = tFont(12);
    _certificationButton.layer.cornerRadius = 15;
    _certificationButton.layer.masksToBounds = YES;
    _certificationButton.layer.shadowColor = [UIColor colorWithRed:53/255.0 green:53/255.0 blue:53/255.0 alpha:0.35].CGColor;
    _certificationButton.layer.shadowOffset = CGSizeMake(0,2);
    _certificationButton.layer.shadowOpacity = 1;
    _certificationButton.layer.shadowRadius = 4;
    [self addSubview:_certificationButton];
     
    _userName = [UILabel new];
    _userName.textColor = KWhiteColor;
    _userName.font = tFont(15);
    [self addSubview:_userName];
    
    _mebmerLevel = [UILabel new];
    _mebmerLevel.text = @"--";
    _mebmerLevel.textColor = rgba(255, 221, 148, 1);
    _mebmerLevel.font = tFont(11);
    [self addSubview:_mebmerLevel];
    
    _userPhoto = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mren"]];
    _userPhoto.contentMode = UIViewContentModeScaleAspectFit;
    _userPhoto.layer.masksToBounds = YES;
    _userPhoto.layer.cornerRadius = 38;
    [self addSubview:_userPhoto];
    
    _whiteBac = [UIView new];
    _whiteBac.backgroundColor = KWhiteColor;
    _whiteBac.layer.shadowColor = [UIColor colorWithRed:255/255.0 green:115/255.0 blue:80/255.0 alpha:0.35].CGColor;
    _whiteBac.layer.shadowOffset = CGSizeMake(0,3);
    _whiteBac.layer.shadowOpacity = 1;
    _whiteBac.layer.shadowRadius = 6;
    _whiteBac.layer.cornerRadius = 10;
    [self addSubview:_whiteBac];
     
    [_signInButton addTarget:self action:@selector(singUpClick:) forControlEvents:UIControlEventTouchUpInside];
    [_certificationButton addTarget:self action:@selector(certificationClick:) forControlEvents:UIControlEventTouchUpInside];
     
}

-(void)updateUserInfoCache{
    if(![HelpManager isBlankString:[WTMallUserInfo shareUserInfo].username]){
        _userName.text = [WTMallUserInfo shareUserInfo].username;
    }
    
    if(![HelpManager isBlankString:[WTMallUserInfo shareUserInfo].memberrank_info]){
        _mebmerLevel.text = [WTMallUserInfo shareUserInfo].memberrank_info;
    }
  
    switch ([[WTMallUserInfo shareUserInfo].is_realname integerValue]) {
        case 0:
        {
            [_certificationButton setTitle:@"实名认证" forState:UIControlStateNormal];
            _certificationButton.userInteractionEnabled = YES;
        }
            break;
        case 1:
        {
            [_certificationButton setTitle:@"已认证" forState:UIControlStateNormal];
            _certificationButton.userInteractionEnabled = NO;
        }
            break;
        case 2:
        {
            [_certificationButton setTitle:@"实名认证" forState:UIControlStateNormal];
            _certificationButton.userInteractionEnabled = YES;
        }
            break;
        default:
            [_certificationButton setTitle:@"审核中" forState:UIControlStateNormal];
            _certificationButton.userInteractionEnabled = NO;
            break;
    }
    
    if([NSStringFormat(@"%@",[WTMallUserInfo shareUserInfo].is_sign) isEqualToString:@"0"]){
        [_signInButton setTitle:@"签到" forState:UIControlStateNormal];
        _signInButton.userInteractionEnabled = YES;
    }else{
        [_signInButton setTitle:@"已签到" forState:UIControlStateNormal];
        _signInButton.userInteractionEnabled = NO;
    }
}
 
- (void)layoutSubview{
    _signInButton.frame = CGRectMake(20, SafeAreaTopHeight + Height_StatusBar, 60, 30);
    _certificationButton.frame = CGRectMake(ScreenWidth - 20 - 70, SafeAreaTopHeight + Height_StatusBar, 70, 30);
    
    [_userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_signInButton.mas_bottom).offset(9);
    }];
    
    [_mebmerLevel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(_userName.mas_bottom).offset(5);
    }];
    
    [_userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_mebmerLevel.mas_bottom).offset(9.5);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(76, 76));
    }];
    
    [_whiteBac mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_userPhoto.mas_centerY);
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.height.mas_equalTo(120);
    }];
    
    [_imageBac mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(_whiteBac.mas_centerY);
    }];
    
    [self bringSubviewToFront:_userPhoto];
    
    NSArray *dataArray = @[@{@"image":@"gouwuche",@"title":@"购物车",@"viewControllerName":@"JVShopcartViewController"},
       @{@"image":@"dingdan",@"title":@"我的订单",@"viewControllerName":@"MyOrderViewController"},
       @{@"image":@"kucun",@"title":@"我的库存",@"viewControllerName":@"MyStockViewController"},
       @{@"image":@"shoucnag",@"title":@"我的收藏",@"viewControllerName":@"MyKeepViewController"}];
       
       for (int i = 0; i<4; i++) {
             long perRowItemCount = 4;
             
             CGFloat space = 40;
             long columnIndex = i % perRowItemCount;
             long rowIndex = i / perRowItemCount;
             CGFloat margin = 40;
             CGFloat itemW = (ScreenWidth - margin *5 - 15*2)/4;
             CGFloat itemH = itemW ;
             CGFloat bacWidth = space + columnIndex * (itemW + margin);
       
             CGFloat bacHeigth = rowIndex * (itemH + margin) + 45; //20 距顶部的距离
             
             SQCustomButton *button = [[SQCustomButton alloc] initWithFrame:CGRectMake(bacWidth, bacHeigth, itemW, itemH) type:SQCustomButtonTopImageType  imageSize:CGSizeMake(32, 32) midmargin:1];
             button.imageView.image = [UIImage imageNamed:dataArray[i][@"image"]];
             button.titleLabel.text = dataArray[i][@"title"];
             button.titleLabel.font = tFont(13);
             button.titleLabel.textColor = rgba(51, 51, 51, 1);
             @weakify(self)
             [button setTouchBlock:^(SQCustomButton * _Nonnull button) {
                 @strongify(self)
                 Class class = NSClassFromString(dataArray[i][@"viewControllerName"]);
                 UIViewController *vc = [class new];
                 [[self viewController].navigationController pushViewController:vc animated:true];
             }];
             [_whiteBac addSubview:button];
         }
    [self layoutIfNeeded]; 
}

-(void)singUpClick:(UIButton *)button{
    if([self.delegate respondsToSelector:@selector(singUpClick:)]){
        [self.delegate singUpClick:button];
    }
}

-(void)certificationClick:(UIButton *)button{
    if([self.delegate respondsToSelector:@selector(certificationClick:)]){
        [self.delegate certificationClick:button];
    }
}

@end
