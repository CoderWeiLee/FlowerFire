//
//  AnnouncementDetailsViewController.m
//  FlowerFire
//
//  Created by 王涛 on 2020/9/2.
//  Copyright © 2020 Celery. All rights reserved.
//  公告详情

#import "AnnouncementDetailsViewController.h"
#import <JXBWKWebView.h>
#import "EmptyDataView.h"

@interface AnnouncementDetailsViewController ()<WKNavigationDelegate>
 
@property(nonatomic, strong)JXBWKWebView        *wkWebView;
@end

@implementation AnnouncementDetailsViewController

- (void)closeVC{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationItem.title = self.articlesTitle;
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
   
    self.gk_navigationItem.leftBarButtonItem = [UIBarButtonItem gk_itemWithImage:[UIImage gk_imageNamed:@"btn_back_black"] target:self action:@selector(closeVC)];
    
}
 
- (void)createUI{
    [self.view addSubview:self.wkWebView];
    
    self.view.ly_emptyView = [EmptyDataView diyCustomEmptyViewWithTarget:self action:@selector(initData)];
}

- (void)initData{
//    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:1];
//    md[@"article_id"] = self.articleId;
//    [self.afnetWork jsonPostDict:@"/api/article/getArticleCon" JsonDict:md Tag:@"1" LoadingInView:self.view];
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:1];
    md[@"id"] = self.articleId;
    [self.afnetWork jsonGetDict:@"/api/index/getNoticeContent" JsonDict:md Tag:@"1" LoadingInView:self.view];
}

- (void)dataNormal:(NSDictionary *)dict type:(nonnull NSString *)type{
    if(dict[@"data"] != [NSNull null]){
        NSString *htmlStr = NSStringFormat(@"%@",dict[@"data"][@"content"] );
        if([HelpManager isBlankString:htmlStr]){
            printAlert(@"文章无内容", 1.f);
        }else{
            [self.wkWebView loadHTMLString:[self htmlEntityDecode:htmlStr] baseURL:nil];
            [self.view ly_hideEmptyView];
        }
    }else{
        printAlert(@"文章已删除", 1.f);
    }

}

- (NSString*)htmlEntityDecode:(NSString*)string{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    return string;
}
 
- (void)dataErrorHandle:(NSDictionary *)dict type:(nonnull NSString *)type{
    [self.view ly_showEmptyView];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    // 不执行前段界面弹出列表的JS代码，关闭系统的长按保存图片
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];

    @weakify(self)
    [webView evaluateJavaScript:@"document.body.offsetHeight;" completionHandler:^(id Result, NSError * error) {
        @strongify(self)
        NSString *heightStr = [NSString stringWithFormat:@"%@",Result];
              
              //必须加上一点
        CGFloat height = heightStr.floatValue+15.00;
        self.wkWebView.scrollView.contentSize = CGSizeMake(ScreenWidth, height);
        
    }];
}
 
-(JXBWKWebView *)wkWebView{
    if(!_wkWebView){
        //自适应文字和图片
        NSString *jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
        WKUserScript *wkUScript = [[WKUserScript alloc] initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        WKUserContentController *wkUController = [[WKUserContentController alloc] init];
        [wkUController addUserScript:wkUScript];
        WKWebViewConfiguration *wkWebConfig = [[WKWebViewConfiguration alloc] init];
        wkWebConfig.userContentController = wkUController;
        wkWebConfig.allowsInlineMediaPlayback = YES;
        
        _wkWebView = [[JXBWKWebView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar) configuration:wkWebConfig];
        _wkWebView.navigationDelegate = self;
        _wkWebView.scrollView.contentSize = CGSizeZero;
        _wkWebView.scrollView.bounces = NO;
  
    }
    return _wkWebView;
}



@end
