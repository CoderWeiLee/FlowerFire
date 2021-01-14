//
//  MallCategoryDetailController.h
//  MallCategory
//
//  Created by mengxiang on 2019/11/21.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MallCategoryDetailController : BaseViewController
@property (nonatomic, strong)UICollectionView * collectionView;
@property (nonatomic, strong)NSMutableArray   * sectionHeaderArray;
 
@property (nonatomic, strong)UIViewController *parentVC;

@end

NS_ASSUME_NONNULL_END


NS_ASSUME_NONNULL_BEGIN

@interface MallCategoryMenuDetailCollectionHeader : UICollectionReusableView

@property (nonatomic, strong)UILabel *     specificationName;

@end

NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN

@interface MallCategoryMenuDetailCollectionCell : UICollectionViewCell
@property (nonatomic,strong) UIImageView * imageView;
@property (nonatomic,strong) UILabel * titleLabel;
@end

NS_ASSUME_NONNULL_END
