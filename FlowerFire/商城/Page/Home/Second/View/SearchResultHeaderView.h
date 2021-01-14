//
//  SearchResultHeaderView.h
//  531Mall
//
//  Created by 王涛 on 2020/5/19.
//  Copyright © 2020 Celery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol SearchResultHeaderViewDelegate <NSObject>

-(void)searchresultButtonClick:(UIButton *)button;

@end

@interface SearchResultHeaderView : UICollectionReusableView<InitViewProtocol>

@property(nonatomic, weak)id<SearchResultHeaderViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
