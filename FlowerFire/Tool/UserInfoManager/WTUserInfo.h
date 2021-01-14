//
//  WTUserInfo.h
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/8.
//  Copyright © 2019 Celery. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WTUserInfo : NSObject<NSCoding>
 
@property(nonatomic,strong)NSString *avatar;//头像地址
@property(nonatomic,strong)NSString *createtime;
@property(nonatomic,strong)NSString *email;
@property(nonatomic,strong)NSString *expires_in;
@property(nonatomic,strong)NSString *expiretime;
@property(nonatomic,strong)NSString *ID;
@property(nonatomic,strong)NSString *is_googleauth;
@property(nonatomic,strong)NSString *kyc;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *nickname;
@property(nonatomic,strong)NSString *score;
@property(nonatomic,strong)NSString *token;
@property(nonatomic,strong)NSString *trade_num;
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *username;
/// 10 是开启节点,1是未开启
@property(nonatomic,strong)NSString *level;
/// 支付密码
@property(nonatomic,strong)NSString *paypass;

/// 钱包地址
@property(nonatomic,strong)NSString *address;

/// 是否激活挖矿
@property(nonatomic,strong)NSString *activation_status;

/// SD余额
@property(nonatomic,strong)NSString *SD;

/// 用于控制SD认购模块是否显示  1是显示，0是隐藏
@property(nonatomic,strong)NSString *SD_booking_show;
   
/*  通过初始化userIfo并保存在本地(单利模式)   */
+(instancetype)getuserInfoWithDic:(NSDictionary *)dic;

/*  获取用户已登陆的信息 */
+(instancetype)shareUserInfo;

/*  判断用户时否登陆 */
+(BOOL)isLogIn;

/*  退出登陆 */
+(instancetype)logout;

/*  保存当前userInfo */
+(void)saveUser:(WTUserInfo *)userInfo;


@end

NS_ASSUME_NONNULL_END
