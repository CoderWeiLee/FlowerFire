//
//  SubmitOrderHeaderView.h
//  531Mall
//
//  Created by 王涛 on 2020/5/23.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"
#import "AddressInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SubmitOrderHeaderView : BaseUIView

/// 没有地址的布局
-(void)layoutNoAddress;
-(void)layoutHasAddress:(AddressInfoModel *)model;

@property(nonatomic, copy)dispatch_block_t chooseAddressBlock;

@end

NS_ASSUME_NONNULL_END
