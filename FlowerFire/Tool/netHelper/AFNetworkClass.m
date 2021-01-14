//
//  AFNetworkClass.m
//  tongchengqiuou
//
//  Created by 1 on 17/11/17.
//  Copyright © 2017年 com.hengzhong. All rights reserved.
//


#import "AFNetworkClass.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager+AFNShareManager.h"
#import "NSDictionary+WTNull.h" 

@implementation AFNetworkClass

-(void)jsonPostDict:(NSString *)httpstr JsonDict:(NSDictionary *)jsonDict Tag:(NSString *)tag{
    [self jsonPostDict:httpstr JsonDict:jsonDict Tag:tag LoadingInView:nil];
}

- (void)jsonPostDict:(NSString *)httpstr JsonDict:(NSDictionary *)jsonDict Tag:(NSString *)tag LoadingInView:(UIView *)view{
    
    NSString *requestUrl=[NSString stringWithFormat:@"%@%@",BASE_URL,httpstr];
    NSLog(@"jsonPost %@ /n 内容：%@",requestUrl,jsonDict);
    [MBManager showLoadingInView:view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager shareManager];
    [self languageSwitch:manager];

    
    [manager POST:requestUrl parameters:jsonDict headers:[self httpHeaderDic]  progress:^(NSProgress * _Nonnull uploadProgress) {
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       [MBManager hideAlert];
       NSError * error;

       NSString * str  =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
       
       NSString * transStr = [self removeUnescapedCharacter:str];
       NSData * data = [transStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resdic = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error] wt_dictionaryReplaceNullByString];
       

       [self.delegate getHttpData_array:resdic response:1 Tag:tag];
       
       NSLog(@"____%@___",tag);
       
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       [MBManager hideAlert];
       NSLog(@"接口错误log:%@",error.localizedDescription);
       printAlertInView(LocalizationKey(@"NetWorkErrorTip"), 2.f,view);
       [self.delegate getHttpData_array:nil response:0 Tag:tag];
    }];
}

-(void)jsonGetDict:(NSString *)httpstr JsonDict:(NSDictionary *)jsonDict Tag:(NSString *)tag{
    [self jsonGetDict:httpstr JsonDict:jsonDict Tag:tag LoadingInView:nil];
}

- (void)jsonGetDict:(NSString *)httpstr JsonDict:(NSDictionary *)jsonDict Tag:(NSString *)tag LoadingInView:(UIView *)view{
    NSString *requestUrl=[NSString stringWithFormat:@"%@%@",BASE_URL,httpstr];
    NSLog(@"jsonPost %@ /n 内容：%@",requestUrl,jsonDict);
    [MBManager showLoadingInView:view];
    AFHTTPSessionManager *manager= [AFHTTPSessionManager shareManager];

    [self languageSwitch:manager];

    [manager GET:requestUrl parameters:jsonDict headers:[self httpHeaderDic]  progress:^(NSProgress * _Nonnull uploadProgress) {
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       [MBManager hideAlert];
       NSError * error;
       
       NSString * str  =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
       
       NSString * transStr = [self removeUnescapedCharacter:str];
       NSData * data = [transStr dataUsingEncoding:NSUTF8StringEncoding];
       NSDictionary *resdic = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error] wt_dictionaryReplaceNullByString];
      
       [self.delegate getHttpData_array:resdic response:1 Tag:tag];
      
       NSLog(@"____%@___",tag);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       [MBManager hideAlert];
       NSLog(@"接口错误log:%@",error.localizedDescription);
       printAlertInView(LocalizationKey(@"NetWorkErrorTip"), 2.f,view);
       [self.delegate getHttpData_array:nil response:0 Tag:tag];
    }];
}

- (void)uploadDataPost:(NSData *)data parameters:(NSDictionary *)parameters urlString:(NSString *)urlStr LoadingInView:(UIView *)view{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager shareManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self languageSwitch:manager];
    urlStr = @"/api/common/upload";
    [MBManager showLoadingInView:view];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL,urlStr];

    // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
    // 要解决此问题，
    // 可以在上传时使用当前的系统事件作为文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];

    [manager POST:urlString parameters:parameters headers:[self httpHeaderDic]  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       [formData appendPartWithFileData:data name:@"file" fileName:fileName mimeType:@"image/png"];
    //   [formData appendPartWithFormData:datas name:@"user_id"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    // 在主线程更新 UI 进度条
       MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
       dispatch_async(dispatch_get_main_queue(), ^{
            hud.mode = MBProgressHUDModeDeterminate;
            hud.label.text = NSLocalizedString(@"Loading...", @"HUD loading title");
       });
        
       NSLog(@"上传进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       [MBManager hideAlert];
       NSLog(@"请求responseObject：%@",responseObject);
       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
       [self.delegate getHttpData:dic response:1];
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       [MBManager hideAlert];
       NSLog(@"请求失败：%@",[error localizedDescription]);
       [self.delegate getHttpData:nil response:0];
       
    }];
}

-(void)jsonGetSocketDict:(NSString *)httpstr JsonDict:(NSDictionary *)jsonDict Tag:(NSString *)tag{
    NSString *requestUrl=[NSString stringWithFormat:@"%@%@",BASE_URL,httpstr];
    NSLog(@"jsonPost %@ /n 内容：%@",requestUrl,jsonDict);
 
    AFHTTPSessionManager *manager= [AFHTTPSessionManager shareManager];
 
    [self languageSwitch:manager];
    
    [manager GET:requestUrl parameters:jsonDict  headers:[self httpHeaderDic]  progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError * error;
        
        NSString * str  =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSString * transStr = [self removeUnescapedCharacter:str];
        NSData * data = [transStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resdic = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error] wt_dictionaryReplaceNullByString];
        
        
        [self.delegate getHttpData_array:resdic response:1 Tag:tag];
        
        NSLog(@"____%@___",tag);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
      //  [[UniversalViewMethod sharedUniverMthod] ShowAlertOnView:@"请求失败，请重新请求" afterDelay:1.0];
      //  [self.delegate getHttpData_array:nil response:0 and:type];
    }];
}

-(void)jsonPostSocketDict:(NSString *)httpstr JsonDict:(NSDictionary *)jsonDict Tag:(NSString *)tag{
    NSString *requestUrl=[NSString stringWithFormat:@"%@%@",BASE_URL,httpstr];
    NSLog(@"jsonPost %@ /n 内容：%@",requestUrl,jsonDict);
 
    AFHTTPSessionManager *manager= [AFHTTPSessionManager shareManager];
    
    [self languageSwitch:manager];
    
    [manager POST:requestUrl parameters:jsonDict headers:[self httpHeaderDic]  progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError * error;
        
        NSString * str  =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSString * transStr = [self removeUnescapedCharacter:str];
        NSData * data = [transStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *resdic = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error] wt_dictionaryReplaceNullByString];
        
        
        [self.delegate getHttpData_array:resdic response:1 Tag:tag];
        
        NSLog(@"____%@___",tag);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //  [[UniversalViewMethod sharedUniverMthod] ShowAlertOnView:@"请求失败，请重新请求" afterDelay:1.0];
        //  [self.delegate getHttpData_array:nil response:0 and:type];
    }];
}

#pragma  mark - mall
-(void)jsonMallPostDict:(NSString *)httpstr JsonDict:(NSDictionary *)jsonDict Tag:(NSString *)tag{
    [self jsonMallPostDict:httpstr JsonDict:jsonDict Tag:tag LoadingInView:nil];
}

- (void)jsonMallPostDict:(NSString *)httpstr JsonDict:(NSDictionary *)jsonDict Tag:(NSString *)tag LoadingInView:(UIView *)view{
    NSString *requestUrl=[NSString stringWithFormat:@"%@%@",BASE_MALL_URLL,httpstr];
    NSLog(@"jsonPost %@ /n 参数:%@",requestUrl,jsonDict);
    [MBManager showLoadingInView:view];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager shareManager];

    [self languageSwitch:manager];

    [manager POST:requestUrl parameters:jsonDict headers:[self httpHeaderDic] progress:^(NSProgress * _Nonnull uploadProgress) {
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       [MBManager hideAlert];
       NSError * error;

       NSString * str  =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
       
       NSString * transStr = [self removeUnescapedCharacter:str];
       NSData * data = [transStr dataUsingEncoding:NSUTF8StringEncoding];
       NSDictionary *resdic = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error] wt_dictionaryReplaceNullByString];
       

       [self.delegate getMallHttpData_array:resdic response:1 Tag:tag];
       
       NSLog(@"____%@___",tag);
       
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       [MBManager hideAlert];
       NSLog(@"接口错误log:%@",error.localizedDescription);
        if([error.localizedDescription containsString:@"请求超时"]){
            printAlertInView(@"请求超时,请重试", 2.f,view);
        }else{
            printAlertInView(LocalizationKey(@"NetWorkErrorTip"), 2.f,view);
        }
       
       [self.delegate getMallHttpData_array:nil response:0 Tag:tag];
    }];
}

-(void)jsonMallGetDict:(NSString *)httpstr JsonDict:(NSDictionary *)jsonDict Tag:(NSString *)tag{
    [self jsonMallGetDict:httpstr JsonDict:jsonDict Tag:tag LoadingInView:nil];
}

- (void)jsonMallGetDict:(NSString *)httpstr JsonDict:(NSDictionary *)jsonDict Tag:(NSString *)tag LoadingInView:(UIView *)view{
    NSString *requestUrl=[NSString stringWithFormat:@"%@%@",@"",httpstr];
    NSLog(@"jsonPost %@ /n 参数:%@",requestUrl,jsonDict);
    [MBManager showLoadingInView:view];
    AFHTTPSessionManager *manager= [AFHTTPSessionManager shareManager];

    [self languageSwitch:manager];

    [manager GET:requestUrl parameters:jsonDict headers:[self httpHeaderDic] progress:^(NSProgress * _Nonnull uploadProgress) {
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       [MBManager hideAlert];
       NSError * error;
       
       NSString * str  =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
       
       NSString * transStr = [self removeUnescapedCharacter:str];
       NSData * data = [transStr dataUsingEncoding:NSUTF8StringEncoding];
       NSDictionary *resdic = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error] wt_dictionaryReplaceNullByString];
      
       [self.delegate getMallHttpData_array:resdic response:1 Tag:tag];
      
       NSLog(@"____%@___",tag);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       [MBManager hideAlert];
       NSLog(@"接口错误log:%@",error.localizedDescription);
       printAlertInView(LocalizationKey(@"NetWorkErrorTip"), 2.f,view);
       [self.delegate getMallHttpData_array:nil response:0 Tag:tag];
    }];
}

- (void)uploadMallDataPost:(NSData *)data parameters:(NSDictionary *)parameters urlString:(NSString *)urlStr LoadingInView:(UIView *)view{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager shareManager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self languageSwitch:manager];

   // [MBManager showLoadingInView:view];
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_MALL_URLL,urlStr];

    // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
    // 要解决此问题，
    // 可以在上传时使用当前的系统事件作为文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];

    MBProgressHUD *HUD = [[MBProgressHUD alloc] init];
    HUD.mode = MBProgressHUDModeDeterminate;//圆饼作为进度条
    [HUD showAnimated:YES];
    [view addSubview:HUD];
    
    [manager POST:urlString parameters:parameters headers:[self httpHeaderDic] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       [formData appendPartWithFileData:data name:@"file_upload" fileName:fileName mimeType:@"image/png"];
    //   [formData appendPartWithFormData:datas name:@"user_id"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
    // 在主线程更新 UI 进度条
       dispatch_async(dispatch_get_main_queue(), ^{
           HUD.label.text = @"正在上传...";//NSLocalizedString(@"Loading...", @"HUD loading title");
           HUD.progress = 1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
       });
        
       NSLog(@"上传进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       [HUD hideAnimated:YES];
       NSLog(@"请求responseObject：%@",responseObject);
       NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
       [self.delegate getHttpData:dic response:1];
       
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [HUD hideAnimated:YES];
       NSLog(@"请求失败：%@",[error localizedDescription]);
       [self.delegate getHttpData:nil response:0];
       
    }];
}


// 特殊字符处理
-(NSString *)removeUnescapedCharacter:(NSString *)inputStr
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

/**
 网络请求语言切换
 */
- (void)languageSwitch:(AFHTTPSessionManager *)manager {
    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
        [manager.requestSerializer setValue:@"zh-Hans-US;q=1, en-US;q=0.9, en;q=0.8"
                         forHTTPHeaderField:@"Accept-Language"];
    }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
    {
        [manager.requestSerializer setValue:@"zh-CN,zh;q=0.9,ja;q=0.8,zh-TW;q=0.7"
                         forHTTPHeaderField:@"Accept-Language"];
    }else{
        [manager.requestSerializer setValue:@"zh-TW;"
                        forHTTPHeaderField:@"Accept-Language"];
    }
}

-(NSMutableDictionary *)httpHeaderDic{
    NSMutableDictionary *httpHeaderDic = [NSMutableDictionary dictionaryWithCapacity:1];
    httpHeaderDic[@"token"] = [WTUserInfo shareUserInfo].token;
    return httpHeaderDic;
}

@end

