//
//  HKXRegistNegotiateViewController.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/9/7.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXRegistNegotiateViewController.h"

@interface HKXRegistNegotiateViewController ()<UIWebViewDelegate>{
    
    UIWebView * webView;
}

@end

@implementation HKXRegistNegotiateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"注册协议";
    NSString * urlStr =[NSString stringWithFormat:@"%@",@"http://192.168.1.104:8080/hkx/about.html"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    webView.backgroundColor = [UIColor whiteColor];
    webView.delegate = self;
    [webView loadRequest:request];
    [self.view addSubview:webView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
