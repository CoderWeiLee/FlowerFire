//
//  MyStockPickUpPopView.m
//  531Mall
//
//  Created by 王涛 on 2020/5/21.
//  Copyright © 2020 Celery. All rights reserved.
//  我的库存提货

#import "MyStockPickUpPopView.h"
#import "JVShopcartCountView.h"
#import <CRBoxInputView.h>
#import "UIImage+jianbianImage.h"
#import "AddressManagerViewController.h"

@interface MyStockPickUpPopView ()
{
    UIView              *_bacView;
    UILabel             *_shopOne,*_shopTwo,*_shopThree;
    JVShopcartCountView *_shopOneCountView,*_shopTwoCountView,*_shopThreeCountView;
    UIButton            *_chooseAddress;
    UIImageView         *_xiaImageView;
    UILabel             *_name,*_phone,*_inputTip;
    CRBoxInputView      *_pwdInputView;
    UIButton            *_pickUpButton;
    UIImageView         *_closeImage;
}
@property(nonatomic, strong)NSString                 *AddressId;
@property(nonatomic, strong)NSArray<MyStockSkuInfoModel* >  *stockInfoArray;
@end

@implementation MyStockPickUpPopView
 
- (instancetype)initWithFrame:(CGRect)frame stockInfoArray:(NSArray<MyStockSkuInfoModel *> *)stockInfoArray
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
        
        [self setpopViewData:stockInfoArray];
    }
    return self;
}

-(void)setpopViewData:(NSArray<MyStockSkuInfoModel *> *)stockInfoArray{
    NSInteger oneStock = [stockInfoArray[0].stock integerValue];
    NSInteger twoStock = [stockInfoArray[1].stock integerValue];
    NSInteger threeStock = [stockInfoArray[2].stock integerValue];
    
    _shopOne.text = stockInfoArray[0].name;
    _shopTwo.text = stockInfoArray[1].name;
    _shopThree.text = stockInfoArray[2].name;
    
    self.stockInfoArray = stockInfoArray;
    
    @weakify(self)
    if(oneStock == 0){
        [_shopOneCountView configureShopcartCountViewWithProductCount:0 productStock:oneStock];
    }else{
        [_shopOneCountView configureShopcartCountViewWithProductCount:0 productStock:oneStock];
        _shopOneCountView.shopcartCountViewEditBlock = ^(NSInteger count) {
            @strongify(self)
            [self->_shopOneCountView configureShopcartCountViewWithProductCount:count productStock:oneStock];
            
        };
    }

    if(twoStock == 0){
        [_shopTwoCountView configureShopcartCountViewWithProductCount:0 productStock:twoStock];
    }else{
        [_shopTwoCountView configureShopcartCountViewWithProductCount:0 productStock:twoStock];
        _shopTwoCountView.shopcartCountViewEditBlock = ^(NSInteger count) {
            @strongify(self)
            [self->_shopTwoCountView configureShopcartCountViewWithProductCount:count productStock:twoStock];
        };
    }
    
    if(threeStock == 0){
        [_shopThreeCountView configureShopcartCountViewWithProductCount:0 productStock:threeStock];
    }else{
        [_shopThreeCountView configureShopcartCountViewWithProductCount:0 productStock:threeStock];
        _shopThreeCountView.shopcartCountViewEditBlock = ^(NSInteger count) {
            @strongify(self)
            [self->_shopThreeCountView configureShopcartCountViewWithProductCount:count productStock:threeStock];
        };
    }
    

}

/// 提交
-(void)pickUpClick{
//    if(_pwdInputView.textValue.length <6){
//        printAlert(@"请输入支付密码", 1.f);
//    }else{
        NSMutableDictionary *goodInfoDic = [NSMutableDictionary dictionary];
        if(self.stockInfoArray[0].skuInfoID){
            goodInfoDic[self.stockInfoArray[0].skuInfoID] = _shopOneCountView.editTextField.text;
        }
        
        if(self.stockInfoArray[1].skuInfoID){
            goodInfoDic[self.stockInfoArray[1].skuInfoID] = _shopTwoCountView.editTextField.text;
        }
        
        if(self.stockInfoArray[2].skuInfoID){
            goodInfoDic[self.stockInfoArray[2].skuInfoID] = _shopThreeCountView.editTextField.text;
        }
        
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:4];
        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
        md[@"address_id"] = self.AddressId;
        md[@"good_info"] = goodInfoDic;
        [self.afnetWork jsonMallPostDict:@"/api/order/stockOrderSubmit" JsonDict:md Tag:@"1"];
 //   }
}

#pragma mark - dataBack
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    printAlert(dict[@"msg"], 1.f);
    !self.backFreshBlock ? : self.backFreshBlock();
}

-(void)chooseAddressClick{
    AddressManagerViewController *avc = [AddressManagerViewController new];
    BaseNavigationController *nav = [BaseNavigationController rootVC:avc];
    avc.ismodalPresentation = YES;
    
    @weakify(self)
    avc.noHasAddressBlock = ^{
        @strongify(self)
        self->_name.text = @"收件人:";
        self->_phone.text = @"手机号:";
        [self->_chooseAddress setTitle:@"  选择地址" forState:UIControlStateNormal];
        self.currentVC.gk_statusBarStyle = UIStatusBarStyleLightContent;
        self.AddressId = @"";
    };

    avc.didSelectedAddressBlock = ^(AddressInfoModel * _Nullable model) {
        @strongify(self)
        self->_name.text = NSStringFormat(@"收件人: %@",model.consignee);
        self->_phone.text = NSStringFormat(@"手机号: %@",model.mobile);
        [self->_chooseAddress setTitle:NSStringFormat(@"  %@%@%@%@",model.province_info,model.city_info,model.area_info,model.address) forState:UIControlStateNormal];
        self.currentVC.gk_statusBarStyle = UIStatusBarStyleLightContent;
        self.AddressId = model.AddressId;
    };
    self.currentVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    nav.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.currentVC presentViewController:nav animated:YES completion:nil];
    self.currentVC.gk_statusBarStyle = UIStatusBarStyleDefault;
}
  
-(void)closePopClick{
    !self.closePopViewBlock ? : self.closePopViewBlock();
}

- (void)createUI{
    _bacView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 420 - 80)];
    _bacView.backgroundColor = KWhiteColor;
    _bacView.layer.cornerRadius = 10;
    [self addSubview:_bacView];
    
    _shopOne = [self createLabel];
    _shopOne.text = @"--";
    
    _shopTwo = [self createLabel];
    _shopTwo.text = @"--";
    
    _shopThree = [self createLabel];
    _shopThree.text = @"--";
    
    _name = [self createLabel];
    _name.text = @"收件人:";
    
    _phone = [self createLabel];
    _phone.text = @"手机号:";
    
    _inputTip = [self createLabel];
    _inputTip.text = @"请输入支付密码";
    
    _shopOneCountView = [[JVShopcartCountView alloc] init];

    [_bacView addSubview:_shopOneCountView];
    
    _shopTwoCountView = [[JVShopcartCountView alloc] init];
    [_bacView addSubview:_shopTwoCountView];
    
    _shopThreeCountView = [[JVShopcartCountView alloc] init];
    [_bacView addSubview:_shopThreeCountView];
    
    _chooseAddress = [UIButton buttonWithType:UIButtonTypeCustom];
    _chooseAddress.layer.borderWidth = 0.5;
    _chooseAddress.layer.borderColor = rgba(204, 204, 204, 1).CGColor;
    _chooseAddress.layer.masksToBounds = YES;
    _chooseAddress.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_chooseAddress setTitle:@"  选择地址" forState:UIControlStateNormal];
    [_chooseAddress setTitleColor:rgba(51, 51, 51, 1) forState:UIControlStateNormal];
    _chooseAddress.titleLabel.font = tFont(13);
    _chooseAddress.layer.cornerRadius = 5;
    [_bacView addSubview:_chooseAddress];
    
    _xiaImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xia"]];
    [_chooseAddress addSubview:_xiaImageView];
    
    _pwdInputView = [[CRBoxInputView alloc] initWithCodeLength:6]; 
    _pwdInputView.ifNeedSecurity = YES;
    [_pwdInputView loadAndPrepareViewWithBeginEdit:NO];
    [_bacView addSubview:_pwdInputView];
    
    _pickUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pickUpButton setTitle:@"申请提货" forState:UIControlStateNormal];
    _pickUpButton.layer.cornerRadius = 20;
    _pickUpButton.layer.masksToBounds = YES;
    _pickUpButton.titleLabel.font = tFont(18);
    [_bacView addSubview:_pickUpButton];
    [_pickUpButton addTarget:self action:@selector(pickUpClick) forControlEvents:UIControlEventTouchUpInside];
    [_chooseAddress addTarget:self action:@selector(chooseAddressClick) forControlEvents:UIControlEventTouchUpInside];
    
    _closeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"close"]];
    _closeImage.userInteractionEnabled = YES;
    [_closeImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopClick)]];
    [self addSubview:_closeImage];
}

- (void)layoutSubview{
    [_shopOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_bacView.mas_top).offset(28);
        make.left.mas_equalTo(_bacView.mas_left).offset(38);
    }];
    
    [_shopOneCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bacView.mas_right).offset(-38);
        make.centerY.equalTo(_shopOne).offset(0);
        make.size.mas_equalTo(CGSizeMake(90, 25));
    }];
    
    [_shopTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_shopOne.mas_bottom).offset(24);
        make.left.mas_equalTo(_shopOne.mas_left);
    }];
    
    [_shopTwoCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_shopOneCountView.mas_right) ;
        make.centerY.equalTo(_shopTwo).offset(0);
        make.size.mas_equalTo(CGSizeMake(90, 25));
    }];

    [_shopThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_shopTwo.mas_bottom).offset(24);
        make.left.mas_equalTo(_shopTwo.mas_left);
    }];
    
    [_shopThreeCountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_shopTwoCountView.mas_right) ;
        make.centerY.equalTo(_shopThree).offset(0);
        make.size.mas_equalTo(CGSizeMake(90, 25));
    }];
    
    [_chooseAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_shopThree.mas_bottom).offset(20);
        make.left.mas_equalTo(_bacView.mas_left).offset(25);
        make.right.mas_equalTo(_bacView.mas_right).offset(-25);
        make.height.mas_equalTo(30);
    }];
    
    [_xiaImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_chooseAddress.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(19, 11));
        make.centerY.mas_equalTo(_chooseAddress);
    }];
    
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_chooseAddress.mas_bottom).offset(20);
        make.left.mas_equalTo(_shopOne.mas_left);
    }];
    
    [_phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_name.mas_bottom).offset(20);
        make.left.mas_equalTo(_shopOne.mas_left);
    }];
    
    [_inputTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_phone.mas_bottom).offset(15);
        make.left.mas_equalTo(_shopOne.mas_left);
    }];
    
    [_pwdInputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_inputTip.mas_bottom).offset(20);
        make.left.mas_equalTo(_bacView.mas_left).offset(25);
        make.right.mas_equalTo(_bacView.mas_right).offset(-25);
        make.height.mas_equalTo(32);
    }];
    
    _inputTip.hidden = YES;
    _pwdInputView.hidden = YES;
    
    [_pickUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_phone.mas_bottom).offset(22);
        make.centerX.mas_equalTo(_bacView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(_bacView.width - 25 * 2, 40));
    }];
    
    [_pickUpButton setBackgroundImage:[UIImage gradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(_bacView.width - 25 * 2, 40)] forState:UIControlStateNormal];
    
    _closeImage.frame = CGRectMake((_bacView.width-54)/2, _bacView.ly_maxY, 54, 54);
}

-(UILabel *)createLabel{
    UILabel *la = [UILabel new];
    la.textColor = rgba(51, 51, 51, 1);
    la.font = tFont(13);
    [_bacView addSubview:la];
    return la;
}

@end
