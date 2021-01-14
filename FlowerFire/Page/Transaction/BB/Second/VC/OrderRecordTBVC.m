//
//  OrderRecordTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/29.
//  Copyright © 2019 王涛. All rights reserved.
//  订单记录

#import "OrderRecordTBVC.h"
#import "OrderRecordCell.h"
#import "OrderRecordModel.h"
#import "PayMentViewController.h"
#import "OrderRecordFilterModalView.h"

@interface OrderRecordTBVC ()

// 监测范围的临界点,>0代表向上滑动多少距离,<0则是向下滑动多少距离

// 记录scrollView.contentInset.top
@property (nonatomic, assign) CGFloat                     marginTop;
@property (nonatomic, strong) OrderRecordFilterModalView *filterModalView;
@end

@implementation OrderRecordTBVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //默认值
    self.paramsType = @"all";
    self.paramsStatus = @"all";
    
    [self setNarBar];
    [self setMjFresh];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - action
/**
 筛选
 */
-(void)rightClick{
    if(self.filterModalView.isShow){
        [self.filterModalView hideView];
    }else{
        [self.filterModalView showView:self];
        self.filterModalView.paramsStatus = self.paramsStatus;
        self.filterModalView.paramsType = self.paramsType;
    }

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
    if (newoffsetY >= 0 && newoffsetY <= -80) {
        self.gk_navigationItem.title = @"";
    }else if (newoffsetY > 80){
        self.gk_navigationItem.title = LocalizationKey(@"Order record");
    }else{
        self.gk_navigationItem.title = @"";
    }
}


#pragma mark - netWork
-(void)initData{
    NSDictionary *netDic = @{@"type":self.paramsType,
                          @"coin_id":@"",
                          @"order_status":self.paramsStatus,
                          @"page":[NSString stringWithFormat:@"%ld",self.pageIndex],
                          @"page_size":@""
                          };
    [self.afnetWork jsonPostDict:@"/api/otc/getOtcOrderList" JsonDict:netDic Tag:@"1"];
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if(self.isRefresh){
        self.dataArray=[[NSMutableArray alloc]init];
    }
    
    for (NSDictionary *dic in dict[@"data"][@"list"]) {
        [self.dataArray addObject:[OrderRecordModel yy_modelWithDictionary:dic]];
    }
    self.allPages = [dict[@"data"][@"page"][@"page_count"] integerValue];
    [self.tableView reloadData];
}

#pragma mark - tableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PayMentViewController *p = [PayMentViewController  new];
    OrderRecordModel *model = self.dataArray[indexPath.row];
    p.buyOrSeal = model.order_type;
    p.otcOrderId = model.otcOrderId;
    [self.navigationController pushViewController:p animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ 
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    OrderRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[OrderRecordCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(self.dataArray.count > 0){
       [cell setCellData:self.dataArray[indexPath.row]];
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175;
}

#pragma mark - NarVar
-(void)setNarBar{
    
    UIButton *fitterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [fitterBtn theme_setImage:@"global_filter_unselected" forState:UIControlStateNormal];
    [fitterBtn setFrame:CGRectMake(0, 0, 25, 25)];
    [fitterBtn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:fitterBtn];
    self.gk_navigationItem.rightBarButtonItem = rightBtn;
    
    [self setUpView];
}

#pragma mark - ui
-(void)setUpView{
    UIView *headerBac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    headerBac.theme_backgroundColor = THEME_MAIN_BACKGROUNDCOLOR;
    
    UILabel *topLabel = [UILabel new];
    topLabel.text = LocalizationKey(@"Order record");
    topLabel.textColor = MainColor;
    topLabel.font = [UIFont boldSystemFontOfSize:30];
    [headerBac addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerBac.mas_centerY).offset(0);
        make.left.mas_equalTo(headerBac.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
     
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.tableView];
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImage:[UIImage imageNamed:@"mycenter_3"] titleStr:LocalizationKey(@"Not records") detailStr:@""];
    [self.tableView setTableHeaderView:headerBac];

    
}

-(OrderRecordFilterModalView *)filterModalView{
    if(!_filterModalView){
        _filterModalView = [[OrderRecordFilterModalView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        @weakify(self)
        _filterModalView.orderRecordFilterBlock = ^(NSString *paramsType, NSString *paramsStatus) {
          @strongify(self)
            self.paramsType = paramsType;
            self.paramsStatus = paramsStatus;
            [self.tableView.mj_header beginRefreshing];
        };
    }
    return _filterModalView;
}

@end
