//
//  HKXLeaseViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/29.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "SupplierMyByLeaseViewController.h"
#import "CommonMethod.h"
#import "leaseTableViewCell.h"
#import "JGDownListMenu.h"
#import "issueLeaseViewController.h"
#import "requireLeaseViewController.h"
#import "IWHttpTool.h"
#import "equipmentDetailViewController.h"
#import "requireLeaseDetailViewController.h"
#import "requireRentTableViewCell.h"

#import "UIImageView+WebCache.h"

/**
 *  主屏的宽
 */
#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

/**
 *  主屏的高
 */
#define DEF_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
@interface SupplierMyByLeaseViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{
    UIButton *LButton  ;//导航栏左按钮
    UILabel * lb;//标题视图
    
    int page;//上拉加载更多数据
    BOOL loadMore;
    
}
@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation SupplierMyByLeaseViewController{
    
    UITableView * leAndRetableView;
}

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    NSInteger roleId = [[NSUserDefaults standardUserDefaults]integerForKey:@"userDataRole"];
    NSInteger _roleID = roleId;
    
    //下拉刷新
    leAndRetableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
    
    leAndRetableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [leAndRetableView.mj_header beginRefreshing];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.titleView = lb;
    page = 2;
}
#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 5)];
    view.backgroundColor = [CommonMethod getUsualColorWithString:@"#f6f6f6"];
    [self.view addSubview:view];
    
    
    leAndRetableView = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(view.frame) + 10 * myDelegate.autoSizeScaleY, ScreenWidth, ScreenHeight - view.frame.origin.y - view.frame.size.height - 44) style:UITableViewStylePlain];
    leAndRetableView.delegate = self;
    leAndRetableView.dataSource = self;
    leAndRetableView.backgroundColor = [UIColor whiteColor];
    leAndRetableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    leAndRetableView.showsVerticalScrollIndicator = NO;
    [leAndRetableView registerNib:[UINib nibWithNibName:@"leaseTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    [leAndRetableView registerNib:[UINib nibWithNibName:@"requireRentTableViewCell" bundle:nil] forCellReuseIdentifier:@"requireCell"];
    [self.view addSubview:leAndRetableView];
    
    lb = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    lb.textColor = [UIColor whiteColor];
    lb.text = @"我的求租";
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = lb;
    
}
-(void)refresh{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    if (_dataArr.count != 0) {
        
        [_dataArr removeAllObjects];
    }
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:uId],@"uId",
                           @"1",@"pageNo",
                           @"8",@"pageSize",
                           nil];
    [self.view showActivity];
    [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"bylease/selectByuId.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        [leAndRetableView.mj_header endRefreshing];
        if ([dicts[@"success"] boolValue] == YES) {
            
            _dataArr = dicts[@"data"];  
            [leAndRetableView reloadData];
            
            
        }else{
            
            [self showHint:dicts[@"message"]];
            [leAndRetableView reloadData];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        
        [self.view hideActivity];
        [leAndRetableView.mj_header endRefreshing];
    }];
    
    
    
}

- (void)loadData{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    if (_dataArr.count != 0) {
        
        [_dataArr removeAllObjects];
    }
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:uId],@"uId"
                           ,[NSString stringWithFormat:@"%d",page],@"pageNo",
                           @"8",@"pageSize",
                           nil];
    [self.view showActivity];
    [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"leasemachine/queryAll.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        [leAndRetableView.mj_header endRefreshing];
        NSMutableArray * tempArr = [[NSMutableArray alloc] init];
        if ([dicts[@"success"] boolValue] == YES) {
            
            tempArr = dicts[@"data"];
            for (int i = 0; i < tempArr.count; i ++) {
                
                [_dataArr addObject:tempArr[i]];
            }
            [leAndRetableView reloadData];
            [leAndRetableView.mj_footer endRefreshing];
            page++;
            
        }else{
            
            [leAndRetableView.mj_footer endRefreshing];
            [self showHint:dicts[@"message"]];
            
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [leAndRetableView.mj_footer endRefreshing];
        [self.view hideActivity];
    }];
    
}

#pragma mark 获取数据

- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    requireRentTableViewCell * cell = [leAndRetableView dequeueReusableCellWithIdentifier:@"requireCell" forIndexPath:indexPath ];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    if ([_dataArr[indexPath.row][@"type"] isKindOfClass:[NSNull class]]) {
        
        cell.brandName.text = @"";
        
    }else{
        
        cell.brandName.text = _dataArr[indexPath.row][@"type"];
    }
    if ([_dataArr[indexPath.row][@"brand"] isKindOfClass:[NSNull class]]) {
        
        cell.brand2Name.text = @"";
        
    }else{
        
        cell.brand2Name.text = _dataArr[indexPath.row][@"brand"];
    }
    if ([_dataArr[indexPath.row][@"model"] isKindOfClass:[NSNull class]]) {
        
        cell.modelName.text = @"";
        
    }else{
        
        cell.modelName.text = _dataArr[indexPath.row][@"model"];
    }
    return cell;
    
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除本条记录?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
            
            
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            //删除数据
            NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_dataArr[indexPath.row][@"byleaseid"],@"byleaseid",nil];
            [self.view showActivity];
            [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"bylease/dellease.do"] params:dict success:^(id responseObject) {
                
                NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"请求成功%@",dicts);
                [self.view hideActivity];
                if ([dicts[@"success"] boolValue] == YES) {
                    
                    [self showHint:dicts[@"message"]];
                    [leAndRetableView.mj_header beginRefreshing];
                }else{
                    
                    [self showHint:dicts[@"message"]];
                }
                
            } failure:^(NSError *error) {
                
                NSLog(@"请求失败%@",error);
                [self.view hideActivity];
            }];
            
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }];
    return @[deleteAction];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    requireLeaseDetailViewController * eq = [[requireLeaseDetailViewController alloc] init];
    eq.hidesBottomBarWhenPushed = YES;
    eq.type = _dataArr[indexPath.row][@"type"];
    eq.address = _dataArr[indexPath.row][@"address"];
    eq.brand = _dataArr[indexPath.row][@"brand"];
    eq.model = _dataArr[indexPath.row][@"model"];
    eq.size = _dataArr[indexPath.row][@"size"];
    eq.workcontext = _dataArr[indexPath.row][@"workcontext"];
    eq.contact = _dataArr[indexPath.row][@"contact"];
    eq.phone = _dataArr[indexPath.row][@"phone"];
    eq.mid = _dataArr[indexPath.row][@"mid"];
    [self.navigationController pushViewController:eq animated:YES];
    
}


#pragma mark - ConfigData
#pragma mark - Action
#pragma mark - Private Method


#pragma mark - Delegate & Data Source
#pragma mark - Setters & Getters
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
