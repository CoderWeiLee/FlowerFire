//
//  WalletDetailsLIstModel.m
//  531Mall
//
//  Created by 王涛 on 2020/6/8.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "WalletDetailsListModel.h"

@implementation WalletDetailsListModel

- (NSString *)time{
    return [HelpManager getTimeStr:_time dataFormat:@"yyyy-MM-dd HH:mm:ss"];
}

@end
