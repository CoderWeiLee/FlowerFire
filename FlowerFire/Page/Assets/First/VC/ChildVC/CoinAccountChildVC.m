//
//  CoinAccountChildVC.m
//  FireCoin
//
//  Created by 赵馨 on 2019/5/27.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "CoinAccountChildVC.h"
#import "CoinAccountHeaderView.h"
#import "CoinAccountCell.h"
#import "FiatAccountCell.h"
#import "FinancialRecordTBVC.h"
#import "SearchCoinTextField.h"
#import "FFApplyBuyViewController.h"
#import <MJExtension/MJExtension.h>
#import "ChooseCoinListModel.h"
@interface CoinAccountChildVC ()<UITableViewDataSource,UITableViewDelegate,SearchCoinTextFieldDelegate>
{
    NSString          *account_total; //账户总资产
    NSString          *account_cc; //币币账户资产
    FFApplyBuyModel   *_ffApplyBuyModel; //认购数据
}
//@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) WTTableView            *tableView;
@property(nonatomic, strong) CoinAccountHeaderView  *tableHeaderView;
/// 保留隐藏价格前的数据
@property(nonatomic, strong) NSMutableDictionary    *dataDictionary;
@property(nonatomic, strong) NSMutableArray         *hiddDataArray;//隐藏小额币种的数组
/// 隐藏小额币种的按钮
@property(nonatomic, strong) UIButton               *hiddLowPirceButton;
@property(nonatomic, strong) UIView                 *hiddLowPirceView;

@property(nonatomic, assign) BOOL                   isSearchStatus;
@property(nonatomic, strong) NSArray                *searchDataArray;
@property(nonatomic, strong) SearchCoinTextField    *textField;
@property (nonatomic, strong) NSArray *listModelArray;
@end

@implementation CoinAccountChildVC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self initData];
    
    if([[WTUserInfo shareUserInfo].SD_booking_show isEqualToString:@"1"]){
        self.tableView.tableHeaderView = self.tableHeaderView;
    }else{
        self.tableView.tableHeaderView = nil;
    }
    
    //查下认购信息
    [self searchBookingCoin];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
     
    [self.tableHeaderView setHeaderData:self.coinAccountType SumAssets:@"0.0000000" CNYStr:@"0.00"];
      
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HiddenPriceNotice) name:@"HiddenPriceNotice" object:nil];
}

#pragma mark - notice
-(void)HiddenPriceNotice{
    if(self.dataDictionary){
        [self.dataArray removeAllObjects]; 
        [self setPageData:self.dataDictionary];
    }
}

#pragma mark - action
/// 隐藏最小币种点击
-(void)hiddenLowPriceClick:(UIButton *)btn{
    self.hiddLowPirceButton.selected = !self.hiddLowPirceButton.selected;
       if(self.hiddLowPirceButton.isSelected){
           [self.dataArray removeAllObjects];
           if(self.coinAccountType == CoinAccountTypeBB){
               for (NSDictionary * dic in self.dataDictionary[@"data"][@"account_cc"][@"list"]) {
                   [self checkLowPriceAddDataArray:dic];
               }
           }else if (self.coinAccountType == CoinAccountTypeFB){
               for (NSDictionary * dic in self.dataDictionary[@"data"][@"account_currency"][@"list"]) {
                   [self checkLowPriceAddDataArray:dic];
               }
           }else{
               for (NSDictionary * dic in self.dataDictionary[@"data"][@"account_contract"][@"list"]) {
                   [self checkLowPriceAddDataArray:dic];
               }
           }
           [self.tableView reloadData];
       }else{
           [self HiddenPriceNotice];
       }
}

/// 筛选是否是小额币种的加进去数组
-(void)checkLowPriceAddDataArray:(NSDictionary *)dic{
    if([dic[@"money_cny"] doubleValue]  != 0){
        [self.dataArray addObject:dic];
    }
}

/// 判断是要筛选小额币种还是默认数组然后将数据加进数据源
-(void)addHiddenLowPriceArray:(NSDictionary *)dic{
    if (self.hiddLowPirceButton.isSelected) {
         [self checkLowPriceAddDataArray:dic];
    }else{
         [self.dataArray addObject:dic];
    }
}

#pragma mark - netData
-(void)initData{
    self.dataArray = [NSMutableArray array];
    [self.afnetWork jsonGetDict:@"/api/account/getAccount" JsonDict:nil Tag:@"1" LoadingInView:self.view];
    [[AFHTTPSessionManager manager] POST:[NSString stringWithFormat:@"%@%@",BASE_URL,@"/api/coin/getCoinList"] parameters:@{@"type":@"cc"} headers:[self httpHeaderDic] progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
        self.listModelArray = [ChooseCoinListModel mj_objectArrayWithKeyValuesArray:dict[@"data"]];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

-(NSMutableDictionary *)httpHeaderDic{
    NSMutableDictionary *httpHeaderDic = [NSMutableDictionary dictionaryWithCapacity:1];
    httpHeaderDic[@"token"] = [WTUserInfo shareUserInfo].token;
    httpHeaderDic[@"type"] = @"cc";
    return httpHeaderDic;
}

/// 查下认购信息
-(void)searchBookingCoin{
    if(![HelpManager isBlankString:[WTUserInfo shareUserInfo].paypass]){
        [self.afnetWork jsonGetDict:@"/api/user/bookingCoin" JsonDict:nil Tag:@"2"];
    }
}

- (void)setPageData:(NSDictionary * _Nonnull)dict {
    account_total = [NSString stringWithFormat:@"%.8f",[dict[@"data"][@"account_total"] doubleValue]];
    NSString *account_total_cny = [NSString stringWithFormat:@"%.2f",[dict[@"data"][@"account_total_cny"] doubleValue]];
    !self.setAssetsHeaderDataBlock ? : self.setAssetsHeaderDataBlock(account_total,account_total_cny);
    
    if(self.coinAccountType == CoinAccountTypeBB){
        account_cc = [NSString stringWithFormat:@"%.8f",[dict[@"data"][@"account_cc"][@"total"] doubleValue]] ;
        [self.tableHeaderView setHeaderData:self.coinAccountType SumAssets:account_cc CNYStr:[NSString stringWithFormat:@"%.2f",[dict[@"data"][@"account_cc"][@"total_cny"] doubleValue]]];
        for (NSDictionary * dic in dict[@"data"][@"account_cc"][@"list"]) {
            [self addHiddenLowPriceArray:dic];
        }
    }else if (self.coinAccountType == CoinAccountTypeFB){
        account_cc = [NSString stringWithFormat:@"%.8f",[dict[@"data"][@"account_currency"][@"total"] doubleValue]] ;
        [self.tableHeaderView setHeaderData:self.coinAccountType SumAssets:account_cc CNYStr:[NSString stringWithFormat:@"%.2f",[dict[@"data"][@"account_currency"][@"total_cny"] doubleValue]]];
        for (NSDictionary * dic in dict[@"data"][@"account_currency"][@"list"]) {
            [self addHiddenLowPriceArray:dic];
        }
    }else{
        account_cc = [NSString stringWithFormat:@"%.8f",[dict[@"data"][@"account_contract"][@"total"] doubleValue]] ;
        [self.tableHeaderView setHeaderData:self.coinAccountType SumAssets:account_cc CNYStr:[NSString stringWithFormat:@"%.2f",[@"0" doubleValue]]];
        for (NSDictionary * dic in dict[@"data"][@"account_contract"][@"list"]) {
            [self addHiddenLowPriceArray:dic];
        }
    }
     
    
    [self.tableView reloadData];
}

#pragma mark - netBack
-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        if(![dict[@"data"] isKindOfClass:[NSNull class] ]){
            self.dataDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
            [self setPageData:dict];
        }
    }else{
        _ffApplyBuyModel = [FFApplyBuyModel yy_modelWithDictionary:dict[@"data"]];
        self.tableHeaderView.time.text = NSStringFormat(@"%@~%@",_ffApplyBuyModel.start_time,_ffApplyBuyModel.end_time);
    }

}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.coinAccountType == CoinAccountTypeFB){
        FinancialRecordTBVC *fvc = [FinancialRecordTBVC new];
        fvc.coinAccountType = self.coinAccountType;
        if(self.isSearchStatus){
            if(self.searchDataArray.count >0){
                fvc.headerData = self.searchDataArray[indexPath.row];
                [self.navigationController pushViewController:fvc animated:YES];
            }
        }else{
            if(self.dataArray.count >0){
                fvc.headerData = self.dataArray[indexPath.row];
                [self.navigationController pushViewController:fvc animated:YES];
            }
        }
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.isSearchStatus){
        return self.searchDataArray.count;
    }
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.coinAccountType == CoinAccountTypeBB){ //币币
        static NSString *identifier = @"cell";
        [self.tableView registerClass:[CoinAccountCell class] forCellReuseIdentifier:identifier];
        CoinAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        NSUInteger count = self.listModelArray.count;
        cell.model = self.listModelArray[count - (indexPath.row) - 1];
        if(self.isSearchStatus){
            if(self.searchDataArray.count >0){
                [cell setCellData:self.searchDataArray[indexPath.row] CoinAccountType:self.coinAccountType];
            }
        }else{
            if(self.dataArray.count >0){
                [cell setCellData:self.dataArray[indexPath.row] CoinAccountType:self.coinAccountType];
            }
        }
        return cell;
    }else{
        static NSString *identifier1 = @"cell1";
        [self.tableView registerClass:[FiatAccountCell class] forCellReuseIdentifier:identifier1];
        FiatAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier1 forIndexPath:indexPath];
        
        if(self.isSearchStatus){
            if(self.searchDataArray.count >0){
                [cell setCellData:self.searchDataArray[indexPath.row] CoinAccountType:self.coinAccountType];
            }
        }else{
            if(self.dataArray.count >0){
                [cell setCellData:self.dataArray[indexPath.row] CoinAccountType:self.coinAccountType];
            }
        }
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (self.coinAccountType) {
        case CoinAccountTypeBB:
            return ceil(151 + OverAllLeft_OR_RightSpace);
        default:
            return ceil(136 + OverAllLeft_OR_RightSpace);
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.hiddLowPirceView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}

#pragma mark - SearchCoinTextFieldDelegate
- (void)changedTextField:(UITextField *)textField{
    if(textField.text.length == 0){
        self.isSearchStatus = NO;
    }else{
        self.isSearchStatus = YES;
    }
    //  要求取出包含‘币名’的元素  [c]不区分大小写[d]不区分发音符号即没有重音符号[cd]既不区分大小写，也不区分发音符号。
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"symbol CONTAINS [cd] %@",textField.text];
    self.searchDataArray = [self.dataArray filteredArrayUsingPredicate:pred2];
    [self.tableView reloadData];
}

- (void)cleanFieldClick{
    self.isSearchStatus = NO;
    self.textField.text = @"";
    [self.tableView reloadData];
}

#pragma mark - lazyInit
-(void)setCoinAccountType:(CoinAccountType)coinAccountType{
    _coinAccountType = coinAccountType;
}

-(WTTableView *)tableView{
    if(!_tableView){
        if(IS_IPHONE_X){
             _tableView = [[WTTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - Height_TabBar) style:UITableViewStyleGrouped];
        }else{
             _tableView = [[WTTableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - Height_TabBar) style:UITableViewStyleGrouped];
        }
        [_tableView setTheme_backgroundColor:THEME_MAIN_BACKGROUNDCOLOR];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.showsVerticalScrollIndicator = NO;
    }
    return _tableView;
}

-(CoinAccountHeaderView *)tableHeaderView{
    if(!_tableHeaderView){
        _tableHeaderView = [[CoinAccountHeaderView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,  130)];
        @weakify(self)
        [_tableHeaderView.goBuyButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strongify(self)
            [[UniversalViewMethod sharedInstance] activationStatusCheck:self];
            
            FFApplyBuyViewController *fvc = [[FFApplyBuyViewController alloc] initWithFFApplyBuyModel:self->_ffApplyBuyModel];
            [self.navigationController pushViewController:fvc animated:YES];
        }];
    }
    return _tableHeaderView;
}

/// section第一个头部视图
-(UIView *)hiddLowPirceView{
    if(!_hiddLowPirceView){
        if(!self.hiddLowPirceButton){
            _hiddLowPirceView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)] ;
               _hiddLowPirceView.theme_backgroundColor = THEME_NAVBAR_BACKGROUNDCOLOR;
            _hiddLowPirceButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [_hiddLowPirceButton setTitle:LocalizationKey(@"AssetsTip1") forState:UIControlStateNormal];
            [_hiddLowPirceButton setImage:[UIImage imageNamed:@"BAI-danxuankuang"] forState:UIControlStateNormal];
            [_hiddLowPirceButton setImage:[UIImage imageNamed:@"BAI-danxuankuangs"] forState:UIControlStateSelected];
            _hiddLowPirceButton.imageEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
            [_hiddLowPirceButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            _hiddLowPirceButton.titleLabel.font  = tFont(14);
            [_hiddLowPirceView addSubview:_hiddLowPirceButton];
            [_hiddLowPirceButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_hiddLowPirceView.mas_centerY).offset(0);
                make.left.mas_equalTo(_hiddLowPirceView.mas_left).offset(OverAllLeft_OR_RightSpace);
                make.width.mas_equalTo(120);
            }];
            [_hiddLowPirceButton.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(20, 20));
                make.centerY.mas_equalTo(_hiddLowPirceButton.mas_centerY);
            }];
            
            UIButton *questionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            questionBtn.hidden = YES;
            [questionBtn setTitle:@"?" forState:UIControlStateNormal];
            [questionBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            questionBtn.titleLabel.font  = tFont(13);
            [_hiddLowPirceView addSubview:questionBtn];
            [questionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(_hiddLowPirceButton.mas_centerY);
                make.left.mas_equalTo(_hiddLowPirceButton.mas_right).offset(2);
            }];
             
            self.textField = [[SearchCoinTextField alloc] initWithFrame:CGRectZero delegate:self];
            [_hiddLowPirceView addSubview:self.textField];
            [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(_hiddLowPirceView.mas_right).offset(-OverAllLeft_OR_RightSpace);
                make.centerY.mas_equalTo(_hiddLowPirceView.mas_centerY);
                make.size.mas_equalTo(CGSizeMake(125, 30));
            }];
//            
//            UIView *xian  = [UIView new];
//            xian.theme_backgroundColor = THEME_LINE_TABLEVIEW_SEPARATOR_COLOR;
//            [_hiddLowPirceView addSubview:xian];
//            [xian mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.bottom.mas_equalTo(_hiddLowPirceView.mas_bottom);
//                make.left.mas_equalTo(_hiddLowPirceView.mas_left);
//                make.size.mas_equalTo(CGSizeMake(ScreenWidth, 1));
//            }];
//            
            [_hiddLowPirceButton addTarget:self action:@selector(hiddenLowPriceClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    return _hiddLowPirceView;
}
 

@end
