//
//  FBTransactionViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/5/6.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "FBTransactionViewController.h"
#import "SQCustomButton.h"
#import "MJCSegmentInterface.h"
#import "LegalCurrencyPageVC.h"
#import "ViewController.h"
#import <LSTPopView.h>
#import "FBChooseCoinView.h"
#import "MyOrderVC.h"
#import "OrderRecordTBVC.h"

@interface FBTransactionViewController ()<MJCSegmentDelegate>
{
    MJCSegmentInterface *_interFace;
    NSInteger           _lastPageIndex;//记录跳转订单前最后一个index
}
@property(nonatomic, strong)LegalCurrencyPageVC *FBBuyVC;
@property(nonatomic, strong)LegalCurrencyPageVC *FBSellVC;
@property(nonatomic, strong)LSTPopView          *popView;
@property(nonatomic, strong)SQCustomButton      *titleButton;
@end

@implementation FBTransactionViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _interFace.selectedSegmentIndex = _lastPageIndex;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}
 
- (void)createNavBar{
    self.titleButton = [[SQCustomButton alloc] initWithFrame:CGRectMake(self.view.center.x - 50, SafeIS_IPHONE_X, 100, 40) type:SQCustomButtonRightImageType imageSize:CGSizeMake(20, 20) midmargin:1];
    self.titleButton.imageView.theme_image = @"under_arrow";
    self.titleButton.titleLabel.text = @"";
    self.titleButton.titleLabel.font = [UIFont boldSystemFontOfSize:NAVIGATATIONBAR_TITLE_FONT];
    self.gk_navigationItem.titleView = self.titleButton;
    //不佳点击事件不响应
    self.titleButton.intrinsicContentSize = CGSizeMake(self.titleButton.width+70, Height_NavBar);
      
    @weakify(self)
    [self.titleButton touchAction:^(SQCustomButton * _Nonnull button) {
        @strongify(self)
        FBChooseCoinView *fbChooseCoinView = [[FBChooseCoinView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 120)  coinInfoArray:self.dataArray currentSelectCoinId:self.FBBuyVC.coin_id chooseCoinIdBlock:^(NSString * _Nonnull coinid,NSString * _Nonnull coinName) {

            self.FBBuyVC.coin_id = coinid;
            self.FBBuyVC.coinName = coinName;
            self.FBSellVC.coin_id = coinid;
            self.FBSellVC.coinName = coinName;
            
            self.titleButton.titleLabel.text = coinName;
            [self.popView dismissWithStyle:LSTDismissStyleSmoothToTop duration:1.0]; 
            self.popView = nil;
        }];
         LSTPopView *v = [LSTPopView initWithCustomView:fbChooseCoinView parentView:self.view popStyle:LSTPopStyleSmoothFromTop dismissStyle:LSTDismissStyleSmoothToTop];
        v.hemStyle = LSTHemStyleTop;
        @weakify(v)
        v.bgClickBlock = ^{
            @strongify(v)
            [v dismiss];
            self.popView = nil;
        };
        [v pop];
        self.popView = v;
    }];
}

- (void)createUI{
    [self setScrollSegementControl:@[LocalizationKey(@"FBTip1"),LocalizationKey(@"FBTip2"),
    LocalizationKey(@"FBTip3"),LocalizationKey(@"FBTip4")]];
}

- (void)initData{
    [self.afnetWork jsonPostDict:@"/api/coin/getCoinList" JsonDict:@{@"type":LegalCurrency_Account} Tag:@"1"];
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    NSMutableArray *titleArray = [NSMutableArray array];
    for (NSDictionary *dic in dict[@"data"]) {
        [self.dataArray addObject:dic];
    }
    for (int i = 0 ; i<self.dataArray.count; i++) {
        [titleArray addObject:self.dataArray[i][@"symbol"]];
    }
    self.FBBuyVC.coin_id = NSStringFormat(@"%@",self.dataArray.firstObject[@"coin_id"]); //没请求到币id，给显示一个空的视图
    self.FBBuyVC.coinName = self.dataArray.firstObject[@"symbol"];
    self.FBSellVC.coin_id = NSStringFormat(@"%@",self.dataArray.firstObject[@"coin_id"]);
    self.FBSellVC.coinName = self.dataArray.firstObject[@"symbol"];
    
    self.titleButton.titleLabel.text = self.dataArray.firstObject[@"symbol"];
    _interFace.selectedSegmentIndex = 0;
}

//跳订单页面
-(void)jumpOrderRecordTBVC{
    OrderRecordTBVC *ob = [OrderRecordTBVC new];
    [self.navigationController pushViewController:ob animated:YES];
}
//跳委托单页面
-(void)jumpCommissionOrderTBVC{
    MyOrderVC *FBCommissionOrderVC = [MyOrderVC new];
    FBCommissionOrderVC.MyOrderPageWhereJump = MyOrderPageWhereJumpFB;
    [self.navigationController pushViewController:FBCommissionOrderVC animated:YES];
}

#pragma mark - MJCSegmentDelegate
-(void)mjc_ClickEventWithItem:(UIButton *)tabItem childsController:(UIViewController *)childsController segmentInterface:(MJCSegmentInterface *)segmentInterface{
    if(tabItem.tag !=3 && tabItem.tag !=2){
        _lastPageIndex = tabItem.tag;
    }
    if(tabItem.tag == 3){
        [self jumpOrderRecordTBVC];
    }
    if(tabItem.tag == 2){
        [self jumpCommissionOrderTBVC];
    }
}

-(void)mjc_scrollDidEndDeceleratingWithItem:(UIButton *)tabItem childsController:(UIViewController *)childsController indexPage:(NSInteger)indexPage segmentInterface:(MJCSegmentInterface *)segmentInterface{
    if(indexPage !=3 && indexPage !=2){
        _lastPageIndex = indexPage;
    }
    if(indexPage == 3){
        [self jumpOrderRecordTBVC];
    }
    if(indexPage == 2){
        [self jumpCommissionOrderTBVC];
    }
}

#pragma mark - titleSegement
-(void)setScrollSegementControl:(NSArray *)titlesArr{
    NSMutableArray *vcarrr = [NSMutableArray array];
    [vcarrr addObject:self.FBBuyVC];
    [vcarrr addObject:self.FBSellVC];
    [self setupBasicUIWithTitlesArr:titlesArr vcArr:vcarrr];
    
}

-(void)setupBasicUIWithTitlesArr:(NSArray*)titlesArr vcArr:(NSArray*)vcArr
{
    
    MJCSegmentStylesTools *tools = [MJCSegmentStylesTools jc_initWithSegmentStylestoolsBlock:^(MJCSegmentStylesTools *jc_tools) {
        jc_tools.
        jc_titlesViewBackColor(MainColor).
        jc_titleBarStyles(MJCTitlesClassicStyle).
        jc_itemTextSelectedColor(MainColor).
        jc_itemTextNormalColor(rgba(108, 128, 142, 1)).
        jc_itemTextFontSize(16).
        jc_itemImageSize(CGSizeMake(25, 25)).
        jc_childScollEnabled(YES).
        jc_indicatorColor(MainColor).
        jc_indicatorFollowEnabled(YES).
        jc_indicatorFrame(CGRectMake(0, 58, 0, 2)).
        jc_indicatorHidden(NO).
        jc_scaleLayoutEnabled(NO).
        jc_itemTextZoomEnabled(NO,25).
        jc_titlesViewFrame(CGRectMake(0, 0, ScreenWidth, 60)).
        jc_indicatorStyles(MJCIndicatorEqualTextEffect);
        
    }];
    
    _interFace = [MJCSegmentInterface initWithFrame: CGRectMake(0,Height_NavBar + 0,self.view.jc_width, self.view.jc_height- Height_NavBar) interFaceStyletools:tools];
    _interFace.delegate = self;
    [self.view addSubview:_interFace];
    
    [_interFace intoTitlesArray:titlesArr intoChildControllerArray:vcArr hostController:self];
    
}

-(LegalCurrencyPageVC *)FBBuyVC{
    if(!_FBBuyVC){
        _FBBuyVC = [LegalCurrencyPageVC new];
        _FBBuyVC.buyOrSell = @"1";
     //   _FBBuyVC.coin_id = @"1000"; //没请求到币id，给显示一个空的视图
     //   _FBBuyVC.coinName = @"";
    }
    return _FBBuyVC;
}

-(LegalCurrencyPageVC *)FBSellVC{
    if(!_FBSellVC){
        _FBSellVC = [LegalCurrencyPageVC new];
        _FBSellVC.buyOrSell = @"0";
      //  _FBSellVC.coin_id = @"1000";
      //  _FBSellVC.coinName = @"";
    }
    return _FBSellVC;
}
 
@end
