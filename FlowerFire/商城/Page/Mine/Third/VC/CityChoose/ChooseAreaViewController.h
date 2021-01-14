//
//  ChooseAreaViewController.h
//  FilmCrowdfunding
//
//  Created by 王涛 on 2019/11/25.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChooseAreaViewController : BaseTableViewController

/// 城市id
@property(nonatomic, strong)NSString *provinceId;
@property(nonatomic, strong)NSString *provinceName;
@property(nonatomic, strong)NSDictionary *provinceDic;

@end


NS_ASSUME_NONNULL_END
