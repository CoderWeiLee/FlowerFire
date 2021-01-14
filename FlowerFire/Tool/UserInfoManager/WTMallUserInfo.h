//
//  WTUserInfo.h
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/8.
//  Copyright © 2019 Celery. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTMallUserInfo : NSObject<NSCoding>
 
@property(nonatomic,strong)NSString *truename;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *avatar;//头像地址
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *sessionid;
/// 是否实名认证 0为上传  1 为通过  2为未通过 3为未审核
@property(nonatomic,strong)NSString *is_realname;
/// 会员等级
@property(nonatomic,strong)NSString *memberrank_info;
@property(nonatomic,strong)NSString *memberrank;
@property(nonatomic,strong)NSString *user_id;

/// 实名认证的地址
@property(nonatomic,strong)NSString *addr;
/// 0未签到，1已签到
@property(nonatomic,strong)NSString *is_sign;
 
/*  通过初始化userIfo并保存在本地(单利模式)   */
+(instancetype)getuserInfoWithDic:(NSDictionary *)dic;

/*  获取用户已登陆的信息 */
+(instancetype)shareUserInfo;

/*  判断用户时否登陆 */
+(BOOL)isLogIn;

/*  退出登陆 */
+(instancetype)logout;

/*  保存当前userInfo */
+(void)saveUser:(WTMallUserInfo *)userInfo;


@end

NS_ASSUME_NONNULL_END
