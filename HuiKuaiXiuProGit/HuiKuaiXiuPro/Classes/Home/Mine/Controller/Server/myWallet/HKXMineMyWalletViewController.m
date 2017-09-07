//
//  HKXMineMyWalletViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineMyWalletViewController.h"
#import "CommonMethod.h"

#import "HKXHttpRequestManager.h"

#import "HKXMineMyWalletAddViewController.h"
#import "HKXMineMyWalletModelDataModels.h"


@interface HKXMineMyWalletViewController ()<UITableViewDelegate , UITableViewDataSource>
{
    UITableView * _bottomTableView;
}

@property (nonatomic , strong) HKXMineMyWalletData * myWalletModel;//银行卡信息model

@end

@implementation HKXMineMyWalletViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI ];
    
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self configData];
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    
    _bottomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 60, ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60) style:UITableViewStylePlain];
    _bottomTableView.backgroundColor = [UIColor whiteColor];
    _bottomTableView.dataSource = self;
    _bottomTableView.delegate = self;
    
    [self.view addSubview:_bottomTableView];
    
    [_bottomTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
#pragma mark - ConfigData
- (void)configData
{
    long userId = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userDataId"];
    [HKXHttpRequestManager sendRequestWithUserId:[NSString stringWithFormat:@"%ld",(long)userId] ToGetMineMyWalletResult:^(id data) {
        HKXMineMyWalletModel * model = data;
        if (model.success)
        {
            self.isCard = true;
            self.myWalletModel = [model.data firstObject];
            
            [_bottomTableView reloadData];
        }
        else
        {
            self.isCard = false;
//            [self showHint:model.message];
        }
        
    }];
}
#pragma mark - Action
#pragma mark - Private Method
#pragma mark - Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (self.isCard == true)
    {
        return 90 * myDelegate.autoSizeScaleY;
    }
    else
    {
        return 50.5 * myDelegate.autoSizeScaleY;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    没有银行卡
    if (self.isCard == false)
    {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator ;
    }
    
    UILabel * reCardLabel = [cell viewWithTag:40000];
    [reCardLabel removeFromSuperview];
    UILabel * reCardNumLabel = [cell viewWithTag:40001];
    [reCardNumLabel removeFromSuperview];
    
//    银行卡（默认为没有银行卡）
    UILabel * cardLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, 24 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"银行卡" WithFont:14 * myDelegate.autoSizeScaleX], 14 * myDelegate.autoSizeScaleX)];
    cardLabel.text = @"银行卡";
    cardLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
    cardLabel.textColor = [CommonMethod getUsualColorWithString:@"#333333"];
    cardLabel.tag = 40000;
    if (self.isCard == true)
    {
        cardLabel.frame = CGRectMake(22 * myDelegate.autoSizeScaleX, 24 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"建设银行储蓄卡" WithFont:14 * myDelegate.autoSizeScaleX], 14 * myDelegate.autoSizeScaleX);
        cardLabel.text = self.myWalletModel.userName;
    }
    [cell addSubview:cardLabel];
    
//    添加银行卡/银行卡号(默认为添加银行卡)
    UILabel * cardNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(276 * myDelegate.autoSizeScaleX, 24 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"添加银行卡" WithFont:14 * myDelegate.autoSizeScaleX], 14 * myDelegate.autoSizeScaleX)];
    cardNumLabel.tag = 40001;
    cardNumLabel.text = @"添加银行卡";
    cardNumLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
    cardNumLabel.textColor = [CommonMethod getUsualColorWithString:@"#333333"];
    [cell addSubview:cardNumLabel];
    if (self.isCard == true)
    {
        cardNumLabel.frame = CGRectMake(0, 62 * myDelegate.autoSizeScaleY, cell.frame.size.width, 17 * myDelegate.autoSizeScaleX);
//        cardNumLabel.text = @"1234 **** **** 1234";
        cardNumLabel.text = self.myWalletModel.userIdCard;
        cardNumLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isCard == false)
    {
        HKXMineMyWalletAddViewController * addCardVC = [[HKXMineMyWalletAddViewController alloc] init];
        addCardVC.navigationItem.title = @"我的钱包";
        [self.navigationController pushViewController:addCardVC animated:YES];
    }
    
}
#pragma mark - Setters & Getters
- (HKXMineMyWalletData *)myWalletModel
{
    if (!_myWalletModel)
    {
        _myWalletModel = [[HKXMineMyWalletData alloc] init];
    }
    return _myWalletModel;
}
- (void)didReceiveMemoryWarning
{
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
