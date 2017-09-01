//
//  HKXBasicInfoRegisterViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/3.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXBasicInfoRegisterViewController.h"
#import "CommonMethod.h"
#import "HKXOwnerMoreInfoViewController.h"
#import "HKXSupplierMoreInfoViewController.h"
#import "HKXServerMoreInfoViewController.h"

#import "HKXRegisterBasicInfoModel.h"
#import "HKXHttpRequestManager.h"
#import "HKXRegisterResultDataModels.h"
#import "HKXUserLocationModelDataModels.h"

#import "CustomSubmitView.h"

#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

#import "AreaModel.h"
#import "CityModel.h"
#import "ProvinceModel.h"


@interface HKXBasicInfoRegisterViewController ()<CLLocationManagerDelegate ,UIPickerViewDelegate ,UIPickerViewDataSource>
{
    CLLocationManager * _locationManager;
    NSString          * _locationString;
    NSString          * _cityString;//所在城市
    
    UIPickerView *_pickerView;
    NSDictionary *_areaDic;
    NSMutableArray *_provinceArr;
    
    UIView       * _bottomView;
    NSMutableArray *_proArr;
    NSMutableArray *_cityArr;
    NSMutableArray *_areaArr;
}

@property (nonatomic , strong) HKXRegisterBasicInfoModel * infoModel;



@end

@implementation HKXBasicInfoRegisterViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
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
        [self setLocationServevice];
        [self createUI];
        
    }
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication]  delegate];
    self.view.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1];

    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 + 40 + 10 * myDelegate.autoSizeScaleY, ScreenWidth, ScreenHeight - 20 - 60 - 10 * myDelegate.autoSizeScaleY)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    NSArray * placeHolderArray = @[@"输入您的姓名",@"13XXXXXXXX",@"设置您的位置",@"输入您的单位名称（选填）",@"输入您的推荐码（选填）"];
    for (int i = 0; i < 5; i ++)
    {
        UITextField * pswTF = [[UITextField alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY + (10 + 40) * i * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];
        
        pswTF.placeholder = placeHolderArray[i];
        pswTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * myDelegate.autoSizeScaleX, pswTF.frame.size.height)];
        pswTF.leftView.backgroundColor = [UIColor clearColor];
        pswTF.leftViewMode = UITextFieldViewModeAlways;
        pswTF.borderStyle = UITextBorderStyleRoundedRect;
        pswTF.tag = 50000 + i;
        [_bottomView addSubview:pswTF];
        
        if (i == 1)
        {
            pswTF.text = self.userMobile;
            pswTF.enabled = NO;
        }
        
    }

//    地址
    UIButton * addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.frame = CGRectMake(ScreenWidth - 44 * myDelegate.autoSizeScaleX - 30 * myDelegate.autoSizeScaleX + 22 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY + (10 + 40) * 2 * myDelegate.autoSizeScaleY, 30 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY);
    [addressBtn addTarget:self action:@selector(showAddressPickerViewBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:addressBtn];
    
    UIImageView * addressImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 9 * myDelegate.autoSizeScaleY, 15 * myDelegate.autoSizeScaleX, 22 * myDelegate.autoSizeScaleY)];
    addressImage.image = [UIImage imageNamed:@"定位"];
    [addressBtn addSubview:addressImage];
    
    UIButton * nextStepBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nextStepBtn.frame = CGRectMake((ScreenWidth - 274 * myDelegate.autoSizeScaleX) / 2, 10 * myDelegate.autoSizeScaleY + (10 + 40) * 4 * myDelegate.autoSizeScaleY + 40 * myDelegate.autoSizeScaleY + 376 / 2 * myDelegate.autoSizeScaleY, 274 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
    nextStepBtn.layer.cornerRadius = 3 * myDelegate.autoSizeScaleY;
    nextStepBtn.clipsToBounds = YES;
    [nextStepBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextStepBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    nextStepBtn.tag = 20000;
    [nextStepBtn addTarget:self action:@selector(nextStepBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:nextStepBtn];
}
- (void)setLocationServevice
{
    _locationString = [[NSString alloc] init];
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
    
}
#pragma mark - ConfigData
#pragma mark - Action
- (void)showAddressPickerViewBtnClick:(UIButton *)btn
{
    [self.view endEditing:YES];
    UIButton * nextBtn = [_bottomView viewWithTag:20000];
    nextBtn.hidden = !nextBtn.hidden;
    if (nextBtn.hidden)
    {
        [self loading];
    }
    else
    {
        [_pickerView removeFromSuperview];
    }
}
- (void)nextStepBtnClick
{
    UITextField * userNameTF = [_bottomView viewWithTag:50000];
    UITextField * userAddressTF = [_bottomView viewWithTag:50002];
    if ([userNameTF.text isEqualToString:@""] || [userAddressTF.text isEqualToString:@""])
    {
        
        UIView * backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        backGroundView.backgroundColor = [UIColor darkGrayColor];
        backGroundView.alpha = 0.3;
        backGroundView.tag = 500;
        [self.view addSubview:backGroundView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
        [backGroundView addGestureRecognizer:tap];
        CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:@"输入内容不可为空" sure:@"确定" sureBtnClick:^{
                    [self tapGestureClick];
        } WithAlertHeight:160];
        customAlertView.tag = 501;
        [self.view addSubview:customAlertView];
        return;
    }
    self.infoModel.userId = [NSString stringWithFormat:@"%ld",self.userRegisterData.dataIdentifier];
    self.infoModel.realName = userNameTF.text;

    self.infoModel.address = _locationString;
    
    UITextField * companyNameTF = [_bottomView viewWithTag:50003];
    self.infoModel.companyName = [companyNameTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : companyNameTF.text;
    UITextField * inviteCodeTF = [_bottomView viewWithTag:50004];
    self.infoModel.inviteCode = [inviteCodeTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : inviteCodeTF.text;
    [self.view showActivity];
    [HKXHttpRequestManager sendRequestWithBasicInfo:self.infoModel ToGetRegisterResult:^(id data) {
        [self.view hideActivity];
        HKXRegisterResult * model = data;
        if (model.success)
        {
            if ([self.navigationItem.title isEqualToString:@"机主"])
            {
                HKXOwnerMoreInfoViewController * ownerInfoVC = [[HKXOwnerMoreInfoViewController alloc] init];
                ownerInfoVC.userRegisterData = self.userRegisterData;
                [self.navigationController pushViewController:ownerInfoVC animated:YES];
            }
            if ([self.navigationItem.title isEqualToString:@"供应商"])
            {
                HKXSupplierMoreInfoViewController * supplierInfoVC = [[HKXSupplierMoreInfoViewController alloc] init];
                supplierInfoVC.userRegisterData = self.userRegisterData;
                supplierInfoVC.contactName = userNameTF.text;
                supplierInfoVC.phone = self.userMobile;
                supplierInfoVC.companyName = companyNameTF.text;
                supplierInfoVC.companyCity = _cityString;
                [self.navigationController pushViewController:supplierInfoVC animated:YES];
            }
            if ([self.navigationItem.title isEqualToString:@"服务维修"])
            {
                HKXServerMoreInfoViewController * serverInfoVC = [[HKXServerMoreInfoViewController alloc] init];
                serverInfoVC.userRegisterData = self.userRegisterData;
                [self.navigationController pushViewController:serverInfoVC animated:YES];
            }
        }
        else
        {
            
            UIView * backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
            backGroundView.backgroundColor = [UIColor darkGrayColor];
            backGroundView.alpha = 0.3;
            backGroundView.tag = 504;
            [self.view addSubview:backGroundView];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
            [backGroundView addGestureRecognizer:tap];
            CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:model.message sure:@"确定" sureBtnClick:^{
                
                [self tapGestureClick];
            } WithAlertHeight:160];
            customAlertView.tag = 505;
            [self.view addSubview:customAlertView];
            return;
        }
    }];
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
- (void)loading
{
    dispatch_queue_t globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(globalQueue, ^{
        [self prepareData];
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        dispatch_async(mainQueue, ^{
            [self uiConfig];
        });
        
    });
}
- (void)prepareData
{
    //area.plist是字典
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    _areaDic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    
    //city.plist是数组
    NSString *plist = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
    NSMutableArray *dataCity = [[NSMutableArray alloc] initWithContentsOfFile:plist];
    
    _provinceArr = [[NSMutableArray alloc]init];
    for (NSDictionary *dic in dataCity) {
        ProvinceModel *model  = [[ProvinceModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        model.citiesArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in model.cities) {
            CityModel *cityModel = [[CityModel alloc]init];
            [cityModel setValuesForKeysWithDictionary:dic];
            [model.citiesArr addObject:cityModel];
        }
        [_provinceArr addObject:model];
    }
    _proArr = [NSMutableArray arrayWithCapacity:0];
    _cityArr = [NSMutableArray arrayWithCapacity:0];
    _areaArr = [NSMutableArray arrayWithCapacity:0];
    [_proArr addObject:@"请选择"];
    for (ProvinceModel *model in _provinceArr) {
        
        [_proArr addObject:model.name];
    }
    

}
- (void)uiConfig
{
    //picker view 有默认高度216
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 216, ScreenWidth, 216)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [_pickerView selectRow:0 inComponent:0 animated:YES];
    _pickerView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_pickerView];
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 3;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0) {
        return _proArr.count;
    } else if(component == 1){
        // 如果是第二列，返回cities的个数
        return _cityArr.count;
    } else {
        return _areaArr.count;
    }}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (component == 0) {
        NSString *name=_proArr[row];
        
        return name;
    } else if(component == 1){
        NSString *name=_cityArr[row];
        
        return name;
    } else {
        NSString *name=_areaArr[row];
        
        return name;
    }
    
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSInteger selectOne = [pickerView selectedRowInComponent:0];
    NSInteger selectTwo = [pickerView selectedRowInComponent:1];
    NSInteger selectThree = [pickerView selectedRowInComponent:2];
    
//    ProvinceModel *model = _provinceArr[selectOne - 1];
//    CityModel *cityModel = model.citiesArr[selectTwo];
//    NSString *str = [cityModel.code description];
//    NSArray *arr = _areaDic[str];
//    AreaModel *areaModel = [[AreaModel alloc]init];
//    [areaModel setValuesForKeysWithDictionary:arr[selectThree]];
    if(0 == component)
    {
        _cityArr = [[NSMutableArray alloc] init];
        [_areaArr removeAllObjects];
        [pickerView reloadComponent:2];
        if (selectOne < 1) {
            
            [_cityArr removeAllObjects];
            [pickerView reloadComponent:1];
        }else{
        ProvinceModel *model = _provinceArr[selectOne - 1];
        NSMutableArray * city = model.citiesArr;
        [_cityArr addObject:@"请选择"];
        for (CityModel * cityModel in city) {
            
            [_cityArr addObject:cityModel.name];
        }
        [pickerView selectRow:0 inComponent:1 animated:NO];
        [pickerView reloadComponent:1];
        }
    } if(1 == component)
    {
        
        if (selectTwo < 1) {
            
            [_areaArr removeAllObjects];
            [pickerView reloadComponent:2];
        }else if (selectOne < 1){
            
            [_cityArr removeAllObjects];
            [pickerView reloadComponent:1];
        }
        else{
        _areaArr = [[NSMutableArray alloc] init];
        ProvinceModel *model = _provinceArr[selectOne - 1];
        CityModel *cityModel = model.citiesArr[selectTwo - 1];
        NSString *str = [cityModel.code description];
        NSArray *arr = _areaDic[str];
        NSLog(@"%@",arr);
        [_areaArr addObject:@"请选择"];
        for (NSDictionary * area in arr) {
            
            [_areaArr addObject:area[@"name"]];
        }
        [pickerView selectRow:0 inComponent:2 animated:NO];
        [pickerView reloadComponent:2];
        }
    }
    
    
//    self.navigationItem.title = [NSString stringWithFormat:@"省:%@  市:%@  区:%@",model.name,cityModel.name,areaModel.name];
//    NSLog(@"省:%@ 市:%@ 区:%@",model.name,cityModel.name,areaModel.name);
//    UIView * backView = [self.view viewWithTag:1000];
    UITextField * locationTF = [_bottomView viewWithTag:50002];
    _locationString = @"";
    if (_proArr.count != 0 && _cityArr.count != 0 && _areaArr.count != 0) {
        
        if ([_areaArr[selectThree] isEqualToString:@"请选择"] ) {
            
            _locationString = @"";
            
            
        }else{
        
        _locationString = [NSString stringWithFormat:@"%@/%@/%@",_proArr[selectOne],_cityArr[selectTwo],_areaArr[selectThree]];
        }
    }
    //_locationString = [NSString stringWithFormat:@"%@/%@/%@",model.name,cityModel.name,areaModel.name];
    locationTF.text = _locationString;
    //_cityString = cityModel.name;
}
#pragma mark - Delegate & Data Source
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    CLLocation * location = [locations firstObject];
    CLLocationDegrees lat = location.coordinate.latitude;
    CLLocationDegrees lon = location.coordinate.longitude;

    UITextField * locationTF = [_bottomView viewWithTag:50002];
    
//TODO:在此处改变经纬度，实际使用时获得实际地理位置
    NSLog(@"====%f==%f",lat,lon);
    
    // 获取当前所在的城市名
    CLLocation * alocation = [[CLLocation alloc] initWithLatitude:38.020662 longitude:114.517437];
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:alocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];
            //将获得的所有信息显示到label上
            //获取城市
            NSString *city = placemark.locality;
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSString * province = placemark.administrativeArea;
            NSString * region = placemark.subLocality;

//            NSLog(@"===province = %@ city = %@ region = %@",province,city, region);
            _locationString = [NSString stringWithFormat:@"%@/%@/%@",province,city,region];
            locationTF.text = _locationString;
            _cityString = city;
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

#pragma mark - Setters & Getters
- (HKXRegisterBasicInfoModel *)infoModel
{
    if (!_infoModel)
    {
        _infoModel = [HKXRegisterBasicInfoModel getUserModel];
    }
    return _infoModel;
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
