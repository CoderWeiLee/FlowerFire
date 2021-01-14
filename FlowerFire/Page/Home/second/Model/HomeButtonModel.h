//
//  HomeButtonModel.h
//  FlowerFire
//
//  Created by 王涛 on 2020/5/27.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeButtonModel : WTBaseModel

@property (nullable, nonatomic, copy) NSString *buttonImageName;
@property (nullable, nonatomic, copy) NSString *buttonTitle;
@property (nullable, nonatomic, copy) NSString *webView;
@property (nullable, nonatomic, copy) NSString *viewControllerName;
@property (nullable, nonatomic, copy) NSString *buttonID;
@property (nullable, nonatomic, copy) NSString *sortID;

@end

NS_ASSUME_NONNULL_END
