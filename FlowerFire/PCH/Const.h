//
//  Const.h
//  BaseDevelopmentFramework
//
//  Created by 王涛 on 2019/11/4.
//  Copyright © 2019 Celery. All rights reserved.
//

#ifndef Const_h
#define Const_h

#pragma mark - 通知名 
//登录成功
static NSString *const LOGIN_SUCCESS_NOTIFICATION = @"login_success";
static NSString *const SWITCH_ACCOUNT_SUCCESS_NOTIFICATION = @"switch_account_login_success";
//退出登录
static NSString *const EXIT_LOGIN_NOTIFICATION = @"exit_login";
 
//关闭抽屉通知
static NSString *const PopSkidVCNotification = @"PopSkidVCNotification";

//通知名  当前选择的交易对
static NSString *const CURRENTSELECTED_SYMBOL = @"CURRENTSELECTED_SYMBOL";

//通知名  去自选交易对
UIKIT_EXTERN NSNotificationName const ChooseCustomSymbol;

//排序首页按钮
UIKIT_EXTERN NSNotificationName const SortHomeButtonNotice;

#pragma mark - mall
UIKIT_EXTERN NSNotificationName const SELECTED_ADDRESS_NOTICE;

//支付宝授权成功
UIKIT_EXTERN NSNotificationName const AuthAlipaySuccessNotice;

//更新用户缓存
UIKIT_EXTERN NSNotificationName const UpdateUserInfoNotice;

//关闭登录页面
UIKIT_EXTERN NSNotificationName const CloseLoginVCNotice;

//选中tabbar的Index
UIKIT_EXTERN NSNotificationName const SelectedTabBarIndexNotice;


#pragma mark - 字符串
//登陆页面控制器
static NSString *const LOGIN_VIEW_CONTROLLER = @"LoginViewController";
static NSString *const Mall_LOGIN_VIEW_CONTROLLER = @"MallLoginViewController";

//币币账户
static NSString *const Coin_Account = @"cc";

//法币账户
static NSString *const LegalCurrency_Account = @"currency";

//合约账户
static NSString *const Contract_Account = @"contract";

//默认选择的k线类型的userdefult的key值
static NSString *const defualtKlineType = @"defualtKlineType";

//发送手机号验证码的请求
static NSString *const HTTP_SEND_PHONE = @"/api/sms/send";

//发送邮箱验证码的请求
static NSString *const HTTP_SEND_EMS = @"/api/ems/send";

#pragma mark - 第三方
//腾讯bugly的appId
static NSString *const BUGLY_APPID = @"90164f5f1e";

//腾讯bugly的appkey
static NSString *const BUGLY_APPKEY = @"1c90e87d-184c-441c-99a8-852f61f7aa9b";

static NSString *const RongCloudIM_AppKey = @"mgb7ka1nme5ug";


static NSString *const RongCloudIM_Token = @"+Gpq9kMVSCp0fxgaqDl8eboQifNT4g7wK+jx+BQKqjY=@hrw8.cn.rongnav.com;hrw8.cn.rongcfg.com";

//导航栏字体大小
static CGFloat const NAVIGATATIONBAR_TITLE_FONT = 17;

static int const POLLIING_TIME = 2;//轮询时间

static int const SEGMENTED_WIDTH = 100;//WTSegmentedControl 宽度
static int const SEGMENTED_HEIGHT = 35;//WTSegmentedControl 高度
static int const LoginModuleLeftSpace = 40;//登录模块左右边距

static NSString *const AES_KEY = @"A-16-Byte-String";

#pragma mark - Block
/**
 返回页面上个页面进行刷新
 */
typedef void(^backRefreshBlock)(void);

#endif /* Const_h */
