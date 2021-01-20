//
//  CoinAccountCell.m
//  FireCoin
//
//  Created by 赵馨 on 2019/5/27.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "CoinAccountCell.h"
#import "ChooseCoinTBVC.h"
#import "TransferViewController.h"
#import "RechargeCoinVC.h"
#import "WithdrawCoinTBVC.h"
extern BOOL ISHIDDENPRICE;
@interface CoinAccountCell ()
{
    UILabel     *_coinName;
    UIImageView *_coinImage;
    UILabel     *_coinValue,*_coinCNYValue;
    UIButton    *_depositButton,*_withdrawButton,*_transferButton;
    UIView      *_line,*_line2,*_line3,*_line4;
    
    NSString *coind_id,*symbol;
}
@end

@implementation CoinAccountCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        self.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        
        [self createUI];
        [self layoutSubview];
      
    }
    return self;
}

#pragma mark - action
-(void)depositClick{
    //充值
//    [[UniversalViewMethod sharedInstance] activationStatusCheck:[self viewController]];
//
//    ChooseCoinTBVC *tvc = [[ChooseCoinTBVC alloc] initWithChooseCoinType:ChooseCoinTypeDeposit];
//    [[self viewController].navigationController pushViewController:tvc animated:YES];
    
    

 //   coind_id = dic[@"coin_id"];
 //   symbol = dic[@"symbol"];
    
    ChooseCoinListModel *model = [[ChooseCoinListModel alloc] init];
    model.coin_id = [NSString stringWithFormat:@"%@",coind_id];
    model.symbol = [NSString stringWithFormat:@"%@",symbol];
    RechargeCoinVC *rvc =[RechargeCoinVC new];
    rvc.coinListModel = model;
    [[self viewController].navigationController pushViewController:rvc animated:YES];
    
}

-(void)withdrawClick{
    //提币
//    [[UniversalViewMethod sharedInstance] activationStatusCheck:[self viewController]];
//
//    ChooseCoinTBVC *tvc = [[ChooseCoinTBVC alloc] initWithChooseCoinType:ChooseCoinTypeWithdraw];
//    [[self viewController].navigationController pushViewController:tvc animated:YES];
    ChooseCoinListModel *lwmodel = [[ChooseCoinListModel alloc] init];
    lwmodel.coin_id = [NSString stringWithFormat:@"%@",coind_id];
    lwmodel.symbol = [NSString stringWithFormat:@"%@",symbol];
    lwmodel.withdraw_fee = self.model.withdraw_fee;
    WithdrawCoinTBVC *wvc = [WithdrawCoinTBVC new];
    wvc.coinListModel = lwmodel;
    [[self viewController].navigationController pushViewController:wvc animated:YES];
}

-(void)transferClick{
    [[UniversalViewMethod sharedInstance] activationStatusCheck:[self viewController]];
    
    TransferViewController *tvc = [TransferViewController new];
    tvc.coin_id = [NSString stringWithFormat:@"%@",coind_id];
    tvc.symbol = [NSString stringWithFormat:@"%@",symbol];
    [[self viewController].navigationController pushViewController:tvc animated:YES];
    
}

- (void)createUI{
    self.layer.borderColor = FlowerFireBorderColor.CGColor;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 2;
    
    _coinImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"USDT"]];
    _coinImage.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_coinImage];
    
    _coinName = [UILabel new];
    _coinName.theme_textColor = THEME_GRAY_TEXTCOLOR;
    _coinName.font = tFont(15);
    _coinName.text = @"USDT";
    [self addSubview:_coinName];
    
    _coinValue = [UILabel new];
    _coinValue.theme_textColor = THEME_TEXT_COLOR;
    _coinValue.font = [UIFont boldSystemFontOfSize:18];
    _coinValue.text = @"0.000";
    [self addSubview:_coinValue];
    [_coinValue setAdjustsFontSizeToFitWidth:YES];
    
    _coinCNYValue = [UILabel new];
    _coinCNYValue.theme_textColor = THEME_GRAY_TEXTCOLOR;
    _coinCNYValue.font = tFont(14);
    _coinCNYValue.text = @"≈0.00 CNY";
    [self addSubview:_coinCNYValue];
    
    [_coinCNYValue setAdjustsFontSizeToFitWidth:YES];
    
    _line = [UIView new];
    _line.backgroundColor = FlowerFireBorderColor;
    [self addSubview:_line];
    
    _depositButton = [self creatButton:@"assetsTip1"];
    _withdrawButton = [self creatButton:@"assetsTip2"];
    _transferButton = [self creatButton:@"578Tip80"];
    
    [_depositButton addTarget:self action:@selector(depositClick) forControlEvents:UIControlEventTouchUpInside];
    [_withdrawButton addTarget:self action:@selector(withdrawClick) forControlEvents:UIControlEventTouchUpInside];
    [_transferButton addTarget:self action:@selector(transferClick) forControlEvents:UIControlEventTouchUpInside];
    
    _line2 = [UIView new];
    _line2.backgroundColor = FlowerFireBorderColor;
    [_withdrawButton addSubview:_line2];
    
    _line3 = [UIView new];
    _line3.backgroundColor = FlowerFireBorderColor;
    [_transferButton addSubview:_line3];
    
    _line4 = [UIView new];
    _line4.backgroundColor = FlowerFireBorderColor;
    [self addSubview:_line4];
       
    
    //_transferButton.enabled = NO;
}

- (void)layoutSubview{
    _coinImage.frame = CGRectMake(OverAllLeft_OR_RightSpace, 10, 30, 30);
    _coinName.frame = CGRectMake(_coinImage.ly_maxX+10, _coinImage.center.y-10, 100, 20);
     
    _line4.frame = CGRectMake(0, _coinImage.ly_maxY + 10, ScreenWidth - OverAllLeft_OR_RightSpace * 2, 1);
    
    [_coinValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coinImage.mas_left);
        make.top.mas_equalTo(_line4.mas_bottom).offset(20);
        make.width.mas_lessThanOrEqualTo((ScreenWidth - 2 * OverAllLeft_OR_RightSpace)/3*2);
    }];
    
    [_coinCNYValue mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_coinValue.mas_right).offset(2);
        make.bottom.mas_equalTo(_coinValue.mas_bottom).offset(0);
        make.width.mas_lessThanOrEqualTo((ScreenWidth - 2 * OverAllLeft_OR_RightSpace)/3);
    }];
 
    _line.frame = CGRectMake(0, _coinImage.ly_maxY + 70, ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 1);
    
    CGFloat buttonWidth = (ScreenWidth - 2 *OverAllLeft_OR_RightSpace)/3;
    _depositButton.frame = CGRectMake(_line.ly_x, _line.ly_maxY, buttonWidth, 40);
    _withdrawButton.frame = CGRectMake(_depositButton.ly_maxX, _line.ly_maxY, buttonWidth, 40);
    _transferButton.frame = CGRectMake(_withdrawButton.ly_maxX, _line.ly_maxY, buttonWidth, 40);
    
    _line2.frame = CGRectMake(0, 12.5, 1, 15);
    _line3.frame = CGRectMake(0, 12.5, 1, 15);
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x += OverAllLeft_OR_RightSpace;
    frame.size.height -= OverAllLeft_OR_RightSpace;
    frame.size.width -= 2 * OverAllLeft_OR_RightSpace;
    [super setFrame:frame];
}

-(UIButton *)creatButton:(NSString *)titleStr{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn theme_setTitleColor:THEME_TEXT_COLOR forState:UIControlStateNormal];
    [btn theme_setTitleColor:THEME_GRAY_TEXTCOLOR forState:UIControlStateDisabled];
    btn.titleLabel.font = tFont(14);
    [btn setTitle:LocalizationKey(titleStr) forState:UIControlStateNormal];
    [self addSubview:btn];
    return btn;
}

-(void)setCellData:(NSDictionary *)dic CoinAccountType:(CoinAccountType)coinAccountType{
    NSString *imgName = dic[@"symbol"];
    if ([imgName isEqualToString:@"SD"]) {
        imgName = @"replaceSD";
    }
    UIImage *img = [UIImage imageNamed:imgName];
    if (img == nil) {
        img = [UIImage imageNamed:@"USDT"];
    }
    _coinImage.image = img;
    NSString *titleName = dic[@"symbol"];
    if ([titleName isEqualToString:@"tusdt"]) {
        titleName = @"TUSDT";
    }
    _coinName.text = titleName;
    _coinValue.text = ISHIDDENPRICE ? @"*****" : [NSString stringWithFormat:@"%.8f",[dic[@"money"] doubleValue]];
    _coinCNYValue.text = ISHIDDENPRICE ? @"***** CNY" : [NSString stringWithFormat:@"≈%.8f CNY",[dic[@"money_cny"] doubleValue]];
 
    coind_id = dic[@"coin_id"];
    symbol = dic[@"symbol"];
    
    /*
     is_transfers  转帐
     is_recharge  充值
     is_withdraw 提现
     0 禁用 1启用

     */
    if([dic[@"is_transfers"] intValue] == 1){
        _transferButton.enabled = YES;
    }else{
        _transferButton.enabled = NO;
    }
    
    if([dic[@"is_recharge"] intValue] == 1){
        _depositButton.enabled = YES;
    }else{
        _depositButton.enabled = NO;
    }
    
    if([dic[@"is_withdraw"] intValue] == 1){
        _withdrawButton.enabled = YES;
    }else{
        _withdrawButton.enabled = NO;
    }
}
@end
