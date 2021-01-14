//
//  JVShopcartCell.h
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ShopcartCellBlock)(BOOL isSelected,UIButton *button);
typedef void(^ShopcartCellEditBlock)(NSInteger count);

@interface JVShopcartCell : UITableViewCell

@property (nonatomic, copy) ShopcartCellBlock shopcartCellBlock;
@property (nonatomic, copy) ShopcartCellEditBlock shopcartCellEditBlock;

- (void)configureShopcartCellWithProductURL:(NSString *)productURL
                                productName:(NSString *)productName
                                productSize:(NSString *)productSize
                               productPrice:(NSString *)productPrice
                               threePrice:(NSString *)threePrice
                               productCount:(NSInteger)productCount
                               productStock:(NSInteger)productStock
                            productSelected:(BOOL)productSelected
                            cartId:(NSString *)cartId;

@end
