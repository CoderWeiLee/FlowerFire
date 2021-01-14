//
//  ShareFriendViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/5/21.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "ShareFriendViewController.h"
#import "BDFCustomPhotoAlbum.h"

@interface ShareFriendViewController ()
{
    NSString *_linkStr;
}
@property(nonatomic, strong)UIImageView *qrcodeImageView;
@property(nonatomic, strong)UIButton    *linkTitle;
@end

@implementation ShareFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationBar.hidden = YES;
   
}

- (void)createUI{
    UIImageView *bac = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg4"]];
    bac.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    bac.contentMode = UIViewContentModeScaleToFill;
    [self.view addSubview:bac];
    
    UIButton *dissmissBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    dissmissBtn.titleLabel.font = tFont(15);
    [dissmissBtn setImage:[UIImage gk_imageNamed:@"btn_back_white"] forState:UIControlStateNormal];
    [dissmissBtn addTarget:self action:@selector(backItemClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dissmissBtn];
    dissmissBtn.frame = CGRectMake(OverAllLeft_OR_RightSpace, SafeAreaTopHeight + Height_StatusBar , 30, 30);
   
    UIImageView *titleImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title"]];
    titleImage.contentMode = UIViewContentModeScaleAspectFit;
    [bac addSubview:titleImage];
    [titleImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.top.mas_equalTo(self.view.mas_top).offset(100+Height_StatusBar);
        make.size.mas_equalTo(titleImage.image.size);
    }];
    
    UIImageView *xinImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"xin"]];
    xinImage.contentMode = UIViewContentModeScaleAspectFit;
    [bac addSubview:xinImage];
    [xinImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX).offset(20);
        make.top.mas_equalTo(titleImage.mas_bottom).offset(63);
        make.size.mas_equalTo(xinImage.image.size);
    }];
    
    self.qrcodeImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.qrcodeImageView];
    [self.qrcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(xinImage.mas_centerX).offset(-10);
        make.top.mas_equalTo(xinImage.mas_top).offset(25);
        make.size.mas_equalTo(CGSizeMake(111, 111));
    }];
    [self.qrcodeImageView setUserInteractionEnabled:YES];
    [self.qrcodeImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveQrCodeImage)]];
    
    self.linkTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    self.linkTitle.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.linkTitle setTitle:@"--\n复制链接" forState:UIControlStateNormal];
    self.linkTitle.titleLabel.font = tFont(12);
    self.linkTitle.titleLabel.numberOfLines = 0;
    [self.view addSubview:self.linkTitle];
    [self.linkTitle addTarget:self action:@selector(copyLinkClick) forControlEvents:UIControlEventTouchUpInside];
    [self.linkTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(xinImage.mas_bottom).offset(30);
        make.centerX.mas_equalTo(self.qrcodeImageView.mas_centerX);
    }];
    
 
}

#pragma mark - dataSource
- (void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    [self.afnetWork jsonMallPostDict:@"/api/member/qrCode" JsonDict:md Tag:@"1" LoadingInView:self.view];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    _linkStr = dict[@"data"];
     [self createQRCode:_linkStr qrCodeSize:111];
    [self.linkTitle setTitle:NSStringFormat(@"%@\n复制链接",_linkStr) forState:UIControlStateNormal];
}

-(void)copyLinkClick{
    if([HelpManager isBlankString:_linkStr]){
        printAlert(@"未有链接",1.f);
        return;
    }
    UIPasteboard * pastboard = [UIPasteboard generalPasteboard];
    pastboard.string = _linkStr;
    printAlert(@"复制成功", 1.f);
}

-(void)saveQrCodeImage{
    UIAlertController *ua = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *ua1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *ua2 = [UIAlertAction actionWithTitle:@"保存到相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if([HelpManager isBlankString:self->_linkStr]){
            printAlert(@"未有二维码",1.f);
            return;
        }
        [[BDFCustomPhotoAlbum shareInstance] saveToNewThumb:self.qrcodeImageView.image];
    }];
    [ua addAction:ua1];
    [ua addAction:ua2];
    [self presentViewController:ua animated:YES completion:nil];
}

- (void)createQRCode:(NSString*)string qrCodeSize:(CGFloat)size {
    // 1. 创建一个二维码滤镜实例(CIFilter)
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 滤镜恢复默认设置
    [filter setDefaults];
    
    // 2. 给滤镜添加数据
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    // 使用KVC的方式给filter赋值
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 3. 生成二维码
    CIImage *image = [filter outputImage];

    //4.在中心增加一张图片
    UIImage *img = [self createNonInterpolatedUIImageFormCIImage:image withSize:size];
    
    //5.把中央图片划入二维码里面
    //5.1开启图形上下文
    UIGraphicsBeginImageContext(img.size);
    //5.2将二维码的图片画入
    [img drawInRect:CGRectMake(0, 0, img.size.width, img.size.height)];
    UIImage *centerImg = [UIImage imageNamed:@"AppIcon"];
    CGFloat centerW=img.size.width*0.3;
    CGFloat centerH=centerW;
    CGFloat centerX=(img.size.width-centerW)*0.5;
    CGFloat centerY=(img.size.height -centerH)*0.5;
    [centerImg drawInRect:CGRectMake(centerX, centerY, centerW, centerH)];
    //5.3获取绘制好的图片
    UIImage *finalImg=UIGraphicsGetImageFromCurrentImageContext();
    //5.4关闭图像上下文
    UIGraphicsEndImageContext();

    //6.显示最终二维码
    self.qrcodeImageView.image = finalImg;
}

/**
 *  调用该方法处理图像变清晰
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度以及高度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
