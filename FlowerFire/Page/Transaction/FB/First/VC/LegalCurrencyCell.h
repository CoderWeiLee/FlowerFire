//
//  LegalCurrencyCell.h
//  FireCoin
//
//  Created by 赵馨 on 2019/5/28.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "LegalCurrencyModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol LegalCurrencyCellDelegate <NSObject>

-(void)btnClick:(UIButton *)btn cell:(UITableViewCell *)cell;

@end

@interface LegalCurrencyCell : BaseTableViewCell

-(void)setCellData:(LegalCurrencyModel *)model
          coinName:(NSString *)coinName
               buyOrSeal:(NSString *)buyOrSeal; //NO 为买

@property(nonatomic, weak) id<LegalCurrencyCellDelegate> delegate;
@property(nonatomic, strong) UIButton        *buyBtn;

@end

NS_ASSUME_NONNULL_END
