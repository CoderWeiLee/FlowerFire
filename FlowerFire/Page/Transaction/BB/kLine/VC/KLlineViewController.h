//
//  KLlineViewController.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/5.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewController.h"
#import "LeftMenuViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol KLlineViewControllerDelegate <NSObject>

/**
 点击买或卖回调
 
 @param btn 响应的按钮
 @param TransactionPairName 交易对名字
 @param fromId 交易对id
 */
-(void)didTrade:(UIButton *)btn TransactionPairName:(NSString *)TransactionPairName fromId:(NSString *)fromId;

@end

@interface KLlineViewController : BaseTableViewController

@property(nonatomic, strong) LeftMenuViewController          *menuVC;
@property(nonatomic, weak) id<KLlineViewControllerDelegate>  delegate;

@property(nonatomic, assign)int                               fromScale;     //交易对钱精确度(小数点后几位)
@property(nonatomic, assign)int                               toScale;         //交易对后精确度
@property(nonatomic, assign)int                               priceScale;     //价格精确度
@property(nonatomic, strong)NSString                         *TransactionPairName;//交易对
/**
 交易对前货币id
 */
@property(nonatomic, strong) NSString                        *fromId;

@end

NS_ASSUME_NONNULL_END
