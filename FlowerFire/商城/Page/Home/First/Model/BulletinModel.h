//
//  BulletinModel.h
//  FilmCrowdfunding
//
//  Created by 王涛 on 2019/11/25.
//  Copyright © 2019 Celery. All rights reserved.
//  公告数据

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BulletinModel : NSObject

@property(nonatomic, copy)NSString *content;
@property(nonatomic, copy)NSString *title;
@property(nonatomic, copy)NSString *ctime;
@property(nonatomic, copy)NSString *bulletinId;
@end

NS_ASSUME_NONNULL_END
