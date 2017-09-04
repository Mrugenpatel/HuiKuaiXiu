//
//  HKXShoppingMallViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/6/29.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXShoppingMallViewController.h"
#import "CommonMethod.h"
#import "JGDownListMenu.h"
#import "MyDropView.h"
#import "goodsTableViewCell.h"
#import "goodsPartDetailViewController.h"
#import "goodsEquipmentDetailViewController.h"
#import "ProvinceModel.h"
#import "PartGoodsModel.h"
#import "UIImageView+WebCache.h"
#import "EquipmentGoodsModel.h"
@interface HKXShoppingMallViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchControllerDelegate,UISearchResultsUpdating,DownListMenuDelegate,MyDownListMenuDelegate1>{
    
    UIView * topView;//放类别地区搜索的视图
    UIView * checkListView;//放寻找..的视图
    UIButton * classifyBtn;//类别按钮
    UIButton * arrowBtn1;//商城箭头
    UIButton * partBtn;//找配件
    UIButton * equipmentBtn;//找设备
    
    UITableView * goodsTableView;//商品列表
    int page;
    
    NSString * searchString;
    NSString * classifyString;//选的类别
    NSString * proString;//选的地区
    
}

@property (nonatomic,retain) UISearchController *searchController;
@property (nonatomic, strong) JGDownListMenu *list;
@property (nonatomic, strong) MyDropView *list1;

@property (nonatomic , strong) NSMutableArray * goodsModelArr;
@property (nonatomic , strong) NSMutableArray * classifyArr;
@end

@implementation HKXShoppingMallViewController



#pragma mark - LifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    classifyString = @"全部";
    searchString = @"";
    [self createUI];
    [goodsTableView.mj_header beginRefreshing];
    page = 2;
}
- (NSMutableArray *)goodsModelArr
{
    if (!_goodsModelArr)
    {
        _goodsModelArr = [NSMutableArray array];
    }
    return _goodsModelArr;
}
- (NSMutableArray *)classifyArr
{
    if (!_classifyArr)
    {
        _classifyArr = [NSMutableArray array];
    }
    return _classifyArr;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.searchController.searchBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
}
#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    //重新创建一个barButtonItem
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    //设置backBarButtonItem即可
    self.navigationItem.backBarButtonItem = backItem;
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, 5)];
    view.backgroundColor = [CommonMethod getUsualColorWithString:@"#f6f6f6"];
    [self.view addSubview:view];
    
    topView = [[UIView alloc] initWithFrame:CGRectMake(0, view.frame.origin.y + view.frame.size.height, ScreenWidth, 44)];
    topView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:topView];
    
    classifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    classifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 40, topView.frame.size.height)];
    [classifyBtn setTitle:@"类别" forState:UIControlStateNormal];
    classifyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [classifyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [classifyBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateSelected];
    
    //[classifyBtn addTarget:self action:@selector(showClassifyList:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:classifyBtn];
    
    arrowBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    arrowBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(classifyBtn.frame.origin.x + classifyBtn.frame.size.width, 0, 30, topView.frame.size.height)];
    [arrowBtn1 setImage:[UIImage imageNamed:@"商城箭头"] forState:UIControlStateNormal];
    [arrowBtn1 addTarget:self action:@selector(showClassifyList:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:arrowBtn1];
    
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    //设置代理
    self.searchController.delegate= self;
    self.searchController.searchResultsUpdater = self;
    //包着搜索框外层的颜色
    self.searchController.searchBar.barTintColor = [UIColor whiteColor];
    //提醒字眼
    self.searchController.searchBar.placeholder= @"请输入搜索内容";
    //提前在搜索框内加入搜索词
    //self.searchController.searchBar.text = @"我是周杰伦";
    //设置UISearchController的显示属性，以下3个属性默认为YES
    //搜索时，背景变暗色
    self.searchController.dimsBackgroundDuringPresentation = NO;
    //搜索时，背景变模糊
    self.searchController.obscuresBackgroundDuringPresentation = NO;
    //点击搜索的时候,是否隐藏导航栏
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    //位置
    UIView * viewq = [[UIView alloc] initWithFrame:CGRectMake(arrowBtn1.frame.size.width + arrowBtn1.frame.origin.x + 10, 0 ,ScreenWidth - arrowBtn1.frame.size.width - arrowBtn1.frame.origin.x - 20, 44)];
    viewq.backgroundColor = [UIColor whiteColor];
    [topView addSubview:viewq];
    [self.searchController.searchBar setBackgroundImage:[UIImage new]];
    
    self.searchController.searchBar.frame = CGRectMake(2, 0,viewq.frame.size.width -5, 44);
    UITextField *searchField=[self.searchController.searchBar valueForKey:@"_searchField"];
    
    searchField.borderStyle = UITextBorderStyleRoundedRect;
    searchField.layer.backgroundColor = [[CommonMethod getUsualColorWithString:@"#eeeeee"] CGColor];
    searchField.layer.cornerRadius = 4.0;
    searchField.layer.borderWidth = 0.1f;
    searchField.layer.masksToBounds = YES;
    // 添加 searchbar 到 headerview
    [viewq addSubview:self.searchController.searchBar];
    
    checkListView = [[UIView alloc] initWithFrame:CGRectMake(0, topView.frame.origin.y + topView.frame.size.height, arrowBtn1.frame.size.width + arrowBtn1.frame.origin.x, ScreenHeight - topView.frame.origin.y - topView.frame.size.height)];
    checkListView.backgroundColor = [CommonMethod getUsualColorWithString:@"#eeeeee"];
    
    [self.view addSubview:checkListView];
    
    partBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    partBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, checkListView.frame.size.width, 60)];
    [partBtn setTitle:@"找配件" forState:UIControlStateNormal];
    [partBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    partBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [partBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateSelected];
    [partBtn addTarget:self action:@selector(seekPart:) forControlEvents:UIControlEventTouchUpInside];
    partBtn.selected = YES;
    [checkListView addSubview:partBtn];
    
    equipmentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    equipmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, partBtn.frame.size.height, checkListView.frame.size.width, partBtn.frame.size.height)];
    [equipmentBtn setTitle:@"找设备" forState:UIControlStateNormal];
    equipmentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [equipmentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [equipmentBtn setTitleColor:[CommonMethod getUsualColorWithString:@"#ffa304"] forState:UIControlStateSelected];
    [equipmentBtn setBackgroundColor:[UIColor whiteColor]];
    [equipmentBtn addTarget:self action:@selector(seekEquipment:) forControlEvents:UIControlEventTouchUpInside];
    [checkListView addSubview:equipmentBtn];
    
    
    goodsTableView = [[UITableView alloc] initWithFrame:CGRectMake(checkListView.frame.size.width, checkListView.frame.origin.y, ScreenWidth - checkListView.frame.size.width, ScreenHeight -checkListView.frame.origin.y - 44 ) style:UITableViewStylePlain];
    goodsTableView.showsVerticalScrollIndicator = NO;
    goodsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [goodsTableView registerNib:[UINib nibWithNibName:@"goodsTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    goodsTableView.delegate = self;
    goodsTableView.dataSource = self;
    [self.view addSubview:goodsTableView];
    
    goodsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    
    
    goodsTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
}



- (void)refresh{
    
    if (self.goodsModelArr.count !=0) {
        
        [self.goodsModelArr removeAllObjects];
    }
    if (partBtn.selected) {
        //配件
        page = 2;
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:classifyString,@"category",searchString,@"search",@"1",@"pageNo",@"8",@"pageSize",nil];
        NSLog(@"%@",dict);
        
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"supplierbase/selectRack.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            [goodsTableView.mj_header endRefreshing];
            if ([dicts[@"success"] boolValue] == YES) {
                
                NSMutableArray * tempArr = [[NSMutableArray alloc] init];
                tempArr = dicts[@"data"];
                for (int i = 0; i < tempArr.count; i ++) {
                    
                    
                    PartGoodsModel * partGoods = [[PartGoodsModel alloc] initWithDict:tempArr[i]];
                    [self.goodsModelArr addObject:partGoods];
                }
                [goodsTableView reloadData];
                
                
            }else{
                
                [self showHint:dicts[@"message"]];
                [goodsTableView reloadData];
            }
            
            
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [goodsTableView.mj_header endRefreshing];
            [self.view hideActivity];
            [self showHint:@"请求失败"];
            
        }];
        
    }else if (equipmentBtn.selected){
        //设备
        page = 2;
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:classifyString,@"add",searchString,@"search",@"1",@"pageNo",@"8",@"pageSize",nil];
        NSLog(@"%@",dict);
        
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"supplier/selectRack.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            [goodsTableView.mj_header endRefreshing];
            if ([dicts[@"success"] boolValue] == YES) {
                
                NSMutableArray * tempArr = [[NSMutableArray alloc] init];
                tempArr = dicts[@"data"];
                for (int i = 0; i < tempArr.count; i ++) {
                    
                    
                    EquipmentGoodsModel * equipmentGoods = [[EquipmentGoodsModel alloc] initWithDict:tempArr[i]];
                    [self.goodsModelArr addObject:equipmentGoods];
                }
                [goodsTableView reloadData];
                
            }else{
                
                [self showHint:dicts[@"message"]];
                [goodsTableView reloadData];
            }
            
            
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [goodsTableView.mj_header endRefreshing];
            [self.view hideActivity];
            [self showHint:@"请求失败"];
            
        }];
        
    }
    
    
}

- (void)loadData{
    
    
    if (partBtn.selected) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:classifyString,@"category",searchString,@"search",[NSNumber numberWithInteger:page],@"pageNo",@"8",@"pageSize",nil];
        NSLog(@"%@",dict);
        
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"supplierbase/selectRack.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            [goodsTableView.mj_footer endRefreshing];
            if ([dicts[@"success"] boolValue] == YES) {
                NSMutableArray * tempArr = [[NSMutableArray alloc] init];
                tempArr = dicts[@"data"];
                for (int i = 0; i < tempArr.count; i ++) {
                    
                    PartGoodsModel * partGoods = [[PartGoodsModel alloc] initWithDict:tempArr[i]];
                    [self.goodsModelArr addObject:partGoods];
                }
                page++;
                [goodsTableView reloadData];
                NSLog(@"======%ld",self.goodsModelArr.count);
                
            }else{
                
                [self showHint:dicts[@"message"]];
                [goodsTableView reloadData];
            }
            
            
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [goodsTableView.mj_footer endRefreshing];
            [self.view hideActivity];
            [self showHint:@"请求失败"];
            
        }];
    }else if (equipmentBtn.selected){
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:classifyString,@"add",searchString,@"search",[NSNumber numberWithInteger:page],@"pageNo",@"8",@"pageSize",nil];
        NSLog(@"%@",dict);
        
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"supplier/selectRack.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            [goodsTableView.mj_footer endRefreshing];
            if ([dicts[@"success"] boolValue] == YES) {
                NSMutableArray * tempArr = [[NSMutableArray alloc] init];
                tempArr = dicts[@"data"];
                for (int i = 0; i < tempArr.count; i ++) {
                    
                    EquipmentGoodsModel * equipmentGoods = [[EquipmentGoodsModel alloc] initWithDict:tempArr[i]];
                    [self.goodsModelArr addObject:equipmentGoods];
                }
                page++;
                [goodsTableView reloadData];
                NSLog(@"======%ld",self.goodsModelArr.count);
                
            }else{
                
                [self showHint:dicts[@"message"]];
                [goodsTableView reloadData];
            }
            
            
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [goodsTableView.mj_footer endRefreshing];
            [self.view hideActivity];
            [self showHint:@"请求失败"];
            
        }];
    }
}



//谓词搜索过滤
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    //修改"Cancle"退出字眼,这样修改,按钮一开始就直接出现,而不是搜索的时候再出现
    searchController.searchBar.showsCancelButton = YES;
    //    searchController.searchBar.showsSearchResultsButton = YES;
    //
    //    [self.searchController.searchBar setImage:[UIImage imageNamed:@"添加"]forSearchBarIcon:UISearchBarIconResultsList state:UIControlStateNormal];
    searchString = [self.searchController.searchBar text];
    
    for(id sousuo in [searchController.searchBar subviews])
    {
        
        for (id zz in [sousuo subviews])
        {
            
            if([zz isKindOfClass:[UIButton class]]){
                UIButton *btn = (UIButton *)zz;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            }
        }
    }
    if (searchString.length == 0) {
        
        return;
    }
    if (self.goodsModelArr.count !=0) {
        
        [self.goodsModelArr removeAllObjects];
    }
    page = 2;
    if (partBtn.selected) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:classifyString,@"category",searchString,@"search",@"1",@"pageNo",@"8",@"pageSize",nil];
        NSLog(@"%@",dict);
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"supplierbase/selectRack.do"] params:dict success:^(id responseObject) {
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            
            if ([dicts[@"success"] boolValue] == YES) {
                
                NSMutableArray * tempArr = [[NSMutableArray alloc] init];
                tempArr = dicts[@"data"];
                for (int i = 0; i < tempArr.count; i ++) {
                    
                    PartGoodsModel * partGoods = [[PartGoodsModel alloc] initWithDict:tempArr[i]];
                    [self.goodsModelArr addObject:partGoods];
                }
                [goodsTableView reloadData];
                
                
            }else{
                
                [self showHint:dicts[@"message"]];
                [goodsTableView reloadData];
            }
            
            
        } failure:^(NSError *error) {
            
            [self showHint:@"请求失败"];
            
        }];
    }else if (equipmentBtn.selected){
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:classifyString,@"add",searchString,@"search",@"1",@"pageNo",@"8",@"pageSize",nil];
        NSLog(@"%@",dict);
        
        [self.view showActivity];
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"supplier/selectRack.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            [goodsTableView.mj_footer endRefreshing];
            if ([dicts[@"success"] boolValue] == YES) {
                NSMutableArray * tempArr = [[NSMutableArray alloc] init];
                tempArr = dicts[@"data"];
                for (int i = 0; i < tempArr.count; i ++) {
                    
                    EquipmentGoodsModel * equipmentGoods = [[EquipmentGoodsModel alloc] initWithDict:tempArr[i]];
                    [self.goodsModelArr addObject:equipmentGoods];
                }
                page++;
                [goodsTableView reloadData];
                NSLog(@"======%ld",self.goodsModelArr.count);
                
            }else{
                
                [self showHint:dicts[@"message"]];
                [goodsTableView reloadData];
            }
            
            
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [goodsTableView.mj_footer endRefreshing];
            [self.view hideActivity];
            [self showHint:@"请求失败"];
            
        }];
        
    }
    
    
    
}

//展示分类列表
- (void)showClassifyList:(UIButton *)btn{
    
    //找配件
    if (partBtn.selected) {
        
        
        [IWHttpTool postWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"category/partsList.do"] params:nil success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            
            if ([dicts[@"success"] boolValue] == YES) {
                
                
                self.classifyArr = dicts[@"data"];
                NSMutableArray * nameArr = [[NSMutableArray alloc] init];
                for ( int i = 0 ; i < self.classifyArr.count; i ++) {
                    
                    [nameArr addObject:self.classifyArr[i][@"name"]];
                }
                
                
                CGRect rect = CGRectMake(0,topView.frame.origin.y + topView.frame.size.height ,checkListView.frame.size.width, nameArr.count * 40);
                if (_list) {
                    
                    [_list removeFromSuperview];
                }
                _list = [[JGDownListMenu alloc] initWithFrame:rect ListDataSource:nameArr rowHeight:40 view:btn];
                _list.mark = @"商城列表";
                _list.delegate = self;
                [self.view addSubview:_list];
                
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
                
            }else{
                
                [self showHint:dicts[@"message"]];
                
            }
            
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            [self showHint:@"请求失败"];
            
        }];
    }else if (equipmentBtn.selected){
        
        //city.plist是数组
        NSString *plist = [[NSBundle mainBundle] pathForResource:@"city" ofType:@"plist"];
        NSMutableArray *dataCity = [[NSMutableArray alloc] initWithContentsOfFile:plist];
        NSMutableArray * provinceArr = [[NSMutableArray alloc]init];
        NSMutableArray * proArr = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in dataCity) {
            ProvinceModel *model  = [[ProvinceModel alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            model.citiesArr = [[NSMutableArray alloc]init];
            
            [provinceArr addObject:model];
        }
        proArr = [NSMutableArray arrayWithCapacity:0];
        [proArr addObject:@"全国"];
        for (ProvinceModel *model in provinceArr) {
            
            [proArr addObject:model.name];
        }
        self.classifyArr = proArr;
        
        CGRect rect = CGRectMake(0,topView.frame.origin.y + topView.frame.size.height ,checkListView.frame.size.width, ScreenHeight - CGRectGetMaxY(topView.frame) - 44);
        if (_list) {
            
            [_list removeFromSuperview];
        }
        _list = [[JGDownListMenu alloc] initWithFrame:rect ListDataSource:proArr rowHeight:40 view:btn];
        _list.delegate = self;
        _list.mark = @"商城列表";
        [self.view addSubview:_list];
        
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
    
    
    
}

//选择一级
-(void)dropDownListParame:(NSString *)aStr
{
    
    if (partBtn.selected) {
        
        if (_list1) {
            
            [_list1 removeFromSuperview];
        }
        NSInteger  i = [aStr integerValue];
        NSMutableArray * classifyArr2 = [[NSMutableArray alloc] init];
        classifyArr2 = self.classifyArr[i][@"category"];
        NSMutableArray * nameArr2 = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < classifyArr2.count; i ++) {
            
            [nameArr2 addObject:classifyArr2[i][@"name"]];
        }
        
        if (nameArr2.count == 0) {
            
            return;
        }
        
        CGRect rect = CGRectMake(_list.frame.size.width + _list.frame.origin.x, _list.frame.origin.y + 40 * [aStr integerValue] + 40, checkListView.frame.size.width, 5 * 40);
        _list1 = [[MyDropView alloc] initWithFrame1:rect ListDataSource1:nameArr2 rowHeight1:40 view1:nil];
        _list1.delegate = self;
        [self.view addSubview:self.list1];
        [_list1 showList1];
    }else if (equipmentBtn.selected){
        
        [_list hiddenList];
        arrowBtn1.selected = NO;
        NSInteger  i = [aStr integerValue];
        classifyString =_classifyArr[i];
        [goodsTableView.mj_header beginRefreshing];
    }
    
    
    
}
//选择二级
-(void)dropDownListParame1:(NSString *)aStr
{
    classifyString = aStr;
    [goodsTableView.mj_header beginRefreshing];
    arrowBtn1.selected = NO;
    [_list hiddenList];
    
}
//查找配件
- (void)seekPart:(UIButton *)btn{
    
    
    if (btn.selected) {
        
        
    }else{
        btn.selected = !btn.selected;
        // [partBtn setBackgroundColor:[CommonMethod getUsualColorWithString:@"#eeeeee"]];
        [classifyBtn setTitle:@"类别" forState:UIControlStateNormal];
    }
    
    equipmentBtn.selected = NO;
    classifyString = @"全部";
    [goodsTableView.mj_header beginRefreshing];
    //[equipmentBtn setBackgroundColor:[UIColor whiteColor]];
}
//查找设备
- (void)seekEquipment:(UIButton *)btn{
    
    if (btn.selected) {
        
        
    }else{
        btn.selected = !btn.selected;
        //[equipmentBtn setBackgroundColor:[CommonMethod getUsualColorWithString:@"#eeeeee"]];
        [classifyBtn setTitle:@"地区" forState:UIControlStateNormal];
    }
    partBtn.selected = NO;
    classifyString = @"全国";
    [goodsTableView.mj_header beginRefreshing];
    
    //[partBtn setBackgroundColor:[UIColor whiteColor]];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.goodsModelArr.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    goodsTableViewCell * cell = [goodsTableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (partBtn.selected) {
        PartGoodsModel * model = self.goodsModelArr[indexPath.row];
        [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,model.picture[0]]] placeholderImage:nil];
        cell.goodsPrice.text = [NSString stringWithFormat:@"¥%@",model.price];
        cell.goodsPrice.textColor = [UIColor redColor];
        cell.goodsAddress.text = model.address;
        cell.goodsCompany.text = model.companyName;
        cell.goodsBrand.text = model.basename;
        return cell;
        
    }else if (equipmentBtn.selected){
        
        EquipmentGoodsModel * model = self.goodsModelArr[indexPath.row];
        [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,model.picture]] placeholderImage:nil];
        cell.goodsPrice.text = model.modelnum;
        cell.goodsPrice.textColor = [UIColor blackColor];
        cell.goodsAddress.text = model.parameter;
        cell.goodsCompany.text = model.compname;
        cell.goodsBrand.text = model.brand;
        
        return cell;
    }else{
        
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //跳转详情界面
    if (partBtn.selected) {
        
        goodsPartDetailViewController * goodsDetail = [[goodsPartDetailViewController alloc] init];
        goodsDetail.partModel = self.goodsModelArr[indexPath.row];
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }
    
    if (equipmentBtn.selected) {
        
        goodsEquipmentDetailViewController * goodsDetail = [[goodsEquipmentDetailViewController alloc] init];
        goodsDetail.equipmentModel = self.goodsModelArr[indexPath.row];
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    
    self.searchController.searchBar.hidden = YES;
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
