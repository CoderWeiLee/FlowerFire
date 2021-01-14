//
//  MemberLevelInfoModel.h
//  531Mall
//
//  Created by 王涛 on 2020/6/8.
//  Copyright © 2020 Celery. All rights reserved.
//。会员等级详情模型

#import "WTBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MemberLevelRankNodeModel : WTBaseModel

@property(nonatomic, copy)NSString *sheet;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, copy)NSString *xnode;
 
@end

@interface MemberLevelRankInfosModel : WTBaseModel
 
@property(nonatomic, copy)NSString *money;
@property(nonatomic, copy)NSString *name;
@property(nonatomic, assign)NSInteger num;
@property(nonatomic, copy)NSString *stock;
@property(nonatomic, copy)NSString *xnode;
 
@end

@interface MemberLevelInfoModel : WTBaseModel

@property(nonatomic, copy)NSString *nowtype;
@property(nonatomic, strong)MemberLevelRankInfosModel             *nowrank;
@property(nonatomic, strong)MemberLevelRankNodeModel              *ranknode;
@property(nonatomic, copy)NSArray<MemberLevelRankInfosModel *>    *rankinfos;

@end

NS_ASSUME_NONNULL_END
