//
//  MyWalletModel.h
//  531Mall
//
//  Created by 王涛 on 2020/6/8.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyWalletModel : WTBaseModel

/// 余额
@property(nonatomic, copy)NSString *balance;
@property(nonatomic, copy)NSString *bankname;// "余额钱包"; 
@property(nonatomic, copy)NSString *sheet;// = bank1;
@end

NS_ASSUME_NONNULL_END
