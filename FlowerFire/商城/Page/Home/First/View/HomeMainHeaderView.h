//
//  HomeMainHeaderView.h
//  531Mall
//
//  Created by 王涛 on 2020/5/18.
//  Copyright © 2020 Celery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitViewProtocol.h"
#import "BulletinModel.h"
#import "HomeNavtionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HomeMainHeaderView : UICollectionReusableView<InitViewProtocol>

+(CGFloat)HomeMainHeaderHeight;

-(void)setBanner:(NSArray *)bannerArray;

@property(nonatomic, strong)NSMutableArray<BulletinModel *>  *dataSource;
@property(nonatomic, strong)NSMutableArray                   *articleDataArray; 
@property(nonatomic, strong)HomeNavtionView                  *homeNavtionView;
@end

@interface headerButtonModel : NSObject

@property(nonatomic, copy)NSString *buttonImageName;
@property(nonatomic, copy)NSString *buttonTitle;
@property(nonatomic, copy)NSString *viewControllerName;
@property(nonatomic, assign,getter=isWebView)Boolean webView;

@end

NS_ASSUME_NONNULL_END
