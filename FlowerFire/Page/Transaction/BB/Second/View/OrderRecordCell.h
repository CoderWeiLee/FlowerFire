//
//  OrderRecordCell.h
//  FireCoin
//
//  Created by 王涛 on 2019/5/30.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "OrderRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderRecordCell : BaseTableViewCell

-(void)setCellData:(OrderRecordModel *)model;

@end

NS_ASSUME_NONNULL_END
