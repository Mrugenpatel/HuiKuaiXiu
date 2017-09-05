//
//  HKXMineBuyingDetailViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineBuyingDetailViewController.h"
#import "HKXMinePayViewController.h"
#import "CommonMethod.h"

#import "HKXGoodsView.h"

@interface HKXMineBuyingDetailViewController ()<UITableViewDelegate , UITableViewDataSource>
{
    UITableView * _detailTableView;//订单详情
}

@end

@implementation HKXMineBuyingDetailViewController
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
    
    _detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 7 * myDelegate.autoSizeScaleY + 64, ScreenWidth, ScreenHeight  - 30 * myDelegate.autoSizeScaleY - 64) style:UITableViewStylePlain];
    _detailTableView.dataSource = self;
    _detailTableView.delegate = self;
    _detailTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_detailTableView];
    [_detailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}
#pragma mark - ConfigData
#pragma mark - Action

#pragma mark - Private Method
#pragma mark - Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (indexPath.row == 0)
    {
        return 95 / 2 * myDelegate.autoSizeScaleY;
    }
    else if (indexPath.row == 1)
    {
        return 80 * myDelegate.autoSizeScaleY;
    }
    else if (indexPath.row == 2)
    {
        return 30 * myDelegate.autoSizeScaleY;
    }
    else if (indexPath.row == 3)
    {
        return (190 + 20 + 34) / 2 * myDelegate.autoSizeScaleY * self.store.goodsArr.count;
    }
    else if (indexPath.row == 7)
    {
        return _detailTableView.frame.size.height - (95 / 2 + 80 + 30 + (190 + 20 + 34) / 2 + 40 * 3) * myDelegate.autoSizeScaleY;
    }
    else
    {
        return 40 * myDelegate.autoSizeScaleY;
    }
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel * reLab1 = [cell viewWithTag:50000];
    [reLab1 removeFromSuperview];
    UILabel * reLab2 = [cell viewWithTag:50001];
    [reLab2 removeFromSuperview];
    UILabel * reLab3 = [cell viewWithTag:50002];
    [reLab3 removeFromSuperview];
    UILabel * reLab4 = [cell viewWithTag:50003];
    [reLab4 removeFromSuperview];
    UILabel * reLab5 = [cell viewWithTag:50004];
    [reLab5 removeFromSuperview];
    UIImageView * reImg = [cell viewWithTag:50005];
    [reImg removeFromSuperview];
    UIButton * reOneMoreBtn = [cell viewWithTag:50006];
    [reOneMoreBtn removeFromSuperview];
    UIButton * reOneMoreBtn2 = [cell viewWithTag:50007];
    [reOneMoreBtn2 removeFromSuperview];
    
    UILabel * label1 = [[UILabel alloc] init];
    label1.tag = 50000;
    [cell addSubview:label1];
    UILabel * label2 = [[UILabel alloc] init];
    label2.tag = 50001;
    [cell addSubview:label2];
    UILabel * label3 = [[UILabel alloc] init];
    label3.tag = 50003;
    [cell addSubview:label3];
    UILabel * label4 = [[UILabel alloc] init];
    label4.tag = 50004;
    [cell addSubview:label4];
    
    if (indexPath.row == 0)
    {
        label1.frame = CGRectMake(30 * myDelegate.autoSizeScaleX, 20 * myDelegate.autoSizeScaleY, 300 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleX);
        label1.text =[NSString stringWithFormat:@"订单号:%@",self.store.orderId];
        label1.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
        
        label2.frame = CGRectMake(300 * myDelegate.autoSizeScaleX, 20 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"卖家待发货" WithFont:16 * myDelegate.autoSizeScaleX], 16 * myDelegate.autoSizeScaleX);
        label2.text = [NSString stringWithFormat:@"%@",_store.orderMessage];
        label2.textColor = [UIColor redColor];
        label2.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
    }
    else if (indexPath.row == 1)
    {
        label1.frame = CGRectMake(30 * myDelegate.autoSizeScaleX, 13 * myDelegate.autoSizeScaleY, 300 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleX);
        label1.text = [NSString stringWithFormat:@"%@ %@",self.store.companyName,self.store.addTel];
        label1.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
        
        label2.frame = CGRectMake(30 * myDelegate.autoSizeScaleX, CGRectGetMaxY(label1.frame) + 25 * myDelegate.autoSizeScaleY, 300 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleX);
        label2.text = [NSString stringWithFormat:@"%@",self.store.add];
        label2.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
    }
    else if (indexPath.row == 2)
    {
        cell.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
        label1.frame = CGRectMake(30 * myDelegate.autoSizeScaleX, 8 * myDelegate.autoSizeScaleY, 300 * myDelegate.autoSizeScaleX, 14 * myDelegate.autoSizeScaleY);
        label1.text = [NSString stringWithFormat:@"%@",self.store.companyName];
        label1.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
    }
    else if (indexPath.row == 3)
    {
        for (int i = 0; i < self.store.goodsArr.count; i ++) {
            
            HKXGoodsView * goodsView = [[HKXGoodsView alloc] initWithFrame:CGRectMake(0,(190 + 20 + 34) / 2 * myDelegate.autoSizeScaleY * i, ScreenWidth, (190 + 20 + 34) / 2 * myDelegate.autoSizeScaleY)];
            goodsView.goods = self.store.goodsArr[i];
            [cell addSubview:goodsView];
        }
        
    }
    else if (indexPath.row == 7)
    {
        label1.frame = CGRectMake(224 * myDelegate.autoSizeScaleX, 13 * myDelegate.autoSizeScaleY, ScreenWidth - 224 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleY);
        label1.text = [NSString stringWithFormat:@"实付款:¥ %.2f",[self.store.cost floatValue]];
        label1.textColor = [UIColor redColor];
        label1.font = [UIFont boldSystemFontOfSize:15 * myDelegate.autoSizeScaleY];
        
        UIButton * leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.tag = 50006;
        leftBtn.frame = CGRectMake(217 * myDelegate.autoSizeScaleX -  150 * myDelegate.autoSizeScaleX - 30* myDelegate.autoSizeScaleX, CGRectGetMaxY(label1.frame) + 67 * myDelegate.autoSizeScaleY, 150 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY);
        leftBtn.layer.cornerRadius = 2;
        leftBtn.clipsToBounds = YES;
        leftBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
        
        [leftBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(leftBtnclick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:leftBtn];
        
        UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.tag = 50007;
        rightBtn.frame = CGRectMake(217 * myDelegate.autoSizeScaleX, CGRectGetMaxY(label1.frame) + 67 * myDelegate.autoSizeScaleY, 150 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY);
        rightBtn.layer.cornerRadius = 2;
        rightBtn.clipsToBounds = YES;
        rightBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
        [rightBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(rightBtnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        //卖家待发货
        if ([[NSString stringWithFormat:@"%@",self.store.orderStatus] isEqualToString:@"10"]){
            
            leftBtn.hidden = YES;
            rightBtn.hidden = YES;
            
        } //交易成功
        else if ([[NSString stringWithFormat:@"%@",self.store.orderStatus] isEqualToString:@"0"]){
            
            [leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [rightBtn setTitle:@"再来一单" forState:UIControlStateNormal];
           
            
        }//待付款
        else if ([[NSString stringWithFormat:@"%@",self.store.orderStatus] isEqualToString:@"11"]){
     
            [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [rightBtn setTitle:@"去支付" forState:UIControlStateNormal];
         
        }//卖家已发货
        else if ([[NSString stringWithFormat:@"%@",self.store.orderStatus] isEqualToString:@"2"]){
           
            [leftBtn setTitle:@"确认收货" forState:UIControlStateNormal];
            [rightBtn setTitle:@"再来一单" forState:UIControlStateNormal];
         
        }//交易成功
        else if ([[NSString stringWithFormat:@"%@",self.store.orderStatus] isEqualToString:@"3"]){
            
            [leftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [rightBtn setTitle:@"再来一单" forState:UIControlStateNormal];

        }//已取消
        else if ([[NSString stringWithFormat:@"%@",self.store.orderStatus] isEqualToString:@"-1"]){
            
            leftBtn.hidden = YES;
            [rightBtn setTitle:@"删除订单" forState:UIControlStateNormal];

        }

        [cell addSubview:rightBtn];
    }
    else
    {
        label1.frame = CGRectMake(30 * myDelegate.autoSizeScaleX, 0, [CommonMethod getLabelLengthWithString:@"支付方式" WithFont:16 * myDelegate.autoSizeScaleX ], 40 * myDelegate.autoSizeScaleY);
        label1.font = [UIFont systemFontOfSize:16 * myDelegate.autoSizeScaleX];
        label2.frame = CGRectMake(294 * myDelegate.autoSizeScaleX, 0, ScreenWidth - 294 * myDelegate.autoSizeScaleX, 40 * myDelegate.autoSizeScaleY);
        label2.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
        
        if (indexPath.row == 4)
        {
            label1.text = @"支付方式";
            label2.text = @"在线支付";
        }
        else if (indexPath.row == 5)
        {
            label1.text = @"商品金额";
            label2.text = @"¥1200.0";
        }
        else
        {
            label1.text = @"运费";
            label2.text = @"包邮";
        }
    }
    return cell;
}

- (void)leftBtnclick:(UIButton *)leftBtn{
    
    
    //交易成功
    if ([[NSString stringWithFormat:@"%@",self.store.orderStatus] isEqualToString:@"0"]){
        
        //删除订单
        [self delaeteOrderWithOrderId:self.store.orderId];
        
    }//待付款
    else if ([[NSString stringWithFormat:@"%@",self.store.orderStatus] isEqualToString:@"11"]){
        
         [self cancelOrderWithOrderId:self.store.orderId];
        
    }//卖家已发货
    else if ([[NSString stringWithFormat:@"%@",self.store.orderStatus] isEqualToString:@"2"]){
        
        //确认收货
        [self confirmTakeGoodsWithOrderId:self.store.orderId];
        
    }//交易成功
    else if ([[NSString stringWithFormat:@"%@",self.store.orderStatus] isEqualToString:@"3"]){
        
        //删除订单
        [self delaeteOrderWithOrderId:self.store.orderId];
        
    }//已取消
    else if ([[NSString stringWithFormat:@"%@",self.store.orderStatus] isEqualToString:@"-1"]){
        
        
        
    }

    
}

- (void)rightBtnclick:(UIButton *)rightBtn{
    
    //交易成功
    if ([[NSString stringWithFormat:@"%@",self.store.orderStatus] isEqualToString:@"0"]){
        
        //再来一单
        
    }//待付款
    else if ([[NSString stringWithFormat:@"%@",self.store.orderStatus] isEqualToString:@"11"]){
        
        //支付
        HKXMinePayViewController * pay = [[HKXMinePayViewController alloc] init];
        pay.ruoId = self.store.orderId;
        pay.payCount =[NSString stringWithFormat:@"%@",self.store.cost];
        [self.navigationController pushViewController:pay animated:YES];
        
    }//卖家已发货
    else if ([[NSString stringWithFormat:@"%@",self.store.orderStatus] isEqualToString:@"2"]){
        
        //再来一单
        
    }//交易成功
    else if ([[NSString stringWithFormat:@"%@",self.store.orderStatus] isEqualToString:@"3"]){
        
        //再来一单
        
    }//已取消
    else if ([[NSString stringWithFormat:@"%@",self.store.orderStatus] isEqualToString:@"-1"]){
        
        //删除订单
        [self delaeteOrderWithOrderId:self.store.orderId];
        
    }

    
    
}


- (void)cancelOrderWithOrderId:(NSString *)orderId{
    
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:[self.store.orderId doubleValue]],@"orderId",
                           nil];
    [self.view showActivity];
    [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/buycallOrder.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue] == YES) {
            
            [self showHint:dicts[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [self showHint:dicts[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        
    }];
    
}



- (void)confirmTakeGoodsWithOrderId:(NSString *)orderId{
    
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:[self.store.orderId doubleValue]],@"orderId",
                           nil];
    [self.view showActivity];
    [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/updateTakeGood.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue] == YES) {
            
            [self showHint:dicts[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [self showHint:dicts[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        
    }];
    
}


- (void)delaeteOrderWithOrderId:(NSString *)orderId{
    
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:[self.store.orderId doubleValue]],@"orderId",
                           nil];
    [self.view showActivity];
    [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/deleteOrder.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue] == YES) {
            
            [self showHint:dicts[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            
            [self showHint:dicts[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        
    }];
    
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
