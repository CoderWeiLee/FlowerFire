//
//  BaseViewController.h
//  FireCoin
//
//  Created by 赵馨 on 2019/5/24.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import "BaseNavigationController.h"
#import "InitViewControllerProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewController : UIViewController <AFNetworkDelege,InitViewControllerProtocol>

@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) AFNetworkClass *afnetWork; 

-(void)getHttpData_array:(NSDictionary *)dict response:(Response)flag Tag:(NSString *)tag;
-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type;
- (void)getMallHttpData_array:(NSDictionary *)dict response:(Response)flag Tag:(NSString *)tag;
//普通错误处理
-(void)dataErrorHandle:(NSDictionary *)dict type:(NSString *)type;
//- (void)setStatusBarBackgroundColor:(UIColor *)color;
 

-(void)jumpLogin; 
-(void)jumpKycVC:(NSDictionary *)dict;
-(void)jumpKycVC2:(NSDictionary *)dict;
-(void)jumpAddAccount:(NSDictionary *)dict;
-(void)jumpGoogleCodeVC:(NSDictionary *)dict;
-(void)monitorNetStateChanged:(AFNetworkReachabilityStatus)netState;

-(void)closeVC;

/// 主题改变
-(void)theme_didChanged;
 
@end

NS_ASSUME_NONNULL_END
