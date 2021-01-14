//
//  AddDepositAddressTBVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/8/2.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^didSelectedAddressBlock)(NSString *address,NSString *tag);

@interface ShowWithdrawAddressTBVC : BaseTableViewController

@property(nonatomic, strong)NSString *coinId;

/**
 地址选择回调，地址和tag
 */
@property(nonatomic, copy)didSelectedAddressBlock  didSeletedAddressBlock;

@end

NS_ASSUME_NONNULL_END
