//
//  HKXMineReceiveAddressViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineReceiveAddressViewController.h"
#import "CommonMethod.h"

#import "HKXMineAddNewReceiveAddressViewController.h"//增加新地址界面

#import "HKXHttpRequestManager.h"
#import "HKXMineDefaultAddressExistModelDataModels.h"//查询默认收货地址是否存在
#import "HKXMineAddressListModelDataModels.h"//所有收货地址

@interface HKXMineReceiveAddressViewController ()<UITableViewDelegate , UITableViewDataSource>
{
    UITableView * _addressTableView;//收货地址
}
@property (nonatomic , strong) NSMutableArray * addressArray;//地址列表

@end

@implementation HKXMineReceiveAddressViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self createUI];
    long userId = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userDataId"];
    [HKXHttpRequestManager sendRequestWithUserId:[NSString stringWithFormat:@"%ld",userId] ToGetMineDefaultAddressExistResult:^(id data) {
        HKXMineDefaultAddressExistModel * model = data;
        if (model.success)
        {
            //            查询列表
            [self configData];
        }
        else
        {
            HKXMineAddNewReceiveAddressViewController * addNewAddressVC = [[HKXMineAddNewReceiveAddressViewController alloc] init];
            addNewAddressVC.navigationItem.title = @"收货地址";
            addNewAddressVC.isNew = YES;
            [self.navigationController pushViewController:addNewAddressVC animated:YES];
            
        }
    }];
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
    
    _addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 7 * myDelegate.autoSizeScaleY + 64, ScreenWidth, ScreenHeight  - 30 * myDelegate.autoSizeScaleY - 64) style:UITableViewStylePlain];
    _addressTableView.dataSource = self;
    _addressTableView.delegate = self;
    _addressTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_addressTableView];
    [_addressTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
#pragma mark - ConfigData
- (void)configData
{
    long userId = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userDataId"];
    [HKXHttpRequestManager sendRequestWithUserId:[NSString stringWithFormat:@"%ld",userId] ToGetMineAllConsigneeAddressListResult:^(id data) {
        HKXMineAddressListModel * addressListModel = data;
        if (addressListModel.success)
        {
            [self.addressArray removeAllObjects];
            for (HKXMineAddressListData * addData in addressListModel.data)
            {
                [self.addressArray addObject:addData];
            }
            [_addressTableView reloadData];
        }
        else
        {
            [self showHint:addressListModel.message];
        }
    }];
    
}
#pragma mark - Action
- (void)updateDefaultAddressBtnClick:(UIButton *)btn
{
    long userId = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userDataId"];
    NSInteger index = btn.tag - 7003;
    HKXMineAddressListData * addressData = self.addressArray[index];
    
    [HKXHttpRequestManager sendRequestWithAddId:[NSString stringWithFormat:@"%ld",addressData.addId] WithUserId:[NSString stringWithFormat:@"%ld",userId] ToGetMineUpdateDefaultAddressResult:^(id data) {
        HKXMineAddressListModel * model = data;
        [self showHint:model.message];
        [self configData];
//        [_addressTableView reloadData];//或者在此处修改model的默认属性
    }];
}
- (void)addNewAddressBtnClick:(UIButton *)btn
{
    HKXMineAddNewReceiveAddressViewController * addNewAddressVC = [[HKXMineAddNewReceiveAddressViewController alloc] init];
    addNewAddressVC.navigationItem.title = @"收货地址";
    addNewAddressVC.isNew = YES;
    [self.navigationController pushViewController:addNewAddressVC animated:YES];
}
#pragma mark - Private Method
#pragma mark - Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressArray.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (indexPath.row == self.addressArray.count)
    {
        return 174 * myDelegate.autoSizeScaleY;
    }
    else
    {
        return 80 * myDelegate.autoSizeScaleY;
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
    
    UIButton * reAddBtn = [cell viewWithTag:7000];
    [reAddBtn removeFromSuperview];
    UILabel * reNameLabel = [cell viewWithTag:7001];
    [reNameLabel removeFromSuperview];
    UILabel * reAddressLabel = [cell viewWithTag:7002];
    [reAddressLabel removeFromSuperview];
    UIImageView * reDefaultImg = [cell viewWithTag:6999];
    [reDefaultImg removeFromSuperview];
    for (int i = 7003; i < 7004 + indexPath.row; i ++)
    {
        UIButton * reUpdateBtn = [cell viewWithTag:i];
        [reUpdateBtn removeFromSuperview];
    }
    
    
    
    if (indexPath.row == self.addressArray.count)
    {
        UIButton * addNewAddressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        addNewAddressBtn.frame = CGRectMake(50 * myDelegate.autoSizeScaleX, 75 * myDelegate.autoSizeScaleY, ScreenWidth - 100 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
        addNewAddressBtn.tag = 7000;
        addNewAddressBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
        addNewAddressBtn.layer.cornerRadius = 2;
        addNewAddressBtn.clipsToBounds = YES;
        [addNewAddressBtn setTitle:@"添加新地址" forState:UIControlStateNormal];
        [addNewAddressBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [addNewAddressBtn addTarget:self action:@selector(addNewAddressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:addNewAddressBtn];
    }
    else
    {
        HKXMineAddressListData * addressData = self.addressArray[indexPath.row];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * myDelegate.autoSizeScaleX, 14 * myDelegate.autoSizeScaleY, 300 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleX)];
        nameLabel.text = [NSString stringWithFormat:@"%@ %@",addressData.consignees,addressData.consigneesTel];
        nameLabel.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
        nameLabel.tag = 7001;
        [cell addSubview:nameLabel];
        
        UILabel * addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * myDelegate.autoSizeScaleX, CGRectGetMaxY(nameLabel.frame) + 25 * myDelegate.autoSizeScaleY, 300 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleX)];
        addressLabel.tag = 7002;
//        addressLabel.text = @"北京市海淀区大钟寺9号楼京仪大厦2层";
        addressLabel.text = addressData.consigneesAdd;
        addressLabel.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
        [cell addSubview:addressLabel];
        
        UIButton * updateDefaultBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth / 2, cell.frame.size.height)];
        updateDefaultBtn.tag = 7003 + indexPath.row;
        [updateDefaultBtn addTarget:self action:@selector(updateDefaultAddressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:updateDefaultBtn];
        
        UIImageView * defaultImage = [[UIImageView alloc] initWithFrame:CGRectMake(7 * myDelegate.autoSizeScaleX, 32 * myDelegate.autoSizeScaleY, 16 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleX)];
        if (addressData.defaultSet == 1)
        {
            defaultImage.hidden = NO;
            defaultImage.image = [UIImage imageNamed:@"选择2"];
        }
        else
        {
            defaultImage.hidden = YES;
        }
        
        defaultImage.tag = 6999;
        [cell addSubview:defaultImage];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != self.addressArray.count)
    {
        HKXMineAddressListData * addressData = self.addressArray[indexPath.row];
        HKXMineAddNewReceiveAddressViewController * addNewVC = [[HKXMineAddNewReceiveAddressViewController alloc] init];
        addNewVC.navigationItem.title = @"收货地址";
        addNewVC.isNew = NO;
        addNewVC.addressData = addressData;
        [self.navigationController pushViewController:addNewVC animated:YES];
    }
}
#pragma mark - Setters & Getters
- (NSMutableArray *)addressArray
{
    if (!_addressArray)
    {
        _addressArray = [NSMutableArray array];
    }
    return _addressArray;
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
