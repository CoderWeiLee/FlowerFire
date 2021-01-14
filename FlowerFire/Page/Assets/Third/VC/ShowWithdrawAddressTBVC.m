//
//  AddDepositAddressTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/8/2.
//  Copyright © 2019 王涛. All rights reserved.
//  添加提币地址列表

#import "ShowWithdrawAddressTBVC.h"
#import "ShowWithdrawAddressCell.h"
#import "AddWithdrawAddressVC.h"

static const CGFloat Threshold = 80;
@interface ShowWithdrawAddressTBVC ()
{
    UILabel  *_sybmol;
    NSString *_coinName;
}
@property (nonatomic, assign)CGFloat marginTop;
@end

@implementation ShowWithdrawAddressTBVC

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setUpView];
    [self setMjFresh];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.dataArray removeAllObjects];
    [self initData];
}

#pragma mark action
-(void)addAddressClick{
    AddWithdrawAddressVC *avc = [AddWithdrawAddressVC new];
    avc.coinId = self.coinId;
    avc.coinName = _coinName;
    avc.hasAddressCount = self.dataArray.count;
    [self.navigationController pushViewController:avc animated:YES];
}

#pragma mark - dataSource
-(void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"coin_id"] = self.coinId;
    md[@"page"] = [NSString stringWithFormat:@"%ld",self.pageIndex];
    md[@"page_size"] = @"";
    [self.afnetWork jsonPostDict:@"/api/account/getWithdrawAddressList" JsonDict:md Tag:@"1"];
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
    _coinName = dict[@"data"][@"symbol"];
    _sybmol.text = NSStringFormat(@"%@ %@",_coinName,LocalizationKey(@"Address"));
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArray.count > 0){
       !self.didSeletedAddressBlock ? : self.didSeletedAddressBlock(self.dataArray[indexPath.row][@"address"],self.dataArray[indexPath.row][@"tag"]);
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[ShowWithdrawAddressCell class] forCellReuseIdentifier:identifier];
    ShowWithdrawAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if(self.dataArray.count > 0){
        [cell setCellData:self.dataArray[indexPath.row] symbol:_coinName];
    }
    return cell;
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
        self.gk_navigationItem.title = _sybmol.text;
    }else{
        self.gk_navigationItem.title = @"";
    }
}

#pragma mark - ui
-(void)setUpView{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, Threshold)];
    headerView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
    _sybmol = [[UILabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 0, ScreenWidth, Threshold)];
    _sybmol.theme_textColor = THEME_TEXT_COLOR;
    _sybmol.font = [UIFont boldSystemFontOfSize:30];
    [headerView addSubview:_sybmol];
    [self.view addSubview:self.tableView];
    [self.tableView setTableHeaderView:headerView];
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.layer.masksToBounds = YES;
    addBtn.layer.cornerRadius = 2;
    [addBtn setTitle:LocalizationKey(@"AddAddress") forState:UIControlStateNormal];
    [addBtn setBackgroundColor:MainBlueColor];
    addBtn.titleLabel.font = tFont(15);
    [self.view addSubview:addBtn];
    [addBtn addTarget:self action:@selector(addAddressClick) forControlEvents:UIControlEventTouchUpInside];
    
    if(IS_IPHONE_X){
        addBtn.frame = CGRectMake(OverAllLeft_OR_RightSpace, ScreenHeight - 45 - 20 - 15 - 0, ScreenWidth - OverAllLeft_OR_RightSpace * 2, 45);
        self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar - 20 - 15 - 45);
    }else{
        addBtn.frame = CGRectMake(OverAllLeft_OR_RightSpace, ScreenHeight - 45 - 10 - 10 - 0, ScreenWidth - OverAllLeft_OR_RightSpace * 2, 45);
        self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar - 10 - 10 - 45);
    }
    
}
@end
