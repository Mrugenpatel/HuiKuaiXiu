//
//  HKXLeaseViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/29.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "OwerMyleaseViewController.h"
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
@interface OwerMyleaseViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>{

    UIButton *leButton ; //出租按钮
    UIButton *reButton ; //求组按钮
    UILabel * lb;//标题视图
    
    int page;//上拉加载更多数据
    BOOL loadMore;
    
}

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation OwerMyleaseViewController{
    
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
    
    self.navigationController.navigationBarHidden = NO;
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
    //出租/求租按钮
    leButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leButton.frame = CGRectMake(ScreenWidth / 2 - ScreenWidth / 4, view.frame.origin.y + view.frame.size.height + 10 * myDelegate.autoSizeScaleY, ScreenWidth / 4, 40 * myDelegate.autoSizeScaleY);
    [leButton setBackgroundColor:[CommonMethod getUsualColorWithString:@"#ffa304"]];
    leButton.layer.borderWidth=1;//设置边框的宽度
    leButton.layer.borderColor=[[CommonMethod getUsualColorWithString:@"#ffa304"] CGColor];//设置边框的颜色
    leButton.clipsToBounds=YES;
    leButton.selected = YES;
    [leButton setTitle:@"出租" forState:UIControlStateNormal];
    leButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [leButton setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateNormal];
    [leButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [leButton addTarget:self action:@selector(leBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:leButton];
    
    
    reButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reButton.frame = CGRectMake( ScreenWidth / 2, leButton.frame.origin.y, ScreenWidth / 4, leButton.frame.size.height);
    reButton.layer.borderWidth=1;//设置边框的宽度
    reButton.layer.borderColor=[[CommonMethod getUsualColorWithString:@"#ffa304"] CGColor];//设置边框的颜色
    reButton.clipsToBounds=YES;
    
    [reButton setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateNormal];
    [reButton setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [reButton setTitle:@"求租" forState:UIControlStateNormal];
    reButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [reButton addTarget:self action:@selector(reBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reButton];
    
    leAndRetableView = [[UITableView alloc] initWithFrame:CGRectMake(0, reButton.frame.origin.y + reButton.frame.size.height + 10 * myDelegate.autoSizeScaleY, ScreenWidth, ScreenHeight - reButton.frame.origin.y - reButton.frame.size.height - 54) style:UITableViewStylePlain];
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
    lb.text = @"租赁";
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:17];
    self.navigationItem.titleView = lb;
  
}
-(void)refresh{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    if (leButton.selected) {
        //获取出租列表数据
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:uId],@"uId",@"1",@"pageNo",@"8",@"pageSize",nil];
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"leasemachine/selectByuId.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            [leAndRetableView.mj_header endRefreshing];
            if ([dicts[@"success"] boolValue] == YES) {
                
                _dataArr = dicts[@"data"];
                [leAndRetableView reloadData];
                
            }else{
                
                [self showHint:dicts[@"message"]];
                
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            
            [self.view hideActivity];
            [leAndRetableView.mj_header endRefreshing];
        }];
    }else{
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:uId],@"uId",@"1",@"pageNo",@"8",@"pageSize",nil];
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
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            
            [leAndRetableView.mj_header endRefreshing];
            [self.view hideActivity];
            [self showHint:@"请求失败"];
            
        }];
        
        
    }
    
}

- (void)loadData{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    if (leButton.selected) {
        //获取出租列表数据
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:uId],@"uId",
                               [NSString stringWithFormat:@"%d",page],@"pageNo",
                               @"8",@"pageSize",
                               nil];
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"bylease/selectByuId.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            [leAndRetableView.mj_footer endRefreshing];
            NSMutableArray * tempArr = [[NSMutableArray alloc] init];
            if ([dicts[@"success"] boolValue] == YES) {
                
                tempArr = dicts[@"data"];
                if (tempArr.count != 0) {
                    
                    for (int i = 0; i < tempArr.count; i ++) {
                        
                        [_dataArr addObject:tempArr[i]];
                    }
                    [leAndRetableView reloadData];
                    page++;
                }else{
                    
                    [self showHint:dicts[@"message"]];
                }
                
                
            }else{
                
                [self showHint:dicts[@"message"]];
                
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [leAndRetableView.mj_footer endRefreshing];
            [self.view hideActivity];
        }];
    }else{
        
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:uId],@"uId",
                               [NSString stringWithFormat:@"%d",page],@"pageNo",
                               @"8",@"pageSize",
                               nil];
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"bylease/queryAll.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            [leAndRetableView.mj_footer endRefreshing];
            NSMutableArray * tempArr = [[NSMutableArray alloc] init];
            if ([dicts[@"success"] boolValue] == YES) {
                
                tempArr = dicts[@"data"];
                if (tempArr.count != 0) {
                    
                    for (int i = 0; i < tempArr.count; i ++) {
                        
                        [_dataArr addObject:tempArr[i]];
                    }
                    [leAndRetableView reloadData];
                    page++;
                    
                }else{
                    
                    [self showHint:dicts[@"message"]];
                }
                
            }else{
                
                
                [self showHint:dicts[@"message"]];
                
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [leAndRetableView.mj_footer endRefreshing];
            [self.view hideActivity];
        }];
        
    }

}

#pragma mark 获取数据

- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

#pragma mark 点击出租按钮
- (void)leBtnClick:(UIButton *)btn{
    
    
    if (leButton.selected){
        
        NSLog(@"出租选中状态");
        [leAndRetableView.mj_header beginRefreshing];
    }else{
        
        reButton.selected = NO;
        leButton.selected = YES;
        [leButton setBackgroundColor:[CommonMethod getUsualColorWithString:@"#ffa304"]];
        [reButton setBackgroundColor:[UIColor whiteColor]];
        [leAndRetableView.mj_header beginRefreshing];
    }
    
    
    
}
#pragma mark 点击求租按钮
- (void)reBtnClick:(UIButton *)btn{
    
    if (reButton.selected){
        
        NSLog(@"求租选中状态");
        [leAndRetableView.mj_header beginRefreshing];
    }else{
        
        reButton.selected = YES;
        leButton.selected = NO;
        [reButton setBackgroundColor:[CommonMethod getUsualColorWithString:@"#ffa304"]];
        [leButton setBackgroundColor:[UIColor whiteColor]];
        [leAndRetableView.mj_header beginRefreshing];
    }
    
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
    
    if (leButton.selected) {
        
        leaseTableViewCell * cell = [leAndRetableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath ];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        if ([_dataArr[indexPath.row][@"machinetype"] isKindOfClass:[NSNull class]]) {
            
            cell.brandName.text = @"";
        }else{
            
            cell.brandName.text = _dataArr[indexPath.row][@"machinetype"];
        }
        if ([_dataArr[indexPath.row][@"brand"] isKindOfClass:[NSNull class]]) {
            
            cell.brand2Name.text = @"";
        }else{
            
            cell.brand2Name.text = _dataArr[indexPath.row][@"brand"];
        }
        
        if ([_dataArr[indexPath.row][@"modeltype"] isKindOfClass:[NSNull class]]) {
            
            cell.modelName.text = @"";
        }else{
            
            cell.modelName.text = _dataArr[indexPath.row][@"modeltype"];
        }
        // NSLog(@"%@",[NSString   stringWithFormat:@"%@%@",kPictureUrl,_dataArr[indexPath.row][@"picture"]]);
        if ([[NSString stringWithFormat:@"%@%@",kIMAGEURL,_dataArr[indexPath.row][@"picture"]] isKindOfClass:[NSNull class]]) {
            
            
            
        }else{
            
            [cell.equipmentImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,_dataArr[indexPath.row][@"picture"]]] placeholderImage:[UIImage imageNamed:@"滑动视图示例"]];
        }
        
        return cell;
        
    }else{
        
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
    
}

- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewRowAction *deleteAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除本条记录?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            
            //删除数据
            NSLog(@"删除");
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            double uId = [defaults doubleForKey:@"userDataId"];
            if (leButton.selected) {
                NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:_dataArr[indexPath.row][@"machineleaseid"],@"machineleaseid",nil];
                [self.view showActivity];
                [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"leasemachine/dellease.do"] params:dict success:^(id responseObject) {
                    
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
                
            }else{
                
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
            }
 
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }];
    return @[deleteAction];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //leaseTableViewCell * cell = [leAndRetableView cellForRowAtIndexPath:indexPath];
    
    if (leButton.selected) {
        
        equipmentDetailViewController * eq = [[equipmentDetailViewController alloc] init];
        eq.hidesBottomBarWhenPushed = YES;
        eq.brandmodel = _dataArr[indexPath.row][@"modeltype"];
        eq.address = _dataArr[indexPath.row][@"address"];
        eq.picture = _dataArr[indexPath.row][@"picture"];
        eq.cost =_dataArr[indexPath.row][@"cost"];
        eq.oil = _dataArr[indexPath.row][@"oil"];
        eq.driver = _dataArr[indexPath.row][@"driver"];
        eq.machinephone = _dataArr[indexPath.row][@"machinephone"];
        eq.mark = @"我的出租";
        [self.navigationController pushViewController:eq animated:YES];
        
    }else{
        
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
        eq.mark = @"我的求租";
        [self.navigationController pushViewController:eq animated:YES];
    }
    
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
