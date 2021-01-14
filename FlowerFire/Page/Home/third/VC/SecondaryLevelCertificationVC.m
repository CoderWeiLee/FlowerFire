//
//  SecondaryLevelCertificationVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/6/3.
//  Copyright © 2019 王涛. All rights reserved.
//  二级认证

#import "SecondaryLevelCertificationVC.h"
#import "PermissionUtil.h"
#import <UIButton+WebCache.h>

@interface SecondaryLevelCertificationVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIButton *positiveImageBtn;  //正面照
    UIButton *reverseImageBtn;  //反面照
    BOOL     isUploadReverse; //是否上传的是反面 默认NO
    NSString *positiveUrl,*reverseUrl;
}
@end

@implementation SecondaryLevelCertificationVC

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.gk_navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpView];
    
    positiveUrl = @"";
    reverseUrl = @"";
}

#pragma mark - action
-(void)uploadPositiveClick{
    isUploadReverse = NO;
    [self presentAlbum];
}

-(void)uploadReverseImageBtnClick{
    isUploadReverse = YES;
    [self presentAlbum];
}

-(void)saveClick{
    if([HelpManager isBlankString:positiveUrl]){
        printAlert(LocalizationKey(@"Kyc2Tip1"), 1);
        return;
    }
    
    if([HelpManager isBlankString:reverseUrl]){
        printAlert(LocalizationKey(@"Kyc2Tip2"), 1);
        return;
    }
    [self.afnetWork jsonPostDict:@"/api/account/addVerifyKyc2" JsonDict:@{@"sn_imga":positiveUrl,@"sn_imgb":reverseUrl} Tag:@"1" LoadingInView:self.view];
}

#pragma mark - netBack
-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    printAlert(dict[@"msg"], 1.f);
    [self.navigationController popViewControllerAnimated:YES];
    
      //TODO:直接kyc升级为2级了
    WTUserInfo *userInfo = [WTUserInfo shareUserInfo];
    userInfo.kyc = @"2";
    [WTUserInfo saveUser:userInfo];
   
}

#pragma mark - 打开相册
-(void)presentAlbum{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:LocalizationKey(@"Take a photo") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self Camera];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:LocalizationKey(@"Album") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self choosevideo];
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    //把action添加到actionSheet里
    [actionSheet addAction:action1];
    [actionSheet addAction:action2];
    [actionSheet addAction:action3];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

#pragma mark - 代理方法 防止关不掉页面
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    imagepicker.modalPresentationStyle = UIModalPresentationFullScreen;    [self presentViewController:imagepicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    if(isUploadReverse){
        [reverseImageBtn setImage:nil forState:UIControlStateNormal];
    }else{
        [positiveImageBtn setImage:nil forState:UIControlStateNormal];
    }
    UIImage *resultImage = info[UIImagePickerControllerEditedImage];
    NSData *imageData = UIImageJPEGRepresentation(resultImage, 0.1);
    [self.afnetWork uploadDataPost:imageData parameters:nil urlString:nil LoadingInView:self.view];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//网络上传图片
-(void)getHttpData:(NSDictionary *)dict response:(Response)flag{
    [MBManager hideAlert];
    if(flag == Success){
        if([dict[@"code"] integerValue] == 1){
            if(isUploadReverse){
                reverseUrl = [NSString stringWithFormat:@"%@",dict[@"data"][@"url"]];
                [reverseImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,dict[@"data"][@"url"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mycenter_1"]];
            }else{ 
                positiveUrl = [NSString stringWithFormat:@"%@",dict[@"data"][@"url"]];
                [positiveImageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,dict[@"data"][@"url"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"mycenter_2"]];
            }
        }else{
            NSString *msg = [NSString stringWithFormat:@"%@",dict[@"msg"]];
            printAlert(msg, 1.f);
            if(isUploadReverse){
                [reverseImageBtn setImage:[UIImage imageNamed:@"mycenter_1"] forState:UIControlStateNormal];
            }else{
                [positiveImageBtn setImage:[UIImage imageNamed:@"mycenter_2"] forState:UIControlStateNormal];
            }
        }
    }else{
        printAlert(LocalizationKey(@"upload failed"), 1.f);
        if(isUploadReverse){
            [reverseImageBtn setImage:[UIImage imageNamed:@"mycenter_1"] forState:UIControlStateNormal];
        }else{
            [positiveImageBtn setImage:[UIImage imageNamed:@"mycenter_2"] forState:UIControlStateNormal];
        }
        
    }
}

#pragma mark - ui
-(void)setUpView{
    self.gk_navigationItem.title = LocalizationKey(@"KYC2 certification");
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = rgba(144, 157, 180, 1);
    titleLabel.font = tFont(18);
    titleLabel.text = LocalizationKey(@"ID card front photo");
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).offset(30+Height_NavBar);
        make.left.mas_equalTo(self.view.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
    
    positiveImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [positiveImageBtn setImage:[UIImage imageNamed:@"mycenter_1"] forState:UIControlStateNormal];
    [positiveImageBtn setTheme_backgroundColor:@"bac_kyc"];
    [self.view addSubview:positiveImageBtn];
    [positiveImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, (ScreenWidth - 30) /2));
    }];
    
    [positiveImageBtn addTarget:self action:@selector(uploadPositiveClick) forControlEvents:UIControlEventTouchUpInside];
    
    titleLabel = [UILabel new];
    titleLabel.textColor = rgba(144, 157, 180, 1);
    titleLabel.font = tFont(18);
    titleLabel.text = LocalizationKey(@"ID card back photo");
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(positiveImageBtn.mas_bottom).offset(30);
        make.left.mas_equalTo(self.view.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
    
    reverseImageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reverseImageBtn setImage:[UIImage imageNamed:@"mycenter_2"] forState:UIControlStateNormal];
    [reverseImageBtn  setTheme_backgroundColor:@"bac_kyc"];
    [self.view addSubview:reverseImageBtn];
    [reverseImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 40, (ScreenWidth - 40) /2));
    }];
    
    [reverseImageBtn addTarget:self action:@selector(uploadReverseImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.layer.cornerRadius = 3;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn setTitle:LocalizationKey(@"Save")  forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:MainBlueColor];
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20 );
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 50));
    }];
    [saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
}

@end
