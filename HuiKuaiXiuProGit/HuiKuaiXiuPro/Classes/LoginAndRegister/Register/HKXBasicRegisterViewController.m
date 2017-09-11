//
//  HKXBasicRegisterViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/30.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXBasicRegisterViewController.h"
#import "CommonMethod.h"
#import "HKXBasicInfoRegisterViewController.h"
#import "CustomDropDownBtn.h"
#import "CustomSubmitView.h"

#import "HKXHttpRequestManager.h"
#import "HKXRegisterResultDataModels.h"
#import "HKXUserVertificationCodeResultModelDataModels.h"

@interface HKXBasicRegisterViewController ()<CustomDropDownDelegate , UITextFieldDelegate>{
    
    NSTimer *timer;
    int time;
    UIButton * getVerificationCodeBtn;
}

@property (nonatomic , copy)NSString          * roleName;
@property (nonatomic , weak)CustomDropDownBtn * dropDownBtn;

@end

@implementation HKXBasicRegisterViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
//    [timer setFireDate:[NSDate distantFuture]];
//    [getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
//    getVerificationCodeBtn.enabled = YES;
}
#pragma mark - CreateUI
- (void)createUI
{
    self.roleName = [[NSString alloc] init];
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1];
    self.navigationItem.title = @"加盟注册";
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = item;
    
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 20 + 40 + 10 * myDelegate.autoSizeScaleY, ScreenWidth, ScreenHeight - 20 - 60 - 10 * myDelegate.autoSizeScaleY)];
    bottomView.backgroundColor = [UIColor whiteColor];
    bottomView.tag = 2000;
    [self.view addSubview:bottomView];
    
    NSArray * placeHolderArray = @[@"输入您的手机号",@"输入您的验证码",@"设置您的密码",@"再次输入您的新密码",@"选择您的身份"];
    for (int i = 0; i < 5; i ++)
    {
        UITextField * pswTF = [[UITextField alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY + (10 + 40) * i * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];
        if (i == 1)
        {
            pswTF.frame = CGRectMake((44 + 282 + 30) / 2 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY + (10 + 40) * i * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX - (141 + 15) * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY);
        }
        pswTF.placeholder = placeHolderArray[i];
        pswTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * myDelegate.autoSizeScaleX, pswTF.frame.size.height)];
        pswTF.leftView.backgroundColor = [UIColor clearColor];
        pswTF.leftViewMode = UITextFieldViewModeAlways;
        pswTF.borderStyle = UITextBorderStyleRoundedRect;
        pswTF.tag = 4000 + i;
        pswTF.delegate = self;
        pswTF.layer.borderColor = [[CommonMethod getUsualColorWithString:@"#a0a0a0"] CGColor];
        [bottomView addSubview:pswTF];
        
        if (i == 4)
        {
            CustomDropDownBtn * optionBtn = [[CustomDropDownBtn alloc] initWithFrame:CGRectMake(272 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY + (10 + 40) * i * myDelegate.autoSizeScaleY, 80 * myDelegate.autoSizeScaleX, pswTF.frame.size.height)];
            optionBtn.array = [NSMutableArray arrayWithObjects:@"机主",@"服务维修",@"供应商", nil];
            optionBtn.delegate = self;
            [bottomView addSubview:optionBtn];
            self.dropDownBtn = optionBtn;
            
            
        }
        if (i == 2 || i == 3)
        {
            pswTF.secureTextEntry = YES;
        }
        
        
    }
    
    getVerificationCodeBtn= [UIButton buttonWithType:UIButtonTypeCustom];
    getVerificationCodeBtn.frame = CGRectMake(22 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY + (10 + 40) * 1 * myDelegate.autoSizeScaleY, 282 / 2 * myDelegate.autoSizeScaleX, 40 *myDelegate.autoSizeScaleY);
    getVerificationCodeBtn.layer.cornerRadius = 4 * myDelegate.autoSizeScaleY;
    getVerificationCodeBtn.clipsToBounds = YES;
    [getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    getVerificationCodeBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    [getVerificationCodeBtn addTarget:self action:@selector(getVerificationCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:getVerificationCodeBtn];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake((ScreenWidth - 274 * myDelegate.autoSizeScaleX) / 2, 10 * myDelegate.autoSizeScaleY + (10 + 40) * 4 * myDelegate.autoSizeScaleY + 40 * myDelegate.autoSizeScaleY + 376 / 2 * myDelegate.autoSizeScaleY, 274 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
    submitBtn.layer.cornerRadius = 3 * myDelegate.autoSizeScaleY;
    submitBtn.clipsToBounds = YES;
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    submitBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    [submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:submitBtn];
}
#pragma mark - ConfigData
#pragma mark - Action

/**
获得注册手机对应的验证码信息

 @param btn 按钮
 */
- (void)getVerificationCodeBtnClick:(UIButton *)btn
{
    UIView * backView = [self.view viewWithTag:2000];
    UITextField * phoneTF = [backView viewWithTag:4000];
    NSString * mobile = phoneTF.text;
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
        [HKXHttpRequestManager sendRequestWithUserPhoneNumber:phoneTF.text ToGetUserRegisterCodeResult:^(id data) {
            HKXUserVertificationCodeResultModel * model = data;
            if (!model.success)
            {
                [self showHint:model.message];
//                UIView * backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
//                backGroundView.backgroundColor = [UIColor darkGrayColor];
//                backGroundView.alpha = 0.3;
//                backGroundView.tag = 506;
//                [self.view addSubview:backGroundView];
//                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
//                [backGroundView addGestureRecognizer:tap];
//                CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:model.message sure:@"确定" sureBtnClick:^{
//                    
//                    [self tapGestureClick];
//                } WithAlertHeight:160];
//                customAlertView.tag = 507;
//                [self.view addSubview:customAlertView];
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
                
                //                getVerificationCodeBtn.enabled = NO;
                //                time = 60;
                //                timer = [NSTimer scheduledTimerWithTimeInterval:1.0  target:self selector:@selector(countdown) userInfo:nil repeats:YES];
                //                [timer fire];
                
            }
        }];
//        [HKXHttpRequestManager sendRequestWithUserPhoneNumber:phoneTF.text ToGetVertificationCode:^(id data) {
//            HKXUserVertificationCodeResultModel * model = data;
//            if (!model.success)
//            {
//                UIView * backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
//                backGroundView.backgroundColor = [UIColor darkGrayColor];
//                backGroundView.alpha = 0.3;
//                backGroundView.tag = 506;
//                [self.view addSubview:backGroundView];
//                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
//                [backGroundView addGestureRecognizer:tap];
//                CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:model.message sure:@"确定" sureBtnClick:^{
//                    
//                    [self tapGestureClick];
//                } WithAlertHeight:160];
//                customAlertView.tag = 507;
//                [self.view addSubview:customAlertView];
//            }
//            else
//            {
//                HKXUserVertificationCodeData * data = model.data;
//                NSLog(@"验证码%@",data.number);
//                CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:[NSString stringWithFormat:@"验证码%@",data.number] sure:@"确定" sureBtnClick:^{
//                    
//                    [self tapGestureClick];
//                } WithAlertHeight:160];
//                customAlertView.tag = 507;
//                [self.view addSubview:customAlertView];
//                
////                getVerificationCodeBtn.enabled = NO;
////                time = 60;
////                timer = [NSTimer scheduledTimerWithTimeInterval:1.0  target:self selector:@selector(countdown) userInfo:nil repeats:YES];
////                [timer fire];
//                
//            }
//        }];
    }
}
- (void)countdown{
    
    time--;
    if (time == 0) {
        [timer setFireDate:[NSDate distantFuture]];
        [getVerificationCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
        getVerificationCodeBtn.enabled = YES;
        
    }else{
        
        [getVerificationCodeBtn setTitle:[NSString stringWithFormat:@"%d秒后重新获取",time] forState:UIControlStateNormal];
    }
}

- (void)submitBtnClick
{
    UIView * bottomView = [self.view viewWithTag:2000];
    for (UITextField * tf in bottomView.subviews)
    {
        if (tf.tag >= 4000 && tf.tag <= 4004)
        {
            if ([tf.text isEqualToString:@""])
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
            
            UITextField * userPswTf = [bottomView viewWithTag:4002];
            UITextField * reUserPswTf = [bottomView viewWithTag:4003];
            if (![userPswTf.text isEqualToString:reUserPswTf.text])
            {
                UIView * backGroundView = [[UIView alloc] initWithFrame:self.view.bounds];
                backGroundView.backgroundColor = [UIColor darkGrayColor];
                backGroundView.alpha = 0.3;
                backGroundView.tag = 502;
                [self.view addSubview:backGroundView];
                UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
                [backGroundView addGestureRecognizer:tap];
                CustomSubmitView * customAlertView = [CustomSubmitView alertViewWithTitle:@"提示" content:@"两次密码输入不一致" sure:@"确定" sureBtnClick:^{
                    reUserPswTf.text = [NSString stringWithFormat:@""];
                    [self tapGestureClick];
                } WithAlertHeight:160];
                customAlertView.tag = 503;
                [self.view addSubview:customAlertView];
                return;
            }
        }
    }
    NSString * roleId;
    UITextField * verificationTF = [bottomView viewWithTag:4001];
    UITextField * userNameTF = [bottomView viewWithTag:4000];
    UITextField * userPswTf = [bottomView viewWithTag:4002];
    if ([self.roleName isEqualToString:@"机主"])
    {
        roleId = [NSString stringWithFormat:@"%d",0];
    }
    else if ([self.roleName isEqualToString:@"服务维修"])
    {
        roleId = [NSString stringWithFormat:@"%d",1];
    }
    else
    {
        roleId = [NSString stringWithFormat:@"%d",2];
    }
    [self.view showActivity];
    [HKXHttpRequestManager sendRequestWithUserName:userNameTF.text WithUserPsw:userPswTf.text WithUserRole:roleId WithUserVerificationCode:verificationTF.text ToGetRegisterResult:^(id data) {
        [self.view hideActivity];
        HKXRegisterResult * model = data;
        if (model.success)
        {
            HKXBasicInfoRegisterViewController * basicInfoVC = [[HKXBasicInfoRegisterViewController alloc] init];
            basicInfoVC.navigationItem.title = self.roleName;
            basicInfoVC.userMobile = userNameTF.text;
            basicInfoVC.userRegisterData = model.data;
            [self.navigationController pushViewController:basicInfoVC animated:YES];
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
- (void)didSelectedOptionInCustomDropDownBtn:(CustomDropDownBtn *)dropDownBtn
{
    UITextField * userTF = [self.view viewWithTag:4004];
    userTF.text = dropDownBtn.selectedTitle;
    self.roleName = dropDownBtn.selectedTitle;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 4004)
    {
        textField.enabled = NO;
    }
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 4000)
    {
        
        NSString * mobile = textField.text;
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
        
    }
}
#pragma mark - Setters & Getters

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
