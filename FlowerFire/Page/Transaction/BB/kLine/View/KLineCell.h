//
//  KLineCell.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/5.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "Y_StockChartView.h"


NS_ASSUME_NONNULL_BEGIN

@interface KLineCell : BaseTableViewCell

@property (nonatomic, strong)  UIView   *moreView;
@property (nonatomic, strong)  UIView   *indView;
@property (nonatomic, strong)  UIButton *KlineCurrentBtn;//选中的K线种类
@property (nonatomic, strong)  UIButton *mainCurrentBtn;//选中的主图
@property (nonatomic, strong)  UIButton *subCurrentBtn;//选中的副图
@property (nonatomic, strong)  UIButton *macdBtn;
@property (nonatomic, strong)  UIButton *maBtn; 
@property (nonatomic, strong)  UIButton *moreBtn;
@property (nonatomic, strong)  UIButton *indexBtn; 
@property (nonatomic, strong) Y_StockChartView *stockChartView;


@property (nonatomic, strong)  NSMutableArray<UIButton *>   *btnArray,*btnArray1,*btnArray2,*btnArray3;

@end

NS_ASSUME_NONNULL_END
