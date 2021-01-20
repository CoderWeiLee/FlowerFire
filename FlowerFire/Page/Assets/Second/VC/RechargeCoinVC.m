//
//  RechargeCoinVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/19.
//  Copyright © 2019 王涛. All rights reserved.
//  充币

#import "RechargeCoinVC.h"
#import "PayMentBottomView.h"
#import "BDFCustomPhotoAlbum.h"
#import "ChooseCoinTBVC.h"
#import "DepositModel.h"
#import "LBXScanNative.h"
#import "CoinFlowHistoryTBVC.h"
#import "FFBuyRecordViewController.h"
#import "FFChainNameView.h"

static const CGFloat Threshold = 80;
@interface RechargeCoinVC ()<UIScrollViewDelegate>
{
    UILabel             *_coinName;
    UIImageView         *_qrCodeImage;  //二维码图片
    UILabel             *_rechargeAddress; //充币地址
    UILabel             *_taglabel;
    UIView              *centerBac;
    UIButton            *copyBtn;
    NSArray<UIView *>   *viewArray;
    NSString            *_coinId;
    UIButton            *_headerBtn;
}
@property (nonatomic, strong)UIScrollView       *scrollView;
@property (nonatomic, assign)CGFloat             marginTop;
@property (nonatomic, strong)PayMentBottomView  *bottomView;
@property (nonatomic, strong)FFChainNameView    *chainNameView;
@end

@implementation RechargeCoinVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
 
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setUpView];
   
}

#pragma mark - action
//切换币
-(void)switchCoinkindClick{
    ChooseCoinTBVC *cvc = [ChooseCoinTBVC new];
    cvc.isSwitchCoin = YES;
    @weakify(self);
    cvc.switchCoinBlock = ^(ChooseCoinListModel * _Nonnull model) {
        @strongify(self)
        self.coinListModel = model;
        [self initData];
    };
    
    [self.navigationController pushViewController:cvc animated:YES];
}

-(void)saveAlbumsClick{
     [[BDFCustomPhotoAlbum shareInstance]saveToNewThumb:_qrCodeImage.image];
}

/**
 跳转记录页面
 */
-(void)jumpRecordClick{
    if([self.coinListModel.coin_id isEqual:@"21"]){
        FFBuyRecordViewController *fvc = [[FFBuyRecordViewController alloc] initWithFFBuyRecordType:FFBuyRecordTypeHidtoryRecord];
        [self.navigationController pushViewController:fvc animated:YES];
    }else{
        if(![HelpManager isBlankString:_coinId] &&
           ![HelpManager isBlankString:_coinName.text]){
           CoinFlowHistoryTBVC *cvc = [[CoinFlowHistoryTBVC alloc] initWithCoinFlowHistoryType:CoinFlowHistoryTypeDeposit CoinId:_coinId Symbol:_coinName.text];
            [self.navigationController pushViewController:cvc animated:YES];
        }else{
            printAlert(LocalizationKey(@"DepositTip6"), 1.f);
        }
    }
}

/**
 拷贝tag
 */
-(void)copyTagClick{
    if([_taglabel.text isEqualToString:@"--"]){
        printAlert(LocalizationKey(@"DepositTip6"), 1.f);
    }else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _taglabel.text;
        printAlert(LocalizationKey(@"Successful copy"), 1.f);
    } 
}

-(void)copyClick{
    if([_rechargeAddress.text isEqualToString:@"--"]){
        printAlert(LocalizationKey(@"DepositTip6"), 1.f);
    }else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _rechargeAddress.text;
        printAlert(LocalizationKey(@"Successful copy"), 1.f);
    }
    
}

#pragma mark - dataSource
-(void)initData{
    //SD用特有接口
    if([self.coinListModel.coin_id isEqual:@"21"]){
        [self.afnetWork jsonGetDict:@"/api/cc/getVbgAddress" JsonDict:nil Tag:@"1" LoadingInView:self.view];
    }else{
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.coinListModel.coin_id,@"coin_id", nil];
        [self.afnetWork jsonPostDict:@"/api/account/recharge" JsonDict:md Tag:@"1" LoadingInView:self.view];
    }
}
- (void)dataErrorHandle:(NSDictionary *)dict type:(NSString *)type{
    printAlert(dict[@"msg"], 2.f);
    _coinId = @"";
    _qrCodeImage.image = [UIImage imageNamed:@"address_unabled_image"];
    self.bottomView.showTextLabel.text = LocalizationKey(@"DepositTip6");
    _coinName.text = @"--";
    _rechargeAddress.text = @"--";
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    DepositModel *model = [DepositModel yy_modelWithDictionary:dict[@"data"]];
 
    if(![HelpManager isBlankString:model.tag]){
        [self showTagView:model];
    }else{
        if(viewArray.count > 0){
            for (UIView *view in viewArray) {
                [view removeFromSuperview];
            }
        }
    }
   _coinId = model.coin_id;
   _qrCodeImage.image = [LBXScanNative createQRWithString:model.address QRSize:_qrCodeImage.bounds.size];
    if([self.coinListModel.coin_id isEqual:@"21"]){
        self.bottomView.hidden = YES;
        _coinName.text = @"SD";
        
        self.chainNameView.hidden = YES;
        centerBac.top = _headerBtn.bottom + 15;
    }else{
        _coinName.text = [model.symbol uppercaseString];
        self.bottomView.hidden = NO;
        self.bottomView.showTextLabel.text =
        NSStringFormat(@"%@%@%@%@%@%@%@",LocalizationKey(@"DepositTip2"),model.reharge_confirm,LocalizationKey(@"DepositTip3"),LocalizationKey(@"DepositTip4"),model.reharge_min,[model.symbol uppercaseString],LocalizationKey(@"DepositTip5")); 
    
        self.chainNameView.hidden = NO;
        centerBac.top = self.chainNameView.bottom + 15;
    }
    
    
    _rechargeAddress.text = model.address;
}

#pragma mark - privateMethod
-(void)showTagView:(DepositModel *)model{
    _taglabel = [UILabel new];
    _taglabel.backgroundColor = centerBac.backgroundColor;
    _taglabel.theme_textColor = THEME_TEXT_COLOR;
    _taglabel.layer.masksToBounds = YES;
    _taglabel.text = model.tag;
    _taglabel.font = tFont(15);
    [centerBac addSubview:_taglabel];
    [_taglabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(copyBtn.mas_bottom).offset(20);
        make.centerX.mas_equalTo(centerBac.mas_centerX);
    }];
    
    UILabel *tip = [UILabel new];
    tip.textColor = MainBlueColor;
    tip.font = tFont(15);
    tip.text = LocalizationKey(@"DepositTip1");
    tip.numberOfLines = 2;
    tip.textAlignment = NSTextAlignmentCenter;
    tip.backgroundColor = centerBac.backgroundColor;
    tip.layer.masksToBounds = YES;
    [centerBac addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_taglabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(centerBac.mas_centerX);
        make.width.mas_equalTo(ScreenWidth - OverAllLeft_OR_RightSpace * 6);
    }];
    
    UIButton *copyTagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    copyTagBtn.backgroundColor = rgba(100, 111, 129, 1);
    copyTagBtn.layer.cornerRadius = 3;
    copyTagBtn.layer.masksToBounds = YES;
    copyTagBtn.titleLabel.font = tFont(16);
    [copyTagBtn setTitle:LocalizationKey(@"CopyTag") forState:UIControlStateNormal];
    [centerBac addSubview:copyTagBtn];
    [copyTagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tip.mas_bottom).offset(20);
        make.centerX.mas_equalTo(centerBac.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(90, 35));
    }];
    [copyTagBtn addTarget:self action:@selector(copyTagClick) forControlEvents:UIControlEventTouchUpInside];
    
    centerBac.height = centerBac.height + 130;
    viewArray = @[_taglabel,tip,copyTagBtn];
}

#pragma mark - ui
-(void)setUpView{
    
    UIButton *barBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    barBtn.frame = CGRectMake(0, 0, 30, 30);
    [barBtn setImageEdgeInsets:UIEdgeInsetsMake(4, 0, 4, 0)];//调整图片大小5:2
    barBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [barBtn theme_setImage:@"otc_market_history_btn" forState:UIControlStateNormal];
    self.gk_navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:barBtn];
    
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 0, ScreenWidth, Threshold)];
    la.text = LocalizationKey(@"Deposit");
    la.theme_textColor = THEME_TEXT_COLOR;
    la.layer.masksToBounds = YES;
    la.font = [UIFont boldSystemFontOfSize:30];
    [self.scrollView addSubview:la];
    la.backgroundColor= self.view.backgroundColor;
    
    _headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _headerBtn.layer.cornerRadius = 3;
    _headerBtn.frame = CGRectMake(OverAllLeft_OR_RightSpace, CGRectGetMaxY(la.frame)+10, ScreenWidth - OverAllLeft_OR_RightSpace * 2, 50);
    _headerBtn.theme_backgroundColor = THEME_INPUT_BACKGROUNDCOLOR;
    [self.scrollView addSubview:_headerBtn];
    
    _coinName = [[UILabel alloc] init];
    _coinName.theme_textColor = THEME_TEXT_COLOR;
    _coinName.text = self.coinListModel.symbol;
    _coinName.font = tFont(15);
    _coinName.layer.masksToBounds = YES;
    _coinName.backgroundColor= _headerBtn.backgroundColor;
    [_headerBtn addSubview:_coinName];
    [_coinName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_headerBtn.mas_centerY);
        make.left.mas_equalTo(_headerBtn.mas_left).offset(15);
    }];
    
    UIImageView *goImg = [[UIImageView alloc] init];
//    goImg.theme_image = @"history_order_right_arrow";
    goImg.backgroundColor= _headerBtn.backgroundColor;
    [_headerBtn addSubview:goImg];
    [goImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_headerBtn.mas_right).offset(-15);
        make.centerY.mas_equalTo(_headerBtn.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(12, 17));
    }];
    
    UILabel *tip = [[UILabel alloc] init];
    tip.textColor = ContractDarkBlueColor;
  //  tip.text = LocalizationKey(@"SelectCurrency");
    tip.font = tFont(14);
    tip.layer.masksToBounds = YES;
    tip.backgroundColor= _headerBtn.backgroundColor;
    [_headerBtn addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(goImg.mas_left).offset(-5);
        make.centerY.mas_equalTo(_headerBtn.mas_centerY);
    }];
    
    self.chainNameView = [[FFChainNameView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, _headerBtn.bottom + 15, ScreenWidth-OverAllLeft_OR_RightSpace * 2, 60)];
    self.chainNameView.hidden = YES;
    [self.scrollView addSubview:self.chainNameView];
    
    centerBac = [[UIView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, self.chainNameView.bottom+15, ScreenWidth-OverAllLeft_OR_RightSpace * 2, 430)];
    centerBac.layer.cornerRadius = 3;
    centerBac.theme_backgroundColor = THEME_INPUT_BACKGROUNDCOLOR;
    [self.scrollView addSubview:centerBac];
    
    _qrCodeImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"address_unabled_image"]];
    _qrCodeImage.layer.cornerRadius = 5;
    _qrCodeImage.layer.masksToBounds = YES;
    [centerBac addSubview:_qrCodeImage];
    [_qrCodeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(centerBac.mas_top).offset(35);
        make.centerX.mas_equalTo(centerBac.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(150, 150));
    }];
    
    UIButton *saveAlbumsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveAlbumsBtn setTitle:LocalizationKey(@"Save QR code to album") forState:UIControlStateNormal];
    saveAlbumsBtn.backgroundColor = rgba(84, 113, 144, 1);
    saveAlbumsBtn.layer.cornerRadius = 3;
    saveAlbumsBtn.titleLabel.font = tFont(16); 
    saveAlbumsBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
    [centerBac addSubview:saveAlbumsBtn];
    [saveAlbumsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_qrCodeImage.mas_bottom).offset(25);
        make.centerX.mas_equalTo(centerBac.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(180, 45));
    }];
    
    UILabel *tip1 = [UILabel new];
    tip1.textColor = rgba(113, 140, 173, 1);
    tip1.font = tFont(15);
    tip1.text = LocalizationKey(@"DepositAddress");
    [centerBac addSubview:tip1];
    [tip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(saveAlbumsBtn.mas_bottom).offset(25);
        make.centerX.mas_equalTo(centerBac.mas_centerX);
    }];
    
    _rechargeAddress = [UILabel new];
    _rechargeAddress.theme_textColor = THEME_TEXT_COLOR;
    _rechargeAddress.text = @"---";
    _rechargeAddress.font = tFont(15);
    _rechargeAddress.backgroundColor = centerBac.backgroundColor;
    _rechargeAddress.layer.masksToBounds = YES;
    _rechargeAddress.numberOfLines = 2;
    _rechargeAddress.textAlignment = NSTextAlignmentCenter;
    [centerBac addSubview:_rechargeAddress];
    [_rechargeAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(tip1.mas_bottom).offset(10);
        make.centerX.mas_equalTo(centerBac.mas_centerX);
        make.width.mas_equalTo(ScreenWidth - OverAllLeft_OR_RightSpace *6);
    }];
    
    copyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [copyBtn setTitle:LocalizationKey(@"Copy") forState:UIControlStateNormal];
    copyBtn.backgroundColor = rgba(100, 111, 129, 1);
    copyBtn.layer.cornerRadius = 3;
    copyBtn.titleLabel.font = tFont(16);
    [centerBac addSubview:copyBtn];
    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_rechargeAddress.mas_bottom).offset(20);
        make.centerX.mas_equalTo(_rechargeAddress.mas_centerX);
        make.size.mas_equalTo(CGSizeMake([copyBtn.titleLabel.text widthForFont:tFont(16)] + 20, 35));
    }];
    
    [self.scrollView addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(centerBac.mas_bottom).offset(15);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.width.mas_equalTo(ScreenWidth - OverAllLeft_OR_RightSpace * 2);
        make.bottom.mas_equalTo(self.bottomView.showTextLabel.mas_bottom).offset(15);
    }];
    
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bottomView.mas_bottom).offset(30);
    }];
    
    [_headerBtn addTarget:self action:@selector(switchCoinkindClick) forControlEvents:UIControlEventTouchUpInside];
    [saveAlbumsBtn addTarget:self action:@selector(saveAlbumsClick) forControlEvents:UIControlEventTouchUpInside];
    [copyBtn addTarget:self action:@selector(copyClick) forControlEvents:UIControlEventTouchUpInside];
    [barBtn addTarget:self action:@selector(jumpRecordClick) forControlEvents:UIControlEventTouchUpInside];
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
        self.title = LocalizationKey(@"Deposit");
    }else{
        self.title = @"";
    }
}

#pragma mark - lazyInit
-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        [self.view addSubview:_scrollView];
        _scrollView.delegate = self;
        [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsMake(Height_NavBar, 0, 0, 0));
        }];
    }
    return _scrollView;
}

-(PayMentBottomView *)bottomView{
    if(!_bottomView){
        _bottomView = [PayMentBottomView new];
        [_bottomView.showTitleBtn setTitle:LocalizationKey(@"DepositTip7") forState:UIControlStateNormal];
        _bottomView.theme_backgroundColor = THEME_INPUT_BACKGROUNDCOLOR;
        _bottomView.showTextLabel.text = NSStringFormat(@"%@%@%@%@%@%@%@",LocalizationKey(@"DepositTip2"),@"--",LocalizationKey(@"DepositTip3"),LocalizationKey(@"DepositTip4"),@"--",@"--",LocalizationKey(@"DepositTip5"));
    }
    return _bottomView;
}
@end
