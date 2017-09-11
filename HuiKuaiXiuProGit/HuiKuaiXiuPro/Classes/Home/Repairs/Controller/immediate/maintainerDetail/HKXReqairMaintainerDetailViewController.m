//
//  HKXReqairMaintainerDetailViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/21.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXReqairMaintainerDetailViewController.h"

#import "CommonMethod.h"
#import "UIImageView+WebCache.h"

#import "HKXHttpRequestManager.h"
#import "HKXMineServeCertificateProfileModelDataModels.h"//证书资料

@interface HKXReqairMaintainerDetailViewController ()

@property (nonatomic , strong) NSArray * serveSpecArray;//主修种类
@property (nonatomic , strong) NSMutableArray * certificateProfileArray;//证书数组

@end

@implementation HKXReqairMaintainerDetailViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    [self loadData];
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1];
    self.navigationItem.title = @"维修师";
    
    UIView * backGroudView = [[UIView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 60, ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60)];
    backGroudView.tag = 480;
    backGroudView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backGroudView];
    
    NSArray * contentArray = @[_maintainerName,_maintainerTele,@""];
    for (int i = 0; i < 3; i ++)
    {
        UITextField * contentTF = [[UITextField alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, (10 + 50 * i) * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY)];
        contentTF.enabled = NO;
        contentTF.tag = 20000 + i;
        contentTF.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
        contentTF.text = contentArray[i];
        contentTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10 * myDelegate.autoSizeScaleX, contentTF.frame.size.height)];
        contentTF.leftView.backgroundColor = [UIColor clearColor];
        contentTF.leftViewMode = UITextFieldViewModeAlways;
        contentTF.borderStyle = UITextBorderStyleRoundedRect;
        [backGroudView addSubview:contentTF];
        if (i == 1)
        {
//            主修
            float troubleLabelLength = [CommonMethod getLabelLengthWithString:@"主修" WithFont:17 * myDelegate.autoSizeScaleX];
            UILabel * majorLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, CGRectGetMaxY(contentTF.frame) + 22 * myDelegate.autoSizeScaleY, troubleLabelLength, 17 * myDelegate.autoSizeScaleX)];
            majorLabel.text = @"主修";
            majorLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
            [backGroudView addSubview:majorLabel];
            
            float serveSpecLabelLength = [CommonMethod getLabelLengthWithString:@"液压系统" WithFont:14 * myDelegate.autoSizeScaleX];
            NSArray * troubleTitleArray = @[@"液压系统",@"机械部位",@"发动机",@"电路",@"保养"];
            for (int j = 0; j < troubleTitleArray.count; j ++)
            {
                int X = j % 3;
                int Y = j / 3;
                
                UIButton * serveSpecBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(majorLabel.frame) + 16 * myDelegate.autoSizeScaleX + X * (38 * myDelegate.autoSizeScaleX + serveSpecLabelLength), CGRectGetMaxY(contentTF.frame) + 24 * myDelegate.autoSizeScaleY + Y * 49 * myDelegate.autoSizeScaleY, 12 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX)];
//                serveSpecBtn.backgroundColor = [UIColor redColor];
                [serveSpecBtn setImage:[UIImage imageNamed:@"复选框-未选中"] forState:UIControlStateNormal];
                [serveSpecBtn setImage:[UIImage imageNamed:@"复选框_已选择"] forState:UIControlStateSelected];
                serveSpecBtn.tag = 30000 + j;
                
                [backGroudView addSubview:serveSpecBtn];
                
                UILabel * majorLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(serveSpecBtn.frame) + 10 * myDelegate.autoSizeScaleX, serveSpecBtn.frame.origin.y, serveSpecLabelLength, 14 * myDelegate.autoSizeScaleX)];
                majorLabel.text = troubleTitleArray[j];
                majorLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
                [backGroudView addSubview:majorLabel];
            }
        }
        if (i == 2)
        {
            contentTF.frame = CGRectMake(22 * myDelegate.autoSizeScaleX, (10 + 50 * i) * myDelegate.autoSizeScaleY + 98 * myDelegate.autoSizeScaleY, ScreenWidth - 44 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY);
            
//            证书
            float troubleLabelLength = [CommonMethod getLabelLengthWithString:@"证书" WithFont:17 * myDelegate.autoSizeScaleX];
            UILabel * certificateLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, CGRectGetMaxY(contentTF.frame) + 23 * myDelegate.autoSizeScaleY, troubleLabelLength, 17 * myDelegate.autoSizeScaleX)];
            certificateLabel.text = @"证书";
            certificateLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
            [backGroudView addSubview:certificateLabel];
            
            for (int j = 0; j < 5; j ++)
            {
                int X = j % 3;
                int Y = j / 3;
                UIImageView * certificateImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(certificateLabel.frame) + ( 17 + X * 100) * myDelegate.autoSizeScaleX, CGRectGetMaxY(contentTF.frame) + (23 + Y * 70) * myDelegate.autoSizeScaleY, 97 * myDelegate.autoSizeScaleX, 61 * myDelegate.autoSizeScaleY)];
                [backGroudView addSubview:certificateImage];
                
                if (j == 4)
                {
                    NSArray * btnTitleArray = @[@"确认订单",@"立即联系"];
                    NSArray * btnBGColorArray = @[@"#e06e15",@"#ffa304"];
                    for (int a = 0; a < 2; a ++)
                    {
                        UIButton * actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                        actionBtn.frame = CGRectMake((22 + (150 + 31) * a) * myDelegate.autoSizeScaleX, CGRectGetMaxY(certificateImage.frame) + 62 * myDelegate.autoSizeScaleY, 150 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
                        [actionBtn setTitle:btnTitleArray[a] forState:UIControlStateNormal];
                        [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        actionBtn.backgroundColor = [CommonMethod getUsualColorWithString:btnBGColorArray[a]];
                        actionBtn.tag = 50000 + a;
                        [actionBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                        actionBtn.layer.cornerRadius = 2;
                        actionBtn.clipsToBounds = YES;
                        [backGroudView addSubview:actionBtn];
                    }
                }
            }
        }
    }
}
#pragma mark - ConfigData

- (void)loadData
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView * backView = [self.view viewWithTag:480];
    [HKXHttpRequestManager sendRequestWithUserId:[NSString stringWithFormat:@"%@",_maintainerId] ToGetUserCertificateProfileResult:^(id data) {
        HKXMineServeCertificateProfileModel * model = data;
        if (model.success)
        {
            for (int btnTag = 30000; btnTag < 30005; btnTag ++)
            {
                NSString * majorString = [NSString stringWithFormat:@"%d",btnTag - 30000];
                
                if ([model.data.majorMachine rangeOfString:majorString].location != NSNotFound)
                {
                    
                    UIButton * btn = [backView viewWithTag:btnTag];
                    btn.selected = YES;
                }
            }
            UITextField * skillTF = [backView viewWithTag:20002];
            skillTF.text = model.data.profile;
            skillTF.enabled = NO;
            
            [self.certificateProfileArray removeAllObjects];
            self.certificateProfileArray = (NSMutableArray *)model.data.credentials;
            float length = [CommonMethod getLabelLengthWithString:@"主修" WithFont:17 * myDelegate.autoSizeScaleY];
            for (int i = 0; i < self.certificateProfileArray.count; i ++)
            {
                int x = i % 2;
                int y = i / 2;
                UIImageView * certificateView = [[UIImageView alloc] initWithFrame:CGRectMake((length + (22 + 17) * myDelegate.autoSizeScaleX ) + x * 100 * myDelegate.autoSizeScaleX, CGRectGetMaxY(skillTF.frame) + 23 * myDelegate.autoSizeScaleY + y * 70 * myDelegate.autoSizeScaleY, 97 * myDelegate.autoSizeScaleX, 61 * myDelegate.autoSizeScaleY)];
                
                [certificateView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,self.certificateProfileArray[i]]] placeholderImage:[UIImage imageNamed:@"滑动视图示例"]];
                [backView addSubview:certificateView];
            }
            
            
        }
    }];
}
#pragma mark - Action
- (void)actionBtnClick:(UIButton *)btn
{
    if (btn.tag - 50000 == 1)
    {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",_maintainerTele];
        UIWebView * callWebview = [[UIWebView alloc] init];
        [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
        [self.view addSubview:callWebview];
    }else{
      
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_ruoId,@"ruoId",[NSNumber numberWithDouble:[_maintainerId doubleValue]],@"repairId",nil];
        NSLog(@"%@",dict);
        
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"repair/confirmOrder.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            if ([dicts[@"success"] boolValue] == YES) {
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
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
- (NSArray *)serveSpecArray
{
    if (!_serveSpecArray)
    {
        _serveSpecArray = [NSArray array];
    }
    return _serveSpecArray;
}
- (NSMutableArray *)certificateProfileArray
{
    if (!_certificateProfileArray)
    {
        _certificateProfileArray = [NSMutableArray array];
    }
    return _certificateProfileArray;
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
