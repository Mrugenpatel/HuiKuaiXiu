//
//  HKXMineMyWalletAddViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineMyWalletAddViewController.h"
#import "CommonMethod.h"

@interface HKXMineMyWalletAddViewController ()
{
    UIView * _bottomView;
}

@end

@implementation HKXMineMyWalletAddViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1];
    self.navigationItem.title = @"我的钱包";
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 60 + 10 * myDelegate.autoSizeScaleY, ScreenWidth, ScreenHeight - 20 - 60 - 10 * myDelegate.autoSizeScaleY)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.tag = 9000;
    [self.view addSubview:_bottomView];
    
    NSArray * placeHolderArray = @[@"输入您的银行卡号",@"输入持卡人的姓名",@"输入开户行地址"];
    for (int i = 0; i < placeHolderArray.count; i ++)
    {
        UITextField * pswTF = [[UITextField alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY + (10 + 40) * i * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];
        
        pswTF.placeholder = placeHolderArray[i];
        pswTF.tag = 8000 + i;
        pswTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * myDelegate.autoSizeScaleX, pswTF.frame.size.height)];
        pswTF.leftView.backgroundColor = [UIColor clearColor];
        pswTF.leftViewMode = UITextFieldViewModeAlways;
        pswTF.borderStyle = UITextBorderStyleRoundedRect;
        [_bottomView addSubview:pswTF];
        
        if (i == placeHolderArray.count - 1)
        {
            UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            submitBtn.frame = CGRectMake(98 / 2 * myDelegate.autoSizeScaleX , CGRectGetMaxY(pswTF.frame) + 172 * myDelegate.autoSizeScaleY, 554 / 2 * myDelegate.autoSizeScaleX , 87 / 2 * myDelegate.autoSizeScaleY);
            submitBtn.layer.cornerRadius = 3 * myDelegate.autoSizeScaleY;
            submitBtn.clipsToBounds = YES;
            [submitBtn setTitle:@"确 定" forState:UIControlStateNormal];
            submitBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
            [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:submitBtn];
        }
        
    }
   
    
    
}
#pragma mark - ConfigData
#pragma mark - Action
- (void)submitBtnClick
{
    NSLog(@"提交银行卡信息");
}
#pragma mark - Private Method
#pragma mark - Delegate & Data Source
#pragma mark - Setters & Getters

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
