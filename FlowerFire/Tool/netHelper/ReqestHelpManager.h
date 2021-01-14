//
//  ReqestHelpManager.h
//  OneToOneTeach
//
//  Created by mac on 2019/3/5.
//  Copyright © 2019年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^Http_request)(NSInteger state,NSDictionary *responseDict);
typedef NS_ENUM(NSInteger,ReqestType){
    Fails = 0,//失败
    Successeds,//成功
};

@interface ReqestHelpManager : NSObject
+(ReqestHelpManager *)share;
- (void)requestPost:(NSString *)url andHeaderParam:(NSDictionary *)param finish:(void(^)(NSDictionary *dicForData,ReqestType flag))finish;

- (void)requsetUplodImage:(NSData *)imageData andImageName:(NSString *)imageName andUserID:(NSString *)userID finish:(void(^)(id imageUrl,ReqestType flag))finish;

/**
 get网络回调

 @param url url
 @param params 参数
 @param finish 回调
 */
-(void)requestGet:(NSString *)url andHeaderParams:(NSDictionary *)params finish:(void(^)(NSDictionary *dicForData,ReqestType flag))finish;

#pragma mark - mall
- (void)requestMallPost:(NSString *)url andHeaderParam:(NSDictionary *)param finish:(void(^)(NSDictionary *dicForData,ReqestType flag))finish;

- (void)requsetMallUplodImage:(NSData *)imageData andImageName:(NSString *)imageName andUserID:(NSString *)userID finish:(void(^)(id imageUrl,ReqestType flag))finish;

/**
 get网络回调

 @param url url
 @param params 参数
 @param finish 回调
 */
-(void)requestMallGet:(NSString *)url andHeaderParams:(NSDictionary *)params finish:(void(^)(NSDictionary *dicForData,ReqestType flag))finish;


@end
