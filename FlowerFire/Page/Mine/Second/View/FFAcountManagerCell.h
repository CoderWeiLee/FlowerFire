//
//  FFAcountManagerCell.h
//  FlowerFire
//
//  Created by 王涛 on 2020/8/24.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "UserAccount+CoreDataProperties.h"

NS_ASSUME_NONNULL_BEGIN

@interface FFAcountManagerCell : BaseTableViewCell

@property(nonatomic, strong)WTButton  *singleButton;
@property(nonatomic, strong)WTButton  *arrowButton;
@property(nonatomic, strong)WTLabel   *tip;

-(void)setCellData:(UserAccount *)userAccount;

@end

NS_ASSUME_NONNULL_END
