//
//  WTUserInfo.m
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/8.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "WTMallUserInfo.h"

static WTMallUserInfo *userInfo = nil;


@implementation WTMallUserInfo

/*  通过初始化userIfo并保存在本地(单利模式)   */
+(instancetype)getuserInfoWithDic:(NSDictionary *)dic{
    userInfo = [[WTMallUserInfo alloc] initWithDictionary:dic];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:MALLUSERINFO];
    [[NSUserDefaults standardUserDefaults] synchronize];//及时存储数据
    return userInfo;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    return [WTMallUserInfo yy_modelWithDictionary:dic];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"ID":@"id"};
    
}
 
/*  获取用户已登陆的信息 */
+(instancetype)shareUserInfo{
    
    if (userInfo == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:MALLUSERINFO];
        if (data) {
            userInfo =[NSKeyedUnarchiver unarchiveObjectWithData:data];
            return userInfo;
        }
    }
    return userInfo;
}

/*  判断用户是否登陆 */
+(BOOL)isLogIn{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:MALLUSERINFO];
    if (data) {
        userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (![HelpManager isBlankString:userInfo.sessionid]) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

/*  退出登陆 */
+(instancetype)logout{
    userInfo = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:MALLUSERINFO];
    [[NSUserDefaults standardUserDefaults] synchronize];//及时存储数据
    return userInfo;
}

/*  保存当前userInfo */
+(void)saveUser:(WTMallUserInfo *)userInfo{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:MALLUSERINFO];
    [[NSUserDefaults standardUserDefaults] synchronize];//及时存储数据
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.truename forKey:@"truename"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.sessionid forKey:@"sessionid"];
    [aCoder encodeObject:self.is_realname forKey:@"is_realname"];
    [aCoder encodeObject:self.memberrank_info forKey:@"memberrank_info"];
    [aCoder encodeObject:self.addr forKey:@"addr"];
    [aCoder encodeObject:self.is_sign forKey:@"is_sign"];
    [aCoder encodeObject:self.memberrank forKey:@"memberrank"];
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.truename = [aDecoder decodeObjectForKey:@"truename"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.sessionid = [aDecoder decodeObjectForKey:@"sessionid"];
        self.is_realname = [aDecoder decodeObjectForKey:@"is_realname"];
        self.memberrank_info = [aDecoder decodeObjectForKey:@"memberrank_info"];
        self.addr = [aDecoder decodeObjectForKey:@"addr"];
        self.is_sign = [aDecoder decodeObjectForKey:@"is_sign"];
        self.memberrank = [aDecoder decodeObjectForKey:@"memberrank"];
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
       
        
    }
    return self;
}


@end
