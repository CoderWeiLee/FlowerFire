//
//  MyCommissionOrderRecordTBVC.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/11.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "OrderRecordTBVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyCommissionOrderRecordTBVC : OrderRecordTBVC

@property(nonatomic ,strong) NSString *otcOrderId;
@property(nonatomic ,strong) UIView   *headerView;
@end

NS_ASSUME_NONNULL_END
