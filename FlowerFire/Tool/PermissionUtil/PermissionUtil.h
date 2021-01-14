//
//  PermissionUtil.h
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/5.
//  Copyright © 2019 Celery. All rights reserved.
//  权限获取工具

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PermissionUtil : NSObject

/// 获取相册权限
+(void)checkPhotoPermission;

/// 获取相机权限
+(void)checkCameraPermission;

@end

NS_ASSUME_NONNULL_END
