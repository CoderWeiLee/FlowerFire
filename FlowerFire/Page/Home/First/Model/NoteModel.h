//
//  NoteModel.h
//  FireCoin
//
//  Created by 王涛 on 2019/9/12.
//  Copyright © 2019 王涛. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoteModel : NSObject

@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *addtime;
@property(nonatomic, copy) NSString *sort;
@property(nonatomic, copy) NSString *NoteId;
@property(nonatomic, copy) NSString *content;
@property(nonatomic, copy) NSString *status;


@end

NS_ASSUME_NONNULL_END
