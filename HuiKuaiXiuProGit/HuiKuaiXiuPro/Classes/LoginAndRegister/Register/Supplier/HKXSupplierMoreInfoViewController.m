//
//  HKXSupplierMoreInfoViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/5.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXSupplierMoreInfoViewController.h"
#import "CommonMethod.h"
#import "HKXNavigationController.h"
#import "HKXHttpRequestManager.h"
#import "HKXUserVertificationCodeResultModelDataModels.h"
#import "HKXSupplierCompanyInfoModel.h"

#import "CustomSubmitView.h"

#import "HKXHomePageViewController.h"//homePage
#import "HKXShoppingMallViewController.h"//shoppingMall
#import "HKXRepairsViewController.h"//repairs
#import "HKXOrderReceivingViewController.h"//orderReceiving
#import "HKXLeaseViewController.h"//lease
#import "HKXMineViewController.h"//mine

@interface HKXSupplierMoreInfoViewController ()<UITextFieldDelegate>

{
    UIView * _bottomView;
}

@property (nonatomic , strong) HKXSupplierCompanyInfoModel * companyModel;//供应商录入公司信息

@end

@implementation HKXSupplierMoreInfoViewController

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
    
    self.navigationItem.title = @"供应商";
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 60, ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    NSArray * placeHolderContentArray = @[@"输入您的公司名称",@"所在城市",@"联系人",@"电话",@"注册资本",@"公司介绍",@"公司主管",@"输入您的地址",@"成立时间"];
    for (int i = 0; i < placeHolderContentArray.count; i ++)
    {
        UITextField * contentTF = [[UITextField alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, (10 + 50 * i) * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];
        if (i == 0)
        {
            contentTF.text = self.companyName;
        }
        
        if (i == 2)
        {
            contentTF.text = self.contactName;
        }
        if (i == 3)
        {
            contentTF.text = self.phone;
        }
        if (i == 1)
        {
            contentTF.frame = CGRectMake(22 * myDelegate.autoSizeScaleX , (10 + 50 * i) * myDelegate.autoSizeScaleY, 96 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY);
            contentTF.text = self.companyCity;
        }
        if (i == 4)
        {
            contentTF.frame = CGRectMake(22 * myDelegate.autoSizeScaleX, (10 + 50 * i) * myDelegate.autoSizeScaleY, 155 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY);
        }
        if (i == 7)
        {
            contentTF.frame = CGRectMake((22 + 96 + 13) * myDelegate.autoSizeScaleX  , (10 + 50 * 1) * myDelegate.autoSizeScaleY, 222 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY);
        }
        if (i == 8)
        {
            contentTF.frame = CGRectMake((22 + 155 + 13) * myDelegate.autoSizeScaleX, (10 + 50 * 4) * myDelegate.autoSizeScaleY, 163 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY);
        }
        contentTF.tag = 20000 + i;
        contentTF.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
        contentTF.placeholder = placeHolderContentArray[i];
        contentTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * myDelegate.autoSizeScaleX, contentTF.frame.size.height)];
        contentTF.leftView.backgroundColor = [UIColor clearColor];
        contentTF.leftViewMode = UITextFieldViewModeAlways;
        contentTF.borderStyle = UITextBorderStyleRoundedRect;
        contentTF.delegate = self;
        [_bottomView addSubview:contentTF];
        
    }
    
    UITextField * managerTF = [_bottomView viewWithTag:20006];
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(98 / 2 * myDelegate.autoSizeScaleX , CGRectGetMaxY(managerTF.frame) + 39 * myDelegate.autoSizeScaleY, 554 / 2 * myDelegate.autoSizeScaleX , 87 / 2 * myDelegate.autoSizeScaleY);
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:20 * myDelegate.autoSizeScaleX];
    submitBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    submitBtn.layer.cornerRadius = 2;
    submitBtn.clipsToBounds = YES;
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:submitBtn];
}
#pragma mark - ConfigData
- (void)prepareData
{
    self.companyModel.uId = [NSString stringWithFormat:@"%ld",self.userRegisterData.dataIdentifier];
    self.companyModel.role = [NSString stringWithFormat:@"%d",self.userRegisterData.role];
    
    UITextField * companyNameTF = [_bottomView viewWithTag:20000];
    self.companyModel.companyName = [companyNameTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : companyNameTF.text;
    
    
    UITextField * locationTF = [_bottomView viewWithTag:20007];
    self.companyModel.companyAddress = [locationTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : locationTF.text;
    
    UITextField * contactNameTF = [_bottomView viewWithTag:20002];
    self.companyModel.realName = [contactNameTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : contactNameTF.text;
    
    UITextField * registerCapital = [_bottomView viewWithTag:20004];
    self.companyModel.registerCapital = [registerCapital.text isEqualToString:@""] ? (NSString *)[NSNull null] : registerCapital.text;
    
    UITextField * foundationTimeTF = [_bottomView viewWithTag:20008];
    self.companyModel.establishmentTime = [foundationTimeTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : foundationTimeTF.text;
    
    UITextField * companyIntroduceTF = [_bottomView viewWithTag:20005];
    self.companyModel.companyIntroduce = [companyIntroduceTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : companyIntroduceTF.text;
    
    UITextField * companyMainTF = [_bottomView viewWithTag:20006];
    self.companyModel.companyMain = [companyMainTF.text isEqualToString:@""] ? (NSString *)[NSNull null] : companyMainTF.text;
    [self.view showActivity];
    [HKXHttpRequestManager sendRequestWithSupplierCompanyInfo:self.companyModel ToGetUpdateSupplierCompanyInfoResult:^(id data) {
        HKXUserVertificationCodeResultModel * model = data;
        
        [self.view hideActivity];
        CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:model.message sure:@"确定" sureBtnClick:^{
            if (model.success)
            {

                [self createTabbar:self.userRegisterData.role];
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:self.userRegisterData.role forKey:@"userDataRole"];
                [defaults setDouble:self.userRegisterData.dataIdentifier forKey:@"userDataId"];
                [defaults setBool:YES forKey:@"userLoginState"];
                NSArray * arr = [[NSString stringWithFormat:@"%ld",self.userRegisterData.dataIdentifier] componentsSeparatedByString:@"."];
                if ([defaults integerForKey:@"userDataRole"] == 0) {
                    
                    [UMessage addAlias:arr[0] type:@"HKX_MACHINE" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                        
                        NSLog(@"%@",responseObject);;
                        
                    }];
                }else if([defaults integerForKey:@"userDataRole"] == 1){
                    
                    
                    [UMessage addAlias:arr[0] type:@"HKX_REPAIR" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                        
                        NSLog(@"%@",responseObject);;
                        
                    }];
                }else if([defaults integerForKey:@"userDataRole"] == 2){
                    
                    [UMessage addAlias:arr[0] type:@"HKX_SUPPLIER" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                        
                        NSLog(@"%@",responseObject);;
                        
                    }];
                }
                

                [defaults synchronize];
            }
            else
            {
                [self tapGestureClick];
            }
            
        } WithAlertHeight:160];
        customAlertView.tag = 501;
        [self.view addSubview:customAlertView];
    }];
}
#pragma mark - Action
- (void)submitBtnClick:(UIButton *)btn
{
    [self prepareData];
}
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
#pragma mark - Private Method
/**
 根据不同角色，布局相应首页tabbar
 */
- (void)createTabbar:(int)userId
{
    NSMutableArray * tabbarArray = [NSMutableArray array];
    NSMutableArray * sonClassVCArray = [NSMutableArray array];
    if (userId == 0)
    {
        //        机主角色
        tabbarArray = [NSMutableArray arrayWithObjects:@"首页",@"商城",@"报修",@"租赁",@"我的", nil];
        sonClassVCArray = [NSMutableArray arrayWithObjects:@"HKXHomePageViewController",@"HKXShoppingMallViewController",@"HKXRepairsViewController",@"HKXLeaseViewController",@"HKXMineViewController", nil];
    }
    if (userId == 2)
    {
        //        供应商角色
        tabbarArray = [NSMutableArray arrayWithObjects:@"首页",@"商城",@"租赁",@"我的", nil];
        sonClassVCArray = [NSMutableArray arrayWithObjects:@"HKXHomePageViewController",@"HKXShoppingMallViewController",@"HKXLeaseViewController",@"HKXMineViewController", nil];
    }
    if (userId == 1)
    {
        //        服务维修角色
        tabbarArray = [NSMutableArray arrayWithObjects:@"首页",@"商城",@"接单",@"租赁",@"我的", nil];
        sonClassVCArray = [NSMutableArray arrayWithObjects:@"HKXHomePageViewController",@"HKXShoppingMallViewController",@"HKXOrderReceivingViewController",@"HKXLeaseViewController",@"HKXMineViewController", nil];
    }
    
    UITabBarController * tabbar = [[UITabBarController alloc] init];
    NSMutableArray * sonViewControllersArray = [NSMutableArray array];
    
    for (int i = 0; i < tabbarArray.count; i ++)
    {
        NSString * titleString = tabbarArray[i];
        //        UITabBarItem * item = [tabbar.tabBar.items objectAtIndex:i ];
        
        //        视图的类名
        Class c = NSClassFromString(sonClassVCArray[i]);
        UIViewController * superViewController = [[c alloc] init];
        
        HKXNavigationController * nc = [[HKXNavigationController alloc] initWithRootViewController:superViewController];
        nc.title = titleString;
        
        [sonViewControllersArray addObject:nc];
        
        UIImage * icoImage = [[UIImage imageNamed:tabbarArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage * icoSelectedImage = [[UIImage imageNamed:[NSString stringWithFormat:@"%@选中",tabbarArray[i]]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        superViewController.tabBarItem = [[UITabBarItem alloc] initWithTitle:titleString image:icoImage selectedImage:icoSelectedImage];
        tabbar.tabBar.tintColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
        
        //        设置导航名字
        //        if ([titleString isEqualToString:@"商城"] || [titleString isEqualToString:@"报修"] || [titleString isEqualToString:@"抢单"] || [titleString isEqualToString:@"租赁"] || [titleString isEqualToString:@"我的"])
        //        {
        if ([titleString isEqualToString:@"接单"])
        {
            superViewController.navigationItem.title = @"接单列表";
        }
        else if ([titleString isEqualToString:@"我的"])
        {
            superViewController.navigationItem.title = @"我的个人中心";
        }
        else
        {
            superViewController.navigationItem.title = titleString;
        }
        //        }
    }
    tabbar.viewControllers = sonViewControllersArray;
    
    
    UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
    
    window.rootViewController = tabbar;
    [window makeKeyWindow];
    
    
}
#pragma mark - Delegate & Data Source
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if ( textField.tag == 20003 || textField.tag == 20001 )
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
#pragma mark - Setters & Getters
- (HKXSupplierCompanyInfoModel *)companyModel
{
    if (!_companyModel)
    {
        _companyModel = [HKXSupplierCompanyInfoModel getUserModel];
    }
    return _companyModel;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [_bottomView endEditing:YES];
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
