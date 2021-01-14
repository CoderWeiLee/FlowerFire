//
//  BulletinModel.m
//  FilmCrowdfunding
//
//  Created by 王涛 on 2019/11/25.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "BulletinModel.h"

@implementation BulletinModel

 
- (void)setCtime:(NSString *)ctime{
   _ctime = [HelpManager getTimeStr:ctime dataFormat:@"yyyy-MM-dd HH:mm:ss"];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"bulletinId":@"id"};
    
}

@end
