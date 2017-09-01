//
//  HKXOrderDetailViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/18.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXOrderDetailViewController.h"
#import "CommonMethod.h"

#import <UIImageView+WebCache.h>
#import "orderMapViewController.h"
@interface HKXOrderDetailViewController ()

@end

@implementation HKXOrderDetailViewController

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
    self.navigationItem.title = @"订单详情";
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 74 * myDelegate.autoSizeScaleY, ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
//    维修设备
    UILabel * equipmentNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, 55 / 2 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX)];
    equipmentNameLabel.tag = 4000;
    equipmentNameLabel.text = [NSString stringWithFormat:@"维修设备：%@",_repairListModel.brandModel];
    equipmentNameLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
    [bottomView addSubview:equipmentNameLabel];
    
//    故障类型
    UILabel * troubleTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(equipmentNameLabel.frame) + 24 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX)];
    troubleTypeLabel.tag = 4001;
    troubleTypeLabel.text = [NSString stringWithFormat:@"故障类型：%@",_repairListModel.fault];
    troubleTypeLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
    [bottomView addSubview:troubleTypeLabel];
    
    float titleLabelLength = [CommonMethod getLabelLengthWithString:@"故障描述：" WithFont:17 * myDelegate.autoSizeScaleX];
    //    故障描述
    UILabel * troubleDescribeLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(troubleTypeLabel.frame) + 24 * myDelegate.autoSizeScaleY, titleLabelLength, 17 * myDelegate.autoSizeScaleX)];
    troubleDescribeLabel.tag = 4002;
    troubleDescribeLabel.text = [NSString stringWithFormat:@"故障描述："];
    troubleDescribeLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
    [bottomView addSubview:troubleDescribeLabel];
    
    UILabel * troubleDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(troubleDescribeLabel.frame),CGRectGetMaxY(troubleTypeLabel.frame) + 24 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX - titleLabelLength, 48 * myDelegate.autoSizeScaleX)];
    troubleDetailLabel.tag = 4003;
    troubleDetailLabel.text = _repairListModel.faultInfo;
    troubleDetailLabel.numberOfLines = 2;
    troubleDetailLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
    [bottomView addSubview:troubleDetailLabel];
    
    //    故障图片
    UILabel * troublePicLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(troubleDetailLabel.frame) + 24 * myDelegate.autoSizeScaleY, titleLabelLength, 17 * myDelegate.autoSizeScaleX)];
    troublePicLabel.tag = 4004;
    troublePicLabel.text = [NSString stringWithFormat:@"故障图片"];
    troublePicLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
    [bottomView addSubview:troublePicLabel];
    
    for (int i = 0; i < 4; i ++)
    {
        int X = i % 2;
        int Y = i / 2;
        UIImageView * troublePicImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(troublePicLabel.frame) + (17 + 100 * X) * myDelegate.autoSizeScaleX , CGRectGetMaxY(troubleDetailLabel.frame) + (24 + 73 * Y) * myDelegate.autoSizeScaleY, 97 * myDelegate.autoSizeScaleX, 64 * myDelegate.autoSizeScaleY)];
        troublePicImage.image = [UIImage imageNamed:@"滑动视图示例"];
        [troublePicImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMAGEURL,_repairListModel.picture[i]]] placeholderImage:[UIImage imageNamed:@""]];
        troublePicImage.tag = 4005 + i;
        [bottomView addSubview:troublePicImage];
        
        if (i == 2)
        {
//               电话
            UILabel * phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(troublePicImage.frame) + 17 * myDelegate.autoSizeScaleY, ScreenWidth - 78 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX)];
            phoneLabel.tag = 4009;
            phoneLabel.text = [NSString stringWithFormat:@"电话：%@",_repairListModel.telephone];
            phoneLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
            [bottomView addSubview:phoneLabel];
            
//                           电话按钮
            UIButton * phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            phoneBtn.tag = 4010;
            phoneBtn.frame = CGRectMake(CGRectGetMaxX(phoneLabel.frame) + 19 * myDelegate.autoSizeScaleX, phoneLabel.frame.origin.y + 1 * myDelegate.autoSizeScaleY, 15 * myDelegate.autoSizeScaleX, 15 * myDelegate.autoSizeScaleX);
            [phoneBtn setBackgroundImage:[UIImage imageNamed:@"电话"] forState:UIControlStateNormal];
            [phoneBtn addTarget:self action:@selector(callPhoneNumberBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:phoneBtn];
            
//                        地址
            UILabel * addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX,CGRectGetMaxY(phoneLabel.frame) + 24 * myDelegate.autoSizeScaleY, ScreenWidth - 78 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX)];
            addressLabel.tag = 4011;
            addressLabel.text = [NSString stringWithFormat:@"地址：%@",_repairListModel.address];
            addressLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
            [bottomView addSubview:addressLabel];
            
//                        定位
            UIButton * addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addressBtn.tag = 4012;
            addressBtn.frame = CGRectMake(CGRectGetMaxX(addressLabel.frame) + 19 * myDelegate.autoSizeScaleX, addressLabel.frame.origin.y - 2.5 * myDelegate.autoSizeScaleY, 15 * myDelegate.autoSizeScaleX, 22 * myDelegate.autoSizeScaleY);
            [addressBtn setImage:[UIImage imageNamed:@"定位"] forState:UIControlStateNormal];
            [addressBtn addTarget:self action:@selector(showMapAddressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [bottomView addSubview:addressBtn];
            
//            取消订单/下一步
            NSArray * btnTitleArray = @[@"取消订单",@"下一步"];
            NSArray * btnBGColorArray = @[@"#e06e15",@"#ffa304"];
            for (int j = 0; j < 2; j ++)
            {
                UIButton * actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                actionBtn.frame = CGRectMake((22 + (150 + 31) * j) * myDelegate.autoSizeScaleX, CGRectGetMaxY(addressLabel.frame) + 75 * myDelegate.autoSizeScaleY, 150 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
                [actionBtn setTitle:btnTitleArray[j] forState:UIControlStateNormal];
                [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                actionBtn.backgroundColor = [CommonMethod getUsualColorWithString:btnBGColorArray[j]];
                actionBtn.tag = 50000 + j;
                [actionBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                actionBtn.layer.cornerRadius = 2;
                actionBtn.clipsToBounds = YES;
                [bottomView addSubview:actionBtn];
            }
        }
    }
}
#pragma mark - ConfigData
#pragma mark - Action
- (void)showMapAddressBtnClick:(UIButton *)btn
{
    
    orderMapViewController * map = [[orderMapViewController alloc] init];
//    map.latitude = latitude;
//    map.longitude = longitude;
    map.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:map animated:YES];
        
}
- (void)callPhoneNumberBtnClick:(UIButton *)btn
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",self.repairListModel.telephone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}
- (void)actionBtnClick:(UIButton *)btn
{
    if (btn.tag - 50000 == 0)
    {
        NSLog(@"取消订单");
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        double uId = [defaults doubleForKey:@"userDataId"];
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:[_repairListModel.repairId doubleValue]],@"ruoId",[NSNumber numberWithDouble:uId],@"uId",nil];
        NSLog(@"%@",dict);
        
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"repairOrder/removeOrder.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            if ([dicts[@"success"] boolValue] == YES) {
                
                [self showHint:dicts[@"message"]];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else if ([dicts[@"success"] boolValue] == NO) {
                
                [self showHint:dicts[@"message"]];
            }
            
            
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            [self showHint:@"请求失败"];
        }];


    }else
    {
        NSLog(@"下一步");
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        double uId = [defaults doubleForKey:@"userDataId"];
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:[_repairListModel.repairId doubleValue]],@"ruoId",[NSNumber numberWithDouble:uId],@"uId",nil];
        NSLog(@"%@",dict);
        
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"repairOrder/next.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            if ([dicts[@"success"] boolValue] == YES) {
                
                [self showHint:dicts[@"message"]];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else if ([dicts[@"success"] boolValue] == NO) {
                
                [self showHint:dicts[@"message"]];
                
            }
            
            
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            [self showHint:@"请求失败"];
        }];
    }
}
#pragma mark - Private Method
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
