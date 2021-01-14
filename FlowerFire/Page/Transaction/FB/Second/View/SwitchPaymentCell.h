//
//  SwitchPaymentCell.h
//  FireCoin
//
//  Created by 王涛 on 2019/5/29.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SwitchPaymentCell : BaseTableViewCell

@property(nonatomic, strong) UILabel  *leftLabel,*rightLabel;
@property(nonatomic, strong) UIButton *rightBtn;

-(void)setCellData:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END