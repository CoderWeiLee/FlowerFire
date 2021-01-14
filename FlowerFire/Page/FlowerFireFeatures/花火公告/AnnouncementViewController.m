//
//  AnnouncementViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/7/15.
//  Copyright © 2020 Celery. All rights reserved.
//  SD公告

#import "AnnouncementViewController.h"
#import "AnnouncementCell.h"
#import "AnnouncementModel.h"
#import "AnnouncementDetailsViewController.h"

@interface AnnouncementViewController ()

@end

@implementation AnnouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

#pragma mark - action

#pragma mark - initViewDelegate
- (void)theme_didChanged{
     self.gk_navLineHidden = NO;
}

- (void)createNavBar{
    self.gk_navigationItem.title = LocalizationKey(@"AnnouncementTip1");
     
}

- (void)createUI{
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
  //  [self setMjFresh];
    self.tableView.bounces = NO;
    [self.view addSubview:self.tableView];
     
}
//指定分类文章列表
- (void)initData{
//    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
//    md[@"cat_id"] = @"1";
//    md[@"page"] = [NSString stringWithFormat:@"%ld", (long)self.pageIndex];;
//    [self.afnetWork jsonPostDict:@"/api/article/getArticleCatList" JsonDict:md Tag:@"1"];
}
 
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        
        if(self.isRefresh){
            self.dataArray=[[NSMutableArray alloc]init];
        }
        
        for (NSDictionary *dic in dict[@"data"][@"list"]) {
            [self.dataArray addObject:[AnnouncementModel yy_modelWithDictionary:dic]];
        }
          
        self.allPages = [dict[@"data"][@"page"][@"page_count"] integerValue];
        [self.tableView reloadData];
    }else{
        printAlert(dict[@"msg"], 1.f);
        [self closeVC];
    }
    
}


#pragma mark - tableViewDegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if(self.dataArray.count>0){
//        AnnouncementModel *model = self.dataArray[indexPath.row];
//        AnnouncementDetailsViewController *avc = [AnnouncementDetailsViewController new];
//        avc.articleId = model.announcementID;
//        avc.articlesTitle = model.title;
//        [self.navigationController pushViewController:avc animated:YES];
//    }
    
    if(self.dataArray.count>0){
        NoteModel *model = self.dataArray[indexPath.row];
        AnnouncementDetailsViewController *avc = [AnnouncementDetailsViewController new];
        avc.articleId = model.NoteId;
        avc.articlesTitle = model.title;
        [self.navigationController pushViewController:avc animated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"AnnouncementCell";
    [self.tableView registerClass:[AnnouncementCell class] forCellReuseIdentifier:identifier];
    AnnouncementCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    if(self.dataArray.count>0){
        [cell setCellData:self.dataArray[indexPath.row]];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
 

@end
