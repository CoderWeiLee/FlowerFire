//
//  PayMentViewController.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/29.
//  Copyright © 2019 王涛. All rights reserved.
//  付款页面

#import "PayMentViewController.h"
#import "SQCustomButton.h"
#import "SwitchPaymentMethodView.h"
#import "PayMentBottomView.h"
#import "OrderRecordModel.h"
#import "OrderInfoTableView.h"
#import "AppealDetailTBVC.h"
#import "AppealTBVC.h"

#define payMentBlueTextColor rgba(34, 131, 208, 1);
@interface PayMentViewController ()
{
    int                 isStopTimer; //变量为1，说明倒计时到点了，不然再倒计时了
    dispatch_source_t   timer; //倒计时时间
    UILabel            *orderStatusTip;  // q倒计时 订单取消
    SQCustomButton     *contactToBtn;//联系对方
    UILabel            *orderStatusTip1;  //待支付
    UILabel            *totalPrice;    //金额
    UILabel            *payPieceTip,*payPieceNum;  //交易单价
    UILabel            *payAmountTip,*payAmountNum;  //交易数量
    UIView             *grayView;
    OrderRecordModel   *_model1;
}
@property(nonatomic, strong) UILabel                 *orderStatus;  // 订单状态:-1=取消,0=待付款,1=已付款,待放币,2=交易成功
@property(nonatomic, strong) PayMentBottomView       *bottomView;
@property(nonatomic, strong) OrderInfoTableView      *orderInfoTableView;
@property(nonatomic, strong) SwitchPaymentMethodView *switchPaymentMethodView;
@property(nonatomic, strong) UIScrollView            *scrollView;
@end

@implementation PayMentViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //特殊导航栏颜色处理
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
    self.gk_navBackgroundColor = self.view.backgroundColor;
    [self initData];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if(timer){
       dispatch_source_cancel(timer);
    }
    
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self setUpView];
}

#pragma mark - action
//申诉详情
-(void)jumpAppealDetailClick{
    AppealDetailTBVC *avc= [AppealDetailTBVC new];
    avc.model = _model1;
    [self.navigationController pushViewController:avc animated:YES];
}
//申诉提交
-(void)jumpAppealSubmitClick{
    AppealTBVC *avc = [AppealTBVC new];
    avc.model = _model1;
    
    [self.navigationController pushViewController:avc animated:YES];
}

#pragma mark - netWork
-(void)initData{
    [self.afnetWork jsonPostDict:@"/api/otc/getOtcOrderInfo" JsonDict:@{@"type":self.buyOrSeal,@"otc_order_id":self.otcOrderId} Tag:@"1" LoadingInView:self.view];
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    [self.scrollView.mj_header endRefreshing];
 
    //移除每次add进的视图
    [self.switchPaymentMethodView removeFromSuperview];
    [self.orderInfoTableView removeFromSuperview];
    
    [self.orderInfoTableView.leftBtn removeFromSuperview];
    [self.orderInfoTableView.bottomLabel removeFromSuperview];
    [self.orderInfoTableView.bottomLine removeFromSuperview];
    
    
    
    OrderRecordModel *model = [OrderRecordModel yy_modelWithDictionary:dict[@"data"]];
 
    if(![model.order_status isEqualToString:@"-2"]){
        [self.orderInfoTableView.bottomView removeFromSuperview];
    }
    
    [self analysisNetData:model];
   
    
}
 
/**
 解析一波数据
 
 */
-(void)analysisNetData:(OrderRecordModel *)model{
    _model1 = model;
    isStopTimer = 0;
    if(timer){
        dispatch_source_cancel(timer);
        timer = nil;
    }
  
     self.switchPaymentMethodView.leftBtn.enabled = YES;
    //是订单发起者显示的
    if([model.is_from isEqualToString:@"1"]){
        //购买
        if([model.order_type isEqualToString:@"0"]){
            if([model.order_status isEqualToString:@"-1"]){
                self.orderStatus.text = LocalizationKey(@"FiatOrderTip1");
                self.orderStatus.textColor = KWhiteColor;
                orderStatusTip.text = LocalizationKey(@"FiatOrderTip2");
                orderStatusTip1.text = LocalizationKey(@"FiatOrderTip3");
                payAmountTip.hidden = YES;
                payAmountNum.hidden = YES;
                payPieceTip.hidden = YES;
                payPieceNum.hidden = YES;
                
                [self.scrollView addSubview:self.orderInfoTableView];
                [self.orderInfoTableView initData:model];
                [self.switchPaymentMethodView removeAllSubviews];
                [self.bottomView removeFromSuperview];
                [self.orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.orderInfoTableView.tableView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
            }else if ([model.order_status isEqualToString:@"0"]){
                self.orderStatus.text = LocalizationKey(@"FiatOrderTip4");
                
                NSString *time = [self dateTimeDifferenceWithStartTime:model.end_time endTime:[HelpManager getNowTimeTimestamp]] ;
                //开一波倒计时
                [self startTime:model.end_time endTime:[HelpManager getNowTimeTimestamp]];
                NSString *mStr = [NSString stringWithFormat:@"%@ %@ %@", LocalizationKey(@"FiatOrderTip5"),time, LocalizationKey(@"FiatOrderTip6")];
                NSMutableAttributedString *mtaStr = [[NSMutableAttributedString alloc] initWithString:mStr];
                [mtaStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:[[mtaStr string] rangeOfString:time]];
                orderStatusTip.attributedText = mtaStr;
                
                orderStatusTip1.text = LocalizationKey(@"FiatOrderTip7");;
              
                [self.scrollView addSubview:self.switchPaymentMethodView];
                
                self.switchPaymentMethodView.model = model;
                for (payMethodModel *model1 in model.pay_list) {
                    if([model1.type_id isEqualToString:@"1"]){
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeBank;
                    }else if ([model1.type_id isEqualToString:@"2"]){
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeAliPay;
                    }else{
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeWeChat;
                    }
                }
                
                [self.switchPaymentMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.switchPaymentMethodView.bottomView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                
                [self.scrollView addSubview:self.bottomView];
                [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.scrollView.mas_left).offset(OverAllLeft_OR_RightSpace);
                    make.top.mas_equalTo(self.switchPaymentMethodView.mas_bottom).offset(15);
                   // make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 170));
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
            }else if ([model.order_status isEqualToString:@"1"]){
                self.orderStatus.text = LocalizationKey(@"FiatOrderTip8");;
                
                NSString *time = [self dateTimeDifferenceWithStartTime:model.relase_end_time endTime:[HelpManager getNowTimeTimestamp]] ;
                //开一波倒计时
                [self startTime:model.relase_end_time endTime:[HelpManager getNowTimeTimestamp]];
                NSString *mStr = [NSString stringWithFormat:@"%@ %@ ", LocalizationKey(@"FiatOrderTip9"),time];
                NSMutableAttributedString *mtaStr = [[NSMutableAttributedString alloc] initWithString:mStr];
                [mtaStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:[[mtaStr string] rangeOfString:time]];
                orderStatusTip.attributedText = mtaStr;
                
                
               // orderStatusTip.text = @"等待卖家放币";
                orderStatusTip1.text = LocalizationKey(@"FiatOrderTip10");
               
                [self.scrollView addSubview:self.switchPaymentMethodView];
                
                self.switchPaymentMethodView.model = model;
                for (payMethodModel *model1 in model.pay_list) {
                    if([model1.type_id isEqualToString:@"1"]){
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeBank;
                    }else if ([model1.type_id isEqualToString:@"2"]){
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeAliPay;
                    }else{
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeWeChat;
                    }
                }
                
                [self.switchPaymentMethodView.leftBtn setBackgroundColor:qutesRedColor];
                [self.switchPaymentMethodView.leftBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
                [self.switchPaymentMethodView.leftBtn setTitle:LocalizationKey(@"FiatOrderTip11") forState:UIControlStateNormal];
                self.switchPaymentMethodView.rightBtn.enabled = NO;
                [self.switchPaymentMethodView.rightBtn setTitle:LocalizationKey(@"FiatOrderTip12") forState:UIControlStateNormal];
                
                [self.switchPaymentMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.switchPaymentMethodView.bottomView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                
                [self.scrollView addSubview:self.bottomView];
                [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.scrollView.mas_left).offset(OverAllLeft_OR_RightSpace);
                    make.top.mas_equalTo(self.switchPaymentMethodView.mas_bottom).offset(15);
                   make.width.mas_equalTo(ScreenWidth - 30);
                }];
                
            }else if ([model.order_status isEqualToString:@"2"]){
                self.orderStatus.text = LocalizationKey(@"FiatOrderTip13");
                orderStatusTip.text = LocalizationKey(@"FiatOrderTip14");
                orderStatusTip1.text = LocalizationKey(@"FiatOrderTip3");
                payAmountTip.hidden = YES;
                payAmountNum.hidden = YES;
                payPieceTip.hidden = YES;
                payPieceNum.hidden = YES;
              
                [self.scrollView addSubview:self.orderInfoTableView];
                [self.orderInfoTableView initData:model];
                [self.orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.orderInfoTableView.tableView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                self.bottomView.hidden = YES;
                
                for (UIView *view in self.orderInfoTableView.subviews) {
                    if(view == self.orderInfoTableView.bottomView){
                        [view removeFromSuperview];
                    }
                }
            }else if ([model.order_status isEqualToString:@"-2"]){
                //申诉中
                self.orderStatus.text = LocalizationKey(@"FiatOrderTip15");
                orderStatusTip.hidden = YES;
                orderStatusTip1.text = LocalizationKey(@"FiatOrderTip15");
              
                [self.scrollView addSubview:self.switchPaymentMethodView];
                
                self.switchPaymentMethodView.model = model;
                for (payMethodModel *model1 in model.pay_list) {
                    if([model1.type_id isEqualToString:@"1"]){
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeBank;
                    }else if ([model1.type_id isEqualToString:@"2"]){
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeAliPay;
                    }else{
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeWeChat;
                    }
                }
                self.switchPaymentMethodView.leftBtn.hidden = YES;
                self.switchPaymentMethodView.rightBtn.hidden = YES;
                
                UIButton *AppealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
               
                [AppealBtn setBackgroundColor:qutesRedColor];
                [self.switchPaymentMethodView addSubview:AppealBtn];
                [AppealBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.switchPaymentMethodView.leftBtn.mas_top);
                    make.bottom.mas_equalTo(self.switchPaymentMethodView.leftBtn.mas_bottom);
                    make.left.mas_equalTo(self.switchPaymentMethodView.leftBtn.mas_left);
                    make.right.mas_equalTo(self.switchPaymentMethodView.rightBtn.mas_right);
                }];
                //是否已经申诉，0 跳转申诉页面 ， 1 跳转申诉详情页
                if([model.is_appeal isEqualToString:@"0"]){
                     [AppealBtn setTitle:LocalizationKey(@"FiatOrderTip16") forState:UIControlStateNormal];
                     [AppealBtn addTarget:self action:@selector(jumpAppealSubmitClick) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [AppealBtn setTitle:LocalizationKey(@"FiatOrderTip17") forState:UIControlStateNormal];
                    [AppealBtn addTarget:self action:@selector(jumpAppealDetailClick) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                [self.switchPaymentMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.switchPaymentMethodView.bottomView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                
                [self.scrollView addSubview:self.bottomView];
                [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.scrollView.mas_left).offset(OverAllLeft_OR_RightSpace);
                    make.top.mas_equalTo(self.switchPaymentMethodView.mas_bottom).offset(15);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
            }
        }else{
            if([model.order_status isEqualToString:@"-1"]){
                self.orderStatus.text = LocalizationKey(@"FiatOrderTip1");
                orderStatusTip.text = LocalizationKey(@"FiatOrderTip2");
                self.orderStatus.textColor = KWhiteColor;
                orderStatusTip1.text = LocalizationKey(@"FiatOrderTip3");
                payAmountTip.hidden = YES;
                payAmountNum.hidden = YES;
                payPieceTip.hidden = YES;
                payPieceNum.hidden = YES;
                
                [self.scrollView addSubview:self.orderInfoTableView];
                [self.orderInfoTableView initData:model];
                [self.bottomView removeFromSuperview];
                [self.orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.orderInfoTableView.tableView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
            }else if ([model.order_status isEqualToString:@"0"]){
                self.orderStatus.text = LocalizationKey(@"FiatOrderTip4");
                self.orderStatus.textColor = rgba(235, 191, 146, 1);
                
                NSString *time = [self dateTimeDifferenceWithStartTime:model.end_time endTime:[HelpManager getNowTimeTimestamp]] ;
                //开一波倒计时
                [self startTime:model.end_time endTime:[HelpManager getNowTimeTimestamp]];
                NSString *mStr = [NSString stringWithFormat:@"%@ %@",LocalizationKey(@"FiatOrderTip21"),time];
                NSMutableAttributedString *mtaStr = [[NSMutableAttributedString alloc] initWithString:mStr];
                [mtaStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:[[mtaStr string] rangeOfString:time]];
                orderStatusTip.attributedText = mtaStr;
                
              //  orderStatusTip.text = @"买家未付款，等待买家付款";
                orderStatusTip1.text =  LocalizationKey(@"FiatOrderTip26");
              
                [self.scrollView addSubview:self.orderInfoTableView];
                [self.orderInfoTableView showBottomView];
                [self.orderInfoTableView initData:model];
                
                [self.orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.orderInfoTableView.bottomView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                
                [self.scrollView addSubview:self.bottomView];
                [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.scrollView.mas_left).offset(OverAllLeft_OR_RightSpace);
                    make.top.mas_equalTo(self.orderInfoTableView.mas_bottom).offset(15);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
            }else if ([model.order_status isEqualToString:@"1"]){
                self.orderStatus.text =  LocalizationKey(@"FiatOrderTip8");
                
                orderStatusTip.text = [NSString stringWithFormat:@"%@%@", LocalizationKey(@"FiatOrderTip18"),model.symbol];
                orderStatusTip1.text =  LocalizationKey(@"FiatOrderTip19");
               
                self.orderStatus.textColor = rgba(235, 191, 146, 1);
                [self.scrollView addSubview:self.orderInfoTableView];
                [self.orderInfoTableView showBottomView];
                [self.orderInfoTableView initData:model];
                
                [self.orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.orderInfoTableView.bottomView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                
                [self.scrollView addSubview:self.bottomView];
                [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.scrollView.mas_left).offset(OverAllLeft_OR_RightSpace);
                    make.top.mas_equalTo(self.orderInfoTableView.mas_bottom).offset(15);
                   make.width.mas_equalTo(ScreenWidth - 30);
                }];
                [self.orderInfoTableView.leftBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
                [self.orderInfoTableView.leftBtn setBackgroundColor:qutesRedColor];
                self.orderInfoTableView.leftBtn.enabled = YES;
                
            }else if ([model.order_status isEqualToString:@"2"]){
                self.orderStatus.text =  LocalizationKey(@"FiatOrderTip13");
                orderStatusTip.text =   LocalizationKey(@"FiatOrderTip14");
                orderStatusTip1.text =  LocalizationKey(@"FiatOrderTip3");
                payAmountTip.hidden = YES;
                payAmountNum.hidden = YES;
                payPieceTip.hidden = YES;
                payPieceNum.hidden = YES;
            
                [self.scrollView addSubview:self.orderInfoTableView];
                [self.orderInfoTableView initData:model];
                [self.orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.orderInfoTableView.tableView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                
                self.bottomView.hidden = YES;
                for (UIView *view in self.orderInfoTableView.subviews) {
                    if(view == self.orderInfoTableView.bottomView){
                        [view removeFromSuperview];
                    }
                }
            }else if ([model.order_status isEqualToString:@"-2"]){
                //申诉中
                self.orderStatus.text =  LocalizationKey(@"FiatOrderTip15");
                orderStatusTip.hidden = YES;
                orderStatusTip1.text =  LocalizationKey(@"FiatOrderTip15");
               
                [self.scrollView addSubview:self.orderInfoTableView];
                [self.orderInfoTableView showBottomView];
                [self.orderInfoTableView initData:model];
                
                [self.orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.orderInfoTableView.bottomView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                
                [self.orderInfoTableView.leftBtn setHidden:YES];
                [self.orderInfoTableView.bottomView setHidden:YES];
                
                UIButton *AppealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                
                [AppealBtn setBackgroundColor:qutesRedColor];
                [self.orderInfoTableView addSubview:AppealBtn];
                [AppealBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.orderInfoTableView.bottomView.mas_bottom).offset(0);
                    make.left.mas_equalTo(self.orderInfoTableView.mas_left).offset(20);
                    make.size.mas_equalTo(CGSizeMake((ScreenWidth - 60), 50));
                }];
                //是否已经申诉，0 跳转申诉页面 ， 1 跳转申诉详情页
                if([model.is_appeal isEqualToString:@"0"]){
                    [AppealBtn setTitle: LocalizationKey(@"FiatOrderTip16") forState:UIControlStateNormal];
                    [AppealBtn addTarget:self action:@selector(jumpAppealSubmitClick) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [AppealBtn setTitle: LocalizationKey(@"FiatOrderTip17") forState:UIControlStateNormal];
                    [AppealBtn addTarget:self action:@selector(jumpAppealDetailClick) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                
                [self.scrollView addSubview:self.bottomView];
                [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.scrollView.mas_left).offset(OverAllLeft_OR_RightSpace);
                    make.top.mas_equalTo(self.orderInfoTableView.mas_bottom).offset(15);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
            }
        }
    }else{
        //不是订单发起者，即为委托人显示的
        if([model.order_type isEqualToString:@"1"]){
            if([model.order_status isEqualToString:@"-1"]){
                self.orderStatus.text =  LocalizationKey(@"FiatOrderTip1");
                self.orderStatus.textColor = KWhiteColor;
                orderStatusTip.text =  LocalizationKey(@"FiatOrderTip2");
                orderStatusTip1.text =  LocalizationKey(@"FiatOrderTip3");
                payAmountTip.hidden = YES;
                payAmountNum.hidden = YES;
                payPieceTip.hidden = YES;
                payPieceNum.hidden = YES;
                
                [self.scrollView addSubview:self.orderInfoTableView];
                [self.orderInfoTableView initData:model];
                [self.switchPaymentMethodView removeAllSubviews];
                 [self.bottomView removeFromSuperview];
                [self.orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.orderInfoTableView.tableView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
            }else if ([model.order_status isEqualToString:@"0"]){
                self.orderStatus.text =  LocalizationKey(@"FiatOrderTip4");
                
                NSString *time = [self dateTimeDifferenceWithStartTime:model.end_time endTime:[HelpManager getNowTimeTimestamp]] ;
                //开一波倒计时
                [self startTime:model.end_time endTime:[HelpManager getNowTimeTimestamp]];
                NSString *mStr = [NSString stringWithFormat:@"%@ %@ %@", LocalizationKey(@"FiatOrderTip5"),time, LocalizationKey(@"FiatOrderTip6")];
                NSMutableAttributedString *mtaStr = [[NSMutableAttributedString alloc] initWithString:mStr];
                [mtaStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:[[mtaStr string] rangeOfString:time]];
                orderStatusTip.attributedText = mtaStr;
                
                orderStatusTip1.text =  LocalizationKey(@"FiatOrderTip7");
               
                [self.scrollView addSubview:self.switchPaymentMethodView];
                
                self.switchPaymentMethodView.model = model;
                for (payMethodModel *model1 in model.pay_list) {
                    if([model1.type_id isEqualToString:@"1"]){
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeBank;
                    }else if ([model1.type_id isEqualToString:@"2"]){
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeAliPay;
                    }else{
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeWeChat;
                    }
                }
                
                [self.switchPaymentMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.switchPaymentMethodView.bottomView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                
                [self.scrollView addSubview:self.bottomView];
                [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.scrollView.mas_left).offset(OverAllLeft_OR_RightSpace);
                    make.top.mas_equalTo(self.switchPaymentMethodView.mas_bottom).offset(15);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
            }else if ([model.order_status isEqualToString:@"1"]){
                self.orderStatus.text = LocalizationKey(@"OrderTip2");
                
                NSString *time = [self dateTimeDifferenceWithStartTime:model.relase_end_time endTime:[HelpManager getNowTimeTimestamp]] ;
                //开一波倒计时
                [self startTime:model.relase_end_time endTime:[HelpManager getNowTimeTimestamp]];
                NSString *mStr = [NSString stringWithFormat:@"%@ %@ ", LocalizationKey(@"FiatOrderTip9"),time];
                NSMutableAttributedString *mtaStr = [[NSMutableAttributedString alloc] initWithString:mStr];
                [mtaStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:[[mtaStr string] rangeOfString:time]];
                orderStatusTip.attributedText = mtaStr;
                
              //  orderStatusTip.text = @"等待卖家放币";
                orderStatusTip1.text =  LocalizationKey(@"FiatOrderTip10");
                
                [self.scrollView addSubview:self.switchPaymentMethodView];
                
                self.switchPaymentMethodView.model = model;
                for (payMethodModel *model1 in model.pay_list) {
                    if([model1.type_id isEqualToString:@"1"]){
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeBank;
                    }else if ([model1.type_id isEqualToString:@"2"]){
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeAliPay;
                    }else{
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeWeChat;
                    }
                }
                
                [self.switchPaymentMethodView.leftBtn setBackgroundColor:qutesRedColor];
                [self.switchPaymentMethodView.leftBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
                [self.switchPaymentMethodView.leftBtn setTitle: LocalizationKey(@"FiatOrderTip11") forState:UIControlStateNormal];
                self.switchPaymentMethodView.rightBtn.enabled = NO;
                [self.switchPaymentMethodView.rightBtn setTitle: LocalizationKey(@"FiatOrderTip12") forState:UIControlStateNormal];
                
                [self.switchPaymentMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.switchPaymentMethodView.bottomView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                
                [self.scrollView addSubview:self.bottomView];
                [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.scrollView.mas_left).offset(OverAllLeft_OR_RightSpace);
                    make.top.mas_equalTo(self.switchPaymentMethodView.mas_bottom).offset(15);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                
            }else if ([model.order_status isEqualToString:@"2"]){
                self.orderStatus.text =  LocalizationKey(@"FiatOrderTip13");
                orderStatusTip.text =  LocalizationKey(@"FiatOrderTip14");
                orderStatusTip1.text =  LocalizationKey(@"FiatOrderTip3");
                payAmountTip.hidden = YES;
                payAmountNum.hidden = YES;
                payPieceTip.hidden = YES;
                payPieceNum.hidden = YES;
                [self.scrollView addSubview:self.orderInfoTableView];
                [self.orderInfoTableView initData:model];
              
                [self.orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.orderInfoTableView.tableView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                self.bottomView.hidden = YES;
                for (UIView *view in self.orderInfoTableView.subviews) {
                    if(view == self.orderInfoTableView.bottomView){
                        [view removeFromSuperview];
                    }
                }
            }else if ([model.order_status isEqualToString:@"-2"]){
                //申诉中
                self.orderStatus.text =  LocalizationKey(@"FiatOrderTip15");
                orderStatusTip.hidden = YES;
                orderStatusTip1.text =  LocalizationKey(@"FiatOrderTip15");
               
                [self.scrollView addSubview:self.switchPaymentMethodView];
                
                self.switchPaymentMethodView.model = model;
                for (payMethodModel *model1 in model.pay_list) {
                    if([model1.type_id isEqualToString:@"1"]){
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeBank;
                    }else if ([model1.type_id isEqualToString:@"2"]){
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeAliPay;
                    }else{
                        self.switchPaymentMethodView.switchPaymentMethodType = SwitchPaymentMethodTypeWeChat;
                    }
                }
                self.switchPaymentMethodView.leftBtn.hidden = YES;
                self.switchPaymentMethodView.rightBtn.hidden = YES;
                
                UIButton *AppealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [AppealBtn setBackgroundColor:qutesRedColor];
                [self.switchPaymentMethodView addSubview:AppealBtn];
                [AppealBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(self.switchPaymentMethodView.leftBtn.mas_top);
                    make.bottom.mas_equalTo(self.switchPaymentMethodView.leftBtn.mas_bottom);
                    make.left.mas_equalTo(self.switchPaymentMethodView.leftBtn.mas_left);
                    make.right.mas_equalTo(self.switchPaymentMethodView.rightBtn.mas_right);
                }];
                
                //是否已经申诉，0 跳转申诉页面 ， 1 跳转申诉详情页
                if([model.is_appeal isEqualToString:@"0"]){
                    [AppealBtn setTitle: LocalizationKey(@"FiatOrderTip16") forState:UIControlStateNormal];
                    [AppealBtn addTarget:self action:@selector(jumpAppealSubmitClick) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [AppealBtn setTitle: LocalizationKey(@"FiatOrderTip17") forState:UIControlStateNormal];
                    [AppealBtn addTarget:self action:@selector(jumpAppealDetailClick) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                
                [self.switchPaymentMethodView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.switchPaymentMethodView.bottomView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                
                [self.scrollView addSubview:self.bottomView];
                [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.scrollView.mas_left).offset(OverAllLeft_OR_RightSpace);
                    make.top.mas_equalTo(self.switchPaymentMethodView.mas_bottom).offset(15);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
            }
        }else{
            if([model.order_status isEqualToString:@"-1"]){
                self.orderStatus.text =  LocalizationKey(@"FiatOrderTip1");
                orderStatusTip.text =  LocalizationKey(@"FiatOrderTip2");
                self.orderStatus.textColor = KWhiteColor;
                orderStatusTip1.text =  LocalizationKey(@"FiatOrderTip3");
                payAmountTip.hidden = YES;
                payAmountNum.hidden = YES;
                payPieceTip.hidden = YES;
                payPieceNum.hidden = YES;
                
                [self.scrollView addSubview:self.orderInfoTableView];
                [self.orderInfoTableView initData:model];
                [self.bottomView removeFromSuperview];
                [self.orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.orderInfoTableView.tableView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
            }else if ([model.order_status isEqualToString:@"0"]){
                self.orderStatus.text =  LocalizationKey(@"FiatOrderTip27");
                self.orderStatus.textColor = rgba(235, 191, 146, 1);
                
                NSString *time = [self dateTimeDifferenceWithStartTime:model.end_time endTime:[HelpManager getNowTimeTimestamp]] ;
                //开一波倒计时
                [self startTime:model.end_time endTime:[HelpManager getNowTimeTimestamp]];
                NSString *mStr = [NSString stringWithFormat:@"%@ %@",LocalizationKey(@"FiatOrderTip21"),time];
                NSMutableAttributedString *mtaStr = [[NSMutableAttributedString alloc] initWithString:mStr];
                [mtaStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:[[mtaStr string] rangeOfString:time]];
                orderStatusTip.attributedText = mtaStr;
                
              //  orderStatusTip.text = @"买家未付款，等待买家付款";
                orderStatusTip1.text = LocalizationKey(@"FiatOrderTip26");
               
                [self.scrollView addSubview:self.orderInfoTableView];
                [self.orderInfoTableView showBottomView];
                [self.orderInfoTableView initData:model];
                
                [self.orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.orderInfoTableView.bottomView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                
                [self.scrollView addSubview:self.bottomView];
                [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.scrollView.mas_left).offset(OverAllLeft_OR_RightSpace);
                    make.top.mas_equalTo(self.orderInfoTableView.mas_bottom).offset(15);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
            }else if ([model.order_status isEqualToString:@"1"]){
                self.orderStatus.text = LocalizationKey(@"FiatOrderTip8");
               
                self.orderInfoTableView.leftBtn.enabled = YES;
                orderStatusTip.text = [NSString stringWithFormat:@"%@%@",LocalizationKey(@"FiatOrderTip18"),model.symbol];
                orderStatusTip1.text = LocalizationKey(@"FiatOrderTip19");
                self.orderStatus.textColor = rgba(235, 191, 146, 1);
                [self.scrollView addSubview:self.orderInfoTableView];
                [self.orderInfoTableView showBottomView];
                [self.orderInfoTableView initData:model];
                
                [self.orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.orderInfoTableView.bottomView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                
                [self.scrollView addSubview:self.bottomView];
                [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.scrollView.mas_left).offset(OverAllLeft_OR_RightSpace);
                    make.top.mas_equalTo(self.orderInfoTableView.mas_bottom).offset(15);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                [self.orderInfoTableView.leftBtn setTitleColor:KWhiteColor forState:UIControlStateNormal];
                [self.orderInfoTableView.leftBtn setBackgroundColor:qutesRedColor];
                self.orderInfoTableView.leftBtn.enabled = YES;
                
            }else if ([model.order_status isEqualToString:@"2"]){
                self.orderStatus.text = LocalizationKey(@"FiatOrderTip13");
                orderStatusTip.text = LocalizationKey(@"FiatOrderTip14");
                orderStatusTip1.text = LocalizationKey(@"FiatOrderTip3");
                payAmountTip.hidden = YES;
                payAmountNum.hidden = YES;
                payPieceTip.hidden = YES;
                payPieceNum.hidden = YES;
               
                [self.scrollView addSubview:self.orderInfoTableView];
                [self.orderInfoTableView initData:model];
                [self.orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.orderInfoTableView.tableView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                self.bottomView.hidden = YES;
                for (UIView *view in self.orderInfoTableView.subviews) {
                    if(view == self.orderInfoTableView.bottomView){
                        [view removeFromSuperview];
                    }
                }
            }else if ([model.order_status isEqualToString:@"-2"]){
                //申诉中
                self.orderStatus.text = LocalizationKey(@"FiatOrderTip15");
                orderStatusTip.hidden = YES;
                orderStatusTip1.text = LocalizationKey(@"FiatOrderTip15");
                [self.scrollView addSubview:self.orderInfoTableView];
                [self.orderInfoTableView showBottomView];
                [self.orderInfoTableView initData:model];
                
                [self.orderInfoTableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(grayView.mas_bottom);
                    make.left.mas_equalTo(grayView.mas_left);
                    make.bottom.mas_equalTo(self.orderInfoTableView.bottomView.mas_bottom).offset(20);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
                
                UIButton *AppealBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [AppealBtn setBackgroundColor:qutesRedColor];
                [self.orderInfoTableView addSubview:AppealBtn];
                [AppealBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.mas_equalTo(self.orderInfoTableView.bottomView.mas_bottom).offset(0);
                    make.left.mas_equalTo(self.orderInfoTableView.mas_left).offset(OverAllLeft_OR_RightSpace);
                    make.size.mas_equalTo(CGSizeMake((ScreenWidth - 60), 50));
                }];
                
                [self.orderInfoTableView.leftBtn setHidden:YES];
                [self.orderInfoTableView.bottomView setHidden:YES];
                //是否已经申诉，0 跳转申诉页面 ， 1 跳转申诉详情页
                if([model.is_appeal isEqualToString:@"0"]){
                    [AppealBtn setTitle:LocalizationKey(@"FiatOrderTip16") forState:UIControlStateNormal];
                    [AppealBtn addTarget:self action:@selector(jumpAppealSubmitClick) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [AppealBtn setTitle:LocalizationKey(@"FiatOrderTip17") forState:UIControlStateNormal];
                    [AppealBtn addTarget:self action:@selector(jumpAppealDetailClick) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                
                [self.scrollView addSubview:self.bottomView];
                [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(self.scrollView.mas_left).offset(OverAllLeft_OR_RightSpace);
                    make.top.mas_equalTo(self.orderInfoTableView.mas_bottom).offset(15);
                    make.width.mas_equalTo(ScreenWidth - 30);
                }];
            }
        }
    }
    
    totalPrice.text = [NSString stringWithFormat:@"¥ %@\n $ %.2f",model.total_price,[model.total_price doubleValue]/7];
    payPieceNum.text = [NSString stringWithFormat:@"¥ %@\n $ %.2f",model.price,[model.price doubleValue]/7];
    payAmountNum.text = [NSString stringWithFormat:@"%@ %@",model.amount,model.symbol];
    
  
    //设置圆点
    UIView *circle = [UIView new];
    circle.backgroundColor = self.view.backgroundColor;
    circle.layer.cornerRadius = 7.5;
    circle.layer.masksToBounds = YES;
    [self.scrollView addSubview:circle];
    [circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(grayView.mas_bottom).offset(-7.5);
        make.centerX.mas_equalTo(grayView.mas_left);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    circle = [UIView new];
    circle.backgroundColor = self.view.backgroundColor;
    circle.layer.cornerRadius = 7.5;
    circle.layer.masksToBounds = YES;
    [self.scrollView addSubview:circle];
    [circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(grayView.mas_bottom).offset(-7.5);
        make.centerX.mas_equalTo(grayView.mas_right);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    //设置i 标题
    [self setOrderStatusText:self.orderStatus];
    
    //判断 是否有父视图，不然约束会崩溃
    if(self.bottomView.superview){
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.bottomView.mas_bottom).offset(30);
        }];
    }else{
        self.scrollView.contentSize = CGSizeMake(ScreenWidth, 600);
    }
}

#pragma mark - util
-(void)startTime:(NSString *)startTime endTime:(NSString *)endTime{
    // 倒计时时间
    __block NSInteger second = [self getDateDifferenceWithNowDateStr:startTime deadlineStr:endTime];
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    if(second == 0){
        dispatch_async(dispatch_get_main_queue(), ^{
           NSString *mStr = LocalizationKey(@"FiatOrderTip22");
           NSMutableAttributedString *mtaStr = [[NSMutableAttributedString alloc] initWithString:mStr];
           [mtaStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:[[mtaStr string] rangeOfString:mStr]];
           orderStatusTip.attributedText = mtaStr;
           [self.switchPaymentMethodView.rightBtn setTitle:LocalizationKey(@"FiatOrderTip22") forState:UIControlStateNormal];
        });
        return;
    }
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second > 0) {
                NSInteger days = (int)(second/(3600*24));
                NSInteger hours = (int)((second-days*24*3600)/3600);
                NSInteger minute = (int)(second-days*24*3600-hours*3600)/60;
                NSInteger second1 = second - days*24*3600 - hours*3600 - minute*60;
                NSString *time = [NSString stringWithFormat:@"%02ld:%02ld", (long)minute,(long)second1];
                
                if([_model1.is_from isEqualToString:@"1"]){ //是订单发起者显示的
                    if([_model1.order_type isEqualToString:@"1"]){
                        if([_model1.order_status isEqualToString:@"0"]){
                            NSString *mStr = [NSString stringWithFormat:@"%@ %@",LocalizationKey(@"FiatOrderTip21"),time];
                            NSMutableAttributedString *mtaStr = [[NSMutableAttributedString alloc] initWithString:mStr];
                            [mtaStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:[[mtaStr string] rangeOfString:time]];
                            orderStatusTip.attributedText = mtaStr;
                        }else if ([_model1.order_status isEqualToString:@"1"]){
                            NSString *mStr = [NSString stringWithFormat:@"%@ %@",LocalizationKey(@"FiatOrderTip20"),time];
                            NSMutableAttributedString *mtaStr = [[NSMutableAttributedString alloc] initWithString:mStr];
                            [mtaStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:[[mtaStr string] rangeOfString:time]];
                            orderStatusTip.attributedText = mtaStr;
                        }
                      
                    }else{
                        if([_model1.order_status isEqualToString:@"0"]){
                            NSString *mStr = [NSString stringWithFormat:@"%@ %@ %@",LocalizationKey(@"FiatOrderTip5"),time,LocalizationKey(@"FiatOrderTip6")];
                            NSMutableAttributedString *mtaStr = [[NSMutableAttributedString alloc] initWithString:mStr];
                            [mtaStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:[[mtaStr string] rangeOfString:time]];
                            orderStatusTip.attributedText = mtaStr;
                        }else if ([_model1.order_status isEqualToString:@"1"]){
                            NSString *mStr = [NSString stringWithFormat:@"%@ %@",LocalizationKey(@"FiatOrderTip9"),time];
                            NSMutableAttributedString *mtaStr = [[NSMutableAttributedString alloc] initWithString:mStr];
                            [mtaStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:[[mtaStr string] rangeOfString:time]];
                            orderStatusTip.attributedText = mtaStr;
                        }
                       
                    }
                }else{
                    if([_model1.order_type isEqualToString:@"0"]){
                        if([_model1.order_status isEqualToString:@"0"]){
                            NSString *mStr = [NSString stringWithFormat:@"%@ %@",LocalizationKey(@"FiatOrderTip21"),time];
                            NSMutableAttributedString *mtaStr = [[NSMutableAttributedString alloc] initWithString:mStr];
                            [mtaStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:[[mtaStr string] rangeOfString:time]];
                            orderStatusTip.attributedText = mtaStr;
                        }else if ([_model1.order_status isEqualToString:@"1"]){
                            NSString *mStr = [NSString stringWithFormat:@"%@ %@",LocalizationKey(@"FiatOrderTip20"),time];
                            NSMutableAttributedString *mtaStr = [[NSMutableAttributedString alloc] initWithString:mStr];
                            [mtaStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:[[mtaStr string] rangeOfString:time]];
                            orderStatusTip.attributedText = mtaStr;
                        }
                    }else{
                        if([_model1.order_status isEqualToString:@"0"]){
                            NSString *mStr = [NSString stringWithFormat:@"%@ %@ %@",LocalizationKey(@"FiatOrderTip5"),time,LocalizationKey(@"FiatOrderTip6")];
                            NSMutableAttributedString *mtaStr = [[NSMutableAttributedString alloc] initWithString:mStr];
                            [mtaStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:[[mtaStr string] rangeOfString:time]];
                            orderStatusTip.attributedText = mtaStr;
                        }else if ([_model1.order_status isEqualToString:@"1"]){
                            NSString *mStr = [NSString stringWithFormat:@"%@ %@",LocalizationKey(@"FiatOrderTip9"),time];
                            NSMutableAttributedString *mtaStr = [[NSMutableAttributedString alloc] initWithString:mStr];
                            [mtaStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:[[mtaStr string] rangeOfString:time]];
                            orderStatusTip.attributedText = mtaStr;
                        }
                    }
                }
                
                second--;
            }
            else
            {
                if(isStopTimer == 0){
                    if([_model1.order_status isEqualToString:@"1"]){
                         [self.switchPaymentMethodView.rightBtn setTitle:LocalizationKey(@"FiatOrderTip22") forState:UIControlStateNormal];
                    }else{
                        isStopTimer ++;
                        [self initData];
                        dispatch_source_cancel(timer);
                        timer = nil;
                    }
                }
            }
        });
    });
    dispatch_resume(timer);
}

/**
 两个时间相差多少天多少小时多少分多少秒
 
 @param startTime 开始时间
 @param endTime 结束时间
 @return 相差时间
 */
- (NSString *)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime
{
    NSTimeInterval value = [self getDateDifferenceWithNowDateStr:startTime deadlineStr:endTime];
    // 分
    int minute = (int)value /60%60;
    // 秒
    int second = (int)value %60;
    
    NSString *timeStr;
    timeStr = [NSString stringWithFormat:@"%d:%d",minute,second];

    return timeStr;
}

/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineStr : 截止时间
 *  @return 时间戳差值
 */
- (NSInteger)getDateDifferenceWithNowDateStr:(NSString*)nowDateStr deadlineStr:(NSString*)deadlineStr {
    
    NSInteger timeDifference = 0;
    NSTimeInterval oldTime = [deadlineStr doubleValue]/1;
    NSTimeInterval newTime = [nowDateStr doubleValue]/1;
    timeDifference = newTime - oldTime;
    
    if(timeDifference >0){
        return timeDifference;
    }else{
        return 0;
    }
}

#pragma mark - ui
-(void)setUpView{
    self.view.backgroundColor = rgba(0, 16, 36, 1);
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(Height_NavBar, 0, 0, 0));
    }];
    
    [self.scrollView addSubview:self.orderStatus];
    [self.orderStatus mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.scrollView.mas_top).offset(30);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
    
    orderStatusTip = [UILabel new];
    orderStatusTip.textColor = MainColor;
    orderStatusTip.font = tFont(15);
    [self.scrollView addSubview:orderStatusTip];
    [orderStatusTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderStatus.mas_bottom).offset(5);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
    
    NSMutableAttributedString *mtaStr = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"%@ 15:00 %@",LocalizationKey(@"FiatOrderTip5") ,LocalizationKey(@"FiatOrderTip6"))];
    [mtaStr addAttribute:NSForegroundColorAttributeName value:KWhiteColor range:[[mtaStr string] rangeOfString:@"15:00"]];
    orderStatusTip.attributedText = mtaStr;
    
    contactToBtn = [[SQCustomButton alloc] initWithFrame:CGRectZero type:SQCustomButtonTopImageType imageSize:CGSizeMake(40, 40) midmargin:8];
    contactToBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    contactToBtn.imageView.image = [UIImage imageNamed:@"call_her"];
    contactToBtn.titleLabel.text = LocalizationKey(@"FiatOrderTip23");
    contactToBtn.titleLabel.font = tFont(16);
    contactToBtn.titleLabel.textColor = MainColor;
    @weakify(self)
    [contactToBtn setTouchBlock:^(SQCustomButton * _Nonnull button) {
        @strongify(self)
       // 是订单发起者
        if([self->_model1.is_from isEqualToString:@"1"]){
            if(![HelpManager isBlankString:self->_model1.trade_uinfo.mobile]){//没手机号显示邮箱
                NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self->_model1.trade_uinfo.mobile];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
            }else{
                [[UniversalViewMethod sharedInstance] alertShowMessage:self->_model1.trade_uinfo.email WhoShow:self CanNilTitle:LocalizationKey(@"FiatOrderTip51")];
            }
        }else{//委托单发起者
           if(![HelpManager isBlankString:self->_model1.trade_uinfo.mobile]){//没手机号显示邮箱
                NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self->_model1.ower.mobile];
               [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{} completionHandler:nil];
            }else{
                [[UniversalViewMethod sharedInstance] alertShowMessage:self->_model1.ower.email WhoShow:self CanNilTitle:LocalizationKey(@"FiatOrderTip51")];
            }
        }
    }];
    [self.scrollView addSubview:contactToBtn];
    [contactToBtn mas_makeConstraints:^(MASConstraintMaker *make) {   make.right.mas_equalTo(self.view.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.centerY.mas_equalTo(self.orderStatus.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 70));
    }];
    [contactToBtn sizeToFit];
   
    grayView = [UIView new];
    grayView.layer.cornerRadius = 5 ;
    grayView.layer.masksToBounds = YES;
    grayView.backgroundColor = rgba(247, 246, 251, 1);
    [self.scrollView addSubview:grayView];
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderStatusTip.mas_bottom).offset(20);
        make.left.mas_equalTo(self.scrollView.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.width.mas_equalTo(ScreenWidth - 30);
        make.height.mas_equalTo(110);
    }];
    
    orderStatusTip1 = [UILabel new];
    orderStatusTip1.text = LocalizationKey(@"FiatOrderTip7");
    orderStatusTip1.textColor = KBlackColor;
    orderStatusTip1.font = [UIFont systemFontOfSize:15];
    [grayView addSubview:orderStatusTip1];
    [orderStatusTip1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(grayView.mas_top).offset(20);
        make.left.mas_equalTo(grayView.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
    
    totalPrice = [UILabel new];
    totalPrice.text = @"¥ 0.00";
    totalPrice.numberOfLines = 2;
    totalPrice.textColor = MainColor;
    totalPrice.font = [UIFont boldSystemFontOfSize:20];
    [grayView addSubview:totalPrice];
    [totalPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(orderStatusTip1.mas_bottom).offset(10);
        make.left.mas_equalTo(grayView.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
    
    payPieceNum = [UILabel new];
    payPieceNum.text = @"¥ 0.00";
    payPieceNum.textColor = [UIColor grayColor];
    payPieceNum.font = tFont(14);;
    payPieceNum.numberOfLines = 2;
    [grayView addSubview:payPieceNum];
    [payPieceNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(grayView.mas_top).offset(30);
        make.right.mas_equalTo(grayView.mas_right).offset(-OverAllLeft_OR_RightSpace);
    }];
    
    payPieceTip = [UILabel new];
    payPieceTip.text = LocalizationKey(@"FiatOrderTip24");
    payPieceTip.textColor = [UIColor grayColor];
    payPieceTip.font = tFont(14);;
    [grayView addSubview:payPieceTip];
    [payPieceTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(payPieceNum.mas_centerY).offset(0);
        make.left.mas_equalTo(grayView.mas_centerX).offset(0);
    }];
    
    payAmountTip = [UILabel new];
    payAmountTip.text = LocalizationKey(@"FiatOrderTip25");
    payAmountTip.textColor = [UIColor grayColor];
    payAmountTip.font = tFont(14);
    [grayView addSubview:payAmountTip];
    [payAmountTip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(payPieceTip.mas_bottom).offset(10);
        make.left.mas_equalTo(grayView.mas_centerX).offset(0);
    }];
   
    payAmountNum = [UILabel new];
    payAmountNum.text = @"0.00 BTC";
    payAmountNum.textColor = [UIColor grayColor];
    payAmountNum.adjustsFontSizeToFitWidth = YES;
    payAmountNum.font = tFont(14);
    [grayView addSubview:payAmountNum];
    [payAmountNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(payAmountTip.mas_centerY).offset(0);
        make.right.mas_equalTo(grayView.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.left.mas_equalTo(payPieceTip.mas_right).offset(5);
    }];
    
    __weak typeof(self) weakSelf = self;
    self.scrollView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf initData];
    }];
   // self.scrollView.contentSize = CGSizeMake(ScreenWidth, 900);
}

#pragma mark - set
-(void)setOrderStatusText:(UILabel *)orderStatus{
    self.navigationItem.title = self.orderStatus.text;
}

#pragma mark - lazyInit
-(UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight-Height_NavBar)];
        
    }
    return _scrollView;
}

-(SwitchPaymentMethodView *)switchPaymentMethodView{
    if(!_switchPaymentMethodView){
        _switchPaymentMethodView = [SwitchPaymentMethodView new];
        __weak typeof(self) weakSelf = self;
        _switchPaymentMethodView.backRefreshBlock = ^{
            [weakSelf initData];
        };
    }
    return _switchPaymentMethodView;
}

-(OrderInfoTableView *)orderInfoTableView{
    if(!_orderInfoTableView){
        _orderInfoTableView = [OrderInfoTableView new];
        __weak typeof(self) weakSelf = self;
        _orderInfoTableView.backRefreshBlock = ^{
            [weakSelf initData];
        };
    }
    return _orderInfoTableView;
}

-(PayMentBottomView *)bottomView{
    if(!_bottomView){
        _bottomView = [PayMentBottomView new];
        
    }
    return _bottomView;
}

-(UILabel *)orderStatus{
    if(!_orderStatus){
        _orderStatus = [UILabel new];
        _orderStatus.text = LocalizationKey(@"FiatOrderTip4");
        _orderStatus.textColor = payMentBlueTextColor;
        _orderStatus.font = [UIFont boldSystemFontOfSize:30];
    }
    return _orderStatus;
}

@end
