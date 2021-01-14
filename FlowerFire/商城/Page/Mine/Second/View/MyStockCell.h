//
//  MyStockCell.h
//  531Mall
//
//  Created by 王涛 on 2020/5/21.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MyStockModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyStockCell : BaseTableViewCell

-(void)setCellData:(MyStockSkuListModel *)model;

@end

NS_ASSUME_NONNULL_END
