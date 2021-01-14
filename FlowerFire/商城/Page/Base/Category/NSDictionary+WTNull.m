//
//  NSDictionary+WTNull.m
//  531Mall
//
//  Created by 王涛 on 2020/6/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "NSDictionary+WTNull.h"
#import "NSArray+WTNull.h"

@implementation NSDictionary (WTNull)

-(NSDictionary *)wt_dictionaryReplaceNullByString{
    
    NSMutableDictionary *mutDictionary = [self mutableCopy];
    
    //遍历字典中的key
    for (NSString *key in self) {
        
        //因为不清楚value的类型，所以定义一个万能id类型
        id value = self[key];
        
        //判断value的类型是字符串
        if ([value isKindOfClass:[NSString class]]) {
            
            //遇到该死的null替换成""
            if ([value isEqualToString:@"<null>"] ||
                [value isEqualToString:@"NSNull"] ||
                [value isEqualToString:@"null"] ||
                [value isEqualToString:@"NULL"] ||
                [value isEqualToString:@"Null"]) {
                [mutDictionary setValue:@"" forKey:key];
            }
            
        }
        
        //判断value的类型是字典，继续调用一遍解析
        else if ([value isKindOfClass:[NSDictionary class]]) {
            [mutDictionary setValue:[value wt_dictionaryReplaceNullByString] forKey:key];
        }
        
        //判断value的类型是数组，调用数组的容错方法
        else if ([value isKindOfClass:[NSArray class]]) {
            [mutDictionary setValue:[value arrayReplaceNullByString] forKey:key];
        }
        
        //判断value的类型是对象
        else{
            
            //定义一个id类型对象，如果是该死的NSNull类型替换成""
            id null = [NSNull null];
            if (value == null || [value isEqual:[NSNull class]]) {
                [mutDictionary setValue:@"" forKey:key];
            }
            
        }
    }
    
    //把处理的最终结果返回回去
    return (NSDictionary *)[mutDictionary copy];

}

@end
