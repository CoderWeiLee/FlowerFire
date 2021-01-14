//
//  AddressViewController.h
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewController.h"
#import "AddressInfoModel.h"

typedef void(^DidSelectedAddressBlock)(AddressInfoModel* _Nullable model);
 
NS_ASSUME_NONNULL_BEGIN

@interface AddressManagerViewController : BaseTableViewController

@property(nonatomic, copy)DidSelectedAddressBlock didSelectedAddressBlock;
@property(nonatomic, copy)dispatch_block_t        noHasAddressBlock;
/// 是模态跳转过来的
@property(nonatomic, assign)BOOL                  ismodalPresentation;
@end

NS_ASSUME_NONNULL_END
