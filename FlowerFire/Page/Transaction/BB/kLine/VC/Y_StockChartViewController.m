//
//  YStockChartViewController.m
//  BTC-Kline
//
//  Created by yate1996 on 16/4/27.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import "Y_StockChartViewController.h" 
#import "QuotesTradingZoneModel.h"
//#import "NetWorking.h"
#import "Y_KLineGroupModel.h"
#import "UIColor+Y_StockChart.h"
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "Y_StockChartHorizontalView.h"

#import "SHPolling.h"
@interface Y_StockChartViewController ()<Y_StockChartViewDataSource,Y_StockChartHorizontalViewDelegate>

@property (nonatomic, strong) Y_KLineGroupModel          *groupModel;
@property (nonatomic, copy)   NSMutableDictionary
<NSString*, Y_KLineGroupModel*>                          *modelsDict;
@property(nonatomic, strong)  Y_StockChartHorizontalView *horizontalView;
@property (nonatomic, copy)   NSString                   *type;
@property(nonatomic, strong)  SHPolling                  *SHPollinga;
///是否立即刷新视图
@property(nonatomic, assign)  BOOL                       isShouldRefreshNow;
@property(nonatomic, assign)  BOOL                       isScroll;//是否在滑动，在滑动就不让刷新视图
@end

@implementation Y_StockChartViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    if(!self.SHPollinga.runing){
        [self.SHPollinga start];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    
      [self.SHPollinga pause];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.gk_navigationBar.hidden = YES;
    //[self.view setTheme_backgroundColor:@"bac_cell"];
    self.view.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    self.horizontalView = [[Y_StockChartHorizontalView alloc] initWithFrame:CGRectMake(0, 0, ScreenHeight, ScreenWidth)]; 
    self.horizontalView.delegate = self;
    if(self.currentIndex > 0){
        self.horizontalView.stockChartView.DefalutselectedIndex = self.currentIndex;
    }else{
        self.horizontalView.stockChartView.DefalutselectedIndex = 1;
    }
    self.horizontalView.currentIndex = self.horizontalView.stockChartView.DefalutselectedIndex;
    self.horizontalView.stockChartView.dataSource = self;
    
    self.horizontalView.symbolLabel.text = self.symbol;
    
    [self.view addSubview:self.horizontalView];
    
    //TODO:暂用轮询请求
    __weak typeof(self) weakSelf = self;
    self.SHPollinga = [SHPolling pollingWithInterval:0 block:^(SHPolling *observer,SHPollingStatus pollingStatus) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(POLLIING_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
           [weakSelf getAllCoinData:weakSelf.symbol];
            [weakSelf reloadData:weakSelf.type];
            [observer next:pollingStatus];
            
        });
        
    }];
    
    [self getAllCoinData:self.symbol];
    [self reloadData:self.type];
    
    [self switchKlineTime];
    //切换时间类型的通知，这时候必须要刷新数据，忽视是否在滑动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchKlineTime) name:@"tongzhi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDidScrollNotice:) name:@"scrollViewDidScrollNotice" object:nil];
}

-(void)switchKlineTime{
    [MBManager showLoadingInView:self.view];
    self.isShouldRefreshNow = YES;
}

//k线滑动时候的通知
-(void)scrollViewDidScrollNotice:(NSNotification *)notice{
    NSDictionary *dic = notice.userInfo;
    if ([dic[@"isScroll"] isEqualToString:@"1"]) {
        self.isScroll = YES;
    }else{
        self.isScroll = NO;
    }
}

//获取交易对的行情数据
-(void)getAllCoinData:(NSString*)symbol {
    __weak typeof(self) weakSelf = self;
    [[ReqestHelpManager share] requestGet:@"/api/market/getMarket" andHeaderParams:nil finish:^(NSDictionary *dicForData, ReqestType flag) {
        if(flag == Success){
            if(![dicForData[@"data"] isKindOfClass:[NSNull class]]){
                NSArray *d = dicForData[@"data"];
                for (int i = 0 ; i<d.count; i++) {
                    QuotesTradingZoneModel *model = [QuotesTradingZoneModel yy_modelWithDictionary:d[i]];
                    if(i < model.list.count){
                        for (QuotesTransactionPairModel *pairModel in model.list) {
                            //如果这个交易对是要看的交易对
                            if ([pairModel.display_name isEqualToString:symbol]){
                                //设置头部数据源
                                weakSelf.horizontalView.model = pairModel;
                                return;
                            }
                        }
                    }
                }
            }
            
        }
    }];
}


#pragma mark - Y_StockChartViewDataSource
-(id) stockDatasWithIndex:(NSInteger)index
{
    NSString *type;
    
    
    switch (index) {
        case 0:
        {
            type = @"1min";
        }
            break;
        case 1:
        {
            type = @"1min";//分时
        }
            break;
        case 2:
        {
            type = @"1min";//1分
        }
            break;
        case 3:
        {
            type = @"5min";//5分钟
        }
            break;
        case 4:
        {
            type = @"1hour";//1小时
        }
            break;
        case 5:
        {
            type = @"1day";//1天
        }
            break;
        case 6:
        {
            type = @"15min";//15分钟
            
        }
            break;
        case 7:
        {
            type = @"30min";//30分钟
        }
            break;
        case 8:
        {
            type = @"1week";//1周
        }
            break;
        case 9:
        {
            type = @"1month";//1月
        }
            break;
        default:
            break;
    }
    self.currentIndex = index;
    self.type = type;
    [self reloadData:type];
  
    return nil;
}

- (void)reloadData:(NSString *)type
{
    if ([type isEqualToString:@"1min"]) {
        [self getDatawithSymbol:self.kNetSymbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2)]] withResolution:@"1min"];
    }
    else if ([type isEqualToString:@"5min"])
    {
        [self getDatawithSymbol:self.kNetSymbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*5)]] withResolution:@"5min"];
    }
    else if ([type isEqualToString:@"30min"])
    {
        [self getDatawithSymbol:self.kNetSymbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*30)]] withResolution:@"30min"];
    }
    else if ([type isEqualToString:@"1hour"])
    {
        [self getDatawithSymbol:self.kNetSymbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*60)]] withResolution:@"1h"];
    }
    else if ([type isEqualToString:@"1day"])
    {
        [self getDatawithSymbol:self.kNetSymbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*24*60)]] withResolution:@"1day"];
    }
    else if ([type isEqualToString:@"1week"])
    {
        [self getDatawithSymbol:self.kNetSymbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*24*60*7)]] withResolution:@"1week"];
    }
    else if ([type isEqualToString:@"15min"])
    {
        [self getDatawithSymbol:self.kNetSymbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*15)]] withResolution:@"15min"];
    }
    else if ([type isEqualToString:@"1month"])
    {
        [self getDatawithSymbol:self.kNetSymbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*24*60)]] withResolution:@"1month"];
    }else{
        
    }
//    NSMutableDictionary *param = [NSMutableDictionary dictionary];
//    param[@"type"] = type;
//    param[@"market"] = @"btc_usdt";
//    param[@"size"] = @"100";
//
//
//    AFHTTPSessionManager *manager= [AFHTTPSessionManager shareManager];
//    manager.requestSerializer=[AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
//                                                                              @"text/html",
//                                                                              @"text/json",
//                                                                              @"text/plain",
//                                                                              @"text/javascript",
//                                                                              @"text/xml",
//                                                                              @"image/*"]];
//
//    [manager GET:@"http://api.bitkk.com/data/v1/kline" parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if([responseObject isKindOfClass:[NSData class]]){
//            NSError *error;
//            NSString * str  =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//
//            //      NSString * transStr = [self removeUnescapedCharacter:str];
//            NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary *resdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
//            if([resdic isKindOfClass:[NSDictionary class]]){
//                if(![[resdic allKeys] containsObject:@"result"] && ![[resdic allKeys] containsObject:@"error"]){
//                    Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:resdic[@"data"]];
//                    self.groupModel = groupModel;
//                    [self.modelsDict setObject:groupModel forKey:self.type];
//                    NSLog(@"%@",groupModel);
//                    [self.horizontalView.stockChartView reloadData:self.groupModel.models];
//                }
//            }else{
//                Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:@[@{@"data":@[@[@1559923200000,@"7926.96",@"8448.459999999999",@"7518.13",@"8394.18",@"94527.85520000001"],@[@1559923200000,@"7926.96",@"8448.459999999999",@"7518.13",@"8394.18",@"94527.85520000001"]],@"moneyType":@"USDT",@"symbol":@"btc"}]];
//                self.groupModel = groupModel;
//                [self.modelsDict setObject:groupModel forKey:self.type];
//                NSLog(@"%@",groupModel);
//                [self.horizontalView.stockChartView reloadData:self.groupModel.models];
//            }
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//
//    }];
    
}


-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if(self.isShouldRefreshNow){
        [MBManager hideAlert];
        self.isScroll = NO;
        self.isShouldRefreshNow = NO;
    }
    if(self.isScroll){
        return;
    }
    if([type isEqualToString:@"1"]){
        NSArray *netArray = dict[@"data"];
        if([netArray isKindOfClass:[NSArray class]]){
            if(netArray.count>0){
                Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:netArray];
                self.groupModel = groupModel;
                [self.modelsDict setObject:groupModel forKey:self.type];
               // NSLog(@"%@",groupModel);
                [self.horizontalView.stockChartView reloadData:self.groupModel.models];
            }else{
                NSMutableArray *klineArray = [NSMutableArray array];
                for (int i = 0; i<6; i++) {
                    [klineArray addObject:@[@0,
                                            @0,
                                            @0,
                                            @0,
                                            @0,
                                            @0]];
                }
                Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:klineArray];
                
                [self.horizontalView.stockChartView reloadData:groupModel.models];
            }
        }
    }
}

/**
 获取k线数据
 
 @param symbol 交易名  例：btc_usdt
 @param time  开始时间
 
 @param resolution 时间粒度:1min=1分钟,5min=5分钟,15min=15分钟,30min=30分钟,1h=1小时,1day=1天,1week=1周,1month=1月
 
 */
-(void)getDatawithSymbol:(NSString*)symbol withFromtime:(NSString*)time withResolution:(NSString*)resolution{
    NSMutableDictionary *netDic = [NSMutableDictionary dictionary];
    netDic[@"symbol"] = symbol;
    netDic[@"period"] = resolution;
    netDic[@"from"] = time;
    netDic[@"to"] = [self getStringWithDate:[NSDate date]];
    [self.afnetWork jsonGetSocketDict:@"/api/kline/history" JsonDict:netDic Tag:@"1"];
}

-(NSString*)getStringWithDate:(NSDate*)date{
    NSTimeInterval nowtime = [date timeIntervalSince1970];
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    return  [NSString stringWithFormat:@"%llu",theTime];//当前时间的毫秒数
}

#pragma mark - Y_StockChartHorizontalViewDelegate
- (void)dismiss
{
    AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdelegate.isEable = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotate
{
    return NO;
}

- (NSMutableDictionary<NSString *,Y_KLineGroupModel *> *)modelsDict
{
    if (!_modelsDict) {
        _modelsDict = @{}.mutableCopy;
    }
    return _modelsDict;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidEndDragging:(nonnull UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(decelerate == NO){
        [self scrollViewDidEndDecelerating:scrollView];
    }else{
    }
}

- (void)scrollViewDidEndDecelerating:(nonnull UIScrollView *)scrollView
{
    self.isScroll = NO;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.isScroll = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
@end
