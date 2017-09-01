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
    self.addressArray = [NSMutableArray arrayWithObjects:@"1",@"1", nil];
    [_addressTableView reloadData];
}
#pragma mark - Action
- (void)addNewAddressBtnClick:(UIButton *)btn
{
    NSLog(@"跳转至增添新地址界面");
    HKXMineAddNewReceiveAddressViewController * addNewAddressVC = [[HKXMineAddNewReceiveAddressViewController alloc] init];
    addNewAddressVC.navigationItem.title = @"收货地址";
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
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel * nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * myDelegate.autoSizeScaleX, 14 * myDelegate.autoSizeScaleY, 300 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleX)];
        nameLabel.text = @"万三 12345678912";
        nameLabel.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
        nameLabel.tag = 7001;
        [cell addSubview:nameLabel];
        
        UILabel * addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(30 * myDelegate.autoSizeScaleX, CGRectGetMaxY(nameLabel.frame) + 25 * myDelegate.autoSizeScaleY, 300 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleX)];
        addressLabel.tag = 7002;
        addressLabel.text = @"北京市海淀区大钟寺9号楼京仪大厦2层";
        addressLabel.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
        [cell addSubview:addressLabel];
    }
    
    return cell;
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
