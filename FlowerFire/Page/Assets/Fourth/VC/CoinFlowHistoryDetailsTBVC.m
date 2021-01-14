//
//  CoinFlowHistoryDetailsTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/8/2.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "CoinFlowHistoryDetailsTBVC.h"

@interface CoinFlowHistoryDetailsTBVC ()

@property(nonatomic, strong) NSArray *dataArray;
@end

@implementation CoinFlowHistoryDetailsTBVC

@synthesize dataArray = _dataArray;

- (void)viewDidLoad {
    [super viewDidLoad];
   
}
//覆盖父类
/**
 "money": "0.02356000",
 "addtime": 4294967295,
 "status_name": "已完成"
 address    string    提现地址
 tag    string    标签
 money    string    提现数量
 fee    string    手续费
 amount    string    到账数量
 status_name    string    状态
 txhash    string    交易hash
 addtime    string    时间
 */
-(void)initData{
    switch (self.coinFlowHistoryType) {
        case CoinFlowHistoryTypeDeposit:
        {
            self.money.text = [NSString stringWithFormat:@"+%@ %@",self.coinFlowHistoryDataSource[@"money"],self.coinName];
            self.dataArray = @[@{@"title":LocalizationKey(@"Type"),@"type":LocalizationKey(@"Deposit")},@{@"title":LocalizationKey(@"Status"),@"type":self.coinFlowHistoryDataSource[@"status_name"]},
                               @{@"title":LocalizationKey(@"Date"),@"type":self.coinFlowHistoryDataSource[@"addtime"]},];
        }
            break;
        default:
        {
            self.money.text = [NSString stringWithFormat:@"-%@ %@",self.coinFlowHistoryDataSource[@"money"],self.coinName];
            self.dataArray = @[@{@"title":LocalizationKey(@"Type"),@"type":LocalizationKey(@"Withdraw")},@{@"title":LocalizationKey(@"WithdrawAddress"),@"type":self.coinFlowHistoryDataSource[@"address"]},@{@"title":LocalizationKey(@"Status"),@"type":self.coinFlowHistoryDataSource[@"status_name"]},@{@"title":LocalizationKey(@"Fee"),@"type":self.coinFlowHistoryDataSource[@"fee"]},
                               @{@"title":LocalizationKey(@"Date"),@"type":self.coinFlowHistoryDataSource[@"addtime"]},];
        }
            break;
    }
}

@end
