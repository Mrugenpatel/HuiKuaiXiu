//
//  HKXMinePayViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/11.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMinePayViewController.h"
#import "CommonMethod.h"
#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>
#import "HKXMineOwnerRepairListViewController.h"
#import "HKXShoppingMallViewController.h"
@interface HKXMinePayViewController ()<UITableViewDelegate , UITableViewDataSource>
{
    UITableView * _payTableView;

}

@property(nonatomic ,strong)UIButton * WechatBtn;
@property(nonatomic ,strong)UIButton * AlipayBtn;
@end



@implementation HKXMinePayViewController

#pragma mark - LifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoNotificationPaySuccess:) name:@"paySuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoNotificationPayFailed:) name:@"payFailed" object:nil];
}

-(void)userInfoNotificationPaySuccess:(NSNotification*)notification{
    
    [self showHint:@"支付成功"];
    [self performSelector:@selector(popViewcontroller) withObject:nil afterDelay:1.f];
    
    
}
-(void)userInfoNotificationPayFailed:(NSNotification*)notification{
    
    [self showHint:@"支付失败"];
    
}

- (void)popViewcontroller{
    
    if (self.come == 0) {
        
        HKXShoppingMallViewController * shoppingMall = [[HKXShoppingMallViewController alloc] init];
        [self.navigationController popToViewController:shoppingMall animated:YES];
        
    }else{
    
       HKXMineOwnerRepairListViewController * list = [[HKXMineOwnerRepairListViewController alloc] init];
       [self.navigationController popToViewController:list animated:YES];
    }
}

#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    
    _payTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 60, ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60) style:UITableViewStylePlain];
    _payTableView.backgroundColor = [UIColor whiteColor];
    _payTableView.dataSource = self;
    _payTableView.delegate = self;
    _payTableView.scrollEnabled = NO;
    [self.view addSubview:_payTableView];
    
    [_payTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - ConfigData
#pragma mark - Action
- (void)selectPayTypeToPayBtnClick:(UIButton *)btn
{
    //TODO:选择支付方式
    btn.selected = !btn.selected;
    
    if(btn.tag == _WechatBtn.tag && btn.selected){
        
        _AlipayBtn.selected = NO;
    }
    if(btn.tag == _AlipayBtn.tag && btn.selected){
        
        _WechatBtn.selected = NO;
    }
    
}
- (void)payCOSTBtnClick:(UIButton *)btn
{
    
    if (!_WechatBtn.selected && !_AlipayBtn.selected) {
        
        [self showHint:@"请选择支付方式"];
        return;
    }if (_WechatBtn.selected) {
        
        if (self.come == 0 || self.come == 1) {
            
        [self GoodsWechatPay];
        }else{
            
        [self WechatPay];
            
        }
        
    }else if (_AlipayBtn.selected){
        
        if (self.come == 0 || self.come == 1)
        {
            
            [self GoodsAlipay];
        }else{
            
            [self Alipay];
            
        }
    }
    
    

}
//微信
- (void)WechatPay{
    
    
    if (![WXApi isWXAppInstalled]) {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"点击确定安装微信" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            NSString  *str = [NSString stringWithFormat:@"%@",[WXApi getWXAppInstallUrl]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:[_ruoId doubleValue]],@"ruoId",nil];
    NSLog(@"%@",dict);
    
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"app/pay/repairwxpay.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",responseObject);
        
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue] == YES) {
            
            // NOTE: 调用支付结果开始支付
            NSDictionary * json = [dicts objectForKey:@"data"];
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = [json objectForKey:@"partnerid"];
            request.prepayId= [json objectForKey:@"prepayid"];
            request.package = [json objectForKey:@"package"];
            request.nonceStr= [json objectForKey:@"noncestr"];
            request.timeStamp= [[json objectForKey:@"timestamp"] intValue];
            request.sign= [json objectForKey:@"sign"];
            
            [WXApi sendReq:request];
            
        }else if ([dicts[@"success"] boolValue] == NO) {
            
            [self showHint:dicts[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        [self showHint:@"请求失败"];
    }];
    

}
//微信
- (void)GoodsWechatPay{
    
    if (![WXApi isWXAppInstalled]) {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"点击确定安装微信" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            NSString  *str = [NSString stringWithFormat:@"%@",[WXApi getWXAppInstallUrl]];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    

    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:[_ruoId doubleValue]],@"orderId",[NSNumber numberWithInteger:self.come],@"come",nil];
    NSLog(@"%@",dict);
    
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"pay/shopOrderWXpay.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",responseObject);
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue] == YES) {
            
            // NOTE: 调用支付结果开始支付
            NSDictionary * json = [dicts objectForKey:@"data"];
            PayReq *request = [[PayReq alloc] init];
            request.partnerId = [json objectForKey:@"partnerid"];
            request.prepayId= [json objectForKey:@"prepayid"];
            request.package = [json objectForKey:@"package"];
            request.nonceStr= [json objectForKey:@"noncestr"];
            request.timeStamp= [[json objectForKey:@"timestamp"] intValue];
            request.sign= [json objectForKey:@"sign"];
            
            [WXApi sendReq:request];
            
        }else if ([dicts[@"success"] boolValue] == NO) {
            
            [self showHint:dicts[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        [self showHint:@"请求失败"];
    }];
    

}

//支付宝
- (void)Alipay{
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:[_ruoId doubleValue]],@"ruoId",nil];
    NSLog(@"%@",dict);
    
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"app/pay/repairAlipay.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",responseObject);
        
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue] == YES) {
            
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:dicts[@"data"] fromScheme:@"Lee.HKXPro" callback:^(NSDictionary *resultDic) {
                
                NSLog(@"reslut = %@",resultDic);
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                    
                    [self showHint:@"支付成功"];
                    HKXMineOwnerRepairListViewController * list = [[HKXMineOwnerRepairListViewController alloc] init];
                    [self.navigationController popToViewController:list animated:YES];
                }else{
                    
                    [self showHint:@"支付失败"];
                }
                
                
            }];
            
        }else if ([dicts[@"success"] boolValue] == NO) {
            
            [self showHint:dicts[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        [self showHint:@"请求失败"];
    }];

}
- (void)GoodsAlipay{
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:[_ruoId doubleValue]],@"orderId",[NSNumber numberWithInteger:self.come],@"come",nil];
    NSLog(@"%@",dict);
    
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"app/pay/repairAlipay.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",responseObject);
        
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue] == YES) {
            
            // NOTE: 调用支付结果开始支付
            [[AlipaySDK defaultService] payOrder:dicts[@"data"] fromScheme:@"Lee.HKXPro" callback:^(NSDictionary *resultDic) {
                
                NSLog(@"reslut = %@",resultDic);
                if ([resultDic[@"resultStatus"] isEqualToString:@"9000"]) {
                    
                    [self showHint:@"支付成功"];
                    HKXMineOwnerRepairListViewController * list = [[HKXMineOwnerRepairListViewController alloc] init];
                    [self.navigationController popToViewController:list animated:YES];
                }else{
                    
                    [self showHint:@"支付失败"];
                }
                
                
            }];
            
        }else if ([dicts[@"success"] boolValue] == NO) {
            
            [self showHint:dicts[@"message"]];
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        [self showHint:@"请求失败"];
    }];
    
}


#pragma mark - Private Method
#pragma mark - Delegate & Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (indexPath.row == 0)
    {
        return 71 * myDelegate.autoSizeScaleY;
    }
    else if (indexPath.row == 3)
    {
        return (_payTableView.frame.size.height - (71 + 80) * myDelegate.autoSizeScaleY);
    }
    else
    {
        return 44 * myDelegate.autoSizeScaleY;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    static NSString * cellIdentifier = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    
    UILabel * reMoneyLabel = [cell viewWithTag:6000];
    [reMoneyLabel removeFromSuperview];
    UILabel * reTotalMoneyLabel = [cell viewWithTag:6001];
    [reTotalMoneyLabel removeFromSuperview];
    UIImageView * reIcon = [cell viewWithTag:6002];
    [reIcon removeFromSuperview];
    //    UIButton * reSelectedBtn = [cell viewWithTag:6003];
    //    [reSelectedBtn removeFromSuperview];
    UIButton * rePayBtn = [cell viewWithTag:6004];
    [rePayBtn removeFromSuperview];
    UIImageView * reTextImg = [cell viewWithTag:40000];
    [reTextImg removeFromSuperview];
    UIImageView * reTuiJianImg = [cell viewWithTag:40001];
    [reTuiJianImg removeFromSuperview];
    
    if (indexPath.row == 0)
    {
        UILabel * moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, 22 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"支付金额" WithFont:17 * myDelegate.autoSizeScaleX], 17 * myDelegate.autoSizeScaleX)];
        moneyLabel.tag = 6000;
        moneyLabel.text = @"支付金额";
        moneyLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
        [cell addSubview:moneyLabel];
        
        UILabel * totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(191 * myDelegate.autoSizeScaleX + CGRectGetMaxX(moneyLabel.frame) , 22 * myDelegate.autoSizeScaleY, 150 * myDelegate.autoSizeScaleX, 17 * myDelegate.autoSizeScaleX)];
        totalMoneyLabel.tag = 6001;
        totalMoneyLabel.text = [NSString stringWithFormat:@"¥%@",self.payCount];
        totalMoneyLabel.textColor = [CommonMethod getUsualColorWithString:@"#e06e14"];
        totalMoneyLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
        [cell addSubview:totalMoneyLabel];
    }
    if (indexPath.row == 1 || indexPath.row == 2)
    {
        float xPosition = 16 * myDelegate.autoSizeScaleX;
        float yPosition = (indexPath.row == 1) ? 9 * myDelegate.autoSizeScaleY : 17 / 2 * myDelegate.autoSizeScaleY;
        float width = (indexPath.row == 1) ? (51 / 2 * myDelegate.autoSizeScaleX) : 23 * myDelegate.autoSizeScaleX;
        float height = (indexPath.row == 1) ? 22 * myDelegate.autoSizeScaleY : 23 * myDelegate.autoSizeScaleY;
        UIImageView * payIconImage = [[UIImageView alloc] initWithFrame:CGRectMake(xPosition, yPosition, width, height)];
        payIconImage.tag = 6002;
        [cell addSubview:payIconImage];
        
        float textXPosition = 6 * myDelegate.autoSizeScaleX;
        float textYPosition = (indexPath.row == 1) ? 9 * myDelegate.autoSizeScaleY : 17 / 2 * myDelegate.autoSizeScaleY;
        float textWidth = (indexPath.row == 1) ? (95 / 2 * myDelegate.autoSizeScaleX) : 36 * myDelegate.autoSizeScaleX;
        float textHeight = (indexPath.row == 1) ? 11 * myDelegate.autoSizeScaleY : 9 * myDelegate.autoSizeScaleY;
        UIImageView * textImg = [[UIImageView alloc] initWithFrame:CGRectMake(textXPosition + CGRectGetMaxX(payIconImage.frame), textYPosition, textWidth, textHeight)];
        textImg.tag = 40000;
        [cell addSubview:textImg];
        
        float tuiJianXPosition = 4 * myDelegate.autoSizeScaleX;
        float tuiJianYPosition = (indexPath.row == 1) ? 9 * myDelegate.autoSizeScaleY : 17 / 2 * myDelegate.autoSizeScaleY;
        float tuiJianWidth = (indexPath.row == 1) ? (49 / 2 * myDelegate.autoSizeScaleX) : (41 / 2) * myDelegate.autoSizeScaleX;
        float tuiJianHeight = (indexPath.row == 1) ? 11 * myDelegate.autoSizeScaleY : 9 * myDelegate.autoSizeScaleY;
        UIImageView * tuiJianImage = [[UIImageView alloc] initWithFrame:CGRectMake(tuiJianXPosition + CGRectGetMaxX(textImg.frame), tuiJianYPosition, tuiJianWidth, tuiJianHeight)];
        tuiJianImage.tag = 40001;
        [cell addSubview:tuiJianImage];
        
        UILabel * totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(6 * myDelegate.autoSizeScaleX + CGRectGetMaxX(payIconImage.frame) , 4 * myDelegate.autoSizeScaleY + CGRectGetMaxY(textImg.frame), [CommonMethod getLabelLengthWithString:@"亿万用户的选择，更快更安全" WithFont:9 * myDelegate.autoSizeScaleX ], 9 * myDelegate.autoSizeScaleX)];
        totalMoneyLabel.textColor = [CommonMethod getUsualColorWithString:@"#666666"];
        totalMoneyLabel.tag = 6001;
        totalMoneyLabel.font = [UIFont systemFontOfSize:9 * myDelegate.autoSizeScaleX];
        [cell addSubview:totalMoneyLabel];
        

        if (indexPath.row == 1)
        {
            
             _WechatBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalMoneyLabel.frame) + 174 * myDelegate.autoSizeScaleX, 14 * myDelegate.autoSizeScaleY, 16 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleX)];
            _WechatBtn.tag = 6003 + indexPath.row;
            [_WechatBtn setImage:[UIImage imageNamed:@"选择1"] forState:UIControlStateNormal];
            [_WechatBtn setImage:[UIImage imageNamed:@"选择2"] forState:UIControlStateSelected];
            _WechatBtn.selected = YES;
            [_WechatBtn addTarget:self action:@selector(selectPayTypeToPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:_WechatBtn];
            
            payIconImage.image = [UIImage imageNamed:@"微信logo"];
            textImg.image = [UIImage imageNamed:@"微信支付"];
            totalMoneyLabel.text = @"亿万用户的选择，更快更安全";
            tuiJianImage.image = [UIImage imageNamed:@"微信推荐"];
        }
        else
        {
            
            _AlipayBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(totalMoneyLabel.frame) + 174 * myDelegate.autoSizeScaleX, 14 * myDelegate.autoSizeScaleY, 16 * myDelegate.autoSizeScaleX, 16 * myDelegate.autoSizeScaleX)];
            _AlipayBtn.tag = 6003 + indexPath.row;
            [_AlipayBtn setImage:[UIImage imageNamed:@"选择1"] forState:UIControlStateNormal];
            [_AlipayBtn setImage:[UIImage imageNamed:@"选择2"] forState:UIControlStateSelected];
            _AlipayBtn.selected = NO;
            [_AlipayBtn addTarget:self action:@selector(selectPayTypeToPayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell addSubview:_AlipayBtn];
            
            payIconImage.image = [UIImage imageNamed:@"支付宝logo"];
            textImg.image = [UIImage imageNamed:@"支付宝文字"];
            totalMoneyLabel.text = @"数亿用户都在用，安全可托付";
            tuiJianImage.image = [UIImage imageNamed:@"支付宝推荐"];
        }
    }
    if (indexPath.row == 3)
    {
        UIButton * payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        payBtn.tag = 6004;
        
        payBtn.frame = CGRectMake((ScreenWidth - 277 * myDelegate.autoSizeScaleX) / 2, 228 * myDelegate.autoSizeScaleY, 277 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
        payBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
        payBtn.layer.cornerRadius = 2;
        payBtn.clipsToBounds = YES;
        [payBtn setTitle:@"支 付" forState:UIControlStateNormal];
        [payBtn addTarget:self action:@selector(payCOSTBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:payBtn];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
