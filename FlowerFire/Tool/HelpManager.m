//
//  HelpManager.m
//  tongchengqiuou
//
//  Created by 1 on 17/11/17.
//  Copyright © 2017年 com.hengzhong. All rights reserved.
//

#import "HelpManager.h"
 #import <Accelerate/Accelerate.h>
#import "AFNetworking.h"
//#import "XMPPManager.h"

//#import <ShareSDK/ShareSDK.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>

#import "NSString+StringSize.h"
#import "UIImage+jianbianImage.h"
 

@implementation HelpManager
static HelpManager *instance;
//单例模式
+ (instancetype)sharedHelpManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

 
/**
 * 压缩图片暂时方案
 */
- (NSData *)imageWithImageSimple:(UIImage*)scaledImage{
    BOOL isTryAgain=true; UIImage *SelscaledImage=scaledImage;NSData *imageScaledData;
    CGFloat targetWith=SelscaledImage.size.width;
    CGFloat targetHeight=SelscaledImage.size.height;
    while (isTryAgain) {
        targetWith=targetWith* 0.8;
        targetHeight=targetHeight* 0.8;
        CGSize targetSize= CGSizeMake(targetWith,targetHeight);
        UIGraphicsBeginImageContext(targetSize);
        [SelscaledImage drawInRect:CGRectMake(0,0,targetSize.width,targetSize.height)];
        SelscaledImage=UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        imageScaledData=UIImageJPEGRepresentation(SelscaledImage, 0.8);
        //NSLog(@"压缩图片方法  %lu",(unsigned long)[imageScaledData length]);
        if ([imageScaledData length]<300*1024) {
            isTryAgain=false;
        }
    }
    if (imageScaledData==nil) {
        imageScaledData = UIImagePNGRepresentation(scaledImage);
    }
    return imageScaledData;
}

// 16进制颜色
+ (UIColor *) stringTOColor:(NSString *)str

{
    if (!str || [str isEqualToString:@""]) {
        return nil;
    }
    unsigned red,green,blue;
    NSRange range;
    range.length = 2;
    range.location = 1;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[str substringWithRange:range]] scanHexInt:&blue];
    UIColor *color= [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:1];
    return color;
}
// 图标模糊处理
+ (UIImage *)boxblurImage:(UIImage *)image withBlurNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    
    CGImageRef img = image.CGImage;
    
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) *
                         CGImageGetHeight(img));
    
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(
                                             outBuffer.data,
                                             outBuffer.width,
                                             outBuffer.height,
                                             8,
                                             outBuffer.rowBytes,
                                             colorSpace,
                                             kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    
    //释放C对象
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGImageRelease(imageRef);
    
    return returnImage;
}

/**
 *  思路：
 1.检测到网络ok 连接极光推送和进行连接  ,并上传轨迹
 */
-(void)netWorkStateCheck{
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        if (status!=AFNetworkReachabilityStatusNotReachable) {
//            static dispatch_once_t onceToken;
//            UploadGaoDeTrack *u = [UploadGaoDeTrack new];
//            [u startUpLoadTrack];
//            dispatch_once(&onceToken, ^{
//
//                /**
//                 进入App连接信息中心
//                 */
//                NSLog(@"----------   准备进入信息中心1   ----------");
//                if ([[UniversalViewMethod sharedUniverMthod]getSessionId]!=nil) {
//                    if (![[XMPPManager sharedXMPPManager] connection]) {
//                        NSLog(@"信息中心连接失败1");
//                        [[UniversalViewMethod sharedUniverMthod]ShowAlertOnView:@"信息中心连接失败" afterDelay:1.5f];
//                    }
//                }
//            });
//
//            /**
//             进入App连接信息中心
//             */
//            NSLog(@"----------   准备进入信息中心2   ----------");
//            //if ([[UniversalViewMethod sharedUniverMthod]getSessionId]!=nil&&[UniversalViewMethod sharedUniverMthod].isCanConnectInfomation){
//            if ([[XMPPManager sharedXMPPManager].xmppStream isDisconnected]) {
//                if (![[XMPPManager sharedXMPPManager] connection]) {
//                    NSLog(@"信息中心连接失败2");
//                    [[UniversalViewMethod sharedUniverMthod]ShowAlertOnView:@"信息中心连接失败" afterDelay:1.5f];
//                }
//            } else {
//                NSLog(@"xmppStream is connected");
//            }
//            //}
//        }
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"NetWorkCheckState" object:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%ld",(long)status],@"NetWorkState", nil]];
//    }];
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

// 特殊字符处理
+(NSString *)removeUnescapedCharacter:(NSString *)inputStr

{
    
    NSCharacterSet *controlChars = [NSCharacterSet controlCharacterSet];
    
    NSRange range = [inputStr rangeOfCharacterFromSet:controlChars];
    
    if (range.location != NSNotFound)
        
    {
        
        NSMutableString *mutable = [NSMutableString stringWithString:inputStr];
        
        while (range.location != NSNotFound)
            
        {
            [mutable deleteCharactersInRange:range];
            
            range = [mutable rangeOfCharacterFromSet:controlChars];
            
        }
        
        return mutable;
        
    }
    
    return inputStr;
    
}
+ (NSString *) compareCurrentTime:(NSString *)str
{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1)
    {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
}

+(void)Share{
//    
//    //1、创建分享参数
//    NSArray* imageArray = @[[UIImage imageNamed:@"ic_launcher"]];
//    if (imageArray) {
//        
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:@"分享内容"
//                                         images:imageArray
//                                            url:[NSURL URLWithString:@"http://mob.com"]
//                                          title:@"分享标题"
//                                           type:SSDKContentTypeAuto];
//        
//        
//        //大家请注意：4.1.2版本开始因为UI重构了下，所以这个弹出分享菜单的接口有点改变，如果集成的是4.1.2以及以后版本，如下调用：
//        [ShareSDK showShareActionSheet:nil customItems:nil shareParams:shareParams sheetConfiguration:nil onStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//            switch (state) {
//                case SSDKResponseStateSuccess:
//                {
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                        message:nil
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"确定"
//                                                              otherButtonTitles:nil];
//                    [alertView show];
//                    break;
//                }
//                case SSDKResponseStateFail:
//                {
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                    message:[NSString stringWithFormat:@"%@",error]
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"OK"
//                                                          otherButtonTitles:nil, nil];
//                    [alert show];
//                    break;
//                }
//                default:
//                    break;
//            }
//        }];
//        
//        
//    }
}

+(float)getMultiLineWithFont:(NSInteger)font andText:(NSString *)text textWidth:(float)textWidth{
    float height  = [text boundingRectWithSize:CGSizeMake(textWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size.height;
    return height;
}

//爱碰流日期
-(NSString *)time_format:(NSString *) time{
    @try {
        
        // ------实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//这里的格式必须和DateString格式一致
        
        NSDate * nowDate = [NSDate date];
        
        // ------将需要转换的时间转换成 NSDate 对象
        NSDate * needFormatDate = [dateFormatter dateFromString:time];
        
        // ------取当前时间和转换时间两个日期对象的时间间隔
        NSTimeInterval time = [nowDate timeIntervalSinceDate:needFormatDate];
        
        //NSLog(@"time----%f",time);
        // ------再然后，把间隔的秒数折算成天数和小时数：
        
        NSString *dateStr = [[NSString alloc] init];
        
        if (time<=60) {  //1分钟以内的
            
            dateStr = @"刚刚";
            
        }else if(time<=60*60){  //一个小时以内的
            
            int mins = time/60;
            dateStr = [NSString stringWithFormat:@"%d分钟前",mins];
            
        }else if(time<=60*60*24){  //在两天内的
            
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString * need_yMd = [dateFormatter stringFromDate:needFormatDate];
            NSString *now_yMd = [dateFormatter stringFromDate:nowDate];
            
            [dateFormatter setDateFormat:@"HH:mm"];
            if ([need_yMd isEqualToString:now_yMd]) {
                //在同一天
                dateStr = [NSString stringWithFormat:@"今天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }else{
                //昨天
                dateStr = [NSString stringWithFormat:@"昨天 %@",[dateFormatter stringFromDate:needFormatDate]];
            }
        }else {
            
            [dateFormatter setDateFormat:@"yyyy"];
            NSString * yearStr = [dateFormatter stringFromDate:needFormatDate];
            NSString *nowYear = [dateFormatter stringFromDate:nowDate];
            
            if ([yearStr isEqualToString:nowYear]) {
                //在同一年
                [dateFormatter setDateFormat:@"MM-dd HH:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }else{
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                dateStr = [dateFormatter stringFromDate:needFormatDate];
            }
        }
        
        return dateStr;
    }
    @catch (NSException *exception) {
        return @"";
    }
    
    
    //时间
    /*NSString *createdTimeStr = time;
     //把字符串转为NSdate
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
     [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
     NSDate *timeDate = [dateFormatter dateFromString:createdTimeStr];
     //得到与当前时间差
     NSTimeInterval timeInterval = [timeDate timeIntervalSinceNow];
     timeInterval = -timeInterval;
     long temp = 0;
     NSString *result,*week_time;
     //    if (timeInterval < 60) {
     //        result = [NSString stringWithFormat:@"刚刚"];
     //    }else if((temp = timeInterval/60) < 60){
     //        result = [NSString stringWithFormat:@"%ld分钟前",temp];
     //    }else if((temp = timeInterval/3600) > 1 && (temp = timeInterval/3600) <24){
     //        result = [NSString stringWithFormat:@"%ld小时前",temp];
     //    }
     //时分
     if((temp = timeInterval/3600) <24){
     NSString *sfm = [createdTimeStr componentsSeparatedByString:@" "][1];
     result = [NSString stringWithFormat:@"%@:%@", [sfm componentsSeparatedByString:@":"][0],[sfm componentsSeparatedByString:@":"][1] ];
     week_time = result;
     }
     else if ((temp = timeInterval/3600) >= 24 && (temp = timeInterval/3600) < 48){
     result = [NSString stringWithFormat:@"昨天"];
     }
     else if ((temp = timeInterval/3600) >= 48 && (temp = timeInterval/3600) < 72){
     result = [NSString stringWithFormat:@"前天"];
     }else if((temp = timeInterval/3600) >= 72 && (temp = timeInterval/3600) < 240){
     //        result =[ NSString stringWithFormat:@"%@ %@",[self getWeekDay:createdTimeStr],week_time] ;          //星期
     result =[ NSString stringWithFormat:@"%@",[self getWeekDay:createdTimeStr]] ;          //星期
     }else{ //年月日
     result = [createdTimeStr componentsSeparatedByString:@" "][0];
     }
     
     return result;*/
}

- (NSString*)getWeekDay:(NSString*)currentStr

{
    
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc]init];//实例化一个NSDateFormatter对象
    
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,要注意跟下面的dateString匹配，否则日起将无效
    
    NSDate*date =[dateFormat dateFromString:currentStr];
    
    NSArray*weekdays = [NSArray arrayWithObjects: [NSNull null],@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六",nil];
    
    NSCalendar*calendar = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone*timeZone = [[NSTimeZone alloc]initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents*theComponents = [calendar components:calendarUnit fromDate:date];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

//获取系统时间
-(NSString *)getSystemTime{
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateformatter stringFromDate:[NSDate date]];
}

+(CGSize)getLabelWidth:(CGFloat)labelFont labelTxt:(NSString *)labelTxt{
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont systemFontOfSize:labelFont]};
    return [labelTxt sizeWithAttributes:attrs];
}


-(int)compareOneDay:(NSString *)oneDay withAnotherDay:(NSString *)anotherDay
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateA = [dateFormatter dateFromString:oneDay];
    NSDate *dateB = [dateFormatter dateFromString:anotherDay];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        //NSLog(@"DateA  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"DateA is in the past");
        return -1;
    }else{
        //NSLog(@"Both dates are the same");
        return 0;
    }
    
}

+(BOOL) isBlankString:(NSString *)string {
    
    if (string == nil || string == NULL) {
        
        return YES;
        
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        
        return YES;
        
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        
        return YES;
        
    }
    
    return NO;
    
}

+(NSArray *)getRunTimeClassProperty:(Class)getClass{
    unsigned int count;
    Ivar *ivars =  class_copyIvarList(getClass, &count);
    NSMutableArray *arr = [NSMutableArray new];
    for (int i = 0; i < count; i++) {
        Ivar ivar = ivars[i];
        const char * cName =  ivar_getName(ivar);
        NSString *ocName = [NSString stringWithUTF8String:cName];
        [arr addObject:ocName];
    }
    free(ivars);
    return arr;
}

- (UIViewController*)viewController:(UIView *)view{
    for (UIView* next = [view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController
                                          class]]) {
            return (UIViewController*)nextResponder;
        }
    }
    return nil;
}


+(NSString *)getNowTimeTimestamp{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
   // NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1]; //秒
    
    return timeSp;
    
}

//获取字符串日期的毫秒数

+ (long long)getTimeTimestampStr:(NSString*)time FormatStr:(NSString *)formatStr
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatStr];
    
    NSDate *date1=[dateFormatter dateFromString:time];
    
   // return [date1 timeIntervalSince1970]*1000;
    return [date1 timeIntervalSince1970]; //秒
}

- (void)setPartRoundWithView:(UIView *)view corners:(UIRectCorner)corners cornerRadius:(float)cornerRadius {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:view.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(cornerRadius, cornerRadius)].CGPath;
    view.layer.mask = shapeLayer;
}


+ (UIImage *)imageWithText:(NSString *)text
                  textFont:(NSInteger)fontSize
                 textColor:(UIColor *)textColor
                 textFrame:(CGRect)textFrame
               originImage:(UIImage *)image
    imageLocationViewFrame:(CGRect)viewFrame {
    
    if (!text)      {  return image;   }
    if (!fontSize)  {  fontSize = 17;   }
    if (!textColor) {  textColor = [UIColor blackColor];   }
    if (!image)     {  return nil;  }
    if (viewFrame.size.height==0 || viewFrame.size.width==0 || textFrame.size.width==0 || textFrame.size.height==0 ){return nil;}
    
    NSString *mark = text;
    CGFloat height = [mark sizeWithPreferWidth:textFrame.size.width font:[UIFont systemFontOfSize:fontSize]].height; // 此分类方法要导入头文件
    if ((height + textFrame.origin.y) > viewFrame.size.height) { // 文字高度超出父视图的宽度
        height = viewFrame.size.height - textFrame.origin.y;
    }
    
    //    CGFloat w = image.size.width;
    //    CGFloat h = image.size.height;
    UIGraphicsBeginImageContext(viewFrame.size);
    [image drawInRect:CGRectMake(0, 0, viewFrame.size.width, viewFrame.size.height)];
    NSDictionary *attr = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize], NSForegroundColorAttributeName : textColor };
    //位置显示
    [mark drawInRect:CGRectMake(textFrame.origin.x, textFrame.origin.y, textFrame.size.width, height) withAttributes:attr];
    
    UIImage *aimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return aimg;
}

-(void)jianbianMainColor:(UIView *)view size:(CGSize)size{
    NSArray *colors = @[(id)RGBACOLOR(253, 63, 32, 1),(id)RGBACOLOR(255, 84, 19, 1),(id)RGBACOLOR(233, 96, 18, 1)];  // 设置渐变颜色
    UIImage *bgImg = [UIImage gradientColorImageFromColors:colors gradientType:GradientTypeLeftToRight imgSize:size ];
    [view  setBackgroundColor:[UIColor colorWithPatternImage:bgImg]];
}

+(NSString *)getTimeStr:(NSString *)paramsTime dataFormat:(NSString *)dataFormat{
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    = [paramsTime doubleValue];
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:dataFormat];
    
    return  [formatter stringFromDate: date];
}

- (void)sendVerificationCode:(UIButton *)sendBtn{
    __block int timeout= 60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [sendBtn setTitle:LocalizationKey(@"BindingPhoneResendCode") forState:UIControlStateNormal];
                sendBtn.userInteractionEnabled = YES;
                [sendBtn sizeToFit];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [sendBtn setTitle:[NSString stringWithFormat:@"%d%@   ",timeout,LocalizationKey(@"Resend after seconds")] forState:UIControlStateNormal];
                [UIView commitAnimations];
                sendBtn.userInteractionEnabled = NO;
                [sendBtn sizeToFit];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

+ (void)copyStringOnPasteboard:(NSString *)stirng{
    if([HelpManager isBlankString:stirng]){
        printAlert(LocalizationKey(@"578Tip148"), 1.f);
    }else{
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = stirng;
        printAlert(LocalizationKey(@"Successful copy"), 1.f);
    }
}

@end

