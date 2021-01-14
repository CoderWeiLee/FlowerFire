//
//  MyKeepModel.h
//  531Mall
//
//  Created by 王涛 on 2020/6/3.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyKeepModel : WTBaseModel

@property(nonatomic, copy)NSString *keepID;
@property(nonatomic, copy)NSString *good_id;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *main_img;
@property(nonatomic, copy)NSString *second_price;
@property(nonatomic, copy)NSString *three_price;
@property(nonatomic, copy)NSString *total_stock;

@end

NS_ASSUME_NONNULL_END
