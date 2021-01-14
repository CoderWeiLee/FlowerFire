//
//  LegalCurrencyModel.h
//  FireCoin
//
//  Created by 王涛 on 2019/5/28.
//  Copyright © 2019 王涛. All rights reserved.
//  法币交易model

#import <Foundation/Foundation.h>
#import "payMethodModel.h" 
NS_ASSUME_NONNULL_BEGIN

@interface owerModel : NSObject
@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, copy) NSString *kyc;  //  认证等级
@property(nonatomic, copy) NSString *trade_num;  // 交易笔数
@property(nonatomic, copy) NSString *email;  // email
@property(nonatomic, copy) NSString *mobile;  //手机号

@end

@interface LegalCurrencyModel : NSObject

@property(nonatomic, copy) NSString *otcId;   //交易id
@property(nonatomic, copy) NSString *price;   // 单价
@property(nonatomic, copy) NSString *amount ;   //  数量
@property(nonatomic, copy) NSString *surplus ;  //剩余可交易数量
@property(nonatomic, copy) NSString *verify_level;   //   限制认证等级
@property(nonatomic, copy) NSString *limit_reg_time  ; //  限制注册时间 0 不限制
@property(nonatomic, copy) NSString *desc ;  // 交易说明
@property(nonatomic, copy) NSString *order_type;  //0购买 1出售
@property(nonatomic, copy) NSString *order_status; //订单状态:all=全部,-2=申诉,-1=取消,0=待付款,1=已付款,待放币,2=交易成功
@property(nonatomic, copy) NSString *limit_min ;  //  限额最小数量
@property(nonatomic, copy) NSString *limit_max;    //  限额最大数量
@property(nonatomic, copy) NSString *symbol;    //  币名字
//@property(nonatomic, copy) NSString *end_time; //   订单结束时间
@property(nonatomic, strong) owerModel *ower ;  //   商家信息 trade_num 交易笔数
@property(nonatomic, strong) NSArray<payMethodModel *> *pay_list; //支付方式

@property(nonatomic, copy) NSString *addtime; //委托单发布时间
@property(nonatomic, copy) NSString *otc_id; // 订单id
@property(nonatomic, copy) NSString *trade_amount; //币剩余数量

@end



NS_ASSUME_NONNULL_END
