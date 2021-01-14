//
//  FBChooseCoinView.h
//  FlowerFire
//
//  Created by 王涛 on 2020/5/8.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN
 
@interface FBChooseCoinView : BaseUIView

-(instancetype)initWithFrame:(CGRect)frame coinInfoArray:(NSArray *)coinInfoArray
           currentSelectCoinId:(NSString *)coinId chooseCoinIdBlock:(void (^)(NSString *coinid,NSString *coinName)) block;
 

@end

@interface FBChooseCoinCollectionViewCell : UICollectionViewCell

@property(nonatomic, strong)UILabel *coinName;
 
@end

NS_ASSUME_NONNULL_END
