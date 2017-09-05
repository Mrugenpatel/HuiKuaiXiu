//
//  HKXOrderReceivingViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/29.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXOrderReceivingViewController.h"
#import "CommonMethod.h"

#import "HKXOrderDetailViewController.h"

#import "repairListModel.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "UIImageView+WebCache.h"
#import "orderMapViewController.h"
#import "repairCostViewController.h"
#import "JGDownListMenu.h"
#import "HKXOrderReceivingListTableViewCell.h"

@interface HKXOrderReceivingViewController ()<UITableViewDelegate , UITableViewDataSource,CLLocationManagerDelegate,UITabBarControllerDelegate,DownListMenuDelegate>
{
    UITableView * _bottomTableView;
    CLLocationDegrees latitude;//维修人员所在维度
    CLLocationDegrees longitude;//维修人员所在经度
    UIView * searchView;
    JGDownListMenu * _list;
    int page ;
    NSString * searchString;
}

@property (nonatomic , strong) NSMutableArray * orderListArray;
@property (nonatomic, strong) CLLocationManager * locationManager;
@end

@implementation HKXOrderReceivingViewController


#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.delegate=self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoNotification:) name:@"userInfoNotification" object:nil];
    page = 1;
    searchString = @"";
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([CLLocationManager locationServicesEnabled])
    {
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        _locationManager = [[CLLocationManager alloc] init];
        //设置定位的精度
        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        _locationManager.distanceFilter = 10.0f;
        _locationManager.delegate = self;
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)
        {
            [_locationManager requestAlwaysAuthorization];
            [_locationManager requestWhenInUseAuthorization];
        }
        
        //开始实时定位
        [_locationManager startUpdatingLocation];
    }else {
        
        [self showHint:@"请开启定位功能！"];
        return;
    }
    
    [_bottomTableView.mj_header beginRefreshing];
    
}

-(void)userInfoNotification:(NSNotification*)notification{
    
    NSDictionary *dict = [notification userInfo];
    NSString *type=[dict valueForKey:@"repair"];
    if ([type isEqualToString:@"103"]) {
        
        [_bottomTableView.mj_header beginRefreshing];
    }
}
#pragma mark - CreateUI
- (void)createUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1];
    searchView= [[UIView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 60, ScreenWidth, 50 * myDelegate.autoSizeScaleY)];
    searchView.backgroundColor = [UIColor whiteColor];
    NSArray * searchArr = @[@"维修设备",@"时间",@"故障类型"];
    for (int i = 0; i < 3; i ++) {
        
        UIButton * searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(38 * myDelegate.autoSizeScaleX + 100 * myDelegate.autoSizeScaleX * i, 10 * myDelegate.autoSizeScaleY, 100 * myDelegate.autoSizeScaleX, 30 *myDelegate.autoSizeScaleY)];
        [searchBtn setTitle:searchArr[i] forState:UIControlStateNormal];
        [searchBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa303"] forState:UIControlStateNormal];
        [searchBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [searchBtn setBackgroundColor:[UIColor whiteColor]];
        searchBtn.layer.borderWidth = 0.5f;
        searchBtn.tag = i;
        searchBtn.layer.borderColor = [[CommonMethod getUsualColorWithString:@"#ffa303"] CGColor];
        [searchBtn addTarget:self action:@selector(search:) forControlEvents:UIControlEventTouchUpInside];
        [searchView addSubview:searchBtn];
    }
    [self.view addSubview:searchView];
    
    _bottomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchView.frame), ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60 - 49.5 - 30 * myDelegate.autoSizeScaleY) style:UITableViewStylePlain];
    _bottomTableView.dataSource = self;
    _bottomTableView.delegate = self;
    _bottomTableView.showsVerticalScrollIndicator = NO;
    _bottomTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _bottomTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomTableView];
   
    [_bottomTableView registerClass:[HKXOrderReceivingListTableViewCell class] forCellReuseIdentifier:@"cell"];
    _bottomTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
    
    _bottomTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
}

- (void)search:(UIButton *)searchBtn{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    searchBtn.selected = !searchBtn.selected;
    if (searchBtn.selected) {
        
        [searchBtn setBackgroundColor:[CommonMethod getUsualColorWithString:@"#ffa303"]];
        for (UIButton * btn in searchView.subviews) {
            
            if (btn.tag != searchBtn.tag) {
                
                [btn setBackgroundColor:[UIColor whiteColor]];
                btn.selected = NO;
                if (btn.tag == 2) {
                    
                    [_list removeFromSuperview];
                }
            }
            
        }
        if (searchBtn.tag == 0) {
            
            searchString =@"维修设备";
            [_bottomTableView.mj_header beginRefreshing];
        }else if (searchBtn.tag == 1){
            
            searchString =@"时间";
            [_bottomTableView.mj_header beginRefreshing];
        }else if (searchBtn.tag == 2){
            
            
        }
        
    }else{
        
        [searchBtn setBackgroundColor:[UIColor whiteColor]];
        searchString = @"";
        [_bottomTableView.mj_header beginRefreshing];
    }
    if (searchBtn.tag == 2) {
        
        CGRect rect = CGRectMake(ScreenWidth - 38 * myDelegate.autoSizeScaleX - 80 * myDelegate.autoSizeScaleX ,CGRectGetMaxY(searchView.frame) - 10 * myDelegate.autoSizeScaleY,80 * myDelegate.autoSizeScaleX, 5 * 40);
        if (_list) {
            
            [_list removeFromSuperview];
            
        }
        _list = [[JGDownListMenu alloc] initWithFrame:rect ListDataSource:@[@"液压系统",@"机械部位",@"发动机",@"电路",@"保养"] rowHeight:40 view:searchBtn];
        _list.mark = @"接单列表";
        _list.delegate = self;
        [self.view addSubview:_list];
        
        if (searchBtn.selected == YES)
        {
            [_list showList];
            
            //_msakImg.transform = CGAffineTransformRotate(_msakImg.transform, M_PI);
        }else
        {
            [_list hiddenList];
            
            searchBtn.selected = NO;
            //_msakImg.transform = CGAffineTransformRotate(_msakImg.transform, -M_PI);
        }
    }
    
}

- (void)dropDownListParame:(NSString *)aStr{
    
    for (UIButton * btn in searchView.subviews) {
        

        searchString = aStr;
        [_bottomTableView.mj_header beginRefreshing];
    }
    
}




#pragma mark - ConfigData
- (void)refresh{
    //    经度：lon
    //    纬度：lat
    //    维修人员Id:uId
    //    页码：pageNo
    //    每页数量：pageSize
    //[NSString stringWithFormat:@"%lf",longitude]
    //[NSString stringWithFormat:@"%lf",latitude]
    page = 2;
    if (_orderListArray.count !=0) {
        
        [_orderListArray removeAllObjects];
    }
    [_bottomTableView.mj_header beginRefreshing];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",longitude],@"lon",[NSString stringWithFormat:@"%f",latitude],@"lat",[NSNumber numberWithDouble:uId],@"uId",searchString,@"search",@"1",@"pageNo",@"8",@"pageSize",nil];
    NSLog(@"%@",dict);
    
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"repairOrder/list.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        [_bottomTableView.mj_header endRefreshing];
        if ([dicts[@"success"] boolValue] == YES) {
            
            _orderListArray = [repairListModel ordersWithArray:dicts[@"data"]];
            NSLog(@"%@",_orderListArray);
            [_bottomTableView reloadData];
        }else{
            
            [self showHint:dicts[@"message"]];
            [_bottomTableView reloadData];
        }
        
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [_bottomTableView.mj_header endRefreshing];
        [self.view hideActivity];
        [self showHint:@"请求失败"];
        
    }];
    
}

- (void)loadData{
    
    //    经度：lon
    //    纬度：lat
    //    维修人员Id:uId
    //    页码：pageNo
    //    每页数量：pageSize
    //[NSString stringWithFormat:@"%lf",longitude]
    //[NSString stringWithFormat:@"%lf",latitude]
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",longitude],@"lon",[NSString stringWithFormat:@"%f",latitude],@"lat",[NSNumber numberWithDouble:uId],@"uId",[NSString stringWithFormat:@"%d",page],@"pageNo",@"8",@"pageSize",nil];
    NSLog(@"%@",dict);
    
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"repairOrder/list.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        [_bottomTableView.mj_footer endRefreshing];
        NSMutableArray * tempArr = [[NSMutableArray alloc] init];
        if ([dicts[@"success"] boolValue] == YES) {
            
            tempArr =[repairListModel ordersWithArray:dicts[@"data"]];
            
            for (int i = 0; i < tempArr.count; i ++) {
                
                [_orderListArray addObject:tempArr[i]];
            }
            
            [_bottomTableView reloadData];
            if (tempArr.count != 0) {
                
                page++;
                
            }
        }else{
            
            [self showHint:dicts[@"message"]];
        }
        
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [_bottomTableView.mj_footer endRefreshing];
        [self.view hideActivity];
        [self showHint:@"请求失败"];
        
    }];
    
}
//代理,定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    CLGeocoder * _geocoder = [[CLGeocoder alloc] init];;
    
    //NSLog(@"%lu",(unsigned long)locations.count);
    CLLocation * location = locations.lastObject;
    // 纬度
    latitude = location.coordinate.latitude;
    // 经度
    longitude = location.coordinate.longitude;
    NSLog(@"%@",[NSString stringWithFormat:@"%lf", location.coordinate.longitude]);
    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f", location.coordinate.longitude, location.coordinate.latitude,location.altitude,location.course,location.speed);
    [manager stopUpdatingLocation];//不用的时候关闭更新位置服务
    
}

#pragma mark - Action
- (void)showMapAddressBtnClick:(UIButton *)btn
{
    NSLog(@"跳转至地图定位界面");
    orderMapViewController * map = [[orderMapViewController alloc] init];
    repairListModel * model = _orderListArray[btn.tag];
    CLLocation * location;
    if ([model.latitude isKindOfClass:[NSNull class]] || [model.longitude isKindOfClass:[NSNull class]]) {
        
        location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
        
    }else{
        
        location = [[CLLocation alloc] initWithLatitude:[model.latitude floatValue] longitude:[model.longitude floatValue]];
    }
    
    map.latitude = location.coordinate.latitude;
    map.longitude = location.coordinate.longitude;
    map.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:map animated:YES];
}

#pragma mark - Private Method
#pragma mark - Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.orderListArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    repairListModel * model = _orderListArray[indexPath.row];
    if ([model.appointmentTime isKindOfClass:[NSNull class]]) {
        
        if ([model.repairStatus doubleValue] != 2){
            
            return 426.5 * myDelegate.autoSizeScaleY + 31 * myDelegate.autoSizeScaleY ;
        }else{
            
            return 426.5 * myDelegate.autoSizeScaleY;
        }
        
    }else{
        
        if ([model.repairStatus doubleValue] != 2){
            
            return 466.5 * myDelegate.autoSizeScaleY + 31 * myDelegate.autoSizeScaleY ;
        }else{
            
            return 466.5 * myDelegate.autoSizeScaleY;
        }
    }
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    
    static NSString * cellIdentifier = @"cell";
    HKXOrderReceivingListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell)
    {
        cell = [[HKXOrderReceivingListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
  
    repairListModel * model = _orderListArray[indexPath.row];
    cell.repairModel = model;
    cell.tag = indexPath.row;
    cell.CallTeleBlock = ^(UIGestureRecognizer *tap) {
      
        [self callTele:tap];
    };
    cell.BtnClickBlock = ^(UIButton *btn) {
        
        if (btn.tag > 999) {
            
           [self orderStateBtnClick:btn];
        }else{
            
           [self showMapAddressBtnClick:btn];
        }
       
        
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (void)orderStateBtnClick:(UIButton *)btn
{
    NSLog(@"不同的抢单状态");
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    repairListModel * model = _orderListArray[btn.tag - 1000];
    
    //    21 下一步，维修人员调取下一步接口
    //    22 正在进行，不进行调取接口
    //    2 抢单或预约抢单，调取抢单接口
    //    3 到达现场，维修人员调取到达现场接口
    //    4 待输入金额，跳转维修人员输入金额页面
    [self.view showActivity];
    if ([model.repairStatus doubleValue] == 21) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:[model.repairId doubleValue]],@"ruoId",[NSNumber numberWithDouble:uId],@"uId",nil];
        NSLog(@"%@",dict);
        
        
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"repairOrder/next.do"] params:dict success:^(id responseObject) {
            [self.view hideActivity];
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            if ([dicts[@"success"] boolValue] == YES) {
                
                [_bottomTableView.mj_header beginRefreshing];
                
            }else if ([dicts[@"success"] boolValue] == NO) {
                
                [self showHint:dicts[@"message"]];
            }
            
            
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            [self showHint:@"请求失败"];
        }];
        
    }else if ([model.repairStatus doubleValue] == 22) {
        
        NSLog(@"正在进行的订单");
        [self.view hideActivity];
        [self showHint:@"请等待机主确认"];
        
    }else if ([model.repairStatus doubleValue] == 2) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:[model.repairId doubleValue]],@"ruoId",[NSNumber numberWithDouble:uId],@"uId",nil];
        NSLog(@"%@",dict);
        
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"repairOrder/add.do"] params:dict success:^(id responseObject) {
            [self.view hideActivity];
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            if ([dicts[@"success"] boolValue] == YES) {
                
                
                HKXOrderDetailViewController * orderDetailVC = [[HKXOrderDetailViewController alloc] init];
                orderDetailVC.hidesBottomBarWhenPushed = YES;
                orderDetailVC.repairListModel = _orderListArray[btn.tag - 4011];
                [self.navigationController pushViewController:orderDetailVC animated:YES];
                
            }else if ([dicts[@"success"] boolValue] == NO) {
                
                [_bottomTableView.mj_header beginRefreshing];
                [self showHint:dicts[@"message"]];
            }
            
            
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            [self showHint:@"请求失败"];
        }];
        
    }else if ([model.repairStatus doubleValue] == 3) {
        
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:[model.repairId doubleValue]],@"ruoId",nil];
        NSLog(@"%@",dict);
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"repair/arrive.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            if ([dicts[@"success"] boolValue] == YES) {
                
                [_bottomTableView.mj_header beginRefreshing];
                
            }else if ([dicts[@"success"] boolValue] == NO) {
                
                [self showHint:dicts[@"message"]];
            }
            
            
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            [self showHint:@"请求失败"];
        }];
        
    }else if([model.repairStatus doubleValue] == 4){
        
        repairCostViewController * cost = [[repairCostViewController alloc] init];
        cost.repairId = model.repairId;
        [self.navigationController pushViewController:cost animated:YES];
        
    }
    
    
    
}

- (void)callTele:(UIGestureRecognizer *)gesture{
    
    CGPoint location = [gesture locationInView:_bottomTableView];
    NSIndexPath *indexPath = [_bottomTableView indexPathForRowAtPoint:location];
    repairListModel * model = self.orderListArray[indexPath.row];
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",model.telephone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
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
//点击的时候触发的方法
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (self.tabBarController.selectedIndex==2) {
        
        [_bottomTableView.mj_header beginRefreshing];
    }
    
}
//防止通个页面一直点击tabbar 的方法
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    //    UIViewController *tbselect=tabBarController.selectedViewController;
    //    if([tbselect isEqual:viewController]){
    //
    //        return NO;
    //    }
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
