//
//  NoteModel.m
//  FireCoin
//
//  Created by 王涛 on 2019/9/12.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "NoteModel.h"

@implementation NoteModel

+ (NSDictionary *)modelCustomPropertyMapper {
    // 将personId映射到key为id的数据字段
    return @{@"NoteId":@"id"};
    
}

- (NSString *)addtime{
    return [HelpManager getTimeStr:_addtime dataFormat:@"yyyy-MM-dd HH:mm:ss"];
}


@end
