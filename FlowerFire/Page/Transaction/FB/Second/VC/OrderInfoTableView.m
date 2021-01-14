//
//  OrderInfoTableView.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/30.
//  Copyright © 2019 王涛. All rights reserved.
//  订单详情的列表

#import "OrderInfoTableView.h"
#import "SwitchPaymentCell.h"
#import "AppealTBVC.h"

@interface OrderInfoTableView ()<UITableViewDelegate,UITableViewDataSource>
{
    int               isStopTimer; //变量为1，说明倒计时到点了，不然再倒计时了
    dispatch_source_t timer; //倒计时时间
    
}
@property(nonatomic, strong) NSArray     *dataArray;

@end

@implementation OrderInfoTableView

-(void)dealloc{
    if(timer){
        dispatch_source_cancel(timer);
    }
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
      //  [self initData];
        [self setUpView];
    }
    return self;
}

#pragma mark - action
//申诉点击
-(void)cancelClick{
    AppealTBVC *avc = [AppealTBVC new];
    avc.model = self.model;
    [[self viewController].navigationController pushViewController:avc animated:YES];
}
//放行点击
-(void)submitClick{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:LocalizationKey(@"FiatOrderTip32") message:LocalizationKey(@"FiatOrderTip40") preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *bank = [UIAlertAction actionWithTitle:LocalizationKey(@"confirm") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self.afnetWork jsonPostDict:@"/api/otc/finishOtcOrder" JsonDict:@{@"otc_order_id":self.model.otcOrderId} Tag:@"1"];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
    [ua addAction:bank];
    [ua addAction:cancel];
    [[self viewController]. navigationController presentViewController:ua animated:YES completion:nil];
}

#pragma mark -
-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    !self.backRefreshBlock ? : self.backRefreshBlock();
}

#pragma mark - dataSource
-(void)initData:(OrderRecordModel *)model{
    self.model = model;
    isStopTimer = 0;
    //是订单发起者显示的
    if([model.is_from isEqualToString:@"1"]){
        //购买
        if([self.model.order_type isEqualToString:@"0"]){
            if([self.model.order_status isEqualToString:@"-1"]){
                //  self.orderStatus.text = @"已取消";
                [self setCancelDataSouce:LocalizationKey(@"FiatOrderTip41") userName:self.model.trade_uinfo.nickname];
            }else if ([self.model.order_status isEqualToString:@"0"]){
                // self.orderStatus.text = @"请付款";
                
            }else if ([self.model.order_status isEqualToString:@"1"]){
                // self.orderStatus.text = @"已付款，待放币";
            }else if ([self.model.order_status isEqualToString:@"0"]){
            }else if ([self.model.order_status isEqualToString:@"2"]){
                //  self.orderStatus.text = @"交易成功";
                [self setDataSourceCarryOut:LocalizationKey(@"FiatOrderTip41") userName:self.model.trade_uinfo.nickname];
            }else if ([self.model.order_status isEqualToString:@"0"]){
            }else if ([self.model.order_status isEqualToString:@"-2"]){
                [self setDataSource:LocalizationKey(@"FiatOrderTip41") userName:self.model.trade_uinfo.nickname];
            }
        }else{ //出售
//            NSString *referenceId;
//            if(self.model.pay_list.count > 0){
//                referenceId = self.model.pay_list[0].referenceId;
//            }else{
//                referenceId = @"";
//            }
            if([self.model.order_status isEqualToString:@"-1"]){
                //  self.orderStatus.text = @"已取消";
                [self setCancelDataSouce:LocalizationKey(@"FiatOrderTip42") userName:self.model.trade_uinfo.nickname];
            }else if ([self.model.order_status isEqualToString:@"0"]){
                //    self.orderStatus.text = @"待付款";
                 self.bottomView.enabled = NO;
             //   [ self.bottomView setTitle:@"等待买家付款" forState:UIControlStateNormal];
                [self setDataSource:LocalizationKey(@"FiatOrderTip42") userName:self.model.trade_uinfo.nickname];
            }else if ([self.model.order_status isEqualToString:@"1"]){
                //   self.orderStatus.text = @"已付款，待放币";
                 self.bottomView.enabled = YES;
                NSString *time = [self dateTimeDifferenceWithStartTime:self.model.relase_end_time endTime:[HelpManager getNowTimeTimestamp]] ;
                //开一波倒计时
                [self startTime:self.model.relase_end_time endTime:[HelpManager getNowTimeTimestamp]];
                
                
                 [ self.bottomView setTitle:[NSString stringWithFormat:@"%@%@ %@%@",LocalizationKey(@"FiatOrderTip18"),self.model.symbol,LocalizationKey(@"FiatOrderTip43"),time] forState:UIControlStateNormal];
                 [self setDataSource:LocalizationKey(@"FiatOrderTip42") userName:self.model.trade_uinfo.nickname];
            }else if ([self.model.order_status isEqualToString:@"2"]){
                //    self.orderStatus.text = @"交易成功";
                 [self setDataSourceCarryOut:LocalizationKey(@"FiatOrderTip42") userName:self.model.trade_uinfo.nickname];
            }else if ([self.model.order_status isEqualToString:@"-2"]){
                 [self setDataSource:LocalizationKey(@"FiatOrderTip42") userName:self.model.trade_uinfo.nickname];
            }
        }
    }else{//不是订单发起者，即为委托人显示的
        //购买
        if([self.model.order_type isEqualToString:@"1"]){
            if([self.model.order_status isEqualToString:@"-1"]){
                //  self.orderStatus.text = @"已取消";
            [self setCancelDataSouce:LocalizationKey(@"FiatOrderTip41") userName:self.model.order_uinfo.nickname];
            }else if ([self.model.order_status isEqualToString:@"0"]){
                // self.orderStatus.text = @"请付款";
                
            }else if ([self.model.order_status isEqualToString:@"1"]){
                // self.orderStatus.text = @"已付款，待放币";
            }else if ([self.model.order_status isEqualToString:@"0"]){
            }else if ([self.model.order_status isEqualToString:@"2"]){
                //  self.orderStatus.text = @"交易成功";
                [self setDataSourceCarryOut:LocalizationKey(@"FiatOrderTip41") userName:self.model.order_uinfo.nickname];
            }else if ([self.model.order_status isEqualToString:@"0"]){
            }else if ([self.model.order_status isEqualToString:@"-2"]){
                [self setDataSource:LocalizationKey(@"FiatOrderTip41") userName:self.model.order_uinfo.nickname];
            }
        }else{ //出售
//            NSString *referenceId;
//            if(self.model.pay_list.count > 0){
//                referenceId = self.model.pay_list[0].referenceId;
//            }else{
//                referenceId = @"";
//            }
            if([self.model.order_status isEqualToString:@"-1"]){
                //  self.orderStatus.text = @"已取消";
               [self setCancelDataSouce:LocalizationKey(@"FiatOrderTip42") userName:self.model.order_uinfo.nickname];
            }else if ([self.model.order_status isEqualToString:@"0"]){
                //    self.orderStatus.text = @"待付款";
                self.bottomView.enabled = NO;
                [ self.bottomView setTitle:LocalizationKey(@"FiatOrderTip21") forState:UIControlStateNormal];
                [self setDataSource:LocalizationKey(@"FiatOrderTip42") userName:self.model.order_uinfo.nickname];
            }else if ([self.model.order_status isEqualToString:@"1"]){
                //   self.orderStatus.text = @"已付款，待放币";
                 self.bottomView.enabled = YES;
                NSString *time = [self dateTimeDifferenceWithStartTime:self.model.relase_end_time endTime:[HelpManager getNowTimeTimestamp]] ;
                //开一波倒计时
                [self startTime:self.model.relase_end_time endTime:[HelpManager getNowTimeTimestamp]];
                
                
                [ self.bottomView  setTitle:[NSString stringWithFormat:@"%@%@ %@%@",LocalizationKey(@"FiatOrderTip18"),self.model.symbol,LocalizationKey(@"FiatOrderTip43"),time] forState:UIControlStateNormal];
                [self setDataSource:LocalizationKey(@"FiatOrderTip42") userName:self.model.order_uinfo.nickname];
            }else if ([self.model.order_status isEqualToString:@"2"]){
                //    self.orderStatus.text = @"交易成功";
                [self setDataSourceCarryOut:LocalizationKey(@"FiatOrderTip42") userName:self.model.order_uinfo.nickname];
            }else if ([self.model.order_status isEqualToString:@"-2"]){
                [self setDataSource:LocalizationKey(@"FiatOrderTip42") userName:self.model.order_uinfo.nickname];
            }
        }
    }
    
   
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {    
        make.height.mas_equalTo(self.dataArray.count * 60);
    }];
    [self.tableView reloadData];
    
}
//交易完成的数据
-(void)setDataSourceCarryOut:(NSString *)title userName:(NSString *)userName{
    NSString *referenceId;
    if(self.model.pay_list.count > 0){
        referenceId = self.model.otcOrderId;
    }else{
        referenceId = @"";
    }
    self.dataArray = @[@{@"leftText":title,@"rightText":userName,@"showLeftBtn":@"0",@"showRightBtn":@"0"},
                       @{@"leftText":LocalizationKey(@"FiatPrice"),@"rightText":self.model.price,@"showLeftBtn":@"0",@"showRightBtn":@"0"},
          @{@"leftText":LocalizationKey(@"Amount"),@"rightText":self.model.amount,@"showLeftBtn":@"0",@"showRightBtn":@"0"},
          @{@"leftText":LocalizationKey(@"FiatOrderTip45"),@"rightText":[self getDateTimeStr:self.model.addtime],@"showLeftBtn":@"0",@"showRightBtn":@"1"},
         @{@"leftText":LocalizationKey(@"FiatOrderTip44"),@"rightText":self.model.otcOrderId,@"showLeftBtn":@"0",@"showRightBtn":@"1"},  @{@"leftText":LocalizationKey(@"FiatOrderTip37"),@"rightText":referenceId,@"showLeftBtn":@"1",@"showRightBtn":@"1"}];
    
}


-(void)setDataSource:(NSString *)title userName:(NSString *)userName{
    NSString *referenceId;
    if(self.model.pay_list.count > 0){
        referenceId = self.model.otcOrderId;
    }else{
        referenceId = @"";
    }
    self.dataArray = @[@{@"leftText":title,@"rightText":userName,@"showLeftBtn":@"0",@"showRightBtn":@"0"},
                       @{@"leftText":LocalizationKey(@"FiatOrderTip45"),@"rightText":[self getDateTimeStr:self.model.addtime],@"showLeftBtn":@"0",@"showRightBtn":@"1"},
                       @{@"leftText":LocalizationKey(@"FiatOrderTip44"),@"rightText":self.model.otcOrderId,@"showLeftBtn":@"0",@"showRightBtn":@"1"},  @{@"leftText":LocalizationKey(@"FiatOrderTip37"),@"rightText":referenceId,@"showLeftBtn":@"1",@"showRightBtn":@"1"}];
    
}

-(void)setCancelDataSouce:(NSString *)title userName:(NSString *)userName{
    NSString *referenceId;
    if(self.model.pay_list.count > 0){
        referenceId = self.model.otcOrderId;
    }else{
        referenceId = @"";
    }
    self.dataArray =  @[@{@"leftText":title,@"rightText":userName,@"showLeftBtn":@"0",@"showRightBtn":@"0"},
                       @{@"leftText":LocalizationKey(@"FiatOrderTip45"),@"rightText":[self getDateTimeStr:self.model.addtime],@"showLeftBtn":@"0",@"showRightBtn":@"1"},
                       @{@"leftText":LocalizationKey(@"FiatOrderTip44"),@"rightText":self.model.otcOrderId,@"showLeftBtn":@"0",@"showRightBtn":@"1"},
                       @{@"leftText":LocalizationKey(@"FiatOrderTip37"),@"rightText":referenceId,@"showLeftBtn":@"1",@"showRightBtn":@"1"}];
}

#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[SwitchPaymentCell class] forCellReuseIdentifier:identifier];
    SwitchPaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell){
        cell = [[SwitchPaymentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    [cell setCellData:self.dataArray[indexPath.row]];
    return cell;
}

#pragma mark - util
-(void)startTime:(NSString *)startTime endTime:(NSString *)endTime{
    // 倒计时时间
    __block NSInteger second = [self getDateDifferenceWithNowDateStr:startTime deadlineStr:endTime];
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, quene);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), NSEC_PER_SEC * 1, 0);
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (second > 0) {
                NSInteger days = (int)(second/(3600*24));
                NSInteger hours = (int)((second-days*24*3600)/3600);
                NSInteger minute = (int)(second-days*24*3600-hours*3600)/60;
                NSInteger second1 = second - days*24*3600 - hours*3600 - minute*60;
                NSString *time = [NSString stringWithFormat:@"%02ld分%02ld秒", minute,second1];
               [ self.bottomView setTitle:[NSString stringWithFormat:@"%@%@ %@%@",LocalizationKey(@"FiatOrderTip18"),self.model.symbol,LocalizationKey(@"FiatOrderTip43"),time] forState:UIControlStateNormal];
          //     [self.bottomView setImage:[UIImage imageNamed:@"pay_countdown"] forState:UIControlStateNormal];
                second--;
            }
            else
            {
                if(isStopTimer == 0){
                    isStopTimer ++;
                    [self initData];
                    [self.bottomView setTitle:[NSString stringWithFormat:@"%@",LocalizationKey(@"FiatOrderTip22")] forState:UIControlStateNormal];
                    self.bottomView.enabled = NO;
                    dispatch_source_cancel(timer);
                    timer = nil;
                }
            }
        });
    });
    dispatch_resume(timer);
}

-(NSString *)getDateTimeStr:(NSString *)time{
    // iOS 生成的时间戳是10位
    NSTimeInterval interval    = [time doubleValue] ;/// 1000.0;
    NSDate *date               = [NSDate dateWithTimeIntervalSince1970:interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm MM/dd"];
    return [formatter stringFromDate: date];
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
    timeStr = [NSString stringWithFormat:@"%d%@%d%@",minute,LocalizationKey(@"min"),second,LocalizationKey(@"second")];
    
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
-(void)showBottomView{
    UIView *line = [UIView new];
    line.backgroundColor = rgba(233, 235, 237, 1);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 80, 1));
    }];
    
    UILabel *tip = [UILabel new];
    tip.text = LocalizationKey(@"FiatOrderTip46");
    tip.numberOfLines = 2;
    [tip adjustsFontSizeToFitWidth];
    tip.textColor = rgba(43, 139, 212, 1);
    [self addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(line.mas_bottom).offset(15);
    }];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:LocalizationKey(@"FiatOrderTip11") forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = tFont(15);
    [cancelBtn setTitleColor:rgba(60, 69, 93, 1) forState:UIControlStateNormal];
    [cancelBtn setBackgroundColor:rgba(227, 227, 227, 1)];
    cancelBtn.layer.cornerRadius = 3;
    cancelBtn.enabled = NO;
    
    [self addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(tip.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake((ScreenWidth - 60 - 7.5) /4 * 1, 50));
    }];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  
    [submitBtn setTitle:[NSString stringWithFormat:@"%@ %@",LocalizationKey(@"FiatOrderTip18"),self.model.symbol] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:rgba(86, 112, 143, 1)];
    submitBtn.titleLabel.font = tFont(16);
    submitBtn.layer.cornerRadius = 3;
    [self addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.mas_right).offset(-OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(tip.mas_bottom).offset(15);
        make.size.mas_equalTo(CGSizeMake((ScreenWidth - 60 - 7.5) /4 * 3, 50));
    }];
    
    self.bottomLine = line;
    self.bottomLabel = tip;
    self.bottomView = submitBtn;
    self.leftBtn = cancelBtn;
   
    [cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
    [ self.bottomView addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
}

 

-(void)setUpView{
    self.backgroundColor = KWhiteColor;
    self.layer.cornerRadius = 5;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
  
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top);
        make.left.mas_equalTo(self.mas_left);
        make.width.mas_equalTo(self.mas_width);
       
    }];
    
   
}

-(OrderRecordModel *)model{
    if(!_model){
        _model = [OrderRecordModel new];
    }
    return _model;
}

@end
