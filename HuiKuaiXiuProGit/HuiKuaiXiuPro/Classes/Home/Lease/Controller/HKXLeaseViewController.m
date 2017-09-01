//
//  HKXLeaseViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/29.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXLeaseViewController.h"
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
@interface HKXLeaseViewController ()<UITableViewDataSource,UITableViewDelegate,DownListMenuDelegate,UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate>{
    UIButton *LButton  ;//导航栏左按钮
    UIButton *RButton  ;//导航栏右按钮
    UIButton *leButton ; //出租按钮
    UIButton *reButton ; //求组按钮
    UILabel * lb;//标题视图
    
    int page;//上拉加载更多数据
    BOOL loadMore;
    
}
@property (nonatomic,retain) UISearchController *searchController;
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, strong) JGDownListMenu *list;
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation HKXLeaseViewController{
    
    UITableView * leAndRetableView;
}

#pragma mark - LifeCycle

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self createUI];
    NSInteger roleId = [[NSUserDefaults standardUserDefaults]integerForKey:@"userDataRole"];
    NSInteger _roleID = roleId;
    if (_roleID == 0) {
        
        self.array = [NSArray arrayWithObjects:@"发布出租",@"发布求租",nil];
    }else{
        
        self.array = [NSArray arrayWithObjects:@"发布求租",nil];
    }
    
    
    [self.view addSubview:self.list];
    //下拉刷新
    leAndRetableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
    
    leAndRetableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [leAndRetableView.mj_header beginRefreshing];
}

-(JGDownListMenu *)list
{
    if (!_list)
    {
        CGRect rect = CGRectMake(ScreenWidth - 90, 60, 80, self.array.count * 40);
        _list = [[JGDownListMenu alloc] initWithFrame:rect ListDataSource:self.array rowHeight:40 view:RButton];
        _list.delegate = self;
    }
    return _list;
}

#pragma 出租/求租跳转
//代理方法实现跳转
-(void)dropDownListParame:(NSString *)aStr
{
    
    if ([aStr isEqualToString:@"发布出租"]) {
        issueLeaseViewController * i = [[issueLeaseViewController alloc] init];
        i.hidesBottomBarWhenPushed = YES;
        i.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:i animated:YES];
    }else{
        
        requireLeaseViewController * i = [[requireLeaseViewController alloc] init];
        i.view.backgroundColor = [UIColor whiteColor];
        i.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:i animated:YES];
    }
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    RButton.selected = NO;
    LButton.hidden = NO;
    self.navigationItem.titleView = lb;
    page = 2;
}
#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //左按钮
    LButton =[UIButton buttonWithType:UIButtonTypeCustom];
    LButton.frame = CGRectMake(0, 40 * myDelegate.autoSizeScaleY, 40, 40);
    LButton.imageEdgeInsets= UIEdgeInsetsMake(0, 20, 0, 0);
    [LButton setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [LButton setTitle:@"搜索" forState:UIControlStateNormal];
    LButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    [LButton addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:LButton];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    //右按钮
    RButton =[UIButton buttonWithType:UIButtonTypeCustom];
    RButton.frame = CGRectMake(0, 0, 40, 40);
    [RButton setImage:[UIImage imageNamed:@"添加"] forState:UIControlStateNormal];
    [RButton addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithCustomView:RButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 5)];
    view.backgroundColor = [CommonMethod getUsualColorWithString:@"#f6f6f6"];
    [self.view addSubview:view];
    
    //出租/求租按钮
    leButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leButton.frame = CGRectMake(ScreenWidth / 2 - ScreenWidth / 4, view.frame.origin.y + view.frame.size.height + 10, ScreenWidth / 4, 40);
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
    
    leAndRetableView = [[UITableView alloc] initWithFrame:CGRectMake(0, reButton.frame.origin.y + reButton.frame.size.height + 10, ScreenWidth, ScreenHeight - reButton.frame.origin.y - 80) style:UITableViewStylePlain];
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
    
    
    if (leButton.selected) {
        //获取出租列表数据
        if (_dataArr.count != 0) {
            
            [_dataArr removeAllObjects];
        }
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"1",@"pageNo",
                               @"8",@"pageSize",
                               nil];
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"leasemachine/queryAll.do"] params:dict success:^(id responseObject) {
            
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
        
        
        if (_dataArr.count != 0) {
            
            [_dataArr removeAllObjects];
        }
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               @"1",@"pageNo",
                               @"8",@"pageSize",
                               nil];
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"bylease/queryAll.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            if ([dicts[@"success"] boolValue] == YES) {
                
                _dataArr = dicts[@"data"];
                
                
                [leAndRetableView reloadData];
                [leAndRetableView.mj_header endRefreshing];
            }else{
                [leAndRetableView.mj_header endRefreshing];
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
    
    if (leButton.selected) {
        //获取出租列表数据
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSString stringWithFormat:@"%d",page],@"pageNo",
                               @"8",@"pageSize",
                               nil];
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"leasemachine/queryAll.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
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
    }else{
        
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSString stringWithFormat:@"%d",page],@"pageNo",
                               @"8",@"pageSize",
                               nil];
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"bylease/queryAll.do"] params:dict success:^(id responseObject) {
            
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
    
    
    
    
    
}

#pragma mark 获取数据

- (NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"搜索");
    
}// called when keyboard search button presse
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"搜索");
    
} // called when bookmark button pressed
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    NSLog(@"搜索");
} // called when cancel button pressed
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar{
    
}
#pragma mark 点击搜索
- (void)leftBtnClick:(UIButton *)btn{
    
    NSLog(@"点击搜索");
    btn.hidden = YES;
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    self.searchController.delegate= self;
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.delegate = self;
    //包着搜索框外层的颜色
    self.searchController.searchBar.barTintColor = [UIColor whiteColor];
    
    //提醒字眼
    self.searchController.searchBar.placeholder= @"请输入设备地址搜索";
    
    //提前在搜索框内加入搜索词
    //self.searchController.searchBar.text = @"我是周杰伦";
    
    
    //设置UISearchController的显示属性，以下3个属性默认为YES
    
    //搜索时，背景变暗色
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    
    //点击搜索的时候,是否隐藏导航栏
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.showsCancelButton = YES;
    for(id sousuo in [self.searchController.searchBar subviews])
    {
        
        for (id zz in [sousuo subviews])
        {
            
            if([zz isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)zz;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                //                    [btn addTarget:self action:@selector(searchEquipment:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }
    //位置
    self.searchController.searchBar.frame = CGRectMake(0, 0, self.searchController.searchBar.frame.size.width, 44.0);
    
    // 添加 searchbar 到 headerview
    self.navigationItem.titleView = self.searchController.searchBar;
    
}
//谓词搜索过滤
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    
    //修改"Cancle"退出字眼,这样修改,按钮一开始就直接出现,而不是搜索的时候再出现
    
    //    searchController.searchBar.showsSearchResultsButton = YES;
    //
    //    [self.searchController.searchBar setImage:[UIImage imageNamed:@"添加"]forSearchBarIcon:UISearchBarIconResultsList state:UIControlStateNormal];
    NSString *searchString = [self.searchController.searchBar text];
    //        for(id sousuo in [searchController.searchBar subviews])
    //        {
    //
    //            for (id zz in [sousuo subviews])
    //            {
    //
    //                if([zz isKindOfClass:[UIButton class]]){
    //                    UIButton *btn = (UIButton *)zz;
    //                    [btn setTitle:@"取消" forState:UIControlStateNormal];
    //                    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    //                    [btn addTarget:self action:@selector(searchEquipment:) forControlEvents:UIControlEventTouchUpInside];
    //      }
    //
    //
    //            }
    //        }
    
    NSLog(@"updateSearchResultsForSearchController");
    
    //NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
    //    if (self.searchListArry!= nil) {
    //        [self.searchListArry removeAllObjects];
    //    }
    //过滤数据
    //self.searchListArry= [NSMutableArray arrayWithArray:[self.dataListArry filteredArrayUsingPredicate:preicate]];
    //刷新表格
    
    //获取搜索的关键字
    if (searchString.length == 0) {
        
        return;
    }
    if (_dataArr.count != 0) {
        
        [_dataArr removeAllObjects];
    }
    
    if (leButton.selected) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:searchString,@"search",nil];
        
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"leasemachine/selectAddLike.do"] params:dict success:^(id responseObject) {
            [self.view hideActivity];
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            if ([dicts[@"data"] isKindOfClass:[NSNull class]]) {
                
                [_dataArr removeAllObjects];
                [leAndRetableView reloadData];
            }else{
                if ([dicts[@"success"] boolValue] == YES) {
                    
                    _dataArr = dicts[@"data"];
                    
                    [leAndRetableView reloadData];
                }else{
                    
                    [self showHint:dicts[@"message"]];
                }
                
            }
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [leAndRetableView reloadData];
            [self.view hideActivity];
            [self showHint:@"请求失败"];
        }];
    }else if (reButton.selected){
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:searchString,@"search",nil];
        
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"bylease/selectAddLike.do"] params:dict success:^(id responseObject) {
            [self.view hideActivity];
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            if ([dicts[@"data"] isKindOfClass:[NSNull class]]) {
                
                [_dataArr removeAllObjects];
                [leAndRetableView reloadData];
            }else{
                if ([dicts[@"success"] boolValue] == YES) {
                    
                    _dataArr = dicts[@"data"];
                    
                    [leAndRetableView reloadData];
                }else{
                    
                    [self showHint:dicts[@"message"]];
                }
                
            }
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [leAndRetableView reloadData];
            [self.view hideActivity];
            [self showHint:@"请求失败"];
        }];
    }
    
    
    
}


#pragma mark - UISearchControllerDelegate代理,可以省略,主要是为了验证打印的顺序
//测试UISearchController的执行过程

- (void)willPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"willPresentSearchController");
}

- (void)didPresentSearchController:(UISearchController *)searchController
{
    NSLog(@"didPresentSearchController");
#warning 如果进入预编辑状态,searchBar消失(UISearchController套到TabBarController可能会出现这个情况),请添加下边这句话
    //    [self.view addSubview:self.searchController.searchBar];
}

- (void)willDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"willDismissSearchController");
    [UIView animateWithDuration:0.5 animations:^{
        LButton.hidden = NO;
        self.navigationItem.titleView = lb;
    }];
    [self.searchController.searchBar removeFromSuperview];
    
    
}

- (void)didDismissSearchController:(UISearchController *)searchController
{
    NSLog(@"didDismissSearchController");
}

- (void)presentSearchController:(UISearchController *)searchController
{
    NSLog(@"presentSearchController");
}

#pragma mark 点击加号
- (void)rightBtnClick:(UIButton *)btn{
    
    NSLog(@"点击加号");
    
    btn.selected = !btn.selected;
    if (btn.selected == YES)
    {
        [_list showList];
        //_msakImg.transform = CGAffineTransformRotate(_msakImg.transform, M_PI);
    }else
    {
        [_list hiddenList];
        //_msakImg.transform = CGAffineTransformRotate(_msakImg.transform, -M_PI);
    }
    
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
            
            [cell.equipmentImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,_dataArr[indexPath.row][@"picture"]]] placeholderImage:nil];
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
