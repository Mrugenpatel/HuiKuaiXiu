//
//  HKXRepairMapViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/18.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXRepairMapViewController.h"
#import "CustomSubmitView.h"
#import "CommonMethod.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "HKXRepairMaintainerListViewController.h"
#import "Mypoint.h"

@interface HKXRepairMapViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>
{
    MKMapView * _mapView;
    CLLocationManager * _locationManager;
    UILabel * tipLabel;//提示字符
    UIButton * actionBtn;//立即查看
}

@property(nonatomic ,strong)NSMutableArray * maintainerArr;
@end

@implementation HKXRepairMapViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    [rightBtn setTitle:@"完成" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * right = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    
    
    if (![CLLocationManager locationServicesEnabled])
    {
        CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:@"位置服务不可用" sure:@"确定" sureBtnClick:^{
            [self tapGestureClick];
        } WithAlertHeight:160];
        customAlertView.tag = 501;
        [self.view addSubview:customAlertView];
    }
    else
    {
        [self createUI];
    }
}

- (void)rightBtnClick:(UIButton *)rightBtn{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self confidData];
}
- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoNotification:) name:@"userInfoNotification" object:nil];
}
-(void)userInfoNotification:(NSNotification*)notification{
    
    NSDictionary *dict = [notification userInfo];
    NSString *type=[dict valueForKey:@"machine"];
    if ([type isEqualToString:@"101"]) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:[self.ruoId longLongValue]],@"ruoId",nil];
        NSLog(@"%@",dict);
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"rul/rulbyruo.do"] params:dict success:^(id responseObject) {
            [self.view hideActivity];
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            if ([dicts[@"success"] boolValue] == YES) {
                
                [_mapView removeOverlays:_mapView.overlays];
                [_mapView removeAnnotations:_mapView.annotations];
                NSMutableArray * latitudeAndLongitudeArr = [[NSMutableArray alloc] init];
                latitudeAndLongitudeArr = dicts[@"data"];
                NSMutableArray * latitudeArr = [[NSMutableArray alloc] init];
                NSMutableArray * LongitudeArr = [[NSMutableArray alloc] init];
                NSMutableArray * realNameArr = [[NSMutableArray alloc] init];
                tipLabel.text = [NSString stringWithFormat:@"已有%ld位师傅接单",latitudeAndLongitudeArr.count];
                actionBtn.userInteractionEnabled = YES;
                for (int i = 0; i < latitudeAndLongitudeArr.count; i ++) {
                    
                    [latitudeArr addObject:latitudeAndLongitudeArr[i][@"lat"]]
                    ;
                    [LongitudeArr addObject:latitudeAndLongitudeArr[i][@"lon"]]
                    ;
                    [realNameArr addObject:latitudeAndLongitudeArr[i][@"realName"]]
                    ;
                }
                for (int i = 0; i < latitudeAndLongitudeArr.count; i ++) {
                    
                    CLLocation * loc = [[CLLocation alloc] initWithLatitude:[latitudeArr[i] floatValue] longitude:[LongitudeArr[i] floatValue]];
                    CLLocationCoordinate2D coord = [loc coordinate];
                    Mypoint * point = [[Mypoint alloc] initWithCoordinate:coord andTitle:realNameArr[i]];
                    [_mapView addAnnotation:point];
                }
                
                
            }else if ([dicts[@"success"] boolValue] == NO){
                
                NSLog(@"暂无维修人员接单");
                
            }
            
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            [self showHint:@"请求失败"];
        }];

    }
    
}

#pragma mark - CreateUI
- (void)createUI
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"报修地图";
    [self setLocationServevice];
}
- (void)setLocationServevice
{
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    if ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways)
    {
        [_locationManager requestAlwaysAuthorization];
    }
    if ([_locationManager respondsToSelector:@selector(allowsBackgroundLocationUpdates)])
    {
        _locationManager.allowsBackgroundLocationUpdates = YES;
    }
    
    _locationManager.distanceFilter = 50;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [_locationManager startUpdatingLocation];
    
    [self createMap];
}
- (void)createMap
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MKUserTrackingModeFollow;
    [self.view addSubview:_mapView];
    
    CLLocationCoordinate2D coordinate = _mapView.userLocation.coordinate;
    
    [_mapView setCenterCoordinate:coordinate animated:YES];;
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 250, 250);
    [_mapView setRegion:region animated:YES];
    UIView * alertView = [[UIView alloc] initWithFrame:CGRectMake(7 * myDelegate.autoSizeScaleX, 503 * myDelegate.autoSizeScaleY , ScreenWidth - 14 * myDelegate.autoSizeScaleX, 123 * myDelegate.autoSizeScaleY)];
    alertView.backgroundColor = [UIColor whiteColor];
    alertView.layer.cornerRadius = 2;
    alertView.clipsToBounds = YES;
    [self.view addSubview:alertView];
    
    tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 25 * myDelegate.autoSizeScaleY, alertView.frame.size.width, 20 * myDelegate.autoSizeScaleX)];
    tipLabel.text = @"正在为您匹配维修师";
    tipLabel.font = [UIFont systemFontOfSize:20 * myDelegate.autoSizeScaleX];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [alertView addSubview:tipLabel];
    
    actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    actionBtn.frame = CGRectMake(42 * myDelegate.autoSizeScaleX, CGRectGetMaxY(tipLabel.frame) + 27 * myDelegate.autoSizeScaleY, 287 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
    actionBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    [actionBtn setTitle:@"立即查看" forState:UIControlStateNormal];
    [actionBtn addTarget:self action:@selector(showServerDetailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    actionBtn.layer.cornerRadius = 2;
    actionBtn.clipsToBounds = YES;
    //先关闭查看按钮互动
    //actionBtn.userInteractionEnabled = NO;
    [alertView addSubview:actionBtn];
}
#pragma mark - ConfigData
- (void)confidData
{
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_address,@"province",nil];
    NSLog(@"%@",dict);
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"rul/allrul.do"] params:dict success:^(id responseObject) {
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue]== YES) {
            
            tipLabel.text = @"正在为您匹配维修师";
            actionBtn.userInteractionEnabled = NO;
            NSMutableArray * latitudeAndLongitudeArr = [[NSMutableArray alloc] init];
            latitudeAndLongitudeArr = dicts[@"data"];
            NSMutableArray * latitudeArr = [[NSMutableArray alloc] init];
            NSMutableArray * LongitudeArr = [[NSMutableArray alloc] init];
            NSMutableArray * realNameArr = [[NSMutableArray alloc] init];
            for (int i = 0; i < latitudeAndLongitudeArr.count; i ++) {
                
                [latitudeArr addObject:latitudeAndLongitudeArr[i][@"lat"]]
                ;
                [LongitudeArr addObject:latitudeAndLongitudeArr[i][@"lon"]]
                ;
                if ([latitudeAndLongitudeArr[i][@"realName"] isKindOfClass:[NSNull class]]) {
                    
                    [realNameArr addObject:@""];
                }else{
                [realNameArr addObject:latitudeAndLongitudeArr[i][@"realName"]]
                ;
                }
            }
            for (int i = 0; i < latitudeAndLongitudeArr.count; i ++) {
                
                CLLocation * loc = [[CLLocation alloc] initWithLatitude:[latitudeArr[i] floatValue] longitude:[LongitudeArr[i] floatValue]];
                CLLocationCoordinate2D coord = [loc coordinate];
                Mypoint * point = [[Mypoint alloc] initWithCoordinate:coord andTitle:realNameArr[i]];
                [_mapView addAnnotation:point];
            }
            
        }else{
            
            [self showHint:dicts[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        [self showHint:@"请求失败"];
    }];
    
    //根据经纬度在地图上显示维修师傅位置
//    NSArray * arr = @[@"40.04484",@"39.93065"];
//    NSArray * arr1 = @[@"116.27802",@"116.428703"];
//    for (int i = 0; i < 2; i ++) {
//        
//        CLLocation * loc = [[CLLocation alloc] initWithLatitude:[arr[i] floatValue] longitude:[arr1[i] floatValue]];
//        CLLocationCoordinate2D coord = [loc coordinate];
//        Mypoint * point = [[Mypoint alloc] initWithCoordinate:coord andTitle:@"经纬度"];
//        [_mapView addAnnotation:point];
//        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 10000, 10000);
//        [_mapView setRegion:region animated:YES];
//    }
    
    //    CLLocation * loc = [[CLLocation alloc] initWithLatitude:[@"40.04484" floatValue] longitude:[@"116.27802" floatValue]];
    //    CLLocationCoordinate2D coord = [loc coordinate];
    //    Mypoint * point = [[Mypoint alloc] initWithCoordinate:coord andTitle:@"经纬度"];
    //    [_mapView addAnnotation:point];
    //    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coord, 250, 250);
    //    [_mapView setRegion:region animated:YES];
}


#pragma mark - Action
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


- (void)showServerDetailBtnClick:(UIButton *)btn
{
    
    NSLog(@"跳转至抢单师傅界面");
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:[self.ruoId longLongValue]],@"ruoId",nil];
    NSLog(@"%@",dict);
    
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"repair/selectRepairInfo.do"] params:dict success:^(id responseObject) {
        
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        NSLog(@"%@",dicts[@"message"]);
        _maintainerArr = [[NSMutableArray alloc] init];
        if ([dicts[@"success"] boolValue] == YES) {
            
            [self.view hideActivity];
            _maintainerArr = dicts[@"data"];

            HKXRepairMaintainerListViewController * maintainerListVC = [[HKXRepairMaintainerListViewController alloc] init];
            maintainerListVC.ruoId = _ruoId;
            maintainerListVC.maintainerListArray = [[NSMutableArray alloc] initWithArray:_maintainerArr];
            maintainerListVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:maintainerListVC animated:YES];
            
        }else if ([dicts[@"success"] boolValue] == NO){
            
            [self.view hideActivity];
            [self showHint:dicts[@"message"]];
            
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        [self showHint:@"请求失败"];
    }];
    
}

#pragma mark - MKMapViewDelegate
- (nullable MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[Mypoint class]]){
        // 跟tableViewCell的创建一样的原理
        static NSString *identifier = @"kkk";
        
        MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        
        if (annotationView == nil) {
            
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        }
        annotationView.canShowCallout = YES; // 显示大头针小标题
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        leftBtn.frame = CGRectMake(0, 0, 50, 50);
        leftBtn.backgroundColor = [UIColor orangeColor];
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        rightBtn.frame = CGRectMake(0, 0, 50, 50);
        rightBtn.backgroundColor = [UIColor purpleColor];
        //        annotationView.leftCalloutAccessoryView = leftBtn; // 显示左右按钮
        //        annotationView.rightCalloutAccessoryView = rightBtn;
        // 自定义图片(如果使用系统大头针可以使用<MKPinAnnotationView>类)
        annotationView.image = [UIImage imageNamed:@"挖掘机@2x"];
        
        return annotationView;
        
    }
    return nil; // 设为nil  自动创建系统大头针(唯一区别就是图片的设置)
    
}

#pragma mark - Private Method
#pragma mark - Delegate & Data Source
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
//    CLLocation * location = [locations firstObject];
}
#pragma mark - Setters & Getters
- (NSMutableArray *)maintainerArr{
    
    if (!_maintainerArr) {
        
        _maintainerArr = [NSMutableArray array];
    }
    return _maintainerArr;
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
