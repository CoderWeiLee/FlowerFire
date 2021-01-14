//
//  OrderDetialsViewController.h
//  531Mall
//
//  Created by 王涛 on 2020/6/5.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableStyleGroupViewController.h" 
#import "BaseUIView.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderDetialsViewController : BaseTableStyleGroupViewController

-(instancetype)initWithOrderID:(NSString *)orderID;


@end

@interface OrderDetialsHeaderView : BaseUIView
 
@property(nonatomic, strong)UILabel *title;
@property(nonatomic, strong)UIView  *line;
@end


NS_ASSUME_NONNULL_END
