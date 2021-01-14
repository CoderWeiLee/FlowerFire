//
//  BaseCollectionViewController.h
//  FilmCrowdfunding
//
//  Created by 王涛 on 2019/11/13.
//  Copyright © 2019 Celery. All rights reserved.
//

#import "BaseViewController.h"
#import "TableViewFreshProtocol.h" 
NS_ASSUME_NONNULL_BEGIN

@interface BaseCollectionViewController : BaseViewController<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,TableViewFreshProtocol>

@property (nonatomic, strong)UICollectionViewFlowLayout *collectionViewLayout;
@property (nonatomic, strong)UICollectionView           *collectionView;
@property (nonatomic, assign)NSInteger                   pageIndex,allPages;
@property (nonatomic, assign)BOOL                        isRefresh;

-(void)setEmptyViewContentViewY:(CGFloat)offset;
-(void)addEmptyView:(UICollectionView *)collectionView;
@end

NS_ASSUME_NONNULL_END
