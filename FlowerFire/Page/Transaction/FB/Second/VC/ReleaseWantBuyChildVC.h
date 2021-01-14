//
//  ReleaseWantBuyChildVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/5/31.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    ReleaseWantBuyTypeBuy,  //购买
    ReleaseWantBuyTypeSale, //出售
   
} ReleaseWantBuyType;

NS_ASSUME_NONNULL_BEGIN

@interface ReleaseWantBuyChildVC : BaseViewController

@property(nonatomic, assign)ReleaseWantBuyType releaseWantBuyType;

/**
 必传coinId和coin名字
 */
@property(nonatomic, strong) NSString     *coinId,*coinName;
@property(nonatomic, strong) NSDictionary *netDic; // 网络数据字典

@end

NS_ASSUME_NONNULL_END
