//
//  ViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/12.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "ViewController.h"
#import "CommonMethod.h"

#import "HKXHomePageViewController.h"//homePage
#import "HKXShoppingMallViewController.h"//shoppingMall
#import "HKXRepairsViewController.h"//repairs
#import "HKXOrderReceivingViewController.h"//orderReceiving
#import "HKXLeaseViewController.h"//lease
#import "HKXMineViewController.h"//mine
#import "HKXResetPswViewController.h"//resetPswVC
#import "HKXBasicRegisterViewController.h"//registerVC
#import "HKXNavigationController.h"
#import "HKXHttpRequestManager.h"
#import "HKXLoginResultDataModels.h"

#import <UShareUI/UShareUI.h>

@interface ViewController ()

@end

@implementation ViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
   
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userLoginState"] == YES) {
        
        [self createTabbar:(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"userDataRole"]];
        
    }else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"userLoginState"] == NO){
        
        [self createUI];
        
    }
}





#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
//    changeStatusBarColor
    UIView * statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
    statusBarView.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    [self.view addSubview:statusBarView];
    
//    logoImageView
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    float XPosition = ( ScreenWidth - 479 * myDelegate.autoSizeScaleX / 2 ) / 2  ;
    float YPosition = 166 / 2 * myDelegate.autoSizeScaleY + 20 ;
    UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(XPosition, YPosition, 479 / 2 * myDelegate.autoSizeScaleX, 126 / 2 * myDelegate.autoSizeScaleY)];
    logoImageView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoImageView];
    
//    userPhoneNumberTextField & userPasswordTextField
    NSArray * placeHolderStringArray = [NSArray arrayWithObjects:@"请输入您的手机号",@"请输入您的密码", nil];
    NSArray * userInfoImageTitleArray = [NSArray arrayWithObjects:@"登录人",@"登录密码", nil];
    float userInfoImageXPosition;
    float userInfoImageYPosition = 10 * myDelegate.autoSizeScaleY;
    float userInfoImageWidth ;
    float userInfoImageHeight = 20 * myDelegate.autoSizeScaleY;
    for (int i = 0; i < 2; i ++)
    {
        UITextField * userInfoTF = [[UITextField alloc] initWithFrame:CGRectMake(98 / 2 * myDelegate.autoSizeScaleX, CGRectGetMaxY(logoImageView.frame) + 156 / 2 * myDelegate.autoSizeScaleY + i * (40 + 16) * myDelegate.autoSizeScaleY , 554 / 2 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];
//        UITextField * userInfoTF = [[UITextField alloc] initWithFrame:CGRectMake(98 / 2 * myDelegate.autoSizeScaleX, CGRectGetMaxY(logoImageView.frame) + 156 / 2 * myDelegate.autoSizeScaleY + i * (40 + 16) * myDelegate.autoSizeScaleY , ScreenWidth - 98 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];

        [self.view addSubview:userInfoTF];
        
        userInfoTF.font = [UIFont systemFontOfSize: 16 * myDelegate.autoSizeScaleX];
        userInfoTF.backgroundColor = [CommonMethod getUsualColorWithString:@"#f6f6f6"];
        userInfoTF.layer.borderColor = [CommonMethod getUsualColorWithString:@"#ffa304"].CGColor;
        userInfoTF.layer.borderWidth = 0.5;
        userInfoTF.tag = 900 + i;
        
//        leftClearView
        userInfoTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 110 / 2 * myDelegate.autoSizeScaleX, userInfoTF.frame.size.height)];
        userInfoTF.leftViewMode = UITextFieldViewModeAlways;
        userInfoTF.leftView.backgroundColor = [UIColor clearColor];
        
//        placeHolder
        userInfoTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeHolderStringArray[i] attributes:@{NSForegroundColorAttributeName:[CommonMethod getUsualColorWithString:@"#999999"]}];
        
//        leftWhiteView
        UIView * leftWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40 * myDelegate.autoSizeScaleX, userInfoTF.frame.size.height)];
        leftWhiteView.backgroundColor = [UIColor whiteColor];
        [userInfoTF addSubview:leftWhiteView];
        
//        userInfoImageView
        if (i == 0)
        {
            userInfoImageXPosition = 11 * myDelegate.autoSizeScaleX;
            userInfoImageWidth     = 18 * myDelegate.autoSizeScaleX;
        }
        else
        {
            userInfoImageXPosition = 12.5 * myDelegate.autoSizeScaleX;
            userInfoImageWidth     = 15 * myDelegate.autoSizeScaleX;
        }
        UIImageView * userInfoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(userInfoImageXPosition, userInfoImageYPosition, userInfoImageWidth, userInfoImageHeight)];
        userInfoImageView.image = [UIImage imageNamed:userInfoImageTitleArray[i]];
        [userInfoTF addSubview:userInfoImageView];
        
//        changePswStatusBtn
        if (i == 1)
        {
            float placeHolderStringLength = [CommonMethod getLabelLengthWithString:placeHolderStringArray[i] WithFont:16 * myDelegate.autoSizeScaleX];
            float changePswStatusBtnPosition = (110 + 150) / 2 * myDelegate.autoSizeScaleX + placeHolderStringLength;
            UIButton * changePswStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            changePswStatusBtn.frame = CGRectMake(changePswStatusBtnPosition, 0, userInfoTF.frame.size.width - changePswStatusBtnPosition, userInfoTF.frame.size.height);
            [changePswStatusBtn addTarget:self action:@selector(changePswStatusBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            changePswStatusBtn.backgroundColor = [UIColor clearColor];
            [userInfoTF addSubview:changePswStatusBtn];
            
            UIImageView * changePswStatusImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleY, 18 * myDelegate.autoSizeScaleX, 17 / 2 * myDelegate.autoSizeScaleY)];
            changePswStatusImageView.image = [UIImage imageNamed:@"不显示密码"];
            changePswStatusImageView.tag = 500;
            [changePswStatusBtn addSubview:changePswStatusImageView];
            
            userInfoTF.secureTextEntry = YES;
        }
    }
    
//    loginBtn
    UITextField * userPswTF = [self.view viewWithTag:901];
    UIButton * loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame = CGRectMake(98 / 2 * myDelegate.autoSizeScaleX , CGRectGetMaxY(userPswTF.frame) + 44 * myDelegate.autoSizeScaleY, 554 / 2 * myDelegate.autoSizeScaleX , 87 / 2 * myDelegate.autoSizeScaleY);
//    loginBtn.frame = CGRectMake(98 / 2 * myDelegate.autoSizeScaleX , CGRectGetMaxY(userPswTF.frame) + 44 * myDelegate.autoSizeScaleY, ScreenWidth - 98 * myDelegate.autoSizeScaleX , 87 / 2 * myDelegate.autoSizeScaleY);
    [loginBtn setTitle:@"登 录" forState:UIControlStateNormal];
    loginBtn.titleLabel.font = [UIFont systemFontOfSize:20 * myDelegate.autoSizeScaleX];
    loginBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    loginBtn.layer.cornerRadius = 2;
    loginBtn.clipsToBounds = YES;
    [loginBtn addTarget:self action:@selector(loginBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
//    resetPasswordBtn & registerBtn
    float btnTitleLength = [CommonMethod getLabelLengthWithString:@"忘记密码" WithFont:11 * myDelegate.autoSizeScaleX];
    NSArray * btnTitleArray = [NSArray arrayWithObjects:@"忘记密码",@"快速注册", nil];
    NSArray * btnTitleColorArray = [NSArray arrayWithObjects:@"#999999",@"#f8931d", nil];
    for (int i = 0; i < 2; i ++)
    {
        UIButton * otherFunctionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        otherFunctionBtn.frame = CGRectMake(98 / 2 * myDelegate.autoSizeScaleX + i * (loginBtn.frame.size.width - btnTitleLength ), CGRectGetMaxY(loginBtn.frame) + 17 * myDelegate.autoSizeScaleY, btnTitleLength, 11 * myDelegate.autoSizeScaleY);
        [otherFunctionBtn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
        [otherFunctionBtn setTitleColor:[CommonMethod getUsualColorWithString:btnTitleColorArray[i]] forState:UIControlStateNormal];
        otherFunctionBtn.titleLabel.font = [UIFont systemFontOfSize:11 * myDelegate.autoSizeScaleX];
        [otherFunctionBtn addTarget:self action:@selector(resetPswOrRegisterBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        otherFunctionBtn.tag = 3000 + i;
        [self.view addSubview:otherFunctionBtn];
    }
}

#pragma mark - ConfigData
#pragma mark - Action
/**
 改变密码明密文状态

 @param btn 按钮
 */
- (void)changePswStatusBtnClick:(UIButton *)btn
{ 
    UITextField * userPswTF = [self.view viewWithTag:901];
    userPswTF.secureTextEntry = !userPswTF.secureTextEntry;
    
    UIImageView * changePswStatusImageView = [self.view viewWithTag:500];
    if (!userPswTF.secureTextEntry)
    {
        changePswStatusImageView.image = [UIImage imageNamed:@"显示密码"];
    }
    else
    {
        changePswStatusImageView.image = [UIImage imageNamed:@"不显示密码"];
    }
}

/**
 用户登录操作

 @param btn 登录按钮
 */
- (void)loginBtnClick:(UIButton *)btn
{

    UITextField * userNameTF = [self.view viewWithTag:900];
    UITextField * userPswTF = [self.view viewWithTag:901];
    if ([userPswTF.text isEqualToString:@""] || [userNameTF.text isEqualToString:@""])
    {
        userNameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"您输入的账号错误！" attributes:@{NSForegroundColorAttributeName:[CommonMethod getUsualColorWithString:@"#ff0000"]}];
    }
    else
    {
        [self.view showActivity];
        [HKXHttpRequestManager sendRequestWithUserName:userNameTF.text WithUserPassword:userPswTF.text ToGetLoginResult:^(id data) {
            HKXLoginResult * model = data;
            
            [self.view hideActivity];
            if (model.success)
            {
                HKXLoginData * userData = model.data;
                [self createTabbar:userData.role];
//                存入本地
                NSLog(@"-====>%@",userData);
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setInteger:userData.role forKey:@"userDataRole"];
                [defaults setDouble:userData.dataIdentifier forKey:@"userDataId"];
                [defaults setBool:YES forKey:@"userLoginState"];
                NSArray * arr = [[NSString stringWithFormat:@"%f",userData.dataIdentifier] componentsSeparatedByString:@"."];
                if (userData.role == 0) {
                    
                    [UMessage addAlias:arr[0] type:@"HKX_MACHINE" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                        
                        NSLog(@"%@",responseObject);;

                    }];
                }else if(userData.role == 1){

                    
                    [UMessage addAlias:arr[0] type:@"HKX_REPAIR" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                        
                        NSLog(@"%@",responseObject);;
                        
                    }];
                }else if(userData.role == 2){
                    
                    [UMessage addAlias:arr[0] type:@"HKX_SUPPLIER" response:^(id  _Nonnull responseObject, NSError * _Nonnull error) {
                        
                        NSLog(@"%@",responseObject);;
                        
                    }];
                }
                
                
                [defaults synchronize];
            }
            else
            {
                NSLog(@"%@",model.message);
                userNameTF.text = [NSString stringWithFormat:@""];
                userNameTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:model.message attributes:@{NSForegroundColorAttributeName:[CommonMethod getUsualColorWithString:@"#ff0000"]}];
            }
        }];
    }
    
}

/**
 重置密码或者快速注册

 @param btn btn
 */
- (void)resetPswOrRegisterBtnClick:(UIButton *)btn
{
    if (btn.tag - 3000 == 0)
    {
        HKXResetPswViewController * resetPswVC = [[HKXResetPswViewController alloc] init];
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:resetPswVC];
        nc.title = @"忘记密码";
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        
        window.rootViewController = nc;
        [window makeKeyWindow];
    }
    else
    {
        
        HKXBasicRegisterViewController * registerVC = [[HKXBasicRegisterViewController alloc] init];
        UINavigationController * nc = [[UINavigationController alloc] initWithRootViewController:registerVC];
        nc.title = @"加盟注册";
        UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
        
        window.rootViewController = nc;
        [window makeKeyWindow];
    }
}
#pragma mark - Private Method
/**
 *  沙盒路径
 *
 *  @return 沙盒路径
 */
- (NSString *)getFilePath
{
    NSFileManager * manager = [NSFileManager defaultManager];
    NSString * filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"/Documents/HKXUser.plist"];
    if (![manager fileExistsAtPath:filePath])
    {
        [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    }
    return filePath;
}
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
#pragma mark - Setters & Getters

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
