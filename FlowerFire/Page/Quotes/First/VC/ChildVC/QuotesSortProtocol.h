//
//  QuotesSortProtocol.h
//  FlowerFire
//
//  Created by 王涛 on 2020/4/29.
//  Copyright © 2020 Celery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "QuotesTradingZoneModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QuotesSortProtocol <NSObject>

@property(nonatomic, assign)int sortType,sortDirection;

-(void)startSortData:(UIViewController *)qvc model:(QuotesTradingZoneModel *)model;

@end

NS_ASSUME_NONNULL_END
