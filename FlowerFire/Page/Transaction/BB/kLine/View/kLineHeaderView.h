//
//  kLineHeaderView.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/5.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseUIView.h"
#import "QuotesTransactionPairModel.h"
#import "Y_KLineModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface kLineHeaderView : BaseUIView

@property (nonatomic, strong)  UILabel *nowPrice;
@property (nonatomic, strong)  UILabel *CNYLabel;
@property (nonatomic, strong)  UILabel *changeLabel;
@property (nonatomic, strong)  UILabel *hightPrice;
@property (nonatomic, strong)  UILabel *LowPrice;
@property (nonatomic, strong)  UILabel *numberLabel;
@property (nonatomic, strong)  UILabel *Hlabel;
@property (nonatomic, strong)  UILabel *Llabel;
@property (nonatomic, strong)  UILabel *Alabel;

@property (nonatomic, strong) QuotesTransactionPairModel *model;

/**
 币股交易的数据源
 */
@property (nonatomic, strong) Y_KLineModel *Y_KLineModel;

@end

NS_ASSUME_NONNULL_END
