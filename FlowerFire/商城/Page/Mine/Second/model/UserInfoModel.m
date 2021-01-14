//
//  UserInfoModel.m
//  531Mall
//
//  Created by 王涛 on 2020/6/6.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

- (NSString *)value{
    if([_variable isEqualToString:@"pass1"]){
        return @"****** ";
    }else if([_variable isEqualToString:@"pass2"]){
        return @"****** ";
    }else{
        return NSStringFormat(@"%@ ",_value);
    }
}
 
@end
