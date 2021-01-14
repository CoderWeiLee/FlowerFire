//
//  WTUserInfo.m
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/8.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "WTUserInfo.h"

static WTUserInfo *userInfo = nil;


@implementation WTUserInfo

/*  通过初始化userIfo并保存在本地(单利模式)   */
+(instancetype)getuserInfoWithDic:(NSDictionary *)dic{
    userInfo = [[WTUserInfo alloc] initWithDictionary:dic];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:USERINFO];
    [[NSUserDefaults standardUserDefaults] synchronize];//及时存储数据
    return userInfo;
}

-(id)initWithDictionary:(NSDictionary *)dic{
    return [WTUserInfo yy_modelWithDictionary:dic];
}

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"ID":@"id"};
    
}
 
//- (NSString *)email{
//    
//    return @"不需要邮箱";
//    
//}


/*  获取用户已登陆的信息 */
+(instancetype)shareUserInfo{
    
    if (userInfo == nil) {
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USERINFO];
        if (data) {
            userInfo =[NSKeyedUnarchiver unarchiveObjectWithData:data];
            return userInfo;
        }
    }
    return userInfo;
}

/*  判断用户是否登陆 */
+(BOOL)isLogIn{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:USERINFO];
    if (data) {
        userInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        if (![HelpManager isBlankString:userInfo.token]) {
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
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USERINFO];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    return userInfo;
}

/*  保存当前userInfo */
+(void)saveUser:(WTUserInfo *)userInfo{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:USERINFO];
    [[NSUserDefaults standardUserDefaults] synchronize];//及时存储数据
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.avatar forKey:@"avatar"];
    [aCoder encodeObject:self.createtime forKey:@"createtime"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.expires_in forKey:@"expires_in"];
    [aCoder encodeObject:self.expiretime forKey:@"expiretime"];
    [aCoder encodeObject:self.is_googleauth forKey:@"is_googleauth"];
    [aCoder encodeObject:self.kyc forKey:@"kyc"];
    [aCoder encodeObject:self.mobile forKey:@"mobile"];
    [aCoder encodeObject:self.nickname forKey:@"nickname"];
    [aCoder encodeObject:self.score forKey:@"score"];
    [aCoder encodeObject:self.token forKey:@"token"];
    [aCoder encodeObject:self.trade_num forKey:@"trade_num"];
    [aCoder encodeObject:self.user_id forKey:@"user_id"];
    [aCoder encodeObject:self.username forKey:@"username"];
    [aCoder encodeObject:self.ID forKey:@"ID"];
    [aCoder encodeObject:self.level forKey:@"level"];
    [aCoder encodeObject:self.paypass forKey:@"paypass"];
    [aCoder encodeObject:self.address forKey:@"address"];
    [aCoder encodeObject:self.activation_status forKey:@"activation_status"];
    [aCoder encodeObject:self.SD forKey:@"SD"];
    [aCoder encodeObject:self.SD_booking_show forKey:@"SD_booking_show"];
    
    
}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.avatar = [aDecoder decodeObjectForKey:@"avatar"];
        self.createtime = [aDecoder decodeObjectForKey:@"createtime"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.expires_in = [aDecoder decodeObjectForKey:@"expires_in"];
        self.expiretime = [aDecoder decodeObjectForKey:@"expiretime"];
        self.is_googleauth = [aDecoder decodeObjectForKey:@"is_googleauth"];
        self.kyc = [aDecoder decodeObjectForKey:@"kyc"];
        self.mobile = [aDecoder decodeObjectForKey:@"mobile"];
        self.nickname = [aDecoder decodeObjectForKey:@"nickname"];
        self.score = [aDecoder decodeObjectForKey:@"score"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
        self.trade_num = [aDecoder decodeObjectForKey:@"trade_num"];
        self.user_id = [aDecoder decodeObjectForKey:@"user_id"];
        self.username = [aDecoder decodeObjectForKey:@"username"];
        self.ID = [aDecoder decodeObjectForKey:@"ID"];
        self.level = [aDecoder decodeObjectForKey:@"level"];
        self.paypass = [aDecoder decodeObjectForKey:@"paypass"];
        self.address = [aDecoder decodeObjectForKey:@"address"]; 
        self.activation_status = [aDecoder decodeObjectForKey:@"activation_status"];
        self.SD = [aDecoder decodeObjectForKey:@"SD"];
        self.SD_booking_show = [aDecoder decodeObjectForKey:@"SD_booking_show"];
        
    }
    return self;
}


@end
