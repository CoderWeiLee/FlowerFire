//
//  NSArray+WTNull.m
//  531Mall
//
//  Created by 王涛 on 2020/6/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "NSArray+WTNull.h"
#import "NSDictionary+WTNull.h"

@implementation NSArray (WTNull)

-(NSArray *)arrayReplaceNullByString{
    
    NSMutableArray *mutArray = [self mutableCopy];
    
    //遍历数组中的元素
    for (int idx = 0; idx < mutArray.count; idx ++) {
        
        //因为不清楚value的类型，所以定义一个万能id类型
        id value = mutArray[idx];
        
        //判断value的类型是字符串
        if ([value isKindOfClass:[NSString class]]) {
            
            //遇到该死的null替换成""
            if ([value isEqualToString:@"<null>"] ||
                [value isEqualToString:@"NSNull"] ||
                [value isEqualToString:@"null"] ||
                [value isEqualToString:@"NULL"] ||
                [value isEqualToString:@"Null"]) {
                [mutArray replaceObjectAtIndex:idx withObject:@""];
            }
            
        }
        
        //判断value的类型是字典，调用字典的容错方法
        else if ([value isKindOfClass:[NSDictionary class]]){
            [mutArray replaceObjectAtIndex:idx withObject:[value wt_dictionaryReplaceNullByString]]; 
        }
        
        //判断value的类型是数组，继续调用一遍解析
        else if ([value isKindOfClass:[NSArray class]]) {
            [mutArray replaceObjectAtIndex:idx withObject:[value arrayReplaceNullByString]];
        }
        
        //判断value的类型是对象
        else{
            
            //定义一个id类型对象，如果是该死的NSNull类型替换成""
            id null = [NSNull null];
            if (value == null || [value isEqual:[NSNull class]]) {
                [mutArray replaceObjectAtIndex:idx withObject:@""];
            }
            
        }
        
    }
    
    //把处理的最终结果返回回去
    return (NSArray *)[mutArray copy];
    
}


@end
