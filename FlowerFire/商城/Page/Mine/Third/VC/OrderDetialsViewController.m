//
//  OrderDetialsViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/6/5.
//  Copyright © 2020 Celery. All rights reserved.
//  订单详情

#import "OrderDetialsViewController.h"
#import "SubmitOrderCell.h"
#import "OrderDetailsCell.h"
#import "SubmitOrderSectionFooterView.h"
#import "OrderDetailsCell2.h"
#import "GradientButton.h"
#import "SubmitPayPopView.h"
#import "LSTPopView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"
#import "ShopDetailsViewController.h"

@interface OrderDetialsViewController ()

@property(nonatomic, strong)NSString                 *orderID;

@property(nonatomic, strong)NSDictionary             *infoDictionary;
@property(nonatomic, strong)NSMutableArray           *sectionTwoArray,*sectionThreeArray;
@property(nonatomic, strong)GradientButton                  *payButton;
@property(nonatomic, strong)SubmitOrderSectionFooterView    *sectionFooterView;

/// 支付方式字典
@property(nonatomic, strong)NSDictionary *paymentDictionary;
@end

@implementation OrderDetialsViewController

- (instancetype)initWithOrderID:(NSString *)orderID{
    self = [super init];
    if(self){
        self.orderID = orderID;
      
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationItem.title = @"订单详情";
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
}

- (void)createUI{
    self.view.backgroundColor = rgba(250, 250, 250, 1);
    self.tableView.backgroundColor=  self.view.backgroundColor;
       
    [self setOnlyReFresh];
}
  
/// 支付点击
-(void)payClick{
    NSLog(@"%@",self.paymentDictionary.description);
      
    if(self.paymentDictionary &&
       self.paymentDictionary[@"order"][@"goods_money"]){
        UIAlertController *ua = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
          
        for (NSDictionary *dic in self.paymentDictionary[@"paymentList"]) {
            
            UIAlertAction *ua2 = [UIAlertAction actionWithTitle:dic[@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {//TODO:去微信
                if([dic[@"code"] isEqualToString:@"new_alipay"]){
                    return;
                    //支付宝支付发起
                    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:4];
                    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
                    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
                    md[@"order_id"] = self.orderID;
                    md[@"pay_radio"] = @{@"ali_app":self.paymentDictionary[@"order"][@"goods_money"]};
                    [self.afnetWork jsonMallPostDict:@"/api/order/orderPaySubmit" JsonDict:md Tag:@"4"];
                    
                }else if([dic[@"code"] isEqualToString:@"new_weixin"]){
                    return;
                    //微信支付发起
                    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:4];
                    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
                    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
                    md[@"order_id"] = self.orderID;
                    md[@"pay_radio"] = @{@"wx_app":self.paymentDictionary[@"order"][@"goods_money"]};
                    [self.afnetWork jsonMallPostDict:@"/api/order/orderPaySubmit" JsonDict:md Tag:@"5"];
                }
            }];
            [ua addAction:ua2];
        }
        
        for (NSDictionary *dic in self.paymentDictionary[@"wallet"]) {
            UIAlertAction *ua2 = [UIAlertAction actionWithTitle:dic[@"name"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                //本地支付
                SubmitPayPopView *submitPayView = [[SubmitPayPopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth - 37.5 * 2, 230+ 54)];
                [submitPayView.choosePayMethodButton setTitle:dic[@"name"] forState:UIControlStateNormal];
                [[UniversalViewMethod sharedInstance] priceAddqCouponStr:submitPayView.price priceStr:self.paymentDictionary[@"order"][@"actual_total_money"] CouponStr:self.paymentDictionary[@"order"][@"three_price"]];
                
                LSTPopView *popView = [LSTPopView initWithCustomView:submitPayView];
                [popView pop];
                @weakify(popView)
                submitPayView.closePopViewBlock = ^{
                    @strongify(popView)
                    [popView dismiss];
                };
                //密码输入完了，提交订单
                submitPayView.pwdInputView.textDidChangeblock = ^(NSString * _Nullable text, BOOL isFinished) {
                    if(isFinished){
                         @strongify(popView)
                         [popView dismiss];
                        //本地支付发起
                        
                        NSMutableDictionary *payDic = [NSMutableDictionary dictionaryWithCapacity:1];
                        double goodsMoney = [self.paymentDictionary[@"order"][@"actual_total_money"] doubleValue];
                      //  double threeMoney = [self.paymentDictionary[@"order"][@"three_price"] doubleValue];
                        payDic[dic[@"sheet"]] = @(goodsMoney);
                        
                        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:4];
                        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
                        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
                        md[@"order_id"] = self.orderID;
                        md[@"pay_radio"] = payDic;
                        
                        [self.afnetWork jsonMallPostDict:@"/api/order/orderPaySubmit" JsonDict:md Tag:@"3"];
                    }
                 };
            }];
            [ua addAction:ua2];
        }
        
         UIAlertAction *ua1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
         [ua addAction:ua1];
         [self presentViewController:ua animated:YES completion:nil];
         
    }else{
        [self searchPayMentList];
    }
   
}

#pragma mark - netData
- (void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"id"] = self.orderID;
    [self.afnetWork jsonMallPostDict:@"/api/order/orderDetail" JsonDict:md Tag:@"1" LoadingInView:self.view];
}
- (void)searchPayMentList {
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"order_id"] = self.orderID;
    [self.afnetWork jsonMallPostDict:@"/api/order/orderPayInfo" JsonDict:md Tag:@"2" LoadingInView:self.view];
}
 
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        [self.tableView.mj_header endRefreshing];
        self.infoDictionary = dict[@"data"][@"info"];
        
        //未付款并且待付款状态
        if([self.infoDictionary[@"is_pay"] integerValue] == 0 &&
           [self.infoDictionary[@"state"] integerValue] == 1){
            self.tableView.frame = CGRectMake(0, Height_NavBar , ScreenWidth, ScreenHeight - Height_NavBar - self.payButton.height - 10 - SafeAreaBottomHeight);
            self.payButton.hidden = NO;
            
            //未付款，查询一下付款信息
            [self searchPayMentList];
            
        }else{
            self.tableView.frame = CGRectMake(0, Height_NavBar , ScreenWidth, ScreenHeight - Height_NavBar);
            self.payButton.hidden = YES;
        }
        
        //section1数组
        for (NSDictionary *dic in self.infoDictionary[@"goods"]) {
            [self.dataArray addObject:dic];
        }
        self.sectionTwoArray = @[@{@"left":@"收货人:",@"right":self.infoDictionary[@"receipt_username"]},
                                @{@"left":@"手机号:",@"right":self.infoDictionary[@"receipt_mobile"]},
                                @{@"left":@"收货地址:",@"right":self.infoDictionary[@"receipt_address"]}].copy;
       
        //section2数组
        //物流信息数组
        NSArray *expressArray = self.infoDictionary[@"express"];
        NSString *express_name = @"暂无物流信息";
        NSString *express_no = @"暂无快递单号";
        if(expressArray.count>0){
            express_name = expressArray.firstObject[@"express_name"];
            express_no   = expressArray.firstObject[@"express_no"];
        }
        
        self.sectionThreeArray = @[@{@"left":@"订单编号:",@"right":self.infoDictionary[@"order_no"]},
                                   @{@"left":@"下单时间:",@"right":[HelpManager getTimeStr:self.infoDictionary[@"created_time"] dataFormat:@"yyyy-MM-dd HH:mm:ss"]},
                                   @{@"left":@"配送物流:",@"right":express_name},
                                   @{@"left":@"快递单号:",@"right":express_no}].copy;
         
        NSString *labelStr = NSStringFormat(@"商品 小计:¥%.f",[self.infoDictionary[@"actual_total_money"] doubleValue]);
        
        if([self.infoDictionary[@"three_money"] doubleValue] != 0){
            labelStr = NSStringFormat(@"%@ + %@券",labelStr,self.infoDictionary[@"three_money"]);
        }
        
        NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString:labelStr];
        [ma addAttributes:@{NSForegroundColorAttributeName:MainColor} range:[labelStr rangeOfString:NSStringFormat(@"¥%.f",[self.infoDictionary[@"actual_total_money"] doubleValue])]];
       
        if([self.infoDictionary[@"three_money"] doubleValue] != 0){ 
            [ma addAttributes:@{NSForegroundColorAttributeName:MainYellowColor} range:[labelStr rangeOfString:NSStringFormat(@"%@券",self.infoDictionary[@"three_money"])]];
            [ma addAttributes:@{NSForegroundColorAttributeName:KBlackColor} range:[labelStr rangeOfString:@"+"]];
        }
        
        self.sectionFooterView.buyNumLabel.attributedText = ma;
        
        [self.view addSubview:self.tableView];
        [self.tableView reloadData];
    }else if([type isEqualToString:@"2"]){ //付款信息
        self.paymentDictionary = dict[@"data"];
    }else if([type isEqualToString:@"3"]){ // 本地支付订单支付保存提交
        printAlert(dict[@"msg"], 1.f);
        [self closeVC];
    }else if([type isEqualToString:@"4"]){ // 支付宝支付订单支付保存提交
        NSLog(@"alipay:%@",dict[@"data"]);
    }else if([type isEqualToString:@"5"]){ // 微信订单支付保存提交
        NSLog(@"wechat:%@",dict[@"data"]);
    }
}

- (void)dataErrorHandle:(NSDictionary *)dict type:(NSString *)type{
    [self.tableView ly_endLoading];
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    
//    if([type isEqualToString:@"4"]){ // 支付宝支付订单支付保存提交
//      NSString *appScheme = AlipayScheme;
//      NSString *orderString = dict[@"data"];
//      // TODO: 调用支付结果开始支付
//      [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
//          NSLog(@"充值结果reslut = %@",resultDic);
//      }];
//
//
//    }else if([type isEqualToString:@"5"]){ // 微信订单支付保存提交
//
//        NSString *urlString   = @"https://wxpay.wxutil.com/pub_v2/app/app_pay.php?plat=ios";
//        //解析服务端返回json数据
//        NSError *error;
//        //加载一个NSURL对象
//        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
//        //将请求的url数据放到NSData对象中
//        NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//        if ( response != nil) {
//            NSMutableDictionary *dict = NULL;
//            //IOS5自带解析类NSJSONSerialization从response中解析出数据放到字典中
//            dict = [NSJSONSerialization JSONObjectWithData:response options:NSJSONReadingMutableLeaves error:&error];
//
//            NSLog(@"url:%@",urlString);
//            if(dict != nil){
//                NSMutableString *retcode = [dict objectForKey:@"retcode"];
//                if (retcode.intValue == 0){
//                    NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
//
//                    //调起微信支付
//                    PayReq* req             = [[PayReq alloc] init];
//                    req.partnerId           = [dict objectForKey:@"partnerid"];
//                    req.prepayId            = [dict objectForKey:@"prepayid"];
//                    req.nonceStr            = [dict objectForKey:@"noncestr"];
//                    req.timeStamp           = stamp.intValue;
//                    req.package             = [dict objectForKey:@"package"];
//                    req.sign                = [dict objectForKey:@"sign"];
//                    [WXApi  sendReq:req completion:^(BOOL success) {
//
//                    }];
//
//                    //日志输出
//                    NSLog(@"appid=%@\npartid=%@\nprepayid=%@\nnoncestr=%@\ntimestamp=%ld\npackage=%@\nsign=%@",[dict objectForKey:@"appid"],req.partnerId,req.prepayId,req.nonceStr,(long)req.timeStamp,req.package,req.sign );
//
//                }
//            }
//        }
        
//        PayReq *request = [[PayReq alloc] init];
//
//        request.partnerId = dict[@"partnerid"];
//        request.prepayId= dict[@"prepayid"];
//        request.package = @"Sign=WXPay";
//        request.nonceStr= dict[@"nonceStr"];
//        NSMutableString *ts = dict[@"timeStamp"];
//        request.timeStamp = ts.intValue;
//
//        request.sign= dict[@"sign"];
//        [WXApi sendReq:request completion:^(BOOL success) {
//
//
//        }];
//
//
//    }else{
//        if(![HelpManager isBlankString:dict[@"msg"]]  ){
            printAlert(dict[@"msg"], 1.5f);
//        }
//    }
     
}

 
#pragma mark - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        NSString *goodsID = NSStringFormat(@"%@",self.dataArray[indexPath.row][@"good_id"]);
        if(![HelpManager isBlankString:goodsID]){
            ShopDetailsViewController *svc = [[ShopDetailsViewController alloc] initWithGoodsID:goodsID];
            [self.navigationController pushViewController:svc animated:YES];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
         {
            static NSString *identifier = @"cell";
            [self.tableView registerClass:[OrderDetailsCell2 class] forCellReuseIdentifier:identifier];
            OrderDetailsCell2 *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            if(self.dataArray.count>0){
                 [cell setOrderInfoCellData:self.dataArray[indexPath.row]];
            }
            return cell;
         }
        case 1:
        {
            static NSString *identifier = @"cell1";
            [self.tableView registerClass:[OrderDetailsCell class] forCellReuseIdentifier:identifier];
            OrderDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            if(self.sectionTwoArray.count>0){
                cell.leftLabel.text = NSStringFormat(@"%@",self.sectionTwoArray[indexPath.row][@"left"]);
                [cell.leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo([HelpManager getLabelWidth:13 labelTxt:cell.leftLabel.text].width + 2);
                }];
                cell.rightLabel.text = NSStringFormat(@"%@",self.sectionTwoArray[indexPath.row][@"right"]);
              
            }
            return cell;
        }
        default:
        {
            static NSString *identifier = @"cell2";
            [self.tableView registerClass:[OrderDetailsCell class] forCellReuseIdentifier:identifier];
            OrderDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            if(self.sectionThreeArray.count>0){
                cell.leftLabel.text = NSStringFormat(@"%@",self.sectionThreeArray[indexPath.row][@"left"]);
                [cell.leftLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.width.mas_equalTo([HelpManager getLabelWidth:13 labelTxt:cell.leftLabel.text].width + 2);
                }];
                cell.rightLabel.text = NSStringFormat(@"%@",self.sectionThreeArray[indexPath.row][@"right"]);
            }
            return cell;
        } 
    }
      
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            return self.dataArray.count * 80;
        }
        case 1:
        {
            return  200;
        }
        default:
            return 200;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return self.dataArray.count;
        case 1:
            return self.sectionTwoArray.count;
        default:
            return self.sectionThreeArray.count;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
        {
            return [self createHeaderView:@"商品信息"];
        }
        case 1:
        {
            return [self createHeaderView:@"收货信息"];
        }
        default:
        {
            return [self createHeaderView:@"基本信息"];
        }
    }
 
}

-(UIView *)createHeaderView:(NSString *)title{
    CGFloat headerViewHeight = 50;
    OrderDetialsHeaderView *headerView = [[OrderDetialsHeaderView alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 0, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, headerViewHeight)];
    headerView.title.text = title;
    [[HelpManager sharedHelpManager] setPartRoundWithView:headerView corners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadius:10];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, headerViewHeight)];
    [view addSubview:headerView];
   
    return view;
}
 
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 45.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if(section == 0){
        return self.sectionFooterView;;
    }else{
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        return v;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 50;
        default:
            return 20;
    };
}

-(SubmitOrderSectionFooterView *)sectionFooterView{
    if(!_sectionFooterView){
        _sectionFooterView = [[SubmitOrderSectionFooterView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    }
    return _sectionFooterView;
}

-(GradientButton *)payButton{
    if(!_payButton){
        _payButton = [[GradientButton alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, ScreenHeight - SafeAreaBottomHeight - 50, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 50) titleStr:@"去付款"];
        _payButton.layer.cornerRadius = 5;
        [self.view addSubview:_payButton];
        [_payButton addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // 圆角角度
    CGFloat radius = 5;
    // 设置cell 背景色为透明
    cell.backgroundColor = UIColor.clearColor;
    // 创建两个layer
    CAShapeLayer *normalLayer = [[CAShapeLayer alloc] init];
    CAShapeLayer *selectLayer = [[CAShapeLayer alloc] init];
    // 获取显示区域大小
    CGRect bounds = CGRectInset(cell.bounds, 15, 0);
    // cell的backgroundView
    UIView *normalBgView = [[UIView alloc] initWithFrame:bounds];
    // 获取每组行数
    NSInteger rowNum = [tableView numberOfRowsInSection:indexPath.section];
    // 贝塞尔曲线
    UIBezierPath *bezierPath = nil;
    
    if (rowNum == 1) {
        // 一组只有一行（四个角全部为圆角）
        bezierPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)];
        normalBgView.clipsToBounds = NO;
    }else {
        if (indexPath.row == 0) {
            normalBgView.clipsToBounds = NO;
            normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(-5, 0, 0, 0));
            CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(5, 0, 0, 0));
            // 每组第一行（添加左上和右上的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(0.1, 0.1)];
           
            // 阴影
            normalLayer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
            normalLayer.shadowOffset = CGSizeMake(0,0);
            normalLayer.shadowOpacity = 0;
            normalLayer.shadowRadius = 0;
            normalLayer.cornerRadius = 0;
            normalLayer.shadowPath = bezierPath.CGPath;
            
            // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
            normalLayer.path = bezierPath.CGPath;
            selectLayer.path = bezierPath.CGPath;
            
            // 设置填充颜色
            normalLayer.fillColor = [UIColor whiteColor].CGColor;
            // 添加图层到nomarBgView中
            [normalBgView.layer insertSublayer:normalLayer atIndex:0];
            normalBgView.backgroundColor = UIColor.clearColor;
            cell.backgroundView = normalBgView;
           
            return;
        }else if (indexPath.row == rowNum - 1) {
            normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, -5, 0));
            CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(0, 0, 5, 0));
            // 每组最后一行（添加左下和右下的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerBottomLeft|UIRectCornerBottomRight) cornerRadii:CGSizeMake(radius, radius)];
            normalBgView.clipsToBounds = NO;
        }else {
            // 每组不是首位的行不设置圆角
            bezierPath = [UIBezierPath bezierPathWithRect:bounds];
            normalBgView.clipsToBounds = YES;
        }
    }
    
    // 阴影
    normalLayer.shadowColor = [UIColor colorWithRed:153/255.0 green:174/255.0 blue:223/255.0 alpha:0.2].CGColor;
    normalLayer.shadowOffset = CGSizeMake(0,5);
    normalLayer.shadowOpacity = 1;
    normalLayer.shadowRadius = 9;
    normalLayer.cornerRadius = 5;
    normalLayer.shadowPath = bezierPath.CGPath;
    
    // 把已经绘制好的贝塞尔曲线路径赋值给图层，然后图层根据path进行图像渲染render
    normalLayer.path = bezierPath.CGPath;
    selectLayer.path = bezierPath.CGPath;
    
    // 设置填充颜色
    normalLayer.fillColor = [UIColor whiteColor].CGColor;
    // 添加图层到nomarBgView中
    [normalBgView.layer insertSublayer:normalLayer atIndex:0];
    normalBgView.backgroundColor = UIColor.clearColor;
    cell.backgroundView = normalBgView;
     
}


@end

@implementation OrderDetialsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
        [self layoutSubview];
    }
    return self;
}

- (void)createUI{
    self.backgroundColor = KWhiteColor;
    
    self.title = [UILabel new];
    self.title.text = @"";
    self.title.font = tFont(12);
    self.title.textColor = rgba(102, 102, 102, 1);
    [self addSubview:self.title];
  
    self.line = [UIView new];
    self.line.backgroundColor = rgba(204, 204, 204, 1);
    [self addSubview:self.line];
    
}

- (void)layoutSubview{
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(self.mas_centerY).offset(-2.5);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.bottom.mas_equalTo(self.bottom).offset(-10);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 0.5));
    }];
}

@end
