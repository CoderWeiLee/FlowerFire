//
//  AFHTTPSessionManager+AFNShareManager.h
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/4.
//  Copyright © 2019 Celery. All rights reserved.
//
 

#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

@interface AFHTTPSessionManager (AFNShareManager)

+(instancetype)shareManager;
 
@end

NS_ASSUME_NONNULL_END
