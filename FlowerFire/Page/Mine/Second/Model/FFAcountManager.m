//
//  FFAcountManager.m
//  FlowerFire
//
//  Created by 王涛 on 2020/9/1.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "FFAcountManager.h"

@implementation FFAcountManager

+ (instancetype)sharedInstance
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
    }
    return self;
}

- (void)saveUserAccount:(NSDictionary *)userAccount{
    //去重
    BOOL isHas = NO;
    NSArray *userAccountArray = [self userAccountArray];
    for (UserAccount *userAccount2 in userAccountArray) {
        if([userAccount2.username isEqualToString:userAccount[@"username"]]){
            isHas = YES;
            return;
        }
    }
    
    if(isHas){
        printAlert(LocalizationKey(@"578Tip150"), 1.f);
    }else{
        UserAccount *sqlAccount = [UserAccount MR_createEntity];
        sqlAccount.address = [WTUserInfo shareUserInfo].address;
        sqlAccount.sd = [WTUserInfo shareUserInfo].SD;
        sqlAccount.pwd = userAccount[@"pwd"];
        sqlAccount.type = [userAccount[@"type"] intValue];
        sqlAccount.username = userAccount[@"username"];
        sqlAccount.time = [NSDate date];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    }
}
- (void)updateUserMoney:(NSDictionary *)dic{
    NSArray *userAccountArray = [self userAccountArray];
    for (UserAccount *userAccount2 in userAccountArray) {
        if([userAccount2.username isEqualToString:dic[@"data"][@"welcome"][@"username"]]){ 
            userAccount2.address = dic[@"data"][@"welcome"][@"address"];
            userAccount2.sd = dic[@"data"][@"welcome"][@"SD"];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            return;
        }
    }
}


- (void)deleteUserAccount:(NSString *)userName{
    NSArray *personsdelete = [UserAccount MR_findByAttribute:@"username" withValue:userName andOrderBy:nil ascending:YES];
 
    for (UserAccount *userAccount2 in personsdelete) {
        [userAccount2 MR_deleteEntity];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        return;
    }
}

- (NSArray *)userAccountArray{
    NSArray<UserAccount *> *sqliteArray = [UserAccount MR_findAllSortedBy:@"time" ascending:YES];
    return sqliteArray;
}



@end
