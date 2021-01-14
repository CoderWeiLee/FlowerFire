//
//  AFHTTPSessionManager+AFNShareManager.m
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/4.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "AFHTTPSessionManager+AFNShareManager.h"

static NSInteger const TimeoutInterval = 8;

@implementation AFHTTPSessionManager (AFNShareManager)

+ (instancetype)shareManager{
    static AFHTTPSessionManager *_manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        _manager = [AFHTTPSessionManager manager];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/json", @"text/javascript", @"text/html", nil];
        _manager.requestSerializer=[AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer]; 
        [_manager.requestSerializer setTimeoutInterval:TimeoutInterval];
    });
    return _manager;
}
 
@end
