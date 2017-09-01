//
//  HKXMineOwnerEquipmentListViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineOwnerEquipmentListViewController.h"
#import "CommonMethod.h"

#import "HKXHttpRequestManager.h"
#import "HKXMineOwnerEquipmentListModelDataModels.h"

#import "UIImageView+WebCache.h"

@interface HKXMineOwnerEquipmentListViewController ()<UITableViewDelegate , UITableViewDataSource>
{
    UITableView * _equipmentListTableView;//设备列表
}

@property (nonatomic , strong) NSMutableArray * equipmentListArray ;//机主设备列表

@end

@implementation HKXMineOwnerEquipmentListViewController
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
    
    [self configData];
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    
    _equipmentListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 60, ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60) style:UITableViewStylePlain];
    _equipmentListTableView.backgroundColor = [UIColor whiteColor];
    _equipmentListTableView.dataSource = self;
    _equipmentListTableView.delegate = self;
    [self.view addSubview:_equipmentListTableView];
    
    [_equipmentListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
#pragma mark - ConfigData
- (void)configData
{
    long userId = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userDataId"];
    [HKXHttpRequestManager sendRequestWithUserId:[NSString stringWithFormat:@"%ld",userId] WithPageNo:@"0" WithPageSize:@"1" ToGetMineOwnerAllEquipmentListResult:^(id data) {
        
        HKXMineOwnerEquipmentListModel * model = data;
        if (model.success)
        {
            for (HKXMineOwnerEquipmentListData * modelData in model.data)
            {
                [self.equipmentListArray addObject:modelData];
                
            }
            
            [_equipmentListTableView reloadData];
        }
    }];
}
#pragma mark - Action
#pragma mark - Private Method
#pragma mark - Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.equipmentListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return 114 * myDelegate.autoSizeScaleY;
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
    
    UIImageView * reLogoImage = [cell viewWithTag:3000];
    [reLogoImage removeFromSuperview];
    UILabel * reTitleLabel = [cell viewWithTag:3001];
    [reTitleLabel removeFromSuperview];
    UILabel * reLabelLabel = [cell viewWithTag:3002];
    [reLabelLabel removeFromSuperview];
    UILabel * reNumberLabel = [cell viewWithTag:3003];
    [reNumberLabel removeFromSuperview];

    UILabel * rePhoneLabel = [cell viewWithTag:3005];
    [rePhoneLabel removeFromSuperview];
    
    HKXMineOwnerEquipmentListData * equipmentModel = self.equipmentListArray[indexPath.row];
    
    UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, 102 * myDelegate.autoSizeScaleX, 95 * myDelegate.autoSizeScaleY)];
//    logoImageView.image = [UIImage imageNamed:@"滑动视图示例"];
        [logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,equipmentModel.picture]] placeholderImage:[UIImage imageNamed:@"滑动视图示例"]];
    logoImageView.tag = 3000;
    [cell addSubview:logoImageView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 16 * myDelegate.autoSizeScaleX, 21 * myDelegate.autoSizeScaleY, 184 * myDelegate.autoSizeScaleX, 13 * myDelegate.autoSizeScaleX)];
    titleLabel.tag = 3001;
    titleLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
//    titleLabel.text = @"挖掘机 ";
        titleLabel.text = [NSString stringWithFormat:@"%@",equipmentModel.brand];
    [cell addSubview:titleLabel];
    
    UILabel * labelLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 16 * myDelegate.autoSizeScaleX, CGRectGetMaxY(titleLabel.frame) + 12 * myDelegate.autoSizeScaleY, 184 * myDelegate.autoSizeScaleX, 13 * myDelegate.autoSizeScaleX)];
    labelLabel.tag = 3002;
    labelLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
//    labelLabel.text = @"卡特彼勒（caterpillar）";
        labelLabel.text = equipmentModel.model;
    [cell addSubview:labelLabel];
    
    UILabel * numeberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 16 * myDelegate.autoSizeScaleX,CGRectGetMaxY(labelLabel.frame) + 12 * myDelegate.autoSizeScaleY, 184 * myDelegate.autoSizeScaleX, 13 * myDelegate.autoSizeScaleX)];
    numeberLabel.tag = 3003;
    numeberLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
//    numeberLabel.text = @"XG806F";
        numeberLabel.text = equipmentModel.nameplateNum;
    [cell addSubview:numeberLabel];


    
    return cell;
}

#pragma mark - Setters & Getters
- (NSMutableArray *)equipmentListArray
{
    if (!_equipmentListArray)
    {
        _equipmentListArray = [NSMutableArray array];
    }
    return _equipmentListArray;
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
