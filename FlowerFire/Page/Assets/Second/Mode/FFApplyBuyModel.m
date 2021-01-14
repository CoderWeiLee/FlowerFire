//
//  FFApplyBuyModel.m
//  FlowerFire
//
//  Created by 王涛 on 2020/8/31.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "FFApplyBuyModel.h"

@implementation FFApplyBuyModel

- (void)setStart_time:(NSString *)start_time{
    _start_time = [HelpManager getTimeStr:start_time dataFormat:@"yyyy-MM-dd"];
}

- (void)setEnd_time:(NSString *)end_time{
    _end_time = [HelpManager getTimeStr:end_time dataFormat:@"yyyy-MM-dd"];
}

- (NSString *)max_exchange_amount{
    if([HelpManager isBlankString:_max_exchange_amount]){
        return @"";
    }else{
        return _max_exchange_amount;
    }
}

@end
