//
//  HKXMineShoppingCartViewController.m
//  HuiKuaiXiuPro
//
//  Created by 李金灿 on 2017/8/24.
//  Copyright © 2017年 Lee. All rights reserved.
//

#import "HKXMineShoppingCartViewController.h"
#import "CommonMethod.h"

#import "HKXMineShoppingGoodsDetailViewController.h"//订单详情界面

#import "HKXHttpRequestManager.h"
#import "HKXMineShoppingCartListModelDataModels.h"//购物车列表
#import "HKXMineShoppingCartUpdateCartNumberModelDataModels.h"//更新购物车商品数量

#import "UIImageView+WebCache.h"

#import "HKXCsutomShoppingCartCollectionReusableView.h"
#import "HKXCustomShoppingCartCollectionViewCell.h"

#import "CustomAlertView.h"

#import "HKXMineServeCertificateProfileModel.h"//删除商品结果

@interface HKXMineShoppingCartViewController ()<UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,HKXMineCustomShoppingCartCollectionViewCellDelegate , HKXCsutomShoppingCartCollectionReusableViewDelegate>
{
    UICollectionView * _shoppingCartCollectionView;//购物车
    UIView           * _totalPriceView;//总价view
}

@property (nonatomic , strong) NSMutableArray * shopArray;//所有商铺数组
@property (nonatomic , strong) NSMutableArray * selectGoodsArray;//所有选中商品数组

@property (nonatomic , assign)BOOL isSelectedAll;//是否全选

@end

@implementation HKXMineShoppingCartViewController

#pragma mark - LifeCycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self createUI];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.selectGoodsArray removeAllObjects];
    [self configData];
    [self createUI];
}
#pragma mark - CreateUI
- (void)createUI
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout * flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    _shoppingCartCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64 , ScreenWidth, ScreenHeight  - 50 * myDelegate.autoSizeScaleY - 64) collectionViewLayout:flowLayOut];
    _shoppingCartCollectionView.backgroundColor = [UIColor whiteColor];
    _shoppingCartCollectionView.delegate = self;
    _shoppingCartCollectionView.dataSource = self;
    _shoppingCartCollectionView.contentInset = UIEdgeInsetsMake(7 * myDelegate.autoSizeScaleY, 0, 0, 0);
    [self.view addSubview:_shoppingCartCollectionView];
    
    [_shoppingCartCollectionView registerClass:[HKXCustomShoppingCartCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [_shoppingCartCollectionView registerClass:[HKXCsutomShoppingCartCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    _totalPriceView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_shoppingCartCollectionView.frame) + 1 * myDelegate.autoSizeScaleY, ScreenWidth, 49 * myDelegate.autoSizeScaleY)];
    _totalPriceView.layer.borderColor = [UIColor colorWithRed:235 / 255.0 green:235 / 255.0 blue:235 / 255.0 alpha:1].CGColor;
    _totalPriceView.layer.borderWidth = 1;
    _totalPriceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_totalPriceView];
    
    UIButton * selectAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(10 * myDelegate.autoSizeScaleX, 19 * myDelegate.autoSizeScaleY, 12 * myDelegate.autoSizeScaleX, 12 * myDelegate.autoSizeScaleX)];
    selectAllBtn.tag = 40000;
    [selectAllBtn addTarget:self action:@selector(selectAllGoodsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectAllBtn setImage:[UIImage imageNamed:@"复选框-未选中"] forState:UIControlStateNormal];
    [selectAllBtn setImage:[UIImage imageNamed:@"复选框_已选择"] forState:UIControlStateSelected];
    selectAllBtn.selected = NO;
    [_totalPriceView addSubview:selectAllBtn];
    
    UILabel * allSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(selectAllBtn.frame) + 10 * myDelegate.autoSizeScaleX, 19 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"全选" WithFont:14 * myDelegate.autoSizeScaleX], 14 * myDelegate.autoSizeScaleX)];
    allSelectLabel.text = @"全选";
    allSelectLabel.font = [UIFont systemFontOfSize:14 * myDelegate.autoSizeScaleX];
    allSelectLabel.textColor = [CommonMethod getUsualColorWithString:@"#333333"];
    [_totalPriceView addSubview:allSelectLabel];
    
    NSString * totalPrice = [NSString stringWithFormat:@"合计：¥0.00"];
    UILabel * totalPriceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(allSelectLabel.frame) + 80 * myDelegate.autoSizeScaleX, 8 * myDelegate.autoSizeScaleY, 140 * myDelegate.autoSizeScaleX, 15 * myDelegate.autoSizeScaleX)];
    totalPriceLabel.textColor = [CommonMethod getUsualColorWithString:@"#333333"];
    totalPriceLabel.text = totalPrice;
    totalPriceLabel.tag = 40001;
    totalPriceLabel.font = [UIFont systemFontOfSize:15 * myDelegate.autoSizeScaleX];
    [_totalPriceView addSubview:totalPriceLabel];
    
    UILabel * transportFeiLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(allSelectLabel.frame) + 80 * myDelegate.autoSizeScaleX, CGRectGetMaxY(totalPriceLabel.frame) + 9 * myDelegate.autoSizeScaleY, [CommonMethod getLabelLengthWithString:@"不含运费" WithFont:13 * myDelegate.autoSizeScaleX], 13 * myDelegate.autoSizeScaleX)];
    transportFeiLabel.text = @"不含运费";
    transportFeiLabel.font = [UIFont systemFontOfSize:13 * myDelegate.autoSizeScaleX];
    transportFeiLabel.textColor = [CommonMethod getUsualColorWithString:@"#666666"];
    [_totalPriceView addSubview:transportFeiLabel];
    
    UIButton * submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(280 * myDelegate.autoSizeScaleX, 0, ScreenWidth - 280 * myDelegate.autoSizeScaleX, 50 * myDelegate.autoSizeScaleY);
    submitBtn.backgroundColor = [CommonMethod getUsualColorWithString:@"#ffa304"];
    [submitBtn setTitle:@"结算" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_totalPriceView addSubview:submitBtn];
}
#pragma mark - ConfigData
- (void)configData
{
    long userId = [[NSUserDefaults standardUserDefaults] doubleForKey:@"userDataId"];
    [HKXHttpRequestManager sendRequestWithUserId:[NSString stringWithFormat:@"%ld",userId] ToGetAllMineShoppingCartListResult:^(id data) {
        HKXMineShoppingCartListModel * model = data;
        if (model.success)
        {
            [self.shopArray removeAllObjects];
            for (HKXMineShoppingCartListData * shopModel in model.data)
            {
                [self.shopArray addObject:shopModel];
            }
            [_shoppingCartCollectionView reloadData];
        }
        else
        {
            [self showHint:model.message];
        }
    }];
    
}
#pragma mark - Action

/**
 结算选中商品

 @param btn 结算按钮
 */
- (void)submitBtnClick:(UIButton *)btn
{
    double totalPrice = 0;
    for (HKXMineShoppingCartListShopcartList * goodsModel in self.selectGoodsArray)
    {
        totalPrice = totalPrice + goodsModel.totalprice;
    }
    if (totalPrice == 0)
    {
        [self showHint:@"您未选中任何商品"];
    }
    else
    {
        HKXMineShoppingGoodsDetailViewController * detailVC = [[HKXMineShoppingGoodsDetailViewController alloc] init];
        detailVC.navigationItem.title = @"确认订单";
        detailVC.totalCount = [NSString stringWithFormat:@"%.2f",totalPrice];
        detailVC.selectGoodsArray = self.selectGoodsArray;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}
/**
 点击全选按钮选中购物车中所有商品

 @param btn 全选按钮
 */
- (void)selectAllGoodsBtnClick:(UIButton *)btn
{
    NSLog(@"选中所有商品");
    
//    全选之前清空数据
    [self.selectGoodsArray removeAllObjects];
    if (btn.selected == YES)
    {
        btn.selected = NO;
        self.isSelectedAll = NO;
        for (HKXMineShoppingCartListData * shopData in self.shopArray)
        {
            shopData.isSelected = NO;
            for (HKXMineShoppingCartListShopcartList * goodsModel in shopData.shopcartList)
            {
                goodsModel.isSelected = NO;
            }
        }
    }
    else
    {
        btn.selected = YES;
        self.isSelectedAll = YES;
        for (HKXMineShoppingCartListData * shopData in self.shopArray)
        {
            shopData.isSelected = YES;
            for (HKXMineShoppingCartListShopcartList * goodsModel in shopData.shopcartList)
            {
                goodsModel.isSelected = YES;
                [self.selectGoodsArray addObject:goodsModel];
            }
        }
    }
    [self getTotalPrice];
    [_shoppingCartCollectionView reloadData];
}

#pragma mark - Private Method
- (void)dismissClick
{
    CustomAlertView * alert = [self.view viewWithTag:688];
    [alert removeFromSuperview];
}
- (void)checkShopState
{
    NSInteger totalSelect = 0;
    for (HKXMineShoppingCartListData * shopData in self.shopArray)
    {
        if (shopData.isSelected == YES)
        {
            totalSelect ++;
        }
    }
    if (totalSelect == self.shopArray.count)
    {
        self.isSelectedAll = YES;
        UIButton * selectAllBtn = [_totalPriceView viewWithTag:40000];
        selectAllBtn.selected = YES;
    }
    else
    {
        self.isSelectedAll = NO;
    }
    [self getTotalPrice];
    
}
/**
 求总金额
 */
- (void)getTotalPrice
{
    double totalPrice = 0;
    for (HKXMineShoppingCartListShopcartList * goodsModel in self.selectGoodsArray)
    {
        totalPrice = totalPrice + goodsModel.totalprice;
    }
    NSLog(@"---%.2f",totalPrice);
    UILabel * totalPriceLabel = [_totalPriceView viewWithTag:40001];
    totalPriceLabel.text = [NSString stringWithFormat:@"合计：¥%.2f",totalPrice];
}
#pragma mark - Delegate & Data Source

/**
 改变购物车数量

 @param cell 商品所在cell
 @param count 商品的数量
 */
- (void)changeTheGoodsCount:(HKXCustomShoppingCartCollectionViewCell *)cell Count:(NSInteger)count
{
    NSLog(@"****%ld",count);
    [HKXHttpRequestManager sendRequestWithCartId:[NSString stringWithFormat:@"%ld",(long)cell.goodsModel.carid] WithBuyNumber:[NSString stringWithFormat:@"%ld",count] ToGetUpdateShoppingCartNumberResult:^(id data) {
        HKXMineShoppingCartUpdateCartNumberModel * model = data;
        if (model.success)
        {
            cell.goodsModel.totalprice = cell.goodsModel.price * count;
            cell.goodsModel.buynumber = (int)count;
            [_shoppingCartCollectionView reloadData];
            [self getTotalPrice];
        }
        else
        {
            [self showHint:model.message];
        }
    }];
}

/**
 选中某个商品

 @param cell 商品在的cell
 */
- (void)clickWhichLeftBtn:(HKXCustomShoppingCartCollectionViewCell *)cell
{
    HKXMineShoppingCartListShopcartList * goodsModel = cell.goodsModel;
    if (goodsModel.isSelected == YES)
    {
        goodsModel.isSelected = NO;
        [self.selectGoodsArray removeObject:goodsModel];
        HKXMineShoppingCartListData * shopData = self.shopArray[cell.tag - 90000];
        shopData.isSelected = NO;
    }
    else
    {
        goodsModel.isSelected = YES;
        [self.selectGoodsArray addObject:goodsModel];
        
        HKXMineShoppingCartListData * shopData = self.shopArray[cell.tag - 90000];
        for (HKXMineShoppingCartListShopcartList * goodsModel in shopData.shopcartList)
        {
            if (goodsModel.isSelected == NO)
            {
                shopData.isSelected = NO;
            }
            else
            {
                shopData.isSelected = YES;
            }
        }
    }
    [self checkShopState];
    [self getTotalPrice];
    [_shoppingCartCollectionView reloadData];
}

/**
 选中某个商铺的商品

 @param index 商铺的index
 */
- (void)clickedWhichHeaderView:(NSInteger)index
{
    NSLog(@"----%ld",index);
    HKXMineShoppingCartListData * shopData = self.shopArray[index - 80000];
    if (shopData.isSelected)
    {
        shopData.isSelected = NO;
        for (HKXMineShoppingCartListShopcartList * goodsModel in shopData.shopcartList)
        {
            goodsModel.isSelected = NO;
            [self.selectGoodsArray removeObject:goodsModel];
        }
    }
    else
    {
        shopData.isSelected = YES;
        for (HKXMineShoppingCartListShopcartList * goodsModel in shopData.shopcartList)
        {
            if (goodsModel.isSelected == NO)
            {
                goodsModel.isSelected = YES;
                [self.selectGoodsArray addObject:goodsModel];
            }
        }
    }
    [self checkShopState];
    [self getTotalPrice];
    [_shoppingCartCollectionView reloadData];
}

/**
 长按cell一秒以上出现删除该商品的提示框

 @param cell 要删除的商品
 */
- (void)longPressToDeleteThisGoods:(HKXCustomShoppingCartCollectionViewCell *)cell
{
     AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CustomAlertView * alert = [CustomAlertView alertViewWithTitle:@"提示" content:@"确定删除该商品？" cancel:@"取消" sure:@"确定" cancelBtnClick:^{
        [self dismissClick];
    } sureBtnClick:^{
        NSLog(@"调用删除单件商品请求");
        [self dismissClick];
        [HKXHttpRequestManager sendRequestWithGoodsId:[NSString stringWithFormat:@"%ld",(long)cell.goodsModel.carid] ToGetMineDeleteCartGoodsResult:^(id data) {
            HKXMineServeCertificateProfileModel * model = data;
            [self showHint:model.message];
            if (model.success)
            {
                [self configData];
            }
        }];
        
    } WithAlertHeight:210 * myDelegate.autoSizeScaleY];
    alert.tag = 688;
    [self.view addSubview:alert];
}
#pragma mark UICollectionViewDelegateFlowLayout
//设置每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return CGSizeMake(ScreenWidth, 125 * myDelegate.autoSizeScaleY);
}
//设置整个区的UIEdgeInsets
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//设置每一行之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.1;
}
//设置没一列的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.1;
}
//设置区头大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return CGSizeMake(ScreenWidth, 30 * myDelegate.autoSizeScaleY);
}
#pragma mark UICollectionViewDataSource
//返回collectionView的区个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.shopArray.count;
}
//返回collectionView的item的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    HKXMineShoppingCartListData * shopData = self.shopArray[section];
    
    return shopData.shopcartList.count;
}
//设置区头（区脚）
- (UICollectionReusableView* )collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
//    AppDelegate * myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        //在这设置区头
        HKXCsutomShoppingCartCollectionReusableView * headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];

        HKXMineShoppingCartListData * headerModel = self.shopArray[indexPath.section];

        headerView.delegate = self;
        headerView.tag = 80000 + indexPath.section;
        [headerView loadDataWithShopData:headerModel];

        return headerView;
    }else if([kind isEqualToString:UICollectionElementKindSectionFooter])
    {
        //在这设置区脚
        return nil;
    }else
    {
        return nil;
    }
}

//设置每个item的内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier = @"cell";

    HKXCustomShoppingCartCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    cell.tag = indexPath.section + 90000;
    HKXMineShoppingCartListData * shopModel = self.shopArray[indexPath.section];
    HKXMineShoppingCartListShopcartList * goodsModel = shopModel.shopcartList[indexPath.row];
    
    [cell loadDataWithShopModel:goodsModel];
    

    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld区 %ld个",indexPath.section,indexPath.row);
}
#pragma mark - Setters & Getters

- (NSMutableArray *)shopArray
{
    if (!_shopArray)
    {
        _shopArray = [NSMutableArray array];
    }
    return _shopArray;
}
- (NSMutableArray *)selectGoodsArray
{
    if (!_selectGoodsArray)
    {
        _selectGoodsArray = [NSMutableArray array];
    }
    return _selectGoodsArray;
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
