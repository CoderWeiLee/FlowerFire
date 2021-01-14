//
//  LegalCurrencyTransactionModalVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/5/29.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseViewController.h"
#import "LegalCurrencyModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^legalCurrencytransactionCloseBlock)(BOOL isNext,NSString *otcOrderId,int errorcode); //有否有下一步操作默认没有 直接关闭  订单ID;

@interface LegalCurrencyTransactionModalVC : BaseViewController
/**
 我要买 参数用1
 我要卖 参数用0
 */
@property(nonatomic, strong) NSString            *buyOrSell; // 0购买 1出售
@property(nonatomic, strong) LegalCurrencyModel  *model;
@property(nonatomic, copy)   legalCurrencytransactionCloseBlock closeBlock;
@end

NS_ASSUME_NONNULL_END
