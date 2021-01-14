//
//  MallHomeHornView.h
//  FlowerFire
//
//  Created by 王涛 on 2020/7/25.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"
#import "UUMarqueeView.h"
#import "BaseUIView.h"
#import "GradientView.h"
#import "BulletinModel.h"
 
NS_ASSUME_NONNULL_BEGIN

@interface MallHomeHornView : BaseUIView

@property(nonatomic, strong)NSMutableArray<BulletinModel*>   *dataSource;
@property(nonatomic, strong)UUMarqueeView                    *marqueeView;

@end

NS_ASSUME_NONNULL_END
