//
//  ShopDetailsViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//  商品详情

#import "ShopDetailsViewController.h"
#import <SDCycleScrollView/SDCycleScrollView.h> 
#import "ShopDetailsInfoView.h"
#import <JXBWKWebView.h>
#import "ShopDetailsToolBarView.h"
#import "JVShopcartViewController.h" 
#import "ShopDetailsBuyPopView.h"
#import <LSTPopView.h>
#import "SubmitOrderViewController.h"
#import <YBImageBrowser.h>
#import "GoodsDetailsModel.h"

@interface ShopDetailsViewController ()<SDCycleScrollViewDelegate,UIScrollViewDelegate,WKNavigationDelegate,ShopDetailsToolBarViewDelegate>
{
   SDCycleScrollView *_sdcycleScrollView;
}
@property(nonatomic, strong)ShopDetailsInfoView    *infoView;
@property(nonatomic, strong)UIScrollView           *scrollView;
@property(nonatomic, strong)JXBWKWebView           *wkWebView;
@property(nonatomic, strong)ShopDetailsToolBarView *toolBarView;
@property(nonatomic, strong)NSString               *goodsID;
@property(nonatomic, strong)GoodsDetailsModel      *goodsDetailsModel;
@end

@implementation ShopDetailsViewController

- (instancetype)initWithGoodsID:(NSString *)goodsID{
    self = [super init];
    if(self){
        self.goodsID = goodsID;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationBar.hidden = YES;
}

- (void)createUI{
    [self.view addSubview:self.scrollView];
    @weakify(self)
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self initData];
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-50-SafeAreaBottomHeight);
        make.top.mas_equalTo(self.view.mas_top).offset(-Height_StatusBar);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    _sdcycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth , ceil(ScreenWidth/1.5)) delegate:self placeholderImage:[UIImage imageWithColor:[UIColor whiteColor]]];
    [self.scrollView addSubview:_sdcycleScrollView];
   // _sdcycleScrollView.placeholderImage = [UIImage imageNamed:@"lunbo1"];
    _sdcycleScrollView.backgroundColor = [UIColor clearColor];
    _sdcycleScrollView.currentPageDotColor = MainColor;
    _sdcycleScrollView.pageDotColor = rgba(255, 221, 148, 1);
    _sdcycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFit;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"fha"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backItemClick:) forControlEvents:UIControlEventTouchUpInside];
    backButton.frame = CGRectMake(OverAllLeft_OR_RightSpace, SafeIS_IPHONE_X   , 26, 26);
    [self.scrollView addSubview:backButton];
    
    [self.scrollView addSubview:self.infoView];
    [self.infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_sdcycleScrollView.mas_bottom);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.width.mas_equalTo(ScreenWidth);
        make.bottom.mas_equalTo(self.infoView.shopDetailsTipImageView.mas_bottom).offset(22);
    }];
    
    [self.scrollView addSubview:self.wkWebView];
    [self.wkWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.infoView.mas_bottom);
        make.bottom.mas_equalTo(self.scrollView.mas_bottom);
        make.left.mas_equalTo(self.scrollView.mas_left);
        make.width.mas_equalTo(ScreenWidth);
    }];
    
    [self.view addSubview:self.toolBarView];
}

#pragma mark - datasorece
- (void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"id"] = self.goodsID;
    [self.afnetWork jsonMallPostDict:@"/api/goods/goodsInfo" JsonDict:md Tag:@"1" LoadingInView:self.view];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        [self.scrollView.mj_header endRefreshing];
        self.goodsDetailsModel = [GoodsDetailsModel yy_modelWithDictionary:dict[@"data"]];
        if(self.goodsDetailsModel.is_collect == 1){
            _toolBarView.keepButton.selected = YES;
        }else{
            _toolBarView.keepButton.selected = NO;
        }
        if(self.goodsDetailsModel.is_cart == 1){
            _toolBarView.addShopCartButton.enabled = NO;
        }else{
            _toolBarView.addShopCartButton.enabled = YES;
        }
        [self.infoView setDetailsInfoViewData:self.goodsDetailsModel];
        _sdcycleScrollView.imageURLStringsGroup = self.goodsDetailsModel.heavy.imgsArray;
        [_wkWebView loadHTMLString:self.goodsDetailsModel.heavy.desc baseURL:nil];
    }else if([type isEqualToString:@"2"]){//加入购物车
        printAlert(dict[@"msg"], 1.f);
        _toolBarView.addShopCartButton.enabled = NO;
    }
}

- (void)dataErrorHandle:(NSDictionary *)dict type:(NSString *)type{
    printAlert(dict[@"msg"], 1.f);
}

#pragma mark - ShopDetailsToolBarViewDelegate
-(void)keepClick:(SQCustomButton *)button{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"id"] = self.goodsDetailsModel.GoodsId;
    md[@"sku_id"] = @""; //商品库存ID（用于区分多规格），不填为默认规格
    
    if(button.isSelected){ //取消收藏
        [[ReqestHelpManager share] requestMallPost:@"/api/goods/cancelCollect" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
            if([dicForData[@"status"] integerValue] == 1){
                printAlert(dicForData[@"msg"], 1.f);
                button.selected = !button.selected;
            }else if([dicForData[@"status"] integerValue] == 9){
                [self jumpLogin];
                [WTMallUserInfo logout];
            }else{
                printAlert(dicForData[@"msg"], 1.f);
            }
        }];
    }else{ //收藏
        [[ReqestHelpManager share] requestMallPost:@"/api/goods/confirmCollect" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
            if([dicForData[@"status"] integerValue] == 1){
                printAlert(dicForData[@"msg"], 1.f);
                button.selected = !button.selected;
            }else if([dicForData[@"status"] integerValue] == 9){
                [self jumpLogin];
                [WTMallUserInfo logout];
            }else{
                printAlert(dicForData[@"msg"], 1.f);
            }
        }];
    }
}

- (void)jumpShopCartClick:(SQCustomButton *)button{
    if([WTMallUserInfo isLogIn]){
        JVShopcartViewController *v = [JVShopcartViewController new];
        v.backFreshBlock = ^{
            [self.scrollView.mj_header beginRefreshing];
        };
        [self.navigationController pushViewController:v animated:YES];
    }else{
        [self jumpLogin];
    }
}

- (void)addShopCartClick:(UIButton *)button{
   if([WTMallUserInfo isLogIn]){
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
        md[@"sku_id"] = self.goodsDetailsModel.sku_id;
        md[@"amount"] = @"1"; //商品数量,默认为1个
        [self.afnetWork jsonMallPostDict:@"/api/cart/addCart" JsonDict:md Tag:@"2" LoadingInView:self.view];
    }else{
        [self jumpLogin];
    }
}

- (void)buyClick:(UIButton *)button{
    if([WTMallUserInfo isLogIn]){
        ShopDetailsBuyPopView *buyView = [[ShopDetailsBuyPopView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 220 - SafeAreaBottomHeight, ScreenWidth, 220 + SafeAreaBottomHeight) GoodsDetailsModel:self.goodsDetailsModel];

        LSTPopView *popView = [LSTPopView initWithCustomView:buyView parentView:self.view popStyle:LSTPopStyleSmoothFromBottom dismissStyle:LSTDismissStyleSmoothToBottom];
        popView.hemStyle = LSTHemStyleBottom;
        @weakify(popView)
        popView.bgClickBlock = ^{
         @strongify(popView)
            [popView dismiss];
        };
        [popView pop];
        @weakify(self)
        buyView.buyClickBlock = ^(NSString * _Nonnull num) {
            @strongify(self)
            @strongify(popView)
            [popView dismiss];
            
            SubmitOrderViewController *sov = [[SubmitOrderViewController alloc] init];
            sov.skuID = self.goodsDetailsModel.sku_id;
            sov.amount = num;
            [self.navigationController pushViewController:sov animated:YES];
            
        };
    }else{
        [self jumpLogin];
    }

}

#pragma mark - sdcycleDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    //查看图片集
    if(cycleScrollView.imageURLStringsGroup.count>0){
         NSMutableArray *browserDataSourceArray = [NSMutableArray arrayWithCapacity:cycleScrollView.imageURLStringsGroup.count];
         for (NSURL *url in cycleScrollView.imageURLStringsGroup) {
             YBIBImageData *data0 = [YBIBImageData new];
             data0.imageURL = url;
             data0.projectiveView = cycleScrollView;
             [browserDataSourceArray addObject:data0];
         }
         
        YBImageBrowser *browser = [YBImageBrowser new];
        browser.dataSourceArray = browserDataSourceArray;
        browser.currentPage = index;
        [browser show];
    } 
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY >= _infoView.ly_maxY - 50) {
        self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    }else{
        self.gk_statusBarStyle = UIStatusBarStyleDefault;
    }
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    // 不执行前段界面弹出列表的JS代码，关闭系统的长按保存图片
       [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
       
      //    document.body.scrollHeight（不准）   document.body.offsetHeight;(好)
      [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id Result, NSError * error) {
        NSString *heightStr = [NSString stringWithFormat:@"%@",Result];
              
              //必须加上一点
              CGFloat height = heightStr.floatValue+15.00;
              self.wkWebView.scrollView.contentSize = CGSizeMake(ScreenWidth, height);
              [self.wkWebView mas_updateConstraints:^(MASConstraintMaker *make) {
                  make.height.mas_equalTo(height);
              }];
  
      }];
}

-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 50)];
        _scrollView.delegate = self;
    }
    return _scrollView;
}

-(ShopDetailsInfoView *)infoView{
    if(!_infoView){
        _infoView = [[ShopDetailsInfoView alloc] initWithFrame:CGRectMake(0, _sdcycleScrollView.ly_maxY, ScreenWidth, 300)];
    }
    return _infoView;
}

-(JXBWKWebView *)wkWebView{
    if(!_wkWebView){
        //自适应文字和图片
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        
        _wkWebView = [[JXBWKWebView alloc] initWithFrame:CGRectZero configuration:wkWebConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.scrollView.scrollEnabled = NO;
        _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
    }
    return _wkWebView;
}

-(ShopDetailsToolBarView *)toolBarView{ 
    if (!_toolBarView) {
        _toolBarView = [[ShopDetailsToolBarView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 50 - SafeAreaBottomHeight, ScreenWidth, 50)];
        _toolBarView.delegate = self;
    }
    return _toolBarView;
}

@end
