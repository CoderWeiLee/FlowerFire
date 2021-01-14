//
//  MyOrderCell.h
//  531Mall
//
//  Created by 王涛 on 2020/5/21.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MyOrderViewController.h"
#import "MyOrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MyOrderCellDelegate <NSObject>

/// 签收
-(void)signForClick:(UIButton *)btn;

/// 退货
-(void)returnClick:(UIButton *)btn;

/// 付款
-(void)payClick:(UIButton *)btn;

/// 取消
-(void)cancelClick:(UIButton *)btn;

/// 取消显示
-(void)cancelShowClick:(UIButton *)btn;

@end

@interface MyOrderCell : BaseTableViewCell

-(void)setCellData:(MyOrderModel *)model
    GoodsInfoModel:(MyOrderGoodInfoModel *)goodsInfoModel
         orderType:(MyOrderType)type
         isLastRow:(BOOL)isLastRow;

- (void)layoutWaitPaySubview;
- (void)layoutWaitShipSubview;
- (void)layoutShippedView;
- (void)layoutOverView;
- (void)layoutOtherView;

@property(nonatomic, weak)id<MyOrderCellDelegate> delegate;
@property(nonatomic, strong)UIButton              *stateButton;

@end

 

@interface MyOrderCellWaitPay : MyOrderCell
 
@end

@interface MyOrderCellWaitShip : MyOrderCell
 
@end

@interface MyOrderCellShipped : MyOrderCell
 
@end

@interface MyOrderCellOver : MyOrderCell
 
@end

/// 其他状态
@interface MyOrderCellOther : MyOrderCell
 

@end

NS_ASSUME_NONNULL_END
