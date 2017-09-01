//
//  HKXMineAddNewReceiveAddressViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineAddNewReceiveAddressViewController.h"
#import "CommonMethod.h"

#import "HKXMineShoppingGoodsDetailViewController.h"//订单结算界面

#import "HKXHttpRequestManager.h"
#import "HKXMineServeCertificateProfileModel.h"//增加结果

@interface HKXMineAddNewReceiveAddressViewController ()<UITextFieldDelegate>
{
    UIView * _bottomView;//底层白色视图
}

@end

@implementation HKXMineAddNewReceiveAddressViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 7 * myDelegate.autoSizeScaleY + 60, ScreenWidth, ScreenHeight - 60 - 30 * myDelegate.autoSizeScaleY)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    NSArray * placeHolderArray = [NSArray arrayWithObjects:@"请输入收货人姓名",@"请输入收货人地址",@"请输入收货人联系电话", nil];
    NSArray * rightContentArray = [NSArray array];
    if (self.isNew == NO)
    {
            rightContentArray = [NSArray arrayWithObjects:self.addressData.consignees,self.addressData.consigneesAdd,self.addressData.consigneesTel, nil];
    }

    for (int i = 0; i < placeHolderArray.count; i ++)
    {
        UITextField * addressTF = [[UITextField alloc] initWithFrame:CGRectMake(10 * myDelegate.autoSizeScaleX, 50 * myDelegate.autoSizeScaleY * i + 10 * myDelegate.autoSizeScaleY, ScreenWidth - 20 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];

        addressTF.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
        addressTF.borderStyle = UITextBorderStyleRoundedRect;
        addressTF.placeholder = placeHolderArray[i];
        addressTF.delegate = self;
        addressTF.tag = 8000 + i;
        addressTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * myDelegate.autoSizeScaleX, addressTF.frame.size.height)];
        addressTF.leftView.backgroundColor = [UIColor clearColor];
        addressTF.leftViewMode = UITextFieldViewModeAlways;
        if (self.isNew == NO)
        {
            addressTF.text = [NSString stringWithFormat:@"%@",rightContentArray[i]];
        }
        [_bottomView addSubview:addressTF];
        
        if (i == placeHolderArray.count - 1)
        {
            UIButton * saveAndUseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            saveAndUseBtn.frame = CGRectMake(50 * myDelegate.autoSizeScaleX, 333 * myDelegate.autoSizeScaleY + CGRectGetMaxY(addressTF.frame), ScreenWidth - 100 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
            saveAndUseBtn.tag = 7000;
            saveAndUseBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
            saveAndUseBtn.layer.cornerRadius = 2;
            saveAndUseBtn.clipsToBounds = YES;
            [saveAndUseBtn setTitle:@"保存并使用" forState:UIControlStateNormal];
            [saveAndUseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [saveAndUseBtn addTarget:self action:@selector(saveAndUseNewAddressBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_bottomView addSubview:saveAndUseBtn];
        }
    }
}
#pragma mark - ConfigData
- (void)loadData
{
    UITextField * userNameTf = [_bottomView viewWithTag:8000];
    NSString * userName = [userNameTf.text isEqualToString:@""] ? (NSString *)[NSNull null] : userNameTf.text;
    UITextField * userTelTf = [_bottomView viewWithTag:8001];
    NSString * userTel = [userTelTf.text isEqualToString:@""] ? (NSString *)[NSNull null] : userTelTf.text;
    UITextField * userAddTf = [_bottomView viewWithTag:8002];
    NSString * userAdd = [userAddTf.text isEqualToString:@""] ? (NSString *)[NSNull null] : userAddTf.text;
    long userId = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userDataId"];
    if (self.isNew == YES)
    {
        [HKXHttpRequestManager sendRequestWithUserId:[NSString stringWithFormat:@"%ld",userId] WithUserName:userName WithUserTel:userTel WithUserAdd:userAdd ToGetAddNewAddResult:^(id data) {
            HKXMineServeCertificateProfileModel * model = data;
            [self showHint:model.message];
            if (model.success)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
    else
    {
        [HKXHttpRequestManager sendRequestWithUserId:[NSString stringWithFormat:@"%ld",self.addressData.addId] WithUserName:userName WithUserTel:userTel WithUserAdd:userAdd ToGetUpdateAddResult:^(id data) {
            HKXMineServeCertificateProfileModel * model = data;
            [self showHint:model.message];
            if (model.success)
            {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}
#pragma mark - Action
- (void)saveAndUseNewAddressBtnClick:(UIButton *)btn
{
    
    [self loadData];
    
    
    
}
#pragma mark - Private Method
#pragma mark - Delegate & Data Source
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text = @"";
}
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
