//
//  HKXMineSaleListViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineSaleListViewController.h"
#import "CommonMethod.h"

#import "HKXSupplierOrderStoreModel.h"
#import "HKXSupplierOrderGoodsModel.h"

#import "HKXSupplierSaleListHeaderView.h"
#import "HKXSupplierSaleListFooterView.h"
static NSString * const HKXHeaderId = @"header";
static NSString * const HKXFooterId = @"footer";
@interface HKXMineSaleListViewController ()<UIScrollViewDelegate , UITableViewDelegate , UITableViewDataSource,HKXSupplierSaleListBtnDelegate>
{
    UISegmentedControl * _segmentControl;//分段控制
    UIScrollView       * _bottomScrollView;//底层大的滑动视图
    UITableView * goodsListTableView;
    int page;
}

@property (nonatomic , strong) NSMutableArray * segementTitleArray;//分段数组
@property (nonatomic , strong) NSMutableArray * tableViewListArray;//所有的tableview数组
@property (nonatomic , strong) NSMutableArray * allGoodsDataListArray;//所有的商品信息数组
@property (nonatomic , strong) NSMutableArray * allDoneGoodsDataListArray;//所有已完成的商品信息数组
@property (nonatomic , strong) NSMutableArray * allCanceledGoodsDataListArray;//所有已取消的商品信息数组

@end

@implementation HKXMineSaleListViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.segementTitleArray = [NSMutableArray arrayWithObjects:@"全部订单",@"已完成",@"已取消", nil];
    [self createUI];
    [goodsListTableView.mj_header beginRefreshing];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}
#pragma mark - CreateUI
- (void)createUI
{
    self.view.backgroundColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1];
    [self createSegment];
    [self createBottomScrollView];
}
- (void)createSegment
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 5 * myDelegate.autoSizeScaleY + 64, ScreenWidth, 40 * myDelegate.autoSizeScaleY)];
    bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottomView];
    
    //    scrollView
    _segmentControl = [[UISegmentedControl alloc] initWithItems:self.segementTitleArray];
    _segmentControl.frame = CGRectMake(38 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, 300 * myDelegate.autoSizeScaleX, 29 * myDelegate.autoSizeScaleY);
    _segmentControl.tintColor = [CommonMethod getUsualColorWithString:@"#ffa302"];
    _segmentControl.selectedSegmentIndex = 0;
    [_segmentControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    [bottomView addSubview:_segmentControl];
}
- (void)createBottomScrollView
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    _bottomScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0 , 45 * myDelegate.autoSizeScaleY + 64, ScreenWidth, ScreenHeight - 45 * myDelegate.autoSizeScaleY - 64 - 30)];
    _bottomScrollView.backgroundColor = [UIColor whiteColor];
    _bottomScrollView.contentSize = CGSizeMake(ScreenWidth * self.segementTitleArray.count, _bottomScrollView.frame.size.height);
    _bottomScrollView.pagingEnabled = YES;
    _bottomScrollView.bounces = NO;
    _bottomScrollView.directionalLockEnabled = YES;
    _bottomScrollView.showsHorizontalScrollIndicator = NO;
    _bottomScrollView.delegate = self;
    [self.view addSubview:_bottomScrollView];
    
    for (int i = 0 ; i < self.segementTitleArray.count ; i ++)
    {
        goodsListTableView = [[UITableView alloc] initWithFrame:CGRectMake(_bottomScrollView.frame.size.width * i, 0, _bottomScrollView.frame.size.width, _bottomScrollView.frame.size.height) style:UITableViewStyleGrouped];
        goodsListTableView.dataSource = self;
        goodsListTableView.delegate = self;
        goodsListTableView.showsVerticalScrollIndicator = NO;
        [_bottomScrollView addSubview:goodsListTableView];
        [self.tableViewListArray addObject:goodsListTableView];
        
        
        //        设置分割线长度
        if ([goodsListTableView respondsToSelector:@selector(setSeparatorInset:)])
        {
            [goodsListTableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
        }
        if ([goodsListTableView respondsToSelector:@selector(setLayoutMargins:)])
        {
            [goodsListTableView setLayoutMargins:UIEdgeInsetsMake(0, 12, 0, 12)];
        }
        
        [goodsListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        
        [goodsListTableView registerClass:[HKXSupplierSaleListHeaderView class] forHeaderFooterViewReuseIdentifier:HKXHeaderId];
        
        [goodsListTableView registerClass:[HKXSupplierSaleListFooterView class] forHeaderFooterViewReuseIdentifier:HKXFooterId];
        
        goodsListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(configData)];
        
        
        goodsListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    }
}
#pragma mark - ConfigData
- (void)configData
{
    page = 2;
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    if (_segmentControl.selectedSegmentIndex == 0) {

        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:uId],@"uId",@"1",@"pageNo",
                               @"8",@"pageSize",
                               nil];
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/selectSeller.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            [goodsListTableView.mj_header endRefreshing];
            if ([dicts[@"success"] boolValue] == YES) {
                
                self.allGoodsDataListArray = [HKXSupplierOrderStoreModel modelWithArray:dicts[@"data"]];
                [self.tableViewListArray[0] reloadData];
                
            }else{
                
                [self showHint:dicts[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [goodsListTableView.mj_header endRefreshing];
            [self.view hideActivity];
            
        }];

    }else if (_segmentControl.selectedSegmentIndex == 1){
        
        int i = 0;
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:uId],@"uId",@"1",@"pageNo",
                               @"8",@"pageSize",[NSNumber numberWithInt:i],@"status",
                               nil];
        [self.view showActivity];
        [goodsListTableView.mj_header endRefreshing];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/selectrOrderStatus.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            if ([dicts[@"success"] boolValue] == YES) {
                
                self.allDoneGoodsDataListArray = [HKXSupplierOrderStoreModel modelWithArray:dicts[@"data"]];
                [self.tableViewListArray[1] reloadData];
                
            }else{
                
                [self showHint:dicts[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
            [goodsListTableView.mj_header endRefreshing];
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            
        }];
    }else if (_segmentControl.selectedSegmentIndex == 2){
        
         int i = 1;
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:uId],@"uId",@"1",@"pageNo",
                               @"8",@"pageSize",[NSNumber numberWithInt:i],@"status",
                               nil];
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/selectSeller.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            [goodsListTableView.mj_header endRefreshing];
            if ([dicts[@"success"] boolValue] == YES) {
                
                self.allCanceledGoodsDataListArray = [HKXSupplierOrderStoreModel modelWithArray:dicts[@"data"]];
                [self.tableViewListArray[2] reloadData];
                
            }else{
                
                [self showHint:dicts[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
            [goodsListTableView.mj_header endRefreshing];
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            
        }];

        
    }
    
}
- (void)loadData{
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    double uId = [defaults doubleForKey:@"userDataId"];
    if (_segmentControl.selectedSegmentIndex == 0) {
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:uId],@"uId",page,@"pageNo",
                               @"8",@"pageSize",
                               nil];
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/selectSeller.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            [goodsListTableView.mj_header endRefreshing];
            NSMutableArray * tempArr = [NSMutableArray array];
            if ([dicts[@"success"] boolValue] == YES) {
                
                tempArr = [HKXSupplierOrderStoreModel modelWithArray:dicts[@"data"]];
                [self.allGoodsDataListArray addObject:tempArr];
                page ++;
                [self.tableViewListArray[0] reloadData];
                
            }else{
                
                [self showHint:dicts[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [goodsListTableView.mj_header endRefreshing];
            [self.view hideActivity];
            
        }];
        
    }else if (_segmentControl.selectedSegmentIndex == 1){
        
        int i = 0;
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:uId],@"uId",@"1",@"pageNo",
                               @"8",@"pageSize",[NSNumber numberWithInt:i],@"status",
                               nil];
        [self.view showActivity];
        [goodsListTableView.mj_header endRefreshing];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/selectrOrderStatus.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            NSMutableArray * tempArr = [NSMutableArray array];
            if ([dicts[@"success"] boolValue] == YES) {
                
                tempArr = [HKXSupplierOrderStoreModel modelWithArray:dicts[@"data"]];
                [self.allGoodsDataListArray addObject:tempArr];
                page ++;
                [self.tableViewListArray[0] reloadData];
                
            }else{
                
                [self showHint:dicts[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
            [goodsListTableView.mj_header endRefreshing];
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            
        }];
    }else if (_segmentControl.selectedSegmentIndex == 2){
        
        int i = 1;
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:uId],@"uId",@"1",@"pageNo",
                               @"8",@"pageSize",[NSNumber numberWithInt:i],@"status",
                               nil];
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/selectSeller.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            [goodsListTableView.mj_header endRefreshing];
            NSMutableArray * tempArr = [NSMutableArray array];
            if ([dicts[@"success"] boolValue] == YES) {
                
                tempArr = [HKXSupplierOrderStoreModel modelWithArray:dicts[@"data"]];
                [self.allGoodsDataListArray addObject:tempArr];
                page ++;
                [self.tableViewListArray[0] reloadData];
                
            }else{
                
                [self showHint:dicts[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
            [goodsListTableView.mj_header endRefreshing];
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            
        }];
        
        
    }
}

#pragma mark - Action
/**
 *  segment的点击事件
 *
 *  @param sc segment
 */
- (void)segmentedControlValueChanged:(UISegmentedControl *)sc
{
    [_bottomScrollView setContentOffset:CGPointMake(_bottomScrollView.frame.size.width * sc.selectedSegmentIndex, 0) animated:YES];
    
}

/**
 点击按钮编辑商品价格

 @param btn btn
 */
- (void)editGoodsPriceBtnClick:(UIButton *)btn
{
    NSLog(@"编辑商品价格");
}
#pragma mark - Private Method
#pragma mark - Delegate & Data Source
/**
 *  返回区的个数
 *
 *  @param tableView tableView
 *
 *  @return 区的个数
 */
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView == self.tableViewListArray[0])
    {
        
        return self.allGoodsDataListArray.count;
    }
    else if (tableView == self.tableViewListArray[1])
    {
        return self.allDoneGoodsDataListArray.count;
    }
    else if(tableView == self.tableViewListArray[2])
    {
        return self.allCanceledGoodsDataListArray.count;
    }else{
        
        return 0;
    }
}
/**
 *  每个区返回cell的个数
 *
 *  @param tableView tableView
 *  @param section   section
 *
 *  @return 每个区cell的个数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    HKXSupplierOrderStoreModel * store = self.allGoodsDataListArray[section];
    if (tableView == self.tableViewListArray[0])
    {
        
        return store.goodsArr.count;
    }
    else if (tableView == self.tableViewListArray[1])
    {
        return self.allDoneGoodsDataListArray.count;
    }
    else if(tableView == self.tableViewListArray[2])
    {
        return self.allCanceledGoodsDataListArray.count;
    }else{
        
        return 0;
    }
}
/**
 *  cell的行高
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return 高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return 260 * myDelegate.autoSizeScaleY - 75 * myDelegate.autoSizeScaleY - 44 * myDelegate.autoSizeScaleY - 10 * myDelegate.autoSizeScaleY;
}
/**
 *  区头高度
 *
 *  @param tableView tableView
 *  @param section   section
 *
 *  @return 区头高度
 */

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    HKXSupplierOrderStoreModel * store = self.allGoodsDataListArray[section];
    HKXSupplierSaleListHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HKXHeaderId];
    header.store = store;
   
    return header;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    HKXSupplierOrderStoreModel * store = self.allGoodsDataListArray[section];
    HKXSupplierSaleListFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HKXFooterId];
    footer.tag = section;
    footer.delegate = self;
    footer.store = store;
    return footer;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return 75 * myDelegate.autoSizeScaleY;
}
/**
 *  区尾高度
 *
 *  @param tableView tableView
 *  @param section   section
 *
 *  @return 区尾高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return 54 * myDelegate.autoSizeScaleY;
}
/**
 *  设置cell
 *
 *  @param tableView tableView
 *  @param indexPath indexPath
 *
 *  @return cell
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
   HKXSupplierOrderStoreModel * store = self.allGoodsDataListArray[indexPath.section];
    HKXSupplierOrderGoodsModel * goods = store.goodsArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIImageView * reGoodsImage = [cell viewWithTag:90001];
    [reGoodsImage removeFromSuperview];
    UILabel * reGoodsNameLabel = [cell viewWithTag:90002];
    [reGoodsNameLabel removeFromSuperview];
    UILabel * reGoodsTypeLabel = [cell viewWithTag:90003];
    [reGoodsTypeLabel removeFromSuperview];
    UILabel * rePriceLabel = [cell viewWithTag:90004];
    [rePriceLabel removeFromSuperview];
    UILabel * reGoodsNumLabel = [cell viewWithTag:90005];
    [reGoodsNumLabel removeFromSuperview];
    for (int i = 90006; i < 90009; i ++)
    {
        UIButton * reActionBtn = [cell viewWithTag:i];
        [reActionBtn removeFromSuperview];
    }
    UILabel * reGoodsModelLabel = [cell viewWithTag:90010];
    [reGoodsModelLabel removeFromSuperview];
    

//    商品信息
    
    UIImageView * goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(16 * myDelegate.autoSizeScaleX,20 * myDelegate.autoSizeScaleY, 102 * myDelegate.autoSizeScaleX, 95 * myDelegate.autoSizeScaleY)];
    goodsImg.tag = 90001;
    goodsImg.image = [UIImage imageNamed:@"滑动视图示例"];
    [cell addSubview:goodsImg];
    
    UILabel * goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 15 * myDelegate.autoSizeScaleX, 20 * myDelegate.autoSizeScaleY , [CommonMethod getLabelLengthWithString:@"慧快修 工程机械专用液压油" WithFont:13 * myDelegate.autoSizeScaleX ], 13 * myDelegate.autoSizeScaleX)];
    goodsNameLabel.tag = 90002;
    goodsNameLabel.text = goods.goodName;
    goodsNameLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsNameLabel];
    
    UILabel * goodsTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 15 * myDelegate.autoSizeScaleX, CGRectGetMaxY(goodsNameLabel.frame) + 12 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"产品品牌：壳牌" WithFont:13 * myDelegate.autoSizeScaleX ], 13 * myDelegate.autoSizeScaleX)];
    goodsTypeLabel.tag = 90003;
    goodsTypeLabel.text = goods.goodBrand;
    goodsTypeLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsTypeLabel];
    
    UILabel * goodsModelLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 15 * myDelegate.autoSizeScaleX, CGRectGetMaxY(goodsTypeLabel.frame) + 10 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"产品型号：XG806F" WithFont:13 * myDelegate.autoSizeScaleX ], 13 * myDelegate.autoSizeScaleX )];
    goodsModelLabel.tag = 90010;
    goodsModelLabel.text = goods.goodModel;
    goodsModelLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsModelLabel];
    
    UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 112 * myDelegate.autoSizeScaleX, CGRectGetMaxY(goodsModelLabel.frame) + 10 * myDelegate.autoSizeScaleY, 65 * myDelegate.autoSizeScaleX, 13 * myDelegate.autoSizeScaleX)];
    priceLabel.tag = 90004;
    priceLabel.textColor = [UIColor redColor];
    priceLabel.text = [NSString stringWithFormat:@"¥%.2f",[goods.goodPrice floatValue]];
    priceLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
    [cell addSubview:priceLabel];
    
    UILabel * goodsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 15 * myDelegate.autoSizeScaleX,  CGRectGetMaxY(goodsModelLabel.frame) + 10 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"X 2" WithFont:13 * myDelegate.autoSizeScaleX], 13 * myDelegate.autoSizeScaleX)];
    goodsNumLabel.tag = 90005;
    goodsNumLabel.text = [NSString stringWithFormat:@"X %@",goods.buyNumber];
    goodsNumLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsNumLabel];
    UIButton * editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.tag = 90006;
    editBtn.frame = CGRectMake(118 *myDelegate.autoSizeScaleX  + 184 * myDelegate.autoSizeScaleX,0, 65 * myDelegate.autoSizeScaleX, 30 * myDelegate.autoSizeScaleY);
    editBtn.layer.cornerRadius = 2;
    editBtn.clipsToBounds = YES;
    [editBtn addTarget:self action:@selector(editGoodsPriceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setTitle:@"价格修改" forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:12 * myDelegate.autoSizeScaleX];
    editBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa302"];
    editBtn.hidden = YES;
    [cell addSubview:editBtn];
    
    return cell;
}

/**
 *  scrollview已经结束减速的时候
 *
 *  @param scrollView scrollView
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _bottomScrollView)
    {
        [_segmentControl setSelectedSegmentIndex:scrollView.contentOffset.x / ScreenWidth];
    }
}


- (void)btnClick:(UIButton *)actionBtn{
    
    HKXSupplierOrderStoreModel * store = self.allGoodsDataListArray[actionBtn.tag];
    if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"-1"]) {
        
        [self delaeteOrderWithOrderId:[NSString stringWithFormat:@"%@",store.orderId]];
        
    }else if([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"0"]) {
        
        NSLog(@"完成");
        
    }else if([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"10"]) {
        
        [self cancelOrderWithOrderId:[NSString stringWithFormat:@"%@",store.orderId]];
        [self confirmDispatchGoodsWithOrderId:[NSString stringWithFormat:@"%@",store.orderId]];
        
    }else if([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"11"]) {
        
        NSLog(@"待买家付款");
       
        
    }else if([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"2"]) {
        
         NSLog(@"待确认收货");
        
    }else if([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"3"]) {
        
         NSLog(@"待收款");
        
    }else {
        
         NSLog(@"未知状态");
        
    }
    
}
- (void)cancelOrderWithOrderId:(NSString *)orderId{
    
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:[orderId doubleValue]],@"orderId",
                           nil];
    [self.view showActivity];
    [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/buycallOrder.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue] == YES) {
            
            [self showHint:dicts[@"message"]];
            
        }else{
            
            [self showHint:dicts[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        
    }];
    
}



- (void)confirmDispatchGoodsWithOrderId:(NSString *)orderId{
    
    
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                           [NSNumber numberWithDouble:[orderId doubleValue]],@"orderId",
                           nil];
    [self.view showActivity];
    [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/updateTakeGood.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue] == YES) {
            
            [self showHint:dicts[@"message"]];
            
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
                           [NSNumber numberWithDouble:[orderId doubleValue]],@"orderId",
                           nil];
    [self.view showActivity];
    [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/deleteOrder.do"] params:dict success:^(id responseObject) {
        
        NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"请求成功%@",dicts);
        [self.view hideActivity];
        if ([dicts[@"success"] boolValue] == YES) {
            
            [self showHint:dicts[@"message"]];
            
        }else{
            
            [self showHint:dicts[@"message"]];
        }
        
    } failure:^(NSError *error) {
        
        NSLog(@"请求失败%@",error);
        [self.view hideActivity];
        
    }];
    
}


#pragma mark - Setters & Getters
- (NSMutableArray *)segementTitleArray
{
    if (!_segementTitleArray)
    {
        _segementTitleArray = [NSMutableArray array];
    }
    return _segementTitleArray;
}
- (NSMutableArray *)tableViewListArray
{
    if (!_tableViewListArray)
    {
        _tableViewListArray = [NSMutableArray array];
    }
    return _tableViewListArray;
}
- (NSMutableArray *)allGoodsDataListArray
{
    if (!_allGoodsDataListArray)
    {
        _allGoodsDataListArray = [NSMutableArray array];
    }
    return _allGoodsDataListArray;
}
- (NSMutableArray *)allDoneGoodsDataListArray
{
    if (!_allDoneGoodsDataListArray)
    {
        _allDoneGoodsDataListArray = [NSMutableArray array];
    }
    return _allDoneGoodsDataListArray;
}
- (NSMutableArray *)allCanceledGoodsDataListArray
{
    if (!_allCanceledGoodsDataListArray)
    {
        _allCanceledGoodsDataListArray = [NSMutableArray array];
    }
    return _allCanceledGoodsDataListArray;
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