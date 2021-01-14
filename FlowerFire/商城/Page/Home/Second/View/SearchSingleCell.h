//
//  SearchSingleCell.h
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitViewProtocol.h"
#import "GoodsInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SearchSingleCell : UICollectionViewCell<InitViewProtocol>

-(void)setCellData:(GoodsInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
