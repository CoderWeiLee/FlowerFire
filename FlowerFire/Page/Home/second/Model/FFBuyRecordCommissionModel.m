//
//  FFBuyRecordCommisionModel.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/29.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "FFBuyRecordCommissionModel.h"

@implementation FFBuyRecordCommissionModel

- (NSString *)addtime{
    return [HelpManager getTimeStr:_addtime dataFormat:@"yyyy-MM-dd HH:mm:ss"];
}

@end
