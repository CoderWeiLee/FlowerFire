//
//  ReqestHelpManager.m
//  OneToOneTeach
//
//  Created by mac on 2019/3/5.
//  Copyright © 2019年 mac. All rights reserved.
// http://47.110.157.253:8090/uiface
#import "AFHTTPSessionManager.h"
#import "ReqestHelpManager.h"
#import "AFHTTPSessionManager+AFNShareManager.h"
#import "NSDictionary+WTNull.h"

@implementation ReqestHelpManager
+ (ReqestHelpManager *)share {
    static ReqestHelpManager *maneger = nil;
    if (!maneger) {
        maneger = [[ReqestHelpManager alloc] init];
    }
    return maneger;
}
- (void)requestPost:(NSString *)url andHeaderParam:(NSDictionary *)param finish:(void (^)(NSDictionary *dictionary, ReqestType flag))finish {
    NSString *requestUrl=[NSString stringWithFormat:@"%@%@",BASE_URL,url];
    NSLog(@"jsonPost %@ /n 内容：%@",requestUrl,param);
    
    AFHTTPSessionManager *manager= [AFHTTPSessionManager shareManager];
 
    
    [self languageSwitch:manager];
    [manager POST:requestUrl parameters:param headers:[self httpHeaderDic]  progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        if([responseObject isKindOfClass:[NSData class]]){
            NSString * str  =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            NSString * transStr = [self removeUnescapedCharacter:str];
            NSData * data = [transStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
            
            ReqestType flag = Successeds;
            finish(resdic,flag);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *dic = @{@"error":error};
        NSLog(@"大哥出错了错误接口URL = %@  ---  错误原因error === %@",url,error.localizedDescription);
        finish(dic,Fails);
    }];
}

- (void)requsetUplodImage:(NSData *)imageData andImageName:(NSString *)imageName andUserID:(NSString *)userID finish:(void (^)(id imageUrl,ReqestType flag))finish{
    
    NSData *datas=[[NSString stringWithFormat:@"%@",userID] dataUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager shareManager];
    //    HelpLog(basicType,[NSString stringWithFormat:@"上传图片方法manager"]);
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlString = [NSString stringWithFormat:@"%@/uiface/HUploadFileServletar_01165",BASE_URL];
    
    //    HelpLog(basicType,[NSString stringWithFormat:@"上传图片方法urlString"]);
    [manager POST:urlString parameters:nil headers:[self httpHeaderDic]  constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:imageName mimeType:@"image/png"];
        [formData appendPartWithFormData:datas name:@"user_id"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"请求responseObject：%@",responseObject);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
//        [self.delegate getHttpData:dic response:1];
        ReqestType flag = Successeds;
        finish(dic,flag);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",[error localizedDescription]);
//        [self.delegate getHttpData:nil response:0];
        ReqestType flag = Fails;
        finish(nil,flag);
    }];
    
}

-(void)requestGet:(NSString *)url andHeaderParams:(NSDictionary *)params finish:(void (^)(NSDictionary *, ReqestType))finish{
    NSString *requestUrl=[NSString stringWithFormat:@"%@%@",BASE_URL,url];
    NSLog(@"jsonPost %@ /n 内容：%@",requestUrl,params);
    
    AFHTTPSessionManager *manager= [AFHTTPSessionManager shareManager];
     
    [self languageSwitch:manager];
    [manager GET:requestUrl parameters:params headers:[self httpHeaderDic]  progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        if([responseObject isKindOfClass:[NSData class]]){
            NSString * str  =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            NSString * transStr = [self removeUnescapedCharacter:str];
            NSData * data = [transStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resdic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error];
            
            ReqestType flag = Successeds;
            finish(resdic,flag);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *dic = @{@"error":error};
        NSLog(@"大哥出错了错误接口URL = %@  ---  错误原因error === %@",url,error.localizedDescription);
        finish(dic,Fails);
    }];
}

#pragma mark - mall
- (void)requestMallPost:(NSString *)url andHeaderParam:(NSDictionary *)param finish:(void (^)(NSDictionary *dictionary, ReqestType flag))finish {
    NSString *requestUrl=[NSString stringWithFormat:@"%@%@",BASE_MALL_URLL,url];
    NSLog(@"jsonPost %@ /n 参数:%@",requestUrl,param);
    
    AFHTTPSessionManager *manager= [AFHTTPSessionManager shareManager];
  
    [self languageSwitch:manager];
    [manager POST:requestUrl parameters:param headers:[self httpHeaderDic] progress:^(NSProgress * _Nonnull uploadProgress) {
         
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        if([responseObject isKindOfClass:[NSData class]]){
            NSString * str  =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            NSString * transStr = [self removeUnescapedCharacter:str];
            NSData * data = [transStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resdic = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error] wt_dictionaryReplaceNullByString];
            
            ReqestType flag = Successeds;
            finish(resdic,flag);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSDictionary *dic = @{@"error":error};
        NSLog(@"大哥出错了错误接口URL = %@  ---  错误原因error === %@",url,error.localizedDescription);
        finish(dic,Fails);
    }];
     
}

- (void)requsetMallUplodImage:(NSData *)imageData andImageName:(NSString *)imageName andUserID:(NSString *)userID finish:(void (^)(id imageUrl,ReqestType flag))finish{
    
    NSData *datas=[[NSString stringWithFormat:@"%@",userID] dataUsingEncoding:NSUTF8StringEncoding];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager shareManager];
    //    HelpLog(basicType,[NSString stringWithFormat:@"上传图片方法manager"]);
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlString = [NSString stringWithFormat:@"%@/uiface/HUploadFileServletar_01165",BASE_MALL_URLL];
    
    //    HelpLog(basicType,[NSString stringWithFormat:@"上传图片方法urlString"]);
    [manager POST:urlString parameters:nil headers:[self httpHeaderDic] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:imageData name:@"file" fileName:imageName mimeType:@"image/png"];
        [formData appendPartWithFormData:datas name:@"user_id"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        NSLog(@"上传进度%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"请求responseObject：%@",responseObject);
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:nil];
        //        [self.delegate getHttpData:dic response:1];
                ReqestType flag = Successeds;
                finish(dic,flag);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"请求失败：%@",[error localizedDescription]);
        //        [self.delegate getHttpData:nil response:0];
                ReqestType flag = Fails;
                finish(nil,flag);
    }];
 
    
}

-(void)requestMallGet:(NSString *)url andHeaderParams:(NSDictionary *)params finish:(void (^)(NSDictionary *, ReqestType))finish{
    NSString *requestUrl=[NSString stringWithFormat:@"%@%@",BASE_MALL_URLL,url];
    NSLog(@"jsonPost %@ /n 参数:%@",requestUrl,params);
    
    AFHTTPSessionManager *manager= [AFHTTPSessionManager shareManager];
     
    [self languageSwitch:manager];
    
    [manager GET:requestUrl parameters:params headers:[self httpHeaderDic] progress:^(NSProgress * _Nonnull downloadProgress) {
         
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error;
        if([responseObject isKindOfClass:[NSData class]]){
            NSString * str  =[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            NSString * transStr = [self removeUnescapedCharacter:str];
            NSData * data = [transStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *resdic = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves error:&error] wt_dictionaryReplaceNullByString];
            
            ReqestType flag = Successeds;
            finish(resdic,flag);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         NSDictionary *dic = @{@"error":error};
         NSLog(@"大哥出错了错误接口URL = %@  ---  错误原因error === %@",url,error.localizedDescription);
         finish(dic,Fails);
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
        
    }
}

-(NSMutableDictionary *)httpHeaderDic{
    NSMutableDictionary *httpHeaderDic = [NSMutableDictionary dictionaryWithCapacity:1];
    httpHeaderDic[@"token"] = [WTUserInfo shareUserInfo].token;
    return httpHeaderDic;
}

@end
