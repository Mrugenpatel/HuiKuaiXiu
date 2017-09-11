//
//  HKXMineOwnerRepairListViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/7.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineOwnerRepairListViewController.h"
#import "CommonMethod.h"
#import "CustomSubmitView.h"
#import "HKXHttpRequestManager.h"
#import "HKXMineOwnerRepairListModelDataModels.h"
#import "HKXMineOwnerRepairCostViewController.h"//维修服务费界面
#import "HKXRepairMapViewController.h"//报修地图界面
#import "HKXRepairMaintainerListViewController.h"//抢单师傅列表
#import "HKXMineOwnerRepairDetailViewController.h"//报修抢单详情界面

@interface HKXMineOwnerRepairListViewController ()<UITableViewDelegate , UITableViewDataSource>

{
    UITableView * _repairListTableView;//设备报修列表
}

@property (nonatomic , strong) NSMutableArray * repairListArray;//设备报修列表

@end

@implementation HKXMineOwnerRepairListViewController

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
    
    _repairListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 60, ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60) style:UITableViewStylePlain];
    _repairListTableView.backgroundColor = [UIColor whiteColor];
    _repairListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _repairListTableView.dataSource = self;
    _repairListTableView.delegate = self;
    [self.view addSubview:_repairListTableView];
    
    [_repairListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
#pragma mark - ConfigData
- (void)loadData
{
    long userId = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userDataId"];
    [HKXHttpRequestManager sendRequestWithUserID:[NSString stringWithFormat:@"%ld",userId] WithPageNumber:@"1" WithPageContent:@"8" ToGetAllMineOwnerRepairListResult:^(id data) {
        HKXMineOwnerRepairListModel * model = data;
        
        if (model.success)
        {
            [self.repairListArray removeAllObjects];
            for (HKXMineServerOrderListData * repairData in model.data)
            {
                [self.repairListArray addObject:repairData];
            }
            if (self.repairListArray.count == 0)
            {
                [self showHint:model.message];
            }
            [_repairListTableView reloadData];
        }
        else
        {
            [self showHint:model.message];
        }
    }];
}
#pragma mark - Action
- (void)nextVCBtnClick:(UIButton *)btn
{
    self.hidesBottomBarWhenPushed = YES;
    HKXMineOwnerRepairListData * data = self.repairListArray[btn.tag - 8004];
//TODO:此处待修根据不同的btn的tag值进入不同的界面
    if (data.repairStatus == 5)
    {
        //        待付款可点击
        HKXMineOwnerRepairCostViewController * costVC = [[HKXMineOwnerRepairCostViewController alloc] init];
        costVC.navigationItem.title = @"维修服务费";
        long ruoId = data.repairId;
        costVC.ruoID = [NSString stringWithFormat:@"%ld",ruoId];
        [self.navigationController pushViewController:costVC animated:YES];
    }
    if (data.repairStatus == 2)
    {
        if ([data.repairexplain isEqualToString:@"等待接单"])
        {
            HKXRepairMapViewController * mapVC = [[HKXRepairMapViewController alloc] init];
            mapVC.navigationItem.title = @"抢单地图";
            mapVC.ruoId = [NSString stringWithFormat:@"%f",data.repairId];
            mapVC.address = data.province;
            mapVC.isReceived = NO;
            [self.navigationController pushViewController:mapVC animated:YES];
        }
        else
        {
            HKXRepairMaintainerListViewController * maintainerListVC = [[HKXRepairMaintainerListViewController alloc] init];
            self.navigationItem.title = @"订单列表";
            NSArray * arr = [[NSString stringWithFormat:@"%f",data.repairId] componentsSeparatedByString:@"."];
            maintainerListVC.ruoId = arr[0];
            [self.navigationController pushViewController:maintainerListVC animated:YES];
        }
    }
    if (data.repairStatus == 3 || data.repairStatus == 4)
    {
        CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"维修人员未提供费用清单" content:@"请您联系维修人员尽快提交" sure:@"确定" sureBtnClick:^{
            [self tapGestureClick];
        } WithAlertHeight:160];
        customAlertView.tag = 501;
        [self.view addSubview:customAlertView];
    }
    
    
}
#pragma mark - Private Method
- (void)tapGestureClick
{
    for (UIView * view in self.view.subviews)
    {
        if (view.tag >= 500 && view.tag <= 507 )
        {
            [view removeFromSuperview];
        }
    }
}
#pragma mark - Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.repairListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return 95 * myDelegate.autoSizeScaleY;
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
    
    UILabel * reEquipmentLabel = [cell viewWithTag:8000];
    [reEquipmentLabel removeFromSuperview];
    UILabel * reTroubleTypeLabel = [cell viewWithTag:8001];
    [reTroubleTypeLabel removeFromSuperview];
    UILabel * reTroubleDescribeLabel = [cell viewWithTag:8002];
    [reTroubleDescribeLabel removeFromSuperview];
    UILabel * reTimeLabel = [cell viewWithTag:8003];
    [reTimeLabel removeFromSuperview];
    
    UIButton * reStatusBtn = [cell viewWithTag:8004];
    [reStatusBtn removeFromSuperview];
    
   
    
    HKXMineOwnerRepairListData * data = self.repairListArray[indexPath.row];
    
    UILabel * equipmentLabel = [[UILabel alloc] initWithFrame:CGRectMake(17 * myDelegate.autoSizeScaleX, 15 * myDelegate.autoSizeScaleY, 290 * myDelegate.autoSizeScaleX, 11 * myDelegate.autoSizeScaleX)];
    equipmentLabel.tag = 8000;
    equipmentLabel.font = [UIFont systemFontOfSize:11 * myDelegate.autoSizeScaleX];
    equipmentLabel.text = [NSString stringWithFormat:@"维修设备：%@",data.brandModel];
    [cell addSubview:equipmentLabel];
    
    UILabel * troubleTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(17 * myDelegate.autoSizeScaleX, CGRectGetMaxY(equipmentLabel.frame) + 12 * myDelegate.autoSizeScaleY, 290 * myDelegate.autoSizeScaleX, 11 * myDelegate.autoSizeScaleX)];
    troubleTypeLabel.tag = 8001;
    troubleTypeLabel.font = [UIFont systemFontOfSize:11 * myDelegate.autoSizeScaleX];
    troubleTypeLabel.text = [NSString stringWithFormat:@"故障类型：%@",data.fault];
    [cell addSubview:troubleTypeLabel];
    
    UILabel * troubleDescribeLabel = [[UILabel alloc] initWithFrame:CGRectMake(17 * myDelegate.autoSizeScaleX, CGRectGetMaxY(troubleTypeLabel.frame) + 12 * myDelegate.autoSizeScaleY, 244 * myDelegate.autoSizeScaleX, 11 * myDelegate.autoSizeScaleX)];
    troubleDescribeLabel.tag = 8002;
    troubleDescribeLabel.font = [UIFont systemFontOfSize:11 * myDelegate.autoSizeScaleX];
    troubleDescribeLabel.text = [NSString stringWithFormat:@"故障描述：%@",data.faultInfo];
    [cell addSubview:troubleDescribeLabel];
    
    UILabel * timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(equipmentLabel.frame) + 3 * myDelegate.autoSizeScaleX, 15 * myDelegate.autoSizeScaleY, 63 * myDelegate.autoSizeScaleX, 9 * myDelegate.autoSizeScaleX)];
    timeLabel.tag = 8003;
    timeLabel.font = [UIFont systemFontOfSize:9 * myDelegate.autoSizeScaleX];
    timeLabel.text = [CommonMethod getTimeWithTimeSp:data.createDate];
    timeLabel.textColor = [UIColor lightGrayColor];
    [cell addSubview:timeLabel];
    
    UIButton * statusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    statusBtn.frame = CGRectMake(CGRectGetMaxX(troubleDescribeLabel.frame) + 10 * myDelegate.autoSizeScaleX, CGRectGetMaxY(timeLabel.frame) + 23 * myDelegate.autoSizeScaleY, 95 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY);
    statusBtn.layer.cornerRadius = 2;
    statusBtn.clipsToBounds = YES;
    statusBtn.tag = 8004 + indexPath.row;
    [statusBtn addTarget:self action:@selector(nextVCBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    if (data.repairStatus != 0)
    {
        statusBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa034"];
    }
    else
    {
        statusBtn.backgroundColor = [UIColor colorWithRed:219 / 255.0 green:98 / 255.0 blue:21 / 255.0 alpha:1];
        
    }
    [statusBtn setTitle:data.repairexplain forState:UIControlStateNormal];
    [cell addSubview:statusBtn];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    HKXMineOwnerRepairListData * data = self.repairListArray[indexPath.row];
    if (data.repairStatus == 5 || data.repairStatus == 0 ) {
        
        HKXMineOwnerRepairDetailViewController * detailVC = [[HKXMineOwnerRepairDetailViewController alloc] init];
        detailVC.navigationItem.title = @"报修详情";
        detailVC.isOwner = true;
        detailVC.repairId = [NSString stringWithFormat:@"%ld",(long)data.repairId];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else{
        
        NSLog(@"其他状态类型无法查看报修详情");
    }
    
}
#pragma mark - Setters & Getters
- (NSMutableArray *)repairListArray
{
    if (!_repairListArray)
    {
        _repairListArray = [NSMutableArray array];
    }
    return _repairListArray;
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
