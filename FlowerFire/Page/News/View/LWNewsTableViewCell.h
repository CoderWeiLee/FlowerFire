//
//  LWNewsTableViewCell.h
//  FlowerFire
//
//  Created by 李伟 on 2021/1/20.
//  Copyright © 2021 Celery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LWNewsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface LWNewsTableViewCell : UITableViewCell
@property (nonatomic, strong) LWNewsModel *model;
@end

NS_ASSUME_NONNULL_END
