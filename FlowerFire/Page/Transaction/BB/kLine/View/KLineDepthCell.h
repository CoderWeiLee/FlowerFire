//
//  KLineDepthCell.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/6.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLineDepthCell : BaseTableViewCell

@property (nonatomic, strong)  UILabel *BuyIndex;
@property (nonatomic, strong)  UILabel *BuyNum;
@property (nonatomic, strong)  UILabel *BuyPrice;
@property (nonatomic, strong)  UILabel *SellPrice;
@property (nonatomic, strong)  UILabel *SellNum;
@property (nonatomic, strong)  UILabel *SellIndex;

-(void)setCellData:(NSDictionary *)depthDic
         cellIndex:(NSInteger)cellIndex
        priceScale:(int)priceScale
         fromScale:(int)fromScale;

-(void)setCellData:(NSDictionary *)depthDic
         cellIndex:(NSInteger)cellIndex;
@end

NS_ASSUME_NONNULL_END
