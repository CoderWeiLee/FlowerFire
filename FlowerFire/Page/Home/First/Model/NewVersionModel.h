//
//  NewVersionModel.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/30.
//  Copyright © 2019 王涛. All rights reserved.
//  新版本

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewVersionModel : NSObject

/**
 是否强制更新 1：是 0：否
 */
@property(nonatomic, assign) NSInteger enforce;
/**
  当前客户端版本
 */
@property(nonatomic, strong) NSString  *version;
/**
 新版本
 */
@property(nonatomic, strong) NSString  *newversion;
/**
 下载地址
 */
@property(nonatomic, strong) NSString  *downloadurl;
/**
  安装包大小
 */
@property(nonatomic, strong) NSString  *packagesize;
/**
 更新简介
 */
@property(nonatomic, strong) NSString  *upgradetext;
  
@end

NS_ASSUME_NONNULL_END
