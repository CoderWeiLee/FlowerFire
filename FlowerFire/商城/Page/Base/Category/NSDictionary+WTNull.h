//
//  NSDictionary+WTNull.h
//  531Mall
//
//  Created by 王涛 on 2020/6/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (WTNull)

-(NSDictionary *)wt_dictionaryReplaceNullByString;


@end

NS_ASSUME_NONNULL_END
