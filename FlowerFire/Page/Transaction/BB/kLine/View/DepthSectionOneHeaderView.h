//
//  DepthSectionOneHeaderView.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/6.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseUIView.h"
#import "CFDeepView.h" 

NS_ASSUME_NONNULL_BEGIN

@interface DepthSectionOneHeaderView : BaseUIView

/**
 买盘数量
 */
@property(nonatomic, strong) UILabel     *buyAmountLabel;
/**
 价格
 */
@property(nonatomic, strong) UILabel     *coinPriceLabel;
/**
 卖盘j数量
 */
@property(nonatomic, strong) UILabel     *saleAmountLabel;

@property(nonatomic, strong) CFDeepView  *klineDeepView;

-(void)setCoinName:(NSString *)leftName
         rightName:(NSString *)rightName
          depthDic:(NSDictionary *)depthDic
        priceScale:(int)priceScale
         fromScale:(int)fromScale;


@end

NS_ASSUME_NONNULL_END
