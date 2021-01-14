//
//  TaskModel.m
//  531Mall
//
//  Created by 王涛 on 2020/6/15.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "TaskModel.h"

@implementation TaskModel

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"taskID":@"id"
             ,@"details":@"description"
    };
    
}

- (NSString *)created_time{
    return [HelpManager getTimeStr:_created_time dataFormat:@"yyyy-MM-dd\nHH:mm:ss"];
}

- (NSString *)updated_time{
    return [HelpManager getTimeStr:_updated_time dataFormat:@"yyyy-MM-dd\nHH:mm:ss"];
}
 

@end
