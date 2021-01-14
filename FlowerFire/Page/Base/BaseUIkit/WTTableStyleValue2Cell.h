//
//  WTTableStyleValue2Cell.h
//  FilmCrowdfunding
//
//  Created by mac on 2019/11/18.
//  Copyright © 2019 Celery. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InitViewProtocol.h"

NS_ASSUME_NONNULL_BEGIN
 
@interface WTTableStyleValue2Cell : UITableViewCell<InitViewProtocol>
 
@property(nonatomic, strong)WTLabel *topLabel,*bottomLabel;
@property(nonatomic, strong)UIView  *line;
@property(nonatomic, assign)BOOL     isHiddenSplitLine; 
  
@end

NS_ASSUME_NONNULL_END
