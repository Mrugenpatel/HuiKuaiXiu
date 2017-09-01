//
//  HKXRepairsOrderTimeViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/17.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXRepairsOrderTimeViewController.h"
#import "CommonMethod.h"
#import "HKXRepairMapViewController.h"
@interface HKXRepairsOrderTimeViewController (){
    
    NSString *dateStr ;
}

@end

@implementation HKXRepairsOrderTimeViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1];
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 60, ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
//    时间选择器
    UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 20 * myDelegate.autoSizeScaleY, ScreenWidth, ScreenWidth)];
    datePicker.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [datePicker addTarget:self action:@selector(selectedDate:) forControlEvents:UIControlEventValueChanged];
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文
    datePicker.locale = locale;
    [bottomView addSubview:datePicker];
    NSDate *minDate = [NSDate date];
    datePicker.minimumDate = minDate;
//    确定
    UIButton * confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    confirmBtn.frame = CGRectMake(98 / 2 * myDelegate.autoSizeScaleX , CGRectGetMaxY(datePicker.frame) + 45 * myDelegate.autoSizeScaleY, 554 / 2 * myDelegate.autoSizeScaleX , 87 / 2 * myDelegate.autoSizeScaleY);
    [confirmBtn setTitle:@"立即预约" forState:UIControlStateNormal];
    confirmBtn.titleLabel.font = [UIFont systemFontOfSize:20 * myDelegate.autoSizeScaleX];
    confirmBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    confirmBtn.layer.cornerRadius = 2;
    confirmBtn.clipsToBounds = YES;
    [confirmBtn addTarget:self action:@selector(confirmBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:confirmBtn];
}
#pragma mark - ConfigData
#pragma mark - Action
- (void)confirmBtnClick:(UIButton *)btn
{
    if (dateStr.length == 0) {
        
        NSDate * date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        dateStr = [formatter stringFromDate:date];
    }
    NSLog(@"提交");
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_brandModel,@"brandModel",[NSNumber numberWithDouble:[_brandModelId doubleValue]],@"mId",_address,@"address",_contact,@"contact",_telephone,@"telephone",_workHours,@"workHours",_faultType,@"faultType",_faultInfo,@"faultInfo",_imageDataString,@"picture",[NSNumber numberWithDouble:uId],@"uId",dateStr,@"appointmentTime",_lon,@"lon",_lat,@"lat",nil];
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
        }else if ([dicts[@"success"] boolValue] == NO) {
            
            [self showHint:dicts[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        [self showHint:@"请求失败"];
    }];
    

}
#pragma mark - Private Method
- (void)selectedDate:(UIDatePicker *)datePicker
{
    NSDate *date = [datePicker date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
//    [formatter setAMSymbol:@"上午好"];
//    [formatter setPMSymbol:@"下午好"];
    
   // [formatter setDateFormat:@"yy年MM月dd日 HH时mm分ss秒"];
    [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
    dateStr = [formatter stringFromDate:date];
    NSLog(@"dateStr = %@",dateStr);
    
    
}
#pragma mark - Delegate & Data Source
#pragma mark - Setters & Getters

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
