//
//  AnnouncementModel.h
//  FlowerFire
//
//  Created by 王涛 on 2020/9/2.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AnnouncementModel : WTBaseModel

@property(nonatomic, copy)NSString  *announcementID;
@property(nonatomic, copy)NSString  *title;
@property(nonatomic, copy)NSString  *create_time;
 

@end

NS_ASSUME_NONNULL_END
