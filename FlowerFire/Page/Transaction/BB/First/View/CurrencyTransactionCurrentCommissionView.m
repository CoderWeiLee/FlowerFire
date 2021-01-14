//
//  CurrencyTransactionCurrentCommissionView.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//  币币交易当前委托列表

#import "CurrencyTransactionCurrentCommissionView.h"
#import "CurrencyTransactionCurrentCommissionCell.h"
#import "MyOrderVC.h"

@interface CurrencyTransactionCurrentCommissionView () <UITableViewDelegate,UITableViewDataSource>
{
    
}

@end

@implementation CurrencyTransactionCurrentCommissionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 55)];
        headerView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        UIView *line = [UIView new];
        line.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
        [headerView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerView.mas_top);
            make.left.mas_equalTo(headerView.mas_left);
            make.size.mas_equalTo(CGSizeMake(ScreenWidth, 10));
        }];
        
        UILabel *tip = [[UILabel alloc] init];
        tip.theme_textColor = THEME_TEXT_COLOR;
        tip.text = LocalizationKey(@"Open Orders");
        tip.font = [UIFont boldSystemFontOfSize:18];
        tip.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
        tip.layer.masksToBounds = YES;
        [tip sizeToFit];
        [headerView addSubview:tip];
        [tip mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(headerView.mas_left).offset(OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(headerView.mas_centerY).offset(5);
        }];
        
        UIButton *allBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [allBtn setTitle:LocalizationKey(@"All") forState:UIControlStateNormal];
        [allBtn theme_setTitleColor:THEME_TEXT_COLOR forState:UIControlStateNormal];
        [allBtn theme_setImage:@"transaction_8" forState:UIControlStateNormal]; 
        allBtn.titleLabel.font = tFont(15);
        [headerView addSubview:allBtn];
        [allBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(headerView.mas_right).offset(-OverAllLeft_OR_RightSpace);
            make.centerY.mas_equalTo(headerView.mas_centerY).offset(5);
        }];
        [allBtn addTarget:self action:@selector(allClick) forControlEvents:UIControlEventTouchUpInside];
     
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.mas_top);
            make.left.mas_equalTo(self.mas_left);
            make.right.mas_equalTo(self.mas_right);
            make.height.mas_equalTo(@192);
        }];
        self.tableView.tableHeaderView = headerView;
        self.tableView.tableFooterView = [UIView new];
        
        
    }
    return self;
}

#pragma mark - action
//全部委托单
-(void)allClick{
    [[UniversalViewMethod sharedInstance] activationStatusCheck:[self viewController]];
    if(![HelpManager isBlankString:((AppDelegate *)[UIApplication sharedApplication].delegate).marketId]){
        MyOrderVC *mvc = [MyOrderVC new];
        mvc.MyOrderPageWhereJump = MyOrderPageWhereJumpBB;
        [[self viewController].navigationController pushViewController:mvc animated:YES];
    } 
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[CurrencyTransactionCurrentCommissionCell class] forCellReuseIdentifier:identifier];
    CurrencyTransactionCurrentCommissionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[CurrencyTransactionCurrentCommissionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if(self.dataArray.count >0){
        [cell setCellData:self.dataArray[indexPath.row] fromScale:self.fromScale toScale:self.toScale priceScale:self.priceScale];
    }
    @weakify(self)
    cell.cancelBlcok = ^(UITableViewCell *cell) {
        @strongify(self)
        NSIndexPath *indexPath = [tableView indexPathForCell:cell];
        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowAtIndexPath:indexPath withRowAnimation:UITableViewAutomaticDimension];
        !self.backRefreshBlock ? : self.backRefreshBlock();
    };
    return cell;
}

- (void)downFreshloadData{
    _isRefresh=YES;
    _pageIndex=1;
    self.dataArray = [[NSMutableArray alloc] init];
    if([self.delegate respondsToSelector:@selector(getCommissonData)]){
        [self.delegate getCommissonData];
    }
}
- (void)upFreshLoadMoreData{
    _isRefresh=NO;
    if(_pageIndex>=_allPages){
        self.tableView.mj_footer.state = MJRefreshStateNoMoreData;
    }else{
        _pageIndex++;
        if([self.delegate respondsToSelector:@selector(getCommissonData)]){
            [self.delegate getCommissonData];
        }
    }
}

-(void)setMjFresh{
    __weak typeof (self) weakSelf = self;
    self.tableView.mj_header  = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf downFreshloadData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf upFreshLoadMoreData];
    }];
}

#pragma mark - lazyInit
-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
     //   _tableView.backgroundColor = navBarColor;
         [_tableView setTheme_backgroundColor:THEME_MAIN_BACKGROUNDCOLOR];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 147;
        _tableView.bounces = NO;
        _tableView.ly_emptyView = [LYEmptyView emptyViewWithImage:[UIImage imageNamed:@"mycenter_3"] titleStr:LocalizationKey(@"Not record") detailStr:LocalizationKey(@"Not record")];
        _tableView.ly_emptyView.contentViewOffset = 50;
       // [self setMjFresh];
    }
    return _tableView;
}

-(NSMutableArray *)dataArray{
    if(!_dataArray){
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
  
@end
