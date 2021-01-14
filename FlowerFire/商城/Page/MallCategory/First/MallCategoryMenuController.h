//
//  MallCategoryMenuController.h
//  MallCategory
//
//  Created by mengxiang on 2019/11/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MallCategoryMenuController : UIViewController
@property(nonatomic, strong)UITableView * tableView;
/** 一级分类菜单*/
@property(nonatomic, strong)NSMutableArray * categoryTitlesArray;
@property (nonatomic, strong) NSMutableArray * categoryList;

@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface MallCategoryMenuCell : UITableViewCell

@property (nonatomic, strong) UILabel * categoryTitleLabel;

@end
NS_ASSUME_NONNULL_END
