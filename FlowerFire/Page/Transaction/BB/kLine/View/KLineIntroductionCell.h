//
//  KLineIntroductionCell.h
//  FireCoin
//
//  Created by 王涛 on 2019/7/4.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BlockchainIntroductionModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface KLineIntroductionCell : BaseTableViewCell

@property (nonatomic, strong)UILabel *leftLabel;
@property (nonatomic, strong)UILabel *rightLabel;

-(void)setCellData:(NSArray<BlockchainIntroductionModel *> *)modelArray cellIndex:(NSInteger)cellIndex;

@end

NS_ASSUME_NONNULL_END
