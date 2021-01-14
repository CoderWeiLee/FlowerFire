//
//  UpdateUserInfoPopView.h
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    UpdateUserInfoTypeName = 1, //不用修改手机号了
    UpdateUserInfoTypePhone = 2,
    UpdateUserInfoTypeLoginPwd,
    UpdateUserInfoTypePayPwd, 
} UpdateUserInfoType;


@interface UpdateUserInfoPopView : BaseUIView

-(instancetype)initWithFrame:(CGRect)frame
          updateUserInfoType:(UpdateUserInfoType)type
             updateTextBlock:(void (^)(NSString *text,NSString *text2,NSString *text3) ) block;

@property (nonatomic, assign) UpdateUserInfoType updateUserInfoType;
@property (nonatomic, copy)dispatch_block_t      closePopViewBlock;

@end

NS_ASSUME_NONNULL_END
