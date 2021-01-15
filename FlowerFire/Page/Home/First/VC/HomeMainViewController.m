//
//  HomeMainViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/4/27.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "HomeMainViewController.h"
#import "HomeNavigationView.h"
#import "HomeTableHeaderView.h"
#import "QuotesPageCell.h"
#import "NewVersionModel.h"
#import "NoteModel.h"
#import "SHPolling.h"
#import "MainTabBarController.h"
#import "HomeSkidVC.h"
#import "FFAcountManager.h"
#import "WTMainRootViewController.h"
NSArray *NoticeListArray;
@interface HomeMainViewController ()<UITableViewDelegate,UITableViewDataSource,HomeNavigationViewDelegate>

@property(nonatomic, assign) CGFloat                                      navigationViewHeight;
@property(nonatomic, strong) UITableView                                  *tableView;
@property(nonatomic, strong) HomeTableHeaderView                          *tableHeaderView;
@property(nonatomic, strong) NSMutableArray<QuotesTransactionPairModel *> *modelArray;
@property(nonatomic, strong) NSMutableArray<NSDictionary *>               *bannberArray;
@property(nonatomic, strong) SHPolling                                    *SHPollinga;
@property(nonatomic, strong) HomeSkidVC                                   *skidVC;
@end

@implementation HomeMainViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.SHPollinga pause];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //没获取到汇率继续获取
    if([((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate doubleValue] == 0){
        [self getUSDTToCNYRate];
    }
    if(!self.SHPollinga.runing){
        [self.SHPollinga start];
    }
    
    [self updateGoogleCodeStatus];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(![WTUserInfo isLogIn]){
        [self jumpLogin];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WTMainRootViewController *rootVC = (WTMainRootViewController *)UIApplication.sharedApplication.keyWindow.rootViewController;
    rootVC.navigationBar.hidden = YES;
    [self createNavBar];
    
    [self createUI];
    
    __weak typeof(self)weakSelf = self;
    self.SHPollinga = [SHPolling pollingWithInterval:0 block:^(SHPolling *observer,SHPollingStatus pollingStatus) {
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(POLLIING_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
               [weakSelf initData];
               [observer next:pollingStatus];
           });
    }];
       
    [self checkNewVersion];
    [self initData];
    [self getUSDTToCNYRate]; 
}

/// 更新谷歌验证状态
-(void)updateGoogleCodeStatus{
    if([WTUserInfo isLogIn]){
        [self.afnetWork jsonGetSocketDict:@"/api/user/index" JsonDict:nil Tag:@"4"];
    }
}

/**
 检查新版本
 version    string    1.1.1
 version_code    int    例如:111
 type    int     类型1：安卓 2：ios
 */
-(void)checkNewVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"version"] = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    md[@"version_code"] = [infoDictionary objectForKey:@"CFBundleVersion"];
    md[@"type"] = @"2";
    [self.afnetWork jsonPostDict:@"/api/version/check_version" JsonDict:md Tag:@"3" LoadingInView:self.view];
}

-(void)initData{
    // 首页网络数据
// http://coin.com/6f0617a1-22a9-48c4-a014-85cfeff732af/api/index/index
   [self.afnetWork jsonGetSocketDict:@"/api/index/index" JsonDict:nil Tag:@"1"];
}

//获取USDT对CNY汇率
-(void)getUSDTToCNYRate{
    [self.afnetWork jsonGetDict:@"/api/market/rateUsdtCny" JsonDict:nil Tag:@"2" LoadingInView:self.view];
}
 

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    [self.tableView.mj_header endRefreshing];
    if([type isEqualToString:@"1"]){//首页数据
        if(self.bannberArray.count == 0){ //没有轮播数据就设置一波
            self.bannberArray = [NSMutableArray array];
            for (NSDictionary *dic in dict[@"data"][@"slide_list"]) {
                [self.bannberArray addObject:dic];
            }
            [self.tableHeaderView setBanner:self.bannberArray];
        }
        
        self.dataArray = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"data"][@"rec_list"]) {
            QuotesTransactionPairModel *model = [QuotesTransactionPairModel yy_modelWithDictionary:dic];
             [self.dataArray addObject:model];
            [self.tableView reloadData];
        }
        if(self.tableHeaderView.hornView.dataSource.count == 0){ //没有公告数据就设置一波
            self.tableHeaderView.hornView.dataSource = [NSMutableArray array];
            for (NSDictionary *dic in dict[@"data"][@"notice_list"]) {
                NoteModel *model = [NoteModel yy_modelWithDictionary:dic];
                [self.tableHeaderView.hornView.dataSource addObject:model];
            }
            NoticeListArray = self.tableHeaderView.hornView.dataSource;
            self.tableHeaderView.noticeUrlString = self.tableHeaderView.hornView.dataSource.firstObject.NoteId;
            [self.tableHeaderView.hornView.marqueeView reloadData];
        }
       
        [self.tableView reloadData];
    }else if([type isEqualToString:@"2"]){//获取汇率
        ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",dict[@"data"][@"rate"]]];
    }else if([type isEqualToString:@"4"]){//更新谷歌验证状态
        if(dict[@"data"] != nil){
            //更新用户缓存
            [WTUserInfo getuserInfoWithDic:dict[@"data"][@"welcome"]];
            [[FFAcountManager sharedInstance] updateUserMoney:dict];
        }
    }else if([type isEqualToString:@"5"]){//更新谷歌验证状态
       
    }else{//版本
        NewVersionModel *versionModel = [NewVersionModel yy_modelWithDictionary:dict[@"data"]];
        UIAlertController *ua = [UIAlertController alertControllerWithTitle:LocalizationKey(@"HomeTip1") message:versionModel.upgradetext preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *bank = [UIAlertAction actionWithTitle:LocalizationKey(@"HomeTip1") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:versionModel.downloadurl] options:@{} completionHandler:nil];
        }];
        UIAlertAction *cancel1 = [UIAlertAction actionWithTitle:LocalizationKey(@"Cancel") style:UIAlertActionStyleCancel handler:nil];
        [ua addAction:bank];
        //不是强行更新，有取消按钮
        if(versionModel.enforce == 0){
           [ua addAction:cancel1];
        }
        [self. navigationController presentViewController:ua animated:YES completion:nil];
    }
    
}

- (void)createNavBar{
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    
    self.gk_navigationBar.hidden = YES;
    HomeNavigationView *navigationView = [[HomeNavigationView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.navigationViewHeight)];
    navigationView.delegate = self;
    [self.view addSubview:navigationView];
    
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.tableHeaderView;
   
}

#pragma mark - HomeNavigationViewDelegate
- (void)jumpHomeSikdVC{
    CGRect frame = self.skidVC.view.frame;
    frame.origin.x = - CGRectGetWidth(self.view.frame);
    self.skidVC.view.frame = CGRectMake(- CGRectGetWidth(self.view.frame), 0,  ScreenWidth, ScreenHeight);
    self.skidVC.rootVC = self;
    [[UIApplication sharedApplication].keyWindow addSubview:self.skidVC.view];
    [self.skidVC showFromLeft]; 
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArray.count > 0){
        QuotesTransactionPairModel *model = self.dataArray[indexPath.row];
//        KLlineViewController *klVC = [KLlineViewController new];
//        klVC.fromScale = model.from_dec;
//        klVC.toScale = model.to_dec;
//        klVC.priceScale = model.dec;
//        klVC.delegate = self;
//        klVC.fromId = model.from;
//        klVC.TransactionPairName = model.display_name;
//        ((AppDelegate *)[UIApplication sharedApplication].delegate).marketId = model.market_id;
//        [self.navigationController pushViewController:klVC animated:YES];
        //点击主页进入指定交易的修改
       ((AppDelegate *)[UIApplication sharedApplication].delegate).displayName = model.display_name; 
        [[WTPageRouterManager sharedInstance] jumpTabBarController:2];
        
        NSDictionary *dic;
        
        NSArray *nameArray = [model.display_name componentsSeparatedByString:@"/"];
        
        dic=[NSDictionary dictionaryWithObjectsAndKeys:nameArray[0],@"leftSymbol",nameArray[1],@"rightSymbol",@"buy",@"kind",model.from,@"fromId",nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:CURRENTSELECTED_SYMBOL object:nil userInfo:dic];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[QuotesPageCell class] forCellReuseIdentifier:identifier];
    QuotesPageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(self.dataArray.count > 0){
        [cell setCellData:self.dataArray[indexPath.row]];
    }
    return cell;
}
 
#pragma mark - ui
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.navigationViewHeight - 20, ScreenWidth, ScreenHeight - self.navigationViewHeight +20 - Height_TabBar ) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        //_tableView.theme_backgroundColor = THEME_MAIN_BACKGROUNDCOLOR;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

-(HomeTableHeaderView *)tableHeaderView{
    if(!_tableHeaderView){
        _tableHeaderView = [[HomeTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 365 - 65 - 60)];
    }
    return _tableHeaderView;
}

- (CGFloat)navigationViewHeight{
    return 240;
}
 
-(HomeSkidVC *)skidVC{
    if(!_skidVC){
        _skidVC = [HomeSkidVC new];
    }
    return _skidVC;
}


@end
