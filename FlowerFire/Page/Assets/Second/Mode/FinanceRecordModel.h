//
//  FinanceRecordModel.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/22.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FinanceRecordModel : NSObject

/**
 状态  "已完成"
 */
@property (nonatomic, copy) NSString *status_name;
/**
 分类  "卖出"
 */
@property (nonatomic, copy) NSString *cate_name;
/**
 备注 "币币交易卖出成功",
 */
@property (nonatomic, copy) NSString *memo;
/**
 时间
 */
@property (nonatomic, copy) NSString *createtime;
/**
 数量
 */
@property (nonatomic, copy) NSString *money;

 

@end

NS_ASSUME_NONNULL_END
