//
//  LWNewsModel.h
//  FlowerFire
//
//  Created by 李伟 on 2021/1/20.
//  Copyright © 2021 Celery. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LWNewsModel : NSObject
@property (nonatomic, copy) NSString *addtime;
@property (nonatomic, copy) NSString *addtime_text;
@property (nonatomic, copy) NSString *coverurl;
@property (nonatomic, copy) NSString *haccontent;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *status_text;
@property (nonatomic, copy) NSString *subcontent;
@property (nonatomic, copy) NSString *title;
//分类
@property (nonatomic, copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
