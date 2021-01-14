//
//  payMethodModel.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/10.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface payMethodModel : NSObject

@property(nonatomic, copy) NSString *referenceId ;//参考号
@property(nonatomic, copy) NSString *account;  //银行卡号
@property(nonatomic, copy) NSString *true_name; //名字
@property(nonatomic, copy) NSString *qrcode; //二维码
@property(nonatomic, copy) NSString *bank_address ; //银行名
/**
 1银行卡", 2"支付宝",  3微信支付",
 */
@property(nonatomic, copy) NSString *type_id;
@end

NS_ASSUME_NONNULL_END
