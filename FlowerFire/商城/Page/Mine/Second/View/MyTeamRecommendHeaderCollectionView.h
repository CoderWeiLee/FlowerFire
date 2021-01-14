//
//  MyTeamRecommendHeaderCollectionView.h
//  531Mall
//
//  Created by 王涛 on 2020/6/15.
//  Copyright © 2020 Celery. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^didSwitchLayerClick)(NSInteger layer);

NS_ASSUME_NONNULL_BEGIN

@interface MyTeamRecommendHeaderCollectionView : UIView

@property(nonatomic, strong)NSMutableArray      *recommendHeaderArray;
/// 切换层数点击
@property(nonatomic, copy)didSwitchLayerClick    didSwitchLayerClick;

@end

@interface RecommendHeaderCollectionCell : UICollectionViewCell

@property(nonatomic, strong)UIImageView    *arrow;
/// 层数
@property(nonatomic, strong)UILabel        *numberLayers;

@end

NS_ASSUME_NONNULL_END
