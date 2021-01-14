//
//  ChooseCoinTBVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/7/31.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewController.h"
#import "ChooseCoinListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ChooseCoinType) {
    ChooseCoinTypeDeposit,  //充币
    ChooseCoinTypeWithdraw, //提币
};

typedef void(^SwitchCoinBlock)(ChooseCoinListModel *model);

@interface ChooseCoinTBVC : BaseTableViewController

/**
 必须传类型初始化

 @return vc
 */
-(instancetype)initWithChooseCoinType:(ChooseCoinType)chooseCoinType;

/**
 是否是已经在提币和充币页面里面了，进行切换币
 */
@property(nonatomic, assign) BOOL isSwitchCoin;
/**
 是否是已经在提币和充币页面里面了，进行切换币的回调
 */
@property(nonatomic, copy) SwitchCoinBlock  switchCoinBlock;
@end

NS_ASSUME_NONNULL_END
