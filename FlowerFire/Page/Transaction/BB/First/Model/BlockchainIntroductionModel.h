//
//  BlockchainIntroductionModel.h
//  FireCoin
//
//  Created by 王涛 on 2019/7/5.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BlockchainIntroductionModel : NSObject

/**
 标题
 */
@property(nonatomic, copy) NSString *title;
/**
 发行时间
 */
@property(nonatomic, copy) NSString *public_time;
/**
 发行总量
 */
@property(nonatomic, copy) NSString *total_num;
/**
 流通总量
 */
@property(nonatomic, copy) NSString *total_market;
/**
 众筹价格
 */
@property(nonatomic, copy) NSString *group_price;
/**
 白皮书
 */
@property(nonatomic, copy) NSString *white_book;
/**
 官网
 */
@property(nonatomic, copy) NSString *url;
/**
 区块查询
 */
@property(nonatomic, copy) NSString *block_url;
/**
 简介
 */
@property(nonatomic, copy) NSString *detail; 


@end

NS_ASSUME_NONNULL_END
