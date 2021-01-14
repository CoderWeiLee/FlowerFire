//
//  MineMainHeaderView.h
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MineMainHeaderViewDelegate <NSObject>

-(void)singUpClick:(UIButton *)button;
-(void)certificationClick:(UIButton *)button;

@end

@interface MineMainHeaderView : BaseUIView

@property(nonatomic, strong)    UIView         *whiteBac;
@property(nonatomic, weak)    id<MineMainHeaderViewDelegate> delegate;

/// 更新下用户名字或者等级
-(void)updateUserInfoCache;

@end

NS_ASSUME_NONNULL_END
