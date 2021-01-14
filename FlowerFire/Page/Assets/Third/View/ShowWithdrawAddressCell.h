//
//  ShowDepositAddressCell.h
//  FireCoin
//
//  Created by 王涛 on 2019/8/2.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShowWithdrawAddressCell : BaseTableViewCell

-(void)setCellData:(NSDictionary *)dic symbol:(NSString *)symbol;

@end

NS_ASSUME_NONNULL_END
