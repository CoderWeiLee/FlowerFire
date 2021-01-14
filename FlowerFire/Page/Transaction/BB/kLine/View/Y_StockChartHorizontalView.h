//
//  Y_StockChartHorizontalView.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/18.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseUIView.h"
#import "Y_StockChartView.h"
#import "QuotesTransactionPairModel.h"
#import "Y_KLineModel.h"


NS_ASSUME_NONNULL_BEGIN

@protocol Y_StockChartHorizontalViewDelegate <NSObject>

-(void)dismiss;

@end 

@interface Y_StockChartHorizontalView : BaseUIView

@property(nonatomic, strong)  UIButton   *closeBtn;
@property(nonatomic,assign)   NSUInteger  DefalutselectedIndex;
@property(nonatomic, strong)  UIView     *moreView;
@property(nonatomic, strong)  UIView     *mainView;
@property(nonatomic, strong)  UIView     *headerBac;
@property(nonatomic, strong)  UILabel    *symbolLabel;
@property(nonatomic, strong)  UILabel    *PriceLabel;
@property(nonatomic, strong)  UILabel    *CNYLabel;
@property(nonatomic, strong)  UILabel    *highLabel;
@property(nonatomic, strong)  UILabel    *lowLabel;
@property(nonatomic, strong)  UILabel    *amountLabel;
@property(nonatomic, strong)  UILabel    *changeLabel;
@property(nonatomic, strong)  UIView     *klineView;
@property(nonatomic, strong)  UIButton   *moreBtn;
@property(nonatomic, assign)  NSInteger   currentIndex;


@property (nonatomic, strong) Y_StockChartView *stockChartView;

@property(nonatomic, weak) id<Y_StockChartHorizontalViewDelegate> delegate;

/**
 dataSource
 */
@property (nonatomic, strong) QuotesTransactionPairModel *model;

/**
 币股交易的数据源
 */
@property (nonatomic, strong) Y_KLineModel *Y_KLineModel;


@property (nonatomic, strong) NSMutableArray<UILabel *>  *masArray1;
@end

NS_ASSUME_NONNULL_END
