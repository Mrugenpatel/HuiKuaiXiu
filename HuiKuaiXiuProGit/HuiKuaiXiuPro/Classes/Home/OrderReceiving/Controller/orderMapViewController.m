//
//  orderMapViewController.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/7.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "orderMapViewController.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "Mypoint.h"

#import "CustomSubmitView.h"

@interface orderMapViewController ()<CLLocationManagerDelegate,MKMapViewDelegate>{
    
    MKMapView * _mapView;
    CLLocationManager * _locationManager;
}

@end

@implementation orderMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
#pragma mark - CreateUI
- (void)createUI
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"报修地图";
    [self setLocationServevice];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    CLLocation * loc = [[CLLocation alloc] initWithLatitude:_latitude longitude:_longitude];
    CLLocationCoordinate2D coord = [loc coordinate];
    Mypoint * point = [[Mypoint alloc] initWithCoordinate:coord andTitle:@""];
    [_mapView addAnnotation:point];
    
    if ([self.mark isEqualToString:@"接单列表"]) {
        
        
    }else{
            
        UITapGestureRecognizer *mTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPress:)];
        [_mapView addGestureRecognizer:mTap];
            
    }

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

//自动定位
- (void)chooseAddress:(UIButton *)btn{
    
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
        NSLog(@"请开启定位功能！");
    }
}

//代理,定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    
    CLGeocoder * _geocoder = [[CLGeocoder alloc] init];;
    
    //NSLog(@"%lu",(unsigned long)locations.count);
    CLLocation * location = locations.lastObject;
    // 纬度
    CLLocationDegrees latitude = location.coordinate.latitude;
    // 经度
    CLLocationDegrees longitude = location.coordinate.longitude;
    // NSLog(@"%@",[NSString stringWithFormat:@"%lf", location.coordinate.longitude]);
    //    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f", location.coordinate.longitude, location.coordinate.latitude,location.altitude,location.course,location.speed);
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"%@",placemark.name);
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            // 位置名
            //          NSLog(@"name,%@",placemark.name);
            //           // 街道
            //          NSLog(@"thoroughfare,%@",placemark.thoroughfare);
            //           // 子街道
            //           NSLog(@"subThoroughfare,%@",placemark.subThoroughfare);
            //          // 市
            //          NSLog(@"locality,%@",placemark.locality);
            //              // 区
            //          NSLog(@"subLocality,%@",placemark.subLocality);
            //            // 国家
            //         NSLog(@"country,%@",placemark.country);
            UITextField * tf = [self.view viewWithTag:20001];
            tf.text = [NSString stringWithFormat:@"%@%@%@",placemark.administrativeArea,placemark.locality,placemark.name];
            
        }else if (error == nil && [placemarks count] == 0) {
            NSLog(@"No results were returned.");
        } else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];
    [manager stopUpdatingLocation];//不用的时候关闭更新位置服务
    
}
- (void)tapPress:(UIGestureRecognizer *)tap{
    
    [_mapView removeOverlays:_mapView.overlays];
    [_mapView removeAnnotations:_mapView.annotations];
    CGPoint touchPoint = [tap locationInView:_mapView];//这里touchPoint是点击的某点在地图控件中的位置
    CLLocationCoordinate2D touchMapCoordinate =
    [_mapView convertPoint:touchPoint toCoordinateFromView:_mapView];//这里touchMapCoordinate就是该点的经纬度了
    Mypoint * point = [[Mypoint alloc] initWithCoordinate:touchMapCoordinate andTitle:@""];
    [_mapView addAnnotation:point];
    
    //反向编码获取地址
     CLGeocoder * _geocoder = [[CLGeocoder alloc] init];;
    //NSLog(@"%lu",(unsigned long)locations.count);
    // 纬度
    CLLocationDegrees latitude = touchMapCoordinate.latitude;
    // 经度
    CLLocationDegrees longitude = touchMapCoordinate.longitude;
     CLLocation *location = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
    // NSLog(@"%@",[NSString stringWithFormat:@"%lf", location.coordinate.longitude]);
    //    NSLog(@"经度：%f,纬度：%f,海拔：%f,航向：%f,行走速度：%f", location.coordinate.longitude, location.coordinate.latitude,location.altitude,location.course,location.speed);
    
    [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            CLPlacemark *placemark = [placemarks objectAtIndex:0];
            NSLog(@"%@",placemark.name);
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            // 位置名
            //          NSLog(@"name,%@",placemark.name);
            //           // 街道
            //          NSLog(@"thoroughfare,%@",placemark.thoroughfare);
            //           // 子街道
            //           NSLog(@"subThoroughfare,%@",placemark.subThoroughfare);
            //          // 市
            //          NSLog(@"locality,%@",placemark.locality);
            //              // 区
            //          NSLog(@"subLocality,%@",placemark.subLocality);
            //            // 国家
            //         NSLog(@"country,%@",placemark.country);
            if (self.returnAdressBlock) {
                
                self.returnAdressBlock([NSString stringWithFormat:@"%@,%@,%@%@%@",[NSString stringWithFormat:@"%f",latitude],[NSString stringWithFormat:@"%f",longitude],placemark.administrativeArea,placemark.locality,placemark.name]);
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }else if (error == nil && [placemarks count] == 0) {
            NSLog(@"No results were returned.");
        } else if (error != nil){
            NSLog(@"An error occurred = %@", error);
        }
    }];

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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
