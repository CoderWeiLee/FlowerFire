//
//  AppealSectionThreeCell.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/4.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppealSectionThreeCell : BaseTableViewCell

/**
 上传的图片数组
 */
@property (nonatomic ,strong) NSMutableArray *photosArray;

/**
 有两个控制器跳转这个，如果是申诉详情进入这里，变量为True
 */
@property(nonatomic, assign) Boolean     isJumpDetails;


@end

NS_ASSUME_NONNULL_END
