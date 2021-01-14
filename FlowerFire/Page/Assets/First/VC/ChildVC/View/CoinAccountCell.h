//
//  CoinAccountCell.h
//  FireCoin
//
//  Created by 赵馨 on 2019/5/27.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CoinAccountChildVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CoinAccountCell : BaseTableViewCell

-(void)setCellData:(NSDictionary *)dic
   CoinAccountType:(CoinAccountType )coinAccountType;

@end

NS_ASSUME_NONNULL_END
