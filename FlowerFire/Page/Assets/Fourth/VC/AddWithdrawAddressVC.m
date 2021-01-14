//
//  AddWithdrawAddressVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/8/2.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "AddWithdrawAddressVC.h"
#import "WithdrawHelpView.h"
#import "QRCodeVC.h"
#import "StyleDIY.h"
#import "SendVerificationCodeModalVC.h"

static const CGFloat Threshold = 80;
@interface AddWithdrawAddressVC ()
{
    UILabel *_sybmol;
    UIButton *addBtn;
}
@property (nonatomic, strong)UIScrollView    *scrollView;
@property (nonatomic, assign)CGFloat          marginTop;
/**
 地址
 */
@property (nonatomic, strong)WithdrawHelpView *addressView;
/**
 备注
 */
@property (nonatomic, strong)WithdrawHelpView *remarksView;
/**
 标签
 */
@property (nonatomic, strong)WithdrawHelpView *tagView;

@end

@implementation AddWithdrawAddressVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

#pragma mark - netBack
-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    printAlert(dict[@"msg"], 1.f);
    [self closeVC];
}

#pragma mark - action
-(void)submitClick{
    if([HelpManager isBlankString:self.addressView.inputTextField.text]){
        printAlert(LocalizationKey(@"WithdrawTip12"), 1.f);
        return;
    }
    if([HelpManager isBlankString:self.remarksView.inputTextField.text]){
        printAlert(LocalizationKey(@"WithdrawTip14"), 1.f);
        return;
    }
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"coin_id"] = self.coinId;
    md[@"address"] = self.addressView.inputTextField.text;
    md[@"tag"] = self.tagView.inputTextField.text;
    md[@"info"] = self.remarksView.inputTextField.text;
    
    SendVerificationCodeModalVC *mvc = [SendVerificationCodeModalVC new];
    mvc.sendVerificationCodeWhereJump = SendVerificationCodeWhereJumpAddWithdrawAddress;
    mvc.addWithdrawAddressNetDic = md;
    mvc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    mvc.modalPresentationStyle = UIModalPresentationOverFullScreen;;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:mvc animated:YES completion:nil];
    
    @weakify(self)
    mvc.backRefreshBlock = ^{
        @strongify(self)
        [self closeVC];
    };
}

-(void)changedTextField:(UITextField *)textField{
    if(![HelpManager isBlankString:self.addressView.inputTextField.text] &&
         ![HelpManager isBlankString:self.remarksView.inputTextField.text]){
        addBtn.enabled = YES;
    }else{
        addBtn.enabled = NO;
    }
}

-(void)jumpQRCodeVC{
    QRCodeVC *qvc = [QRCodeVC new];
    qvc.libraryType = SLT_Native;
    qvc.scanCodeType = SCT_QRCode;
    qvc.style = [StyleDIY qqStyle];
    qvc.isVideoZoom = YES;
    @weakify(self)
    qvc.qrCodeBlock = ^(NSString * _Nonnull scanResult) {
        @strongify(self)
        self.addressView.inputTextField.text = scanResult;
        [self changedTextField:self.addressView.inputTextField];
    };
    [self.navigationController pushViewController:qvc animated:YES];
}

#pragma mark ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 实时监测scrollView.contentInset.top， 系统优化以及手动设置contentInset都会影响contentInset.top。
    if (self.marginTop != self.scrollView.contentInset.top) {
        self.marginTop = self.scrollView.contentInset.top;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat newoffsetY = offsetY + self.marginTop;
    
    // 临界值150，向上拖动时变透明
    if (newoffsetY >= 0 && newoffsetY <= -Threshold) {
        self.title = @"";
    }else if (newoffsetY > Threshold){
        self.title = _sybmol.text;
    }else{
        self.title = @"";
    }
}

#pragma mark - ui
-(void)setUpView{
    self.scrollView = [UIScrollView new];
    [self.view addSubview:self.scrollView];
    
    _sybmol = [[UILabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 0, ScreenWidth, Threshold)];
    _sybmol.text = NSStringFormat(@"%@ %@ %@",LocalizationKey(@"Add"),self.coinName,LocalizationKey(@"Address"));
    _sybmol.theme_textColor = THEME_TEXT_COLOR;
    _sybmol.font = [UIFont boldSystemFontOfSize:30];
    [self.scrollView addSubview:_sybmol];
    [self.view addSubview:self.scrollView];
 
    self.addressView = [WithdrawHelpView new];
    self.addressView.backgroundColor = self.scrollView.backgroundColor;
    self.addressView.title.text = LocalizationKey(@"Address");
     
    [self.addressView.leftBtn setHidden:YES];
    self.addressView.line.hidden = YES;
    [self.addressView.rightBtn theme_setImage:@"address_scan_normal_icon" forState:UIControlStateNormal];
    
    
    self.addressView.inputTextField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizationKey(@"WithdrawTip1") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
           
    
  //  [self.addressView.inputTextField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
    
    [self.scrollView addSubview:self.addressView];
    [self.addressView mas_makeConstraints:^(MASConstraintMaker *make) {  make.top.mas_equalTo(_sybmol.mas_bottom).offset(0);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.width.mas_equalTo(ScreenWidth);
        make.bottom.mas_equalTo(self.addressView.bottomLabel.mas_bottom).offset(0);
    }];
    [self.addressView.inputTextField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.addressView.rightBtn addTarget:self action:@selector(jumpQRCodeVC) forControlEvents:UIControlEventTouchUpInside];
  
    self.remarksView = [WithdrawHelpView new];
    self.remarksView.backgroundColor = self.scrollView.backgroundColor;
    self.remarksView.title.text = LocalizationKey(@"Remarks");
    self.remarksView.inputTextField.text = NSStringFormat(@"%@(%@) Address Name %ld",self.coinName,self.coinName,self.hasAddressCount + 1);
    [self.remarksView.leftBtn setHidden:YES];
    [self.remarksView.rightBtn setHidden:YES];
    self.remarksView.line.hidden = YES;
    [self.scrollView addSubview:self.remarksView];
    [self.remarksView mas_makeConstraints:^(MASConstraintMaker *make) {  make.top.mas_equalTo(self.addressView.mas_bottom).offset(OverAllLeft_OR_RightSpace);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.width.mas_equalTo(ScreenWidth);
        make.bottom.mas_equalTo(self.remarksView.bottomLabel.mas_bottom).offset(0);
    }];
    [self.remarksView.inputTextField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    
    self.tagView = [WithdrawHelpView new];
    self.tagView.backgroundColor = self.scrollView.backgroundColor;
    self.tagView.title.text = LocalizationKey(@"Tag");
    self.tagView.inputTextField.text = @"";
    self.tagView.inputTextField.placeholder = LocalizationKey(@"WithdrawTip10");
 
    self.tagView.inputTextField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:LocalizationKey(@"WithdrawTip10") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
            
    
    [self.tagView.leftBtn setHidden:YES];
    [self.tagView.rightBtn setHidden:YES];
    self.tagView.line.hidden = YES;
    [self.scrollView addSubview:self.tagView];
    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {  make.top.mas_equalTo(self.remarksView.mas_bottom).offset(OverAllLeft_OR_RightSpace);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.width.mas_equalTo(ScreenWidth);
        make.bottom.mas_equalTo(self.tagView.bottomLabel.mas_bottom).offset(0);
    }];
    
    addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.cornerRadius = 2;
    [addBtn setTitle:LocalizationKey(@"determine") forState:UIControlStateNormal];
    [addBtn setBackgroundColor:MainBlueColor];
    addBtn.titleLabel.font = tFont(15);
    [addBtn setBackgroundImage:[UIImage imageWithColor:ButtonDisabledColor] forState:UIControlStateDisabled];
    [addBtn setBackgroundImage:[UIImage imageWithColor:MainBlueColor] forState:UIControlStateNormal];
    addBtn.enabled = NO;
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
   
    if(IS_IPHONE_X){
        addBtn.frame = CGRectMake(OverAllLeft_OR_RightSpace, ScreenHeight - 45 - 20 - 15 , ScreenWidth - OverAllLeft_OR_RightSpace * 2, 45);
        self.scrollView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar - 20 - 15 - 45 - Height_NavBar);
    }else{
        addBtn.frame = CGRectMake(OverAllLeft_OR_RightSpace, ScreenHeight - 45 - 10 - 10 , ScreenWidth - OverAllLeft_OR_RightSpace * 2, 45);
        self.scrollView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar - 10 - 10 - 45 - Height_NavBar);
    }
}



@end
