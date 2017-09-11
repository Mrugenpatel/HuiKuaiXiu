//
//  HKXMineOwnerRepairCostViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/8.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineOwnerRepairCostViewController.h"
#import "CommonMethod.h"
#import "HKXHttpRequestManager.h"
#import "HKXMIneOwnerRepairCostModelDataModels.h"

#import "HKXMinePayViewController.h"

@interface HKXMineOwnerRepairCostViewController ()
{
    UIView * _bottomView;
    NSString * _payCount;//待支付总金额
}

@end

@implementation HKXMineOwnerRepairCostViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
}
 
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 60, ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    NSArray * costTitleArray = [NSArray arrayWithObjects:@"工时费",@"配件及附料",@"总计", nil];
    NSArray * costPlaceHolderArray = [NSArray arrayWithObjects:@"输入您的工时费",@"输入您的配件及附料费",@"总金额", nil];
    for (int i = 0;  i < 3;  i ++)
    {
        UILabel * costLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, 22 * myDelegate.autoSizeScaleY + (17 + 22 + 40 + 22) * i * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX)];
        costLabel.text = costTitleArray[i];
        costLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
        [_bottomView addSubview:costLabel];
        
        UITextField * costTF = [[UITextField alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, CGRectGetMaxY(costLabel.frame) + 22 * myDelegate.autoSizeScaleY, 331 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];
        costTF.placeholder = costPlaceHolderArray[i];
        costTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * myDelegate.autoSizeScaleX, costTF.frame.size.height)];
        costTF.tag = 600 + i;
        costTF.leftView.backgroundColor = [UIColor clearColor];
        costTF.leftViewMode = UITextFieldViewModeAlways;
        costTF.borderStyle = UITextBorderStyleRoundedRect;
        costTF.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
        [_bottomView addSubview:costTF];
        
        UILabel * yuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(302 * myDelegate.autoSizeScaleX, 0, 29 * myDelegate.autoSizeScaleX, costTF.frame.size.height)];
        yuanLabel.text = @"元";
        yuanLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
        [costTF addSubview:yuanLabel];
        
        if (i == 2)
        {
            UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            submitBtn.frame = CGRectMake((ScreenWidth - 277 * myDelegate.autoSizeScaleX) / 2, CGRectGetMaxY(costTF.frame) + 89 * myDelegate.autoSizeScaleY, 277 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
            submitBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
            submitBtn.layer.cornerRadius = 2;
            submitBtn.clipsToBounds = YES;
            [submitBtn setTitle:@"确定" forState:UIControlStateNormal];
            [submitBtn addTarget:self action:@selector(payRepaiCostBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:submitBtn];
        }
    }
}
#pragma mark - ConfigData
- (void)loadData
{
    _payCount = 0;
    [HKXHttpRequestManager sendRequestWithRepairId:self.ruoID ToGetOwnerRepairCostResult:^(id data) {
        HKXMIneOwnerRepairCostModel * model = data;
        if (model.success)
        {
            HKXMIneOwnerRepairCostData * data = model.data;
            UITextField * gongShiCostTF = [_bottomView viewWithTag:600];
            gongShiCostTF.text = [NSString stringWithFormat:@"%.2f",data.hourCost ];
            gongShiCostTF.enabled = NO;
            
            UITextField * materialCost = [_bottomView viewWithTag:601];
            materialCost.text = [NSString stringWithFormat:@"%.2f",data.partsCost];
            materialCost.enabled = NO;
            
            UITextField * totalCost = [_bottomView viewWithTag:602];
            totalCost.text = [NSString stringWithFormat:@"%.2f",data.cost];
            totalCost.enabled = NO;
            
            _payCount = [NSString stringWithFormat:@"%.2f",data.cost];
        }
    }];
}
#pragma mark - Action
- (void)payRepaiCostBtnClick:(UIButton *)btn
{
    self.hidesBottomBarWhenPushed = YES;
    
    HKXMinePayViewController * payVC = [[HKXMinePayViewController alloc] init];
    payVC.navigationItem.title = @"支付方式";
    payVC.come = 3;
    payVC.ruoId = _ruoID;
    payVC.payCount = _payCount;
    [self.navigationController pushViewController:payVC animated:YES];
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
