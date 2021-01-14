//
//  QuotesChildFactoryViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/4/29.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "QuotesChildVCFactory.h"
#import "QutesChildChooseViewController.h"
#import "QutesChildAllViewController.h"
#import "SHPolling.h"
#import "QutesPageTableViewController.h"

@interface QuotesChildVCFactory ()

@property(nonatomic,strong)SHPolling *SHPollinga;
@property(nonatomic,assign)quotesChildType qutesType;
@end

@implementation QuotesChildVCFactory

- (instancetype)initWithQutesType:(quotesChildType)qutesType{
    self = [super init];
    if(self){
        _qutesType = qutesType;
        switch (qutesType) {
            case quotesChildTypeChoose:
            {
                QutesChildChooseViewController *qc = [QutesChildChooseViewController new];
                qc.qutesType = qutesType;
                return qc;
            }
            default:
            {
                QutesChildAllViewController *qc = [QutesChildAllViewController new];
                qc.qutesType = qutesType;
                return qc;
            }
        }
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(!self.SHPollinga.runing){
       [self.SHPollinga start];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.SHPollinga pause];
    //self.SHPollinga = nil;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
  
    __weak typeof(self) weakSelf = self;
    self.SHPollinga = [SHPolling pollingWithInterval:0 block:^(SHPolling *observer,SHPollingStatus pollingStatus) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(POLLIING_TIME * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [weakSelf initData];
            [observer next:pollingStatus];
        });
        
    }];
      
    [self initData];
}
 
#pragma mark - netBack
-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        NSMutableArray *titleArray = [NSMutableArray array];
        
        self.dataArray = [NSMutableArray array];
        for (NSDictionary *dic in dict[@"data"]) {
            //只筛选USDT的
//            if([dic[@"symbol"] isEqualToString:@"USDT"]){
                QuotesTradingZoneModel *model = [QuotesTradingZoneModel yy_modelWithJSON:dic];
                [self.dataArray addObject:model];
                [titleArray addObject:dic[@"symbol"]];
//                break;
//            }
        }
        [self netDateHandle:titleArray withArray:self.dataArray];
      //wangminxin  [self netDateHandle:titleArray];
    }
}

-(void)initData{
    [self.afnetWork jsonGetSocketDict:@"/api/market/getMarket" JsonDict:nil Tag:@"1"];
}

- (void)createNavBar{
   self.gk_navigationBar.hidden = YES;
}

- (void)startSortData:(nonnull UIViewController *)qvc model:(QuotesTradingZoneModel *)model {
    if(self.qutesType == quotesChildTypeAll){
       QutesPageTableViewController *qpvc = (QutesPageTableViewController *)qvc;
         if(self.sortDirection == 0){
             qpvc.modelArray = model.list.copy;
         }else{
            switch (self.sortType) {
                case 0:   //名字排序
                {
                    if (self.sortDirection == 1){
                        qpvc.modelArray = [[NSMutableArray alloc] initWithArray:[model.list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                            QuotesTransactionPairModel *model1 = (QuotesTransactionPairModel *)obj1;
                            QuotesTransactionPairModel *model2 = (QuotesTransactionPairModel *)obj2;
                            return [model1.from_symbol compare:model2.from_symbol options:NSNumericSearch];

                        }]];
                    }else{
                        qpvc.modelArray = [[NSMutableArray alloc] initWithArray:[model.list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                            QuotesTransactionPairModel *model1 = (QuotesTransactionPairModel *)obj1;
                            QuotesTransactionPairModel *model2 = (QuotesTransactionPairModel *)obj2;
                            return [model2.from_symbol compare:model1.from_symbol options:NSNumericSearch];
                        }]];
                    }
                }
                    break;
                case 1:   //价格排序
                {
                    if (self.sortDirection == 1){
                        qpvc.modelArray = [[NSMutableArray alloc] initWithArray:[model.list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                            QuotesTransactionPairModel *model1 = (QuotesTransactionPairModel *)obj1;
                            QuotesTransactionPairModel *model2 = (QuotesTransactionPairModel *)obj2;
                            if ([model1.New_price doubleValue] < [model2.New_price doubleValue]) {
                                return NSOrderedDescending;
                            } else {
                                return NSOrderedAscending;
                            }
                        }]];
                    }else{
                        qpvc.modelArray = [[NSMutableArray alloc] initWithArray:[model.list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                            QuotesTransactionPairModel *model1 = (QuotesTransactionPairModel *)obj1;
                            QuotesTransactionPairModel *model2 = (QuotesTransactionPairModel *)obj2;
                            if ([model1.New_price doubleValue] > [model2.New_price doubleValue]) {
                                return NSOrderedDescending;
                            } else {
                                return NSOrderedAscending;
                            }
                        }]];
                    }
                }
                    break;
                default:  //涨跌幅排序
                {
                    if (self.sortDirection == 1){
                        qpvc.modelArray = [[NSMutableArray alloc] initWithArray:[model.list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                            QuotesTransactionPairModel *model1 = (QuotesTransactionPairModel *)obj1;
                            QuotesTransactionPairModel *model2 = (QuotesTransactionPairModel *)obj2;
                            if ([model1.change doubleValue] < [model2.change doubleValue]) {
                                return NSOrderedDescending;
                            } else {
                                return NSOrderedAscending;
                            }
                        }]];
                    }else{
                        qpvc.modelArray = [[NSMutableArray alloc] initWithArray:[model.list sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                            QuotesTransactionPairModel *model1 = (QuotesTransactionPairModel *)obj1;
                            QuotesTransactionPairModel *model2 = (QuotesTransactionPairModel *)obj2;
                            if ([model1.change doubleValue] > [model2.change doubleValue]) {
                                return NSOrderedDescending;
                            } else {
                                return NSOrderedAscending;
                            }
                        }]];
                    }
                }
                    break;
            }
        }
    }else{
        QutesChildChooseViewController *qpvc = (QutesChildChooseViewController *)qvc;
        if(self.sortDirection == 0){
            qpvc.modelArray = [NSMutableArray arrayWithArray:qpvc.sortAfterModelArray];
        }else{
           switch (self.sortType) {
               case 0:   //名字排序
               {
                   if (self.sortDirection == 1){
                       qpvc.modelArray = [[NSMutableArray alloc] initWithArray:[qpvc.modelArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                           QuotesTransactionPairModel *model1 = (QuotesTransactionPairModel *)obj1;
                           QuotesTransactionPairModel *model2 = (QuotesTransactionPairModel *)obj2;
                           return [model1.from_symbol compare:model2.from_symbol options:NSNumericSearch];
                           
                       }]];
                   }else{
                       qpvc.modelArray = [[NSMutableArray alloc] initWithArray:[qpvc.modelArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                           QuotesTransactionPairModel *model1 = (QuotesTransactionPairModel *)obj1;
                           QuotesTransactionPairModel *model2 = (QuotesTransactionPairModel *)obj2;
                           return [model2.from_symbol compare:model1.from_symbol options:NSNumericSearch];
                       }]];
                   }
               }
                   break;
               case 1:   //价格排序
               {
                   if (self.sortDirection == 1){
                       qpvc.modelArray = [[NSMutableArray alloc] initWithArray:[qpvc.modelArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                           QuotesTransactionPairModel *model1 = (QuotesTransactionPairModel *)obj1;
                           QuotesTransactionPairModel *model2 = (QuotesTransactionPairModel *)obj2;
                           if ([model1.New_price doubleValue] < [model2.New_price doubleValue]) {
                               return NSOrderedDescending;
                           } else {
                               return NSOrderedAscending;
                           }
                       }]];
                   }else{
                       qpvc.modelArray = [[NSMutableArray alloc] initWithArray:[qpvc.modelArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                           QuotesTransactionPairModel *model1 = (QuotesTransactionPairModel *)obj1;
                           QuotesTransactionPairModel *model2 = (QuotesTransactionPairModel *)obj2;
                           if ([model1.New_price doubleValue] > [model2.New_price doubleValue]) {
                               return NSOrderedDescending;
                           } else {
                               return NSOrderedAscending;
                           }
                       }]];
                   }
               }
                   break;
               default:  //涨跌幅排序
               {
                   if (self.sortDirection == 1){
                       qpvc.modelArray = [[NSMutableArray alloc] initWithArray:[qpvc.modelArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                           QuotesTransactionPairModel *model1 = (QuotesTransactionPairModel *)obj1;
                           QuotesTransactionPairModel *model2 = (QuotesTransactionPairModel *)obj2;
                           if ([model1.change doubleValue] < [model2.change doubleValue]) {
                               return NSOrderedDescending;
                           } else {
                               return NSOrderedAscending;
                           }
                       }]];
                   }else{
                       qpvc.modelArray = [[NSMutableArray alloc] initWithArray:[qpvc.modelArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                           QuotesTransactionPairModel *model1 = (QuotesTransactionPairModel *)obj1;
                           QuotesTransactionPairModel *model2 = (QuotesTransactionPairModel *)obj2;
                           if ([model1.change doubleValue] > [model2.change doubleValue]) {
                               return NSOrderedDescending;
                           } else {
                               return NSOrderedAscending;
                           }
                       }]];
                   }
               }
                   break;
           }
       }
        [qpvc.tableView reloadData];
    }
 
}

- (void)netDateHandle:(NSArray *)titleArray{}

@synthesize sortDirection;

@synthesize sortType;

@end
