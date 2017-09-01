//
//  HKXRepairMaintainerListViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/7/18.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXRepairMaintainerListViewController.h"
#import "CommonMethod.h"

#import "HKXReqairMaintainerDetailViewController.h"
#import "repairListModel.h"

@interface HKXRepairMaintainerListViewController ()<UITableViewDelegate , UITableViewDataSource ,UITextViewDelegate>

{
    UITableView * _bottomTableView;
    UITextView * cancleReasonTF;
}



@end

@implementation HKXRepairMaintainerListViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configDta];
    [self createUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userInfoNotification:) name:@"userInfoNotification" object:nil];
}
-(void)userInfoNotification:(NSNotification*)notification{
    
    NSDictionary *dict = [notification userInfo];
    NSString *type=[dict valueForKey:@"machine"];
    if ([type isEqualToString:@"101"]) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:[self.ruoId longLongValue]],@"ruoId",nil];
        NSLog(@"%@",dict);
        
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"repair/selectRepairInfo.do"] params:dict success:^(id responseObject) {
            
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            NSLog(@"%@",dicts[@"message"]);
            [self.view hideActivity];
            _maintainerListArray = [[NSMutableArray alloc] init];
            if ([dicts[@"success"] boolValue] == YES) {
                  
                _maintainerListArray = dicts[@"data"];
                
                [_bottomTableView reloadData];
                
            }else if ([dicts[@"success"] boolValue] == NO){
                
                
                [self showHint:dicts[@"message"]];
                
            }
            
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            [self showHint:@"请求失败"];
        }];
        
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)configDta{
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:[self.ruoId longLongValue]],@"ruoId",nil];
    NSLog(@"%@",dict);
    
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"repair/selectRepairInfo.do"] params:dict success:^(id responseObject) {
        
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        NSLog(@"%@",dicts[@"message"]);
        [self.view hideActivity];
        _maintainerListArray = [[NSMutableArray alloc] init];
        if ([dicts[@"success"] boolValue] == YES) {
            
            _maintainerListArray = dicts[@"data"];
            
            [_bottomTableView reloadData];
            
        }else if ([dicts[@"success"] boolValue] == NO){
            
            
            [self showHint:dicts[@"message"]];
            
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        [self showHint:@"请求失败"];
    }];
    
    

}
#pragma mark - CreateUI
- (void)createUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1];
    self.navigationItem.title = @"订单列表";
    
    _bottomTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10 * myDelegate.autoSizeScaleY + 60, ScreenWidth, ScreenHeight - 30 * myDelegate.autoSizeScaleY - 60 - 49.5) style:UITableViewStylePlain];
    _bottomTableView.dataSource = self;
    _bottomTableView.delegate = self;
    _bottomTableView.showsVerticalScrollIndicator = NO;
    _bottomTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomTableView];
    [_bottomTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

#pragma mark - Action
- (void)actionBtnClick:(UIButton *)btn
{
    if (btn.tag - 20002 == 0)
    {
        NSLog(@"取消订单");
        [self showCancleAlertView];
    }
    else
    {
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:[self.ruoId longLongValue]],@"ruoId",nil];
        NSLog(@"%@",dict);
        
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"repair/callback.do"] params:dict success:^(id responseObject) {
            
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            if ([dicts[@"success"] boolValue] == YES) {
                
                [self showHint:dicts[@"message"]];
                [self.navigationController popViewControllerAnimated:YES];
                
            }else if ([dicts[@"success"] boolValue] == NO){
                

                [self showHint:dicts[@"message"]];
                
            }
            
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            [self showHint:@"请求失败"];
        }];
        
       
    }
}
- (void)tapGestureClick
{
    for (UIView * view in self.view.subviews)
    {
        if (view.tag == 500 || view.tag == 501 )
        {
            [view removeFromSuperview];
        }
    }
}
- (void)submitCanccleReasonBtnClick:(UIButton *)btn
{
    for (UIView * view in self.view.subviews)
    {
        if (view.tag == 500 || view.tag == 501 )
        {
            [view removeFromSuperview];
        }
    }
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithLong:[self.ruoId longLongValue]],@"ruoId",cancleReasonTF.text,@"remarks",nil];
    NSLog(@"%@",dict);
    
    [self.view showActivity];
    [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"repair/removeOrder.do"] params:dict success:^(id responseObject) {
        
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        
        if ([dicts[@"success"] boolValue] == YES) {
            
            [self.view hideActivity];
            [self showHint:dicts[@"message"]];
            [self.navigationController popToRootViewControllerAnimated:YES];
            
            
        }else if ([dicts[@"success"] boolValue] == NO){
            
            
            [self.view hideActivity];
            [self showHint:dicts[@"message"]];
            
        }
        
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        [self showHint:@"请求失败"];
    }];
    
    
    
}
#pragma mark - Private Method
- (void)showCancleAlertView
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView * backGroudView = [[UIView alloc] initWithFrame:self.view.bounds];
    backGroudView.backgroundColor = [UIColor darkGrayColor];
    backGroudView.tag = 500;
    backGroudView.alpha = 0.3;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureClick)];
    [backGroudView addGestureRecognizer:tap];
    [self.view addSubview:backGroudView];
    
    UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(58 * myDelegate.autoSizeScaleX, 176 * myDelegate.autoSizeScaleY, 260 * myDelegate.autoSizeScaleX, 180 * myDelegate.autoSizeScaleY)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 2;
    backView.clipsToBounds = YES;
    backView.tag = 501;
    [self.view addSubview:backView];
    
    cancleReasonTF = [[UITextView alloc] initWithFrame:CGRectMake(18 * myDelegate.autoSizeScaleX, 25 * myDelegate.autoSizeScaleY, 221 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY)];
    cancleReasonTF.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleY];
    cancleReasonTF.text = @"取消理由";
    cancleReasonTF.textColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1];
    cancleReasonTF.delegate = self;
    cancleReasonTF.layer.borderColor = [UIColor darkGrayColor].CGColor;
    cancleReasonTF.layer.borderWidth = 1.f;
    [backView addSubview:cancleReasonTF];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake((backView.frame.size.width - 120 * myDelegate.autoSizeScaleX ) / 2, CGRectGetMaxY(cancleReasonTF.frame) + 36 * myDelegate.autoSizeScaleY, 120 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
    submitBtn.layer.cornerRadius = 2;
    submitBtn.clipsToBounds = YES;
    submitBtn.tag = 502;
    submitBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    [submitBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitCanccleReasonBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:submitBtn];
    
}
#pragma mark - Delegate & Data Source
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
}
- (void)textViewDidChange:(UITextView *)textView
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //计算文本的高度
    CGSize constraintSize;
    constraintSize.width = textView.frame.size.width - 16;
    constraintSize.height = MAXFLOAT;
    
    CGRect sizeFrame = [textView.text boundingRectWithSize:CGSizeMake(constraintSize.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17]} context:nil];
    
    //重新调整textView的高度
    textView.frame =CGRectMake(textView.frame.origin.x,textView.frame.origin.y,textView.frame.size.width,sizeFrame.size.height+ 5);
    UIView * backView = [self.view viewWithTag:501];
    backView.frame = CGRectMake(58 * myDelegate.autoSizeScaleX, 176 * myDelegate.autoSizeScaleY, 260 * myDelegate.autoSizeScaleX , 180 * myDelegate.autoSizeScaleY + (sizeFrame.size.height - 44));
    UIButton * submitBtn = [backView viewWithTag:502];
    submitBtn.frame = CGRectMake((backView.frame.size.width - 120 * myDelegate.autoSizeScaleX ) / 2, CGRectGetMaxY(textView.frame) + 36 * myDelegate.autoSizeScaleY, 120 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.maintainerListArray.count + 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (indexPath.row == self.maintainerListArray.count)
    {
        return tableView.frame.size.height - self.maintainerListArray.count * 50 * myDelegate.autoSizeScaleY;
    }
    else
    {
        return 50 * myDelegate.autoSizeScaleY;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell";
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel * reNameLabel = [cell viewWithTag:20000];
    [reNameLabel removeFromSuperview];
    UILabel * rePhoneLabel = [cell viewWithTag:20001];
    [rePhoneLabel removeFromSuperview];
    for (int i = 0; i < 2; i ++)
    {
        UIButton * reActionBtn = [cell viewWithTag:20002 + i];
        [reActionBtn removeFromSuperview];
    }
    
    if (indexPath.row != self.maintainerListArray.count)
    {
        float nameLabelLength;
        if ([self.maintainerListArray[indexPath.row][@"realName"] isKindOfClass:[NSNull class]]) {
            
            
            nameLabelLength = [CommonMethod getLabelLengthWithString:@"" WithFont:17 * myDelegate.autoSizeScaleX];
        }else{
            
            nameLabelLength = [CommonMethod getLabelLengthWithString:self.maintainerListArray[indexPath.row][@"realName"] WithFont:17 * myDelegate.autoSizeScaleX];
        }
       
        UILabel * maintainerNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(22 * myDelegate.autoSizeScaleX, 22.5 * myDelegate.autoSizeScaleY, nameLabelLength, 17 * myDelegate.autoSizeScaleX)];
        maintainerNameLabel.tag = 20000;
        if ([self.maintainerListArray[indexPath.row][@"realName"] isKindOfClass:[NSNull class]]) {
            
            maintainerNameLabel.text = @"";
        }else{
        
        maintainerNameLabel.text = self.maintainerListArray[indexPath.row][@"realName"];
        }
        maintainerNameLabel.font = [UIFont systemFontOfSize:17 * myDelegate.autoSizeScaleX];
        [cell addSubview:maintainerNameLabel];
        
        UILabel * phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(maintainerNameLabel.frame) + 32 * myDelegate.autoSizeScaleX, 22.5 * myDelegate.autoSizeScaleY, 200, 15 * myDelegate.autoSizeScaleX)];
        phoneLabel.tag = 20001;
        if ([self.maintainerListArray[indexPath.row][@"telephone"] isKindOfClass:[NSNull class]]) {
            
            phoneLabel.text = @" ";
        }else{
            
            phoneLabel.text = self.maintainerListArray[indexPath.row][@"telephone"];
        }
        phoneLabel.text = self.maintainerListArray[indexPath.row][@"telephone"];
        phoneLabel.font = [UIFont systemFontOfSize:15 * myDelegate.autoSizeScaleX];
        [cell addSubview:phoneLabel];
    }else
    {
        NSArray * btnTitleArray = @[@"取消订单",@"重新呼叫"];
        NSArray * btnBGColorArray = @[@"#e06e15",@"#ffa304"];
        for (int i = 0; i < 2; i ++)
        {
            UIButton * actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            actionBtn.frame = CGRectMake((22 + (150 + 31) * i) * myDelegate.autoSizeScaleX, 117 * myDelegate.autoSizeScaleY, 150 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
            [actionBtn setTitle:btnTitleArray[i] forState:UIControlStateNormal];
            [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            actionBtn.backgroundColor = [CommonMethod getUsualColorWithString:btnBGColorArray[i]];
            actionBtn.tag = 20002 + i;
            [actionBtn addTarget:self action:@selector(actionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            actionBtn.layer.cornerRadius = 2;
            actionBtn.clipsToBounds = YES;
            [cell addSubview:actionBtn];
        }
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.hidesBottomBarWhenPushed = YES;
    if (indexPath.row != self.maintainerListArray.count)
    {
        HKXReqairMaintainerDetailViewController * detailVC = [[HKXReqairMaintainerDetailViewController alloc] init];
        detailVC.maintainerName = self.maintainerListArray[indexPath.row][@"realName"];
        detailVC.maintainerTele =self.maintainerListArray[indexPath.row][@"telephone"];
        detailVC.maintainerId =self.maintainerListArray[indexPath.row][@"uId"];
        detailVC.ruoId = _ruoId;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark - Setters & Getters
- (NSMutableArray *)maintainerListArray
{
    if (!_maintainerListArray)
    {
        _maintainerListArray = [NSMutableArray array];
    }
    return _maintainerListArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
