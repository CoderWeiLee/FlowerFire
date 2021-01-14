//
//  MyOrderPageCell.h
//  FireCoin
//
//  Created by 王涛 on 2019/6/6.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "LegalCurrencyModel.h"
#import "MyOrderPageTBVC.h"
NS_ASSUME_NONNULL_BEGIN

@protocol MyOrderPageCellDelegate <NSObject>

-(void)cancelOrder:(UIButton *)btn cell:(UITableViewCell *)cell;

@end

@interface MyOrderPageCell : BaseTableViewCell

-(void)setCellData:(LegalCurrencyModel *)model type:(MyOrderPageWhereJump )MyOrderPageWhereJump;

@property(nonatomic, weak) id<MyOrderPageCellDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
