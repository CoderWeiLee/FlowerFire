//
//  JVShopcartFormat.m
//  JVShopcart
//
//  Created by AVGD-Jarvi on 17/3/23.
//  Copyright © 2017年 AVGD-Jarvi. All rights reserved.
//

#import "JVShopcartFormat.h"
#import "JVShopcartProductModel.h"
#import <UIKit/UIKit.h>

@interface JVShopcartFormat ()

@property (nonatomic, strong) NSMutableArray *shopcartListArray;    /**< 购物车数据源 */

@end

@implementation JVShopcartFormat

- (void)requestShopcartProductList {
    //在这里请求数据 当然我直接用本地数据模拟的
    self.shopcartListArray = [NSMutableArray array];
//    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"shopcart" ofType:@"plist"];
//    NSMutableArray *dataArray = [NSMutableArray arrayWithContentsOfFile:plistPath];
//    for (NSDictionary *dic in dataArray) {
//        [self.shopcartListArray addObject:[JVShopcartBrandModel yy_modelWithDictionary:dic]];
//    }
//

    [MBManager showLoading];
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    [[ReqestHelpManager share] requestMallPost:@"/api/cart/cartList" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
        [MBManager hideAlert];
        if([dicForData[@"status"] integerValue] == 1){
            for (NSDictionary *dic in dicForData[@"data"]) {
                
                [self.shopcartListArray addObject:[JVShopcartProductModel yy_modelWithDictionary:dic]];
            }
            //成功之后回调
            [self.delegate shopcartFormatRequestProductListDidSuccessWithArray:self.shopcartListArray];
            //刷新整体状态
            [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected] TotalThreePrice:[self accountTotalThreePrice]];
        }else if([dicForData[@"status"] integerValue] == 9){
             [WTMallUserInfo logout];
        }else{
            printAlert(dicForData[@"msg"], 1.f);
        }
    }];
    
}

- (void)selectProductAtIndexPath:(NSIndexPath *)indexPath isSelected:(BOOL)isSelected productButton:(UIButton *)productButton{
//    JVShopcartBrandModel *brandModel = self.shopcartListArray[indexPath.section];
//    JVShopcartProductModel *productModel = brandModel.products[indexPath.row];
//    productModel.isSelected = isSelected;
//
//    BOOL isBrandSelected = YES;
//
//    for (JVShopcartProductModel *aProductModel in brandModel.products) {
//        if (aProductModel.isSelected == NO) {
//            isBrandSelected = NO;
//        }
//    }
    
//    brandModel.isSelected = isBrandSelected;
     
    
//    BOOL isBrandSelected = YES;
//    for (JVShopcartProductModel *aproductModel in self.shopcartListArray) {
//        if (aproductModel.isSelected == NO) {
//            aproductModel.isSelected = NO;
//        }
//    }
    
     
    JVShopcartProductModel *productModel = self.shopcartListArray[indexPath.row];
    productModel.isSelected = isSelected; 
    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected] TotalThreePrice:[self accountTotalThreePrice]];
              
  
}

- (void)selectBrandAtSection:(NSInteger)section isSelected:(BOOL)isSelected {
//    JVShopcartBrandModel *brandModel = self.shopcartListArray[section];
//    brandModel.isSelected = isSelected;
//
//    for (JVShopcartProductModel *aProductModel in brandModel.products) {
//        aProductModel.isSelected = brandModel.isSelected;
//    }
//
//    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
}
//改变购物车数量
- (void)changeCountAtIndexPath:(NSIndexPath *)indexPath count:(NSInteger)count {
//    JVShopcartBrandModel *brandModel = self.shopcartListArray[indexPath.section];
    JVShopcartProductModel *productModel = self.shopcartListArray[indexPath.row];
    if (count <= 0) {
        count = 1;
    } else if (count > productModel.productStocks) {
        count = productModel.productStocks;
    }
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"amount"] = NSStringFormat(@"%ld",(long)count);
    md[@"cart_id"] = productModel.cartId;
    
    [MBManager showLoading];
    [[ReqestHelpManager share] requestMallPost:@"/api/cart/editCartAmount" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
        [MBManager hideAlert];
        if([dicForData[@"status"] integerValue] == 1){
            //根据请求结果决定是否改变数据
            productModel.productQty = count;
            
            [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected] TotalThreePrice:[self accountTotalThreePrice]];
        }else{
            printAlert(dicForData[@"msg"], 1.f);
        }
    }];
     
}

- (void)deleteProductAtIndexPath:(NSIndexPath *)indexPath {
//    JVShopcartBrandModel *brandModel = self.shopcartListArray[indexPath.section];
    JVShopcartProductModel *model = self.shopcartListArray[indexPath.row];
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"cart_id"] = @[model.cartId];
    
    [MBManager showLoading];
    [[ReqestHelpManager share] requestMallPost:@"/api/cart/delCart" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
        [MBManager hideAlert];
        if([dicForData[@"status"] integerValue] == 1){
            JVShopcartProductModel *productModel = self.shopcartListArray[indexPath.row];
            
            //根据请求结果决定是否删除
            [self.shopcartListArray removeObject:productModel];
            [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected] TotalThreePrice:[self accountTotalThreePrice]];
            
            if (self.shopcartListArray.count == 0) {
                [self.delegate shopcartFormatHasDeleteAllProducts];
            }
        }else{
            printAlert(dicForData[@"msg"], 1.f);
        }
    }];
    

//    [brandModel.products removeObject:productModel];
//    if (brandModel.products.count == 0) {
//        [self.shopcartListArray removeObject:brandModel];
//    } else {
//        if (!brandModel.isSelected) {
//            BOOL isBrandSelected = YES;
//            for (JVShopcartProductModel *aProductModel in brandModel.products) {
//                if (!aProductModel.isSelected) {
//                    isBrandSelected = NO;
//                    break;
//                }
//            }
//            
//            if (isBrandSelected) {
//                brandModel.isSelected = YES;
//            }
//        }
//    }
     
}

- (void)beginToDeleteSelectedProducts {
    NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
  //  for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
    for (JVShopcartProductModel *productModel in self.shopcartListArray) {
            if (productModel.isSelected) {
                [selectedArray addObject:productModel];
            }
        }
 //   }
    
    [self.delegate shopcartFormatWillDeleteSelectedProducts:selectedArray];
}

- (void)deleteSelectedProducts:(NSArray *)selectedArray {
    //根据请求结果决定是否批量删除
    
    NSMutableArray *cardIDs = [NSMutableArray array];
    for (JVShopcartProductModel *model in selectedArray) {
        [cardIDs addObject:model.cartId];
    }
     
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"cart_id"] = cardIDs;
    
    [MBManager showLoading];
    [[ReqestHelpManager share] requestMallPost:@"/api/cart/delCart" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
        [MBManager hideAlert];
        if([dicForData[@"status"] integerValue] == 1){
//            NSMutableArray *emptyArray = [[NSMutableArray alloc] init];
  
            [self.shopcartListArray removeObjectsInArray:selectedArray];
//            for (JVShopcartProductModel *products in self.shopcartListArray) {
//                [emptyArray addObject:products];
//            }
//
//            if (emptyArray.count) {
//                [self.shopcartListArray removeObjectsInArray:emptyArray];
//            }
            
            [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected] TotalThreePrice:[self accountTotalThreePrice]];
            
            if (self.shopcartListArray.count == 0) {
                [self.delegate shopcartFormatHasDeleteAllProducts];
            }
        }else{
            printAlert(dicForData[@"msg"], 1.f);
        }
    }];
    
//    NSMutableArray *emptyArray = [[NSMutableArray alloc] init];
////    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
////        [brandModel.products removeObjectsInArray:selectedArray];
////
////        if (brandModel.products.count == 0) {
////            [emptyArray addObject:brandModel];
////        }
////    }
//
//    [self.shopcartListArray removeObjectsInArray:selectedArray];
//    for (JVShopcartProductModel *products in self.shopcartListArray) {
//        [emptyArray addObject:products];
//    }
//
//    if (emptyArray.count) {
//        [self.shopcartListArray removeObjectsInArray:emptyArray];
//    }
//
//    [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected]];
//
//    if (self.shopcartListArray.count == 0) {
//        [self.delegate shopcartFormatHasDeleteAllProducts];
//    }
}

- (void)starProductAtIndexPath:(NSIndexPath *)indexPath {
    //这里写收藏的网络请求
    
}

- (void)starSelectedProducts {
    //这里写批量收藏的网络请求
     
}
//全选 or 取消全选
- (void)selectAllProductWithStatus:(BOOL)isSelected {
//    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
//        brandModel.isSelected = isSelected;
//        for (JVShopcartProductModel *productModel in brandModel.products) {
//            productModel.isSelected = isSelected;
//        }
//    }
    
    NSMutableArray *cardIDs = [NSMutableArray array];
    for (JVShopcartProductModel *model in self.shopcartListArray) {
          [cardIDs addObject:model.cartId];
    }
      
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"choose"] = isSelected ? @"1" : @"0";
    md[@"cart_id"] = cardIDs;
      
    [MBManager showLoading];
    [[ReqestHelpManager share] requestMallPost:@"/api/cart/chooseCartGood" andHeaderParam:md finish:^(NSDictionary *dicForData, ReqestType flag) {
      [MBManager hideAlert];
      if([dicForData[@"status"] integerValue] == 1){
        
           for (JVShopcartProductModel *productModel in self.shopcartListArray) {
               productModel.isSelected = isSelected;
           }
           
           [self.delegate shopcartFormatAccountForTotalPrice:[self accountTotalPrice] totalCount:[self accountTotalCount] isAllSelected:[self isAllSelected] TotalThreePrice:[self accountTotalThreePrice]];
        }else{
          printAlert(dicForData[@"msg"], 1.f);
        }
    }];
    
 
}

- (void)settleSelectedProducts {
    NSMutableArray *settleArray = [[NSMutableArray alloc] init];
//    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
//        NSMutableArray *selectedArray = [[NSMutableArray alloc] init];
//        for (JVShopcartProductModel *productModel in brandModel.products) {
//            if (productModel.isSelected) {
//                [selectedArray addObject:productModel];
//            }
//        }
//
//        brandModel.selectedArray = selectedArray;
//
//        if (selectedArray.count) {
//            [settleArray addObject:brandModel];
//        }
//    }
    
    for (JVShopcartProductModel *productModel in self.shopcartListArray) {
        if (productModel.isSelected) {
            [settleArray addObject:productModel];
        }
    }
     
    
    [self.delegate shopcartFormatSettleForSelectedProducts:settleArray];
}

#pragma mark private methods

- (float)accountTotalPrice {
    float totalPrice = 0.f;
//    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
//        for (JVShopcartProductModel *productModel in brandModel.products) {
//            if (productModel.isSelected) {
//                totalPrice += productModel.productPrice * productModel.productQty;
//            }
//        }
//    }
    for (JVShopcartProductModel *productModel in self.shopcartListArray) {
        if (productModel.isSelected) {
            totalPrice += [productModel.productPrice doubleValue] * productModel.productQty;
        }
    }
    
    return totalPrice;
}

- (float)accountTotalThreePrice {
    float totalPrice = 0.f;
 
    for (JVShopcartProductModel *productModel in self.shopcartListArray) {
        if (productModel.isSelected) {
            totalPrice += [productModel.three_price doubleValue] * productModel.productQty;
        }
    }
    
    return totalPrice;
}

- (NSInteger)accountTotalCount {
    NSInteger totalCount = 0;
//
//    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
//        for (JVShopcartProductModel *productModel in brandModel.products) {
//            if (productModel.isSelected) {
//                totalCount += productModel.productQty;
//            }
//        }
//    }
    for (JVShopcartProductModel *productModel in self.shopcartListArray) {
        if (productModel.isSelected) {
            totalCount += productModel.productQty;
        }
    }
    
    return totalCount;
}

- (BOOL)isAllSelected {
    if (self.shopcartListArray.count == 0) return NO;
    
    BOOL isAllSelected = YES;
    
//    for (JVShopcartBrandModel *brandModel in self.shopcartListArray) {
//        if (brandModel.isSelected == NO) {
//            isAllSelected = NO;
//        }
//    }
    
    for (JVShopcartProductModel *productModel in self.shopcartListArray) {
        if(productModel.isSelected == NO){
            isAllSelected = NO;
        }
    }
    
    return isAllSelected;
}

@end
