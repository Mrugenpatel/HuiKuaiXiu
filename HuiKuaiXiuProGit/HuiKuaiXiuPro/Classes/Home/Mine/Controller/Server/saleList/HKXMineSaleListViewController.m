//
//  HKXMineSaleListViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/25.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineSaleListViewController.h"
#import "CommonMethod.h"

@interface HKXMineSaleListViewController ()<UIScrollViewDelegate , UITableViewDelegate , UITableViewDataSource>
{
    UISegmentedControl * _segmentControl;//分段控制
    UIScrollView       * _bottomScrollView;//底层大的滑动视图
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
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configData];
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
        UITableView * goodsListTableView = [[UITableView alloc] initWithFrame:CGRectMake(_bottomScrollView.frame.size.width * i, 0, _bottomScrollView.frame.size.width, _bottomScrollView.frame.size.height) style:UITableViewStylePlain];
        goodsListTableView.dataSource = self;
        goodsListTableView.delegate = self;
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
    }
}
#pragma mark - ConfigData
- (void)configData
{
    self.allGoodsDataListArray = [NSMutableArray arrayWithObjects:@"待收款",@"待确认收货",@"完成",@"取消",@"完成",@"确认发货",@"待确认收货",@"取消",@"取消",@"完成",@"取消",@"完成",@"完成", nil];
    for (NSString * str in self.allGoodsDataListArray)
    {
        if ([str isEqualToString:@"完成"])
        {
            [self.allDoneGoodsDataListArray addObject:str];
        }
        if ([str isEqualToString:@"取消"])
        {
            [self.allCanceledGoodsDataListArray addObject:str];
        }
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
    return 1;
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
    if (tableView == self.tableViewListArray[0])
    {
        return self.allGoodsDataListArray.count;
    }
    else if (tableView == self.tableViewListArray[1])
    {
        return self.allDoneGoodsDataListArray.count;
    }
    else
    {
        return self.allCanceledGoodsDataListArray.count;
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
    return 260 * myDelegate.autoSizeScaleY;
}
/**
 *  区头高度
 *
 *  @param tableView tableView
 *  @param section   section
 *
 *  @return 区头高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
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
    return 0.1;
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
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    防重用
    UIView * reClientInfoView = [cell viewWithTag:9000];
    [reClientInfoView removeFromSuperview];
    
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
    
//    客户信息
    UIView * clientInfoView = [[UIView alloc] initWithFrame:CGRectMake(16 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, 351 * myDelegate.autoSizeScaleX, 75 * myDelegate.autoSizeScaleY)];
    clientInfoView.tag = 9000;
    clientInfoView.layer.borderWidth = 0.5;
    clientInfoView.layer.borderColor = [CommonMethod getUsualColorWithString:@"#ffa302"].CGColor;
    clientInfoView.backgroundColor = [UIColor whiteColor];
    [cell addSubview:clientInfoView];
    
    UILabel * orderNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(8 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY, 335 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX)];
    orderNumLabel.text = @"订单编号：12345678";
    orderNumLabel.font = [UIFont systemFontOfSize:12 * myDelegate.autoSizeScaleX];
    [clientInfoView addSubview:orderNumLabel];
    
    UILabel * clientNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(8 * myDelegate.autoSizeScaleX, CGRectGetMaxY(orderNumLabel.frame) + 9 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"姓名：郭得友" WithFont:12 * myDelegate.autoSizeScaleX], 12 * myDelegate.autoSizeScaleX)];
    clientNameLabel.text = @"姓名：郭得友";
    clientNameLabel.font = [UIFont systemFontOfSize:12 * myDelegate.autoSizeScaleX];
    [clientInfoView addSubview:clientNameLabel];
    
    UILabel * clientPhoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(clientNameLabel.frame) + 66 * myDelegate.autoSizeScaleX, CGRectGetMaxY(orderNumLabel.frame) + 9 * myDelegate.autoSizeScaleY, 150 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX)];
    clientPhoneLabel.text = @"电话：12345678945";
    clientPhoneLabel.font = [UIFont systemFontOfSize:12 * myDelegate.autoSizeScaleX];
    [clientInfoView addSubview:clientPhoneLabel];
    
    UILabel * clientAddressLabel = [[UILabel alloc] initWithFrame:CGRectMake(8 * myDelegate.autoSizeScaleX, CGRectGetMaxY(clientNameLabel.frame) + 9 * myDelegate.autoSizeScaleY, 335 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX)];
    clientAddressLabel.text = @"北京市海淀区大钟寺12号";
    clientAddressLabel.font = [UIFont systemFontOfSize:12 * myDelegate.autoSizeScaleX];
    [clientInfoView addSubview:clientAddressLabel];
//    商品信息
    
    UIImageView * goodsImg = [[UIImageView alloc] initWithFrame:CGRectMake(16 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY + CGRectGetMaxY(clientInfoView.frame), 102 * myDelegate.autoSizeScaleX, 95 * myDelegate.autoSizeScaleY)];
    goodsImg.tag = 90001;
    goodsImg.image = [UIImage imageNamed:@"滑动视图示例"];
    [cell addSubview:goodsImg];
    
    UILabel * goodsNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 15 * myDelegate.autoSizeScaleX, 10 * myDelegate.autoSizeScaleY + CGRectGetMaxY(clientInfoView.frame), [CommonMethod getLabelLengthWithString:@"慧快修 工程机械专用液压油" WithFont:13 * myDelegate.autoSizeScaleX ], 13 * myDelegate.autoSizeScaleX)];
    goodsNameLabel.tag = 90002;
    goodsNameLabel.text = @"慧快修 工程机械专用液压油";
    goodsNameLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsNameLabel];
    
    UILabel * goodsTypeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 15 * myDelegate.autoSizeScaleX, CGRectGetMaxY(goodsNameLabel.frame) + 12 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"产品品牌：壳牌" WithFont:13 * myDelegate.autoSizeScaleX ], 13 * myDelegate.autoSizeScaleX)];
    goodsTypeLabel.tag = 90003;
    goodsTypeLabel.text = @"产品品牌：壳牌";
    goodsTypeLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsTypeLabel];
    
    UILabel * goodsModelLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 15 * myDelegate.autoSizeScaleX, CGRectGetMaxY(goodsTypeLabel.frame) + 10 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"产品型号：XG806F" WithFont:13 * myDelegate.autoSizeScaleX ], 13 * myDelegate.autoSizeScaleX )];
    goodsModelLabel.tag = 90010;
    goodsModelLabel.text = @"产品型号：XG806F";
    goodsModelLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsModelLabel];
    
    UILabel * priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 112 * myDelegate.autoSizeScaleX, CGRectGetMaxY(goodsModelLabel.frame) + 10 * myDelegate.autoSizeScaleY, 65 * myDelegate.autoSizeScaleX, 13 * myDelegate.autoSizeScaleX)];
    priceLabel.tag = 90004;
    priceLabel.textColor = [UIColor redColor];
    priceLabel.text = [NSString stringWithFormat:@"¥%.2f",1200.00];
    priceLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
    [cell addSubview:priceLabel];
    
    UILabel * goodsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(goodsImg.frame) + 15 * myDelegate.autoSizeScaleX,  CGRectGetMaxY(goodsModelLabel.frame) + 10 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"X 2" WithFont:13 * myDelegate.autoSizeScaleX], 13 * myDelegate.autoSizeScaleX)];
    goodsNumLabel.tag = 90005;
    goodsNumLabel.text = @"X 2";
    goodsNumLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
    [cell addSubview:goodsNumLabel];
    
    UIButton * editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.tag = 90006;
    editBtn.frame = CGRectMake(CGRectGetMaxX(goodsImg.frame) + 184 * myDelegate.autoSizeScaleX,CGRectGetMaxY(clientInfoView.frame) + 75 * myDelegate.autoSizeScaleY, 65 * myDelegate.autoSizeScaleX, 30 * myDelegate.autoSizeScaleY);
    editBtn.layer.cornerRadius = 2;
    editBtn.clipsToBounds = YES;
    [editBtn addTarget:self action:@selector(editGoodsPriceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [editBtn setTitle:@"价格修改" forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:12 * myDelegate.autoSizeScaleX];
    editBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa302"];
    editBtn.hidden = YES;
    if ((tableView == self.tableViewListArray[0]) && ([self.allGoodsDataListArray[indexPath.row] isEqualToString:@"确认发货"]))
    {
        editBtn.hidden = NO;
    }
    [cell addSubview:editBtn];
    
    for (int i = 0; i < 2; i ++)
    {
        UIButton * actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        actionBtn.frame = CGRectMake(22 * myDelegate.autoSizeScaleX + (180 * i) * myDelegate.autoSizeScaleX, CGRectGetMaxY(goodsImg.frame) + 21 * myDelegate.autoSizeScaleY, 150 * myDelegate.autoSizeScaleX, 44 * myDelegate.autoSizeScaleY);
        actionBtn.layer.cornerRadius = 2;
        actionBtn.clipsToBounds = YES;
        actionBtn.tag = 90007 + i;
        if (i == 0)
        {
            [actionBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            actionBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#d59423"];
            actionBtn.hidden = YES;
            if ((tableView == self.tableViewListArray[0]) && ([self.allGoodsDataListArray[indexPath.row] isEqualToString:@"确认发货"]))
            {
                actionBtn.hidden = NO;
            }
        }
        else
        {
            NSString * actionTitle ;
            if (tableView == self.tableViewListArray[0])
            {
                actionTitle = self.allGoodsDataListArray[indexPath.row];
            }
            else if (tableView == self.tableViewListArray[1])
            {
                actionTitle = @"完成";
            }
            else
            {
                actionTitle = @"订单删除";
            }
            [actionBtn setTitle:actionTitle forState:UIControlStateNormal];
            [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            actionBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa302"];
            
        }
        
        [cell addSubview:actionBtn];
    }
    
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
