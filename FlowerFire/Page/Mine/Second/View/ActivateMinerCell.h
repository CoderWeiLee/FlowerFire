//
//  ActivateMinerCell.h
//  FlowerFire
//
//  Created by 王涛 on 2020/8/24.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FFMinerListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActivateMinerCell : BaseTableViewCell

-(void)setCellData:(FFMinerListModel *)model;

@end

NS_ASSUME_NONNULL_END
