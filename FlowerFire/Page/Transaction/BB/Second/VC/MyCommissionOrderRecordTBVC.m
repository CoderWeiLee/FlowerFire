//
//  MyCommissionOrderRecordTBVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/11.
//  Copyright © 2019 王涛. All rights reserved.
//  我的委托单进入的订单页面

#import "MyCommissionOrderRecordTBVC.h"

@interface MyCommissionOrderRecordTBVC ()

@end

@implementation MyCommissionOrderRecordTBVC

- (void)viewDidLoad {
    [super viewDidLoad];
     
}

#pragma mark - 覆盖父类
//获取我发布的委托单对应订单列表
-(void)initData{
    NSDictionary *netDic = @{@"otc_id":self.otcOrderId,
                             @"order_status":self.paramsStatus,
                             @"page":[NSString stringWithFormat:@"%ld",(long)self.pageIndex],
                             @"page_size":@""
                             };
    [self.afnetWork jsonPostDict:@"/api/otc/myOtcOrderList" JsonDict:netDic Tag:@"1"];
}

-(void)setUpView{
    self.gk_navigationItem.title = LocalizationKey(@"FiatOrderTip50");
    
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.tableView];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
  
}
@end
