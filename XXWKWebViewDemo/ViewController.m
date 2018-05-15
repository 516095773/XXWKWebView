//
//  ViewController.m
//  XXWKWebViewDemo
//
//  Created by xin xu on 2018/5/8.
//  Copyright © 2018年 xin xu. All rights reserved.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import "XXWKWebViewController.h"
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:((float)((0X151515 & 0xFF0000) >> 16))/255.0 green:((float)((0X151515 & 0xFF00) >> 8))/255.0 blue:((float)(0X151515 & 0xFF))/255.0 alpha:1.0];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]
                                                 }];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
  
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height/2, 200, 40);
    [button setTitle:@"百度一下，你就知道" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)tap:(UIButton *)tap{
    
    XXWKWebViewController *webView = [[XXWKWebViewController alloc] init];
    webView.webViewUrl = @"https://www.baidu.com";
    [self.navigationController pushViewController:webView animated:YES];
}
@end
