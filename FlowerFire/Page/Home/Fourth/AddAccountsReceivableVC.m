//
//  AddAccountsReceivableVC.m
//  FireCoin
//
//  Created by 王涛 on 2019/5/31.
//  Copyright © 2019 王涛. All rights reserved.
//  添加支付方式

#import "AddAccountsReceivableVC.h"
#import "ReleaseFiledBaseView.h"
#import "AddAccountsReceivableSendVerificationCodeModalVC.h"
#import "PermissionUtil.h"
#import <UIButton+WebCache.h>

@interface AddAccountsReceivableVC ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    //从上到下
    ReleaseFiledBaseView *baseView1;
    ReleaseFiledBaseView *baseView2;
    ReleaseFiledBaseView *baseView3;
    UIButton             *qrCodeBtn;
    NSString             *qrcodeUrl; //二维码图片
}
@end

@implementation AddAccountsReceivableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setTheme_backgroundColor:THEME_CELL_BACKGROUNDCOLOR];
    //self.view.backgroundColor = navBarColor;
    [self setUpView];
    
    qrcodeUrl = @"";
}

#pragma mark - action
/**
 type_id    string    是    账户类型
 account    string    是    账号
 true_name    string    是    真实姓名
 bank_address    string    否    开户银行 添加银行卡（type_id=1）时必填
 qrcode    string    否    账号二维码
 */
-(void)saveClick{
    if([HelpManager isBlankString:baseView1.inputField.text]){
        printAlert(LocalizationKey(@"Kyc1Tip1"), 1);
        return;
    }
    if([HelpManager isBlankString:baseView2.inputField.text]){
        printAlert(LocalizationKey(@"InputAcount"), 1);
        return;
    }
    if([self.typeId intValue] == 1){
        if([HelpManager isBlankString:baseView3.inputField.text]){
            printAlert(LocalizationKey(@"Input Bank Account"), 1);
            return;
        }
    }
    
    NSDictionary *netDic = @{@"type_id":self.typeId,
                             @"account":baseView2.inputField.text,
                             @"true_name":baseView1.inputField.text,
                             @"bank_address":baseView3.inputField.text,
                             @"qrcode":qrcodeUrl
                             };
    
    AddAccountsReceivableSendVerificationCodeModalVC *mvc = [AddAccountsReceivableSendVerificationCodeModalVC new];
    mvc.sendVerificationCodeWhereJump = SendVerificationCodeWhereJumpAddPayAccount;
    mvc.sendVerificationCodeType = SendVerificationCodeTypeAddAcounts;
    mvc.netDic = [NSMutableDictionary dictionaryWithDictionary:netDic];
    mvc.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    mvc.modalPresentationStyle = UIModalPresentationOverFullScreen;;
    self.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:mvc animated:YES completion:nil];
    
    @weakify(self)
    mvc.backRefreshBlock = ^{
        @strongify(self)
        [self closeVC];
    };
    
   
}

-(void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    printAlert(dict[@"msg"], 1);
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)qrCodeClick{
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
    [qrCodeBtn setImage:nil forState:UIControlStateNormal];
    NSData *imageData = UIImageJPEGRepresentation(resultImage, 0.1);
    [self.afnetWork uploadDataPost:imageData parameters:nil urlString:@"" LoadingInView:self.view];
    [picker dismissViewControllerAnimated:YES completion:nil];
}
//网络上传图片
-(void)getHttpData:(NSDictionary *)dict response:(Response)flag{
    [MBManager hideAlert];
    if(flag == Success){
        if([dict[@"code"] integerValue] == 1){
            qrcodeUrl = [NSString stringWithFormat:@"%@",dict[@"data"][@"url"]];
            [qrCodeBtn sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,dict[@"data"][@"url"]]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"content_icon_tianjia-1"]]; 
        }else{
            NSString *msg = [NSString stringWithFormat:@"%@",dict[@"msg"]];
            printAlert(msg, 1.f);
            [qrCodeBtn setImage:[UIImage imageNamed:@"content_icon_tianjia-1"] forState:UIControlStateNormal];
        }
    }else{
        printAlert(LocalizationKey(@"upload failed"), 1.f);
        [qrCodeBtn setImage:[UIImage imageNamed:@"content_icon_tianjia-1"] forState:UIControlStateNormal];
    }
}

#pragma mark - 代理方法 防止关不掉页面
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ui
-(void)setUpView{
    switch ([self.typeId intValue]) {
        case 1:
            self.gk_navigationItem.title = LocalizationKey(@"Add Bank card");
            break;
        case 2:
            self.gk_navigationItem.title = LocalizationKey(@"Add Alipay");
            break;
        default:
            self.gk_navigationItem.title = LocalizationKey(@"Add WChat");
            break;
    }
    
    baseView1 = [[ReleaseFiledBaseView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, 120)];
    baseView1.rightBtn.hidden = YES;
    baseView1.inputField.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:baseView1];
    
    baseView2 = [[ReleaseFiledBaseView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(baseView1.frame), ScreenWidth, 120)];
    baseView2.rightBtn.hidden = YES;
    baseView2.inputField.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:baseView2];
    
    baseView3 = [[ReleaseFiledBaseView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(baseView2.frame), ScreenWidth, 120)];
    baseView3.rightBtn.hidden = YES;
    baseView3.inputField.keyboardType = UIKeyboardTypeDefault;
    [self.view addSubview:baseView3];
    
    switch ([self.typeId intValue]) {
        case 1:
            [self setUpBankView];
            break;
        case 2:
            [self setUpAliPayView];
            break;
        default:
            [self setUpWeChatView];
            break;
    }
  //  [self setPlaceholderLabel];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    saveBtn.layer.cornerRadius = 3;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn setTitle:LocalizationKey(@"Save") forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:qutesRedColor];
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-20 );
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, 50));
    }];
    [saveBtn addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setUpBankView{
    baseView1.titleLabel.text = LocalizationKey(@"cardholder");
  //  baseView1.inputField.placeholder = LocalizationKey(@"cardholder1");
    
    baseView2.titleLabel.text = LocalizationKey(@"Bank card number");
   
    baseView3.titleLabel.text = LocalizationKey(@"Bank Account");
    baseView1.inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"cardholder1")) attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:18],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
    baseView2.inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"Bank card number1")) attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:18],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
    baseView3.inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"Input Bank Account")) attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:18],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
    
}

-(void)setUpAliPayView{
    baseView1.titleLabel.text = LocalizationKey(@"Name");
  //  baseView1.inputField.placeholder = LocalizationKey(@"Kyc1Tip1");
    baseView2.titleLabel.text = LocalizationKey(@"Alipay Account");
  //  baseView2.inputField.placeholder = LocalizationKey(@"Input Alipay Account");
    
    baseView1.inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"Kyc1Tip1")) attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:18],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
    baseView2.inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"Input Alipay Account")) attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:18],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
   
    [baseView3 removeFromSuperview];
    
    UIView *xian = [UIView new];
     xian.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
    [self.view addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(baseView2.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 2));
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = rgba(144, 157, 180, 1);
    titleLabel.font = tFont(18);
    titleLabel.text = LocalizationKey(@"Add a QR code (optional)");
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(xian.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
    
    qrCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [qrCodeBtn setImage:[UIImage imageNamed:@"content_icon_tianjia-1"] forState:UIControlStateNormal];
    [qrCodeBtn setTheme_backgroundColor:THEME_TRANSFER_BACKGROUNDCOLOR];
    [self.view addSubview:qrCodeBtn];
    [qrCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, (ScreenWidth - 30) /2));
    }];
    
    [qrCodeBtn addTarget:self action:@selector(qrCodeClick) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setUpWeChatView{
    baseView1.titleLabel.text = LocalizationKey(@"Name");
  //  baseView1.inputField.placeholder = LocalizationKey(@"Kyc1Tip1");
    baseView2.titleLabel.text = LocalizationKey(@"WChat Account");
 //   baseView2.inputField.placeholder = LocalizationKey(@"Input WChat Account");
    
    baseView1.inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"Kyc1Tip1")) attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:18],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
    baseView2.inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"Input WChat Account")) attributes:@{ NSFontAttributeName:[UIFont systemFontOfSize:18],SDThemeForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
  
    
    [baseView3 removeFromSuperview];
    
    UIView *xian = [UIView new];
    xian.theme_backgroundColor = THEME_LINE_TABLEVIEW_HEADER_COLOR;
    [self.view addSubview:xian];
    [xian mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(baseView2.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth, 2));
    }];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.textColor = rgba(144, 157, 180, 1);
    titleLabel.font = tFont(18);
    titleLabel.text = LocalizationKey(@"Add a QR code (optional)");
    [self.view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(xian.mas_bottom).offset(15);
        make.left.mas_equalTo(self.view.mas_left).offset(OverAllLeft_OR_RightSpace);
    }];
    
    qrCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [qrCodeBtn setImage:[UIImage imageNamed:@"content_icon_tianjia-1"] forState:UIControlStateNormal];
    [qrCodeBtn setTheme_backgroundColor:THEME_TRANSFER_BACKGROUNDCOLOR];
    [self.view addSubview:qrCodeBtn];
    [qrCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(OverAllLeft_OR_RightSpace);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(10);
        make.size.mas_equalTo(CGSizeMake(ScreenWidth - 30, (ScreenWidth - 30) /2));
    }];
    
    [qrCodeBtn addTarget:self action:@selector(qrCodeClick) forControlEvents:UIControlEventTouchUpInside];
}

//-(void)setPlaceholderLabel{
//    baseView1.inputField.theme_attributedPlaceholder = [[NSAttributedString alloc] initWithString:NSStringFormat(@"%@",LocalizationKey(@"InputNewPassword")) attributes:@{ NSForegroundColorAttributeName:THEME_TEXT_PLACEHOLDERCOLOR}];
//
//    [baseView1.inputField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
//    [baseView2.inputField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
//    [baseView3.inputField setValue:THEME_TEXT_PLACEHOLDERCOLOR forKeyPath:@"_placeholderLabel.theme_textColor"];
//}

#pragma mark - set
-(void)setTypeId:(NSString *)typeId{
    _typeId = typeId;
     
}

@end
