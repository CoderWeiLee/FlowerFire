//
//  FFShareFriendViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/9/8.
//  Copyright © 2020 Celery. All rights reserved.
//

#import "FFShareFriendViewController.h"
#import "BDFCustomPhotoAlbum.h"

@interface FFShareFriendViewController ()
{
    UIImageView *_qrCodeImageView;
}
@property(nonatomic, strong)NSString *android_download_url;
@property(nonatomic, strong)NSString *ios_download_url;
@property(nonatomic, strong)NSString *qrCodeUrlString;

@end

@implementation FFShareFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
  //  self.gk_navigationItem.title = @"红包";
    self.gk_navBarAlpha = 0;
    self.gk_backStyle = GKNavigationBarBackStyleWhite;
    self.gk_navTitleColor = KWhiteColor;
    self.gk_statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)initData{
    [self.afnetWork jsonPostDict:@"/api/configset/getBasicset" JsonDict:nil Tag:@"1"];
}
 
#pragma mark - action
- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if([type isEqualToString:@"1"]){
        self.android_download_url = dict[@"data"][@"android_download_url"];
        self.ios_download_url = dict[@"data"][@"ios_download_url"];
        self.qrCodeUrlString = dict[@"data"][@"download_qrcode"];
        [_qrCodeImageView sd_setImageWithURL:[NSURL URLWithString:NSStringFormat(@"%@%@",BASE_URL,self.qrCodeUrlString)]];
         
    }else{
        printAlert(dict[@"msg"], 1.f);
        [self closeVC];
    }
}

- (void)createUI{
    UIImageView *bac = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"share_bac"]];
    bac.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight );
   // bac.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:bac];
      
    UIImageView *share_logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon-1025"]];
    share_logo.frame = CGRectMake(30, Height_NavBar, SCREEN_WIDTH - 60, ceil((SCREEN_WIDTH - 60)/1.5));
    share_logo.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:share_logo];
    
    WTButton *button2 = [[WTButton alloc] initWithFrame:CGRectMake(75,share_logo.bottom + 30, ScreenWidth - 75 * 2, 45) buttonImage:[UIImage imageNamed:@"share_android"] parentView:self.view];
    
    WTButton *button3 = [[WTButton alloc] initWithFrame:CGRectMake(button2.left, button2.bottom + 20, button2.width, 45) buttonImage:[UIImage imageNamed:@"share_ios"] parentView:self.view];
    
    _qrCodeImageView = [[UIImageView alloc] init];
    _qrCodeImageView.backgroundColor = KWhiteColor;
    _qrCodeImageView.frame = CGRectMake((ScreenWidth - 210)/2, button3.bottom + 40, 210, 210);
    [self.view addSubview:_qrCodeImageView];
    [_qrCodeImageView setUserInteractionEnabled:YES];
    [_qrCodeImageView addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(saveQrCodeImage)]];
    
    @weakify(self) //安卓下载
    [button2 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        if(![HelpManager isBlankString:self.android_download_url]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.android_download_url] options:@{} completionHandler:nil];
        }else{
            printAlert(LocalizationKey(@"578Tip162"), 1.f);
        }
       
    }];
     //苹果下载
    [button3 addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strongify(self)
        if(![HelpManager isBlankString:self.ios_download_url]){
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.ios_download_url] options:@{} completionHandler:nil];
        }else{
            printAlert(LocalizationKey(@"578Tip162"), 1.f);
        }
    }];
}

 -(void)saveQrCodeImage{
     UIAlertController *ua = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
     UIAlertAction *ua1 = [UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:nil];
     UIAlertAction *ua2 = [UIAlertAction actionWithTitle:LocalizationKey(@"Save QR code to album") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         if([HelpManager isBlankString:self.qrCodeUrlString]){
             printAlert(LocalizationKey(@"578Tip162"),1.f);
             return;
         }
         [[BDFCustomPhotoAlbum shareInstance] saveToNewThumb:self->_qrCodeImageView.image];
     }];
     [ua addAction:ua1];
     [ua addAction:ua2];
     [self presentViewController:ua animated:YES completion:nil];
 }

@end
