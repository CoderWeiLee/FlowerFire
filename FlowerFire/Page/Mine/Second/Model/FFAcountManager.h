//
//  FFAcountManager.h
//  FlowerFire
//
//  Created by 王涛 on 2020/9/1.
//  Copyright © 2020 Celery. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserAccount+CoreDataProperties.h"
#import <MagicalRecord/MagicalRecord.h>

NS_ASSUME_NONNULL_BEGIN
 
@interface FFAcountManager : NSObject

+ (instancetype)sharedInstance;

/// 保存
-(void)saveUserAccount:(NSDictionary *)userAccount;
-(void)updateUserMoney:(NSDictionary *)dic;
/// 删除
-(void)deleteUserAccount:(NSString *)userName;

-(NSArray *)userAccountArray;

@end

NS_ASSUME_NONNULL_END
