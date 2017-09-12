//
//  HKXMineSaleListViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineSaleListViewController.h"
#import "CommonMethod.h"

#import "HKXOrderStoreModel.h"
#import "HKXOrderGoodsModel.h"

#import "HKXSaleListHeaderView.h"
#import "HKXSaleListFooterView.h"
#import "UIImageView+WebCache.h"
static NSString * const HKXHeaderId = @"header";
static NSString * const HKXFooterId = @"footer";
@interface HKXMineSaleListViewController ()<UIScrollViewDelegate , UITableViewDelegate , UITableViewDataSource,HKXSaleListBtnDelegate>
{
    UISegmentedControl * _segmentControl;//分段控制
    UIScrollView       * _bottomScrollView;//底层大的滑动视图
    UITableView * allGoodsListTableView;
    UITableView * allDoneGoodsListTableView;
    UITableView * allCanceledGoodsTableView;
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
    [allGoodsListTableView.mj_header beginRefreshing];
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
    
    allGoodsListTableView = [[UITableView alloc] initWithFrame:CGRectMake(_bottomScrollView.frame.size.width * 0, 0, _bottomScrollView.frame.size.width, _bottomScrollView.frame.size.height) style:UITableViewStyleGrouped];
    allGoodsListTableView.dataSource = self;
    allGoodsListTableView.delegate = self;
    allGoodsListTableView.showsVerticalScrollIndicator = NO;
    //        设置分割线长度
    if ([allGoodsListTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [allGoodsListTableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
    }
    if ([allGoodsListTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [allGoodsListTableView setLayoutMargins:UIEdgeInsetsMake(0, 12, 0, 12)];
    }
    
    [allGoodsListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [allGoodsListTableView registerClass:[HKXSaleListHeaderView class] forHeaderFooterViewReuseIdentifier:HKXHeaderId];
    
    [allGoodsListTableView registerClass:[HKXSaleListFooterView class] forHeaderFooterViewReuseIdentifier:HKXFooterId];
    
    allGoodsListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(configData)];
    
    
    allGoodsListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [_bottomScrollView addSubview:allGoodsListTableView];
    
        
        
   
    allDoneGoodsListTableView = [[UITableView alloc] initWithFrame:CGRectMake(_bottomScrollView.frame.size.width * 1, 0, _bottomScrollView.frame.size.width, _bottomScrollView.frame.size.height) style:UITableViewStyleGrouped];
    allDoneGoodsListTableView.dataSource = self;
    allDoneGoodsListTableView.delegate = self;
    allDoneGoodsListTableView.showsVerticalScrollIndicator = NO;
    [_bottomScrollView addSubview:allDoneGoodsListTableView];
    
    
    
    //        设置分割线长度
    if ([allDoneGoodsListTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [allDoneGoodsListTableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
    }
    if ([allDoneGoodsListTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [allDoneGoodsListTableView setLayoutMargins:UIEdgeInsetsMake(0, 12, 0, 12)];
    }
    
    [allDoneGoodsListTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [allDoneGoodsListTableView registerClass:[HKXSaleListHeaderView class] forHeaderFooterViewReuseIdentifier:HKXHeaderId];
    
    [allDoneGoodsListTableView registerClass:[HKXSaleListFooterView class] forHeaderFooterViewReuseIdentifier:HKXFooterId];
    
    allDoneGoodsListTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(configData)];
    
    
    allDoneGoodsListTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    
    
    allCanceledGoodsTableView = [[UITableView alloc] initWithFrame:CGRectMake(_bottomScrollView.frame.size.width * 2, 0, _bottomScrollView.frame.size.width, _bottomScrollView.frame.size.height) style:UITableViewStyleGrouped];
    allCanceledGoodsTableView.dataSource = self;
    allCanceledGoodsTableView.delegate = self;
    allCanceledGoodsTableView.showsVerticalScrollIndicator = NO;
    [_bottomScrollView addSubview:allCanceledGoodsTableView];
    
    
    
    //        设置分割线长度
    if ([allCanceledGoodsTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        [allCanceledGoodsTableView setSeparatorInset:UIEdgeInsetsMake(0, 12, 0, 12)];
    }
    if ([allCanceledGoodsTableView respondsToSelector:@selector(setLayoutMargins:)])
    {
        [allCanceledGoodsTableView setLayoutMargins:UIEdgeInsetsMake(0, 12, 0, 12)];
    }
    
    [allCanceledGoodsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    [allCanceledGoodsTableView registerClass:[HKXSaleListHeaderView class] forHeaderFooterViewReuseIdentifier:HKXHeaderId];
    
    [allCanceledGoodsTableView registerClass:[HKXSaleListFooterView class] forHeaderFooterViewReuseIdentifier:HKXFooterId];
    
    allCanceledGoodsTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(configData)];
    
    
    allCanceledGoodsTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
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
            [allGoodsListTableView.mj_header endRefreshing];
            if ([dicts[@"success"] boolValue] == YES) {
                
                self.allGoodsDataListArray = [HKXOrderStoreModel modelWithArray:dicts[@"data"]];
                [allGoodsListTableView reloadData];
                
            }else{
                
                [self showHint:dicts[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            
            [self.view hideActivity];
            
        }];

    }else if (_segmentControl.selectedSegmentIndex == 1){
        
        int i = 0;
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:uId],@"uId",@"1",@"pageNo",
                               @"8",@"pageSize",[NSNumber numberWithInt:i],@"status",
                               nil];
        [self.view showActivity];
        
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/selectrOrderStatus.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
           
            [allDoneGoodsListTableView.mj_header endRefreshing];
            if ([dicts[@"success"] boolValue] == YES) {
                
                self.allDoneGoodsDataListArray = [HKXOrderStoreModel modelWithArray:dicts[@"data"]];
                [allDoneGoodsListTableView reloadData];
                
            }else{
                
                [self showHint:dicts[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
            [allDoneGoodsListTableView.mj_header endRefreshing];
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            
        }];
    }else if (_segmentControl.selectedSegmentIndex == 2){
        
        int i = -1;
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:uId],@"uId",@"1",@"pageNo",
                               @"8",@"pageSize",[NSNumber numberWithInt:i],@"status",
                               nil];
        [self.view showActivity];
       
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/selectrOrderStatus.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            [self.view hideActivity];
            [allCanceledGoodsTableView.mj_header endRefreshing];
            if ([dicts[@"success"] boolValue] == YES) {
                
                self.allCanceledGoodsDataListArray = [HKXOrderStoreModel modelWithArray:dicts[@"data"]];
                [allCanceledGoodsTableView reloadData];
                
            }else{
                
                [self showHint:dicts[@"message"]];
                
            }
            
        } failure:^(NSError *error) {
            
            [allCanceledGoodsTableView.mj_header endRefreshing];
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
                               [NSNumber numberWithDouble:uId],@"uId",[NSNumber numberWithInt:page],@"pageNo",
                               @"8",@"pageSize",
                               nil];
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/selectSeller.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            
            [allGoodsListTableView.mj_footer endRefreshing];
            NSMutableArray * tempArr = [NSMutableArray array];
            if ([dicts[@"success"] boolValue] == YES) {
                
                tempArr = [HKXOrderStoreModel modelWithArray:dicts[@"data"]];
                if (tempArr.count !=0 ) {
                    
                    for (int i = 0; i < tempArr.count; i ++) {
                        
                        [self.allGoodsDataListArray addObject:tempArr[i]];
                    }
                    page ++;
                    [allGoodsListTableView reloadData];
                }else{
                    
                    [self showHint:dicts[@"message"]];
                }
   
            }else{
                
                [self showHint:dicts[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
            NSLog(@"请求失败%@",error);
            [allGoodsListTableView.mj_footer endRefreshing];
            [self.view hideActivity];
            
        }];
        
    }else if (_segmentControl.selectedSegmentIndex == 1){
        
        int i = 0;
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:uId],@"uId",[NSNumber numberWithInt:page],@"pageNo",
                               @"8",@"pageSize",[NSNumber numberWithInt:i],@"status",
                               nil];
        [self.view showActivity];
        
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/selectrOrderStatus.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            [allDoneGoodsListTableView.mj_footer endRefreshing];
            NSMutableArray * tempArr = [NSMutableArray array];
            if ([dicts[@"success"] boolValue] == YES) {
                
                tempArr = [HKXOrderStoreModel modelWithArray:dicts[@"data"]];
                if (tempArr.count != 0) {
                    
                    for (int i = 0; i < tempArr.count; i ++) {
                        
                        [self.allDoneGoodsDataListArray addObject:tempArr[i]];
                    }
                    page ++;
                    [allDoneGoodsListTableView reloadData];
                }else{
                    
                     [self showHint:dicts[@"message"]];
                }
                
                
            }else{
                
                [self showHint:dicts[@"message"]];
            }
            
        } failure:^(NSError *error) {
            
            [allDoneGoodsListTableView.mj_footer endRefreshing];
            NSLog(@"请求失败%@",error);
            [self.view hideActivity];
            
        }];
    }else if (_segmentControl.selectedSegmentIndex == 2){
        
        int i = -1;
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:uId],@"uId",[NSNumber numberWithInt:page],@"pageNo",
                               @"8",@"pageSize",[NSNumber numberWithInt:i],@"status",
                               nil];
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/selectrOrderStatus.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            [allCanceledGoodsTableView.mj_footer endRefreshing];
            NSMutableArray * tempArr = [NSMutableArray array];
            if ([dicts[@"success"] boolValue] == YES) {
                
                
                tempArr = [HKXOrderStoreModel modelWithArray:dicts[@"data"]];
                if (tempArr.count != 0) {
                    
                    for (int i = 0; i < tempArr.count; i ++) {
                        
                        [self.allCanceledGoodsDataListArray addObject:tempArr[i]];
                    }
                    page ++;
                    [allDoneGoodsListTableView reloadData];
                }else{
                    
                    [self showHint:dicts[@"message"]];
                }

            }else{
                
                [self showHint:dicts[@"message"]];
            }
            
        } failure:^(NSError *error) {

            [allCanceledGoodsTableView.mj_footer endRefreshing];
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
    if (sc.selectedSegmentIndex == 0) {
        
        [allGoodsListTableView.mj_header beginRefreshing];
    }else if (sc.selectedSegmentIndex == 1) {
        
        [allDoneGoodsListTableView.mj_header beginRefreshing];
        
    }else if (sc.selectedSegmentIndex == 2) {

        [allCanceledGoodsTableView.mj_header beginRefreshing];
       
    }
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
    
    if (tableView == allGoodsListTableView)
    {
        
        return self.allGoodsDataListArray.count;
    }
    else if (tableView == allDoneGoodsListTableView)
    {
        return self.allDoneGoodsDataListArray.count;
    }
    else if(tableView == allCanceledGoodsTableView)
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
    HKXOrderStoreModel * store = self.allGoodsDataListArray[section];
    return store.goodsArr.count;
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
    
    HKXOrderStoreModel * store;
    if (tableView == allGoodsListTableView) {
        
        store= self.allGoodsDataListArray[section];
        
    }else if (tableView == allDoneGoodsListTableView){
        
        store = self.allDoneGoodsDataListArray[section];
        
    }else{
        
        store = self.allCanceledGoodsDataListArray[section];
    }
    HKXSaleListHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HKXHeaderId];
    header.store = store;
   
    return header;

}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    HKXOrderStoreModel * store;
    if (tableView == allGoodsListTableView) {
        
        store= self.allGoodsDataListArray[section];
        
    }else if (tableView == allDoneGoodsListTableView){
        
        store = self.allDoneGoodsDataListArray[section];
        
    }else{
        
        store = self.allCanceledGoodsDataListArray[section];
    }
    
  
    HKXSaleListFooterView *footer = [tableView dequeueReusableHeaderFooterViewWithIdentifier:HKXFooterId];
    footer.tag = section;
    footer.delegate = self;
    footer.store = store;
    return footer;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return 85 * myDelegate.autoSizeScaleY;
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
    
    HKXOrderStoreModel * store;
    if (tableView == allGoodsListTableView) {
        
        store= self.allGoodsDataListArray[indexPath.section];
        
    }else if (tableView == allDoneGoodsListTableView){
        
        store = self.allDoneGoodsDataListArray[indexPath.section];
        
    }else{
        
        store = self.allCanceledGoodsDataListArray[indexPath.section];
    }
    
    store = self.allGoodsDataListArray[indexPath.section];
    HKXOrderGoodsModel * goods = store.goodsArr[indexPath.row];
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
    [goodsImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kIMAGEURL,goods.goodPicture]] placeholderImage:[UIImage imageNamed:@"滑动视图示例"]];
    [CommonMethod scanBigImageWithImageView:goodsImg];
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
    
    UIView * footer = actionBtn.superview;
    HKXOrderStoreModel * store = self.allGoodsDataListArray[footer.tag];
    if ([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"-1"]) {
        
        [self delaeteOrderWithOrderId:[NSString stringWithFormat:@"%@",store.orderId]];
        
    }else if([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"0"]) {
        
        NSLog(@"完成");

    }else if([[NSString stringWithFormat:@"%@",store.orderStatus] isEqualToString:@"10"]) {

        if (actionBtn.tag > 999) {
            
        [self cancelOrderWithOrderId:[NSString stringWithFormat:@"%@",store.orderId]];
            
        }else{
        
        [self confirmDispatchGoodsWithOrderId:[NSString stringWithFormat:@"%@",store.orderId]];
            
        }
        
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
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认取消订单?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:[orderId doubleValue]],@"orderId",
                               nil];
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/sellerCallOrder.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            if ([dicts[@"success"] boolValue] == YES) {
                
                [self showHint:dicts[@"message"]];
                if (_segmentControl.selectedSegmentIndex == 0) {
                    
                    [allGoodsListTableView.mj_header beginRefreshing];
                }else if (_segmentControl.selectedSegmentIndex == 1){
                    
                    [allDoneGoodsListTableView.mj_header beginRefreshing];
                }else if (_segmentControl.selectedSegmentIndex == 2){
                    
                    [allCanceledGoodsTableView.mj_header beginRefreshing];
                }
                
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
    
    
}

- (void)confirmDispatchGoodsWithOrderId:(NSString *)orderId{
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认发货?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:[orderId doubleValue]],@"orderId",
                               nil];
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/deliverGood.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            if ([dicts[@"success"] boolValue] == YES) {
                
                [self showHint:dicts[@"message"]];
                
                if (_segmentControl.selectedSegmentIndex == 0) {
                    
                    [allGoodsListTableView.mj_header beginRefreshing];
                }else if (_segmentControl.selectedSegmentIndex == 1){
                    
                    [allDoneGoodsListTableView.mj_header beginRefreshing];
                }else if (_segmentControl.selectedSegmentIndex == 2){
                    
                    [allCanceledGoodsTableView.mj_header beginRefreshing];
                }
                
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
 
}

- (void)delaeteOrderWithOrderId:(NSString *)orderId{
    
    
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除订单?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:[orderId doubleValue]],@"orderId",
                               nil];
        [self.view showActivity];
        [IWHttpTool getWithUrl:[NSString stringWithFormat:@"%@%@",kBASICURL,@"userOrder/sellerDelOrder.do"] params:dict success:^(id responseObject) {
            
            NSDictionary *dicts =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"请求成功%@",dicts);
            [self.view hideActivity];
            if ([dicts[@"success"] boolValue] == YES) {
                
                [self showHint:dicts[@"message"]];
                if (_segmentControl.selectedSegmentIndex == 0) {
                    
                    [allGoodsListTableView.mj_header beginRefreshing];
                }else if (_segmentControl.selectedSegmentIndex == 1){
                    
                    [allDoneGoodsListTableView.mj_header beginRefreshing];
                }else if (_segmentControl.selectedSegmentIndex == 2){
                    
                    [allCanceledGoodsTableView.mj_header beginRefreshing];
                }
                
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
