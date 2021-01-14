//
//  AddWithdrawAddressVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/8/2.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddWithdrawAddressVC : BaseViewController

@property(nonatomic, strong)NSString *coinId;
@property(nonatomic, strong)NSString *coinName;
/**
 已有几个地址了
 */
@property(nonatomic, assign)NSInteger hasAddressCount;

 

@end

NS_ASSUME_NONNULL_END
