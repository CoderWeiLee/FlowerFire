//
//  LegalCurrencyPageVC.m
//  FireCoin
//
//  Created by 赵馨 on 2019/5/28.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "LegalCurrencyPageVC.h"
#import "FBCurrencyCell.h"
#import "LegalCurrencyModel.h"
#import "LegalCurrencyTransactionModalVC.h"
#import "PayMentViewController.h"
#import "FirstLevelCertificationVC.h"
#import "ReleaseOrderVC.h"

@interface LegalCurrencyPageVC () 
{
}
@end

@implementation LegalCurrencyPageVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
      
}

- (void)viewDidLoad {
    [super viewDidLoad]; 
    
    self.gk_navigationBar.hidden = YES;
    
    self.tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - 60 - Height_NavBar );
    self.tableView.directionalLockEnabled = YES;
    self.tableView.backgroundColor = rgba(238, 242, 244, 1); 
    [self.view addSubview:self.tableView];
    [self setMjFresh];
       
    UIButton *_releaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _releaseBtn.layer.cornerRadius = 25;
    _releaseBtn.layer.masksToBounds = YES;
    [_releaseBtn theme_setImage:@"ic_add_light" forState:UIControlStateNormal];
    _releaseBtn.backgroundColor = rgba(34, 116, 234, 1);
    [self.view addSubview:_releaseBtn];
    [_releaseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20-SafeAreaBottomHeight);
        make.right.mas_equalTo(self.view.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
        
    [_releaseBtn addTarget:self action:@selector(releaseClick) forControlEvents:UIControlEventTouchUpInside];
     
}


#pragma mark - action
-(void)releaseClick{ //查询参数发布广告前接口
    if(![WTUserInfo isLogIn]){
        [self jumpLogin];
        return;
    }
    [self.afnetWork jsonPostDict:@"/api/otc/addOtcBefore" JsonDict:@{@"coin_id":self.coin_id} Tag:@"3"];
}
#pragma mark - netWork
//获取委托单列表 pay_type 收付款类型 全部=all 1=银行卡,2=支付宝,3=微信
-(void)initData{
    NSMutableDictionary *netDic = [NSMutableDictionary dictionaryWithCapacity:0];
    netDic[@"type"] = self.buyOrSell;
    netDic[@"coin_id"] = self.coin_id;
    netDic[@"limit_min"] = self.limit_min;
    netDic[@"pay_type"] = self.payMent;
    netDic[@"page"] = [NSString stringWithFormat:@"%ld",(long)self.pageIndex];
   // netDic[@"page_size"] = [NSString stringWithFormat:@"%ld",self.pageSize]  ;
    [self.afnetWork jsonPostDict:@"/api/otc/getOtcList" JsonDict:netDic Tag:@"1"];
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
    if([type isEqualToString:@"1"]){
        if(self.isRefresh){
            self.dataArray=[[NSMutableArray alloc]init];
        }
        
        for (NSDictionary *dic in dict[@"data"][@"list"]) {
            LegalCurrencyModel *model = [LegalCurrencyModel yy_modelWithDictionary:dic];
            
            [self.dataArray addObject:model];
        }
        self.allPages = [dict[@"data"][@"page"][@"page_count"] integerValue];
        [self.tableView reloadData];
    }else if ([type isEqualToString:@"2"]){
        [MBManager hideAlert];
      //  self.tabBarController.tabBar.hidden = YES;
        LegalCurrencyModel *model = [LegalCurrencyModel yy_modelWithDictionary:dict[@"data"]];
  
        __weak typeof(self) weakSelf = self;
        LegalCurrencyTransactionModalVC *lmc = [LegalCurrencyTransactionModalVC new];
        lmc.closeBlock = ^(BOOL isNext,NSString *otcOrderId,int errorcode) {
            if(errorcode == 1){
                if(isNext){
                    PayMentViewController *pmVC = [PayMentViewController new];
                    pmVC.buyOrSeal = weakSelf.buyOrSell;
                    pmVC.otcOrderId = otcOrderId;
                    [self.navigationController pushViewController:pmVC animated:YES];
                }else{
               //     weakSelf.tabBarController.tabBar.hidden = NO;
                }
            }else if (errorcode == 200){
                [weakSelf jumpLogin];
                [WTUserInfo logout];
            //     weakSelf.tabBarController.tabBar.hidden = NO;
            }else if (errorcode == 300){
                [weakSelf jumpKycVC:@{@"msg":otcOrderId}];
            //     weakSelf.tabBarController.tabBar.hidden = NO;
            }else if (errorcode == 301){
                [weakSelf jumpKycVC2:@{@"msg":otcOrderId}];
             //    weakSelf.tabBarController.tabBar.hidden = NO;
            }else if (errorcode == 400){
                [weakSelf jumpAddAccount:@{@"msg":otcOrderId}];
             //    weakSelf.tabBarController.tabBar.hidden = NO;
            }

        };
        lmc.model = model;
        lmc.buyOrSell = self.buyOrSell;
        lmc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        lmc.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalPresentationStyle = UIModalPresentationCurrentContext;
        [self presentViewController:lmc animated:YES completion:nil];
    }else if ([type isEqualToString:@"3"]){
        //[发布];
        ReleaseOrderVC *rvc = [ReleaseOrderVC new];
        rvc.coinName = self.coinName;
        rvc.coinId = self.coin_id;
        rvc.netDic = dict[@"data"];
        [self.navigationController pushViewController:rvc animated:YES];
    }
}

#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if([WTUserInfo isLogIn]){ 
        [self btnClick:indexPath];
    }else{
        [self jumpLogin];
    } 
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[FBCurrencyCell class] forCellReuseIdentifier:identifier];
    FBCurrencyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
   // cell.delegate = self;
    if(self.dataArray.count >0){
        [cell setCellData:self.dataArray[indexPath.row] coinName:self.coinName buyOrSeal:self.buyOrSell];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
} 

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 156 + OverAllLeft_OR_RightSpace;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

#pragma mark - legalCurrencyCellDelegate
-(void)btnClick:(NSIndexPath *)indexPath{

//    if([btn.titleLabel.text isEqualToString:LocalizationKey(@"FiatTip14")]){
//        UIAlertController *ua = [UIAlertController alertControllerWithTitle:nil message:LocalizationKey(@"FiatTip15") preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *bank = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleDefault handler:nil];
//
//        UIAlertAction *cancel = [UIAlertAction actionWithTitle:LocalizationKey(@"Certification") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            SecondaryLevelCertificationVC *svc = [SecondaryLevelCertificationVC new];
//            [self.navigationController pushViewController:svc animated:YES];
//        }];
//        [ua addAction:bank];
//        [ua addAction:cancel];
//        [self. navigationController presentViewController:ua animated:YES completion:nil];
//    }else{
        [MBManager showLoading];
        if(self.dataArray.count > 0){
            if([self.buyOrSell isEqualToString:@"1"]){
                LegalCurrencyModel *model = self.dataArray[indexPath.row];
                [self.afnetWork jsonPostDict:@"/api/otc/getOtcInfo" JsonDict:@{@"type":self.buyOrSell,@"otc_id":model.otcId} Tag:@"2"];
            }else{
                LegalCurrencyModel *model = self.dataArray[indexPath.row];
                [self.afnetWork jsonPostDict:@"/api/otc/getOtcInfo" JsonDict:@{@"type":self.buyOrSell,@"otc_id":model.otcId} Tag:@"2"];
            }
        }
//    }
    
}

#pragma mark - set 
- (void)setCoin_id:(NSString *)coin_id{
    _coin_id = coin_id;
    self.dataArray = [NSMutableArray array]; 
    [self initData];
}

@end
