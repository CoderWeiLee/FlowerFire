//
//  BaseTableStyleGroupViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/6/5.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "BaseTableStyleGroupViewController.h"

@interface BaseTableStyleGroupViewController ()

@end

@implementation BaseTableStyleGroupViewController
 
@synthesize tableView = _tableView;

-(UITableView *)tableView{
    if(!_tableView){
        _tableView = [[WTTableView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_TabBar - Height_NavBar) style:UITableViewStyleGrouped];
   //     _tableView.backgroundColor = self.view.backgroundColor;
         [_tableView setTheme_backgroundColor:THEME_MAIN_BACKGROUNDCOLOR];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        @weakify(self)
        _tableView.didEmptyViewBlock = ^{
            @strongify(self)
            [self.tableView.mj_header beginRefreshing];
//            [self.dataArray addObject:@"123"];
//            [self.tableView reloadData];
//            NSLog(@"刷新重试");
        };
        
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}

  

@end
