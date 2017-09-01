//
//  HKXResetPswViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/30.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXResetPswViewController.h"
#import "CommonMethod.h"
#import "CustomSubmitView.h"
#import "ViewController.h"//loginVC

#import "HKXHttpRequestManager.h"

#import "HKXUserVertificationCodeResultModelDataModels.h"

@interface HKXResetPswViewController ()

@end

@implementation HKXResetPswViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1];
    self.navigationItem.title = @"忘记密码";
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 + 40 + 10 * myDelegate.autoSizeScaleY, ScreenWidth, ScreenHeight - 20 - 60 - 10 * myDelegate.autoSizeScaleY)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.tag = 9000;
    [self.view addSubview:bottomView];
    
    NSArray * placeHolderArray = @[@"输入您的注册手机号",@"输入您的验证码",@"设置您的新密码",@"再次输入您的新密码"];
    for (int i = 0; i < 4; i ++)
    {
        UITextField * pswTF = [[UITextField alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY + (10 + 40) * i * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];
        if (i == 1)
        {
            pswTF.frame = CGRectMake((44 + 282 + 30) / 2 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY + (10 + 40) * i * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX - (141 + 15) * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY);
        }
        pswTF.placeholder = placeHolderArray[i];
        pswTF.tag = 8000 + i;
        pswTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * myDelegate.autoSizeScaleX, pswTF.frame.size.height)];
        pswTF.leftView.backgroundColor = [UIColor clearColor];
        pswTF.leftViewMode = UITextFieldViewModeAlways;
        pswTF.borderStyle = UITextBorderStyleRoundedRect;
        [bottomView addSubview:pswTF];
    }
    
    UIButton * getVerificationCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    getVerificationCodeBtn.frame = CGRectMake(22 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY + (10 + 40) * 1 * myDelegate.autoSizeScaleY, 282 / 2 * myDelegate.autoSizeScaleX, 40 *myDelegate.autoSizeScaleY);
    getVerificationCodeBtn.layer.cornerRadius = 4 * myDelegate.autoSizeScaleY;
    getVerificationCodeBtn.clipsToBounds = YES;
    [getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    getVerificationCodeBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    [getVerificationCodeBtn addTarget:self action:@selector(getVertificationCodeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:getVerificationCodeBtn];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake((ScreenWidth - 274 * myDelegate.autoSizeScaleX) / 2, 10 * myDelegate.autoSizeScaleY + (10 + 40) * 3 * myDelegate.autoSizeScaleY + 40 * myDelegate.autoSizeScaleY + 376 / 2 * myDelegate.autoSizeScaleY, 274 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
    submitBtn.layer.cornerRadius = 3 * myDelegate.autoSizeScaleY;
    submitBtn.clipsToBounds = YES;
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    submitBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:submitBtn];
}
#pragma mark - ConfigData

#pragma mark - Action
- (void)getVertificationCodeBtnClick
{
//    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView * bottomView = [self.view viewWithTag:9000];
    UITextField * userNameTF = [bottomView viewWithTag:8000];
    NSString * mobile = userNameTF.text;
    NSString * alertContent = [self valiMobile:mobile ];
    if (![alertContent isEqualToString:@"ok"] )
    {
        UIView * backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        backGroundView.backgroundColor = [UIColor darkGrayColor];
        backGroundView.alpha = 0.3;
        backGroundView.tag = 506;
        [self.view addSubview:backGroundView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
        [backGroundView addGestureRecognizer:tap];
        CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:alertContent sure:@"确定" sureBtnClick:^{
            
            [self tapGestureClick];
        } WithAlertHeight:160];
        customAlertView.tag = 507;
        [self.view addSubview:customAlertView];
    }
    else
    {
        [HKXHttpRequestManager sendRequestWithUserPhoneNumber:userNameTF.text ToGetVertificationCode:^(id data) {
            HKXUserVertificationCodeResultModel * model = data;
            if (!model.success)
            {
                UIView * backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
                backGroundView.backgroundColor = [UIColor darkGrayColor];
                backGroundView.alpha = 0.3;
                backGroundView.tag = 506;
                [self.view addSubview:backGroundView];
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
                [backGroundView addGestureRecognizer:tap];
                CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:model.message sure:@"确定" sureBtnClick:^{
                    
                    [self tapGestureClick];
                } WithAlertHeight:160];
                customAlertView.tag = 507;
                [self.view addSubview:customAlertView];
            }
            else
            {
                HKXUserVertificationCodeData * data = model.data;
                NSLog(@"验证码%@",data.number);
                
                CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:[NSString stringWithFormat:@"验证码%@",data.number] sure:@"确定" sureBtnClick:^{
                    
                    [self tapGestureClick];
                } WithAlertHeight:160];
                customAlertView.tag = 507;
                [self.view addSubview:customAlertView];
            }
        }];
    }
}
- (void)submitBtnClick
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView * bottomView = [self.view viewWithTag:9000];
    UITextField * userNameTF = [bottomView viewWithTag:8000];
    UITextField * userPswTF = [bottomView viewWithTag:8002];
    UITextField * userRePswTF = [bottomView viewWithTag:8003];
    UITextField * vertificateCodeTF = [bottomView viewWithTag:8001];
    

//    检测是否有空值
    if ([userPswTF.text isEqualToString:@""]||[userPswTF.text isEqualToString:@""] || [userRePswTF.text isEqualToString:@""] || [vertificateCodeTF.text isEqualToString:@""])
    {
        UIView * backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        backGroundView.backgroundColor = [UIColor darkGrayColor];
        backGroundView.alpha = 0.3;
        backGroundView.tag = 4000;
        [self.view addSubview:backGroundView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
        [backGroundView addGestureRecognizer:tap];
        CustomSubmitView * submitAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:@"输入框不可为空" sure:@"确定" sureBtnClick:^{
            
            
        } WithAlertHeight:180 * myDelegate.autoSizeScaleY];
        submitAlertView.tag = 4001;
        [self.view addSubview:submitAlertView];
        return;
    }
    else
    {
//        检测两次密码输入是否一致
        if (![userRePswTF.text isEqualToString:userPswTF.text])
        {
            UIView * backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
            backGroundView.backgroundColor = [UIColor darkGrayColor];
            backGroundView.alpha = 0.3;
            backGroundView.tag = 4000;
            [self.view addSubview:backGroundView];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
            [backGroundView addGestureRecognizer:tap];
            CustomSubmitView * submitAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:@"两次密码输入不一致" sure:@"确定" sureBtnClick:^{
                
                
                
            } WithAlertHeight:180 * myDelegate.autoSizeScaleY];
            submitAlertView.tag = 4001;
            [self.view addSubview:submitAlertView];
            return;
        }
    }
    [self.view showActivity];
    [HKXHttpRequestManager sendRequestWithUserName:userNameTF.text WithUserPsw:userPswTF.text WithVerificateCode:vertificateCodeTF.text ToGetResetPswResult:^(id data) {
        HKXUserVertificationCodeResultModel * model = data;
        [self.view hideActivity];
        if (model.success)
        {
            UIView * backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
            backGroundView.backgroundColor = [UIColor darkGrayColor];
            backGroundView.alpha = 0.3;
            backGroundView.tag = 4000;
            [self.view addSubview:backGroundView];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
            [backGroundView addGestureRecognizer:tap];
            CustomSubmitView * submitAlertView = [CustomSubmitView alertViewWithTitle:@"恭喜您密码设置成功" content:@"请您重新登录" sure:@"确定" sureBtnClick:^{
                UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
                ViewController * loginVC = [[ViewController alloc] init];
                window.rootViewController = loginVC;
                [window makeKeyWindow];
                
            } WithAlertHeight:180 * myDelegate.autoSizeScaleY];
            submitAlertView.tag = 4001;
            [self.view addSubview:submitAlertView];
        }
        else
        {
            UIView * backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
            backGroundView.backgroundColor = [UIColor darkGrayColor];
            backGroundView.alpha = 0.3;
            backGroundView.tag = 4000;
            [self.view addSubview:backGroundView];
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
            [backGroundView addGestureRecognizer:tap];
            CustomSubmitView * submitAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:model.message sure:@"确定" sureBtnClick:^{
                UIWindow * window = [[[UIApplication sharedApplication] delegate] window];
                ViewController * loginVC = [[ViewController alloc] init];
                window.rootViewController = loginVC;
                [window makeKeyWindow];
                
            } WithAlertHeight:180 * myDelegate.autoSizeScaleY];
            submitAlertView.tag = 4001;
            [self.view addSubview:submitAlertView];
        }
    }];
    
    
}
- (void)tapGestureClick
{
    for (UIView * view in self.view.subviews)
    {
        if (view.tag == 4000 || view.tag == 4001)
        {
            [view removeFromSuperview];
        }
    }
}
#pragma mark - Private Method
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
