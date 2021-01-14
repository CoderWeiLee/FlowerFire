//
//  EditAddressViewController.h
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewController.h"
#import "AddressInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AddressManagerType) {
    AddressManagerTypeAddNew = 0,//新增
    AddressManagerTypeEdit, //编辑
};

@interface EditAddressViewController : BaseTableViewController

@property(nonatomic, assign)AddressManagerType addressManagerType;

/// 编辑进来有收货地址信息
@property(nonatomic, strong)AddressInfoModel *addressInfoModel;
@end

NS_ASSUME_NONNULL_END
