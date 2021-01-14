//
//  AFNetworkClass.h
//  tongchengqiuou
//
//  Created by 1 on 17/11/17.
//  Copyright © 2017年 com.hengzhong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIView.h>
#import "NSDictionary+WTNull.h"
 
typedef void (^MR_HttpRequset)(NSInteger stateCode,NSDictionary *responseDict);
//状态枚举
typedef NS_ENUM(NSInteger,Response) {
    Fail = 0,//请求失败
    Success = 1,//请求成功
    whatFunction= 2,//请求成功
};
@protocol AFNetworkDelege  <NSObject>

@optional
//返回数据
-(void)getHttpData:(NSDictionary *)dict
          response:(Response)flag ;

//返回数据 
-(void)getHttpData_array:(NSDictionary *)dict
                response:(Response)flag
                     Tag:(NSString *)tag;
 
//返回数据
-(void)getMallHttpData_array:(NSDictionary *)dict
                response:(Response)flag
                     Tag:(NSString *)tag;

@end

@interface AFNetworkClass : NSObject
 
/**
 post网络请求

 @param httpstr url
 @param jsonDict 参数
 @param tag 区分哪个请求
 */
-(void)jsonPostDict:(NSString *)httpstr
           JsonDict:(NSDictionary *)jsonDict
            Tag:(NSString *)tag;

-(void)jsonPostDict:(NSString *)httpstr
           JsonDict:(NSDictionary *)jsonDict
                Tag:(NSString *)tag
      LoadingInView:(UIView *)view;

/**
 get网络请求

 @param httpstr url
 @param jsonDict 参数
 @param tag 区分哪个请求

 */
-(void)jsonGetDict:(NSString *)httpstr
          JsonDict:(NSDictionary *)jsonDict
            Tag:(NSString *)tag;

-(void)jsonGetDict:(NSString *)httpstr
          JsonDict:(NSDictionary *)jsonDict
               Tag:(NSString *)tag
     LoadingInView:(UIView *)view;

/**
  get网络请求socket
 
 */
-(void)jsonGetSocketDict:(NSString *)httpstr
                JsonDict:(NSDictionary *)jsonDict
                     Tag:(NSString *)tag;


/**
 Post网络请求socket
 
 */
-(void)jsonPostSocketDict:(NSString *)httpstr
                 JsonDict:(NSDictionary *)jsonDict
                      Tag:(NSString *)tag;

/**
 post上传文件
 
 @param data 文件
 @param parameters 参数字典
 @param urlStr url字符串
 
 */
 -(void)uploadDataPost:(NSData *)data
            parameters:(NSDictionary *)parameters
             urlString:(NSString *)urlStr
         LoadingInView:(UIView *)view;

#pragma mark - Mall
/**
 post网络请求

 @param httpstr url
 @param jsonDict 参数
 @param tag 区分哪个请求
 */
-(void)jsonMallPostDict:(NSString *)httpstr
           JsonDict:(NSDictionary *)jsonDict
            Tag:(NSString *)tag;

-(void)jsonMallPostDict:(NSString *)httpstr
           JsonDict:(NSDictionary *)jsonDict
                Tag:(NSString *)tag
      LoadingInView:(UIView *)view;

/**
 get网络请求

 @param httpstr url
 @param jsonDict 参数
 @param tag 区分哪个请求

 */
-(void)jsonMallGetDict:(NSString *)httpstr
          JsonDict:(NSDictionary *)jsonDict
            Tag:(NSString *)tag;

-(void)jsonMallGetDict:(NSString *)httpstr
          JsonDict:(NSDictionary *)jsonDict
               Tag:(NSString *)tag
     LoadingInView:(UIView *)view;

/**
 post上传文件
 
 @param data 文件
 @param parameters 参数字典
 @param urlStr url字符串
 
 */
 -(void)uploadMallDataPost:(NSData *)data
            parameters:(NSDictionary *)parameters
             urlString:(NSString *)urlStr
         LoadingInView:(UIView *)view;

@property(weak,nonatomic)id<AFNetworkDelege>delegate;

@end
