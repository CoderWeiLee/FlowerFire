//
//  FFMinerListModel.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/27.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "FFMinerListModel.h"

@implementation FFMinerListModel

- (NSString *)activation_time{
    return [HelpManager getTimeStr:_activation_time dataFormat:@"yyyy-MM-dd HH:mm:ss"];
}

@end
