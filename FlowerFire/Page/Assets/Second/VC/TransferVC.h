//
//  TransferVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/1.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TransferVC : BaseViewController

/**
  是从合约页面跳转过来的,带默认的币种
 */
@property(nonatomic, strong)NSString *defaultSymbol;

@end

NS_ASSUME_NONNULL_END
