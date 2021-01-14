//
//  KLlineViewController.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/5.
//  Copyright © 2019 王涛. All rights reserved.
//  k线图主控制器

#import "KLlineViewController.h"
#import "BaseUIView.h"
#import "Y_StockChartViewController.h"
#import "AppDelegate.h"
#import "kLineHeaderView.h"
#import "KLineCell.h"
#import "Y_StockChartView.h"
#import "Y_KLineGroupModel.h"
#import "AFHTTPSessionManager.h"
#import "DepthHeaderView.h"
#import "DepthSectionOneHeaderView.h"
#import "KLineDepthCell.h"
#import "KLineTradeHeaderView.h"
#import "KLineTradeCell.h"
#import "AppDelegate.h"
#import "WTMainRootViewController.h"
#import "QuotesTransactionPairModel.h"
#import "QuotesTradingZoneModel.h"
#import "SHPolling.h"
#import "KLineIntroductionCell.h"
#import "BlockchainIntroductionModel.h"
#import "IntroductionFooterView.h"
#import "MainTabBarController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "OptionalSymbol+CoreDataClass.h"

const int DataRow = 20; //显示的行数
@interface KLlineViewController ()<Y_StockChartViewDataSource,UITableViewDelegate,UITableViewDataSource,DepthHeaderViewDelegate>
{
    KLineCell   *cell;
    BOOL         isFirst,_depthHasData; //是否第一次加载k线图
   
    UILabel     *_introducCoinName;//简介的币名
    CGFloat      _introducFotterHeight; //简介的高度
    NSString    *_introducContent; //简介内容;
    UIButton    *_optionsSymoblButton;//自选按钮
}
@property (nonatomic, copy) NSMutableDictionary
<NSString*, Y_KLineGroupModel*>                         *modelsDict;
@property (nonatomic, strong) Y_KLineGroupModel         *groupModel;
@property (nonatomic, assign) NSInteger                  currentIndex;
@property (nonatomic, strong) NSString                  *type;
@property(nonatomic, strong) kLineHeaderView            *headerView;
@property(nonatomic, strong) DepthHeaderView            *depthHeaderView;
@property(nonatomic, strong) DepthSectionOneHeaderView  *sectionOneHeaderView;
@property(nonatomic, strong) KLineTradeHeaderView       *tradeHeaderView;
@property(nonatomic, strong) IntroductionFooterView     *introductoinFotterView;
@property(nonatomic, strong) UIButton                   *titleBtn;
@property(nonatomic, strong) SHPolling                  *SHPollinga;
@property(nonatomic, strong) NSString                   *symbol;
//是否点击了成交量按钮，用途，不点击的时候不开启轮询，点击后再开启
@property(nonatomic, assign)  BOOL                       isClickExchangeNumber;
@property(nonatomic, assign)  BOOL                       isScroll;//是否在滑动，在滑动就不让刷新视图
///是否立即刷新视图
@property(nonatomic, assign)  BOOL                       isShouldRefreshNow;
/**
 深度数据源
 */
@property(nonatomic, strong) NSDictionary *depthDic;

/**
 区块链简介数组
 */
@property(nonatomic, strong) NSMutableArray<BlockchainIntroductionModel *> *introductionArray;
/**
 上次获取的最新成交id，用于下次请求使用
 */
@property(nonatomic, assign)  NSNumber *lastId;
/**
   交易对id
 */
@property(nonatomic, strong) NSString  *markedId;
//@property(nonatomic, strong) QuotesTransactionPairModel *pairModel; //获取的当前交易对行情model
/**
 是否显示成交 默认0
 0 显示深度
 1 显示成交
 2 显示简介
 */
@property(nonatomic, assign) int cellSwitchIndex;
@end

@implementation KLlineViewController

@synthesize tableView = _tableView;
@synthesize markedId = _markedId;

- (void)dealloc
{
    NSLog(@"dealloc了");
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.SHPollinga pause];
      
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(!self.SHPollinga.runing){
        [self.SHPollinga start];
    }
  
    //时间栏颜色
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
  //  [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    isFirst = YES;
//    // 显示深度
//    self.cellSwitchIndex = 0;
    [self setUpView];
    [self optionsSymoblStatusSetting];
    //TODO:暂用轮询请求
    __weak typeof(self) weakSelf = self;
    self.SHPollinga = [SHPolling pollingWithInterval:0 block:^(SHPolling *observer,SHPollingStatus pollingStatus) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(POLLIING_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf getAllCoinData:weakSelf.TransactionPairName];
            [weakSelf reloadData:weakSelf.type];
            [weakSelf getHandicap];
//            if(weakSelf.isClickExchangeNumber){
//              [weakSelf getExchangeNumber];
//            }
            [observer next:pollingStatus];
            
        });
        
    }];
    [self switchKlineTime];
    [self getAllCoinData:self.TransactionPairName];
    
    //根据默认时间类型查k线数据
    NSNumber *defalutIndex = [[NSUserDefaults standardUserDefaults] objectForKey:defualtKlineType];
    [self stockDatasWithIndex:[defalutIndex integerValue]];
    [self getHandicap];
  
    // 简介高度
    [self setEmptyIntroductoin];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notice:) name:CURRENTSELECTED_SYMBOL object:nil];
    //切换时间类型的通知，这时候必须要刷新数据，忽视是否在滑动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(switchKlineTime) name:@"tongzhi" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDidScrollNotice:) name:@"scrollViewDidScrollNotice" object:nil];
}

#pragma mark - 通知
-(void)notice:(NSNotification *)notice{
    [MBManager showLoadingInView:self.view];
    self.isShouldRefreshNow = YES;
    NSDictionary *dic = notice.userInfo;
    NSString *leftSymbol = dic[@"leftSymbol"];
    NSString *rightSymbol = dic[@"rightSymbol"];
    NSString *displayName = [NSString stringWithFormat:@"%@/%@",leftSymbol,rightSymbol];
    self.fromId = dic[@"fromId"];
    self.TransactionPairName = displayName;

    //切换币种清一下k线
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
  
    [cell.stockChartView reloadData:groupModel.models];
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

#pragma mark - action
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

/// 选择自选
/// @param button 那个按钮
-(void)didSelectedCustomSybmolClick:(UIButton *)button{
    if(button.isSelected){ //选择下是删除
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            NSPredicate *peopleFilter = [NSPredicate predicateWithFormat:@"marketID IN %@", @[self.markedId]];
            [OptionalSymbol MR_deleteAllMatchingPredicate:peopleFilter inContext:localContext];
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if(!error){
                printAlert(LocalizationKey(@"OptionalSymbolTip3"), 1.f);
                button.selected = NO;
            }else{
                printAlert(LocalizationKey(@"OptionalSymbolTip4"), 1.f);
            }
        }];
    }else{//否则添加自选
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            OptionalSymbol *o = [OptionalSymbol MR_createEntityInContext:localContext];
            o.marketID = [self.markedId integerValue];
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            if(!error){
                printAlert(LocalizationKey(@"OptionalSymbolTip1"), 1.f);
                button.selected = YES;
            }else{
                printAlert(LocalizationKey(@"OptionalSymbolTip2"), 1.f);
            }
        }];
    }
}

//点击tag 0买 1卖
-(void)tradeClick:(UIButton *)btn{
    MainTabBarController *tabViewController = (MainTabBarController *)[MainTabBarController cyl_tabBarController];
    tabViewController.selectedIndex = 2;
    [self.navigationController popToRootViewControllerAnimated:NO];
    
    if([self.delegate respondsToSelector:@selector(didTrade:TransactionPairName:fromId:)]){
        [self.delegate didTrade:btn TransactionPairName:self.TransactionPairName fromId:self.fromId];
     
    }
}

//跳转横版k线
-(void)showFullScreenClick{
    dispatch_async(dispatch_get_main_queue(), ^{
        AppDelegate *appdelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appdelegate.isEable = YES;
        Y_StockChartViewController *stockChartVC = [Y_StockChartViewController new];
        stockChartVC.symbol = self.TransactionPairName;
        stockChartVC.currentIndex = self.currentIndex;
        stockChartVC.kNetSymbol = self.symbol;
        stockChartVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        stockChartVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:stockChartVC animated:YES completion:nil];
    });
  
}

-(void)didTransactionPairClick{
    if(!self.menuVC){
        self.menuVC = [[LeftMenuViewController alloc] init];
    }
    CGRect frame = self.menuVC.view.frame;
    frame.origin.x = - CGRectGetWidth(self.view.frame);
    self.menuVC.view.frame = CGRectMake(- CGRectGetWidth(self.view.frame), 0,  ScreenWidth, ScreenHeight);
    [[UIApplication sharedApplication].keyWindow addSubview:self.menuVC.view];
    [self.menuVC showFromLeft];
}


#pragma mark - netData
/**
 获取盘口信息
 */
-(void)getHandicap{
    if(![HelpManager isBlankString:self.markedId]){
        NSMutableDictionary *netDic = [NSMutableDictionary dictionary];
        netDic[@"type"] = @"all";
        netDic[@"market_id"] = self.markedId;
        netDic[@"page"] = @"1";
        netDic[@"page_size"] = @"100";
        [self.afnetWork jsonPostSocketDict:@"/api/cc/getQueue" JsonDict:netDic Tag:@"4"];
    }
}

//获取交易对的行情数据
-(void)getAllCoinData:(NSString*)symbol {
    __weak typeof(self) weakSelf = self;
    [[ReqestHelpManager share] requestGet:@"/api/market/getMarket" andHeaderParams:nil finish:^(NSDictionary *dicForData, ReqestType flag) {
        if(flag == Success){
            if([dicForData[@"data"] isKindOfClass:[NSArray class]]){
                NSArray *d = dicForData[@"data"];
                for (int i = 0 ; i<d.count; i++) {
                    QuotesTradingZoneModel *model = [QuotesTradingZoneModel yy_modelWithDictionary:d[i]];
//                    if(i < model.list.count){
                        for (QuotesTransactionPairModel *pairModel in model.list) {
                            //如果这个交易对是要看的交易对
                            if ([pairModel.display_name isEqualToString:symbol]){
                                //设置头部数据源
                                weakSelf.headerView.model = pairModel;
                                weakSelf.markedId = pairModel.market_id;

                                return;
                            }
                        }
//                    }
                }
            } 
        }
    }];
}


//  K线数据
- (void)reloadData:(NSString*)type
{
    if ([type isEqualToString:@"1min"]) {
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2)]] withResolution:@"1min"];
    }
    else if ([type isEqualToString:@"5min"])
    {
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*5)]] withResolution:@"5min"];
    }
    else if ([type isEqualToString:@"30min"])
    {
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*30)]] withResolution:@"30min"];
    }
    else if ([type isEqualToString:@"1hour"])
    {
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*60)]] withResolution:@"1h"];
    }
    else if ([type isEqualToString:@"1day"])
    {
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*24*60)]] withResolution:@"1day"];
    }
    else if ([type isEqualToString:@"1week"])
    {
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*24*60*7)]] withResolution:@"1week"];
    }
    else if ([type isEqualToString:@"15min"])
    {
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*15)]] withResolution:@"15min"];
    }
    else if ([type isEqualToString:@"1month"])
    {
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*24*60)]] withResolution:@"1month"];
    }else{
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2)]] withResolution:@"1min"];
    }
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    //NSLog(@"查看isScroll:%d",self.isScroll);
    if(self.isShouldRefreshNow){
        [MBManager hideAlert];
        self.isScroll = NO;
        self.isShouldRefreshNow = NO;
    }
    //正在滑动并且有盘口数据了就return掉
    if(self.isScroll && _depthHasData){
        return;
    }
    if([type isEqualToString:@"1"]){
        NSArray *netArray = dict[@"data"];
        if([netArray isKindOfClass:[NSArray class]]){
            if(netArray.count>0){
                Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:netArray];
                self.groupModel = groupModel;
                [self.modelsDict setObject:groupModel forKey:self.type];
                NSLog(@"%@",groupModel);
 
                [cell.stockChartView reloadData:self.groupModel.models];
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
              
                [cell.stockChartView reloadData:groupModel.models];
            }
        } 
    }else if ([type isEqualToString:@"2"]){
        [self.dataArray removeAllObjects];
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithDictionary:dict];
        if([md[@"data"] isKindOfClass:[NSString class]]){
            md[@"data"] = @{};
        }
        for (NSDictionary *dic in md[@"data"]) {
            [self.dataArray addObject:dic];
        } 
        if (self.dataArray.count<DataRow) {
            int amount=DataRow-(int)self.dataArray.count;
            for (int i=0; i<amount; i++) {
                [self.dataArray insertObject:@{@"id":@-1,@"order_type":@-1,@"amount":@-1,@"addtime":@-1,@"price":@-1} atIndex:self.dataArray.count];
            }
        }else{
            self.dataArray = [NSMutableArray arrayWithArray:[self.dataArray subarrayWithRange:NSMakeRange(0, DataRow)]];
        }
        self.lastId = [self.dataArray lastObject][@"id"];
        
        [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }else if ([type isEqualToString:@"3"]){
        //币简介
        BlockchainIntroductionModel *model = [BlockchainIntroductionModel yy_modelWithDictionary:dict[@"data"]];
        _introducCoinName.text = model.title;
        //简介高度
        _introducContent = model.detail;
        //30 + 30 + 20 内部空间的间距高度。 + 40 距离底部的距离
        _introducFotterHeight = [HelpManager getMultiLineWithFont:16 andText:_introducContent textWidth:ScreenWidth-40] + 30 + 30 + 20 + 40 ;
        [self.introductoinFotterView setTextStr:_introducContent bacHeight:_introducFotterHeight];
        
        [self.introductionArray addObject:model];
        [self.tableView reloadData];
    }else if([type isEqualToString:@"4"]){
        _depthHasData = YES;
        self.depthDic = [NSDictionary dictionaryWithDictionary:dict[@"data"]];
        
//        self.depthDic = @{@"data":@{@"buy_list":@{@"list":@[@{@"price":@"11625",@"total_surplus":@"0.01234567"},
//                                                            @{@"price":@"11625",@"total_surplus":@"0.01234567"},@{@"price":@"11625",@"total_surplus":@"0.01234567"},@{@"price":@"11625",@"total_surplus":@"0.01234567"}]},
//           @"sell_list":@{@"list":@[@{@"price":@"11625",@"total_surplus":@"0.01234567"},@{@"price":@"11625",@"total_surplus":@"0.01234567"},@{@"price":@"11625",@"total_surplus":@"0.01234567"},@{@"price":@"11625",@"total_surplus":@"0.01234567"}]}
//
//                                    }
//                          }; //[NSDictionary dictionaryWithDictionary:dict[@"data"]] ;
        
        NSArray *nameArray = [self.TransactionPairName componentsSeparatedByString:@"/"];
    
        [self.sectionOneHeaderView setCoinName:nameArray[0] rightName:nameArray[1] depthDic:[NSDictionary dictionaryWithDictionary:dict[@"data"]] priceScale:self.priceScale fromScale:self.fromScale];
        [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }
 
}

//获取成交记录
-(void)getExchangeNumber{
    NSMutableDictionary *netDic = [NSMutableDictionary dictionary];
    netDic[@"market_id"] = self.markedId;
    netDic[@"last_id"] = self.lastId;
    [self.afnetWork jsonPostSocketDict:@"/api/cc/getDealList" JsonDict:netDic Tag:@"2"];
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

#pragma mark - tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 1;
    }else if (section == 1){
        if(self.cellSwitchIndex == 2)
        {
            return 7;
        }
    }
    return DataRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        static NSString *identifier = @"cell";
        [self.tableView registerClass:[KLineCell class] forCellReuseIdentifier:identifier];
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[KLineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if(isFirst){
            cell.stockChartView.dataSource = self;
            isFirst =  NO;
        }
        return cell;
    }else{
        if(self.cellSwitchIndex == 1){  //成交量cell
            static NSString *identifier = @"cell2";
            [self.tableView registerClass:[KLineTradeCell class] forCellReuseIdentifier:identifier];
            KLineTradeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                cell = [[KLineTradeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            if(self.dataArray.count>0){
               [cell setCellData:self.dataArray[indexPath.row] priceScale:self.priceScale fromScale:self.fromScale];
            }
            return cell;
        }else if(self.cellSwitchIndex == 0){ //深度cell
            static NSString *identifier = @"cell1";
            [self.tableView registerClass:[KLineDepthCell class] forCellReuseIdentifier:identifier];
            KLineDepthCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if(!cell){
                cell = [[KLineDepthCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            NSInteger newIndex = 1;
            cell.BuyIndex.text=[NSString stringWithFormat:@"%ld",(long)(indexPath.row + newIndex)];
            cell.SellIndex.text=[NSString stringWithFormat:@"%ld",(long)(indexPath.row + newIndex)];
            if(self.depthDic.count > 0){
                [cell setCellData:self.depthDic cellIndex:indexPath.row priceScale:self.priceScale fromScale:self.fromScale];
            }
            return cell; 
        }else{ //简介cell
            static NSString *identifier = @"cell3";
            KLineIntroductionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            [self.tableView registerClass:[KLineIntroductionCell class] forCellReuseIdentifier:identifier];
            if(!cell){
                cell = [[KLineIntroductionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            [cell setCellData:self.introductionArray cellIndex:indexPath.row];

            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 1){
        if(self.cellSwitchIndex == 2){
            if(self.introductionArray.count > 0){
                BlockchainIntroductionModel *model = self.introductionArray[0];
                if(indexPath.row == 4){
                    [self copyIntroductionInfo:model.white_book];
                }else if (indexPath.row == 5){
                    [self copyIntroductionInfo:model.url];
                }else if (indexPath.row == 6){
                    [self copyIntroductionInfo:model.block_url];
                }
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return 410;
    }else{
        if(self.cellSwitchIndex == 2){
            return 50;
        }
//        if(self.cellSwitchIndex == 0){
//            return 40;
//        }else{
            return  40;//38.667;
      //  }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 1){
        if(self.cellSwitchIndex == 1){
            return self.tradeHeaderView;
        }else if(self.cellSwitchIndex == 0){
            return self.sectionOneHeaderView;
        }else if(self.cellSwitchIndex == 2){
            UIView *bac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth , 60)];
            bac.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
            line.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
            [bac addSubview:line];
            _introducCoinName = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, ScreenWidth-15, 59)];
            _introducCoinName.text = [self.TransactionPairName componentsSeparatedByString:@"/"][0];
            _introducCoinName.theme_textColor = THEME_TEXT_COLOR;
            _introducCoinName.backgroundColor = bac.backgroundColor;
            _introducCoinName.layer.masksToBounds = YES;
            _introducCoinName.font = tFont(20);
            [bac addSubview:_introducCoinName];
                
            return bac;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 1){
        if(self.cellSwitchIndex == 2){
            return 60;
        }else if (self.cellSwitchIndex == 0){
            return 40+ 230;
        }
        return 40;
    }
    return CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
       return self.depthHeaderView;
    }else{
        if(self.cellSwitchIndex == 2){
            return self.introductoinFotterView;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return 50;
    }else{
        if(self.cellSwitchIndex == 2){
            return self.introductoinFotterView.height;
        }
    }
    return CGFLOAT_MIN;
}

#pragma mark - stockChartViewDelegate
//切换k线类型
-(id)stockDatasWithIndex:(NSInteger)index
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

#pragma mark - depthHeaderViewDeleagte
-(void)didSwitchDeepthClick:(UIButton *)btn{
    switch (btn.tag) {
        case 0:  //深度图数据
            self.cellSwitchIndex = 0;
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
            break;
        case 1:   // 成交量数据
            self.cellSwitchIndex = 1;
           // if(!self.isClickExchangeNumber){
               [self getExchangeNumber];
            //   self.isClickExchangeNumber = YES;
           // }
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
            break;
        default://简介数据
            self.cellSwitchIndex = 2;
            if(self.introductionArray.count == 0){
                if(![HelpManager isBlankString:self.fromId]){
                    [self.afnetWork jsonPostDict:@"/api/coin/getCoinInfo" JsonDict:@{@"coin_id":self.fromId} Tag:@"3"];
                }else{
                    printAlert(LocalizationKey(@"NetWorkErrorTip"), 1.f);
                }
            }
            [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
            break;
    }
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

#pragma mark - util
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}
- (BOOL)shouldAutorotate
{
    return NO;
}


#pragma mark - ui
-(void)setUpView{
    UIBarButtonItem *left = [UIBarButtonItem gk_itemWithImage:[UIImage imageNamed:@"top_bar_back_nomal1"] target:self action:@selector(back)];
    
    CGSize titleSize = [HelpManager getLabelWidth:18 labelTxt:self.TransactionPairName];
    
    BaseUIView *titleView = [[BaseUIView alloc] initWithFrame:CGRectMake(100, 0, titleSize.width+70, Height_NavBar)];
    titleView.intrinsicContentSize = CGSizeMake(titleSize.width+70, Height_NavBar);
    
    [titleView addSubview:self.titleBtn];
    [self.titleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(titleView.mas_centerY);
        make.centerX.mas_equalTo(titleView.centerX).offset(0);
    }];
    
 //   UIBarButtonItem *left1 = [[UIBarButtonItem alloc] initWithCustomView:titleView];
    self.gk_navigationItem.titleView = titleView;
    [titleView sizeToFit];
 
    self.gk_navItemLeftSpace = OverAllLeft_OR_RightSpace;
    self.gk_navigationItem.leftBarButtonItems = @[left];
   
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"kline_zoom"] style:UIBarButtonItemStyleDone target:self action:@selector(showFullScreenClick)];
    
//    _optionsSymoblButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_optionsSymoblButton setImage:[UIImage imageNamed:@"start1"] forState:UIControlStateNormal];
//    [_optionsSymoblButton setImage:[UIImage imageNamed:@"start2"] forState:UIControlStateSelected];
//    [_optionsSymoblButton addTarget:self action:@selector(didSelectedCustomSybmolClick:) forControlEvents:UIControlEventTouchUpInside];
//
//    UIBarButtonItem *rightBarBtn2 = [[UIBarButtonItem alloc] initWithCustomView:_optionsSymoblButton];
//
    self.gk_navigationItem.rightBarButtonItems = @[rightBtn];
  
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - 70 - 0, ScreenWidth, 70 )];
  //  [bottomView setTheme_backgroundColor:@"bac_cell"];
    bottomView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    [self.view addSubview:bottomView];
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setTitle:LocalizationKey(@"BUY") forState:UIControlStateNormal];
    buyBtn.backgroundColor = qutesGreenColor;
    if(IS_IPHONE_X){
        buyBtn.frame = CGRectMake(15, 5, ScreenWidth/2 - 20 , 45);
    }else{
        buyBtn.frame = CGRectMake(15, 12.5, ScreenWidth/2 - 20 , 45);
    }
    buyBtn.layer.cornerRadius = 2;
    buyBtn.layer.masksToBounds = YES;
    buyBtn.tag = 0;
    [bottomView addSubview:buyBtn];
    UIButton *sellBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sellBtn setTitle:LocalizationKey(@"SELL") forState:UIControlStateNormal];
    sellBtn.backgroundColor = qutesRedColor;
    if(IS_IPHONE_X){
        sellBtn.frame = CGRectMake(ScreenWidth - 15 - (ScreenWidth/2 - 20 ), 5, ScreenWidth/2 - 20 , 45);
    }else{
        sellBtn.frame = CGRectMake(ScreenWidth - 15 - (ScreenWidth/2 - 20 ), 12.5, ScreenWidth/2 - 20 , 45);
    }
    sellBtn.layer.cornerRadius = 2;
    sellBtn.layer.masksToBounds = YES;
    sellBtn.tag = 1;
    [bottomView addSubview:sellBtn];
    [buyBtn addTarget:self action:@selector(tradeClick:) forControlEvents:UIControlEventTouchUpInside];
    [sellBtn addTarget:self action:@selector(tradeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar - bottomView.ly_height);
    [self.tableView setTableHeaderView:self.headerView];
    [self.view bringSubviewToFront:bottomView];
}

#pragma mark - privateMehtod
/**
 空简介设置
 */
-(void)setEmptyIntroductoin{
    // 简介高度
    _introducContent = LocalizationKey(@"No");
    //30 + 30 + 20 内部空间的间距高度。 + 40 距离底部的距离
    _introducFotterHeight = [HelpManager getMultiLineWithFont:16 andText:_introducContent textWidth:ScreenWidth-40] + 30 + 30 + 20 + 40 ;
    [self.introductoinFotterView setTextStr:_introducContent bacHeight:_introducFotterHeight];
}

/**
 简介复制

 @param content 复制内容
 */
-(void)copyIntroductionInfo:(NSString *)content{
    if(![HelpManager isBlankString:content]){
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = content;
        printAlert(LocalizationKey(@"Copy1"), 1.f);
    }
}

/// 设置自选按钮状态
-(void)optionsSymoblStatusSetting{
    NSArray<OptionalSymbol *> *sqliteArray = [OptionalSymbol MR_findAll];
    for (OptionalSymbol *optionSymbol in sqliteArray) {
        if(optionSymbol.marketID == [self.markedId integerValue]){
            _optionsSymoblButton.selected = YES;
            break; 
        }else{
            _optionsSymoblButton.selected = NO;
        }
    }
}

#pragma mark - lazyInit
-(WTTableView *)tableView{
    if(!_tableView){
        _tableView = [[WTTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - Height_NavBar - 70) style:UITableViewStyleGrouped];
        
        _tableView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
       // _tableView.estimatedRowHeight = 50;
        _tableView.bounces = NO;
       // _tableView.rowHeight = UITableViewAutomaticDimension;
       //  [_tableView setTheme_backgroundColor:THEME_MAIN_BACKGROUNDCOLOR];
       _tableView.estimatedRowHeight = 0;
       _tableView.estimatedSectionHeaderHeight = 0;
       _tableView.estimatedSectionFooterHeight = 0;
       
    }
    return _tableView;
}
 

-(kLineHeaderView *)headerView{
    if(!_headerView){
        _headerView = [[kLineHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    }
    return _headerView;
}

- (NSMutableDictionary<NSString *,Y_KLineGroupModel *> *)modelsDict
{
    if (!_modelsDict) {
        _modelsDict = @{}.mutableCopy;
    }
    return _modelsDict;
}

-(DepthHeaderView *)depthHeaderView
{
    if(!_depthHeaderView){
        _depthHeaderView = [[DepthHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
        _depthHeaderView.deleagte = self;
    }
    return _depthHeaderView;
}

-(DepthSectionOneHeaderView *)sectionOneHeaderView{
    if(!_sectionOneHeaderView){
        _sectionOneHeaderView = [[DepthSectionOneHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40 + 230)];
    }
    return _sectionOneHeaderView;
}

-(KLineTradeHeaderView *)tradeHeaderView{
    if(!_tradeHeaderView){
        _tradeHeaderView = [[KLineTradeHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    }
    return _tradeHeaderView;
}

-(UIButton *)titleBtn{
    if(!_titleBtn){
        _titleBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0 , -5);
        _titleBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
        [_titleBtn theme_setTitleColor:THEME_TEXT_COLOR forState:UIControlStateNormal];
        [_titleBtn addTarget:self action:@selector(didTransactionPairClick) forControlEvents:UIControlEventTouchUpInside]; 
        [_titleBtn setImage:[UIImage imageNamed:@"transaction_3"] forState:UIControlStateNormal];
        
    }
    return _titleBtn;
}

/**
 切换交易对后重新获取页面信息

 @param TransactionPairName 交易对名
 */
-(void)setTransactionPairName:(NSString *)TransactionPairName{
    if([HelpManager isBlankString:TransactionPairName]){
         _TransactionPairName = @"";
        self.symbol = @"";
    }else{
         _TransactionPairName = TransactionPairName;
        ((AppDelegate *)[UIApplication sharedApplication].delegate).displayName = TransactionPairName;
         [self.titleBtn setTitle:_TransactionPairName forState:UIControlStateNormal];
         [self getAllCoinData:_TransactionPairName];
         NSArray *nameArray = [TransactionPairName componentsSeparatedByString:@"/"];
        
         self.symbol = [NSString stringWithFormat:@"%@_%@",nameArray[0],nameArray[1]];
         [self.tradeHeaderView setPriceStr:nameArray[1] amountStr:nameArray[0]];
         [self.sectionOneHeaderView setCoinName:nameArray[0] rightName:nameArray[1] depthDic:@{} priceScale:self.priceScale fromScale:self.fromScale];
         //重置下边列表，默认显示深度的
         [self.depthHeaderView deepthClick:self.depthHeaderView.deepthBtn];
         //切换币种后清除简介信息，等待获取到fromId后再显示
         [self.introductionArray removeAllObjects];
         [self setEmptyIntroductoin];
         [self.tableView reloadSection:1 withRowAnimation:UITableViewRowAnimationNone];
    }
}
//设置交易对左边id
-(void)setFromId:(NSString *)fromId{
    _fromId = fromId;
}

/**
 获取交易对id变量，如果是空的，从appdelegate中获取
 ，否则赋值
 @param markedId 交易对id
 */
-(void)setMarkedId:(NSString *)markedId{
     _markedId = markedId;
      [self optionsSymoblStatusSetting];
}

-(NSString *)markedId{
    if(!_markedId){
        if(![HelpManager isBlankString:((AppDelegate *)[UIApplication sharedApplication].delegate).marketId]){
            _markedId = ((AppDelegate *)[UIApplication sharedApplication].delegate).marketId;
        }else{
            _markedId = @"";
        }
    }
    return _markedId;
}

-(NSMutableArray *)introductionArray{
    if(!_introductionArray){
        _introductionArray = [NSMutableArray array];
    }
    return _introductionArray;
}

-(IntroductionFooterView *)introductoinFotterView{
    if(!_introductoinFotterView){
        _introductoinFotterView = [[IntroductionFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _introducFotterHeight)];
    }
    return _introductoinFotterView;
}

-(void)setIsScroll:(BOOL)isScroll{
    _isScroll = isScroll;
}


@end
