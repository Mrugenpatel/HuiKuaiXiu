//
//  HKXMineSupplierAskValueListViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/28.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineSupplierAskValueListViewController.h"
#import "CommonMethod.h"

@interface HKXMineSupplierAskValueListViewController ()<UITableViewDelegate , UITableViewDataSource>
{
    UITableView * _listTableView;//询价列表
}
@end

@implementation HKXMineSupplierAskValueListViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 60, ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60) style:UITableViewStylePlain];
    _listTableView.backgroundColor = [UIColor whiteColor];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    [self.view addSubview:_listTableView];
    
    [_listTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - ConfigData
#pragma mark - Action
- (void)phoneCallBtnClick:(UIButton *)btn
{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"1008611"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
    
    
}
#pragma mark - Private Method
#pragma mark - Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return 114 * myDelegate.autoSizeScaleY;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    UIImageView * reLogoImage = [cell viewWithTag:3000];
    [reLogoImage removeFromSuperview];
    UILabel * reTitleLabel = [cell viewWithTag:3001];
    [reTitleLabel removeFromSuperview];
    UILabel * reLabelLabel = [cell viewWithTag:3002];
    [reLabelLabel removeFromSuperview];
    UILabel * reNumberLabel = [cell viewWithTag:3003];
    [reNumberLabel removeFromSuperview];
    //TODO:此处待修改button的tag值
    UIButton * reEditBtn = [cell viewWithTag:3004];
    [reEditBtn removeFromSuperview];
    UILabel * rePhoneLabel = [cell viewWithTag:3005];
    [rePhoneLabel removeFromSuperview];
    
    UIImageView * logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(17 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, 102 * myDelegate.autoSizeScaleX, 95 * myDelegate.autoSizeScaleY)];
            logoImageView.image = [UIImage imageNamed:@"滑动视图示例"];
//    [logoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,equipmentModel.picture]] placeholderImage:[UIImage imageNamed:@"滑动视图示例"]];
    logoImageView.tag = 3000;
    [cell addSubview:logoImageView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 16 * myDelegate.autoSizeScaleX, 21 * myDelegate.autoSizeScaleY, 184 * myDelegate.autoSizeScaleX, 13 * myDelegate.autoSizeScaleX)];
    titleLabel.tag = 3001;
    titleLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
            titleLabel.text = @"挖掘机 卡特彼勒（caterpillar）";
//    titleLabel.text = [NSString stringWithFormat:@"%@",equipmentModel.type];
    [cell addSubview:titleLabel];
    
    UILabel * labelLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 16 * myDelegate.autoSizeScaleX, CGRectGetMaxY(titleLabel.frame) + 12 * myDelegate.autoSizeScaleY, 184 * myDelegate.autoSizeScaleX, 13 * myDelegate.autoSizeScaleX)];
    labelLabel.tag = 3002;
    labelLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
            labelLabel.text = @"XG806F";
//    labelLabel.text = equipmentModel.modelnum;
    [cell addSubview:labelLabel];
    
    UILabel * numeberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 16 * myDelegate.autoSizeScaleX,CGRectGetMaxY(labelLabel.frame) + 12 * myDelegate.autoSizeScaleY, 184 * myDelegate.autoSizeScaleX, 13 * myDelegate.autoSizeScaleX)];
    numeberLabel.tag = 3003;
    numeberLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
            numeberLabel.text = @"询价人：网上";
//    numeberLabel.text = equipmentModel.brand;
    [cell addSubview:numeberLabel];
    
    UILabel * phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(logoImageView.frame) + 16 * myDelegate.autoSizeScaleX, CGRectGetMaxY(numeberLabel.frame) + 12 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"询价人电话：" WithFont:13 * myDelegate.autoSizeScaleX], 13 * myDelegate.autoSizeScaleX)];
    phoneLabel.tag = 3005;
    phoneLabel.text = @"询价人电话：";
    phoneLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
    [cell addSubview:phoneLabel];
    
    
    UIButton * phoneNumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneNumBtn.tag = 3004;
    phoneNumBtn.frame = CGRectMake(CGRectGetMaxX(phoneLabel.frame) , CGRectGetMaxY(numeberLabel.frame) + 12 *myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"18709876543" WithFont:12 * myDelegate.autoSizeScaleX], 16 * myDelegate.autoSizeScaleY);

    [phoneNumBtn setTitle:@"18709876543" forState:UIControlStateNormal];
    
    phoneNumBtn.titleLabel.font = [UIFont systemFontOfSize:12 * myDelegate.autoSizeScaleX];
    [phoneNumBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateNormal];
    
    [phoneNumBtn addTarget:self action:@selector(phoneCallBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell addSubview:phoneNumBtn];
    
    return cell;
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
