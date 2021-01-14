//
//  PermissionUtil.m
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/5.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "PermissionUtil.h"
#import "LBXPermission.h"

@implementation PermissionUtil

+ (void)checkPhotoPermission{
    //相册
   [LBXPermission authorizeWithType:LBXPermissionType_Photos completion:^(BOOL granted, BOOL firstTime) {
        
       [self handCompletionWithGranted:granted firstTime:firstTime permissionName:LocalizationKey(@"permissionPhotoTip")];
   }];
}

+ (void)checkCameraPermission{
    //相机
   [LBXPermission authorizeWithType:LBXPermissionType_Camera completion:^(BOOL granted, BOOL firstTime) {
       
       [self handCompletionWithGranted:granted firstTime:firstTime permissionName:LocalizationKey(@"permissionCameraTip")];
   }];
}


+ (void)handCompletionWithGranted:(BOOL)granted
                        firstTime:(BOOL)firstTime permissionName:(NSString *)permissionName;
{
    //没有权限，且不是第一次获取权限
    if ( !granted && !firstTime )
    {
        [LBXPermissionSetting showAlertToDislayPrivacySettingWithTitle:LocalizationKey(@"utilTip5") msg:NSStringFormat(@"%@ %@ %@",LocalizationKey(@"permissionTip1"),permissionName,LocalizationKey(@"permissionTip12")) cancel:LocalizationKey(@"cancel") setting:LocalizationKey(@"permissionTip13")];
    }
}

@end
