//
//  MyWalletViewController.h
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewController.h"
#import "BaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyWalletViewController : BaseTableViewController

@end


@protocol MyWalletCellDelegate  <NSObject>

-(void)walletButtonClick:(UIButton *)button;

@end
/// 余额
@interface MyWalletCell : BaseTableViewCell

@property(nonatomic, strong)UILabel *balanceNumLabel;
@property(nonatomic, weak) id<MyWalletCellDelegate> delegate;

-(void)setCellData:(NSDictionary *)dic;

@end
 
 

NS_ASSUME_NONNULL_END
