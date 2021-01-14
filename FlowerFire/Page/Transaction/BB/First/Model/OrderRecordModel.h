//
//  OrderRecordModel.h
//  FireCoin
//
//  Created by 王涛 on 2019/5/30.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LegalCurrencyModel.h"
#import "payMethodModel.h"
NS_ASSUME_NONNULL_BEGIN

/**
 委托单用户信息
 */
@interface tradeUserInfoModel : NSObject
@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, copy) NSString *kyc;  //  认证等级
@property(nonatomic, copy) NSString *trade_num;  // 交易笔数
@property(nonatomic, copy) NSString *email;  // email
@property(nonatomic, copy) NSString *mobile;  //手机号

@end

/**
 订单用户信息
 */
@interface orderUserInfoModel : NSObject
@property(nonatomic, copy) NSString *nickname;
@property(nonatomic, copy) NSString *kyc;  //  认证等级
@property(nonatomic, copy) NSString *trade_num;  // 交易笔数
@property(nonatomic, copy) NSString *mobile;  //手机号

@end

@interface OrderRecordModel : NSObject

@property(nonatomic, copy) NSString *otcOrderId;   //订单id
@property(nonatomic, copy) NSString *price;   // 单价
@property(nonatomic, copy) NSString *amount ;   //  数量
@property(nonatomic, copy) NSString *total_price ;  //交易总金额
@property(nonatomic, copy) NSString *order_status  ; // 订单状态:-2申诉中-1=取消,0=待付款,1=已付款,待放币,2=交易成功
@property(nonatomic, copy) NSString *desc ;  // 交易说明
@property(nonatomic, copy) NSString *addtime ;  //  开始时间
@property(nonatomic, copy) NSString *end_time; //   订单结束时间
@property(nonatomic, copy) NSString *symbol;    //  币名字
@property(nonatomic, copy) NSString *order_type;    //  是的  0 购买 1 出售
@property(nonatomic, strong) owerModel *ower ;  //   商家信息 trade_num 交易笔数
@property(nonatomic, strong) tradeUserInfoModel *trade_uinfo ;  //   委托单用户信息
@property(nonatomic, strong) orderUserInfoModel *order_uinfo ;  //   订单用户信息
@property(nonatomic, strong) NSArray<payMethodModel *> *pay_list; //支付方式
@property(nonatomic, copy) NSArray<NSString *> *from_appeal_imgs; //订单发起者申诉图片
@property(nonatomic, copy) NSString *from_content;   //订单发起者申诉内容
@property(nonatomic, copy) NSArray<NSString *> *to_appeal_imgs;  //订单被动者申诉图片
@property(nonatomic, copy) NSString *to_content;    //订单被动者申诉内容
@property(nonatomic, copy) NSString *relase_end_time; //放币超时时间 已支付情况才有效，0为永不超时
@property(nonatomic, copy) NSString *fromtime; //订单发起者申诉时间
@property(nonatomic, copy) NSString *totime;   //订单被动者申诉时间

@property(nonatomic, assign)NSInteger is_timeout;//判断是否 已超时，1是超时了

@property(nonatomic, copy) NSString *is_from;   //是否发起者，0 显示to_content ， 1 显示from_content
@property(nonatomic, copy) NSString *is_appeal; //是否已经申诉，0 跳转申诉页面 ， 1 跳转申诉详情页
@end


NS_ASSUME_NONNULL_END
