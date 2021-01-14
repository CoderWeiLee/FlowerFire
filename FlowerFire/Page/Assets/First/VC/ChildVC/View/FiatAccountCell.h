//
//  FiatAccountCell.h
//  FlowerFire
//
//  Created by 王涛 on 2020/4/30.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CoinAccountChildVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface FiatAccountCell : BaseTableViewCell

-(void)setCellData:(NSDictionary *)dic
CoinAccountType:(CoinAccountType )coinAccountType;

@end

NS_ASSUME_NONNULL_END
