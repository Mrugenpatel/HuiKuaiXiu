//
//  goodsDetailViewController.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/7/27.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "goodsEquipmentDetailViewController.h"

#import "HKXShoppingMallViewController.h"

#import "goodsInfoTableViewCell.h"

#import "askPopView.h"

@interface goodsEquipmentDetailViewController ()<UITableViewDelegate,UITableViewDataSource,submitClickDelegate>{
    
    UIImageView * goodsImgView;//商品图片
    UILabel * goodsName;//产品名字
    UITableView * goodsInfoTableView;//产品信息
    UITableView * goodsDetailTableView;//产品详情
    UIButton * buyBtn;
    askPopView * popView;//询价按钮
}

@end

@implementation goodsEquipmentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"设备详情";
    [self createUI];
}

- (void)createUI{
    
    
    self.view.backgroundColor  = [UIColor whiteColor];

    goodsImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 150)];
    goodsImgView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,self.equipmentModel.picture]]]];
    [self.view addSubview:goodsImgView];
    
    goodsName = [[UILabel alloc] initWithFrame:CGRectMake(20, goodsImgView.frame.origin.y + goodsImgView.frame.size.height, ScreenWidth - 40, 50)];
    goodsName.text = self.equipmentModel.brand;
    goodsName.numberOfLines = 0;
    goodsName.lineBreakMode = NSLineBreakByWordWrapping;
    goodsName.font = [UIFont systemFontOfSize:20];
    [self.view addSubview:goodsName];
    
    buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    buyBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth / 3 * 2 - 30, ScreenHeight - 80, ScreenWidth / 3, 50)];
    [buyBtn setTitle:@"询 价" forState:UIControlStateNormal];
    [buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    buyBtn.layer.cornerRadius = 4;
    [buyBtn setBackgroundColor:[UIColor orangeColor]];
    [buyBtn addTarget:self action:@selector(askPrice:) forControlEvents:UIControlEventTouchUpInside];
    buyBtn.layer.masksToBounds = YES;
    [self.view addSubview:buyBtn];
    goodsInfoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, goodsName.frame.origin.y + goodsName.frame.size.height, ScreenWidth - goodsName.frame.origin.x * 2, ScreenHeight - 80 - goodsName.frame.origin.y - goodsName.frame.size.height) style:UITableViewStylePlain];
    goodsInfoTableView.delegate = self;
    goodsInfoTableView.dataSource = self;
    goodsInfoTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [goodsInfoTableView registerNib:[UINib nibWithNibName:@"goodsInfoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:goodsInfoTableView];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        
        return 30;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return 5;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        goodsInfoTableViewCell * cell = [goodsInfoTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            
            cell.titleLb.text = @"关键参数:";
            cell.detailLB.text = self.equipmentModel.parameter;
        }else if (indexPath.row == 1){
            
            cell.titleLb.text = @"企业名称:";
            cell.detailLB.text = self.equipmentModel.compname;
        }else if (indexPath.row == 2){
            
            cell.titleLb.text = @"设备类型:";
            cell.detailLB.text = self.equipmentModel.type;
        }else if (indexPath.row == 3){
            
            cell.titleLb.text = @"名牌:";
            cell.detailLB.text = self.equipmentModel.brand;
        }else if (indexPath.row == 4){
            
            cell.titleLb.text = @"描述:";
            cell.detailLB.text = self.equipmentModel.bewrite;
        }
        
        return cell;
        
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)askPrice:(UIButton *)askPrice{
    
    popView = [[askPopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    popView.brandLb.text =[NSString stringWithFormat:@" 品牌:%@  型号:%@  类型:%@",self.equipmentModel.brand,self.equipmentModel.modelnum,self.equipmentModel.type];
    popView.brandLb.textColor = [UIColor blackColor];
    popView.delegate = self;
    [self.view addSubview:popView];
    
}

- (void)submitClick{
    
    if (popView.nameTf.text.length == 0) {
        
        [self showHint:@"请输入姓名"];
        return;
    }
    if (popView.teleTf.text.length == 0) {
        
        [self showHint:@"请输入电话"];
        return;
    }
    if (popView.addressTF.text.length == 0) {
        
        [self showHint:@"请输入地区"];
        return;
    }
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:self.equipmentModel.pmaId,@"mId",popView.nameTf.text,@"inquiryName",popView.teleTf.text,@"inquiryTel",popView.addressTF.text,@"inquiryAdd",[NSNumber numberWithDouble:uId],@"uId",nil];
    NSLog(@"%@",dict);
    
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"inquiry/inquiry.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue] == YES) {
            
            [self showHint:dicts[@"message"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }else{
            
            [self showHint:dicts[@"message"]];
        }
        
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        
        [self.view hideActivity];
        [self showHint:@"请求失败"];
        
    }];
    

    
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
