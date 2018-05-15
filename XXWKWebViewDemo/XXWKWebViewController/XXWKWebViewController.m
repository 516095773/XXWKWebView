//
//  XXWKWebViewController.m
//  XXWKWebViewDemo
//
//  Created by xin xu on 2018/5/14.
//  Copyright © 2018年 xin xu. All rights reserved.
//

#import "XXWKWebViewController.h"

@interface XXWKWebViewController ()<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler>
@property (nonatomic,weak) CALayer *progressLayer;
@property (nonatomic,retain) UIBarButtonItem *closeButtonitem;
@property (nonatomic,retain) UIBarButtonItem *customBackBarItem;
@end

@implementation XXWKWebViewController

// 网页 WKWebView
- (WKWebView *)webView{
    
    if (_webView == nil) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.selectionGranularity = WKSelectionGranularityDynamic;
        config.allowsInlineMediaPlayback = YES;
        WKPreferences *preferences = [WKPreferences new];
        //是否支持JavaScript
        preferences.javaScriptEnabled = YES;
        //不通过用户交互，是否可以打开窗口
        preferences.javaScriptCanOpenWindowsAutomatically = YES;
        config.preferences = preferences;
        /* 添加用户与js交互的方法
         name: 方法名（JS只能向原生传递一个参数，所以如果有多个参数需要传递，可以让JS传递对象或者JSON字符串即可。）
         */
        [config.userContentController addScriptMessageHandler:self name:@"HelloWorld"];
        
        // 原生调用js方法
        //[webview evaluateJavaScript:“JS语句” completionHandler:^(id _Nullable data, NSError * _Nullable error) {
        //    }];
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) configuration:config];
        /* 加载服务器url的方法*/
        //  例句 ：@"https://www.baidu.com";
        NSString *url = self.webViewUrl;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        [_webView loadRequest:request];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        // 允许手势返回上级页面
        _webView.allowsBackForwardNavigationGestures = YES;
        [self.view addSubview:_webView];
    }
    
    return _webView;
}
// 创建加载进度条
- (UIView *)progressView{
    
    if (_progressView == nil) {
        
        _progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 64,self.view.frame.size.width , 3)];
        _progressView.backgroundColor = [UIColor clearColor];
        CALayer *layer = [CALayer layer];
        layer.frame = CGRectMake(0, 0, 0, 3);
        layer.backgroundColor = [UIColor greenColor].CGColor;
        [_progressView.layer addSublayer:layer];
        self.progressLayer = layer;
    }
    
    return _progressView;
}
// 返回按钮
-(UIBarButtonItem*)customBackBarItem{
    if (!_customBackBarItem) {
        UIImage* backItemImage = [[UIImage imageNamed:@"backItemImage"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIImage* backItemHlImage = [[UIImage imageNamed:@"backItemImage-hl"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        
        UIButton* backButton = [[UIButton alloc] init];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
        [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
        [backButton setImage:backItemImage forState:UIControlStateNormal];
        [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
        [backButton sizeToFit];
        
        [backButton addTarget:self action:@selector(customBackItemClicked) forControlEvents:UIControlEventTouchUpInside];
        _customBackBarItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _customBackBarItem;
}
// 返回按钮
- (void)customBackItemClicked{
    
    [self.webView goBack];
}
// 创建关闭按钮
- (UIBarButtonItem *)closeButtonitem{
    
    if (_closeButtonitem == nil) {
       
        _closeButtonitem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeItemClick:)];
    }
    
    return _closeButtonitem;
}
// 关闭方法
- (void)closeItemClick:(UIBarButtonItem *)closeButtonItem{
    
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // KVO监听
    [self.webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    [self.webView addObserver:self forKeyPath:@"title" options:NSKeyValueObservingOptionNew context:NULL];
    [self.view addSubview:self.progressView];
	
}
#pragma mark - KVO回馈
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [self updataNavigationitems];

    
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressLayer.opacity = 1;
        if ([change[@"new"] floatValue] <[change[@"old"] floatValue]) {
            return;
        }
        self.progressLayer.frame = CGRectMake(0, 0, self.view.frame.size.width*[change[@"new"] floatValue], 3);
        if ([change[@"new"]floatValue] == 1.0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.progressLayer.opacity = 0;
                self.progressLayer.frame = CGRectMake(0, 0, 0, 3);
            });
        }
    }else if ([keyPath isEqualToString:@"title"]){
        //        self.title = change[@"new"];
    }
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message{
    
    if ([message.name isEqualToString:@"HelloWorld"]) {
        
        [self HelloWorld];
        
        NSLog(@"self.helloWorld === %@",message.body);
    }
}
- (void)HelloWorld{
    
}
#pragma mark - WKNavigationDelegate
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    

}

#pragma  mark - updata nav items
- (void)updataNavigationitems{
    
    if (self.webView.canGoBack) {
        UIBarButtonItem *spaceButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceButtonItem.width = -6.5;
        
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [self.navigationItem setLeftBarButtonItems:@[self.closeButtonitem] animated:NO];
        
//        弃用customBackBarItem，使用原生backButtonItem
        [self.navigationItem setLeftBarButtonItems:@[spaceButtonItem,self.customBackBarItem,self.closeButtonitem] animated:NO];
    }else{
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        [self.navigationItem setLeftBarButtonItems:nil];
    }
}
@end
