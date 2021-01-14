//
//  LevelUpMemberViewController.h
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MemberLevelVIP = 10, //vip
    MemberLevelManager = 20,//营销经理
    MemberLevelDirector = 30,//营销总监
} MemberLevel;

@interface LevelUpMemberViewController : BaseTableViewController

@property(nonatomic, assign)MemberLevel memberLevel;

@end

NS_ASSUME_NONNULL_END
