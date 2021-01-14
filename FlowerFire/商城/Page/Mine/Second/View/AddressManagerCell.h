//
//  AddressManagerCell.h
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AddressInfoModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol AddressManagerCellDelegate <NSObject>

-(void)defaultAddressClick:(UIButton *)btn
                 indexPath:(NSIndexPath *)indexPath;

-(void)editAddressClick:(UIButton *)btn
                 indexPath:(NSIndexPath *)indexPath;

-(void)deleteAddressClick:(UIButton *)btn
              indexPath:(NSIndexPath *)indexPath;

@end

@interface AddressManagerCell : BaseTableViewCell

@property(nonatomic, strong)NSIndexPath  *indexPath;

@property(nonatomic, weak)id<AddressManagerCellDelegate> delegate;

@property(nonatomic, strong)UIButton     *defultAddressButton;

-(void)setCellData:(AddressInfoModel *)model;

@end

NS_ASSUME_NONNULL_END
