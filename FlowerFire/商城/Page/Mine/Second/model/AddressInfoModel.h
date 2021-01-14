//
//  AddressInfoModel.h
//  531Mall
//
//  Created by 王涛 on 2020/6/3.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressInfoModel : WTBaseModel

@property(nonatomic, copy)NSString *address;
@property(nonatomic, copy)NSString *area;
@property(nonatomic, copy)NSString *area_info;
@property(nonatomic, copy)NSString *city;
@property(nonatomic, copy)NSString *city_info;
@property(nonatomic, copy)NSString *consignee;
@property(nonatomic, copy)NSString *country;
@property(nonatomic, copy)NSString *email;
@property(nonatomic, copy)NSString *AddressId;
@property(nonatomic, copy)NSString *is_default;
@property(nonatomic, copy)NSString *mobile;
@property(nonatomic, copy)NSString *province;
@property(nonatomic, copy)NSString *province_info;
@property(nonatomic, copy)NSString *street;
@property(nonatomic, copy)NSString *user_id;
@property(nonatomic, copy)NSString *zipcode;
 
@end

NS_ASSUME_NONNULL_END
