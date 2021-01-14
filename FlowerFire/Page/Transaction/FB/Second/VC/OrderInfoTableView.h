//
//  OrderInfoTableView.h
//  FireCoin
//
//  Created by 王涛 on 2019/5/30.
//  Copyright © 2019 王涛. All rights reserved.
//

#import "BaseUIView.h"
#import "OrderRecordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderInfoTableView : BaseUIView
 
@property(nonatomic, strong) OrderRecordModel       *model;


@property(nonatomic, strong) UILabel        *bottomLabel ;
@property(nonatomic, strong) UIButton       *leftBtn;
@property(nonatomic, strong) UIButton       *bottomView;
@property(nonatomic, strong) UIView         *bottomLine;
@property(nonatomic, strong) UITableView    *tableView;
@property (nonatomic, copy)  backRefreshBlock backRefreshBlock;

-(void)initData:(OrderRecordModel *)model;
-(void)showBottomView;

@end

NS_ASSUME_NONNULL_END
