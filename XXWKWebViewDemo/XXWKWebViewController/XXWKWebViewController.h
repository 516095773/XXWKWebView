//
//  XXWKWebViewController.h
//  XXWKWebViewDemo
//
//  Created by xin xu on 2018/5/14.
//  Copyright © 2018年 xin xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface XXWKWebViewController : UIViewController

/*
 网页加载控件
 */
@property (nonatomic, retain) WKWebView *webView;

/*
 加载的URL地址
 */
@property (nonatomic, copy) NSString *webViewUrl;

/*
 进度条颜色设置
 */
@property (nonatomic, retain) UIColor *webViewBarTintColor;

/*
 可以自定义进度条，这里比较懒没有自定义,实现进度条的方法有很多（自行百度）
 */
@property (nonatomic, retain) UIView *progressView;










@end
