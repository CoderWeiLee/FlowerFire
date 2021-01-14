//
//  FinancialRecordTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/22.
//  Copyright © 2019 王涛. All rights reserved.
//  财务日志

#import "FinancialRecordTBVC.h"
#import "FinancialHeaderView.h"
#import "FinanceRecordModel.h"
#import "FinancialRecordCell.h"
#import "FinancialRecordDetailTBVC.h"
@interface FinancialRecordTBVC ()
{
    NSArray     *_filterArray;
    NSInteger    _selectedIndex;
    NSString    *paramsAccountType;
}
@property (nonatomic, assign)CGFloat    marginTop; 
@end

@implementation FinancialRecordTBVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.gk_navigationBar.hidden = NO;
}
// all=全部 0=系统,1=充值,2=提币,3=卖出,4=买入,5=转入,6=转出,7=手续费
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(self.coinAccountType == CoinAccountTypeHY){
        _filterArray = @[LocalizationKey(@"All"),LocalizationKey(@"Open"),LocalizationKey(@"Close"),LocalizationKey(@"Liquidation"),LocalizationKey(@"Delivery settlement"),LocalizationKey(@"Transfer Out"),LocalizationKey(@"Transfer In"),LocalizationKey(@"Fee"),LocalizationKey(@"Promotion Reward"),LocalizationKey(@"System")];
    }else{
        _filterArray = @[LocalizationKey(@"All"),LocalizationKey(@"System"),LocalizationKey(@"Recharge"),LocalizationKey(@"assetsTip2"),LocalizationKey(@"Sell"),LocalizationKey(@"Buy"),LocalizationKey(@"Transfer In"),LocalizationKey(@"Transfer Out"),LocalizationKey(@"Fee")];
    }
    
    
    [self setUpView];
    [self initData];
    [self setMjFresh];
    
    
}

#pragma mark - action
-(void)filterClick{
    UIAlertController *uac  = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i<_filterArray.count; i++) {
        UIAlertAction *ua = [UIAlertAction actionWithTitle:_filterArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            for (int i = 0; i<self->_filterArray.count; i++) {
                if([self->_filterArray[i] isEqualToString:action.title]){
                    self->_selectedIndex = i;
                    [self.dataArray removeAllObjects];
                    [self initData];
                }
            }
        }];
        [uac addAction:ua];
    }
    UIAlertAction *ua1 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [uac addAction:ua1];
    
    [self presentViewController:uac animated:YES completion:nil];
}

#pragma mark - dataSource
//日志类别 all=全部 0=系统,1=充值,2=提币,3=卖出,4=买入,5=转入,6=转出,7=手续费
-(void)initData{
    NSString *cate;
    if(_selectedIndex == 0){
        cate = @"all";
    }else{
        cate = [NSString stringWithFormat:@"%ld",(long)_selectedIndex - 1];
    }
    
    NSMutableDictionary *netDic = [NSMutableDictionary dictionary];
    netDic[@"account_type"] = paramsAccountType;
    netDic[@"cate"] = cate;
    netDic[@"coin_id"] = self.headerData[@"coin_id"];
    netDic[@"page"] = [NSString stringWithFormat:@"%ld",self.pageIndex];
    netDic[@"page_size"] = @"";
    [self.afnetWork jsonPostDict:@"/api/account/getAccountLogList" JsonDict:netDic Tag:@"1" LoadingInView:self.view];
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if(self.isRefresh){
        self.dataArray=[[NSMutableArray alloc]init];
    }
    
    for (NSDictionary *dic in dict[@"data"][@"list"]) {
        FinanceRecordModel *model = [FinanceRecordModel yy_modelWithDictionary:dic];
        [self.dataArray addObject:model];
    }
    
    self.allPages = [dict[@"data"][@"page"][@"page_count"] integerValue];
    [self.tableView reloadData];
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
    if (newoffsetY >= 0 && newoffsetY <= -60) {
        self.gk_navigationItem.title = @"";
    }else if (newoffsetY > 60){
        self.gk_navigationItem.title = self.headerData[@"symbol"];
    }else{
        self.gk_navigationItem.title = @"";
    }
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArray.count>0){
        FinancialRecordDetailTBVC *fdc = [FinancialRecordDetailTBVC new];
        fdc.model = self.dataArray[indexPath.row];
        fdc.coinName =  self.headerData[@"symbol"];
        [self.navigationController pushViewController:fdc animated:YES];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
      if(self.coinAccountType == CoinAccountTypeHY){
          return 10;
      }
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[FinancialRecordCell class] forCellReuseIdentifier:identifier];
    FinancialRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[FinancialRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
 
    if(self.dataArray.count > 0){
        [cell setCellData:self.dataArray[indexPath.row] CoinAccountType:self.coinAccountType];
    }
     
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    bac.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    UILabel *tip = [UILabel new];
    tip.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    tip.theme_textColor = THEME_TEXT_COLOR;
    tip.layer.masksToBounds = YES;
    tip.font = tFont(18);
    tip.text = self.coinAccountType == CoinAccountTypeHY ? LocalizationKey(@"Transactions") : LocalizationKey(@"Finance Records");
    [bac addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bac.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(bac.mas_centerY);
    }];
    
    UIButton *filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    filterBtn.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    [filterBtn theme_setImage:@"global_filter_unselected" forState:UIControlStateNormal];
    [bac addSubview:filterBtn];
    [filterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(bac.mas_centerY);
        make.right.mas_equalTo(bac.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    [filterBtn addTarget:self action:@selector(filterClick) forControlEvents:UIControlEventTouchUpInside];
    return bac;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

#pragma mark - ui
-(void)setUpView{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    FinancialHeaderView *headerView = [[FinancialHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 145)];
    [headerView setCellData:self.headerData];
    self.tableView.tableHeaderView = headerView ;
    [self.view addSubview:self.tableView];
    
    self.tableView.estimatedRowHeight = 85;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - lazyInit
-(void)setCoinAccountType:(CoinAccountType)coinAccountType{
    _coinAccountType = coinAccountType;
    switch (coinAccountType) {
        case CoinAccountTypeBB:
            paramsAccountType = Coin_Account;
            break;
        case CoinAccountTypeFB:
            paramsAccountType = LegalCurrency_Account;
            break;
        default:
            paramsAccountType = Contract_Account;
            break;
    }
}
//common_empty_icon_in_otc_card mycenter_3 

@end
