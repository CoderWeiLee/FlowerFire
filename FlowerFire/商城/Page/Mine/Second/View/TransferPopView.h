//
//  TransferPopView.h
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    TransferPopBalance = 0, //余额转账
    TransferPopEquity,      //股权转账
    TransferPopIntegralExchange             //兑换购物积分
} TransferPopType;

@interface TransferPopView : BaseUIView

-(instancetype)initWithFrame:(CGRect)frame TransferPopType:(TransferPopType)type;

/// 钱包名
@property(nonatomic, strong)NSString *bankName;
/// 转账要的参数
@property(nonatomic, strong)NSString *giveTitle;

@property(nonatomic, copy)dispatch_block_t closePopViewBlock;

/// 转账成功刷新页面
@property(nonatomic, copy)dispatch_block_t transferSuccessBlock;
@end

NS_ASSUME_NONNULL_END
