//
//  CoinFlowHistoryTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/8/2.
//  Copyright © 2019 王涛. All rights reserved.
//  币流水历史记录 充币 提币

#import "CoinFlowHistoryTBVC.h"
#import "FinancialRecordCell.h"
#import "CoinFlowHistoryDetailsTBVC.h"

static const CGFloat Threshold = 80;
@interface CoinFlowHistoryTBVC ()

@property(nonatomic, assign)CoinFlowHistoryType   coinFlowHistoryType;
@property(nonatomic, strong)NSString             *coinId,*symbol;
@property (nonatomic, assign)CGFloat              marginTop; 
@end

@implementation CoinFlowHistoryTBVC

-(instancetype)initWithCoinFlowHistoryType:(CoinFlowHistoryType)type CoinId:(NSString *)coinId Symbol:(NSString *)symbol{
    self = [super init];
    if(self){
        self.coinFlowHistoryType = type;
        self.coinId = coinId;
        self.symbol = symbol;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    [self initData];
    [self setMjFresh];
}

#pragma mark - dataSource
-(void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"coin_id"] = self.coinId;
    md[@"page"] = [NSString stringWithFormat:@"%ld",self.pageIndex];
    md[@"page_size"] = @"";
    switch (self.coinFlowHistoryType) {
        case CoinFlowHistoryTypeDeposit:
        {
            [self.afnetWork jsonPostDict:@"/api/account/getRechargeLogList" JsonDict:md Tag:@"1"];
        }
            break;
        default:
        {
            [self.afnetWork jsonPostDict:@"/api/account/getWithdrawLogList" JsonDict:md Tag:@"1"];
        }
            break;
    }
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if(self.isRefresh){
        self.dataArray=[[NSMutableArray alloc]init];
    }
    
    for (NSDictionary *dic in dict[@"data"][@"list"]) {
        [self.dataArray addObject:dic];
    }
     
    
    self.allPages = [dict[@"data"][@"page"][@"page_count"] integerValue];
    self.symbol = dict[@"data"][@"symbol"];
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArray.count >0){
        CoinFlowHistoryDetailsTBVC *cvc = [CoinFlowHistoryDetailsTBVC new];
        cvc.coinFlowHistoryType = self.coinFlowHistoryType;
        cvc.coinFlowHistoryDataSource = self.dataArray[indexPath.row];
        cvc.coinName = self.symbol;
        [self.navigationController pushViewController:cvc animated:YES];
    } 
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[FinancialRecordCell class] forCellReuseIdentifier:identifier];
    FinancialRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(self.dataArray.count > 0){
        [cell setCoinFlowData:self.dataArray[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

#pragma mark ScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    // 实时监测scrollView.contentInset.top， 系统优化以及手动设置contentInset都会影响contentInset.top。
    if (self.marginTop != self.tableView.contentInset.top) {
        self.marginTop = self.tableView.contentInset.top;
    }
    
    CGFloat offsetY = scrollView.contentOffset.y;
    CGFloat newoffsetY = offsetY + self.marginTop;
    
    // 临界值150，向上拖动时变透明
    if (newoffsetY >= 0 && newoffsetY <= -Threshold) {
        self.gk_navigationItem.title = @"";
    }else if (newoffsetY > Threshold){
        self.gk_navigationItem.title  = LocalizationKey(@"Order History");
    }else{
        self.gk_navigationItem.title = @"";
    }
}

#pragma mark - ui
-(void)setUpView{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, Threshold)];
    UILabel *la = [[UILabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 0, ScreenWidth, Threshold)];
    [header  addSubview:la];
    la.text = LocalizationKey(@"Order History");
    la.theme_textColor = THEME_TEXT_COLOR;
    la.font = [UIFont boldSystemFontOfSize:30];
    [self.tableView setTableHeaderView:header];
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.tableView];
    
}
 

@end
