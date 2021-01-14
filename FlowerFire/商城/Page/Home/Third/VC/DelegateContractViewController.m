//
//  DelegateContractViewController.m
//  531Mall
//
//  Created by 王涛 on 2020/6/12.
//  Copyright © 2020 Celery. All rights reserved.
//  代理合同

#import "DelegateContractViewController.h"
#import "EmptyDataView.h"

@interface DelegateContractViewController ()<WKNavigationDelegate>



@end

@implementation DelegateContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self createNavBar];
    [self createUI];
    [self initData];
}

- (void)createNavBar{
    self.gk_navigationItem.title = @"代理合同";
    self.gk_statusBarStyle = UIStatusBarStyleDefault;
}
 
- (void)createUI{
    [self.view addSubview:self.wkWebView];
    
    self.view.ly_emptyView = [EmptyDataView diyCustomEmptyViewWithTarget:self action:@selector(initData)];
}

- (void)initData{
    NSMutableDictionary *md = [NSMutableDictionary dictionaryWithCapacity:2];
    md[@"userid"] = [WTMallUserInfo shareUserInfo].ID;
    md[@"sessionid"] = [WTMallUserInfo shareUserInfo].sessionid;
    [self.afnetWork jsonMallPostDict:@"/api/member/articleInfo" JsonDict:md Tag:@"1"];
}

- (void)dataNormal:(NSDictionary *)dict type:(NSString *)type{
    if(dict[@"data"] != [NSNull null]){
        NSString *htmlStr = NSStringFormat(@"%@",dict[@"data"][@"content"] );
        if([HelpManager isBlankString:htmlStr]){
            printAlert(@"合同无内容", 1.f);
        }else{
            [self.wkWebView loadHTMLString:[self htmlEntityDecode:htmlStr] baseURL:nil];
            [self.view ly_hideEmptyView];
        }
    }else{
        printAlert(@"代理合同已删除", 1.f);
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

- (void)dataErrorHandle:(NSDictionary *)dict type:(NSString *)type{
    [self.view ly_showEmptyView];
}

#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    // 不执行前段界面弹出列表的JS代码，关闭系统的长按保存图片
    [webView evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
 
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
        
        _wkWebView = [[JXBWKWebView alloc] initWithFrame:CGRectMake(0, Height_NavBar, ScreenWidth, ScreenHeight - Height_NavBar) configuration:wkWebConfig];
        _wkWebView.navigationDelegate = self;
        
    }
    return _wkWebView;
}

@end
