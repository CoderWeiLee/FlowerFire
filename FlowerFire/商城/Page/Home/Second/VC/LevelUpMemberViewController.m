//
//  LevelUpMemberViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/22.
//  Copyright © 2020 Celery. All rights reserved.
//  升级会员

#import "LevelUpMemberViewController.h"
#import "LevelUpMemberCellOne.h"
#import "LevelUpMemberCellTwo.h"
#import "GradientButton.h"
#import "LevelUpMemberCellThree.h"
#import "PermissionUtil.h"
#import <UIButton+WebCache.h>
#import "MemberLevelInfoModel.h"
#import "DeclarationProductsModel.h"
#import "DelegateContractViewController.h"
#import "InputPwdPopView.h"
#import <LSTPopView.h>

NSNotificationName const UpdateUserInfoNotice = @"UpdateUserInfoNotice";
 
@interface LevelUpMemberViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    NSString    *_certificateImageURLStr;
    NSInteger    _selectedProductIndex;
}
@property(nonatomic, strong)NSMutableArray<DeclarationProductsGoodsModel* > *productGoodsArray;
@property(nonatomic, strong)NSMutableArray<DeclarationProductsModel*>       *productArray;
@property(nonatomic, strong)MemberLevelInfoModel  *memberLevelInfoModel;
@property(nonatomic, strong)UIButton              *delegateButton;
/// 当前选中的会员等级
@property(nonatomic, assign)MemberLevel     currentMemberLevel;
@end

@implementation LevelUpMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navBackgroundColor = rgba(250, 250, 250, 1);
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
    self.gk_navigationItem.title = @"升级会员";
}

- (void)createUI{
    self.tableView.bounces = NO;
    self.tableView.frame = CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar);
    [self.view addSubview:self.tableView];
    
    UIImageView *headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hysj"]];
    headerView.frame = CGRectMake(0, 0, ScreenWidth, ceil(ScreenWidth/2.3));
     
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130)];
   
    GradientButton *submitButton = [[GradientButton alloc] initWithFrame:CGRectMake(OverAllLeft_OR_RightSpace, 40, ScreenWidth - 2 *OverAllLeft_OR_RightSpace, 50) titleStr:@"提交申请"];
    submitButton.titleLabel.font = tFont(15);
    submitButton.layer.shadowOffset = CGSizeMake(0,2);
    submitButton.layer.shadowOpacity = 1;
    submitButton.layer.shadowRadius = 4;
    submitButton.layer.cornerRadius = 5; 
    submitButton.layer.shadowColor = [UIColor colorWithRed:255/255.0 green:115/255.0 blue:80/255.0 alpha:0.35].CGColor;
    [bottomView addSubview:submitButton];
    
    NSString *delegateButtonStr = @"我已阅读并同意代理合同";
    NSMutableAttributedString *ma = [[NSMutableAttributedString alloc] initWithString:delegateButtonStr];
    [ma addAttributes:@{NSForegroundColorAttributeName:MainColor} range:[delegateButtonStr rangeOfString:@"代理合同"]];
    [ma addAttributes:@{NSForegroundColorAttributeName:rgba(153, 153, 153, 1)} range:[delegateButtonStr rangeOfString:@"我已阅读并同意"]];

    self.delegateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.delegateButton setAttributedTitle:ma forState:UIControlStateNormal];
    self.delegateButton.titleLabel.font = tFont(11);
    [self.delegateButton setImage:[UIImage imageNamed:@"Unselected"] forState:UIControlStateNormal];
    [self.delegateButton setImage:[UIImage imageNamed:@"ty"] forState:UIControlStateSelected];
    [self.delegateButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [bottomView addSubview:self.delegateButton];
    [self.delegateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(submitButton.mas_right);
        make.top.mas_equalTo(submitButton.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 30));
    }];
    self.delegateButton.selected = YES;
    
    self.delegateButton.imageView.userInteractionEnabled = YES;
    @weakify(self)
    [self.delegateButton.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(UITapGestureRecognizer * _Nonnull sender) {
        @strongify(self)
        self.delegateButton.selected = !self.delegateButton.selected;
    }]];
     
    self.delegateButton.titleLabel.userInteractionEnabled = YES;
    [self.delegateButton.titleLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self)
        DelegateContractViewController *dvc = [DelegateContractViewController new];
        [self.navigationController pushViewController:dvc animated:YES];
    }]];
    
    
    [submitButton addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];

    self.tableView.tableHeaderView = headerView;
    self.tableView.tableFooterView = bottomView;
}

#pragma mark - dataSource
- (void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    md[@"type"] = @"1";
    [self.afnetWork jsonMallPostDict:@"/api/member/memberUpPage" JsonDict:md Tag:@"1" LoadingInView:self.view];
   
    self.dataArray = @[@{@"text":@"选择会员等级"},
                       @{@"text":@"选择报单产品"},
                       ].copy;
}
  
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        if(dict[@"data"] != [NSNull null]){
            self.memberLevelInfoModel = [MemberLevelInfoModel yy_modelWithDictionary:dict[@"data"]];
        }
    }else if([type isEqualToString:@"2"]){
        printAlert(dict[@"msg"], 1.f);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:UpdateUserInfoNotice object:nil];
        
        [self closeVC];
    }else if([type isEqualToString:@"3"]){  //报单产品
        self.productArray = [NSMutableArray array];
       
        for (NSDictionary *dic in dict[@"data"]) {
            [self.productArray addObject:[DeclarationProductsModel yy_modelWithDictionary:dic]];
        }
        
        self.productGoodsArray = self.productArray.firstObject.goods.mutableCopy;
         
        //将第一个数据改成 isShowLeftText YES
        for (DeclarationProductsModel *productsModel in self.productArray) {
            DeclarationProductsGoodsModel *goodsModel = productsModel.goods.firstObject;
            goodsModel.isShowLeftText = YES;
        }
        
        [self presentChooseProductModalVC];
    }else{
        
    }

}

#pragma mark - action
//提交申请
-(void)submitClick{
    if(self.delegateButton.isSelected){
        if(self.memberLevel == 0){
            printAlert(@"请选择会员等级", 1.f);
            return;
        }

        //vip和经理输入支付密码
        if(self.memberLevel == MemberLevelVIP ||
           self.memberLevel == MemberLevelManager){
             InputPwdPopView *inputPwdView = [[InputPwdPopView alloc] initWithFrame:CGRectMake(0, ScreenHeight / 2 - 92, ScreenWidth * 0.8, 184)];
             LSTPopView *popView = [LSTPopView initWithCustomView:inputPwdView parentView:self.view popStyle:LSTPopStyleSpringFromTop dismissStyle:LSTDismissStyleCardDropToTop];
             [popView pop];
            
             @weakify(popView)
             @weakify(self)
             inputPwdView.closePopViewBlock = ^{
              @strongify(popView)
                 [popView dismiss];
             };
             inputPwdView.pwdInputView.textDidChangeblock = ^(NSString * _Nullable text, BOOL isFinished) {
                 @strongify(popView)
                 @strongify(self)
                 if(isFinished){
                     [popView dismiss];
                     [self submitLevelUpNetWork:text];
                 }
             };
        }else{
            //总监上传凭证
            if(self.memberLevel == MemberLevelDirector && [HelpManager isBlankString:_certificateImageURLStr]){
                printAlert(@"请上传支付凭证", 1.f);
            }else{
                [self submitLevelUpNetWork:@""];
            }
        }

    }else{
        printAlert(@"请先同意代理合同", 1.f);
    }
}

/// 提交升级网络请求
/// @param confirm_pass2 支付密码
-(void)submitLevelUpNetWork:(NSString *)confirm_pass2{
    if(self.productArray.count >_selectedProductIndex){
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:4];
        md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
        md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
        md[@"sheet"] = self.memberLevelInfoModel.ranknode.sheet;  // 升级节点的字段名
        md[@"newrank"] = @(self.memberLevel);  //升级到新级别（数字）
        md[@"t_id"] = self.productArray[_selectedProductIndex].productsID;
        md[@"is_agree"] = @"1";
        md[@"pay_img"] = _certificateImageURLStr;  //营销总监需要上传凭证
        md[@"confirm_pass2"] = confirm_pass2;
        [self.afnetWork jsonMallPostDict:@"/api/member/memberUp" JsonDict:md Tag:@"2"];
    }else{
        printAlert(@"请选择报单产品", 1.f);
    }
}

#pragma mark - tableViewDelegate
- (void)reloadTitleStr:(NSIndexPath *)indexPath titleStr:(NSString *)str isFirstRow:(BOOL)isFirstRow{
    NSMutableArray *ma = [NSMutableArray arrayWithArray:self.dataArray];
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[indexPath.row]];
    md[@"text"] = str;
    ma[indexPath.row] = md;
    self.dataArray = ma;
    if(isFirstRow){  //选中会员等级后，重置报单产品文字
        NSMutableDictionary *md = [NSMutableDictionary dictionaryWithDictionary:self.dataArray[1]];
        md[@"text"] = @"选择报单产品";
        ma[1] = md;
        self.dataArray = ma;
    }

    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            {
            if(indexPath.row == 0){
                if(self.memberLevelInfoModel.nowrank.num == MemberLevelDirector){
                    printAlert(@"已是最高等级", 1.f);
                    return;
                }
                UIAlertController *ua = [UIAlertController alertControllerWithTitle:@"选择会员等级" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                for (MemberLevelRankInfosModel *ranksModel in self.memberLevelInfoModel.rankinfos) {
                    UIAlertAction *ua1 = [UIAlertAction actionWithTitle:ranksModel.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                            self.memberLevel = ranksModel.num;
                            self.currentMemberLevel = self.memberLevel;
                            [self.productArray removeAllObjects];
                            [self.productGoodsArray removeAllObjects];
                        [self reloadTitleStr:indexPath titleStr:ranksModel.name isFirstRow:YES];
                        }];
                    [ua addAction:ua1];
                }
                 
                UIAlertAction *ua3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [ua addAction:ua3];
                [self presentViewController:ua animated:YES completion:nil];
            }else{
                if(self.memberLevel == 0){
                    printAlert(@"请选择会员等级", 1.f);
                    return;
                }
                //没有切换会员等级并且有产品数据不用在网络拿数据了
                if(self.currentMemberLevel == self.memberLevel &&
                   self.productArray.count > 0){
                    [self presentChooseProductModalVC];
                }else{
                    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:3];
                    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
                    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
                    md[@"newrank"] = @(self.memberLevel);
                    [self.afnetWork jsonMallPostDict:@"/api/member/memberUpGood" JsonDict:md Tag:@"3"];
                }

            }
        }
            break;
        case 2:
        {
            if(self.memberLevel != MemberLevelDirector){
                UIAlertController *ua = [UIAlertController alertControllerWithTitle:@"选择支付方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//                UIAlertAction *ua1 = [UIAlertAction actionWithTitle:@"微信" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    LevelUpMemberCellOne *cell = [tableView cellForRowAtIndexPath:indexPath];
//                    cell.loginInputView.text = @"微信";
//                }];
//                UIAlertAction *ua2 = [UIAlertAction actionWithTitle:@"支付宝" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                     LevelUpMemberCellOne *cell = [tableView cellForRowAtIndexPath:indexPath];
//                     cell.loginInputView.text = @"支付宝";
//                }];
                UIAlertAction *ua4 = [UIAlertAction actionWithTitle:@"工资钱包" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                     LevelUpMemberCellOne *cell = [tableView cellForRowAtIndexPath:indexPath];
                     cell.loginInputView.text = @"工资钱包";
                }];
                
                UIAlertAction *ua3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        //        [ua addAction:ua1];
        //        [ua addAction:ua2];
                [ua addAction:ua4];
                [ua addAction:ua3];
                [self presentViewController:ua animated:YES completion:nil];
            }
        }
        default:
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
        {
            static NSString *identifier = @"cell";
            [self.tableView registerClass:[LevelUpMemberCellOne class] forCellReuseIdentifier:identifier];
            LevelUpMemberCellOne *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            cell.loginInputView.text = self.dataArray[indexPath.row][@"text"];
            return cell;
        }
        case 1:
        {
            static NSString *identifier = @"cell1";
            [self.tableView registerClass:[LevelUpMemberCellTwo class] forCellReuseIdentifier:identifier];
            LevelUpMemberCellTwo *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
            
            [cell setCellData:self.productGoodsArray[indexPath.row]];
            return cell;
        }
        default:
        {
            if(self.memberLevel != MemberLevelDirector){
                static NSString *identifier = @"cell2";
                [self.tableView registerClass:[LevelUpMemberCellOne class] forCellReuseIdentifier:identifier];
                LevelUpMemberCellOne *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                cell.loginInputView.text = @"工资钱包";
                return cell;
            }else{
                static NSString *identifier = @"cell3";
                [self.tableView registerClass:[LevelUpMemberCellThree class] forCellReuseIdentifier:identifier];
                LevelUpMemberCellThree *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
                [cell.uploadButton addTarget:self action:@selector(uploadClick:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
            }

        }
    }
 

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return self.dataArray.count;
        case 1:
            return self.productGoodsArray.count;
        default:
            return 1;
    }

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.section) {
        case 0:
            return 45 +  1 * OverAllLeft_OR_RightSpace;
        case 1:
            return 20;
        default:
            if(self.memberLevel == MemberLevelDirector){
                return 100;
            }else{
                return 45 +  1 * OverAllLeft_OR_RightSpace;
            }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 15)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0){
        return 25;
    }
    return 10;
}

#pragma mark - privateMethod
- (void)presentChooseProductModalVC {
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:@"选择报单产品" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    NSInteger index = 0;
    for (DeclarationProductsModel *model in self.productArray) {
        UIAlertAction *ua1 = [UIAlertAction actionWithTitle:model.name style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self reloadTitleStr:indexPath titleStr:model.name isFirstRow:NO];
             
            if(index <= self.productArray.count){
                self->_selectedProductIndex = index;
                self.productGoodsArray = self.productArray[index].goods.mutableCopy;
                [self.tableView reloadData];
            }

        }];
        index++;
        [ua addAction:ua1];
    }
    
    UIAlertAction *ua3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [ua addAction:ua3];
    [self presentViewController:ua animated:YES completion:nil];
}

-(void)uploadClick:(UIButton *)button{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"上传支付凭证" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
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
    md[@"dir"] = @"other";
    
    [self.afnetWork uploadMallDataPost:imageData parameters:md urlString:@"/api/Uploadfile/uploads" LoadingInView:self.view];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//网络上传图片
-(void)getHttpData:(NSDictionary *)dict response:(Response)flag{
    [MBManager hideAlert];
    if(flag == Success){
        if([dict[@"status"] integerValue] == 1){
            LevelUpMemberCellThree *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
            _certificateImageURLStr = [NSString stringWithFormat:@"%@",dict[@"url"]];
            [cell.uploadButton sd_setImageWithURL:[NSURL URLWithString:_certificateImageURLStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"tus"]];
  
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
    LevelUpMemberCellThree *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    [cell.uploadButton setImage:[UIImage imageNamed:@"tus"] forState:UIControlStateNormal];
  
}

#pragma mark - 代理方法 防止关不掉页面
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


@end
