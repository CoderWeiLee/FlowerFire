//
//  UniversalViewMethod.m
//  LazyChildSeller
//
//  Created by M gzh on 16/6/25.
//  Copyright © 2016年 hengzhong. All rights reserved.
//
#import <CoreLocation/CLLocationManager.h>
#import<AssetsLibrary/AssetsLibrary.h>
#import<AVFoundation/AVCaptureDevice.h>
#import<AVFoundation/AVMediaFormat.h>
// #import "RecentPeople.h"
#import "UniversalViewMethod.h"
#import <Photos/PHPhotoLibrary.h>
//#import "ShowFriend+CoreDataProperties.h"
//#import "JPUSHService.h"
//#import "MiMaLogin.h"
//#import "LoginOne.h"
//#import "HTMLView.h"
//#import <ShareSDK/ShareSDK.h>
// #import "XMPPManager.h"
//#import "LoginViewController.h"

extern BOOL isInputAfterGestureLock;
@implementation UniversalViewMethod
 
static UniversalViewMethod *_gizManager = nil;

+ (instancetype)sharedInstance{
    if (_gizManager == nil) {
        _gizManager = [[self alloc] init];
    }
    return _gizManager;
}
 
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        if (_gizManager == nil) {
            _gizManager = [super allocWithZone:zone];
        }
    });
    
    return _gizManager;
}
  
-(id)copyWithZone:(NSZone *)zone{
    return [[self class] sharedInstance];
}
-(id)mutableCopyWithZone:(NSZone *)zone{
    return [[self class] sharedInstance];
}

#pragma ----------------------在界面视图中的一些通用方法----------------------

+(BOOL)isLogIn{
    if([HelpManager isBlankString:[[NSUserDefaults standardUserDefaults]objectForKey:@"token"]]){
        return NO;
    }
    return YES;
}

+ (void)exitLogin:(UIViewController *)currentVC{
    NSUserDefaults *defs = [NSUserDefaults standardUserDefaults]; 
    [defs removeObjectForKey:@"token"];
    [defs removeObjectForKey:@"photo"];
    [defs removeObjectForKey:@"userid"];
    [defs removeObjectForKey:@"username"];
    [defs removeObjectForKey:@"nickname"];
    [defs removeObjectForKey:@"phone"];
    [defs removeObjectForKey:@"kycLevel"];
    [defs synchronize];
    
//    [JPUSHService deleteAlias:^(NSInteger iResCode, NSString *iAlias, NSInteger seq) {
//        
//    } seq:6];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EXIT_LOGIN_NOTIFICATION object:nil userInfo:nil];
    
   // [[WTPageRouterManager sharedInstance] jumpLoginViewController:currentVC isModalMode:YES]; 
}

 
-(NSString *)getUserId{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
}
 
-(NSString *)getUserPhoto{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"photo"];
}
-(NSString *)getUserNick{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"nickname"];
}
 
 
-(NSString*)getUserToken{
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"token"];
}

 
#pragma mark --判断手机号合法性

- (BOOL)checkPhone:(NSString *)phoneNumber

{
    
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0-9])|(17[0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:phoneNumber];
    
    if (!isMatch)
        
    {
        
        return NO;
        
    }
    
    return YES;
    
}

//判断是否全是空格

-(BOOL) isEmpty:(NSString *) str {
    
    if (!str) {
        
        return true;
        
    } else {
        
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            
            return true;
            
        } else {
            
            return false;
            
        }
        
    }
    
}



#pragma mark 判断邮箱

 - (BOOL)checkEmail:(NSString *)email{
    
    //^(\\w)+(\\.\\w+)*@(\\w)+((\\.\\w{2,3}){1,3})$
    
    NSString *regex = @"^[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+(\\.[a-zA-Z0-9_-]+)+$";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [emailTest evaluateWithObject:email];
    
}

//直接调用这个方法就行

-(int)checkIsHaveNumAndLetter:(NSString*)password{

    //数字条件

    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]"options:NSRegularExpressionCaseInsensitive error:nil];

    

    //符合数字条件的有几个字节

    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:password

                                                                       options:NSMatchingReportProgress

                                                                         range:NSMakeRange(0, password.length)];

    

    //英文字条件

    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]"options:NSRegularExpressionCaseInsensitive error:nil];

    

    //符合英文字条件的有几个字节

    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)] ;

    if (tNumMatchCount == password.length) {

        //全部符合数字，表示沒有英文

        return 1;

    } else if (tLetterMatchCount == password.length) {

        //全部符合英文，表示沒有数字

        return 2;

    } else if (tNumMatchCount + tLetterMatchCount == password.length) {

        //符合英文和符合数字条件的相加等于密码长度

        return 3;

    } else {

        return 4;

        //可能包含标点符号的情況，或是包含非英文的文字，这里再依照需求详细判断想呈现的错误

    }

    

}


//-(NSString*)getbackgroundPhoto{
//    
//    return [[NSUserDefaults standardUserDefaults]objectForKey:@"backgroundphoto"];
//    
//}
/**
 *  检测当前线程状态
 */
-(void)testThreadState{
    NSLog(@"当前线程状态：%@ \n 是否主线程：%d \n 是否是多线程：%d",[NSThread currentThread],[NSThread isMainThread],[NSThread isMultiThreaded]);
}
 

//网络状态提示
-(void)netWorkHello:(UIViewController *)ViewController{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"网络连接超时，请检查您的网络后重试！" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:okAction];
        [ViewController presentViewController:alertController animated:YES completion:nil];
    }else{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
//                                                        message:@"请您连接网络后访问！"
//                                                       delegate:self
//                                              cancelButtonTitle:@"取消"
//                                              otherButtonTitles:@"确定",nil];
//        [alert show];
    }
}

/**
 *  单提示框
 *
 *  @param message        信息
 *  @param ViewController 谁显示
 *  @param messageTitle   标题 为空时默认 温馨提示
 */
-(void)alertShowMessage:(NSString *)message WhoShow:(UIViewController *)ViewController CanNilTitle:(NSString *)messageTitle{
    if (messageTitle==nil||[messageTitle isEqualToString:@""]) {
        messageTitle= LocalizationKey(@"Tips");
    }
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:messageTitle message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:LocalizationKey(@"determine") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:okAction];
    [ViewController presentViewController:alertController animated:YES completion:nil];
} 

/**
 *  显示在主屏幕上
 *
 *  @param showTxt 显示的内容
 *  @param delay   持续时间
 */
-(void)ShowAlertOnView:(NSString *)showTxt afterDelay:(NSTimeInterval)delay InView:(UIView *)view{
    //UIWindow *surface=[[UIApplication sharedApplication].windows lastObject];
//    UIWindow *surface = nil;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11) {
//        surface = [[UIApplication sharedApplication].windows firstObject];
//    } else {
//        surface = [[UIApplication sharedApplication].windows lastObject];
//    }
//    UIWindow *keyWindow=[[[UIApplication sharedApplication] delegate] window];
//    NSArray *windows = [UIApplication sharedApplication].windows;
//    for (id windowView in windows) {
//        NSString *viewName = NSStringFromClass([windowView class]);
//        if ([@"UIRemoteKeyboardWindow" isEqualToString:viewName]) {
//            keyWindow = windowView;
//            break;
//        }
//    }
     
//  UIWindow *surface=[UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view ?:[[UIApplication sharedApplication] keyWindow] animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = NSLocalizedString(showTxt, @"HUD message title");
//    hud.of = CGPointMake(0, ScreenHeight/100*25);
    hud.margin =  15.f;
    hud.offset = CGPointMake(0, 0);// 150.f;
    hud.label.textColor=[UIColor whiteColor];
//    hud.label.lineBreakMode=NSLineBreakByWordWrapping;
    hud.label.font=[UIFont systemFontOfSize:16];
//    hud.label.numberOfLines=0;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = rgba(34, 50, 71, 1);
    [hud hideAnimated:YES afterDelay:delay];
}
 

#pragma mark --------------------通用的判断权限方法---------------------
 
/**
 *  判断通知权限
 */
-(void)checkUserNoticePower{
    
//    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types== UIUserNotificationTypeNone){
//        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"通知权限未开启" message:@"请在系统设置中开启通知授权,否则您将无法在后台收到消息提醒" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"暂不" style:UIAlertActionStyleCancel handler:nil];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"去设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            NSURL *url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
//            if(@available(iOS 10.0, *)){
//                if([[UIApplication sharedApplication] canOpenURL:url]){
//                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
//                }
//            }else{
//                if([[UIApplication sharedApplication] canOpenURL:url]){
//                    [[UIApplication sharedApplication] openURL:url];
//                }
//            }
//        }];
//        [alertController addAction:cancelAction];
//        [alertController addAction:okAction];
//        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
//    }
}
  
-(CATransition *)createTransitionAnimationdds:(NSString *)type
{
    /*
     动画类型
     fade 淡出效果
     moveIn 新视图移动到旧视图
     push 新视图推出旧视图
     reveal 移开旧视图
     cube 立方体翻转效果
     oglFlip 翻转效果
     suckEffect 收缩效果
     rippleEffect 水滴波纹效果
     pageCurl 向下翻页
     pageUnCurl 向上翻页
     */
    //切换之前添加动画效果
    //后面知识: Core Animation 核心动画
    //不要写成: CATransaction
    //创建CATransition动画对象
    CATransition *animation = [CATransition animation];
    //设置动画的类型:
    animation.type = type;//@"oglFlip";
    //设置动画的方向
    animation.subtype = kCATransitionFromBottom;
    //设置动画的持续时间
    animation.duration = 1.5;
    //设置动画速率(可变的)
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //动画添加到切换的过程中
    return animation;
}

- (void)priceAddqCouponStr:(UILabel *)priceLabel priceStr:(NSString *)priceNumStr CouponStr:(NSString *)couponStr{
    if([HelpManager isBlankString:priceNumStr]){
            priceNumStr = @"0";
    }
    if([HelpManager isBlankString:couponStr]){
            couponStr = @"0";
    }
    if([couponStr doubleValue] == 0){
        priceLabel.text = NSStringFormat(@"¥%@",priceNumStr);
    }else{
        NSString *priceStr = NSStringFormat(@"¥%@ + %@券",priceNumStr,couponStr);
        NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString:priceStr];
        [ma addAttributes:@{NSForegroundColorAttributeName : MainYellowColor} range:[priceStr rangeOfString:NSStringFormat(@" %@券",couponStr)]];
        [ma addAttributes:@{NSForegroundColorAttributeName : KBlackColor} range:[priceStr rangeOfString:@"+"]];
        priceLabel.attributedText = ma;
    }
}
 
- (void)activationStatusCheck:(UIViewController *)currentVC{
    if(![[WTUserInfo shareUserInfo].activation_status isEqualToString:@"1"]){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:LocalizationKey(@"utilTip2") message:LocalizationKey(@"578Tip176") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:LocalizationKey(@"determine") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:okAction];
        [currentVC presentViewController:alertController animated:YES completion:nil]; 
    }
}

@end
