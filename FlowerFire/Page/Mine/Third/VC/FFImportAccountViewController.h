//
//  FFImportAccountViewController.h
//  FlowerFire
//
//  Created by 王涛 on 2020/8/24.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewController.h"
typedef enum : NSUInteger {
    FFImportAccountTypeMnemonic = 0,//助记词
    FFImportAccountTypePrivateKey,//私钥
    
} FFImportAccountType;

NS_ASSUME_NONNULL_BEGIN

@interface FFImportAccountViewController : BaseViewController

 
@end

@interface FFImportAccountChildViewController : BaseViewController

-(instancetype)initWithFFImportAccountType:(FFImportAccountType)FFImportAccountType;

@end

NS_ASSUME_NONNULL_END
