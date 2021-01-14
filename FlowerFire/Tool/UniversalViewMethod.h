//
//  UniversalViewMethod.h
//  LazyChildSeller
//
//  Created by M gzh on 16/6/25.
//  Copyright © 2016年 hengzhong. All rights reserved.
//专门的视图通用类方法

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UniversalViewMethod : NSObject{
     
}

//单例模式
+ (instancetype)sharedInstance;

//定位坐标，每次刷新后存在这里，供整个工程使用
@property(strong,nonatomic) NSString *lat;
@property(strong,nonatomic) NSString *lon;


 
/**
 是否登录

 @return YES 登录了
 */
+(BOOL)isLogIn;
/**
 退出登录
 */
+(void)exitLogin:(UIViewController *)currentVC;
-(NSString *)getUserId;
-(NSString *)getUserPhoto;
-(NSString *)getUserNick;
 
-(NSString*)getUserToken;
  
/**
 *  检测当前线程状态
 */
-(void)testThreadState;
 
//网络状态提示
-(void)netWorkHello:(UIViewController *)ViewController;
 
/**
 *  显示在主屏幕上
 *
 *  @param showTxt 显示的内容
 *  @param delay   持续时间
 */
-(void)ShowAlertOnView:(NSString *)showTxt afterDelay:(NSTimeInterval)delay InView:(UIView *)view;
 
/**
 *  单提示框
 *
 *  @param message        信息
 *  @param ViewController 谁显示
 *  @param messageTitle   标题 为空时默认 温馨提示
 */
-(void)alertShowMessage:(NSString *)message WhoShow:(UIViewController *)ViewController CanNilTitle:(NSString *)messageTitle;

//判断输入的是否全是空格
- (BOOL) isEmpty:(NSString *) str ;
 
/**
 *  判断通知权限
 */
-(void)checkUserNoticePower;
  

- (BOOL)checkPhone:(NSString *)phoneNumber;
- (BOOL)checkEmail:(NSString *)email;
/// //符合英文和符合数字条件的相加等于密码长度
/// @param password 3
-(int)checkIsHaveNumAndLetter:(NSString*)password;

-(CATransition *)createTransitionAnimationdds:(NSString *)type;


/// 价格label添加优惠券
/// @param priceLabel 价格label
/// @param priceNumStr 价格字符串
/// @param couponStr 优惠券字符串
-(void)priceAddqCouponStr:(UILabel *)priceLabel
                 priceStr:(NSString *)priceNumStr
                CouponStr:(NSString *)couponStr;

/// 检测激活状态
///未激活会员可打开的页面：
///首页：其他应用、公告，行情，交易，资产，我的：账户管理、意见反馈、关于我们。
///无法进入其他页面，用户想要进入时弹窗提示“请先激活当前账户”。
-(void)activationStatusCheck:(UIViewController *)currentVC;

@end
