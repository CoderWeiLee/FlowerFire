//
//  JVShopcartTableViewProxy.m
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "JVShopcartTableViewProxy.h"
#import "JVShopcartProductModel.h"
#import "JVShopcartCell.h"
#import "JVShopcartHeaderView.h"
 
@implementation JVShopcartTableViewProxy

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    JVShopcartBrandModel *brandModel = self.dataArray[section];
//    NSArray *productArray = brandModel.products;
//    return productArray.count;
    return self.dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JVShopcartProductModel *productModel = self.dataArray[indexPath.row];
    !self.shopcartProxyDidSelectedRowBlock ? : self.shopcartProxyDidSelectedRowBlock(productModel.brandId);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JVShopcartCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JVShopcartCell"];
 //   JVShopcartBrandModel *brandModel = self.dataArray[indexPath.section];
 //   NSArray *productArray = brandModel.products;
 //   NSArray *productArray = self.dataArray[indexPath.row];
  //  if (productArray.count > indexPath.row) {
    JVShopcartProductModel *productModel = self.dataArray[indexPath.row];
    NSString *productName = [NSString stringWithFormat:@"%@", productModel.brandName];
    NSString *productSize = [NSString stringWithFormat:@"W:%ld H:%ld D:%ld", productModel.specWidth, productModel.specHeight, productModel.specLength];
    [cell configureShopcartCellWithProductURL:productModel.productPicUri productName:productName productSize:productSize productPrice:productModel.productPrice threePrice:productModel.three_price productCount:productModel.productQty productStock:productModel.productStocks productSelected:productModel.isSelected cartId:productModel.cartId];
 //   }
    
    __weak __typeof(self) weakSelf = self;
    cell.shopcartCellBlock = ^(BOOL isSelected, UIButton *button) {
        if (weakSelf.shopcartProxyProductSelectBlock) {
            weakSelf.shopcartProxyProductSelectBlock(isSelected, indexPath,button);
        }
    };
    
    cell.shopcartCellEditBlock = ^(NSInteger count){
        if (weakSelf.shopcartProxyChangeCountBlock) {
            weakSelf.shopcartProxyChangeCountBlock(count, indexPath);
        }
    };
    
    return cell;
}

#pragma mark UITableViewDelegate
//
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    JVShopcartHeaderView *shopcartHeaderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"JVShopcartHeaderView"];
//    if (self.dataArray.count > section) {
//        JVShopcartBrandModel *brandModel = self.dataArray[section];
//        [shopcartHeaderView configureShopcartHeaderViewWithBrandName:brandModel.brandName brandSelect:brandModel.isSelected];
//    }
//    
//    __weak __typeof(self) weakSelf = self;
//    shopcartHeaderView.shopcartHeaderViewBlock = ^(BOOL isSelected){
//        if (weakSelf.shopcartProxyBrandSelectBlock) {
//            weakSelf.shopcartProxyBrandSelectBlock(isSelected, section);
//        }
//    };
//    return shopcartHeaderView;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 0;
//}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        if (self.shopcartProxyDeleteBlock) {
            self.shopcartProxyDeleteBlock(indexPath);
        }
    }];
    
//    UITableViewRowAction *starAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"收藏" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
//        if (self.shopcartProxyStarBlock) {
//            self.shopcartProxyStarBlock(indexPath);
//        }
//    }];
    
    return @[deleteAction];
}

@end
