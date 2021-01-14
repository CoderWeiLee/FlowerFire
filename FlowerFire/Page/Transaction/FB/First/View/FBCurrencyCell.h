//
//  FBCurrencyCell.h
//  FlowerFire
//
//  Created by 王涛 on 2020/5/8.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "LegalCurrencyModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface FBCurrencyCell : BaseTableViewCell 

-(void)setCellData:(LegalCurrencyModel *)model
          coinName:(NSString *)coinName
         buyOrSeal:(NSString *)buyOrSeal; //NO 为买

@end

NS_ASSUME_NONNULL_END
