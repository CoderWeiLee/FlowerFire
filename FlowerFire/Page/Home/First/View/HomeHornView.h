//
//  HomeHornView.h
//  FlowerFire
//
//  Created by 王涛 on 2020/4/28.
//  Copyright © 2020 Celery. All rights reserved.
//  小喇叭视图

#import <UIKit/UIKit.h>
#import "UUMarqueeView.h"
#import "NoteModel.h" 

NS_ASSUME_NONNULL_BEGIN

@interface HomeHornView : BaseUIView

@property(nonatomic, strong)NSMutableArray<NoteModel *> *dataSource;
@property(nonatomic, strong)UUMarqueeView               *marqueeView;

@end

NS_ASSUME_NONNULL_END
