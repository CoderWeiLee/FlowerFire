//
//  TaskModel.h
//  531Mall
//
//  Created by 王涛 on 2020/6/15.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface TaskModel : WTBaseModel

@property(nonatomic,copy)NSString *article_id;
@property(nonatomic,copy)NSString *taskID;
@property(nonatomic,copy)NSString *is_show;
@property(nonatomic,copy)NSString *money;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *details;
@property(nonatomic,copy)NSString *img;
/// 1为签到，2为文章type为1跳转到签到页面（个人中心），为2跳转到文章详情页面（文章ID为article_id）
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString *created_time;
@property(nonatomic,copy)NSString *updated_time;
/// 是否能领取任务
@property(nonatomic,assign)NSInteger is_get;
/// 是否获得奖励
@property(nonatomic,assign)NSInteger is_reward;
 
@end

NS_ASSUME_NONNULL_END
