//
//  HKXRepairsViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/29.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXRepairsViewController.h"
#import "CommonMethod.h"

#import "HKXRepairsOrderTimeViewController.h"
#import "HKXRepairMapViewController.h"

#import <SDWebImage/UIButton+WebCache.h>
#import "JGDownListMenu.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#import "UIViewController+HUD.h"
#import "HKXOwnerMoreInfoViewController.h"
#import "orderMapViewController.h"
#import "HKXMyTextView.h"
@interface HKXRepairsViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate,DownListMenuDelegate,CLLocationManagerDelegate,UITextFieldDelegate,UITextViewDelegate>
{
    UIScrollView * _bottomView;
    UIButton * brandButton;//选择设备品牌
    //照片下拉菜单
    UIActionSheet *myActionSheet;
    
    //图片2进制路径
    NSString* filePath;
    
    //选择的图片
    UIImage * equipmentImg;
    
    //获取的机主当前位置信息
    NSString * ownerAddress;
    
    
    NSString * lat;//选择的维度
    NSString * lon;//选择的经度
}

@property (nonatomic, strong) NSMutableArray *brandArr;
@property (nonatomic, strong) JGDownListMenu *list;
@property (nonatomic, copy) NSString  *modleid;
@property (nonatomic, strong) CLLocationManager * locationManager;
@end

@implementation HKXRepairsViewController

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    [self createUI];
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
        [self.view showActivityWithText:@"定位中"];
    }else {
        NSLog(@"请开启定位功能！");
        [self showHint:@"请开启定位功能"];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIView * view = [_bottomView viewWithTag:787878];
    HKXMyTextView * textView = [_bottomView viewWithTag:676767];
    CGRect frame = view.frame;
    frame.origin.y = CGRectGetMaxY(textView.frame) + 23 * myDelegate.autoSizeScaleY;
    view.frame = frame;
    if (textView.frame.size.height > 35 && textView.frame.size.height < 70 ) {
        
        _bottomView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60 + 35);
    }
    if ( textView.frame.size.height > 70 && textView.frame.size.height < 105 ) {
        
        _bottomView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60 + 70);
    }
    if ( textView.frame.size.height > 105 && textView.frame.size.height < 140 ) {
        
        _bottomView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60 + 105);
    }
    if ( textView.frame.size.height > 140 && textView.frame.size.height < 175 ) {
        
        _bottomView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60 + 140);
    }
    
    self.navigationController.navigationBarHidden = NO;
    
}
#pragma mark - CreateUI
- (void)createUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1];
    _bottomView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 60, ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60 - 49.5)];
    _bottomView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60);
    _bottomView.backgroundColor = [UIColor whiteColor];
    _bottomView.bounces = NO;
    _bottomView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_bottomView];
    
    //    文本框
    NSArray * placeHolderContentArray = @[@"设备品牌/型号",@"设备所在地",@"联系人",@"联系人电话",@"设备工作小时",@""];
    for (int i = 0; i < placeHolderContentArray.count; i ++)
    {
        UITextField * contentTF = [[UITextField alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, (10 + 50 * i) * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];
        
        contentTF.tag = 20000 + i;
        contentTF.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
        contentTF.placeholder = placeHolderContentArray[i];
        contentTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * myDelegate.autoSizeScaleX, contentTF.frame.size.height)];
        contentTF.leftView.backgroundColor = [UIColor clearColor];
        contentTF.leftViewMode = UITextFieldViewModeAlways;
        contentTF.borderStyle = UITextBorderStyleRoundedRect;
        [_bottomView addSubview:contentTF];
        if (i == 0) {
            
            brandButton = [UIButton buttonWithType:UIButtonTypeCustom];
            brandButton.frame = CGRectMake(contentTF.frame.size.width + contentTF.frame.origin.x- 32, contentTF.frame.origin.y + 5, 30, 30);
            [brandButton addTarget:self action:@selector(chooseBrand:) forControlEvents:UIControlEventTouchUpInside];
            //[brandButton setImage:[UIImage imageNamed:@"箭头"] forState:UIControlStateNormal];
            brandButton.backgroundColor = [UIColor whiteColor];
            [brandButton setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
            //    [brandButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - brandButton.imageView.frame.size.width + 10, 0 ,0)];
            //    [brandButton setImageEdgeInsets:UIEdgeInsetsMake(0,brandButton.frame.size.width - brandButton.imageView.frame.size.width - 10 , 0, 0)];
            
            
            [_bottomView addSubview:brandButton];
        }
        
        if (i == 1) {
            
            contentTF.delegate = self;
            [contentTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            UIButton * address = [UIButton buttonWithType:UIButtonTypeCustom];
            address.frame = CGRectMake(contentTF.frame.size.width + contentTF.frame.origin.x- 32, contentTF.frame.origin.y + 5, 30, 30);
            [address addTarget:self action:@selector(chooseAddress:) forControlEvents:UIControlEventTouchUpInside];
            address.backgroundColor = [UIColor whiteColor];
            [address setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
            [_bottomView addSubview:address];
        }
        if (i == 1) {
            
            contentTF.userInteractionEnabled = NO;
        }
        if (i == 3) {
            
            contentTF.keyboardType = UIKeyboardTypeNumberPad;
        }
        if (i == 4)
        {
            //            故障
            contentTF.keyboardType = UIKeyboardTypeNumberPad;
            float troubleLabelLength = [CommonMethod getLabelLengthWithString:@"故障" WithFont:17 * myDelegate.autoSizeScaleX];
            UILabel * troubleLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, CGRectGetMaxY(contentTF.frame) + 22 * myDelegate.autoSizeScaleY, troubleLabelLength, 17 * myDelegate.autoSizeScaleX)];
            troubleLabel.text = @"故障";
            troubleLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
            [_bottomView addSubview:troubleLabel];
            
            float serveSpecLabelLength = [CommonMethod getLabelLengthWithString:@"液压系统" WithFont:14 * myDelegate.autoSizeScaleX];
            NSArray * troubleTitleArray = @[@"液压系统",@"机械部位",@"发动机",@"电路",@"保养"];
            for (int j = 0; j < troubleTitleArray.count; j ++)
            {
                int X = j % 3;
                int Y = j / 3;
                UIButton * serveSpecBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(troubleLabel.frame) + 16 * myDelegate.autoSizeScaleX + X * (38 * myDelegate.autoSizeScaleX + serveSpecLabelLength), CGRectGetMaxY(contentTF.frame) + 22 * myDelegate.autoSizeScaleY + Y * 49 * myDelegate.autoSizeScaleY, 12 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX)];
                [serveSpecBtn setImage:[UIImage imageNamed:@"复选框-未选中"] forState:UIControlStateNormal];
                [serveSpecBtn setImage:[UIImage imageNamed:@"复选框_已选择"] forState:UIControlStateSelected];
                
                serveSpecBtn.selected = NO;
                serveSpecBtn.tag = 30000 + j;
                [serveSpecBtn addTarget:self action:@selector(selectTroubleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                [_bottomView addSubview:serveSpecBtn];
                
                UILabel * troubleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(serveSpecBtn.frame) + 10 * myDelegate.autoSizeScaleX, serveSpecBtn.frame.origin.y, serveSpecLabelLength, 14 * myDelegate.autoSizeScaleX)];
                troubleLabel.text = troubleTitleArray[j];
                troubleLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
                [_bottomView addSubview:troubleLabel];
            }
        }
        if (i == 5)
        {
            float detailLabelLength = [CommonMethod getLabelLengthWithString:@"液压系统" WithFont:17 * myDelegate.autoSizeScaleX];
            
            contentTF.frame = CGRectMake(22 * myDelegate.autoSizeScaleX, (10 + 50 * i) * myDelegate.autoSizeScaleY + 98 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 0);
            HKXMyTextView * textView = [[HKXMyTextView alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, (10 + 50 * i) * myDelegate.autoSizeScaleY + 98 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 0)];
            textView.delegate = self;
            textView.font = [UIFont systemFontOfSize:18];
            textView.tag = 676767;
            textView.layer.borderColor = [UIColor grayColor].CGColor;
            textView.layer.borderWidth = 0.5;
            textView.layer.cornerRadius = 4.0f;
            textView.layer.masksToBounds = YES;
            textView.placeholder = @"设备故障简要描述";
            textView.placeholderColor = [UIColor lightGrayColor];
            textView.verticalSpacing = 10;
            textView.textContainerInset = UIEdgeInsetsMake(15, 10, 15, 10);
            textView.textViewAutoHeight = ^(CGFloat height){
            };
            textView.maxHeight = 140 * myDelegate.autoSizeScaleY;
            textView.minHeight = 35 * myDelegate.autoSizeScaleY;
            textView.backgroundColor = [UIColor whiteColor];
            textView.text = @"";
            [_bottomView addSubview:textView];
            //            上传详情
            
            UIView * view = [[UIView alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, CGRectGetMaxY(textView.frame) + 23 * myDelegate.autoSizeScaleY, ScreenWidth, ScreenHeight)];
            view.tag = 787878;
            [_bottomView addSubview:view];
            UILabel * detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, detailLabelLength, 17 * myDelegate.autoSizeScaleX)];
            detailLabel.text = @"上传详情";
            detailLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
            [view addSubview:detailLabel];
            
            UIButton * detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            detailBtn.frame = CGRectMake(CGRectGetMaxX(detailLabel.frame) + 16 * myDelegate.autoSizeScaleX, 0, 97 * myDelegate.autoSizeScaleX, 61 * myDelegate.autoSizeScaleY);
            detailBtn.tag = 8990;
            CAShapeLayer *border = [CAShapeLayer layer];
            border.strokeColor = [CommonMethod getUsualColorWithString:@"#a0a0a0"].CGColor;
            border.fillColor = nil;
            border.path = [UIBezierPath bezierPathWithRect:detailBtn.bounds].CGPath;
            border.frame = detailBtn.bounds;
            border.lineWidth = 0.5;
            border.lineCap = @"square";
            border.lineDashPattern = @[@4, @2];
            [detailBtn.layer addSublayer:border];
            [detailBtn addTarget:self action:@selector(openPhotoLibraryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:detailBtn];
            
            UIImageView * addImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"添加"]];
            addImage.frame = CGRectMake(37.5 * myDelegate.autoSizeScaleX, 20 * myDelegate.autoSizeScaleY, 22 * myDelegate.autoSizeScaleX, 22 * myDelegate.autoSizeScaleX);
            [detailBtn addSubview:addImage];
            
            //            维修时间
            NSArray * btnTitleArray = @[@"预约维修",@"立即维修"];
            NSArray * btnBGColorArray = @[@"#e06e15",@"#ffa304"];
            for (int i = 0; i < 2; i ++)
            {
                UIButton * actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                actionBtn.frame = CGRectMake(( (150 + 31) * i) * myDelegate.autoSizeScaleX, CGRectGetMaxY(detailBtn.frame) + 28 * myDelegate.autoSizeScaleY, 150 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
                [actionBtn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
                [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                actionBtn.backgroundColor = [CommonMethod getUsualColorWithString:btnBGColorArray[i]];
                actionBtn.tag = 50000 + i;
                [actionBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                actionBtn.layer.cornerRadius = 2;
                actionBtn.clipsToBounds = YES;
                [view addSubview:actionBtn];
            }
        }
    }
}


- (void)textViewDidChange:(UITextView *)textView{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIView * view = [_bottomView viewWithTag:787878];
    
    CGRect frame = view.frame;
    frame.origin.y = CGRectGetMaxY(textView.frame) + 23 * myDelegate.autoSizeScaleY;
    view.frame = frame;
    if ( textView.frame.size.height > 35 && textView.frame.size.height < 70 ) {
        
        _bottomView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60 + 35);
    }
    if ( textView.frame.size.height > 70 && textView.frame.size.height < 105 ) {
        
        _bottomView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60 + 70);
    }
    if ( textView.frame.size.height > 105 && textView.frame.size.height < 140 ) {
        
        _bottomView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60 + 105);
    }
    if ( textView.frame.size.height > 140 && textView.frame.size.height < 175 ) {
        
        _bottomView.contentSize = CGSizeMake(ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60 + 140);
    }
    
}

//控制输入地址字数
- (void)textFieldDidChange:(UITextField *)textField{
    
    int length = 30;//限制的字数
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];       //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position || !selectedRange)
        {
            if (toBeString.length > length)
            {
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:length];
                if (rangeIndex.length == 1)
                {
                    textField.text = [toBeString substringToIndex:length];
                }
                else
                {
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, length)];
                    textField.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        
    }
}

//点击设备品牌/型号
- (void)chooseBrand:(UIButton *)btn{
    
    [self.view endEditing:YES];
    UITextField * tf = [self.view viewWithTag:20000];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:uId],@"id",tf.text,@"search",nil];
    [self.view showActivity];
    [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"machine/brandModel.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        self.brandArr = [[NSMutableArray alloc] init];
        if (_list) {
            
            [_list removeFromSuperview];
            
        }
        if ([dicts[@"data"] isKindOfClass:[NSNull class]]) {
            
            
        }else{

            self.brandArr = dicts[@"data"];
            UITextField * tf = [self.view viewWithTag:20000];
            [self.brandArr addObject:@{@"brandType":@"添加设备"}];
            
            if (self.brandArr.count * 40 > ScreenHeight - tf.frame.origin.y - tf.frame.size.height - 44 - 64 - 40) {
                
                CGRect rect = CGRectMake(ScreenWidth - 100, tf.frame.origin.y + tf.frame.size.height, 80,ScreenHeight - tf.frame.origin.y - tf.frame.size.height - 44 - 64 - 40);
                _list = [[JGDownListMenu alloc] initWithFrame:rect ListDataSource:self.brandArr rowHeight:40 view:brandButton];
            }else{
                
                CGRect rect = CGRectMake(ScreenWidth - 100, tf.frame.origin.y + tf.frame.size.height, 80,self.brandArr.count * 40);
                _list = [[JGDownListMenu alloc] initWithFrame:rect ListDataSource:self.brandArr rowHeight:40 view:brandButton];
            }
            
            _list.mark = @"保修";
            _list.delegate = self;
            [_bottomView addSubview:self.list];
            
            NSLog(@"设备型号");
            btn.selected = !btn.selected;
            if (btn.selected == YES)
            {
                [_list showList];
                //_msakImg.transform = CGAffineTransformRotate(_msakImg.transform, M_PI);
            }else
            {
                [_list hiddenList];
                btn.selected = NO;
                //_msakImg.transform = CGAffineTransformRotate(_msakImg.transform, -M_PI);
            }
        }
  
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        [self showHint:@"请求失败"];
        
    }];
    
}

//自动定位
- (void)chooseAddress:(UIButton *)btn{
    
    if([CLLocationManager locationServicesEnabled])
    {
        
        orderMapViewController * map = [[orderMapViewController alloc] init];
        if (lat.length != 0 && lon.length != 0) {
            
            CLLocation *location = [[CLLocation alloc] initWithLatitude:[lat floatValue] longitude:[lon floatValue]];
            map.latitude = location.coordinate.latitude;
            map.longitude = location.coordinate.longitude;
        }
        
           map.returnAdressBlock = ^(NSString *adress) {
               
            NSArray * arr = [adress componentsSeparatedByString:@","];
            lat = arr[0];
            lon = arr[1];
            adress = arr[2];
            UITextField * tf = [self.view viewWithTag:20001];
            tf.text = [NSString stringWithFormat:@"%@",adress];
            ownerAddress = adress;
            
        };
        [self.navigationController pushViewController:map animated:YES];
        // 启动位置更新
        // 开启位置更新需要与服务器进行轮询所以会比较耗电，在不需要时用stopUpdatingLocation方法关闭;
        //        _locationManager = [[CLLocationManager alloc] init];
        //        //设置定位的精度
        //        [_locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        //        _locationManager.distanceFilter = 10.0f;
        //        _locationManager.delegate = self;
        //        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 8.0)
        //        {
        //            [_locationManager requestAlwaysAuthorization];
        //            [_locationManager requestWhenInUseAuthorization];
        //        }
        //
        //        //开始实时定位
        //        [_locationManager startUpdatingLocation];
        //        [self.view showActivityWithText:@"定位中"];
    }else {
        NSLog(@"请开启定位功能！");
        [self showHint:@"请开启定位功能"];
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
            ownerAddress =[NSString stringWithFormat:@"%@%@",placemark.locality,placemark.name];
            lat = [NSString stringWithFormat:@"%f",latitude];
            lon = [NSString stringWithFormat:@"%f",longitude];
            [self.view hideActivity];
        }else if (error == nil && [placemarks count] == 0) {
            NSLog(@"No results were returned.");
            [self.view hideActivity];
            [self showHint:@"定位失败"];
        } else if (error != nil){
            NSLog(@"An error occurred = %@", error);
            [self.view hideActivity];
            [self showHint:@"定位失败"];
        }
    }];
    
    [manager stopUpdatingLocation];//不用的时候关闭更新位置服务
    
}

-(void)dropDownListParame:(NSString *)aStr
{
    
    NSLog(@"选中设备");
    
    if ([aStr isEqualToString:[NSString stringWithFormat:@"%ld",self.brandArr.count -1]]) {
        
        HKXOwnerMoreInfoViewController * ower = [[HKXOwnerMoreInfoViewController alloc] init];
        brandButton.selected = NO;
        ower.mark = @"报修";
        ower.returnBrandBlock = ^(NSString *type, NSString *brandId) {
            
            UITextField * brandModel = [self.view viewWithTag:20000];
            brandModel.text = type;
        };
        ower.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ower animated:YES];
        
    }else{
        brandButton.selected = NO;
        NSInteger i = [aStr integerValue];
        UITextField * brandTf = [self.view viewWithTag:20000];
        brandTf.text = self.brandArr[i][@"brandType"];
        _modleid =self.brandArr[i][@"modelId"];
        UITextField * realName = [self.view viewWithTag:20002];
        realName.text = self.brandArr[i][@"realName"];
        
        UITextField * telphone = [self.view viewWithTag:20003];
        telphone.text = self.brandArr[i][@"telphone"];
        
        UITextField * workHours = [self.view viewWithTag:20004];
        workHours.text = self.brandArr[i][@"workHours"];
        
    }
    
}

#pragma mark - ConfigData
#pragma mark - Action
- (void)selectTroubleBtnClick:(UIButton *)btn
{
    btn.selected = !btn.selected;
}
- (void)openPhotoLibraryBtnClick:(UIButton *)btn
{
    NSLog(@"打开系统相册");
    NSLog(@"选择照片");
    myActionSheet = [[UIActionSheet alloc]
                     initWithTitle:nil
                     delegate:self
                     cancelButtonTitle:@"取消"
                     destructiveButtonTitle:nil
                     otherButtonTitles:@"从手机相册获取",@"拍照",nil];
    
    [myActionSheet showInView:self.view];
    
}
- (void)actionBtnClick:(UIButton *)btn
{
    self.hidesBottomBarWhenPushed = YES;
    if (btn.tag == 50000)
    {
        NSLog(@"预约维修");
        
        
        //    设备品牌/型号：brandModel
        //    设备ID：mId
        //    设备所在地：address
        //    联系人：contact
        //    联系电话：telephone
        //    设备工作小时数：workHours
        //    故障类型：faultType
        //    故障描述：faultInfo
        //    图片详情：faultInfo
        //    机主id：uId
        //    预约时间：appointmentTime
        UITextField * brandModel = [self.view viewWithTag:20000];
        UITextField * address = [self.view viewWithTag:20001];
        UITextField * contact = [self.view viewWithTag:20002];
        UITextField * telephone = [self.view viewWithTag:20003];
        UITextField * workHours = [self.view viewWithTag:20004];
        HKXMyTextView * faultInfo = [_bottomView viewWithTag:676767];
        
        if ([_modleid isKindOfClass:[NSNumber class]]) {
            
            _modleid = [NSString stringWithFormat:@"%@",_modleid];
        }
        
        if (_modleid.length == 0) {
            
            [self showHint:@"请选择设备品牌/型号"];
            return;
        }
        if (address.text.length == 0) {
            
            [self showHint:@"请选择设备所在地"];
            return;
        }
        if (contact.text.length == 0) {
            
            [self showHint:@"请填入联系人"];
            return;
        }
        if (![[self valiMobile:telephone.text] isEqualToString:@"ok"]) {
            
            [self showHint:@"请正确输入联系人电话"];
            return;
        }
        if (workHours.text.length == 0) {
            
            [self showHint:@"请填入设备工作小时"];
            return;
        }
        UIButton * hydraulicPressureBtn =[self.view viewWithTag:30000];
        UIButton * machineryPartBtn =[self.view viewWithTag:30001];
        UIButton * engineBtn =[self.view viewWithTag:30002];
        UIButton * circuitBtn =[self.view viewWithTag:30003];
        UIButton * maintenanceBtn =[self.view viewWithTag:30004];
        
        NSString * hydraulicPressure;
        NSString * machineryPart;
        NSString * engine;
        NSString * circuit;
        NSString * maintenance;
        NSMutableArray * faultTypeArr = [[NSMutableArray alloc] init];
        if (hydraulicPressureBtn.selected) {
            
            hydraulicPressure  = @"0";
            [faultTypeArr addObject:hydraulicPressure];
        }
        if (machineryPartBtn.selected) {
            
            machineryPart  = @"1";
            [faultTypeArr addObject:machineryPart];
        }
        if (engineBtn.selected) {
            
            engine  = @"2";
            [faultTypeArr addObject:engine];
        }
        if (circuitBtn.selected) {
            
            circuit  = @"3";
            [faultTypeArr addObject:circuit];
        }
        if (maintenanceBtn.selected) {
            
            maintenance  = @"4";
            [faultTypeArr addObject:maintenance];
        }
        if (faultTypeArr.count == 0) {
            
            [self showHint:@"请选择设备故障类型"];
            return;
        }
        if (faultInfo.text.length == 0) {
            
            [self showHint:@"请填入设备故障描述"];
            return;
        }
        NSData *data = UIImageJPEGRepresentation(equipmentImg, 0.3);
        //    if (data == nil) {
        //
        //        [self showHint:@"请选择照片!"];
        //        [CustomAlertView hideHUDForView:self];
        //        return;
        //    }
        // NSData *data = UIImagePNGRepresentation(icon);
        NSString *picture = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        NSString * imageDataString = [NSString stringWithFormat:@"data:image/%@;base64,%@",[self contentTypeForImageData:data],picture];
        NSString * faultType = [faultTypeArr componentsJoinedByString:@","];
        //    NSString * faultType = [NSString stringWithFormat:@"%@%@%@%@%@",hydraulicPressure,machineryPart,engine,circuit,maintenance];
        
        
        HKXRepairsOrderTimeViewController * orderVC = [[HKXRepairsOrderTimeViewController alloc] init];
        orderVC.navigationItem.title = @"预约时间";
        
        orderVC.brandModelId = _modleid;
        orderVC.brandModel = brandModel.text;
        orderVC.address = address.text;
        orderVC.contact = contact.text;
        orderVC.telephone = telephone.text;
        orderVC.workHours = workHours.text;
        
        orderVC.imageDataString = imageDataString;
        orderVC.faultType = faultType;
        orderVC.faultInfo = faultInfo.text;
        orderVC.lat = lat;
        orderVC.lon = lon;
        orderVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:orderVC animated:YES];
        
        
        hydraulicPressureBtn.selected = NO;
   
        machineryPartBtn.selected = NO;
      
        engineBtn.selected = NO;
     
        circuitBtn.selected = NO;
      
        maintenanceBtn.selected = NO;
        
      
        brandModel.text = @"";
      
        address.text = @"";
      
        contact.text = @"";
     
        telephone.text = @"";
      
        workHours.text = @"";
        
        faultInfo.text = @"";
        
        _modleid = @"";
        equipmentImg = nil;
        ownerAddress = @"";
        lat = nil;
        lon = nil;
        UIButton * btn = [self.view viewWithTag:8990];
        [btn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
        
    }
    else
    {
        NSLog(@"立即维修");
        [self immediateRepair];
        
    }
    self.hidesBottomBarWhenPushed = NO;
}

- (void)immediateRepair{
    
    //    设备品牌/型号：brandModel
    //    设备ID：mId
    //    设备所在地：address
    //    联系人：contact
    //    联系电话：telephone
    //    设备工作小时数：workHours
    //    故障类型：faultType
    //    故障描述：faultInfo
    //    图片详情：faultInfo
    //    机主id：uId
    //    预约时间：appointmentTime
    //    经度：lon
    //    纬度：lat
    UITextField * brandModel = [self.view viewWithTag:20000];
    UITextField * address = [self.view viewWithTag:20001];
    UITextField * contact = [self.view viewWithTag:20002];
    UITextField * telephone = [self.view viewWithTag:20003];
    UITextField * workHours = [self.view viewWithTag:20004];
    HKXMyTextView * faultInfo = [_bottomView viewWithTag:676767];
    
    if ([_modleid isKindOfClass:[NSNumber class]]) {
        
        _modleid = [NSString stringWithFormat:@"%@",_modleid];
    }
    
    if (_modleid.length == 0) {
        
        [self showHint:@"请选择设备品牌/型号"];
        return;
    }
    if (address.text.length == 0) {
        
        [self showHint:@"请选择设备所在地"];
        return;
    }
    if (contact.text.length == 0) {
        
        [self showHint:@"请填入联系人"];
        return;
    }
    if (![[self valiMobile:telephone.text] isEqualToString:@"ok"]) {
        
        [self showHint:@"请正确输入联系人电话"];
        return;
    }
    if (workHours.text.length == 0) {
        
        [self showHint:@"请填入设备工作小时"];
        return;
    }
    
    
    
    
    UIButton * hydraulicPressureBtn =[self.view viewWithTag:30000];
    UIButton * machineryPartBtn =[self.view viewWithTag:30001];
    UIButton * engineBtn =[self.view viewWithTag:30002];
    UIButton * circuitBtn =[self.view viewWithTag:30003];
    UIButton * maintenanceBtn =[self.view viewWithTag:30004];
    
    NSString * hydraulicPressure;
    NSString * machineryPart;
    NSString * engine;
    NSString * circuit;
    NSString * maintenance;
    NSMutableArray * faultTypeArr = [[NSMutableArray alloc] init];
    if (hydraulicPressureBtn.selected) {
        
        hydraulicPressure  = @"0";
        [faultTypeArr addObject:hydraulicPressure];
    }
    if (machineryPartBtn.selected) {
        
        machineryPart  = @"1";
        [faultTypeArr addObject:machineryPart];
    }
    if (engineBtn.selected) {
        
        engine  = @"2";
        [faultTypeArr addObject:engine];
    }
    if (circuitBtn.selected) {
        
        circuit  = @"3";
        [faultTypeArr addObject:circuit];
    }
    if (maintenanceBtn.selected) {
        
        maintenance  = @"4";
        [faultTypeArr addObject:maintenance];
    }
    NSData *data = UIImageJPEGRepresentation(equipmentImg, 0.3);
    //    if (data == nil) {
    //
    //        [self showHint:@"请选择照片!"];
    //        [CustomAlertView hideHUDForView:self];
    //        return;
    //    }
    // NSData *data = UIImagePNGRepresentation(icon);
    NSString *picture = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString * imageDataString = [NSString stringWithFormat:@"data:image/%@;base64,%@",[self contentTypeForImageData:data],picture];
    NSString * faultType = [faultTypeArr componentsJoinedByString:@","];
    //    NSString * faultType = [NSString stringWithFormat:@"%@%@%@%@%@",hydraulicPressure,machineryPart,engine,circuit,maintenance];
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:brandModel.text,@"brandModel",[NSNumber numberWithDouble:[_modleid doubleValue]],@"mId",address.text,@"address",contact.text,@"contact",telephone.text,@"telephone",workHours.text,@"workHours",faultType,@"faultType",faultInfo.text,@"faultInfo",imageDataString,@"picture",[NSNumber numberWithDouble:uId],@"uId",lon,@"lon",lat,@"lat",nil];
    NSLog(@"%@",dict);
    
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"repair/add.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue] == YES) {
            
            HKXRepairMapViewController * mapVC = [[HKXRepairMapViewController alloc] init];
            mapVC.address = dicts[@"data"][@"province"];
            mapVC.ruoId = dicts[@"data"][@"ruoId"];
            mapVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:mapVC animated:YES];
            
            
            UIButton * hydraulicPressureBtn =[self.view viewWithTag:30000];
            hydraulicPressureBtn.selected = NO;
            UIButton * machineryPartBtn =[self.view viewWithTag:30001];
            machineryPartBtn.selected = NO;
            UIButton * engineBtn =[self.view viewWithTag:30002];
            engineBtn.selected = NO;
            UIButton * circuitBtn =[self.view viewWithTag:30003];
            circuitBtn.selected = NO;
            UIButton * maintenanceBtn =[self.view viewWithTag:30004];
            maintenanceBtn.selected = NO;
            
            UITextField * brandModel = [self.view viewWithTag:20000];
            brandModel.text = @"";
            UITextField * address = [self.view viewWithTag:20001];
            address.text = @"";
            UITextField * contact = [self.view viewWithTag:20002];
            contact.text = @"";
            UITextField * telephone = [self.view viewWithTag:20003];
            telephone.text = @"";
            UITextField * workHours = [self.view viewWithTag:20004];
            workHours.text = @"";
            HKXMyTextView * textView = [_bottomView viewWithTag:676767];
            textView.text = @"";
            
            _modleid = @"";
            equipmentImg = nil;
            ownerAddress = @"";
            lat = nil;
            lon = nil;
            UIButton * btn = [self.view viewWithTag:8990];
            [btn setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
            
            
        }else if ([dicts[@"success"] boolValue] == NO) {
            
            [self showHint:dicts[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        [self showHint:@"请求失败"];
    }];
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    //呼出的菜单按钮点击后的响应
    if (buttonIndex == myActionSheet.cancelButtonIndex)
    {
        NSLog(@"取消");
    }
    
    switch (buttonIndex)
    {
        case 0:  //打开照相机拍照
            [self LocalPhoto];
            break;
            
        case 1:  //打开本地相册
            [self takePhoto];
            break;
    }
}

//开始拍照
-(void)takePhoto
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        //  [self presentModalViewController:picker animated:YES];
        [self presentViewController:picker animated:YES completion:nil];
    }else
    {
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//打开本地相册
-(void)LocalPhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    //设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    //[self presentModalViewController:picker animated:YES];
    [self presentViewController:picker animated:YES completion:nil];
    
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{
    
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil)
        {
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else
        {
            data = UIImagePNGRepresentation(image);
        }
        
        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        
        //文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:data attributes:nil];
        
        //得到选择后沙盒中图片的完整路径
        filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
        [self sendInfo];
        //关闭相册界面
        //[picker dismissModalViewControllerAnimated:YES];
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
        //创建一个选择后图片的小图标放在下方
        //类似微薄选择图后的效果
        //        UIImageView *smallimage = [[UIImageView alloc] initWithFrame:
        //                                    CGRectMake(50, 120, 40, 40)];
        //
        //        smallimage.image = image;
        UIButton * btn = [self.view viewWithTag:8990];
        [btn setImage:equipmentImg forState:UIControlStateNormal];
        //[btn setTitle:@"" forState:UIControlStateNormal];
        //        //加在视图中
        //        [self.view addSubview:smallimage];
        
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    //[picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendInfo
{
    NSLog(@"图片的路径是：%@", filePath);
    equipmentImg = [[UIImage alloc] initWithContentsOfFile:filePath];
    
}


//通过图片Data数据第一个字节 来获取图片扩展名
- (NSString *)contentTypeForImageData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    switch (c) {
        case 0xFF:
            return @"jpeg";
        case 0x89:
            return @"png";
        case 0x47:
            return @"gif";
        case 0x49:
        case 0x4D:
            return @"tiff";
        case 0x52:
            if ([data length] < 12) {
                return nil;
            }
            NSString *testString = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(0, 12)] encoding:NSASCIIStringEncoding];
            if ([testString hasPrefix:@"RIFF"] && [testString hasSuffix:@"WEBP"]) {
                return @"webp";
            }
            return nil;
    }
    return nil;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self.view endEditing:YES];
}

- (NSString *)valiMobile:(NSString *)mobile{
    
    if (mobile.length < 11)
    {
        return @"手机号长度只能是11位";
    }else{
        
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return @"ok";
        }else{
            return @"请输入正确格式的电话号码";
        }
    }
    return @"ok";
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
}

#pragma mark - Private Method

#pragma mark - Delegate & Data Source
//- (void)textFieldDidBeginEditing:(UITextField *)textField
//{
//    if (textField.tag == 20000)
//    {
//        textField.enabled = NO;
//    }
//}
#pragma mark - Setters & Getters

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
