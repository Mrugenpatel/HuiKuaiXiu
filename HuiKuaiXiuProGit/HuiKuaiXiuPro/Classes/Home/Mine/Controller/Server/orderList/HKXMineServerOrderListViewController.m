//
//  HKXMineServerOrderListViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/14.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineServerOrderListViewController.h"
#import "CommonMethod.h"
#import "HKXHttpRequestManager.h"
#import "HKXMineServerOrderListModelDataModels.h"
#import "CustomSubmitView.h"
#import "HKXMineOwnerRepairDetailViewController.h"//订单详情界面

@interface HKXMineServerOrderListViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView * _bottomOrderListTableView;//订单列表
}

@property (nonatomic , strong) NSMutableArray * orderListArray;//订单列表数组

@end

@implementation HKXMineServerOrderListViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self loadData];
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    
    _bottomOrderListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 60, ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60) style:UITableViewStylePlain];
    _bottomOrderListTableView.backgroundColor = [UIColor whiteColor];
    _bottomOrderListTableView.dataSource = self;
    _bottomOrderListTableView.delegate = self;
    [self.view addSubview:_bottomOrderListTableView];
    
    [_bottomOrderListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
#pragma mark - ConfigData
- (void)loadData
{
    long userId = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userDataId"];
    [self.view showActivity];
    [HKXHttpRequestManager sendRequestWithUserId:[NSString stringWithFormat:@"%ld",userId] WithPageNo:@"1" WithPageSize:@"8" ToGetAllServerOrderListResult:^(id data) {
        [self.view hideActivity];
        HKXMineServerOrderListModel * model = data;
        if (model.success)
        {
            [self.orderListArray removeAllObjects];
            for (HKXMineServerOrderListData * orderData in model.data)
            {
                [self.orderListArray addObject:orderData];
            }
            if (self.orderListArray.count == 0)
            {
                [self showHint:model.message];
            }
            
            [_bottomOrderListTableView reloadData];
        }
        else
        {
//            CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:model.message sure:@"确定" sureBtnClick:^{
//                [self tapGestureClick];
//            } WithAlertHeight:160];
//            customAlertView.tag = 501;
//            [self.view addSubview:customAlertView];
            [self showHint:model.message];
        }
    }];
    
}
#pragma mark - Action
//- (void)tapGestureClick
//{
//    for (UIView * view in self.view.subviews)
//    {
//        if (view.tag >= 500 && view.tag <= 507 )
//        {
//            [view removeFromSuperview];
//        }
//    }
//}
#pragma mark - Private Method
#pragma mark - Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return 80 * myDelegate.autoSizeScaleY;
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
    
    HKXMineServerOrderListData * data = self.orderListArray[indexPath.row];
    
    UILabel * reEquipmentLabel = [cell viewWithTag:70000];
    [reEquipmentLabel removeFromSuperview];
    UILabel * reTroubleTypeLabel = [cell viewWithTag:70001];
    [reTroubleTypeLabel removeFromSuperview];
    UILabel * reMoneyLabel = [cell viewWithTag:70002];
    [reMoneyLabel removeFromSuperview];
    
    UILabel * equipmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleX)];
    equipmentLabel.tag = 70000;
    equipmentLabel.text = [NSString stringWithFormat:@"维修设备：%@",data.brandModel];
    equipmentLabel.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
    [cell addSubview:equipmentLabel];
    
    UILabel * troubleTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, CGRectGetMaxY(equipmentLabel.frame) + 22 * myDelegate.autoSizeScaleX, 277 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleX)];
    troubleTypeLabel.tag = 70001;
    troubleTypeLabel.text = [NSString stringWithFormat:@"故障类型：%@",data.fault];
    troubleTypeLabel.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
    [cell addSubview:troubleTypeLabel];
    
    UILabel * moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(troubleTypeLabel.frame), 54 * myDelegate.autoSizeScaleY, ScreenWidth - 299 * myDelegate.autoSizeScaleX, 15 * myDelegate.autoSizeScaleX)];
    moneyLabel.tag = 70002;
    moneyLabel.textColor = [UIColor redColor];
    if (data.repairStatus == 5)
    {
//        待支付
        moneyLabel.text = @"待支付";
    }
    if (data.repairStatus == 0)
    {
//        已完成
        moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",data.cost];;
    }
    [cell addSubview:moneyLabel];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    HKXMineServerOrderListData * data = self.orderListArray[indexPath.row];
    
    HKXMineOwnerRepairDetailViewController * detailVC = [[HKXMineOwnerRepairDetailViewController alloc] init];
    detailVC.navigationItem.title = @"订单详情";
    detailVC.isOwner = false;
    detailVC.orderData = data;
    [self.navigationController pushViewController:detailVC animated:YES];
}
#pragma mark - Setters & Getters
- (NSMutableArray *)orderListArray
{
    if (!_orderListArray)
    {
        _orderListArray = [NSMutableArray array];
    }
    return _orderListArray;
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
