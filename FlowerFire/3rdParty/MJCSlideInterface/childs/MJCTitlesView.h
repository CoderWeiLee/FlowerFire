//
//  MJCTitlesScollView.h
//  MJCSegmentInterface
//
//  Created by mjc on 16/11/21.
//  Copyright © 2016年 MJC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJCTabItem.h"
#import "MJCSegmentStylesTools.h"


typedef void(^DefaultSelectedItemBlock)(MJCTabItem *tabItem);
typedef void(^SelectedItemClickBlock)(MJCTabItem *tabItem);
typedef void(^TabItemClickBlock)(MJCTabItem *tabItem);
typedef void(^TabItemClickCancelBlock)(MJCTabItem *tabItem);
typedef void(^ScrollDidEndBlock)(MJCTabItem *tabItem);
typedef void(^TabItemArrBlock)(NSArray<MJCTabItem*>*tabItemArr);

@interface MJCTitlesView : UIScrollView
@property (nonatomic,weak) UIViewController *hostController;
@property (nonatomic,strong) NSArray *titlesArray;
-(void)jc_scrollViewDidScroll:(UIScrollView *)scrollView isIndicatorFollow:(BOOL)isIndicatorFollow;
- (void)jc_scrollViewDidEndDragging:(UIScrollView *)scrollView itemTextNormalColor:(UIColor *)itemTextNormalColor;
- (void)jc_scrollViewWillEndDragging:(UIScrollView *)scrollView itemTextNormalColor:(UIColor *)itemTextNormalColor;
- (void)jc_scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
@property(copy,nonatomic) TabItemClickCancelBlock tabItemClickCancelBlock;
@property(copy,nonatomic) TabItemClickBlock tabItemClickBlock;
@property(copy,nonatomic) ScrollDidEndBlock scrollDidEndBlock;
@property(copy,nonatomic) TabItemArrBlock tabItemArrBlock;
@property(copy,nonatomic) SelectedItemClickBlock selectedItemClickBlock;
@property(copy,nonatomic) DefaultSelectedItemBlock defaultSelectedItemBlock;
@property (nonatomic,assign) NSInteger titlesBarStyles;
@property (nonatomic,strong) UIColor *titlesViewBackColor;
@property (nonatomic,strong)  UIImage*backgroudImage;
@property (nonatomic,assign) NSInteger defaultShowItemCount;
@property (nonatomic,assign) NSInteger selectedSegmentIndex;
@property (nonatomic,assign) NSInteger defaultSelectedIndex;
@property (nonatomic,strong) UIColor *itemBackColor;
@property (nonatomic,strong) UIColor *itemBackColorSelected;
@property (nonatomic,strong) UIImage *itemImageNormal;
@property (nonatomic,strong) UIImage *itemImageSelected;
@property (nonatomic,strong) NSArray *itemImageNormalArray;
@property (nonatomic,strong) NSArray *itemImageSelectedArray;
@property (nonatomic,strong) UIImage *itemBackNormalImage;
@property (nonatomic,strong) UIImage *itemBackSelectedImage;
@property (nonatomic,strong) NSArray *itemNormalBackImageArray;
@property (nonatomic,strong) NSArray *itemSelectedBackImageArray;
@property (nonatomic,strong) NSArray *itemTitleNormalColorArray;
@property (nonatomic,strong) NSArray *itemTitleSelectedColorArray;
@property (nonatomic,strong) UIColor *itemTextNormalColor;
@property (nonatomic,strong) UIColor *itemTextSelectedColor;
@property (nonatomic,assign) CGFloat itemTextFontSize;
@property (nonatomic,assign) CGFloat itemTextBoldFontSizeSelected;
@property (nonatomic,assign) CGSize itemImageSize;
@property(nonatomic,assign) BOOL isItemTitleTextHidden;
@property (nonatomic,assign) BOOL isFontGradient;
@property(nonatomic)   UIEdgeInsets itemTextsEdgeInsets;
@property(nonatomic)   UIEdgeInsets itemImagesEdgeInsets;
@property (nonatomic,assign) NSInteger imageEffectStyles;
-(void)tabItemTitlezoomBigEnabled:(BOOL)zoomBigEnabled tabItemTitleMaxfont:(CGFloat)tabItemTitleMaxfont;
-(void)tabItemSizeToFitIsEnabled:(BOOL)sizeToFitIsEnabled itemHeightToFitIsEnabled:(BOOL)heightToFitIsEnabled itemWidthToFitIsEnabled:(BOOL)widthToFitIsEnabled;
@property (nonatomic,assign) CGRect indicatorFrame;
@property (nonatomic,strong) UIColor *indicatorColor;
@property (nonatomic,strong) UIImage *indicatorImage;
@property (nonatomic,assign) BOOL indicatorHidden;
@property (nonatomic,assign) BOOL isIndicatorFollow;
@property (nonatomic,assign) NSInteger indicatorStyles;
@property(nonatomic,assign) BOOL isIndicatorsAnimals;
@property (nonatomic,assign) BOOL isIndicatorColorEqualTextColor;
@property (nonatomic,assign) MJCItemEdgeInsets itemEdgeinsets;
@property (nonatomic,assign) BOOL  scaleLayoutEnabled;
@property (nonatomic,assign) CGSize tabItemExcessSize;
@end
