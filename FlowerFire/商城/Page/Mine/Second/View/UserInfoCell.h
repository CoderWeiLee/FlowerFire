//
//  UserInfoCell.h
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoCell : BaseTableViewCell

@property(nonatomic, strong)WTLabel *leftLabel,*rightLabel;
@property(nonatomic, strong)UIView  *bacView;
@end

NS_ASSUME_NONNULL_END
