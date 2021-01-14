//
//  MyOrderPageTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/6.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "MyOrderPageTBVC.h"
#import "MyOrderPageCell.h"
#import "LegalCurrencyModel.h"
#import "MyCommissionOrderRecordTBVC.h"
#import "CurrencyTransactionModel.h"
#import "CurrencyTransactionCurrentCommissionCell.h"
#import "CurrencyOrderDetailTBVC.h"
 
extern int FROMSCALE;   //交易对钱精确度(小数点后几位)
extern int TOSCALE;     //交易对后精确度
extern int PRICESCALE;
@interface MyOrderPageTBVC ()<MyOrderPageCellDelegate>
 
@end

@implementation MyOrderPageTBVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(self.MyOrderPageWhereJump == MyOrderPageWhereJumpHome){
        if(self.myOrderPageType == MyOrderPageTypeHistory){
            self.gk_navigationItem.title = LocalizationKey(@"homeTip12");
        }else{
            self.gk_navigationItem.title = LocalizationKey(@"homeTip11");
        }
        [self beginFresh];
    }else{
         self.gk_navigationBar.hidden = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUpView];
    [self setMjFresh];
}


#pragma mark - publicMethod
-(void)beginFresh{
   // if(self.tableView.mj_header.isRefreshing){
   //    [self.tableView.mj_header endRefreshing];
   // }else{
        [self.tableView.mj_header beginRefreshing];
    //}
}

#pragma mark - dataSource
-(void)initData{
    switch (self.MyOrderPageWhereJump) {
        case MyOrderPageWhereJumpBB:
        {
            NSMutableDictionary *netDic = [NSMutableDictionary dictionaryWithCapacity:0];
            netDic[@"type"] = self.paramsType;
            netDic[@"order_status"] = self.paramsStatus; //挂售中
            netDic[@"market_id"] = ((AppDelegate *)[UIApplication sharedApplication].delegate).marketId;
            netDic[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.pageIndex];
            netDic[@"page_size"] = @"";
            [self.afnetWork jsonPostDict:@"/api/cc/myCcList" JsonDict:netDic Tag:@"2"];
            break;
        }
        default:
        {
            NSMutableDictionary *netDic = [NSMutableDictionary dictionaryWithCapacity:0];
            netDic[@"type"] = self.paramsType;
            netDic[@"coin_id"] = @"";
            netDic[@"order_status"] = self.paramsStatus;
            netDic[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.pageIndex];
            netDic[@"page_size"] = @"";
            [self.afnetWork jsonPostDict:@"/api/otc/myOtcList" JsonDict:netDic Tag:@"1"];
        }
            break;
    }
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if(self.isRefresh){
            self.dataArray=[[NSMutableArray alloc]init];
        }
        
        for (NSDictionary *dic in dict[@"data"][@"list"]) {
            LegalCurrencyModel *model = [LegalCurrencyModel yy_modelWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        
        self.allPages = [dict[@"data"][@"page"][@"page_count"] integerValue];
        [self.tableView reloadData];
    }else if ([type isEqualToString:@"3"]){
        printAlert(dict[@"msg"], 1.f);
        [self.tableView.mj_header beginRefreshing];
    }else if ([type isEqualToString:@"2"]){
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if(self.isRefresh){
            self.dataArray=[[NSMutableArray alloc]init];
        }
        for (NSDictionary *dic in dict[@"data"][@"list"]) {
            CurrencyTransactionModel *model = [CurrencyTransactionModel yy_modelWithDictionary:dic];
            [self.dataArray addObject:model];
        }
        
        self.allPages = [dict[@"data"][@"page"][@"page_count"] integerValue];
        [self.tableView reloadData];
    }
    
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ 
    return self.dataArray.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.dataArray.count >0){
        if(self.MyOrderPageWhereJump == MyOrderPageWhereJumpBB){
            CurrencyTransactionModel *model = self.dataArray[indexPath.row];
            if(model.order_status != 0){
                CurrencyOrderDetailTBVC *coc = [CurrencyOrderDetailTBVC new];
                coc.trade_id = model.tradeId;
                [self.navigationController pushViewController:coc animated:YES];
            }else{
                printAlert(LocalizationKey(@"ccTip10"), 1.f);
            }
           
        }else{
            if(self.dataArray.count > 0){
                MyCommissionOrderRecordTBVC *mvc = [MyCommissionOrderRecordTBVC  new];
                LegalCurrencyModel *model = self.dataArray[indexPath.row];
                mvc.otcOrderId = model.otc_id;
                [self.navigationController pushViewController:mvc animated:YES];
            }
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.MyOrderPageWhereJump == MyOrderPageWhereJumpBB){
        static NSString *identifier = @"cell";
        [self.tableView registerClass:[CurrencyTransactionCurrentCommissionCell class] forCellReuseIdentifier:identifier];
        CurrencyTransactionCurrentCommissionCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[CurrencyTransactionCurrentCommissionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        if(self.dataArray.count >0){
            [cell setCellData:self.dataArray[indexPath.row] fromScale:FROMSCALE toScale:TOSCALE priceScale:PRICESCALE];
        }
        __weak typeof(self) weakSelf = self;
        cell.cancelBlcok = ^(UITableViewCell *cell) {
             [weakSelf.tableView.mj_header beginRefreshing];
        };
        return cell;
    }else{
        static NSString *identifier = @"cell";
        [self.tableView registerClass:[MyOrderPageCell class] forCellReuseIdentifier:identifier];
        MyOrderPageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if(!cell){
            cell = [[MyOrderPageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        if(self.dataArray.count>0){
            [cell setCellData:self.dataArray[indexPath.row] type:self.MyOrderPageWhereJump];
        }
        cell.delegate = self;
        return cell;
    }
}

#pragma mark - MyOrderPageCell
// 取消委托单
-(void)cancelOrder:(UIButton *)btn cell:(nonnull UITableViewCell *)cell{
    if(self.dataArray.count > 0){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        LegalCurrencyModel *model = self.dataArray[indexPath.row];
        [self.afnetWork jsonPostDict:@"/api/otc/cancelOtc" JsonDict:@{@"otc_id":model.otcId} Tag:@"3"];
    }
}

#pragma mark - ui
-(void)setUpView{
    if(self.MyOrderPageWhereJump == MyOrderPageWhereJumpHome){
        self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    }else{
        self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - Height_NavBar - 80);
    }

    self.tableView.estimatedRowHeight = 128.333;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.view addSubview:self.tableView];
}

#pragma mark - lazyInit
-(void)setMyOrderPageType:(MyOrderPageType)myOrderPageType{
    _myOrderPageType = myOrderPageType;
    switch (myOrderPageType) {
        case MyOrderPageTypeAll:
            self.paramsStatus = @"0";
            break;
        default:
            self.paramsStatus = @"all";
            break;
    }
}

-(void)setMyOrderPageWhereJump:(MyOrderPageWhereJump)MyOrderPageWhereJump{
    _MyOrderPageWhereJump = MyOrderPageWhereJump;
    switch (MyOrderPageWhereJump) {
        case MyOrderPageWhereJumpBB:
            self.paramsType = @"all";
        //    [self initData];
            break;
        default:
            self.paramsType = @"all";
        //    [self initData];
            break;
    }
}

@end
