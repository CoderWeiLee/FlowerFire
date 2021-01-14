//
//  HomeNavigationView.m
//  FireCoin
//
//  Created by 王涛 on 2020/4/27.
//  Copyright © 2020 王涛. All rights reserved.
//

#import "HomeNavigationView.h"
#import "HomeSkidVC.h"  
#import "ChooseCoinTBVC.h"
#import "ScanCodeViewController.h"
#import "StyleDIY.h"
#import "CollectionQRcodeViewController.h"

@interface HomeNavigationView ()
{
    UIButton *_drawerButton;
    WTButton *_title;
    UIButton *_scanCodeButton,*_collectMoneyCodeButton,*_loginButton;
    UILabel  *_incomeTip;
    UILabel  *_incomeNum,*_incomCNYNum;
    UIImageView *_navigationBac,*_moneyPeopleImageView;
    UIView   *_roundBac;
}

@end

@implementation HomeNavigationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
        [self initData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:EXIT_LOGIN_NOTIFICATION object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initData) name:SWITCH_ACCOUNT_SUCCESS_NOTIFICATION object:nil];
    }
    return self;
}

#pragma mark - data
-(void)initData{
    if(![WTUserInfo isLogIn]){
        _incomeTip.font = [UIFont boldSystemFontOfSize:20];
        _incomeTip.textColor = KWhiteColor;
        _incomeNum.textColor = [UIColor colorWithWhite:1 alpha:0.5];
        _incomeNum.font = tFont(12);
        
        _incomeTip.text = LocalizationKey(@"homeTip9");
        _incomeNum.text = LocalizationKey(@"homeTip10");
        _incomCNYNum.text = @"";
    }else{
        _incomeTip.font = tFont(12);
        _incomeTip.textColor = [UIColor colorWithWhite:1 alpha:0.5];
        _incomeNum.textColor = KWhiteColor;
        _incomeNum.font = [UIFont boldSystemFontOfSize:20];
        
        _incomeTip.text = LocalizationKey(@"homeTip1");
         
        @weakify(self)
        //获取SD收益和余额
        [[ReqestHelpManager share] requestGet:@"/api/account/getVbgProfitAndBalance" andHeaderParams:nil finish:^(NSDictionary *dicForData, ReqestType flag) {
            if(dicForData[@"data"]){
                @strongify(self)
                if([dicForData[@"data"] isKindOfClass:[NSDictionary class]]){
                    self->_incomeNum.text = NSStringFormat(@"%@",dicForData[@"data"][@"profit"]);
                    self->_incomCNYNum.text = NSStringFormat(@"≈¥%@",dicForData[@"data"][@"profit_cny"]);
                }else{
                    self->_incomeNum.text = @"0";
                    self->_incomCNYNum.text = @"≈¥0.00";
                }
            }else{
                self->_incomeNum.text = @"0";
                self->_incomCNYNum.text = @"≈¥0.00";
            }
        }];
    }
}

#pragma mark - action
-(void)collectionMoneyCodeClick{
    if(![WTUserInfo isLogIn]){
       [[WTPageRouterManager sharedInstance] jumpLoginViewController:[self viewController] isModalMode:YES whatProject:0];
        return;
    }
    [[UniversalViewMethod sharedInstance] activationStatusCheck:[self viewController]];
    
    CollectionQRcodeViewController *tbvc = [[CollectionQRcodeViewController alloc] init];
    [[self viewController].navigationController pushViewController:tbvc animated:YES];
}

-(void)scanCodeCodeClick{
    if(![WTUserInfo isLogIn]){
       [[WTPageRouterManager sharedInstance] jumpLoginViewController:[self viewController] isModalMode:YES whatProject:0];
        return;
    }
    [[UniversalViewMethod sharedInstance] activationStatusCheck:[self viewController]];
    
    ScanCodeViewController *svc = [[ScanCodeViewController alloc] init]; 
    [[self viewController].navigationController pushViewController:svc animated:YES];
}
 
-(void)jumpLogin{
    if(![WTUserInfo isLogIn]){
       [[WTPageRouterManager sharedInstance] jumpLoginViewController:[self viewController] isModalMode:YES whatProject:0];
    }
}

-(void)jumpHomeSikdVC{
    [[UniversalViewMethod sharedInstance] activationStatusCheck:[self viewController]];
    if([self.delegate respondsToSelector:@selector(jumpHomeSikdVC)]){
        [self.delegate jumpHomeSikdVC];
    } 
}

#pragma mark - ui
-(void)createUI{ 
    _navigationBac = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img32"]];
    [self addSubview:_navigationBac];
     
    _drawerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_drawerButton setImage:[UIImage imageNamed:@"account_user_image"] forState:UIControlStateNormal];
    [_drawerButton addTarget:self action:@selector(jumpHomeSikdVC) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_drawerButton];
    _drawerButton.hidden = YES;
    // LocalizationKey(@"maintitle")
    _title = [[WTButton alloc] initWithFrame:CGRectZero titleStr:@"" titleFont:[UIFont boldSystemFontOfSize:25] titleColor:KWhiteColor buttonImage:nil parentView:self];
    _title.imageView.contentMode = UIViewContentModeScaleAspectFit;
    _title.imageEdgeInsets = UIEdgeInsetsMake(0, -5 - 30, 0, 30 + 5);
    _title.userInteractionEnabled = NO;
    
    _collectMoneyCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectMoneyCodeButton setImage:[UIImage imageNamed:@"img44"] forState:UIControlStateNormal];
    [_collectMoneyCodeButton addTarget:self action:@selector(collectionMoneyCodeClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_collectMoneyCodeButton];
    
    _scanCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scanCodeButton setImage:[UIImage imageNamed:@"扫一扫"] forState:UIControlStateNormal];
    [_scanCodeButton addTarget:self action:@selector(scanCodeCodeClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_scanCodeButton];
     
    _incomeTip = [UILabel new];
    _incomeTip.layer.masksToBounds = YES;
    [self addSubview:_incomeTip];
    
    _incomeNum = [UILabel new];
    _incomeNum.layer.masksToBounds = YES;
    _incomeNum.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_incomeNum];
    
    _incomCNYNum = [UILabel new];
    _incomCNYNum.textColor = KWhiteColor;
    
    _incomCNYNum.font = tFont(14);
    _incomCNYNum.adjustsFontSizeToFitWidth = YES;
    _incomCNYNum.layer.masksToBounds = YES;
    [self addSubview:_incomCNYNum];
    
    _roundBac = [UIView new];
    _roundBac.theme_backgroundColor = THEME_MAIN_BACKGROUNDCOLOR;
    [self addSubview:_roundBac];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginButton addTarget:self action:@selector(jumpLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loginButton];
    
    _moneyPeopleImageView = [[UIImageView alloc] init];
    [self addSubview:_moneyPeopleImageView];
     
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0 ; i<28; i++) {
        NSString *name = [NSString stringWithFormat:@"人-分层_0000%d",i];
        if (i >= 10) {
            name = [NSString stringWithFormat:@"人-分层_000%d",i];
        }
        [imageArray addObject:[UIImage imageNamed:name]];
    }
    // 设置动画图片数组
    _moneyPeopleImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_moneyPeopleImageView setAnimationImages:imageArray];
    // 设置动画持续时间
    [_moneyPeopleImageView setAnimationDuration:1.0];
    // 设置动画重复次数  (当值为0时，表示无限次)
    _moneyPeopleImageView.animationRepeatCount = 0;
    // 开始动画
    [_moneyPeopleImageView startAnimating];
}

- (void)layoutSubview{
    _navigationBac.frame = self.bounds;
    _drawerButton.frame = CGRectMake(OverAllLeft_OR_RightSpace , SafeIS_IPHONE_X, 30, 30);
    _collectMoneyCodeButton.frame = CGRectMake(ScreenWidth - 30 - OverAllLeft_OR_RightSpace, _drawerButton.ly_y, 30, 30);
    _scanCodeButton.frame = CGRectMake(CGRectGetMinX(_collectMoneyCodeButton.frame) - 45, _drawerButton.ly_y, 30, 30);
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_drawerButton.mas_centerY);
        make.centerX.mas_equalTo(self.mas_centerX);
        make.height.mas_equalTo(40);
    }];
    
    [_title.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(30, 30));
        make.top.mas_equalTo(_title.mas_top).offset(8);
    }];
    
    _loginButton.frame = CGRectMake(0, _drawerButton.ly_maxY+30, ScreenWidth, self.ly_maxY - _drawerButton.ly_maxY - 30);
    
    _incomeTip.frame = CGRectMake(OverAllLeft_OR_RightSpace, CGRectGetMaxY(_drawerButton.frame) + 50, 200, 20);
     
    [_incomeNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_incomeTip.mas_bottom).offset(5);
        make.left.mas_equalTo(_incomeTip.mas_left);
        make.width.mas_lessThanOrEqualTo((ScreenWidth - 30)/3*2);
    }];
    
    [_incomCNYNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_incomeNum.mas_right).offset(2);
        make.bottom.mas_equalTo(_incomeNum.mas_bottom).offset(0);
        make.width.mas_lessThanOrEqualTo((ScreenWidth - 30)/3);
    }];
    
    _roundBac.frame = CGRectMake(0, self.ly_maxY - 20, ScreenWidth, 20);
    
    [[HelpManager sharedHelpManager] setPartRoundWithView:_roundBac corners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:30];
    
    [_moneyPeopleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_drawerButton.mas_bottom).offset(60);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.size.mas_equalTo(CGSizeMake(80, 80)); 
    }];
    
   
   
}

@end
