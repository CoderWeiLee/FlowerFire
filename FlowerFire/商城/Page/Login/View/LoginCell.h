//
//  LoginCell.h
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "LoginInputView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^getCodeBlock)(UIButton *); 
typedef void(^getImageCodeBlock)(UIButton *);


@interface LoginCell : BaseTableViewCell
 
@property(nonatomic, strong)LoginInputView *loginInputView;
@property(nonatomic, copy)getCodeBlock           getCodeBlock;
@property(nonatomic, copy)getImageCodeBlock      getImageCodeBlock;

/// 实名认证用的
/// @param dic dic
-(void)setCellData:(NSDictionary *)dic;

/// 登录页面用的
/// @param dic dic
-(void)setLoginCellData:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
