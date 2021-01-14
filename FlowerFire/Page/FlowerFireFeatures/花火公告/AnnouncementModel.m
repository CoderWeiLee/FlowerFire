//
//  AnnouncementModel.m
//  FlowerFire
//
//  Created by 王涛 on 2020/9/2.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "AnnouncementModel.h"

@implementation AnnouncementModel

- (void)setCreate_time:(NSString *)create_time{
    _create_time = [HelpManager getTimeStr:create_time dataFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"announcementID":@"id"};
    
}

@end
