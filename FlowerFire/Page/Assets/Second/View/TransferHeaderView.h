//
//  TransferHeaderView.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/1.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^switchTransTypeBlock)(BOOL isCoinAccountAbove);

@interface TransferHeaderView : BaseUIView

@property(nonatomic, strong) UILabel *legalCurrencyAccount; //法币账户
@property(nonatomic, strong) UILabel *coinAccount;          //币币账户
@property(nonatomic, assign) BOOL    isCoinAccountAbove; // 是否是币币账号在上面 默认NO

/**
 切换划转方向后重新请求数据
 */
@property(nonatomic, copy) switchTransTypeBlock switchTransTypeBlock;
@end

NS_ASSUME_NONNULL_END
