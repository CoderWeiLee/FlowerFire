//
//  SearchResultViewController.h
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseCollectionViewController.h" 

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SearchResultViewType) {
    SearchResultViewTypeDefault = 0,
    SearchResultViewTypeSingle, //一行一个
    SearchResultViewTypeDouble, //一行两个
};

typedef NS_ENUM(NSUInteger, SearchResultWhereJump) {
    SearchResultWhereJumpDefault = 0, //从搜索调过来
    SearchResultWhereJumpMall, // 从商城调过来
};

@interface SearchResultViewController : BaseCollectionViewController

@property(nonatomic, strong)NSString *searchText;
/// 所属分类id，商城跳过来才有
@property(nonatomic, strong)NSString *cate_id;

@property(nonatomic, assign)SearchResultViewType  searchResultViewType;
@property(nonatomic, assign)SearchResultWhereJump searchResultWhereJump;
@end

NS_ASSUME_NONNULL_END
