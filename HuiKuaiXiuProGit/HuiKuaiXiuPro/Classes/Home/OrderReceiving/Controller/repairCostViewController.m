//
//  repairCostViewController.m
//  HuiKuaiXiuPro
//
//  Created by daemona on 2017/8/7.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "repairCostViewController.h"

#import "repairCostTableViewCell.h"

@interface repairCostViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
    UILabel * totalCost;
}

@property(nonatomic ,strong)UITableView * costTableView;
@property(nonatomic ,copy)NSString * hourCost;
@property(nonatomic ,copy)NSString * partsCost;

@end



@implementation repairCostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"服务维修费";
    [self createUI];
}


- (void)createUI{
    
    _costTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight / 2- 64 +100 ) style:UITableViewStylePlain];
    _costTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _costTableView.delegate = self;
    _costTableView.dataSource = self;
    [_costTableView registerNib:[UINib nibWithNibName:@"repairCostTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:_costTableView];
    
    UIButton * sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth / 3, ScreenHeight / 2 + 100, ScreenWidth / 3, 40)];
    [sureBtn setTitle:@"确  定" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sureBtn setBackgroundColor:[UIColor whiteColor]];
    sureBtn.layer.borderWidth = 1.0f;
    sureBtn.layer.borderColor = [[UIColor blackColor] CGColor];
    sureBtn.layer.cornerRadius = 4.0f;
    sureBtn.layer.masksToBounds = YES;
    [sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    repairCostTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (!cell) {
        
        cell = [[repairCostTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.costNum.delegate = self;
    cell.costNum.tag = indexPath.row;
    [cell.costNum addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventEditingChanged];
    cell.totalCost.text = @"合计";
    if (indexPath.row == 0) {
        
        cell.costType.text = @"工时费";
        cell.costNum.placeholder = @"请输入工时费";
        [cell.costNum.text addObserver:self forKeyPath:@"costNum" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
        
    }else if (indexPath.row == 1){
        
        cell.costType.text = @"配件及附料";
        cell.costNum.placeholder = @"请输入配件及附料费";
        
    }else if (indexPath.row == 2){
        
        cell.costType.text = @"总计";
        totalCost = [[UILabel alloc] initWithFrame:cell.costNum.frame];
        
        [cell.costNum removeFromSuperview];
        totalCost.textColor = [UIColor blackColor];
        totalCost.textAlignment = NSTextAlignmentLeft;
        totalCost.layer.cornerRadius = 4.0f;
        totalCost.layer.borderWidth = 1.0f;
        totalCost.layer.borderColor = [[UIColor grayColor] CGColor];
        totalCost.layer.masksToBounds = YES;
        [cell.contentView addSubview:totalCost];
        
    }
    
    return cell;
}



-(void)changeValue:(UITextField *)textField
{
    switch (textField.tag)
    {
        case 0:
            _hourCost = textField.text;
            totalCost.text = [NSString stringWithFormat:@"  %.2f",[_hourCost floatValue] + [_partsCost floatValue]];
            break;
        case 1:
            _partsCost = textField.text;
            totalCost.text = [NSString stringWithFormat:@"  %.2f",[_hourCost floatValue] + [_partsCost floatValue]];
            break;
        default:
            break;
    }
    
    
    
}

//点击确定按钮事件
- (void)sureClick:(UIButton *)btn{
    
    if ([totalCost.text floatValue] == 0) {
        
        [self showHint:@"请输入维修费用"];
        return;
    }

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:[self.repairId doubleValue]],@"ruoId",_hourCost,@"hourCost",_partsCost,@"partsCost",nil];
    NSLog(@"%@",dict);
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"repair/money.do"] params:dict success:^(id responseObject) {
        
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
