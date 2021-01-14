//
//  MyKeepTableViewCell.h
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MyKeepModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyKeepTableViewCell : BaseTableViewCell

-(void)setCellData:(MyKeepModel *)model;

@end

NS_ASSUME_NONNULL_END
