//
//  LeftMenuPageCell.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/5.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "QuotesTransactionPairModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LeftMenuPageCell : BaseTableViewCell

@property (strong, nonatomic)  UILabel *namelabel;
@property (strong, nonatomic)  UILabel *changelabel;

-(void)setCellData:(QuotesTransactionPairModel *)model;

/**
 币股的数据
 
 */
-(void)setSecuritiesCellData:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END
