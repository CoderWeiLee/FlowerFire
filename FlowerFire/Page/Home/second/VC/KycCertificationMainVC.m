//
//  KycCertificationMainVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/30.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "KycCertificationMainVC.h"
#import "FirstLevelCertificationVC.h"
#import "SecondaryLevelCertificationVC.h"

@interface KycCertificationMainVC ()
{
    UIButton *certificationBtn,*certificationBtn2;
    UILabel  *leftText;
    UILabel  *leftText1;
    UILabel  *leftText2;
    UILabel  *leftText3;
}
@end

@implementation KycCertificationMainVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     
    
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.gk_navigationItem.title = LocalizationKey(@"Kyc certification");
    self.gk_navigationBar.hidden = NO;
    
    [self setUpView];

}

#pragma mark - action
-(void)jumpFirstCertificationClick{
    FirstLevelCertificationVC *flc = [FirstLevelCertificationVC new];
    [self.navigationController pushViewController:flc animated:YES];
}

-(void)jumpSecondCertificationClick{
    SecondaryLevelCertificationVC *svc = [SecondaryLevelCertificationVC new];
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - dataSource
-(void)initData{
    [self.afnetWork jsonGetDict:@"/api/account/getAccountVerify" JsonDict:nil Tag:@"1" LoadingInView:self.view];
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    NSDictionary *kyc1Dic = dict[@"data"][@"kyc1"];
    NSDictionary *kyc2Dic = dict[@"data"][@"kyc2"];
    
    if([kyc1Dic[@"status"] intValue] == 0){
        certificationBtn.selected = NO;
        leftText1.text = LocalizationKey(@"KycTip1");
        leftText.text = LocalizationKey(@"KycTip2");
        certificationBtn2.enabled = NO;
    }else{
        certificationBtn.selected = YES;
        certificationBtn.userInteractionEnabled = NO;  //已认证了就不让再点了
        leftText1.text = [NSString stringWithFormat:@"%@:%@",LocalizationKey(@"Name"),kyc1Dic[@"true_name"]];
        leftText.text = [NSString stringWithFormat:@"%@:%@",LocalizationKey(@"Identity number"),kyc1Dic[@"sn"]];
        certificationBtn2.enabled = YES;
    }
    
    if([kyc2Dic[@"status"] intValue] == 0){
        certificationBtn2.selected = NO;
        leftText3.text = LocalizationKey(@"KycTip3");
        leftText2.text = LocalizationKey(@"KycTip4");
        certificationBtn2.userInteractionEnabled = YES;
    }else{
        certificationBtn2.selected = YES;
        leftText3.text = LocalizationKey(@"KycTip3");
        leftText2.text = LocalizationKey(@"KycTip5");
        certificationBtn2.userInteractionEnabled = NO;
    }
}

#pragma mark - ui
-(void)setUpView{
    
    UIView *kyc1Bac = [[UIView alloc] initWithFrame:CGRectMake(0, 20 + Height_NavBar, ScreenWidth, 125)];
    kyc1Bac.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    [self.view addSubview:kyc1Bac];
    
    UILabel *kyc1Tip = [UILabel new];
    kyc1Tip.text = LocalizationKey(@"KYC1 certification");
    kyc1Tip.theme_textColor = THEME_TEXT_COLOR;
    kyc1Tip.font = [UIFont systemFontOfSize:16 weight:5];
    [kyc1Bac addSubview:kyc1Tip];
    [kyc1Tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kyc1Bac.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(kyc1Bac.mas_top).offset(15);
    }];
    
    certificationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    certificationBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    [certificationBtn setTitle:LocalizationKey(@"Go to certification") forState:UIControlStateNormal];
    [certificationBtn setTitle:LocalizationKey(@"verified") forState:UIControlStateSelected];
    certificationBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:5];
    [certificationBtn setImage:[UIImage imageNamed:@"attention_style_1"] forState:UIControlStateNormal];
    [certificationBtn setImage:[UIImage imageNamed:@"verification_ertified"] forState:UIControlStateSelected];
    [certificationBtn setTitleColor:rgba(210, 78, 103, 1) forState:UIControlStateNormal ];
    [certificationBtn setTitleColor:rgba(35, 137, 213, 1) forState:UIControlStateSelected];
    
    [kyc1Bac addSubview:certificationBtn];
    [certificationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kyc1Bac.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(kyc1Tip.mas_centerY);
    }];
    
    UIView *xian = [UIView new];
    xian.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [kyc1Bac addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kyc1Tip.mas_bottom).offset(15);
        make.left.mas_equalTo(kyc1Bac.mas_left);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
    }];
    
    leftText = [UILabel new];
    leftText.text = LocalizationKey(@"KycTip2");
    leftText.textColor = rgba(111, 137, 169, 1);
    leftText.font = tFont(15);
    [kyc1Bac addSubview:leftText];
    [leftText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kyc1Bac.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(xian.mas_bottom).offset(15);
    }];
    
    leftText1 = [UILabel new];
    leftText1.text = LocalizationKey(@"KycTip1");
    leftText1.textColor = rgba(111, 137, 169, 1);
    leftText1.font = tFont(15);
    [kyc1Bac addSubview:leftText1];
    [leftText1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kyc1Bac.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(leftText.mas_bottom).offset(10);
    }];
    
    UIView *kyc2Bac = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(kyc1Bac.frame)+20, ScreenWidth, 145)];
    kyc2Bac.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    [self.view addSubview:kyc2Bac];
    
    
    UILabel *kyc2Tip = [UILabel new];
    kyc2Tip.text = LocalizationKey(@"KYC2 certification");
    kyc2Tip.theme_textColor = THEME_TEXT_COLOR;
    kyc2Tip.font = [UIFont systemFontOfSize:16 weight:5];
    [kyc2Bac addSubview:kyc2Tip];
    [kyc2Tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kyc2Bac.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(kyc2Bac.mas_top).offset(15);
    }];
    
    certificationBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    certificationBtn2.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 5);
    certificationBtn2.enabled = NO; //设置默认不可点
    [certificationBtn2 setTitle:LocalizationKey(@"Go to certification") forState:UIControlStateNormal];
    [certificationBtn2 setTitle:LocalizationKey(@"verified") forState:UIControlStateSelected];
    [certificationBtn2 setTitle:LocalizationKey(@"not certified") forState:UIControlStateDisabled];
    certificationBtn2.titleLabel.font = [UIFont systemFontOfSize:16 weight:5];
    [certificationBtn2 setImage:[UIImage imageNamed:@"attention_style_1"] forState:UIControlStateNormal];
    [certificationBtn2 setImage:[UIImage imageNamed:@"verification_ertified"] forState:UIControlStateSelected];
    [certificationBtn2 setImage:[UIImage imageNamed:@""] forState:UIControlStateDisabled];
    [certificationBtn2 setTitleColor:rgba(210, 78, 103, 1) forState:UIControlStateNormal];
    [certificationBtn2 setTitleColor:rgba(35, 137, 213, 1) forState:UIControlStateSelected ];
    [certificationBtn2 setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [kyc2Bac addSubview:certificationBtn2];
    [certificationBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(kyc2Bac.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(kyc2Tip.mas_centerY);
    }];
    
    xian = [UIView new];
    xian.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
    [kyc2Bac addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(kyc2Tip.mas_bottom).offset(15);
        make.left.mas_equalTo(kyc2Bac.mas_left);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
    }];
    
    leftText2 = [UILabel new];
    leftText2.text = LocalizationKey(@"not KycTip5");
    leftText2.textColor = rgba(111, 137, 169, 1);
    leftText2.font = tFont(15);
    [kyc2Bac addSubview:leftText2];
    [leftText2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kyc2Bac.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(xian.mas_bottom).offset(15);
    }];
    
    leftText3 = [UILabel new];
    leftText3.text = LocalizationKey(@"not KycTip3");
    leftText3.textColor = rgba(111, 137, 169, 1);
    leftText3.numberOfLines = 2;
    leftText3.font = tFont(15);
    [kyc2Bac addSubview:leftText3];
    [leftText3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(kyc2Bac.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(leftText2.mas_bottom).offset(10);
        make.right.mas_equalTo(kyc2Bac.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
    
    [certificationBtn addTarget:self action:@selector(jumpFirstCertificationClick) forControlEvents:UIControlEventTouchUpInside];
    [certificationBtn2 addTarget:self action:@selector(jumpSecondCertificationClick) forControlEvents:UIControlEventTouchUpInside];
    
}

@end
