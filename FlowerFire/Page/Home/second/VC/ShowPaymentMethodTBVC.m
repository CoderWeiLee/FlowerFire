//
//  ShowPaymentMethodTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/3.
//  Copyright © 2019 王涛. All rights reserved.
//  用户收款方式列表

#import "ShowPaymentMethodTBVC.h"
#import "AccountsReceivableSettingTBVC.h"
#import "ShowPaymentMethodCell.h"
#import "AccountReceivableDetailsTBVC.h"
@interface ShowPaymentMethodTBVC ()

// 监测范围的临界点,>0代表向上滑动多少距离,<0则是向下滑动多少距离

// 记录scrollView.contentInset.top

@property (nonatomic, assign)CGFloat      marginTop;
@end

@implementation ShowPaymentMethodTBVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
}

#pragma mark - action
-(void)jumpAccountsSettingClick{
    AccountsReceivableSettingTBVC *arVC = [AccountsReceivableSettingTBVC new];
    [self.navigationController pushViewController:arVC animated:YES];
}

#pragma mark - dataSource
-(void)initData{
    [self.afnetWork jsonGetDict:@"/api/account/getPayList" JsonDict:nil Tag:@"1" LoadingInView:self.view];
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    self.dataArray = [NSMutableArray array];
    
    for (NSDictionary *dic in dict[@"data"]) {
        [self.dataArray addObject:dic];
    }
     
    [self.tableView reloadData];
    
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[ShowPaymentMethodCell class] forCellReuseIdentifier:identifier];
    ShowPaymentMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[ShowPaymentMethodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    if(self.dataArray.count>0){
        [cell setCellData:self.dataArray[indexPath.row]];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArray.count>0){
        AccountReceivableDetailsTBVC *avc = [AccountReceivableDetailsTBVC new];
        avc.dataDic = self.dataArray[indexPath.row];
        [self.navigationController pushViewController:avc animated:YES];
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
        self.gk_navigationItem.title = LocalizationKey(@"Payment Method");
    }else{
        self.gk_navigationItem.title = @"";
    }
}

#pragma mark - ui
-(void)setUpView{
    UIView *headerBac = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
   // headerBac.backgroundColor = navBarColor;
    [headerBac setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
    UILabel *topLabel = [UILabel new];
    topLabel.text = LocalizationKey(@"Payment Method");
    topLabel.theme_textColor = THEME_TEXT_COLOR;
    topLabel.font = [UIFont boldSystemFontOfSize:30];
    [headerBac addSubview:topLabel];
    [topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerBac.mas_centerY).offset(0);
        make.left.mas_equalTo(headerBac.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 108;
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
    [self.tableView setTableHeaderView:headerBac];
   
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [addBtn setTitle:LocalizationKey(@"Add") forState:UIControlStateNormal];
    addBtn.backgroundColor = MainColor;
    addBtn.layer.cornerRadius = 3;
    addBtn.layer.masksToBounds = YES;
    [addBtn addTarget:self action:@selector(jumpAccountsSettingClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 45));
    }];
  
    self.tableView.ly_emptyView = [LYEmptyView emptyViewWithImage:[UIImage imageNamed:@"mycenter_3"] titleStr:LocalizationKey(@"paymentMthodTip1") detailStr:@""];
}


#pragma mark - ui
@end
