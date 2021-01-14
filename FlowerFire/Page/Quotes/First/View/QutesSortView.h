//
//  QutesSortView.h
//  FlowerFire
//
//  Created by 王涛 on 2020/4/29.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol QutesSortViewDelegate <NSObject>

-(void)sortByName:(UIButton *)button;
-(void)sortByPrice:(UIButton *)button;
-(void)sortByChange:(UIButton *)button;

@end

@interface QutesSortView : BaseUIView

@property (nonatomic, strong) UIButton *sortBtn;
@property (nonatomic, strong) UIButton *sortBtn1;
@property (nonatomic, strong) UIButton *sortBtn2;

@property (nonatomic, weak)id<QutesSortViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
