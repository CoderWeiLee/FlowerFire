//
//  SettingUpdateHeaderView.h
//  FlowerFire
//
//  Created by 王涛 on 2020/5/5.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SettingUpdateHeaderView : BaseUIView

/// 修改的标题 
-(instancetype)initWithFrame:(CGRect)frame changeTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
