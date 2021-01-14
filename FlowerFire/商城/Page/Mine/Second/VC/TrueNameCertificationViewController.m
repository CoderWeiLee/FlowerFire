//
//  TrueNameCertificationViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//  实名认证

#import "TrueNameCertificationViewController.h"
#import "LoginCell.h"
#import "UIImage+jianbianImage.h"
#import "PermissionUtil.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <BRPickerView.h>

@interface TrueNameCertificationViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIButton *_leftButton,*_rightButton;
    NSString *_leftIDCardStr,*_rightIDCardStr;
    NSString *_trueNameStr,*_cardStr;
    NSString *_addressStr;
    NSString *_provinceID,*_cityID,*_areaID;
   
}
/// 地址id
@property(nonatomic, strong)NSMutableArray *addressArray;
/// 审核被拒绝原因
@property(nonatomic, strong)YYLabel        *reason;

@end

@implementation TrueNameCertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navigationItem.title = @"实名认证";
}

- (void)createUI{
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.tableView];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 300)];
    
    UILabel *picTip = [[UILabel alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 25, ScreenWidth, 15)];
    picTip.text = @"身份证照片";
    picTip.textColor = rgba(51, 51, 51, 1);
    picTip.font = tFont(13);
    [bottomView addSubview:picTip];
    
    CGFloat buttonWidth = (ScreenWidth - 30 * 3)/2;
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_leftButton setImage:[UIImage imageNamed:@"tus"] forState:UIControlStateNormal];
    [bottomView addSubview:_leftButton];
    _leftButton.frame = CGRectMake(30, picTip.ly_maxY + 10, buttonWidth, ceil(buttonWidth/1.75));
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setImage:[UIImage imageNamed:@"tus"] forState:UIControlStateNormal];
    [bottomView addSubview:_rightButton];
    _rightButton.frame = CGRectMake(ScreenWidth - 30 - buttonWidth, picTip.ly_maxY + 10, buttonWidth, ceil(buttonWidth/1.75));
    
    UILabel *leftTip = [[UILabel alloc] initWithFrame:CGRectMake(_leftButton.ly_x, _leftButton.ly_maxY + 6.5, _leftButton.width, 20)];
    leftTip.text = @"身份证正面";
    leftTip.font = tFont(13);
    leftTip.textAlignment = NSTextAlignmentCenter;
    leftTip.textColor = rgba(204, 204, 204, 1);
    [bottomView addSubview:leftTip];
    
    UILabel *rightTip = [[UILabel alloc] initWithFrame:CGRectMake(_rightButton.ly_x, _rightButton.ly_maxY + 6.5, _rightButton.width, 20)];
    rightTip.text = @"身份证反面";
    rightTip.font = tFont(13);
    rightTip.textAlignment = NSTextAlignmentCenter;
    rightTip.textColor = rgba(204, 204, 204, 1);
    [bottomView addSubview:rightTip];
    
    UIButton *submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitButton setBackgroundImage:[UIImage gradientColorImageFromColors:MaingradientColor gradientType:GradientTypeLeftToRight imgSize:CGSizeMake(ScreenWidth - 2 * OverAllLeft_OR_RightSpace, 50)] forState:UIControlStateNormal];
    submitButton.titleLabel.font = tFont(15);
    submitButton.layer.cornerRadius = 5;
    submitButton.layer.masksToBounds = YES;
    submitButton.frame = CGRectMake(OverAllLeft_OR_RightSpace,leftTip.ly_maxY + 50, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 50);
    submitButton.layer.shadowOffset = CGSizeMake(0,2);
    submitButton.layer.shadowOpacity = 1;
    submitButton.layer.shadowRadius = 4;
    [bottomView addSubview:submitButton];
    
    ///未通过审核
    if([[WTMallUserInfo shareUserInfo].is_realname integerValue] == 2){
        [submitButton setTitle:@"未通过，请重新上传" forState:UIControlStateNormal];
        _reason = [[YYLabel alloc] initWithFrame:CGRectMake(submitButton.ly_x, submitButton.ly_maxY + 20, submitButton.ly_width, 0)];
        _reason.numberOfLines = 0;
        _reason.displaysAsynchronously = YES;
        _reason.ignoreCommonProperties = YES;
        [bottomView addSubview:_reason];
        
    }else{
        [submitButton setTitle:@"提交审核" forState:UIControlStateNormal];
        bottomView.height = submitButton.ly_maxY;
    }
     
    [_leftButton addTarget:self action:@selector(chooseIDCardClick:) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton addTarget:self action:@selector(chooseIDCardClick:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.tableFooterView = bottomView;
}

-(void)setReasonText:(NSString *)reasonStr parentView:(UIView *)parentView{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:NSStringFormat(@"未通过原因:\n%@",reasonStr)];
       text.yy_font = tFont(13);
       text.yy_color = [UIColor grayColor];
       [text yy_setFont:tFont(15) range:[[text string] rangeOfString:@"未通过原因:"]];
       [text yy_setColor:KBlackColor range:[[text string] rangeOfString:@"未通过原因:"]];
       [text yy_setLineSpacing:15 range:[[text string] rangeOfString:@"未通过原因:"]];
        
       YYTextContainer *container = [YYTextContainer new];
       container.size = CGSizeMake(ScreenWidth - 2 * OverAllLeft_OR_RightSpace, CGFLOAT_MAX);
       container.maximumNumberOfRows = 0;
       
       YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
      
       dispatch_async(dispatch_get_main_queue(), ^{
           self.reason.size = layout.textBoundingSize;
           self.reason.textLayout = layout;
           parentView.height = self.reason.ly_maxY;
       });
    });
}

- (void)initData{
    self.dataArray = @[@{@"placeholderStr":@"输入真实姓名"},
    @{@"placeholderStr":@"输入身份证号"},
                       @{@"placeholderStr":@"请选择地址",@"rightView":@"xia2"},].copy;
    
    //未通过审核，查看下原因
    if([[WTMallUserInfo shareUserInfo].is_realname integerValue] == 2){
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
        [self.afnetWork jsonMallPostDict:@"/api/shiming/shiming" JsonDict:md Tag:@"2"];
    }
}

#pragma mark - action
-(void)submitClick{
    if(_trueNameStr && _cardStr && _leftIDCardStr && _rightIDCardStr && _addressStr){
        NSMutableDictionary *md = [NSMutableDictionary dictionary];
        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
        md[@"truename"] = _trueNameStr;
        md[@"card"] = _cardStr;
        md[@"image_input"] = _leftIDCardStr;
        md[@"image2_input"] = _rightIDCardStr;
        md[@"addr"] = _addressStr;
        md[@"province"] = _provinceID;
        md[@"city"] = _cityID;
        md[@"area"] = _areaID;
        [self.afnetWork jsonMallPostDict:@"/api/shiming/shiming_save" JsonDict:md Tag:@"1" LoadingInView:self.view];
    }else{
        printAlert(@"请填写完整信息", 1.f);
    } 
     
}

-(void)chooseIDCardClick:(UIButton *)button{
    if([button isEqual:_leftButton]){ //点击的身份证正面
        _leftButton.selected = YES;
        _rightButton.selected = NO;
    }else{//点击的身份证反面
        _leftButton.selected = NO;
        _rightButton.selected = YES;
    }
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"上传身份证" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"打开相机" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self Camera];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self choosevideo];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

//从相册中选取
- (void)choosevideo{
    [PermissionUtil checkPhotoPermission];
    //图片选择器
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc]init];
    imagepicker.allowsEditing = YES;
    imagepicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagepicker.delegate = self;
    imagepicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagepicker animated:YES completion:nil];
}

///从相机
-(void)Camera{
    [PermissionUtil checkCameraPermission];
    UIImagePickerController *imagepicker = [[UIImagePickerController alloc]init];
    imagepicker.allowsEditing = YES;
    //判断是否可以打开照相机
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //摄像头
        imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else { //否则打开照片库
        imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imagepicker.delegate = self;
    imagepicker.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagepicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *resultImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(resultImage, 0.1);
    
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid; 
    md[@"dir"] = @"profile";
   
    [self.afnetWork uploadMallDataPost:imageData parameters:md urlString:@"/api/Uploadfile/uploads" LoadingInView:self.view];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//网络上传图片
-(void)getHttpData:(NSDictionary *)dict response:(Response)flag{
    [MBManager hideAlert];
    if(flag == Success){
        if([dict[@"status"] integerValue] == 1){
            if(_leftButton.isSelected){
                  _leftIDCardStr = [NSString stringWithFormat:@"%@",dict[@"url"]];
                  [_leftButton sd_setImageWithURL:[NSURL URLWithString:_leftIDCardStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"tus"]];
              }else{
                  _rightIDCardStr = [NSString stringWithFormat:@"%@",dict[@"url"]];
                  [_rightButton sd_setImageWithURL:[NSURL URLWithString:_rightIDCardStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"tus"]];
              }
        }else{
            NSString *msg = [NSString stringWithFormat:@"%@",dict[@"msg"]];
                       printAlert(msg, 1.f);
            [self uploadErrorHandle];
        }
    }else{
        printAlert(LocalizationKey(@"upload failed"), 1.f);
        [self uploadErrorHandle];
    }
}

-(void)uploadErrorHandle{
    if(_leftButton.isSelected){
        [_leftButton setImage:[UIImage imageNamed:@"tus"] forState:UIControlStateNormal];
    }else{
        [_rightButton setImage:[UIImage imageNamed:@"tus"] forState:UIControlStateNormal];
    }
}

#pragma mark - netData
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUserInfoNotice object:nil];
        printAlert(dict[@"msg"], 1.f);
        [self closeVC];
    }else{
        if(dict[@"data"] != [NSNull null]){
            if([dict[@"data"][@"jujue_reason"] isKindOfClass:[NSString class]]){
                [self setReasonText:dict[@"data"][@"jujue_reason"] parentView:self.tableView.tableFooterView];
            }else{
                [self setReasonText:@"无" parentView:self.tableView.tableFooterView];
            }
        }
    }

}

#pragma mark - 代理方法 防止关不掉页面
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma makr - tableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row == 2){
        LoginCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if(self.addressArray.count>0){
            [self showBRaddressPickerView:self.addressArray cell:cell];
        }else{
            self.addressArray = [NSMutableArray array];
            [MBManager showLoading];
            @weakify(self)
            [[ReqestHelpManager share] requestMallPost:@"/api/Webmember/getAllRegion" andHeaderParam:nil finish:^(NSDictionary *dicForData, ReqestType flag) {
                @strongify(self)
                [MBManager hideAlert];
                for (NSDictionary *dic in dicForData[@"data"]) {
                    [self.addressArray addObject:dic];
                }
                
                [self showBRaddressPickerView:self.addressArray cell:cell];
            }];
        }

          
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    [self.tableView registerClass:[LoginCell class] forCellReuseIdentifier:identifier];
    LoginCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    [cell setCellData:self.dataArray[indexPath.row]];
    
    if(indexPath.row == 2){
        cell.loginInputView.enabled = NO;
    }
    
    cell.loginInputView.tag = indexPath.row;
    [cell.loginInputView addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45 +  1 * OverAllLeft_OR_RightSpace;
}

- (void)showBRaddressPickerView:(NSMutableArray *)addressArray cell:(LoginCell *)cell {
    BRAddressPickerView *addressPickerView = [[BRAddressPickerView alloc]init];
    addressPickerView.dataSourceArr = addressArray;
    addressPickerView.pickerMode = BRAddressPickerModeArea;
    addressPickerView.title = @"请选择地区";
    addressPickerView.isAutoSelect = YES;
    addressPickerView.resultBlock = ^(BRProvinceModel *province, BRCityModel *city, BRAreaModel *area) {
        NSLog(@"选择的值：%@", [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name]);
        cell.loginInputView.text = [NSString stringWithFormat:@"%@ %@ %@", province.name, city.name, area.name];
        self->_provinceID = province.code;
        self->_cityID = city.code;
        self->_areaID = area.code;
        
        self->_addressStr = cell.loginInputView.text;
    };
    
    [addressPickerView show];
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            _trueNameStr = textField.text;
            break;
        case 1:
            _cardStr = textField.text;
            break;
    }
}

@end
