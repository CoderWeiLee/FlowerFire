//
//  CurrencyTransactionVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//  币币交易

#import "CurrencyTransactionVC.h"

#import "CurrencyTransactionCurrentCommissionView.h"
#import "LeftMenuViewController.h"
#import "KLlineViewController.h"
#import "AppDelegate.h"
#import "MainTabBarController.h"
#import "QuotesTransactionPairModel.h"
#import "QuotesTradingZoneModel.h"
#import "CurrencyTransactionModel.h"
#import "SHPolling.h"
#import <MJExtension/MJExtension.h>
const CGFloat commissionViewHeight = 192;
int FROMSCALE;   //交易对钱精确度(小数点后几位)
int TOSCALE;     //交易对后精确度
int PRICESCALE;  //价格精确度
@interface CurrencyTransactionVC ()<CurrencyTransactionTitleViewDelegate,CurrencyTransactionQuotesViewDelegate,CurrencyTransactionCurrentCommissionViewDelegate,KLlineViewControllerDelegate>
{
    BOOL   _isFirst; //是否第一次进
    double _lastPrice; //上次最新价
}

@property(nonatomic, strong)CurrencyTransactionCurrentCommissionView *currentCommissionView; //委托单视图
@property(nonatomic, strong)LeftMenuViewController *menu;
@property(nonatomic, strong)NSString               *markId;
@property(nonatomic, strong)SHPolling              *SHPollinga;
/**
 交易对前货币id
 */
@property(nonatomic, strong)NSString               *fromId;

@property(nonatomic, assign)int HandicapDataCount; //盘口数据数量
@property(nonatomic, assign)int fromScale;         //交易对钱精确度(小数点后几位)
@property(nonatomic, assign)int toScale;           //交易对后精确度
@property(nonatomic, assign)int priceScale;        //价格精确度

@end

@implementation CurrencyTransactionVC

-(void)loadView{
    [super loadView];
  
    _isFirst = YES;
    [self initVC];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(!self.SHPollinga.runing){
        [self.SHPollinga start];
    }
    
    [self initData];
   
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.SHPollinga pause];
} 

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    self.HandicapDataCount = 10;
    
    [self initSHPolling];
    
    [self addNoticeObserver];
}

#pragma mark - netWork
-(void)initData{
    NSString *defultName = ((AppDelegate *)[UIApplication sharedApplication].delegate).displayName;
    //是否有默认交易对了，有查询这个交易对的，不然直接查全部的获取
    if([HelpManager isBlankString:defultName]){
        //1.先获取基础行情数据
        [self getQutoesData];
    }else{
        [self getAllCoinData:defultName];
    }
}
/**
 获取行情数据
 */
-(void)getQutoesData{
    [self.afnetWork jsonGetDict:@"/api/market/getMarket" JsonDict:nil Tag:@"2"];
}

/**
 获取盘口信息
 */
-(void)getHandicap:(NSString *)markId{
    if(![HelpManager isBlankString:markId]){
        NSMutableDictionary *netDic = [NSMutableDictionary dictionary];
        netDic[@"type"] = @"all";
        netDic[@"market_id"] = markId;
        netDic[@"page"] = @"1";
        netDic[@"page_size"] = @"";
        [self.afnetWork jsonPostSocketDict:@"/api/cc/getQueue" JsonDict:netDic Tag:@"5"];
    }
}
#pragma  mark - 覆盖父类方法
- (void)getHttpData_array:(NSDictionary *)dict response:(Response)flag Tag:(NSString *)tag{
    [MBManager hideAlert];
    if (flag == Success) {
        switch ([dict[@"code"] integerValue]) {
            case 0:
                printAlert(dict[@"msg"], 1.f);
                break;
            case 1:
            {
                NSMutableDictionary *md = [NSMutableDictionary dictionaryWithDictionary:dict];
               if([md[@"data"] isKindOfClass:[NSNull class]]){
                   md[@"data"] = [NSMutableDictionary dictionary];
               }else if([md[@"data"] isKindOfClass:[NSString class]]){
                   md[@"data"] = [NSMutableDictionary dictionary];
               }
               [self dataNormal:md type:tag];
            } 
                break;
            case 200:
            {
                //未登录 不处理
             //   [self jumpLogin];
            }
                break;
            case 201:
                printAlert(LocalizationKey(@"NetWorkErrorTip1"), 1.f);
                break;
            case 300:
            {
                if([[NSString stringWithFormat:@"%@",dict[@"msg"]] containsString:@"KYC1"]){
                    [self jumpKycVC:dict];
                }else{
                    printAlert(dict[@"msg"], 1.f);
                }
            }
                break;
            case 301:
            {
                if([[NSString stringWithFormat:@"%@",dict[@"msg"]] containsString:@"KYC2"]){
                    [self jumpKycVC2:dict];
                }else{
                    printAlert(dict[@"msg"], 1.f);
                }
            }
                break;
            case 400:
            {
                [self jumpAddAccount:dict];
                break;
            }
            default:
                printAlert(dict[@"NetWorkErrorTip2"], 1.f);
                break;
        }
    }
    
}


-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){//钱包情况
        NSString *coinName;
        if(!self.quotesView.isSell){
            coinName = self.quotesView.coinNameDic[@"rightSymbol"];
        }else{
            coinName = self.quotesView.coinNameDic[@"leftSymbol"];
        }
        self.quotesView.moneyNum = NSStringFormat(@"%@",dict[@"data"][@"money"]);

        switch (self.quotesView.CCQuotesTransactionType) {
            case CCQuotesTransactionTypeLimitPrice:
                {
//                    NSString *useableStr = [NSString stringWithFormat:@"可用%@ %@",[ToolUtil stringFromNumber:[dict[@"data"][@"money"] doubleValue] withlimit:self.coinScale],coinName];
                    NSString *useableStr = [NSString stringWithFormat:@"%@%@ %@",LocalizationKey(@"Available"),dict[@"data"][@"money"] ,coinName];
                    self.quotesView.limitPriceView.Useable.text = useableStr;
                    self.quotesView.limitPriceView.moneyNum = NSStringFormat(@"%@",dict[@"data"][@"money"]);

                    if(!self.quotesView.isSell){
                         self.quotesView.limitPriceView.sliderMaxValue.text=[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[dict[@"data"][@"money"] doubleValue]/[self.quotesView.limitPriceView.PriceTF.text doubleValue] withlimit:self.fromScale],self.quotesView.coinNameDic[@"leftSymbol"]];
                    }else{
                         self.quotesView.limitPriceView.sliderMaxValue.text=[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[dict[@"data"][@"money"] doubleValue] withlimit:self.fromScale],coinName];
                    }
                }
                break;
            case CCQuotesTransactionTypeTakeProfitStopLoss:
                break;
            default:
            {
                
                self.quotesView.marketPriceView.moneyNum = NSStringFormat(@"%@",dict[@"data"][@"money"]);

                NSString *useableStr = [NSString stringWithFormat:@"%@%@ %@",LocalizationKey(@"Available"),dict[@"data"][@"money"] ,coinName];
                self.quotesView.marketPriceView.Useable.text = useableStr;
                self.quotesView.marketPriceView.sliderMaxValue.text = [NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[dict[@"data"][@"money"] doubleValue] withlimit:self.fromScale],coinName];
            }
                break;
        }
    }else if ([type isEqualToString:@"2"]){ //行情情况
        [self.scrollView.mj_header endRefreshing];
        NSString *leftSymbol;
        NSString *rightSymbol;
        NSString *display_name;
        NSString *leftCoinId;
        NSString *rightCoinId;
        
        NSMutableArray<QuotesTransactionPairModel *> *listModel = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"data"]) {
        QuotesTradingZoneModel *model = [QuotesTradingZoneModel yy_modelWithDictionary:dic];
            [listModel addObjectsFromArray:model.list];
        }
        if(listModel.count>0){
            display_name = listModel.lastObject.display_name;
            leftSymbol = [display_name componentsSeparatedByString:@"/"][0];
            rightSymbol = [display_name componentsSeparatedByString:@"/"][1];
            leftCoinId = listModel.firstObject.from;
            rightCoinId = listModel.firstObject.to;
            
            self.quotesView.coinNameDic = @{@"leftSymbol":leftSymbol,@"rightSymbol":rightSymbol,@"leftCoinId":leftCoinId,@"rightCoinId":rightCoinId};
            [self.headerView.switchTransactionPairBtn setTitle:[NSString stringWithFormat:@"%@/%@",leftSymbol,rightSymbol] forState:UIControlStateNormal];
            self.headerView.changeNum = [listModel.firstObject.change doubleValue];
            //默认交易对赋值
            ((AppDelegate *)[UIApplication sharedApplication].delegate).displayName = display_name;
            //2.再根据交易对名查看这个交易对的信息
            [self getAllCoinData:display_name];
        }else{
            printAlert(LocalizationKey(@"ccTip1"), 1);
        }
    }else if ([type isEqualToString:@"3"]){ //发布委托
        printAlert(dict[@"msg"], 1);
        //发布成功后输入框内容重置，重新获取委托单列表，查钱包余额
        switch (self.quotesView.CCQuotesTransactionType) {
            case CCQuotesTransactionTypeLimitPrice:
                self.quotesView.limitPriceView.PriceTF.text = @"";
                self.quotesView.limitPriceView.AmountTF.text = @"";
                self.quotesView.limitPriceView.TradeNumber.text = NSStringFormat(@"%@--",LocalizationKey(@"ccTotal"));
            case CCQuotesTransactionTypeTakeProfitStopLoss:
                
                break;
            default:
                self.quotesView.marketPriceView.AmountTF.text = @"";
                self.quotesView.marketPriceView.TradeNumber.text = NSStringFormat(@"%@--",LocalizationKey(@"ccTotal"));
                break;
                break;
        }
        
        [self getCommissionData:self.markId];//刷新表格
        [self getAllCoinData:((AppDelegate *)[UIApplication sharedApplication].delegate).displayName];//重新获取钱包余额
    }else if ([type isEqualToString:@"4"]){ // 获取我发布的委托单列表
//        [self.currentCommissionView.tableView.mj_header endRefreshing];
//        [self.currentCommissionView.tableView.mj_footer endRefreshing];
//        if(self.currentCommissionView.isRefresh){
//            self.currentCommissionView.dataArray=[[NSMutableArray alloc]init];
//        }
        //TODO: 暂时去掉刷新加载，只显示一页的数据
        [self.currentCommissionView.dataArray removeAllObjects];
        for (NSDictionary *dic in dict[@"data"][@"list"]) {
            CurrencyTransactionModel *model = [CurrencyTransactionModel yy_modelWithDictionary:dic];
            [self.currentCommissionView.dataArray addObject:model];
        }
 //       self.allPages = [dict[@"data"][@"page"][@"page_count"] integerValue];
        [self.currentCommissionView.tableView mas_updateConstraints:^(MASConstraintMaker *make) { //55 头部的高度
            make.height.mas_equalTo(self.currentCommissionView.dataArray.count > 0 ? self.currentCommissionView.dataArray.count * 147 + 55 : commissionViewHeight+50);
        }];
        
        [self.currentCommissionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.currentCommissionView.tableView.mas_bottom);
        }];
 
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.currentCommissionView.mas_bottom).with.offset(0);
        }];
        [self.currentCommissionView.tableView reloadData];
    }else if ([type isEqualToString:@"5"]){ //盘口信息
        self.quotesView.bidcontentArr = [NSMutableArray array];
        self.quotesView.askcontentArr = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"data"][@"buy_list"][@"list"]) {
            [self.quotesView.bidcontentArr addObject:dic];
        }
        for (NSDictionary *dic in dict[@"data"][@"sell_list"][@"list"]) {
            [self.quotesView.askcontentArr addObject:dic];
        }
        
        if (self.quotesView.bidcontentArr.count>=self.HandicapDataCount) {
            self.quotesView.bidcontentArr = [NSMutableArray arrayWithArray:[self.quotesView.bidcontentArr subarrayWithRange:NSMakeRange(0, self.HandicapDataCount)]];
        }else{
            int amount= self.HandicapDataCount-(int)self.quotesView.bidcontentArr.count;
            for (int i=0; i<amount; i++) {
                [self.quotesView.bidcontentArr insertObject:@{@"price":@"--",@"total_surplus":@"--"} atIndex:self.quotesView.bidcontentArr.count];
            }
        }
        
        if (self.quotesView.askcontentArr.count>=self.HandicapDataCount) {
            self.quotesView.askcontentArr = [NSMutableArray arrayWithArray:[self.quotesView.askcontentArr subarrayWithRange:NSMakeRange(0, self.HandicapDataCount)]];
        }else{
            int amount= self.HandicapDataCount-(int)self.quotesView.askcontentArr.count;
            for (int i=0; i<amount; i++) {
                [self.quotesView.askcontentArr insertObject:@{@"price":@"--",@"total_surplus":@"--"} atIndex:self.quotesView.askcontentArr.count];
            }
        }
        //对卖盘排序，从高到低
        self.quotesView.askcontentArr = [[NSMutableArray alloc] initWithArray:[self.quotesView.askcontentArr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            
            double price1 = [obj1[@"price"] doubleValue];
            double price2 = [obj2[@"price"] doubleValue];
             
            if (price2 > price1) {
                return NSOrderedDescending;
            } else {
                return NSOrderedAscending;
            }
        }]];
        
        
        // 实时盘口
        double lastPrice = _lastPrice;
        //当前价格
        double currentPrice = [dict[@"data"][@"new_price"] doubleValue];
        _lastPrice = currentPrice;
        self.quotesView.nowPrice.text=[ToolUtil stringFromNumber:currentPrice withlimit:self.priceScale];
        NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
        NSDecimalNumber *close = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",currentPrice]];
        self.quotesView.nowCNY.text=[NSString stringWithFormat:@"≈%.2f CNY",[[close decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:cnyRate]] doubleValue]];
        //当前价格更高，字显示绿涨
        if(currentPrice > lastPrice){
            self.quotesView.nowPrice.textColor = qutesGreenColor;
        }else{
            self.quotesView.nowPrice.textColor = qutesRedColor;
        }
 
        [self.quotesView.BuyTableView reloadData];
        [self.quotesView.SaleTableView reloadData];
    }
}
// 获取我发布的委托单列表
-(void)getCommissionData:(NSString *)markId{
    if(![HelpManager isBlankString:markId]){
        NSMutableDictionary *netDic = [NSMutableDictionary dictionaryWithCapacity:0];
        netDic[@"type"] = @"all";
        netDic[@"order_status"] = @"0"; //挂售中
        netDic[@"market_id"] = markId;
        netDic[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.currentCommissionView.pageIndex];
        netDic[@"page_size"] = @"";
        [self.afnetWork jsonPostSocketDict:@"/api/cc/myCcList" JsonDict:netDic Tag:@"4"];
    }
}


//获取交易对的行情数据
-(void)getAllCoinData:(NSString*)symbol {
    @weakify(self)
    [[ReqestHelpManager share] requestGet:@"/api/market/getMarket" andHeaderParams:nil finish:^(NSDictionary *dicForData, ReqestType flag) {
        @strongify(self) 
        [self.scrollView.mj_header endRefreshing];
        if(flag == Success){
            if(![dicForData[@"data"] isKindOfClass:[NSNull class]]){
                for (NSDictionary *dic in dicForData[@"data"]) {
                     QuotesTradingZoneModel *model = [QuotesTradingZoneModel yy_modelWithDictionary:dic];
                    for (QuotesTransactionPairModel *pairModel in model.list) {
                        //如果这个交易对是要看的交易对
                        if ([pairModel.display_name isEqualToString:symbol]){
                            self.fromScale = pairModel.from_dec;
                            self.toScale = pairModel.to_dec;
                            self.priceScale = pairModel.dec;
                            self.fromId = pairModel.from;
                            self.quotesView.pairModel = pairModel;
                            //这里
                            self.quotesView.nowPrice.text=[ToolUtil stringFromNumber:[pairModel.New_price doubleValue] withlimit:self.priceScale];
                            NSString*cnyRate= [((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate stringValue];
                            NSDecimalNumber *close = [NSDecimalNumber decimalNumberWithString:pairModel.New_price];
                            //这里
                            self.quotesView.nowCNY.text=[NSString stringWithFormat:@"≈%.2f CNY",[[close decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:cnyRate]] doubleValue]];
                           
                            switch (self.quotesView.CCQuotesTransactionType) {
                                case CCQuotesTransactionTypeLimitPrice:
                                    self.quotesView.limitPriceView.PriceTF.text=[ToolUtil stringFromNumber:[pairModel.New_price doubleValue] withlimit:self.priceScale];
                                    self.quotesView.limitPriceView.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f CNY",[self.quotesView.limitPriceView.PriceTF.text doubleValue]*[cnyRate doubleValue]];
                                    self.quotesView.limitPriceView.priceScale = pairModel.dec;
                                    self.quotesView.limitPriceView.fromScale = pairModel.from_dec;
                                    self.quotesView.limitPriceView.toScale = pairModel.to_dec;
                                    break;
                                case CCQuotesTransactionTypeTakeProfitStopLoss:
                                    self.quotesView.takeProfitStopLossView.priceScale = pairModel.dec;
                                    self.quotesView.takeProfitStopLossView.priceScale = pairModel.from_dec;
                                    self.quotesView.takeProfitStopLossView.toScale = pairModel.to_dec;
                                    break;
                                default:
                                    self.quotesView.marketPriceView.PriceTF.text = LocalizationKey(@"Optimal market price");
                                    self.quotesView.marketPriceView.priceScale = pairModel.dec;
                                    self.quotesView.marketPriceView.fromScale = pairModel.from_dec;
                                    self.quotesView.marketPriceView.toScale = pairModel.to_dec;
                                    break;
                            }
                            if (pairModel.change <0) {
                                self.quotesView.nowPrice.textColor = qutesRedColor;
                            }else{
                                self.quotesView.nowPrice.textColor = qutesGreenColor;
                            }
                            if(!self.quotesView.isSell){ //买 获取钱包余额
                                [self getCCWaltWithCoinId:pairModel.to];
                            }else{  //卖
                                [self getCCWaltWithCoinId:pairModel.from];
                            }
                            self.quotesView.coinNameDic = @{@"leftSymbol":pairModel.from_symbol,@"rightSymbol":pairModel.to_symbol,@"leftCoinId":pairModel.from,@"rightCoinId":pairModel.to};
                            [self.headerView.switchTransactionPairBtn setTitle:[NSString stringWithFormat:@"%@/%@",pairModel.from_symbol,pairModel.to_symbol] forState:UIControlStateNormal];
                            self.headerView.changeNum = [pairModel.change doubleValue];
                            //默认交易对赋值
                            ((AppDelegate *)[UIApplication sharedApplication].delegate).displayName = pairModel.display_name;
                            //获取委托信息
                            self.markId = pairModel.market_id;
                            [self getCommissionData:self.markId];
                            //同时获取盘口信息
                            if(self->_isFirst){
                                [self getHandicap:self.markId];
                                self->_isFirst = NO;
                            }
                            
                            return;
                        }
                    }
                }
            }
        }
    }];
}

#pragma mark - CurrencyTransactionQuotesViewDelegate
-(void)getCCWaltWithCoinId:(NSString *)coidId{
    if(![HelpManager isBlankString:coidId]){
         [self.afnetWork jsonGetDict:@"/api/account/getAccountByTypeCoin" JsonDict:@{@"account_type":Coin_Account,@"coin_id":coidId} Tag:@"1"];
    } 
}

-(void)releaseCommissionClick:(NSDictionary *)netDic{
    self.markId = netDic[@"market_id"];
    [self.afnetWork jsonPostDict:@"/api/cc/addCc" JsonDict:netDic Tag:@"3"];
}

#pragma mark - CurrencyTransactionCurrentCommissionViewDelegate
-(void)getCommissonData{
    [self getCommissionData:self.markId];
}

#pragma mark - titleViewDelegate
-(void)didTransactionPairClick:(UIButton *)btn{
    CGRect frame = self.menu.view.frame;
    frame.origin.x = - CGRectGetWidth(self.view.frame);
    self.menu.view.frame = CGRectMake(- CGRectGetWidth(self.view.frame), 0,  ScreenWidth, ScreenHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:self.menu.view];
    [self.menu showFromLeft];
}

#pragma mark - KLlineViewControllerDelegate
- (void)didTrade:(UIButton *)btn TransactionPairName:(NSString *)TransactionPairName fromId:(NSString *)fromId{
    if(btn.tag == 0){
        [self.quotesView chooseBuyClick:self.quotesView.chooseBuyBtn];
    }else{
        [self.quotesView chooseSaleClick:self.quotesView.chooseSaleBtn];
    }
    //默认交易对赋值
    ((AppDelegate *)[UIApplication sharedApplication].delegate).displayName = TransactionPairName;
    if(![self.headerView.switchTransactionPairBtn.titleLabel.text isEqualToString:TransactionPairName]){
        [self getAllCoinData:TransactionPairName]; //获取交易对信息
    }
}

#pragma mark - 通知
-(void)notice:(NSNotification *)notice{
    NSDictionary *dic = notice.userInfo;
    NSString *leftSymbol = dic[@"leftSymbol"];
    NSString *rightSymbol = dic[@"rightSymbol"];
    NSString *displayName = [NSString stringWithFormat:@"%@/%@",leftSymbol,rightSymbol];
    [self.headerView.switchTransactionPairBtn setTitle:displayName forState:UIControlStateNormal];
    self.fromId = dic[@"fromId"];
    self.quotesView.coinNameDic = dic;
    
    NSString *kind = dic[@"kind"];
    if([kind isEqualToString:@"buy"]){
        [self.quotesView chooseBuyClick:self.quotesView.chooseBuyBtn];
    }else if ([kind isEqualToString:@"sell"]){
        [self.quotesView chooseSaleClick:self.quotesView.chooseSaleBtn];
    }else{
        if(!self.quotesView.isSell){
             [self.quotesView chooseBuyClick:self.quotesView.chooseBuyBtn];
        }else{
             [self.quotesView chooseSaleClick:self.quotesView.chooseSaleBtn];
        }
    }
     
    //切换盘口置空
    _isFirst = YES;
    
    self.quotesView.nowPrice.text = @"--";
    self.quotesView.bidcontentArr = [NSMutableArray array];
    self.quotesView.askcontentArr = [NSMutableArray array];
     
    for (int i=0; i<self.HandicapDataCount; i++) {
        [self.quotesView.bidcontentArr insertObject:@{@"price":@"--",@"total_surplus":@"--"} atIndex:self.quotesView.bidcontentArr.count];
    }
    for (int i=0; i<self.HandicapDataCount; i++) {
        [self.quotesView.askcontentArr insertObject:@{@"price":@"--",@"total_surplus":@"--"} atIndex:self.quotesView.askcontentArr.count];
    }
    
    [self.quotesView.BuyTableView reloadData];
    [self.quotesView.SaleTableView reloadData];
     
    //默认交易对赋值
    ((AppDelegate *)[UIApplication sharedApplication].delegate).displayName = displayName;
    //[self getAllCoinData:displayName]; //获取交易对信息
  
    //默认交易对赋值
    ((AppDelegate *)[UIApplication sharedApplication].delegate).displayName = displayName;
    [self getAllCoinData:displayName]; //获取交易对信息
    //获取盘口信息
    if(!_isFirst){
       [self getHandicap:self.markId];
    }
}

-(void)jumpKLineClick:(UIButton *)btn{
    KLlineViewController *klVC = [KLlineViewController new];
    klVC.delegate = self;
    klVC.menuVC = self.menu;
    klVC.fromScale = self.fromScale;
    klVC.toScale = self.toScale;
    klVC.priceScale = self.priceScale;
    klVC.fromId =  self.fromId;
    klVC.TransactionPairName = self.headerView.switchTransactionPairBtn.titleLabel.text;
    [self.navigationController pushViewController: klVC animated:YES];
}

#pragma mark - privateMethod  供子类重写
-(void)initVC{
    //MainTabBarController *tabViewController = (MainTabBarController *)[MainTabBarController cyl_tabBarController];
   // tabViewController.selectedIndex = 2;
}

/**
 //TODO:暂用轮询请求
 */
-(void)initSHPolling{
    __weak typeof(self) weakSelf = self;
    self.SHPollinga = [SHPolling pollingWithInterval:0 block:^(SHPolling *observer,SHPollingStatus pollingStatus) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(POLLIING_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if(!self->_isFirst){
                [weakSelf getHandicap:weakSelf.markId];
                [weakSelf getCommissonData];
                [observer next:pollingStatus];
            }
        });
        
    }];
}

-(void)addNoticeObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:CURRENTSELECTED_SYMBOL object:nil];
}

#pragma mark - ui
-(void)setUpView{
    self.gk_navigationBar.hidden = NO;
    [self.view addSubview:self.scrollView];
    
    [self.view addSubview:self.headerView];
    [self.scrollView addSubview:self.quotesView];
    [self.quotesView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.quotesView.leftView.mas_bottom);
    }];
    
    [self.scrollView addSubview:self.currentCommissionView];
    
    [self.currentCommissionView.tableView mas_updateConstraints:^(MASConstraintMaker *make) { //55 头部的高度
        make.height.mas_equalTo(commissionViewHeight+50);
    }];
    
    [self.currentCommissionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.quotesView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.currentCommissionView.tableView.mas_bottom);
    }];
  
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    [self.currentCommissionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.currentCommissionView.tableView.mas_bottom);
    }];
    
    [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.currentCommissionView.mas_bottom).with.offset(0);
    }];
}
  
#pragma mark - lazyInit
-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth + Height_NavBar, ScreenHeight - Height_TabBar - Height_NavBar)];
        __weak typeof(self) weakSelf = self;
        _scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf initData];
        }];
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

-(CurrencyTransactionTitleView *)headerView{
    if(!_headerView){
        _headerView = [[CurrencyTransactionTitleView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, 50)];
        _headerView.delegate = self;
    } 
    return _headerView;
}

-(CurrencyTransactionQuotesView *)quotesView{
    if(!_quotesView){
        _quotesView = [[CurrencyTransactionQuotesView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 200)];
        _quotesView.delegate = self;
    }
    return _quotesView;
}

-(CurrencyTransactionCurrentCommissionView *)currentCommissionView{
    if(!_currentCommissionView){
        _currentCommissionView = [[CurrencyTransactionCurrentCommissionView alloc] init];
        _currentCommissionView.delegate = self;
        //撤销委托单后，刷新一波钱包
        @weakify(self)
        _currentCommissionView.backRefreshBlock = ^{
            @strongify(self)
            [self initData];
        };
    }
    return _currentCommissionView;
}

-(LeftMenuViewController *)menu{
    if(!_menu){
        _menu = [[LeftMenuViewController alloc] init];
    }
    return _menu;
}

-(void)setFromScale:(int)fromScale{
    _fromScale = fromScale;
    _quotesView.fromScale = fromScale;
    _currentCommissionView.fromScale = fromScale;
    FROMSCALE = fromScale;
}

-(void)setToScale:(int)toScale{
    _toScale = toScale;
    _quotesView.toScale = toScale;
    _currentCommissionView.toScale = toScale;
    TOSCALE = toScale;
}

-(void)setPriceScale:(int)priceScale{
    _priceScale = priceScale;
    _quotesView.priceScale = priceScale;
    _currentCommissionView.priceScale = priceScale;
    PRICESCALE = priceScale;
}

-(void)setMarkId:(NSString *)markId{
    _markId = markId;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).marketId = markId;
}
@end
