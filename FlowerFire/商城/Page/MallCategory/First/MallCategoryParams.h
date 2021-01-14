//
//  MallCategoryParams.h
//  MallCategory
//
//  Created by mengxiang on 2019/11/21.
//

#ifndef MallCategoryParams_h
#define MallCategoryParams_h

#import "UIView+Size.h"
#import "NSString+AllStringCategory.h"

#define kMain_Width [UIScreen mainScreen].bounds.size.width

#define kMain_Height [UIScreen mainScreen].bounds.size.height

#define KTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)

#define kStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height

#define kNavigationBarHeight  (kStatusBarHeight + 44.0f)

#define  kSafeAreaBottomHeight  (kStatusBarHeight>20? 34 : 0)

#define MALLHEXCOLOR(string) [(string) colorWithHexString]


#define KTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)


#define MALL_CATEGORY_DETAIL_WILLDISPLAY_HEADER    @"willDislayHeaderView_category_detail"

#define MALL_CATEGORY_DETAIL_DIDENDDISPLAY_HEADER  @"didEndDislayHeaderView_category_detail"

#define MALL_CATEGORY_MENU_DIDSELECTROWATINDEXPATH @"didSelectRowAtIndexPath_menu"

#define CATEGORYMENU_WIDTH       kMain_Width*0.253

#define CATEGORYDETAIL_WIDTH     kMain_Width*0.747

#define CATEGORY_DISPLAY_HEIGHT  kMain_Height - KTabBarHeight - kNavigationBarHeight - kSafeAreaBottomHeight

#define CATEGORYMENU_CELL_H      45

#define CATEGORY_DETAIL_SECTIONINSET    UIEdgeInsetsMake(18.5, 10, 15, 10)

#define CATEGORY_DETAIL_CONTENTINSET    UIEdgeInsetsMake(0, 0, 10, 0)

#define CATEGORY_DETAIL_HEADER_H    40

#define CATEGORY_DETAIL_ITEM_W     (CATEGORYDETAIL_WIDTH-20-40)/3

#define CATEGORY_DETAIL_ITEM_H     90

#define CATEGORY_DETAIL_MINIMUMINTERITEMS_SPACE 5

#define CATEGORY_DETAIL_MINIMUMLINE_SPACE       30

#endif /* MallCategoryParams_h */
