//
//  WithdrawCoinCell.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/22.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface WithdrawCoinCell : BaseTableViewCell

@property (nonatomic, strong) NSString *key;
/**
 输入的文字
 */
@property (nonatomic, strong) id textStr;

@property (nonatomic, strong) UITextField  *textField;
-(void)setCellData:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
