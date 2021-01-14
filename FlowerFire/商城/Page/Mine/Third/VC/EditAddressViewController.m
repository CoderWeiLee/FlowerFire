//
//  EditAddressViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/20.
//  Copyright © 2020 Celery. All rights reserved.
//  编辑或新增

#import "EditAddressViewController.h"
#import "UIImage+jianbianImage.h"
#import "EditAddressCell.h"
#import "ChooseProvinceViewController.h"

@interface EditAddressViewController ()
{
    NSString *_userName;
    NSString *_phone;
    NSString *_county;
    NSString *_detailsCounty;
    NSString *_provinceId;
    NSString *_cityId;
    NSString *_areaId;
    NSIndexPath *_addressIndexPath;
}
@property(nonatomic, strong)UIButton     *accButton;
@property(nonatomic, strong)UIImageView  *accImage;
@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedAddressListener:) name:SELECTED_ADDRESS_NOTICE object:nil];
}

-(void)selectedAddressListener:(NSNotification *)notice{
    _provinceId = notice.userInfo[@"provinceId"];
    _cityId = notice.userInfo[@"cityId"];
    _areaId = notice.userInfo[@"areaId"];
    
    NSString *address = [NSString stringWithFormat:@"%@ %@ %@", notice.userInfo[@"provinceName"], notice.userInfo[@"cityName"], notice.userInfo[@"areaName"]];
    
    EditAddressCell *cell = [self.tableView cellForRowAtIndexPath:_addressIndexPath];
    cell.textField.text = address; 
}

- (void)createNavBar{
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
    self.gk_navigationItem.title = @"地址管理";
}
 
- (void)createUI{
    self.view.backgroundColor = self.gk_navBackgroundColor;
    self.tableView.backgroundColor = self.gk_navBackgroundColor;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar - 45 - SafeAreaBottomHeight);
    [self.view addSubview:self.tableView];
    
    UIButton *addAddressButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addAddressButton.titleLabel setFont:tFont(15)];
    [addAddressButton setTitle:@"保存并使用" forState:UIControlStateNormal];
    addAddressButton.frame = CGRectMake(0, ScreenHeight - SafeAreaBottomHeight - 45, ScreenWidth, 45);
    [addAddressButton setBackgroundImage:[UIImage gradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight imgSize:addAddressButton.size] forState:UIControlStateNormal];
    [self.view addSubview:addAddressButton];
    [addAddressButton addTarget:self action:@selector(saveAddressClick) forControlEvents:UIControlEventTouchUpInside];
}

- (void)initData{
    if(self.addressManagerType == AddressManagerTypeEdit){
        self.dataArray = @[@[@{@"title":@"姓名",@"placeholder":@"输入收货人姓名",@"details":self.addressInfoModel.consignee},
                             @{@"title":@"手机号",@"placeholder":@"输入手机号",@"details":self.addressInfoModel.mobile,@"keyBoardType":@"phone"},
                             @{@"title":@"所在地区",@"placeholder":@"省市区",@"details":NSStringFormat(@"%@%@%@",self.addressInfoModel.province_info,self.addressInfoModel.city_info,self.addressInfoModel.area_info),@"accView":@"jiantou",@"disable":@"1"},
                             @{@"title":@"详细地址",@"placeholder":@"请输入详细地址",@"details":self.addressInfoModel.address,@"hiddenLine":@"1"}],
                           
                           @[@{@"title":@"默认地址",@"accView":@"custom",@"hiddenLine":@"1",@"disable":@"1"}]].copy;
        _userName = self.addressInfoModel.consignee;
        _phone = self.addressInfoModel.mobile;
        _detailsCounty = self.addressInfoModel.address;
        _provinceId = self.addressInfoModel.province;
        _cityId = self.addressInfoModel.city;
        _areaId = self.addressInfoModel.area;
    }else{
        self.dataArray = @[@[@{@"title":@"姓名",@"placeholder":@"输入收货人姓名"},
                             @{@"title":@"手机号",@"placeholder":@"输入手机号",@"keyBoardType":@"phone"},
                             @{@"title":@"所在地区",@"placeholder":@"省市区",@"accView":@"jiantou",@"disable":@"1"},
                             @{@"title":@"详细地址",@"placeholder":@"请输入详细地址",@"hiddenLine":@"1"}],
                           
                           @[@{@"title":@"默认地址",@"accView":@"custom",@"hiddenLine":@"1",@"disable":@"1"}]].copy;
    }
    

}

#pragma mark - netBack
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    printAlert(dict[@"msg"], 1.f);
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - action
-(void)saveAddressClick{ 
    if(self.addressManagerType == AddressManagerTypeEdit){
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:9];
        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
        md[@"id"] = self.addressInfoModel.AddressId;
        md[@"consignee"] = _userName;
        md[@"mobile"] = _phone;
        md[@"province"] = _provinceId;
        md[@"city"] = _cityId;
        md[@"area"] = _areaId;
        md[@"address"] = _detailsCounty;
        md[@"is_default"] = self.accButton.isSelected ? @"1":@"0";
        [self.afnetWork jsonMallPostDict:@"/api/order/editAddress" JsonDict:md Tag:@"2" LoadingInView:self.view];
    }else{
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:8];
        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
        md[@"consignee"] = _userName;
        md[@"mobile"] = _phone;
        md[@"province"] = _provinceId;
        md[@"city"] = _cityId;
        md[@"area"] = _areaId;
        md[@"address"] = _detailsCounty;
        md[@"is_default"] = self.accButton.isSelected ? @"1":@"0";
        [self.afnetWork jsonMallPostDict:@"/api/order/addAddress" JsonDict:md Tag:@"1" LoadingInView:self.view];
    }
    

}

-(void)setDefaultAddressClick:(UIButton *)btn{
    btn.selected = !btn.selected;
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            _userName = textField.text;
            break;
        case 1:
            _phone = textField.text;
            break;
        case 2:
            
            break;
        default:
            _detailsCounty = textField.text;
            break;
    }
}


#pragma mark - tableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[EditAddressCell class] forCellReuseIdentifier:identifier];
    EditAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setCellData:self.dataArray[indexPath.section][indexPath.row]];
    
    if([self.dataArray[indexPath.section][indexPath.row][@"accView"] isEqualToString:@"custom"]){
        cell.accessoryView = [self accButton];
    }else if([self.dataArray[indexPath.section][indexPath.row][@"accView"] isEqualToString:@"jiantou"]){
        cell.accessoryView = [self accImage];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textField.tag = indexPath.row;
    [cell.textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
      
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0 && indexPath.row == 2){
        _addressIndexPath = indexPath;
        ChooseProvinceViewController *cvc = [ChooseProvinceViewController new];
        [self.navigationController pushViewController:cvc animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.dataArray[section];
    return array.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)]; 
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
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
            normalBgView.frame = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(-5, 0, 0, 0));
            CGRect rect = UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(5, 0, 0, 0));
            // 每组第一行（添加左上和右上的圆角）
            bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:(UIRectCornerTopLeft|UIRectCornerTopRight) cornerRadii:CGSizeMake(radius, radius)];
            normalBgView.clipsToBounds = YES;
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

-(UIButton *)accButton{
    if(!_accButton){
        _accButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _accButton.frame = CGRectMake(0, 0, 30, 30);
        [_accButton setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
        [_accButton setImage:[UIImage imageNamed:@"Selected"] forState:UIControlStateSelected];
        _accButton.selected = YES;
        [_accButton addTarget:self action:@selector(setDefaultAddressClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accButton;
}

-(UIImageView *)accImage{
    if(!_accImage){
        _accImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        _accImage.image = [UIImage imageNamed:@"8"];
    } 
    return _accImage;
}

@end
