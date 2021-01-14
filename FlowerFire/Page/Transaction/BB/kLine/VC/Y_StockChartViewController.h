//
//  YStockChartViewController.h
//  BTC-Kline
//
//  Created by yate1996 on 16/4/27.
//  Copyright © 2016年 yate1996. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface Y_StockChartViewController : BaseViewController

@property(nonatomic,strong)   NSString  *symbol;//交易对
@property (nonatomic, assign) NSInteger  currentIndex;

/**
 用于获取k线数据的参数
 */
@property (nonatomic, copy)  NSString   *kNetSymbol;

@property (nonatomic,assign)int          baseCoinScale;
@property (nonatomic,assign)int          coinScale;

@end
 
