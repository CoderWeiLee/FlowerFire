//
//  WalletDetailsListCell.h
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "WalletDetailsListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface WalletDetailsListCell : BaseTableViewCell

-(void)setCellData:(WalletDetailsListModel *)model;

@end

NS_ASSUME_NONNULL_END
